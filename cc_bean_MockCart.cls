//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_bean_MockCart {
    //==================================================
    // INSTANCE PROPERTIES
    //==================================================
	public DateTime lastModifiedDate { get; set; }
	public String cartId { get; set; }
	public String cartSFDCName { get; set; }
	public String cartName { get; set; }
	public Decimal cartSubAmount { get; set; }
	public boolean ActiveCart { get; set; }
	public String status { get; set; }
	public Decimal discounts { get; set; }
	public Decimal totalAmount { get; set; }

	//==================================================
    // CONSTRUCTOR
    //==================================================
	public cc_bean_MockCart(E_Cart__c cart) {
		this.lastModifiedDate = cart.LastModifiedDate;
		this.cartId = cart.id;
		this.cartSFDCName = cart.name;
		this.cartName = cart.Name__c;
		this.cartSubAmount = cart.SubtotalAmount_2__c;
		this.status = cart.CartStatus__c;
		this.ActiveCart = cart.ActiveCart__c;
		this.discounts = cart.TotalDiscount__c;
		this.totalAmount = cart.TotalAmount__c;
	}
	
	public cc_bean_MockCart(cc_bean_MyCartItem myCart) {
		this(myCart.cart);
		
	}
	
	
}