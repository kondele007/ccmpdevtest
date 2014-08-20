//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_dao_AddressBook {
    //==================================================
    // CONSTRUCTOR  
    //==================================================
    public cc_dao_AddressBook(){
         
    }
    
    //==================================================
    // STATIC METHODS  
    //==================================================
    public static E_ContactAddr__c readAddressDetails(ID ContactAddressID){
        E_ContactAddr__c addressDetails=[
            Select e.State__c, e.PostalCode__c, e.MiddleName__c,  e.LastName__c, e.CompanyName__c, 
                e.Id, e.FirstName__c, e.City__c, e.AddressThirdline__c, e.AddressSecondline__c, 
                e.AddressFirstline__c,e.HomePhone__c, e.DaytimePhone__c, e.StateISOCode__c, e.Country__c,
                e.CountryISOCode__c,e.Email__c, e.MailStop__c, e.KBSAddressType__c
            From E_ContactAddr__c e where e.Id=:ContactAddressID];
        return addressDetails;      
    }
    
    public static ID saveAddressDetails(E_ContactAddr__c address) {
        upsert address;
        return address.Id;
    }

    public static void deleteAddress(ID ContactAddressID) {
        List<E_ContactAddr__c> addressDetails= [
            Select e.State__c, e.PostalCode__c, e.MiddleName__c, e.LastName__c, e.Id, 
            e.FirstName__c, e.City__c, e.AddressThirdline__c, e.AddressSecondline__c, 
            e.AddressFirstline__c,e.HomePhone__c,e.DaytimePhone__c, e.KBSAddressType__c 
        From E_ContactAddr__c e where e.Id=:ContactAddressID];
        if(addressDetails.size() > 0) delete addressDetails;
    }
    
    public static List<E_AddressBook__c> getAddressBooksForAccount(Id accountID) {
        List<E_AddressBook__c> books = null;

        if(accountID != null) {
            books = [select E_ContactAddress__c, Default__c, AddressType__c,
                        E_ContactAddress__r.AddressFirstLine__c,
                        E_ContactAddress__r.AddressSecondLine__c,
                        E_ContactAddress__r.AddressThirdLine__c,
                        E_ContactAddress__r.Email__c,
                        E_ContactAddress__r.MailStop__c,
                        E_ContactAddress__r.CompanyName__c,
                        E_ContactAddress__r.City__c,
                        E_ContactAddress__r.Country__c,
                        E_ContactAddress__r.CountryISOCode__c,
                        E_ContactAddress__r.FirstName__c,
                        E_ContactAddress__r.MiddleName__c,
                        E_ContactAddress__r.LastName__c,
                        E_ContactAddress__r.PostalCode__c,
                        E_ContactAddress__r.State__c,
                        E_ContactAddress__r.StateISOCode__c,
                        E_ContactAddress__r.HomePhone__c,
                        E_ContactAddress__r.DaytimePhone__c
                    from E_AddressBook__c
                    where account__c = :accountID];
        }

        return books;
    }
    
    public static List<E_AddressBook__c> getAddressBooksForAccount(Id accountID, Id addressID) {
        List<E_AddressBook__c> books = null;

        if(accountID != null && addressID != null) {
            books = [select E_ContactAddress__c, Default__c, AddressType__c,
                        E_ContactAddress__r.AddressFirstLine__c,
                        E_ContactAddress__r.AddressSecondLine__c,
                        E_ContactAddress__r.AddressThirdLine__c,
                        E_ContactAddress__r.Email__c,
                        E_ContactAddress__r.MailStop__c,
                        E_ContactAddress__r.CompanyName__c,
                        E_ContactAddress__r.City__c,
                        E_ContactAddress__r.Country__c,
                        E_ContactAddress__r.CountryISOCode__c,
                        E_ContactAddress__r.FirstName__c,
                        E_ContactAddress__r.MiddleName__c,
                        E_ContactAddress__r.LastName__c,
                        E_ContactAddress__r.PostalCode__c,
                        E_ContactAddress__r.State__c,
                        E_ContactAddress__r.StateISOCode__c,
                        E_ContactAddress__r.HomePhone__c,
                        E_ContactAddress__r.DaytimePhone__c
                    from E_AddressBook__c
                    where account__c = :accountID
                      and E_ContactAddress__c = :addressID];
        }

        return books;
    }
    
    public static Id upsertAddress(cc_bean_MockContactAddress addressBean) {
        Id addressId = null;
        System.debug('--- cc_dao_AddressBook.upsertAddress: addressBean=' + addressBean);
        E_ContactAddr__c address = addressBean.dataObject;

        if(addressBean.sfid == null) {
            //insert
            try {
                insert address;
                System.debug('--- cc_dao_AddressBook.upsertAddress: address after insert=' + address);
                addressId = address.Id;
            } catch(DmlException e) {
                System.debug('--- cc_dao_AddressBook.upsertAddress: ERROR: exception inserting address: ' + e.getMessage());
            }
        } else {
            //update
            try {
                update address;
                System.debug('--- cc_dao_AddressBook.upsertAddress: address after update=' + address);
                addressId = address.Id;
            } catch(DmlException e) {
                System.debug('--- cc_dao_AddressBook.upsertAddress: ERROR: exception updating address: ' + e.getMessage());
            }
        }
        return addressId;
    }
    
    /**
     * delete the address book entries for the given user and address
     * the address itself is not deleted here
     */
    public static String deleteAddressBooks(Id accountID, Id addressID) {
        String result = 'failed';

        if(accountID != null && addressID != null) {
            List<E_AddressBook__c> oldBooks = cc_dao_AddressBook.getAddressBooksForAccount(accountID, addressID);
            if(oldBooks.size() > 0) {
                try {
                    delete oldBooks;
                    result = 'success';
                } catch(DmlException e) {
                    System.debug('--- cc_dao_AddressBook.deleteAddressBooks: ERROR: exception deleting address books: ' + e.getMessage());
                }
            } else {
                result = 'success';
            }
        }

        return result;
    }
    
    public static String insertAddressBooks(Id accountID, Id addressID, List<cc_bean_AddressBook.AddressTypeInfo> addressTypes) {
        String result = 'failed';
        System.debug('--- cc_dao_AddressBook.insertAddressBooks: accountID=' + accountID + ', addressTypes=' + addressTypes);
        if(accountID != null && addressID != null && addressTypes != null && addressTypes.size() > 0) {
            List<E_AddressBook__c> addressBooks = new List<E_AddressBook__c>();
            for(cc_bean_AddressBook.AddressTypeInfo addressType : addressTypes) {
                E_AddressBook__c addressBook = new E_AddressBook__c();
                addressBook.Account__c = accountID;
                addressBook.E_ContactAddress__c = addressID;
                addressBook.AddressType__c = addressType.addressType;
                addressBook.Default__c = addressType.isDefault;
                addressBooks.add(addressBook);
            }
            try {
                insert addressBooks;
                result = 'success';
            } catch(DmlException e) {
                System.debug('--- cc_dao_AddressBook.insertAddressBooks: ERROR: exception inserting address books: ' + e.getMessage());
            }
        } else {
            result = 'success';
        }
        return result;
    }
}