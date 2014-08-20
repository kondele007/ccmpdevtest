//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_bean_ProductForm {

	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public cc_bean_Product product { get; set; }
    public List<cc_bean_ProductListViewData> relatedItems {get;set;}
    public Decimal basePrice { get; set; }
    /*
    	flag aggregatedProductState indicates:
    	None: current product is not an aggregated product
    	Top: current product is an aggregated product
    	Child: current product is not an aggregated product but at least one of its child components is an aggregated product
    */
	public String aggregatedProductState { get; set; } 
	public List<cc_util_CompositeProduct.NamedSelectOptionList> aggregatedProductAggregates { get; set; }

	//==================================================
    // TRANSIENT INSTANCE PROPERTIES
    //==================================================
    transient public List<Id> pictures {get;set;}
    transient public List<cc_bean_EProductImageID> imageIds {get;set;}
    transient public Id groupId {get; set;}
    transient public String mainImage {get; set; }
    transient public String thumbImage {get; set; } 
    transient public String sourceType { get; set; }
    transient public String Alt_Message {get; set; }
    transient public List<cc_bean_ProductTab> tabs {get;set;}
    transient public Decimal productInventory {get;set;}
    transient public cc_bean_PriceInfo priceBean {get; set; }
	transient public List<cc_bean_ProductListViewData> aggregatesViewData { get; set; }
}