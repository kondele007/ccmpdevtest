//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_ctrl_GetSession {
	//==================================================
    // SERVICE METHODS
    //==================================================
    public String getMySessionId() {
        return UserInfo.getSessionId();
    }

}