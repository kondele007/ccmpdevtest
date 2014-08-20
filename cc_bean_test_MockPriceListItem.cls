//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
@isTest
private class cc_bean_test_MockPriceListItem {
	
	private static void prepTestData() {
        
    	delete [select id from E_PriceList__c where PricelistId__c in ('1', '2')];
    	
    	List<E_PriceList__c> priceLists = new List<E_PriceList__c>();

        priceLists.add(new E_PriceList__c(Name='PortalAccount', Desc__c='PortalAccount Price List', CustomerTypeCode__c='General',
                            CurrencyISOCode__c='USD', PricelistId__c='1'));

        priceLists.add(new E_PriceList__c(Name='Enterprise', Desc__c='Enterprise Price List', CustomerTypeCode__c='General',
                            CurrencyISOCode__c='USD', PricelistId__c='2'));

        insert priceLists;
	}

    static testMethod void myUnitTest() {
    	cc_bean_test_MockPriceListItem.prepTestData();
    	
        E_Product__c p = new E_Product__c();
         p.SKU__c = 'plitest123';
         p.LongDesc__c = 'This is long description for testing product';
         p.ShortDesc__c = 'This is short description for testing product';
         p.QuantityPerUnit__c = 1.0;
         insert p;
         
         E_PriceList__c pl = [select Id from E_PriceList__c where PriceListId__c = '2'][0];
         
         E_PriceListItem__c pli = new E_PriceListItem__c();
         pli.Product__c = p.Id;
         pli.Price__c = 110;
         pli.Pricelist__c = pl.Id;
         insert pli;
         pli = [select Price__c from E_PriceListItem__c where Id = :pli.Id];
         cc_bean_MockPriceListItem mpli = new cc_bean_MockPriceListItem(pli);
         System.assertEquals(110, mpli.price);
    }
}