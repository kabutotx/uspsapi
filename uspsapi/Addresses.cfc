/*
File: Addresses.cfc

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
Addresses.cfc 0.9
Author: Robert Davis; kabutotx@gmail.com
*/

component displayName="Addresses" accessors="true" produces="json" hint="This API supports ZIP Code and City/State lookups and validates and standardizes USPS domestic addresses, city and state names, and ZIP Codes in accordance with USPS addressing standards." {
	property name="firm" type="string";
	property name="streetAddress" type="string";
	property name="secondaryAddress" type="string";
	property name="city" type="string";
	property name="state" type="string";
	property name="urbanization" type="string";
	property name="ZIPCode" type="string";
	property name="ZIPPlus4" type="string";

	public any function init(boolean developmentServer="false") {
		if ( arguments.developmentServer ) {
			baseUrl = "apis-tem.usps.com";
		} else {
			baseUrl = "apis.usps.com";
		}
		return this;
	}
	
	public struct function address(required string token) {
		// Required: streetAddress, state
		var buildurl = "https://#variables.baseUrl#/addresses/v3/address";
		cfhttp(method = "GET", charset = "utf-8", url = local.buildurl, result = "result") {
			cfhttpparam(name = "Content-Type", type = "header", value = "application/json");
			cfhttpparam(name = "Authorization", type = "header", value = "Bearer " & arguments.token);
			if ( structKeyExists(variables, "firm") ) {
				cfhttpparam(name = "firm", type = "url", value = variables.getFirm());
			}
			if ( structKeyExists(variables, "streetAddress") ) {
				cfhttpparam(name = "streetAddress", type = "url", value = variables.getStreetAddress());
			}
			if ( structKeyExists(variables, "secondaryAddress") ) {
				cfhttpparam(name = "secondaryAddress", type = "url", value = variables.getSecondaryAddress());
			}
			if ( structKeyExists(variables, "city") ) {
				cfhttpparam(name = "city", type = "url", value = variables.getCity());
			}
			if ( structKeyExists(variables, "state") ) {
				cfhttpparam(name = "state", type = "url", value = variables.getState());
			}
			cfhttpparam(type = "body", value = "");
		}
		stcResponse.status_code = result.Responseheader.status_code;
		stcResponse.response = deserializeJSON(result.filecontent);
		return stcResponse;
	}
	
	public struct function cityState(required string token) {
		// Required: ZIPCode
		var buildurl = "https://#variables.baseUrl#/addresses/v3/city-state";
		cfhttp(method = "GET", charset = "utf-8", url = local.buildurl, result = "result") {
			cfhttpparam(name = "Content-Type", type = "header", value = "application/json");
			cfhttpparam(name = "Authorization", type = "header", value = "Bearer " & arguments.token);
			if ( structKeyExists(variables, "ZIPCode") ) {
				cfhttpparam(name = "ZIPCode", type = "url", value = variables.getZIPCode());
			}
			cfhttpparam(type = "body", value = "");
		}
		stcResponse.status_code = result.Responseheader.status_code;
		stcResponse.response = deserializeJSON(result.filecontent);
		return stcResponse;
	}

	public struct function zipCode(required string token) {
		// Required: streetAddress, city, state
		var buildurl = "https://#variables.baseUrl#/addresses/v3/zipcode";
		cfhttp(method = "GET", charset = "utf-8", url = local.buildurl, result = "result") {
			cfhttpparam(name = "Content-Type", type = "header", value = "application/json");
			cfhttpparam(name = "Authorization", type = "header", value = "Bearer " & arguments.token);
		if ( structKeyExists(variables, "firm") ) {
			cfhttpparam(name = "firm", type = "url", value = variables.getFirm());
		}
		if ( structKeyExists(variables, "streetAddress") ) {
			cfhttpparam(name = "streetAddress", type = "url", value = variables.getStreetAddress());
		}
		if ( structKeyExists(variables, "secondaryAddress") ) {
			cfhttpparam(name = "secondaryAddress", type = "url", value = variables.getSecondaryAddress());
		}
		if ( structKeyExists(variables, "city") ) {
			cfhttpparam(name = "city", type = "url", value = variables.getCity());
		}
		if ( structKeyExists(variables, "state") ) {
			cfhttpparam(name = "state", type = "url", value = variables.getState());
		}
			cfhttpparam(type = "body", value = "");
		}
		stcResponse.status_code = result.Responseheader.status_code;
		stcResponse.response = deserializeJSON(result.filecontent);
		return stcResponse;
	}
}