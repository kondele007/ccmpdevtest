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
private class cc_dao_test_PriceList {
    static testMethod void testCloning() {
        cc_test_PrepTestData.loadInitData();
        
        E_PriceList__c pricelist = [select Id, PricelistId__c from E_PriceList__c limit 1][0];

        String prodStatus = cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED;
        
        E_Product__c product1 = new E_Product__c(
        	Sku__c = 'testSKU1', Name = 'test product 1', ProductStatus__c = prodStatus
		);
        insert product1;
        
        E_PriceListItem__c pli = new E_PriceListItem__c(
        	Pricelist__c = pricelist.Id, Product__c = product1.id, Price__c = 200
        );
        insert pli;
        
        Test.startTest();
        cc_dao_PriceList dao = new cc_dao_PriceList();
        E_PriceList__c clone = dao.clone(pricelist.Id, true);
        System.AssertEquals(pricelist.PricelistId__c + '_copy', clone.PricelistId__c);
        Test.stopTest();
    }
}