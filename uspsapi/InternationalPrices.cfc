/*
File: InternationalPrices.cfc

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
InternationalPrices.cfc 0.9
Author: Robert Davis; kabutotx@gmail.com
*/

component displayName="InternationalPrices" accessors="true" produces="json" hint="The International Prices API can be used to look-up postage rates for International packages." {
	property name="originZIPCode" type="string";
	property name="weight" type="numeric";
	property name="length" type="numeric";
	property name="width" type="numeric";
	property name="height" type="numeric";
	property name="mailClass" type="string";
	property name="processingCategory" type="string";
	property name="rateIndicator" type="string";
	property name="destinationEntryFacilityType" type="string";
	property name="priceType" type="string";
	property name="mailingDate" type="string";
	property name="foreignPostalCode" type="string";
	property name="destinationCountryCode" type="string";
	property name="accountType" type="string";
	property name="accountNumber" type="string";
	property name="extraService" type="numeric";
	property name="itemValue" type="numeric";

	public any function init(boolean developmentServer="false") {
		if ( arguments.developmentServer ) {
			baseUrl = "apis-tem.usps.com";
		} else {
			baseUrl = "apis.usps.com";
		}
		return this;
	}
	
	public struct function baseRates(required string token, required struct request) {
		var buildurl = "https://#variables.baseUrl#/international-prices/v3/base-rates/search";
		cfhttp(method = "POST", charset = "utf-8", url = local.buildurl, result = "result") {
			cfhttpparam(name = "Content-Type", type = "header", value = "application/json");
			cfhttpparam(name = "Authorization", type = "header", value = "Bearer " & arguments.token);
			cfhttpparam(type = "body", value = serializeJSON(arguments.request));
		}
		stcResponse.status_code = result.Responseheader.status_code;
		stcResponse.response = deserializeJSON(result.filecontent);
		return stcResponse;
	}
	
	public struct function extraServiceRates(required string token, required struct request) {
		var buildurl = "https://#variables.baseUrl#/international-prices/v3/extra-service-rates/search";
		cfhttp(method = "POST", charset = "utf-8", url = local.buildurl, result = "result") {
			cfhttpparam(name = "Content-Type", type = "header", value = "application/json");
			cfhttpparam(name = "Authorization", type = "header", value = "Bearer " & arguments.token);
			cfhttpparam(type = "body", value = serializeJSON(arguments.request));
		}
		stcResponse.status_code = result.Responseheader.status_code;
		stcResponse.response = deserializeJSON(result.filecontent);
		return stcResponse;
	}

	public struct function baseRatesList(required string token, required struct request) {
		var buildurl = "https://#variables.baseUrl#/international-prices/v3/base-rates-list/search";
		cfhttp(method = "POST", charset = "utf-8", url = local.buildurl, result = "result") {
			cfhttpparam(name = "Content-Type", type = "header", value = "application/json");
			cfhttpparam(name = "Authorization", type = "header", value = "Bearer " & arguments.token);
			cfhttpparam(type = "body", value = serializeJSON(arguments.request));
		}
		stcResponse.status_code = result.Responseheader.status_code;
		stcResponse.response = deserializeJSON(result.filecontent);
		return stcResponse;
	}
}