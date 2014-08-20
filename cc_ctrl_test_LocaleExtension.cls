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
private class cc_ctrl_test_LocaleExtension {

    static testMethod void testPageConfigurations() {
    	
    	cc_test_TestDataSetup.LoadData();
        System.runas(cc_test_TestDataSetup.testUser) {
    	Test.startTest();
   	
        cc_ctrl_LocaleExtension controller = new cc_ctrl_LocaleExtension();
        
        System.AssertNotEquals(null, controller.getHomepageLeftNav());
       
        Test.stopTest();
        }
    }
}