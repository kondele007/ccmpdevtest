//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
/**
 * This class provides the implementation for handling the user's location.
 * 
 */
public with sharing class cc_api_UserLocationHandler {
	//==================================================
    // SERVICE METHODS
    //==================================================
    /**
     * This method is used to check, if the user's location is restricted.
     */ 
    public boolean isUserLocationRestricted(String countryCode){
        return cc_dao_UserLocationHandler.isUserLocationRestricted(countryCode);
    }       
}