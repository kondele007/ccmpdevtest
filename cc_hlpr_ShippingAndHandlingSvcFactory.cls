//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_hlpr_ShippingAndHandlingSvcFactory { 
	//==================================================
    // STATIC INSTANCE VARIABLES
    //================================================== 
	public static cc_svc_IShippingAndHandling shippingAndHandlingservice;
	//==================================================
    // STATIC SERVICE METHODS
    //==================================================
	public static cc_svc_IShippingAndHandling getShippingAndHandlingService(E_StorefrontSettings__c storefront){
		if(storefront == null)
			System.debug('-------00000000StoreFront is null');
		if(Test.isRunningTest() || cc_util_CloudCraze.isInDevMode(storefront)) {
			shippingAndHandlingservice = new cc_svc_ShippingAndHandlingGeneric(storefront);
		} else if(storefront.UseUPSShipping__c) { 
			shippingAndHandlingservice = new cc_svc_ShippingAndHandlingUPS(storefront);
		} else if(storefront.UseFexExShipping__c) {
			shippingAndHandlingservice = new cc_svc_ShippingAndHandlingFedEx(storefront);
		} else {
		    shippingAndHandlingservice = null;
		}
		
		return shippingAndHandlingservice; 
	} 
}