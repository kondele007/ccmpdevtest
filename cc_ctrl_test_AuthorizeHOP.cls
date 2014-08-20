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
private class cc_ctrl_test_AuthorizeHOP {

    static testMethod void testGenerateFormData() {
    	Test.setCurrentPage(System.Page.CheckOutNew);
    	cc_ctrl_AuthorizeHOP controller = new cc_ctrl_AuthorizeHOP();
    	controller.generateFormData();
        System.AssertNotEquals(null, controller.url);
    	System.AssertNotEquals(null, controller.fingerprint);
    }
}