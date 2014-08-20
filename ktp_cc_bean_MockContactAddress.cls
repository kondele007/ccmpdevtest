//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class ktp_cc_bean_MockContactAddress {
    //==================================================
    // CONSTRUCTOR
    //==================================================
    //dependency injection constructor
    public ktp_cc_bean_MockContactAddress(ccrz__E_ContactAddr__c addr)
    {
        //System.debug('------------------------------ktp_cc_bean_MockContactAddress constructor---------------------------------');
        if(addr != null)
        {
            dataObject = addr;
            try{sfid = addr.Id;}catch(SObjectException e){/*System.debug(e);*/}
            try{address1 = addr.ccrz__AddressFirstline__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{address2 = addr.ccrz__AddressSecondline__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{address3 = addr.ccrz__AddressThirdline__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{city=addr.ccrz__City__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{
                if (addr.ccrz__Country__c == null)
                    country = addr.ccrz__CountryISOCode__c;
                else
                    country = addr.ccrz__Country__c;
            }catch(SObjectException e){/*System.debug(e);*/}
            try{
                if (addr.ccrz__CountryISOCode__c == null)
                    countryCode = addr.ccrz__Country__c;
                else
                    countryCode = addr.ccrz__CountryISOCode__c;
            }catch(SObjectException e){/*System.debug(e);*/}
            try{dayTime = addr.ccrz__DaytimePhone__c;}catch(SObjectException e){/*System.debug(e);*/}
            //try{currencyIsoCode = addr.CurrencyIsoCode;}catch(SObjectException e){/*System.debug(e);*/}
            try{email = addr.ccrz__Email__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{firstName = addr.ccrz__FirstName__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{homePhone = addr.ccrz__HomePhone__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{lastName = addr.ccrz__LastName__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{companyName = addr.ccrz__CompanyName__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{mailStop = addr.ccrz__MailStop__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{middleName = addr.ccrz__MiddleName__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{postalCode = addr.ccrz__PostalCode__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{stateCode = addr.ccrz__StateISOCode__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{state = addr.ccrz__State__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{shippingComments = addr.ccrz__ShippingComments__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{KBSAddressType = addr.KBSAddressType__c;}catch(SObjectException e){/*System.debug(e);*/}
        }
    }
    
    public ktp_cc_bean_MockContactAddress()
    {
        
    }
    //==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public Id sfid {get; set;}
    public String address1 {get; set;}
    public String address2 {get; set;}
    public String address3 {get; set;}
    public String city {get; set;}
    public String contactAddrType {get; set;}
    public String country {get; set;}
    public String countryCode {get; set;}
    //public String currencyIsoCode {get; set;}
    public String dayTime {get; set;}
    public String email {get; set;}
    public String firstName {get; set;}
    public String homePhone {get; set;}
    public String lastName {get; set;}
    public String companyName {get;set;}
    public String mailStop {get; set;}
    public String middleName {get; set;}
    public String postalCode {get; set;}
    public String stateCode {get; set;}
    public String state {get; set;}
    public String shippingComments {get; set;}
    public String KBSAddressType {get; set;}
    public ccrz__E_ContactAddr__c dataObject {
        get {
            if(dataObject == null) { 
                dataObject = new ccrz__E_ContactAddr__c();
            }
            dataObject.ccrz__AddressFirstline__c = address1;
            dataObject.ccrz__AddressSecondline__c = address2;
            dataObject.ccrz__AddressThirdline__c = address3;
            dataObject.ccrz__City__c = city;
            dataObject.ccrz__CompanyName__c = companyName;
            dataObject.ccrz__Country__c = country;
            dataObject.ccrz__CountryISOCode__c = countryCode;
            dataObject.ccrz__DaytimePhone__c = dayTime;
            dataObject.ccrz__Email__c = email;
            dataObject.ccrz__FirstName__c = firstName;
            dataObject.ccrz__HomePhone__c = homePhone;
            dataObject.ccrz__LastName__c = lastName;
            dataObject.ccrz__MailStop__c = mailStop;
            dataObject.ccrz__MiddleName__c = middleName;
            dataObject.ccrz__PostalCode__c = postalCode;
            dataObject.ccrz__State__c = state;
            dataObject.ccrz__StateISOCode__c = stateCode;
            dataObject.ccrz__ShippingComments__c = shippingComments;
            //dataObject.ccrz__KBSAddressType__c = KBSAddressType;
            return dataObject;
        }
        set;
    }
}