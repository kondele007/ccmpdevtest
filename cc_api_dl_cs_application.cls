public with sharing class cc_api_dl_cs_application extends cc_api_dl_customSettingsLoaderBase {
	public override SObject getNewSObject(){
		return new  E_ApplicationSettings__c();
	}
	public override void deleteObject() {
		delete [Select c.Id From E_ApplicationSettings__c c where name='CloudCraze'];
	}
	public override String getDataFileName() {
		return 'application.xml';
	}
	public override Map<String, Schema.SObjectField> getFieldMap() {
		return Schema.SObjectType.E_ApplicationSettings__c.fields.getMap();
	}
	
	public override String getTestString() {
		return '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
				'<Root xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
				'<row><NAME>CloudCraze</NAME><DEFAULT_STOREFRONT__C>DefaultStore</DEFAULT_STOREFRONT__C><ANONYMOUS_ACCOUNT_NAME__C>Anonymous</ANONYMOUS_ACCOUNT_NAME__C><ANONYMOUS_USERNAME__C>Anonymous</ANONYMOUS_USERNAME__C></row>' +
				'</Root>';
    
	}
}