public with sharing class cc_api_dl_cs_PageUIKey extends cc_api_dl_customSettingsLoaderBase  {
	public override SObject getNewSObject(){
		return new  PageUIKey__c();
	}
	public override void deleteObject() {
		
	}
	public override String getDataFileName() {
		return 'PageUIKey.xml';
	}
	public override Map<String, Schema.SObjectField> getFieldMap() {
		return Schema.SObjectType.PageUIKey__c.fields.getMap();
	}
	public override String getTestString() {
		return '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
				'<Root xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
    				'<Row><NAME>products</NAME><VALUE__C>PLP</VALUE__C></Row>' +
    				'</Root>';
    				
	}
	
	@isTest static void myUnitTest() {
        // TO DO: implement unit test
        cc_api_dl_cs_PageUIKey ag = new cc_api_dl_cs_PageUIKey();
        ag.loadData();
        system.assert([select id from PageUIKey__c ].size() != 0);
       
    }
}