//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_ctrl_ExceptionController {
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public String currentCartID { get; set; }
	public String ipAddressLocationKey { 
		get {
			return cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY;
		} set; }     
    public String storeID { get; set {
    	   storeID = cc_util_CloudCraze.application.Default_Storefront__c;
    	}
    }
    public String ipAddressLocation{get; set; }
	//==================================================
    // CONSTRUCTOR
    //==================================================
    public cc_ctrl_ExceptionController() {
        //System.debug('-----In cc_ctrl_ExceptionController constructor-----');
        currentCartID = Apexpages.currentPage().getParameters().get('cartID');
        storeID = cc_util_CloudCraze.application.Default_Storefront__c;
        ipAddressLocation = Apexpages.currentPage().getParameters().get(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY);
   		String refURL = Apexpages.currentPage().getParameters().get('refURL');
		//System.debug('-----cc_ctrl_ExceptionController.constructor-Request values- currentCartID|storeID|ipAddressLocation|refURL : ' + currentCartID + '|' + storeID + '|' + ipAddressLocation + '|' + refURL);
   		if (al.StringUtils.isBlank(storeID) || al.StringUtils.isBlank(ipAddressLocation)) {
   			if (al.StringUtils.isNotBlank(refURL)) {
				PageReference pageRef = new PageReference(refURL);
				if (pageRef != null && pageRef.getParameters() != null)  {
					if (al.StringUtils.isNotBlank(cc_util_CloudCraze.application.Default_Storefront__c)) {
						storeID = cc_util_CloudCraze.application.Default_Storefront__c;						
					}
					if (al.StringUtils.isNotBlank(pageRef.getParameters().get(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY))) {
						ipAddressLocation = pageRef.getParameters().get(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY);						
					}
					if (al.StringUtils.isBlank(currentCartID) && al.StringUtils.isNotBlank(pageRef.getParameters().get('cartID'))) {
						currentCartID = pageRef.getParameters().get('cartID');						
					}					
				}
   			}
   		}        
    }
}