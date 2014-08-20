//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_bean_ProductListViewData {
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public E_Product__c product {get; set; }
    public E_PriceListItem__c priceListItem {get; set {priceListItem=value; cc_bean_MockPriceListItem=new cc_bean_MockPriceListItem(priceListItem);} }
    public cc_bean_PriceInfo priceBean {get; set; }
    public E_CompositeProduct__c compositeProductObj { get; set; }
    public double averageReview {get; set; } 
    public String attachmentID { get; set; }
    public cc_bean_MediaWrapper mediaWrapper { get; set; }
    public String Alt_Message {get; set;}
    public cc_bean_MockProduct mockProduct { get; set; }
    public cc_bean_Product ccProduct { get; set; }
    public cc_bean_MockPriceListItem cc_bean_MockPriceListItem { get; set; } 
    // Fields for I18N
    public String name { get; set; }
    public String short_desc { get; set; }
    public String long_desc { get; set; }
    public Boolean optional { get; set; }
    public Integer qty { get; set; }
    public String category { get; set; }
    public String categoryId { get; set; }
     public Integer lines { get; set; }
    public String voiceMail { get; set; }
    public String expandable { get; set; }
	public Decimal productInventory {get; set; }
    public Integer productSearchRank { get; set; }
	public Decimal sortRank {get;set;}
	public Decimal basePrice { get; set; }
}