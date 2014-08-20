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
private class cc_hlpr_test_InitLoadCategories {

    static testMethod void myUnitTest() {
        //cc_hlpr_test_InitLoadCategories.prepTestData();
        cc_hlpr_InitLoadCategories.initialize();
        
    	Test.startTest();
		cc_hlpr_InitLoadCategories.loadCategories();
		cc_hlpr_InitLoadCategories.loadProducts();
		cc_hlpr_InitLoadCategories.loadProductCategories();
        system.assert([Select c.Id From E_Category__c c where c.CATEGORYID__C in ('0', '99999', '99998', '88888', '88887') ].size() != 0);
        //cc_hlpr_InitLoadCategories.loadTestPriceListItems();
        
        //System.AssertEquals(2, [Select count() From E_Category__c Where Name like 'CloudCrazeTest%']);
        
        Test.stopTest();
        /*
        for(E_Category__c c : [Select e.Name, e.ParentCategory__r.Name From E_Category__c e])
        {
        	//System.debug('---------------------------------->' + c.Name + '--------------->' + c.ParentCategory__r.Name);
        }
        for(E_Product__c c : [Select e.Name, e.SKU__c From E_Product__c e])
        {
        	//System.debug('-----------Product----------------------->' + c.Name + '-------SKU-------->' + c.SKU__c);
        }
        for(E_ProductCategory__c c : [Select e.Product__r.SKU__c, e.Id, e.Category__r.Name From E_ProductCategory__c e])
        {
        	//System.debug('-----------Product----------------------->' + c.Product__r.SKU__c + '-------category-------->' + c.Category__r.Name);
        }
        for(E_PriceListItem__c c : [Select e.Product__r.SKU__c, e.Pricelist__c, e.Price__c, e.Id From E_PriceListItem__c e])
        {
        	//System.debug('-----------Product----------------------->' + c.Product__r.SKU__c + '-------price-------->' + c.Price__c);
        }
        */
    }
}