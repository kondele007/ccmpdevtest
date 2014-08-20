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
private class cc_util_test_Search {

    static testMethod void myUnitTest() {
        String returnAttribute = 'E_Product__c(Id, Name, SKU__c, ShortDesc__c, ProductStatus__c WHERE ProductStatus__c IN (\'' + cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED + '\', \'' + cc_cnst_PickListConstants.PRODUCTSTATUS_NOTORDERABLE + '\'))';
        System.AssertNotEquals(null, cc_util_Search.searchObjects('search', returnAttribute));
    }
}