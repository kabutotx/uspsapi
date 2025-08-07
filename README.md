# ColdFusion USPS API CFC

This is a ColdFusion CFC used to connect to USPS API using OAuth.

## Requirements
* ACF 11+
* Lucee 5+

To authenticate with the USPS API, use your application's Consumer KEY and SECRET. If you don't have these credentials, setup your application from https://developers.usps.com.

## Initialization

This will init the USPS Component cfc and setup testing or production URL.

**CreateObject()**

	variables.uspsapi = CreateObject('component', 'cfcname').init(developmentServer=true);

**New Keyword**

	variables.uspsapi = New cfcname(developmentServer=true);

## Sample Usage

See uspstest.cfm.

Steps:
	1. Retrieve site token. This is not a user specific token requiring them to login to USPS.
	(Store token and expiration somewhere you can retrieve such as a DB. Sample just uses a cookie. You can the use same key until expiration where you will need to get a new token)
	2. Use setters to initialize the properties for the component.
	3. Call API passing token and component variable.

## Response

Result for API will be structure from the deserialized JSON.

## License

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
