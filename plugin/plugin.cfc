/**
* 
* This file is part of MuraPlugin
*
* Copyright 2013-2014 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
component accessors=true extends='mura.plugin.plugincfc' output=false {

	// pluginConfig is automatically available as variables.pluginConfig
	include 'settings.cfm';

	public void function install() {
		application.appInitialized = false;
	}
	
	public void function update() {
		application.appInitialized = false;
	}

	public void function delete() {
		application.appInitialized = false;
	}

	// public void function toBundle(pluginConfig, bundle, siteid) output=false {
		// Do custom toBundle stuff
	// }

	// public void function fromBundle(bundle, keyFactory, siteid) output=false {
		// Do custom fromBundle stuff
	// }

	// access to the pluginConfig should available via variables.pluginConfig
	public any function getPluginConfig() {
		return StructKeyExists(variables, 'pluginConfig') ? variables.pluginConfig : {};
	}
}