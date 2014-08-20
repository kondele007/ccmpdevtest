/**
 * test coverage 100% by cc_api_test_HtmlCache
 */
public with sharing class cc_dao_HtmlCache {

	public static void deleteCaches(String htmlType) {
        List <E_HtmlCache__c> caches = [select Id from E_HtmlCache__c where HtmlType__c = :htmlType];
		if(caches != null && caches.size() > 0) {
			System.debug('--- cc_dao_HtmlCache.deleteCaches: deleting ' + htmlType + ' caches.');
			delete caches;
		}
	}
	
	public static List<E_HtmlCache__c> getHtmlCaches(String htmlType, String storefrontName, String locale) {
		List<E_HtmlCache__c> caches = [
				select Id,
					   (Select Id From Attachments)
				  from E_HtmlCache__c
				 where HtmlType__c = :htmlType
				   and StoreID__c = :storefrontName
				   and Locale__c = :locale];

		return caches;
	}

}