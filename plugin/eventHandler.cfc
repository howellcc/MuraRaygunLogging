component extends='mura.plugin.pluginGenericEventHandler' {

	property name='$' hint='mura scope';

	include 'settings.cfm';

	public void function onApplicationLoad() {
		lock name="#variables.settings.package#_onApplicationLoad" type="exclusive" timeout="10" {
			if( StructKeyExists(application, variables.settings.package) ) {
				structDelete(application,variables.settings.package);
			};
		};
		variables.pluginConfig.addEventHandler(this);
	}

	public void function onSiteRequestStart() {
		lock name="#variables.settings.package#_onApplicationLoad" type="exclusive" timeout="10" {
			if( StructKeyExists(application, variables.settings.package) ) {
				structDelete(application,variables.settings.package);
			};
		};
	}

	public void function onGlobalError(any $) {
		raygunLogging(arguments.$);
	}

	private void function raygunLogging(any $) {
		setting requesttimeout=createObject('java', 'coldfusion.runtime.RequestMonitor').getRequestTimeout() + 30;
		local.assignedSites = variables.getPluginManager().getAssignedSites(moduleID=variables.pluginConfig.getModuleID());
		local.pluginSettings = variables.pluginConfig.getSettings();
		local.raygunLogger = new "#variables.settings.package#.raygun.RaygunLogger"();
		if ( listFind(valuelist(local.assignedSites.siteID),(isStruct(arguments.$) AND structKeyExists(arguments.$,'event')? arguments.$.event('siteID'): '')) GT 0 AND isStruct(local.pluginSettings) ) {
			local.raygunLogger.rayGunLog(
				creditCardFilter=local.pluginSettings.creditCardFilter,
				exception=arguments.$.event("exception"),
				errorEmail=local.pluginSettings.errorEmail,
				fromEmail=local.pluginSettings.fromEmail,
				passwordFilter=local.pluginSettings.passwordFilter,
				raygunAPIKey=local.pluginSettings.raygunAPIKey,
				sessionID=session.sessionID,
				siteID=arguments.$.event('siteID'),
				firstname=session.mura.fname,
				lastname=session.mura.lname,
				email=session.mura.email
			);
		}
	};
}