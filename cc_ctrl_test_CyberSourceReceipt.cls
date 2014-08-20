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
private without sharing class cc_ctrl_test_CyberSourceReceipt {

    static testMethod void testConstructor() {
    	PageReference page = new PageReference('/apex/cc_ctrl_CyberSourceReceipt');
    	page.getParameters().put('ccAuthReply_authorizationCode', '1234');
page.getParameters().put('paySubscriptionCreateReply_subscriptionID', '1234');
    	Test.setCurrentPage(page);
    	
    	Test.startTest();

        cc_ctrl_CyberSourceReceipt controller = new cc_ctrl_CyberSourceReceipt();
        //System.AssertNotEquals(null, controller.authCode);
        
        Test.stopTest();
    }
}