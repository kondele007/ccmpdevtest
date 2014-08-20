/**
 * test coverage 100% by cc_api_test_HtmlCache
 */
public with sharing class cc_dao_Menu {
	
	public static List<E_Menu__c> getAllMenus() {
		return [select DisplayName__c, LinkType__c, URL__c, Product__c, Category__c, NewWindow__c,
					   (select Locale__c, DisplayName__c from Menu_I18N__r),
					   (select Id from Menu_Items__r order by Sequence__c)
				  from E_Menu__c
				 where Enabled__c = true
				   and StartDate__c <= today
				   and EndDate__c > today
			  order by Sequence__c];
	}
	
	public static List<E_MenuItem__c> getMenuItems(List<Id> menuItemIds) {
		return [select DisplayName__c, LinkType__c, URL__c, Product__c, Category__c, NewWindow__c,
					   (select Locale__c, DisplayName__c from MenuItem_I18N__r),
				  	   (select Id from Child_Menu_Items__r order by Sequence__c)
				  from E_MenuItem__c
				 where Id = :menuItemIds
				   and Enabled__c = true
				   and StartDate__c <= today
				   and EndDate__c > today
			  order by Sequence__c];
	}
}