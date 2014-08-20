//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
@isTest

private class cc_cnst_test_CloudCraze {

    static testMethod void testConstants() {
       // System.assertEquals(cc_cnst_CloudCraze.ENV_STORE, cc_util_CloudCraze.application.Default_Storefront__c);
       // System.assertEquals(cc_cnst_CloudCraze.BIO_STORE, cc_util_CloudCraze.application.Default_Storefront__c);
        cc_test_TestDataSetup.loadData();
    	System.RunAs(cc_test_TestDataSetup.testUser){
        System.assertEquals(cc_cnst_CloudCraze.SHIPFROM_ZIPCODE, '68504');
        System.assertEquals(cc_cnst_CloudCraze.SHIPFROM_COUNTRYCODE, 'US');
        
        System.assertEquals(cc_cnst_CloudCraze.GROUNDFLAG, 'groundflag');
        System.assertEquals(cc_cnst_CloudCraze.OVERNIGHTFLAG, 'overnightflag');
        
        System.assertEquals(cc_cnst_CloudCraze.DRYICEFLAG, 'dryiceflag');
        System.assertEquals(cc_cnst_CloudCraze.COOLERPAKFLAG, 'coolerpakflag');
        
        System.assertEquals(cc_cnst_CloudCraze.HAZARDOUSFLAG, 'hazardousflag');
        System.assertEquals(cc_cnst_CloudCraze.HAZARDOUSOUTSIDE48FLAG, 'hazardousoutside48flag');
        
        System.assertEquals(cc_cnst_CloudCraze.SHIP_WEIGHT, 'weight');
        System.assertEquals(cc_cnst_CloudCraze.DRYICEWEIGHT, 'dryiceweight'); 
        
        System.assertEquals(cc_cnst_CloudCraze.PASSWORD_SENT, 'A new password was sent');
        System.assertEquals(cc_cnst_CloudCraze.INVALID_USERNAME_PWD, 'Invalid login or password.');
        
        System.assertEquals(cc_cnst_CloudCraze.ATTACHMENTS_THUMBNAIL_IMAGE_SOQL_PATTERN, '%_thumb%');
        System.assertEquals(cc_cnst_CloudCraze.ATTACHMENTS_STANDARD_IMAGE_SOQL_PATTERN, '%\\_%');
        System.assertEquals(cc_cnst_CloudCraze.ATTACHMENTS_LARGE_IMAGE_SOQL_PATTERN, '%_large%');
        System.assertEquals(cc_cnst_CloudCraze.ATTACHMENTS_XL_IMAGE_SOQL_PATTERN, '%_xl%');
    	}
    }
}