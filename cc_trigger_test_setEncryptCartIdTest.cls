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
private class cc_trigger_test_setEncryptCartIdTest {

    static testMethod void myUnitTest() {
    	cc_test_TestDataSetup.loadData();
    	System.RunAs(cc_test_TestDataSetup.testUser){
        cc_api_Cart api = new cc_api_Cart();
        DateTime now = System.now();
        String formattednow = now.formatGmt('yyyy-MM-dd')+'T'+ now.formatGmt('HH:mm:ss')+'.'+now.formatGMT('SSS')+'Z';
        String name = 'Cart' + formattednow; 
        Test.startTest();
        E_Cart__c cart = api.createCart(name, false, null, null);
        cart = api.retrieveCart(cart.Id);
        E_Cart__c newcart = api.retrieveCart(cart.EncryptedId__c);
        Test.stopTest();
        
       System.assertEquals(newcart.Name__c, name);
    	}
    }
}