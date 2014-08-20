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
 * This class is used to check, if the user location is restricted.
 */ 
public with sharing class cc_dao_UserLocationHandler {
	//==================================================
    // SERVICE METHODS
    //==================================================
    /**
     * This method is used to check, if the IP address location is restricted.
     */    
    public static boolean isUserLocationRestricted(String countryCode) {
        System.debug('--- cc_dao_UserLocationHandler.isUserLocationRestricted: countryCode=' + countryCode);
        boolean isUserLocationRestricted = false;
        if(countryCode != null) {
	        CountryCode__c country = CountryCode__c.getInstance(countryCode);
	        System.debug('--- cc_dao_UserLocationHandler.isUserLocationRestricted: country=' + country);
	        if (country != null && !country.AllowAccess__c) {
	            isUserLocationRestricted = true;
	        }
        }
        System.debug('--- cc_dao_UserLocationHandler.isUserLocationRestricted: returning isUserLocationRestricted=' + isUserLocationRestricted);
        return isUserLocationRestricted;
    }
    
    static testMethod void myUnitTest() {
    	cc_test_TestDataSetup.loadData();
    	System.assertEquals(false, cc_dao_UserLocationHandler.isUserLocationRestricted('US'));  // test data is set up with US as allowed
    	System.assertEquals(true, cc_dao_UserLocationHandler.isUserLocationRestricted('CA')); // test data is set up with CA as restricted
    	System.assertEquals(false, cc_dao_UserLocationHandler.isUserLocationRestricted('nomatchblahblahblah'));
    	System.assertEquals(false, cc_dao_UserLocationHandler.isUserLocationRestricted(null));
    }
}