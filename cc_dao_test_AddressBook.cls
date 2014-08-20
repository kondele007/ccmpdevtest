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
private class cc_dao_test_AddressBook {

    static testMethod void addressBookTest() {
        //E_Code__c countryCode = cc_test_PrepTestData.insertCode('CountryCode', 'USA', 'America');
        E_ContactAddr__c address = new E_ContactAddr__c(
        AddressFirstline__c='100 Pine Street', City__c='SmallTown', DaytimePhone__c='(847) 555-1212',
        FirstName__c='Craig', HomePhone__c='(847) 555-1212', LastName__c='Traxler',
        PostalCode__c='60601', State__c='Idaho', StateISOCode__c='ID',
        CountryISOCode__c='USA');
        cc_dao_AddressBook test =  new cc_dao_AddressBook();
        ID id = cc_dao_AddressBook.saveAddressDetails(address);
        E_ContactAddr__c addTest = cc_dao_AddressBook.readAddressDetails(id);
        System.assertEquals('100 Pine Street', addTest.AddressFirstline__c);
        cc_dao_AddressBook.deleteAddress(id); 
        List<E_ContactAddr__c> l = [Select e.Id from E_ContactAddr__c e where e.Id = :id and e.isDeleted=false];
        System.assert(l.size() == 0);
        
    }
    
    
}