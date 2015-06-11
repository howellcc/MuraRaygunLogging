#Mura Raygun Logger

This is a plugin utility that allows you to log Mura error into https://raygun.io/.

## NOTE: Code example to manually add logging to FW1 onError or other onError areas for more control.
//Manually populate the exception event with the exeption thrown to onError
	public any function onError(any exception, string event) output="true" {
		var errorMessage = structKeyExists(arguments.exception,"message") ? arguments.exception.message & (structKeyExists(arguments.exception,'RootCause') ? ': ' & arguments.exception.RootCause.message & ': ' & arguments.exception.RootCause.Detail:'') : '';
		//var scopes = 'application,arguments,cgi,client,cookie,form,local,request,server,session,url,variables';
		var scopes = 'local,request,session';
		var arrScopes = ListToArray(scopes);
		var i = '';
		var scope = '';
		if ( IsBoolean(variables.framework.debugMode) && variables.framework.debugMode ) {
			WriteOutput('<h2>' & variables.framework.package & ' ERROR</h2>');
			for ( i=1; i <= ArrayLen(arrScopes); i++ ) {
				scope = arrScopes[i];
				WriteDump(var=Evaluate(scope),label=UCase(scope));
			};
		} else {
			// Manually populate the exception event with the exeption thrown to onError
			if ( structKeyExists(arguments.exception,"cause") ) {
				request.context.$.getEvent().setValue(property='exception',propertyValue=arguments.exception.cause);
			} else {
				request.context.$.getEvent().setValue(property='exception',propertyValue=arguments.exception);
			}
			// Lets run announce the onGlobalError so that the raygun logger can log this!
			request.context.$.announceEvent('onGlobalError');
			redirect(action='admin:main.error',preserve='errors');
		}
	}


##Tested With
* Mura CMS Core Version 6.1+
* Adobe ColdFusion 11

##License
Copyright 2015 John McCoy

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this work except in compliance with the License. You may obtain a copy of the License in the LICENSE file, or at:

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

##Other projects used
* https://github.com/stevewithington/MuraPlugin
* https://github.com/MindscapeHQ/raygun4cfml
* http://www.cflib.org/udf/flattenStruct