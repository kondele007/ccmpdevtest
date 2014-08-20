//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
/**
 * This controller handles building the support URL.
 * 
 */
public with sharing class cc_ctrl_StoreSupport {
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public String storeID {
    	get {
    		if(storeID == null) {
                storeID = cc_util_CloudCraze.application.Default_Storefront__c;
    		}
    		return storeID;
    	} set;
    }

    public String supportUrl { 
        get {
            E_StorefrontSettings__c settings = E_StorefrontSettings__c.getValues(storeID);
            supportUrl = settings.Support_URL__c;
            //System.debug('-----supportUrl----- : ' + supportUrl);           
            return supportUrl;
        }
        set;
    }         
}