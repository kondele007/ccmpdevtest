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
private class cc_hlpr_test_CyberSourceHOP {

    static testMethod void testGetPublicDigest() {
    	cc_test_TestDataSetup.LoadData();
        System.runas(cc_test_TestDataSetup.testUser) {
    	cc_hlpr_CyberSourceHOP controller = new cc_hlpr_CyberSourceHOP();
    	 
        System.AssertNotEquals(null, controller.getPublicDigest());
        }
    }
}