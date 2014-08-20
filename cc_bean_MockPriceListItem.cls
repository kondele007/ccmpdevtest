//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_bean_MockPriceListItem {
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
	public Decimal price {get;set;}
	//==================================================
    // CONSTRUCTOR
    //==================================================
	public cc_bean_MockPriceListItem(E_PriceListItem__c item) 
	{
		price = item.Price__c;
	}
}