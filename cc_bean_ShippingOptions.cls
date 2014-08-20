//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_bean_ShippingOptions { 
	public cc_bean_ShippingOptions() { }
	public cc_bean_ShippingOptions(String provider, Boolean status) {
		this.shippingProvider = provider;
		this.status = status;
	}
	
	//==================================================
	// INSTANCE PROPERTIES
	//==================================================
	public boolean status {get;set;}
	public String shippingProvider {get;set;}
	public List<cc_bean_ShippingServicesAndCostDetails> shippingServicesAndCostDetails {get;set;}
	
	static testMethod void myUnitTest() {
		cc_bean_ShippingOptions bean = new cc_bean_ShippingOptions();
		bean = new cc_bean_ShippingOptions('provider', true);
		System.assertEquals('provider', bean.shippingProvider);
		System.assert(bean.status);
		System.assert(bean.shippingServicesAndCostDetails == null);
	}
}