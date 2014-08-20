//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_bean_Cart_va {
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public Id sfid {get;set;}
    public String encryptedId {get;set;}
    public String name {get;set;}
    public Id buyerContactId {get;set;}
    public cc_bean_MockContactAddress billToAddress {get;set;}
    public cc_bean_MockContactAddress shipToAddress {get;set;}
    public String buyerEmail {get;set;}
    public String buyerFirstName {get;set;}
    public String buyerLastName {get;set;}
    public String buyerPhone {get;set;}
    public String buyerMobilePhone {get;set;}
    public String buyerCompanyName {get;set;}
    public String paymentMethod {get;set;}
    public String poNumber {get;set;}
    public cc_bean_CreditCard creditCard {get;set;} // not saved to db
    public String shippingMethod {get;set;}
    public String currencyCode { get; set; }
    public Double shipAmount {get;set;}
    public E_Cart__c dataObject {
    	get {
	        if(dataObject == null) { 
	            dataObject = new E_Cart__c();
	        }
	        dataObject.Name__c = name;
	        dataObject.Contact__c = buyerContactId;
	        dataObject.BuyerEmail__c = buyerEmail;
	        dataObject.BuyerFirstName__c = buyerFirstName;
	        dataObject.BuyerLastName__c = buyerLastName;
	        dataObject.BuyerPhone__c = buyerPhone;
	        dataObject.BuyerMobilePhone__c = buyerMobilePhone;
	        dataObject.BuyerCompanyName__c = buyerCompanyName;
	        dataObject.PaymentMethod__c = paymentMethod;
	        dataObject.PONumber__c = poNumber;
	        dataObject.ShippingMethod__c = shippingMethod;
	        dataObject.ShipAmount__c = shipAmount;
	        dataObject.CurrencyISOCode__c = currencyCode;

			if(billToAddress != null) {
		        dataObject.BillTo__c = billToAddress.sfid;
			}

			if(shipToAddress != null) {
		        dataObject.ShipTo__c = shipToAddress.sfid;
			}

	        return dataObject;
    	}
    	set;
    }
	
	//==================================================
    // CONSTRUCTORS
    //==================================================
    public cc_bean_cart_va() {
    	creditCard = new cc_bean_CreditCard();
    }
    
	public cc_bean_Cart_va(E_Cart__c cart) {
		this();

		if(cart != null) {
            try{sfid = cart.Id;}catch(SObjectException e){/*System.debug(e);*/}
            try{encryptedId = cart.EncryptedId__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{name = cart.Name__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{buyerContactId = cart.Contact__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{buyerEmail = cart.BuyerEmail__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{buyerFirstName = cart.BuyerFirstName__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{buyerLastName = cart.BuyerLastName__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{buyerPhone = cart.BuyerPhone__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{buyerMobilePhone = cart.BuyerMobilePhone__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{buyerCompanyName = cart.BuyerCompanyName__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{paymentMethod = cart.PaymentMethod__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{poNumber = cart.PONumber__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{shippingMethod = cart.ShippingMethod__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{shipAmount = cart.ShipAmount__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{currencyCode = cart.CurrencyISOCode__c;}catch(SObjectException e){/*System.debug(e);*/}

			if(cart.BillTo__r != null) {
				billToAddress = new cc_bean_MockContactAddress(cart.BillTo__r);
			}

			if(cart.ShipTo__r != null) {
				shipToAddress = new cc_bean_MockContactAddress(cart.ShipTo__r);
			}
			dataObject = cart;
		}
	}
	
	//==================================================
    // INSTANCE METHODS
    //==================================================
	public void populateBuyerInfo(Contact buyer) {
		if(buyer != null) {
			this.buyerCompanyName = buyer.CompanyName__c;
			this.buyerContactId = buyer.Id;
			this.buyerEmail = buyer.Email;
			this.buyerFirstName = buyer.FirstName;
			this.buyerLastName = buyer.LastName;
			this.buyerMobilePhone = buyer.MobilePhone;
			this.buyerPhone = buyer.Phone;
		}
	}
}