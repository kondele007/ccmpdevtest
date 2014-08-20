//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public abstract class cc_hlpr_CompositeProductHelperBase {
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
	public List<cc_bean_ProductListViewData> listViewData { get; set; } 
	//==================================================
    // CONSTRUCTOR
    //==================================================
	public cc_hlpr_CompositeProductHelperBase()
	{
		listViewData = new List<cc_bean_ProductListViewData>();
	}
	//==================================================
    // VIRTUAL METHODS
    //==================================================
	public virtual Decimal calAggregatedPrice(E_CartItem__c item) 
	{
		System.debug('calAggregatedPrice ->' + item);
		return item.SubAmount__c;
	}
	public virtual void addComponentProductsToCart(E_CartItem__c majorItem, ID accountID, Date targetDate, String currencyCode, String customerType, Boolean fillPrice, Map<String, String> selectedAggregate)
	{
	}
}