/**
*
* @file  RaygunLogger.cfc
* @author  John McCoy
* @description This is the cfc that the eventHandler.cfc uses onGlobalError
*
*/

component output="false" displayname="RaygunLogger"  {

	public function init(){
		return this;
	}

	public function rayGunLog(
			required string creditCardFilter,
			required string errorEmail,
			required any exception,
			required string passwordFilter,
			required string fromEmail,
			required string raygunAPIKey,
			required string sessionid,
					 string siteID,
					 string firstName,
					 string lastName,
					 string email
		) {
		local.error = arguments.exception;
		local.error = {
			message = arguments.siteID & ': ' & (structKeyExists(local.error,"message") ? local.error.message : "_noMessage"),
			stackTrace = structKeyExists(local.error,"statckTrace") ? local.error.stackTrace : "_noStackTrace",
			type = structKeyExists(local.error,"type") ? local.error.type : "_noType",
			tagcontext = structKeyExists(local.error,"tagcontext") ? local.error.tagcontext : []
		};

		// replace all occurrences of filter with replacement in raygun4cfml and flattenStruct()
		local.filter = [
			{filter = "#arguments.creditCardFilter#", replacement = "__cc__"},
			{filter = "#arguments.passwordFilter#", replacement = "__password__"}
		];

		local.contentFilter = createObject("component","RaygunContentFilter").init(filter);

		// only flattened structs will display correctly in RayGun.io
		local.sessionData = flattenStruct(original=duplicate(session), filter=filter);

		// these custom values will display in the Params Values section
		local.paramsData = {
			"session" = {
				"sessionID"= arguments.sessionID,
				"memberFirstname" = arguments.firstName,
				"memberLastname" = arguments.lastName,
				"memberEmail" = arguments.email
			},
			"params" = {
				"applicationname" = application.applicationname,
				"domainname" = cgi.http_host,
				"serverName" = CreateObject("java", "java.net.InetAddress").getLocalHost().getHostName()
			}
		};

		// Raygun.io reporting
		local.customRequestData = createObject("component", "RaygunUserCustomData").init(local.paramsData);

		// Setup user tracking
		local.identifier=len(arguments.email) GT 0 ? arguments.email:arguments.sessionID;
		local.isAnonymous=len(arguments.email) GT 0 ? false:true;
		local.UUID=arguments.sessionID;
		local.email=arguments.email;
		local.firstName=arguments.firstName;
		local.fullName=arguments.firstName & ' ' & arguments.lastName;

		local.userIdentifier = createObject("component", "RaygunIdentifierMessage").init(
			Identifier=local.identifier,
			isAnonymous=local.isAnonymous,
			UUID=local.UUID,
			email=local.email,
			FirstName=local.firstName,
			Fullname=local.fullName
		);

		local.raygun = createObject("component","RaygunClient").init(
			apiKey = arguments.raygunAPIKey,
			contentFilter = local.contentFilter
		);

		try {
		 local.raygun.send(issueDataStruct=local.error,userCustomData=local.customRequestData,user=local.userIdentifier);
		}
		catch(any e) {
			savecontent variable="mailBody"{
				writeoutput('<p>Error occurred while sending error to Raygun API.<br/>The output from the failed Raygun request is below:: <p>');
				writedump(local.paramsData);
				writedump(arguments.exception);
				writeOutput("</p><p>Ray Gun Error</p>");
				writedump(e);
				writeoutput("</p> </p>");
			}
			mailerService = new mail();
			mailerService.setTo(arguments.errorEmail);
			mailerService.setFrom(arguments.fromEmail);
			mailerService.setSubject("ERROR: Raygun API Error");
			mailerService.setType("html");
			mailerService.send(body=mailBody);
		}
	}

	/*
	 Builds nested structs into a single struct.
	 Updated v2 by author Simeon Cheeseman.

	 @param stObject      Structure to flatten. (Required)
	 @param delimiter      Value to use in new keys. Defaults to a period. (Optional)
	 @param prefix      Value placed in front of flattened keys. Defaults to nothing. (Optional)
	 @param stResult      Structure containing result. (Optional)
	 @param addPrefix      Boolean value that determines if prefix should be used. Defaults to true. (Optional)
	 @return Returns a structure.
	 @author Tom de Manincor (tomdeman@gmail.com)
	 @version 2, September 2, 2011
	*/
	private any function flattenStruct(required struct original,string delimiter=".",struct flattened=structNew(),string prefix_string="",array filter=arrayNew(1)) {
		local.names = structKeyArray(arguments.original);
		local.name = "";

		for(local.name in local.names) {
			if (isStruct(arguments.original[local.name])) {
				arguments.flattened = flattenStruct(arguments.original[local.name], arguments.delimiter, arguments.flattened, arguments.prefix_string & local.name & arguments.delimiter, arguments.filter);
			} else {
				arguments.flattened[arguments.prefix_string & local.name] = arguments.original[local.name];
			}
		}
		return arguments.flattened;
	}
}