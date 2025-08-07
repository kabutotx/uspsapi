/*
File: Tracking.cfc

Copyright © Robert Davis

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

/*
Tracking.cfc 0.9
Author: Robert Davis; kabutotx@gmail.com
*/

component displayName="Tracking" accessors="true" produces="json" hint="Get tracking status and delivery information for one USPS package." {
	property name="trackingNumber" type="string";
	property name="expand" type="string" default="SUMMARY";
	property name="uniqueTrackingId" type="string";
	property name="approximateIntakeDate" type="string";
	property name="notifyEventTypes" type="array";
	property name="firstName" type="string";
	property name="lastName" type="string";
	property name="notifications" type="array";

	public any function init(boolean developmentServer="false") {
		if ( arguments.developmentServer ) {
			baseUrl = "apis-tem.usps.com";
		} else {
			baseUrl = "apis.usps.com";
		}
		return this;
	}
	
	public struct function tracking(required string token) {
		var buildurl = "https://#variables.baseUrl#/tracking/v3/tracking/#variables.getTrackingNumber()#";
		cfhttp(method = "GET", charset = "utf-8", url = local.buildurl, result = "result") {
			cfhttpparam(name = "Content-Type", type = "header", value = "application/json");
			cfhttpparam(name = "Authorization", type = "header", value = "Bearer " & arguments.token);
			if ( structKeyExists(variables, "expand") ) {
				cfhttpparam(name = "expand", type = "url", value = variables.getExpand());
			}
			cfhttpparam(type = "body", value = "");
		}
		stcResponse.status_code = result.Responseheader.status_code;
		stcResponse.response = deserializeJSON(result.filecontent);
		return stcResponse;
	}

	public struct function trackingNotification(required string token) {
		var requestBody = structNew();
		if ( structKeyExists(variables, "uniqueTrackingId") ) { requestBody["uniqueTrackingId"] = variables.getUniqueTrackingId(); }
		if ( structKeyExists(variables, "approximateIntakeDate") ) { requestBody["approximateIntakeDate"] = variables.getApproximateIntakeDate(); }
		if ( structKeyExists(variables, "notifyEventTypes") ) { requestBody["notifyEventTypes"] = variables.getNotifyEventTypes(); }
		if ( structKeyExists(variables, "firstName") ) { requestBody["firstName"] = variables.getFirstName(); }
		if ( structKeyExists(variables, "lastName") ) { requestBody["lastName"] = variables.getLastName(); }
		if ( structKeyExists(variables, "notifications") ) { requestBody["notifications"] = variables.getNotifications(); }
		var buildurl = "https://#variables.baseUrl#/tracking/v3/tracking/#variables.getTrackingNumber()#/notifications";
		cfhttp(method = "POST", charset = "utf-8", url = local.buildurl, result = "result") {
			cfhttpparam(name = "Content-Type", type = "header", value = "application/json");
			cfhttpparam(name = "Authorization", type = "header", value = "Bearer " & arguments.token);
			cfhttpparam(type = "body", value = serializeJSON(local.requestBody));
		}
		stcResponse.status_code = result.Responseheader.status_code;
		stcResponse.response = deserializeJSON(result.filecontent);
		return stcResponse;
	}
}