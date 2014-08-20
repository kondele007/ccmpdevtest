public with sharing class cc_api_customerSettingsLoaderBaseTester extends cc_api_dl_customSettingsLoaderBase {
	public override SObject getNewSObject() {
		return new  E_ApplicationSettings__c();
	}
	public override String getDataFileName() {
		return null;
	}
	
	public override Map<String, Schema.SObjectField> getFieldMap() {
		return null;
	}
	static testMethod void unitTest() {
        cc_api_customerSettingsLoaderBaseTester tester = new cc_api_customerSettingsLoaderBaseTester();
        System.assert(tester.getNewSObject() instanceof E_ApplicationSettings__c);
        System.assert(tester.getDataFileName() == null);
        //System.assert(tester.getStaticResourceUrl() == null);
        tester.getStaticResourceUrl();
        System.assert(tester.getFieldMap() == null);
    }
}