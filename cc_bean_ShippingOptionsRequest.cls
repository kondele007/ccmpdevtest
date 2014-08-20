//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_bean_ShippingOptionsRequest {  
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public String recepientZipCode {get; set;}
    public String recepientStateCode {get; set;}    
    public String recepientCountryCode {get; set;}
    
    public String cartId {get; set;}
    
    public String store {get; set;}    
    public Decimal dryIceWeight {get; set;}    
    
    public List<cc_bean_ShippingAttributes> shippingAttributesList {get;set;}
    
    public E_StorefrontSettings__c storefront {get; set;}
}