//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_bean_ShippingServicesAndCostDetails {  
	public cc_bean_ShippingServicesAndCostDetails() {
		
	}
	public cc_bean_ShippingServicesAndCostDetails(String service, String currencyCode, String cost, String discount) {
		this.shipService = service;
		this.currencyCode = currencyCode;
		this.shipCost = cost;
		this.discountedShipCost = discount;
	}
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public String shipService {get; set;}
    public String currencyCode {get; set;}
    public String shipCost {get; set;}
    public String discountedShipCost {get; set;}    
}