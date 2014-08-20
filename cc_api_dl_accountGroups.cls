public with sharing class cc_api_dl_accountGroups extends cc_api_dl_productDataLoaderBase {
	public override SObject getNewSObject(){
		return new  E_AccountGroup__c();
	}
	public override void deleteObject() {
		//delete [Select c.Id From E_AccountGroup__c c where c.accountgroupid__c in('1', '2')];
	}
	public override String getDataFileName() {
		return 'accountGroup.xml';
	}
	public override Map<String, Schema.SObjectField> getFieldMap() {
		return Schema.SObjectType.E_AccountGroup__c.fields.getMap();
	}
	public override String getTestString() {
		return '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'+
				'<Root xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
				'<Row>'+
				'<NAME>PortalAccount</NAME>'+
				'<ACCOUNTGROUPID__C>1</ACCOUNTGROUPID__C>'+
				'</Row>'+
				'<Row>'+
				'<NAME>Anonymous</NAME>'+
				'<ACCOUNTGROUPID__C>2</ACCOUNTGROUPID__C>'+
				'</Row>'+
			'</Root>';
	}
}