//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_ctrl_Banner {
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
	public Integer count {get; set; }
	//==================================================
    // SERVICE METHODS
    //==================================================
	public PageReference toggleCounter() {
		if(count == 0)
		{
			count = 1;
		}
		else
		{
			count = 0;
		}
		return null;
	}
	
	
}