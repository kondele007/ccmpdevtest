//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public abstract class cc_util_ICompositeProduct {
	//==================================================
    // VIRTUAL METHODS
    //==================================================
	public virtual Decimal calAggregatedPrice(E_CartItem__c item) 
	{
		return item.Price__c;
	}
	public virtual void addComponentProductsToCart(E_CartItem__c majorItem, ID accountID, Date targetDate, String currencyCode, String customerType, Boolean fillPrice)
	{
	}
	
}