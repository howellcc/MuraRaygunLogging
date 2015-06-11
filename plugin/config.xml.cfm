<cfscript>
/**
* 
* This file is part of MuraPlugin
*
* Copyright 2013-2014 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
	include 'settings.cfm';
</cfscript>
<cfoutput>
	<plugin>
		<name>#variables.settings.pluginName#</name>
		<package>#variables.settings.package#</package>
		<directoryFormat>packageOnly</directoryFormat>
		<loadPriority>#variables.settings.loadPriority#</loadPriority>
		<version>#variables.settings.version#</version>
		<provider>#variables.settings.provider#</provider>
		<providerURL>#variables.settings.providerURL#</providerURL>
		<category>#variables.settings.category#</category>
		<autodeploy>false</autodeploy>
		<settings>
			<setting>
				<name>creditCardFilter</name>
				<label>This is the credit card field name to be filtered out of the logs if any are used.</label>
				<hint></hint>
				<type>text</type>
				<required>true</required>
				<validation></validation>
				<regex></regex>
				<message></message>
				<defaultvalue>#variables.settings.creditCardFilter#</defaultvalue>
				<optionlist></optionlist>
				<optionlabellist></optionlabellist>
			</setting>
			<setting>
				<name>errorEmail</name>
				<label>List of email addresses that any failure of the raygun api will be sent to.</label>
				<hint></hint>
				<type>text</type>
				<required>true</required>
				<validation></validation>
				<regex></regex>
				<message></message>
				<defaultvalue>#variables.settings.errorEmail#</defaultvalue>
				<optionlist></optionlist>
				<optionlabellist></optionlabellist>
			</setting>
			<setting>
				<name>fromEmail</name>
				<label>Email addresses that any failure of the raygun api will be sent from.</label>
				<hint></hint>
				<type>text</type>
				<required>true</required>
				<validation></validation>
				<regex></regex>
				<message></message>
				<defaultvalue>#variables.settings.fromEmail#</defaultvalue>
				<optionlist></optionlist>
				<optionlabellist></optionlabellist>
			</setting>
			<setting>
				<name>passwordFilter</name>
				<label>This is the password field name to be filtered out of the logs if any are used.</label>
				<hint></hint>
				<type>text</type>
				<required>true</required>
				<validation></validation>
				<regex></regex>
				<message></message>
				<defaultvalue>#variables.settings.passwordFilter#</defaultvalue>
				<optionlist></optionlist>
				<optionlabellist></optionlabellist>
			</setting>
			<setting>
				<name>raygunAPIKey</name>
				<label>raygun.io Application API key</label>
				<hint></hint>
				<type>text</type>
				<required>true</required>
				<validation></validation>
				<regex></regex>
				<message></message>
				<defaultvalue>#variables.settings.raygunAPIKey#</defaultvalue>
				<optionlist></optionlist>
				<optionlabellist></optionlabellist>
			</setting>
		</settings>
		<displayobjects></displayobjects>
		<eventHandlers>
			<eventHandler event="onApplicationLoad" component="plugin.eventHandler" persist="false" />
		</eventHandlers>
	</plugin>
</cfoutput>