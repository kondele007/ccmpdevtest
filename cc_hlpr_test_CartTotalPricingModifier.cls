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
private class cc_hlpr_test_CartTotalPricingModifier {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        cc_hlpr_CartTotalPricingModifier cartModifier=new cc_hlpr_CartTotalPricingModifier();
        E_Rule__c testRule=new E_Rule__c();
        testRule=cc_test_PrepTestData.insertRule();
        cartModifier.applyModifier(1, 25, testRule.Id);
        
        // TODO: Add meaningful assertion
        System.assert(true);     
    }
}