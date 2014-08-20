@isTest
private class cc_api_test_Product {

    static testMethod void testProductAPI() {
        E_Product__c product1 = new E_Product__c(SKU__C='testSKU1',  Name='test product 1', ShippingWeight__c=1);
        insert product1;

        List<E_ProductTab__c> tabs = new List<E_ProductTab__c> {
	        new E_ProductTab__c(Tab__c='tab1', Product__c=product1.Id, Content__c='Test1'),
	        new E_ProductTab__c(Tab__c='tab2', Product__c=product1.Id, Content__c='Test2')
        };
        insert tabs;
		
		List<cc_bean_ProductTab> tabBeans = cc_api_Product.getProductTabBeans(tabs);
		System.assertEquals(2, tabBeans.size());
    }
}