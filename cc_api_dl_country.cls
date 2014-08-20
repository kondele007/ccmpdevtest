public with sharing class cc_api_dl_country extends cc_api_dl_customSettingsLoaderBase {
	public override SObject getNewSObject(){
		return new  CountryCode__c();
	}
	public override void deleteObject() {
		delete [Select Id From CountryCode__c];
	}
	public override String getDataFileName() {
		return 'country.xml';
	}
	public override Map<String, Schema.SObjectField> getFieldMap() {
		return Schema.SObjectType.CountryCode__c.fields.getMap();
	}
	public override String getTestString() {
		return '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
				'<Root xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
				'<Row>' +
				  '<NAME>US</NAME>' +
				  '<ALLOWACCESS__C>true</ALLOWACCESS__C>' +
				  '<COUNTRY__C>United States</COUNTRY__C>' +
				  '<STOREFRONT__C>DefaultStore</STOREFRONT__C>' +
				'</Row>' + 
				'<Row>' +
				  '<NAME>CA</NAME>' +
				  '<ALLOWACCESS__C>false</ALLOWACCESS__C>' +
				  '<COUNTRY__C>Canada</COUNTRY__C>' +
				  '<STOREFRONT__C>DefaultStore</STOREFRONT__C>' +
				'</Row>' + 
				'</Root>';
	}
	
}