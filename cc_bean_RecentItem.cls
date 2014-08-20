//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_bean_RecentItem {
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public String id {get;set;}
    public String name {get;set;}
    public String cartId {get;set;}
    //==================================================
    // CONSTRUCTOR
    //==================================================
    public cc_bean_RecentItem(String id, String name, String cartId){
        this.id = id;
        this.name = name;
        this.cartId = cartId;
    }
}