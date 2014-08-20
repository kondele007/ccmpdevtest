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
private class cc_util_test_UpdateContactTest {

	private static void prepTestData() {
        cc_test_PrepTestData.loadCustomSettings();
        cc_test_PrepTestData.loadInitData();
	}

    static testMethod void myUnitTest() {
    	cc_util_test_UpdateContactTest.prepTestData();
        User u = cc_test_PrepTestData.insertPortalUser('cc_util_test_UpdateContactTest');
        Test.startTest();
        
        cc_util_UpdateContact.updateContacts(new List<ID>{u.Id});
        
        // TODO: validate the update worked/add meaningful assertion
        System.assert(true);
        
        
        Test.stopTest();
    }
}