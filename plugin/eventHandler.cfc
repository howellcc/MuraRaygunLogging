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
		setting requesttimeout=createObject('java', 'coldfusion.runtime.RequestMonitor').getRequestTimeout() + 30;
		local.assignedSites = variables.getPluginManager().getAssignedSites(moduleID=variables.pluginConfig.getModuleID());
		local.pluginSettings = variables.pluginConfig.getSettings();

		// Because we are tapping into the Global Error we need to make sure we have the plugin assigned to this site
		if ( listFind(valuelist(local.assignedSites.siteID),(isStruct(arguments.$) AND structKeyExists(arguments.$,'event')? arguments.$.event('siteID'): '')) AND isStruct(local.pluginSettings) ) {
			lock name="#variables.settings.package#_onGlobalError" type="exclusive" timeout="10" {
				if( !StructKeyExists(application, variables.settings.package) ) {
					application[variables.settings.package] = new "#variables.settings.package#.raygun.RaygunLogger"();
				};
			};
			application[variables.settings.package].rayGunLog(
				creditCardFilter=local.pluginSettings.creditCardFilter,
				exception=arguments.$.event("exception"),
				errorEmail=local.pluginSettings.errorEmail,
				fromEmail=local.pluginSettings.fromEmail,
				passwordFilter=local.pluginSettings.passwordFilter,
				raygunAPIKey=local.pluginSettings.raygunAPIKey
			);
		}
	}

}