public with sharing class cc_api_dl_menus extends cc_api_dl_productDataLoaderBase {

	public override SObject getNewSObject(){
		return new  E_Menu__c();
	}
	
	public override void deleteObject() {
		// deletes all menus before loading from the xml file
		delete [select Id From E_Menu__c];
	}

	public override String getDataFileName() {
		return 'menu.xml';
	}

	public override Map<String, Schema.SObjectField> getFieldMap() {
		return Schema.SObjectType.E_Menu__c.fields.getMap();
	}
	
	public override void postProcess(List<SObject> objs) {
		insert objs;

    	cc_api_HtmlCache.deleteAllMenuHtmlCaches();
    	cc_api_HtmlCache.cacheMenus();
	}

	public override String getTestString() {
		return '<document><row><MenuId__c>1</MenuId__c><DisplayName__c>Navigation Item #1</DisplayName__c><Sequence__c>100</Sequence__c><StoreID__c>DefaultStore</StoreID__c></row></document>';
	}
}