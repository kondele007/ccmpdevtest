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
private class cc_bean_test_MockContactAddress {
     static testMethod void myUnitTest() {
        //cc_test_PrepTestData.cleanCodeObject();
        //E_Code__c countryCode = cc_test_PrepTestData.insertCode('CountryCode', 'USA', 'America');
        E_ContactAddr__c address = new E_ContactAddr__c(
        AddressFirstline__c='100 Pine Street', City__c='SmallTown', DaytimePhone__c='(847) 555-1212',
        FirstName__c='Craig', HomePhone__c='(847) 555-1212', LastName__c='Traxler',
        PostalCode__c='60601', State__c='Idaho', StateISOCode__c='ID',
        CountryISOCode__c='US');
        cc_dao_AddressBook test =  new cc_dao_AddressBook();
        ID id = cc_dao_AddressBook.saveAddressDetails(address);
        cc_bean_MockContactAddress mockAddress1 = new cc_bean_MockContactAddress();
        cc_bean_MockContactAddress mockAddress = new cc_bean_MockContactAddress(address);
        System.assertEquals(address.Id, mockAddress.sfid);
        System.assertEquals('100 Pine Street', mockAddress.address1);
    }
}