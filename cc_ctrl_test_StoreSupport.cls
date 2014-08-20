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
private class cc_ctrl_test_StoreSupport {

    static testMethod void storeIdTest() {
        cc_test_PrepTestData.loadCustomSettings();
        Test.startTest();
        
        cc_ctrl_StoreSupport controller = new cc_ctrl_StoreSupport();
        controller.storeID = cc_util_CloudCraze.application.Default_Storefront__c;
        System.assert(controller.storeID == cc_util_CloudCraze.application.Default_Storefront__c);
        
        Test.stopTest();
    }
    
    static testMethod void supportUrlTest() {
        cc_test_PrepTestData.loadCustomSettings();
        Test.startTest();

        cc_ctrl_StoreSupport controller = new cc_ctrl_StoreSupport();
        System.assertEquals(controller.supportUrl, cc_cnst_CloudCraze.DEFAULT_STORE_SUPPORT_URL);

        Test.stopTest();
    }
}