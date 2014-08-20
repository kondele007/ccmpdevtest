public with sharing class cc_api_dl_MenuItems extends cc_api_dl_productDataLoaderBase {

	public override SObject getNewSObject(){
		return new  E_MenuItem__c();
	}
	
	public override void deleteObject() {
		// deletes all menus before loading from the xml file
		delete [select Id From E_MenuItem__c];
	}

	public override String getDataFileName() {
		return 'menuItem.xml';
	}

	public override Map<String, Schema.SObjectField> getFieldMap() {
		return Schema.SObjectType.E_MenuItem__c.fields.getMap();
	}
	
	public override void postProcess(List<SObject> objs) {
		List<E_MenuItem__c> menuItems = new List<E_MenuItem__c>();
		for(SObject so : objs) {
			E_Menu__c menu = new E_Menu__c(MenuId__c=String.valueOf(so.get('Menu__c')));
			menuItems.add(new E_MenuItem__c(
				Menu__r = menu,
				DisplayName__c = String.valueOf(so.get('DisplayName__c')),
				Sequence__c = Double.valueOf(so.get('Sequence__c'))
			));
		}
		insert menuItems;
		
    	cc_api_HtmlCache.deleteAllMenuHtmlCaches();
    	cc_api_HtmlCache.cacheMenus();
	}

	public override String getTestString() {
		return '<document><row><Menu__c>1</Menu__c><DisplayName__c>Sub Navigation #1</DisplayName__c><Sequence__c>100</Sequence__c></row></document>';
	}
}