//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_bean_MockContactAddress {
    //==================================================
    // CONSTRUCTOR
    //==================================================
    //dependency injection constructor
    public cc_bean_MockContactAddress(E_ContactAddr__c addr)
    {
        //System.debug('------------------------------cc_bean_MockContactAddress constructor---------------------------------');
        if(addr != null)
        {
            dataObject = addr;
            try{sfid = addr.Id;}catch(SObjectException e){/*System.debug(e);*/}
            try{address1 = addr.AddressFirstline__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{address2 = addr.AddressSecondline__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{address3 = addr.AddressThirdline__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{city=addr.City__c;}catch(SObjectException e){/*System.debug(e);*/}
           	try{
            	if (addr.Country__c == null)
            		country = addr.CountryISOCode__c;
            	else
            		country = addr.Country__c;
            }catch(SObjectException e){/*System.debug(e);*/}
            try{
            	if (addr.CountryISOCode__c == null)
            		countryCode = addr.Country__c;
            	else
            		countryCode = addr.CountryISOCode__c;
            }catch(SObjectException e){/*System.debug(e);*/}
            try{dayTime = addr.DaytimePhone__c;}catch(SObjectException e){/*System.debug(e);*/}
            //try{currencyIsoCode = addr.CurrencyIsoCode;}catch(SObjectException e){/*System.debug(e);*/}
            try{email = addr.Email__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{firstName = addr.FirstName__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{homePhone = addr.HomePhone__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{lastName = addr.LastName__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{companyName = addr.CompanyName__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{mailStop = addr.MailStop__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{middleName = addr.MiddleName__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{postalCode = addr.PostalCode__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{stateCode = addr.StateISOCode__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{state = addr.State__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{shippingComments = addr.ShippingComments__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{KBSAddressType = addr.KBSAddressType__c;}catch(SObjectException e){/*System.debug(e);*/}
        }
    }
    
    public cc_bean_MockContactAddress()
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
    public E_ContactAddr__c dataObject {
    	get {
	        if(dataObject == null) { 
	            dataObject = new E_ContactAddr__c();
	        }
	        dataObject.AddressFirstline__c = address1;
	        dataObject.AddressSecondline__c = address2;
	        dataObject.AddressThirdline__c = address3;
	        dataObject.City__c = city;
	        dataObject.CompanyName__c = companyName;
	        dataObject.Country__c = country;
	        dataObject.CountryISOCode__c = countryCode;
	        dataObject.DaytimePhone__c = dayTime;
	        dataObject.Email__c = email;
	        dataObject.FirstName__c = firstName;
	        dataObject.HomePhone__c = homePhone;
	        dataObject.LastName__c = lastName;
	        dataObject.MailStop__c = mailStop;
	        dataObject.MiddleName__c = middleName;
	        dataObject.PostalCode__c = postalCode;
	        dataObject.State__c = state;
	        dataObject.StateISOCode__c = stateCode;
	        dataObject.ShippingComments__c = shippingComments;
			//dataObject.KBSAddressType__c = KBSAddressType;
	        return dataObject;
    	}
    	set;
    }
}