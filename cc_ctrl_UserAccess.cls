//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_ctrl_UserAccess {
	//==================================================
    // INSTANCE VARIABLES
    //==================================================
    private ApexPages.StandardController controller;
    //==================================================
    // CONSTRUCTOR
    //==================================================
    public cc_ctrl_UserAccess(ApexPages.StandardController c){
        this.controller=c;
    }
    //==================================================
    // SERVICE METHODS
    //==================================================
    //This function controls if current user can access current page. This is for user access such as
    //Product Manager and Pricing Manager
    public boolean getCanAccess()
    {
        return true;
    }
}