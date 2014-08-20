public with sharing class cc_api_dl_cs_pageConfiguration extends cc_api_dl_customSettingsLoaderBase {
	public override SObject getNewSObject(){
		return new  PageConfiguration__c();
	}
	public override void deleteObject() {
		delete [Select c.Id From PageConfiguration__c c LIMIT 2000];
	}
	public override String getDataFileName() {
		return 'pageConfiguration.xml';
	}
	public override Map<String, Schema.SObjectField> getFieldMap() {
		return Schema.SObjectType.PageConfiguration__c.fields.getMap();
	}
	public override String getTestString() {
		return '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
				'<Root xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
    				'<Row><NAME>HomepageLeftNav</NAME><VALUE__C>aw_LeftNavInc</VALUE__C></Row>' +
    				'</Root>';
    				
	}
}