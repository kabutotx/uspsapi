<cfscript>
// Get OAuth Token if missing or expired and save to browser cookie
if (not structKeyExists(cookie, "USPStokenExp")) {
	cfcookie(name="USPStokenExp", value="");
}
if (now() gt cookie.USPStokenExp) {
	// OAuth Call
	uspsapi = new uspsapi.OAuth(1); // 1 = CAT Test Servers
	uspsapi.setClientId("xxxx"); // API Key
	uspsapi.setClientSecret("xxxx"); // API Secret
	uspsapi.setGrantType("client_credentials");
	result = uspsapi.token();
	writeDump(var=result, label="OAuth");
	if (result.status_code == 200){
		writeOutput("New Token");
		cfcookie(name="USPStoken", value=result.response.access_token);
		cfcookie(name="USPStokenExp", value=dateAdd("S", result.response.expires_in-10, now()));
	}
}

if (structKeyExists(cookie, "USPStoken")) {
/* Domestic Prices V3 base-rates */
uspsapi = new uspsapi.DomesticPrices(1);
uspsapi.setOriginZIPCode("78664");
uspsapi.setDestinationZIPCode("78665");
uspsapi.setWeight(7);
uspsapi.setLength(9);
uspsapi.setWidth(0.25);
uspsapi.setHeight(6);
uspsapi.setMailClass("PRIORITY_MAIL");
uspsapi.setProcessingCategory("MACHINABLE");
uspsapi.setDestinationEntryFacilityType("NONE");
uspsapi.setRateIndicator("DR");
uspsapi.setPriceType("COMMERCIAL");
uspsapi.setAccountType("EPS");
//uspsapi.setAccountNumber("XXXXXXXXXX");
uspsapi.setMailingDate("2025-05-25");
result = uspsapi.baseRates(cookie.USPStoken, uspsapi);
writeDump(var=result, label="Domestic Base Rates");


/* Domestic Prices V3 extra-service-rates
uspsapi = new uspsapi.DomesticPrices(1);
uspsapi.setextraService(415);
uspsapi.setMailClass("PARCEL_SELECT");
uspsapi.setPriceType("RETAIL");
uspsapi.setItemValue(0);
uspsapi.setWeight(5);
uspsapi.setMailingDate("2024-05-25");
uspsapi.setAccountType("EPS");
uspsapi.setAccountNumber("XXXXXXXXXX");
result = uspsapi.extraServiceRates(cookie.USPStoken, uspsapi);
writeDump(var=result, label="Extra Service Rates");
*/

/* Domestic Prices V3 base-rates-list
uspsapi = new uspsapi.DomesticPrices(1);
uspsapi.setOriginZIPCode("32796");
uspsapi.setDestinationZIPCode("92656");
uspsapi.setWeight(5);
uspsapi.setLength(7.25);
uspsapi.setWidth(7.25);
uspsapi.setHeight(6.5);
uspsapi.setMailClasses(["PRIORITY_MAIL"]);
uspsapi.setPriceType("COMMERCIAL");
//uspsapi.setAccountType("EPS");
//uspsapi.setAccountNumber("XXXXXXXXXX");
uspsapi.setMailingDate("2024-03-28");
result = uspsapi.baseRatesList(cookie.USPStoken, uspsapi);
writeDump(var=result, label="Base Rates List");
*/

/* Domestic Prices V3 total-rates
uspsapi = new uspsapi.DomesticPrices(1);
uspsapi.setOriginZIPCode("32796");
uspsapi.setDestinationZIPCode("92656");
uspsapi.setWeight(5);
uspsapi.setLength(6);
uspsapi.setWidth(6);
uspsapi.setHeight(6);
//uspsapi.setMailClass("PRIORITY_MAIL");
//uspsapi.setProcessingCategory("MACHINABLE");
//uspsapi.setDestinationEntryFacilityType("NONE");
//uspsapi.setRateIndicator("DR");
uspsapi.setPriceType("RETAIL");
//uspsapi.setAccountType("EPS");
//uspsapi.setAccountNumber("XXXXXXXXXX");
uspsapi.setMailingDate("2024-09-11");
result = uspsapi.totalRates(cookie.USPStoken, uspsapi);
writeDump(var=result, label="Total Rates");
*/

/* Domestic Prices V3 letter-rates
uspsapi = new uspsapi.DomesticPrices(1);
uspsapi.setWeight(0.0560);
uspsapi.setLength(9.5);
uspsapi.setHeight(4.125);
uspsapi.setThickness(0.20);
uspsapi.setProcessingCategory("LETTERS");
result = uspsapi.letterRates(cookie.USPStoken, uspsapi);
writeDump(var=result, label="Letter Rates");
*/

/* International Prices V3 base-rates
uspsapi = new uspsapi.InternationalPrices(1);
uspsapi.setOriginZIPCode("22407");
uspsapi.setForeignPostalCode("10109");
uspsapi.setDestinationCountryCode("CA");
uspsapi.setDestinationEntryFacilityType("NONE");
uspsapi.setWeight(0.5);
uspsapi.setLength(9);
uspsapi.setWidth(15);
uspsapi.setHeight(6);
uspsapi.setMailClass("FIRST-CLASS_PACKAGE_INTERNATIONAL_SERVICE");
uspsapi.setProcessingCategory("NON_MACHINABLE");
uspsapi.setRateIndicator("SP");
uspsapi.setPriceType("COMMERCIAL");
uspsapi.setAccountType("EPS");
//uspsapi.setAccountNumber("XXXXXXXXXX");
uspsapi.setMailingDate("2025-05-25");
result = uspsapi.baseRates(cookie.USPStoken, uspsapi);
writeDump(var=result, label="International Base Rates");
*/

/* Addresses Address
uspsapi = new uspsapi.Addresses(1);
uspsapi.setStreetAddress("3120 M ST NW");
uspsapi.setcity("WASHINGTON");
uspsapi.setState("DC");
uspsapi.setZIPCode("20007");
result = uspsapi.address(cookie.USPStoken);
writeDump(var=result, label="Address");
*/

/* Addresses Zipcode
uspsapi = new uspsapi.Addresses(1);
uspsapi.setStreetAddress("3120 M ST NW");
uspsapi.setcity("WASHINGTON");
uspsapi.setState("DC");
result = uspsapi.zipcode(cookie.USPStoken);
writeDump(var=result, label="ZipCode");
*/

/* Tracking
uspsapi = new uspsapi.tracking(1);
uspsapi.setTrackingNumber("XXXXXXXXXXXXXXXXXXXX");
uspsapi.setExpand("DETAIL");
result = uspsapi.tracking(cookie.USPStoken);
writeDump(var=result, label="Tracking");
*/

/* Tracking Notification
uspsNotify = arrayNew();
stcNotify = structNew();
stcNotify["email"] = "user@example.com";
uspsNotify.append(stcNotify);
stcNotify = structNew();
stcNotify["cellNumber"] = "1112223333";
uspsNotify.append(stcNotify);
uspsapi = new uspsapi.tracking(1);
uspsapi.setTrackingNumber("XXXXXXXXXXXXXXXXXXXX");
//uspsapi.setUniqueTrackingID("");
uspsapi.setNotifyEventTypes(["EMAIL_ALERT"]);
uspsapi.setNotifications(uspsNotify);
result = uspsapi.trackingNotification(cookie.USPStoken);
writeDump(var=result, label="Tracking Notification");
*/
}
</cfscript>