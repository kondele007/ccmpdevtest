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
private class cc_test_PrepTestDataTest {
	
    static testmethod void testInsertUser() {
    	cc_test_PrepTestData.loadCustomSettings();
    	cc_test_PrepTestData.loadInitData();
    	Test.startTest();
    	
    	//System.debug('--- application=' + cc_util_CloudCraze.application);
    	System.assertNotEquals(null, cc_util_CloudCraze.application);

        //System.debug('--- application.Default_Storefront__c=' + cc_util_CloudCraze.application.Default_Storefront__c);
        System.assertEquals(cc_cnst_CloudCraze.DEFAULT_STOREFRONT_NAME, cc_util_CloudCraze.application.Default_Storefront__c);

    	User u = cc_test_PrepTestData.insertPortalUser('test1');
    	cc_test_PrepTestData.insertCategory();
    	cc_test_PrepTestData.insertWishList();
    	cc_test_PrepTestData.insertStorefrontCustomSetting(true, 'DefaultStore', 'http://www.google.com', 'PortalAccount');
    	cc_test_PrepTestData.createUser();
        System.assertNotEquals(u, null);
        
        Test.stopTest();
    }
    
}