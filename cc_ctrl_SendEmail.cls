//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_ctrl_SendEmail {
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
	public String subject { get; set; }
	public String body { get; set; }
	//==================================================
    // CONSTRUCTOR
    //==================================================
	public cc_ctrl_SendEmail(){
	}
	//==================================================
    // SERVICE METHODS
    //==================================================
	public void emailer()
	{
		cc_hlpr_Email eh = new cc_hlpr_Email();
		eh.sendEmail(subject, body);
	}

}