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
</cfscript>
<style type="text/css">
	#bodyWrap h3{padding-top:1em;}
	#bodyWrap ul{padding:0 0.75em;margin:0 0.75em;}
</style>
<cfsavecontent variable="body"><cfoutput>
<div id="bodyWrap">
	<h1>#HTMLEditFormat(pluginConfig.getName())#</h1>
	<p>This allows for logging through raygun.io</p>

	<h3>pluginConfig</h3>
	Error Email: #pluginConfig.getSetting("errorEmail")#</br>
	From Email: #pluginConfig.getSetting("fromEmail")#</br>
	Raygun API Key: #pluginConfig.getSetting("raygunAPIKey")#<br/>
	Credit Card Filter: #pluginConfig.getSetting("creditCardFilter")#<br/>
	Password Filter: #pluginConfig.getSetting("passwordFilter")#
</div>
</cfoutput></cfsavecontent>
<cfoutput>
	#$.getBean('pluginManager').renderAdminTemplate(
		body = body
		, pageTitle = ''
		, jsLib = 'jquery'
		, jsLibLoaded = false
	)#
</cfoutput>