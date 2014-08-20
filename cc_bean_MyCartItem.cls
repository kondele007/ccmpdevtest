//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_bean_MyCartItem {
	//==================================================
	// INSTANCE PROPERTIES
	//==================================================
	public E_Cart__c cart {get;set;}
	public E_ContactAddr__c billingAddress{get;set;}
    public E_ContactAddr__c shippingAddress{get;set;}
	public cc_bean_MockContactAddress mockBillingAddress{get{mockBillingAddress=new cc_bean_MockContactAddress(billingAddress); return mockBillingAddress; } set;}
    public cc_bean_MockContactAddress mockShippingAddress{get{mockShippingAddress=new cc_bean_MockContactAddress(shippingAddress); return mockShippingAddress; }  set;}
	public String status {get;set;}
	public List<E_CartItem__c> cartItems {get;set;}
	//==================================================
    // HELPER METHODS
    //==================================================
	public String getCartStatus() {
		return cart.CartStatus__c;
	}
	public String getShippingName(){
		String name = '';
		if(shippingAddress != null){
			name = shippingAddress.FirstName__c + ' ' 
			+ shippingAddress.MiddleName__c + ' '
			+ shippingAddress.LastName__c;
		}
		return name;
	}	

	public String getBillingName(){
		String name = '';
		if(billingAddress != null){
			name = billingAddress.FirstName__c + ' ' 
			+ billingAddress.MiddleName__c + ' '
			+ billingAddress.LastName__c;
		}
		return name;
	}
	public String getCartEmail(){
		// VALIDATE -- we really should have email in the Order and possibly the Cart.
		// The user could change their email address after having placed an order.
		User user = cc_api_User.getCurrentUser;
		return user.Email;
	}
}