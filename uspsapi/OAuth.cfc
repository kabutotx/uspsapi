/*
File: OAuth.cfc

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
OAuth.cfc 0.5
Author: Robert Davis; kabutotx@gmail.com
*/

component displayName="OAuth" accessors="true" hint="Issue one or more OAuth tokens for a client application to use to make subsequent resource requests." {
	property name="clientId" type="string";
	property name="clientSecret" type="string";
	property name="grantType" type="string";
	property name="scope" type="string";
	property name="state" type="string";
	property name="token" type="string";
	property name="tokenTypeHint" type="string";
	property name="code" type="string";
	property name="redirectUri" type="string";
	property name="refreshToken" type="string";
	property name="responseType" type="string";

	public any function init(boolean developmentServer="false") {
		if ( arguments.developmentServer ) {
			baseUrl = "apis-tem.usps.com";
		} else {
			baseUrl = "apis.usps.com";
		}
		return this;
	}

	public struct function authorize() {
		var requestBody = structNew();
		requestBody["client_id"] = variables.getClientId();
		if ( structKeyExists(variables, "responseType") ) {
			requestBody["response_type"] = variables.getResponseType();
		} else {
			requestBody["response_type"] = "code"; // default
		}
		requestBody["grant_type"] = variables.getGrantType();
		if ( structKeyExists(variables, "redirectUri") ) { requestBody["redirect_uri"] = variables.getRedirectUri(); }
		if ( structKeyExists(variables, "scope") ) { requestBody["scope"] = variables.getScope(); }
		if ( structKeyExists(variables, "state") ) { requestBody["state"] = variables.getState(); }
		cfhttp(method = "POST", charset = "utf-8", url = "https://#variables.baseUrl#/oauth2/v3/authorize", result = "result") {
			cfhttpparam(name = "Content-Type", type = "header", value = "application/json");
			cfhttpparam(type = "body", value = serializeJSON(requestBody));
		}
		stcResponse.status_code = result.Responseheader.status_code;
		stcResponse.response = deserializeJSON(result.filecontent);
		return stcResponse;
	}

	public struct function token() {
		var requestBody = structNew();
		requestBody["client_id"] = variables.getClientId();
		requestBody["client_secret"] = variables.getClientSecret();
		requestBody["grant_type"] = variables.getGrantType();
		if ( structKeyExists(variables, "scope") ) { requestBody["scope"] = variables.getScope(); }
		if ( structKeyExists(variables, "state") ) { requestBody["state"] = variables.getState(); }
		if ( structKeyExists(variables, "code") ) { requestBody["code"] = variables.getCode(); }
		if ( structKeyExists(variables, "redirectUri") ) { requestBody["redirect_uri"] = variables.getRedirectUri(); }
		if ( structKeyExists(variables, "refreshToken") ) { requestBody["refreshToken"] = variables.getRefreshToken(); }
		cfhttp(method = "POST", charset = "utf-8", url = "https://#variables.baseUrl#/oauth2/v3/token", result = "result") {
			cfhttpparam(name = "Content-Type", type = "header", value = "application/json");
			cfhttpparam(type = "body", value = serializeJSON(requestBody));
		}
		stcResponse.status_code = result.Responseheader.status_code;
		stcResponse.response = deserializeJSON(result.filecontent);
		return stcResponse;
	}

	public struct function revoke() {
		var requestBody = structNew();
		requestBody["token"] = variables.getToken();
		if ( structKeyExists(variables, "tokenTypeHint") ) {
			requestBody["token_type_hint"] = variables.gettokenTypeHint();
		} else {
			requestBody["token_type_hint"] = "refresh_token"; // default
		}
		cfhttp(method = "POST", charset = "utf-8", url = "https://#variables.baseUrl#/oauth2/v3/revoke", result = "result") {
			cfhttpparam(name = "Content-Type", type = "header", value = "application/json");
			cfhttpparam(type = "body", value = serializeJSON(requestBody));
		}
		stcResponse.status_code = result.Responseheader.status_code;
		stcResponse.response = deserializeJSON(result.filecontent);
		return stcResponse;
	}
}	
