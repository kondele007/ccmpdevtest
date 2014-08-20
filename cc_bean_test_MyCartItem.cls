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
private class cc_bean_test_MyCartItem {

    static testMethod void testAddresses() {
    	cc_test_TestDataSetup.LoadData();
        System.runas(cc_test_TestDataSetup.testUser) {
    	cc_api_Cart capi = new cc_api_Cart();
    	E_Cart__c cart = capi.createEmptyCart();
    	cart = [select ID, CartId__c, Name, TotalAmount__c, CartStatus__c, LastModifiedDate, EncryptedID__c,
                   BillTo__r.FirstName__c, BillTo__r.MiddleName__c, BillTo__r.LastName__c,
                   ShipTo__r.FirstName__c, ShipTo__r.MiddleName__c, ShipTo__r.LastName__c
                   from E_Cart__c where Id=:cart.Id limit 1][0];

    	Test.startTest();
    	
        cc_bean_MyCartItem bean = new cc_bean_MyCartItem();
        bean.cart = cart;
        bean.billingAddress = cart.BillTo__r;
        bean.shippingAddress = cart.ShipTo__r;

        System.AssertNotEquals(null, bean.getCartStatus());
        System.AssertNotEquals(null, bean.getShippingName());
        System.AssertNotEquals(null, bean.getBillingName());
        System.AssertNotEquals(null, bean.getCartEmail());
        System.AssertNotEquals(null, bean.mockBillingAddress);
        System.AssertNotEquals(null, bean.mockShippingAddress);
        
        Test.stopTest();
        }
    }
}