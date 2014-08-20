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
private class cc_ctrl_test_PriceListExtension {

    static testMethod void testClonePriceList() {
    	cc_test_PrepTestData.loadAllCustomSettings();
        cc_test_PrepTestData.loadInitData();
        
        List<E_PriceList__c> pls = [select CurrencyISOCode__c from E_PriceList__c limit 1];
        E_PriceList__c pl = null;
        if(pls.size() > 0) {
        	pl = pls[0];
        }
    	ApexPages.StandardController sController = new ApexPages.StandardController(pl);
        
        Test.startTest();

        cc_ctrl_PriceListExtension controller = new cc_ctrl_PriceListExtension(sController);
        System.AssertNotEquals(null, controller.ClonePriceList());
        
        Test.stopTest();
    }
}