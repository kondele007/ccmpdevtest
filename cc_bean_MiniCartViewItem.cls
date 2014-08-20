//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_bean_MiniCartViewItem { 
	//==================================================
   // INSTANCE PROPERTIES
   //==================================================
	public cc_bean_MockCartItem mockCartItem { get; set; }
    public E_CartItem__c item { get; set; }
    public Id thumbnailId { get; set; }
    public cc_bean_MediaWrapper mediaWrapper {get; set; }
    public boolean isReleased { get; set; }    
}