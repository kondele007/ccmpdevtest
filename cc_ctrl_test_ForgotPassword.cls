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
private class cc_ctrl_test_ForgotPassword {

    public static testMethod void testCCForgotPasswordController() {
        cc_test_PrepTestData.loadCustomSettings();
        Test.startTest();

        // Instantiate a new controller with all parameters in the page
        cc_ctrl_ForgotPassword controller = new cc_ctrl_ForgotPassword();
        controller.username = 'test@salesforce.com';        
        PageReference pr = new PageReference('/apex/CCForgotPassword');
        System.assertNotEquals(null, controller.forgotPassword());
        System.assertNotEquals(null, controller.gotoLoginPage(pr)); 
        
        Test.stopTest();
    }
}