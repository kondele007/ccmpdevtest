//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_bean_SelectableProduct {
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
	public cc_bean_ProductListViewData productListViewData {get;set;}
	public Boolean selected {
		get{
			if(selected == null){
				selected = false;
			}
			return selected;
		}
		set;
	}

}