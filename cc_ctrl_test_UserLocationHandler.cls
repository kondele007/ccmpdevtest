//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
/* ============================================================
 * Unit test for cc_ctrl_UserLocationHandler
 * 
 * ============================================================
 */
@IsTest
private class cc_ctrl_test_UserLocationHandler { 

	private static void prepTestData() {
        cc_test_PrepTestData.loadCustomSettings();
        cc_test_PrepTestData.loadInitData();
	}

    private static testmethod void testlocationHandlerWithValidCountryCodes(){
    	cc_ctrl_test_UserLocationHandler.prepTestData();
    	Test.startTest();

        cc_ctrl_UserLocationHandler cc_ctrl_UserLocationHandler = new cc_ctrl_UserLocationHandler();

        cc_ctrl_UserLocationHandler.countryCode = 'US';
        Pagereference page = cc_ctrl_UserLocationHandler.locationHandler();
        String ipAddressLocation = page.getParameters().get(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY);
        //System.debug('-----ipAddressLocation----- : ' + ipAddressLocation);
        
        System.assertEquals('US', Encodingutil.base64Decode(ipAddressLocation).toString());
        System.assertEquals(true, page.getRedirect());

        cc_ctrl_UserLocationHandler.countryCode = 'CA';
        page = cc_ctrl_UserLocationHandler.locationHandler();
        ipAddressLocation = page.getParameters().get(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY);
        //System.debug('-----ipAddressLocation----- : ' + ipAddressLocation);    
        
        System.assertEquals('CA', Encodingutil.base64Decode(ipAddressLocation).toString());
        System.assertEquals(true, page.getRedirect());
        
        Test.stopTest();
    }
    
    private static testmethod void testlocationHandlerWithRestrictedCountryCodes(){
        cc_ctrl_test_UserLocationHandler.prepTestData();
        Test.startTest();

        cc_ctrl_UserLocationHandler cc_ctrl_UserLocationHandler = new cc_ctrl_UserLocationHandler();
        
        cc_ctrl_UserLocationHandler.countryCode = 'CU';
        Pagereference page = cc_ctrl_UserLocationHandler.locationHandler();
        String ipAddressLocation = page.getParameters().get(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY);
        //System.debug('-----ipAddressLocation----- : ' + ipAddressLocation);     
        
        System.assertEquals(true, page.getRedirect());

        cc_ctrl_UserLocationHandler.countryCode = 'IR';
        page = cc_ctrl_UserLocationHandler.locationHandler();
        ipAddressLocation = page.getParameters().get(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY);
      
        //System.debug('-----ipAddressLocation----- : ' + ipAddressLocation);     
        System.assertEquals(true, page.getRedirect());
        
        Test.stopTest();
    }    
    
    private static testmethod void testlocationHandlerWithNoCountryCodes(){
        cc_ctrl_test_UserLocationHandler.prepTestData();
        Test.startTest();

        cc_ctrl_UserLocationHandler cc_ctrl_UserLocationHandler = new cc_ctrl_UserLocationHandler();

        cc_ctrl_UserLocationHandler.countryCode = '';
        Pagereference page = cc_ctrl_UserLocationHandler.locationHandler();
        String ipAddressLocation = page.getParameters().get(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY);
        //System.debug('-----ipAddressLocation----- : ' + ipAddressLocation);     
        
        System.assertEquals(true, page.getRedirect());
        
        cc_ctrl_UserLocationHandler.countryCode = null;
        page = cc_ctrl_UserLocationHandler.locationHandler();
        ipAddressLocation = page.getParameters().get(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY);
        //System.debug('-----ipAddressLocation----- : ' + ipAddressLocation);     
       
        System.assertEquals(true, page.getRedirect());
        System.AssertNotEquals(null, cc_ctrl_UserLocationHandler.googlePathAndKey);
        
        Test.stopTest();
    }    

    private static testmethod void testlocationHandlerWithCategoryId(){
        cc_ctrl_test_UserLocationHandler.prepTestData();
        Test.startTest();

        cc_ctrl_UserLocationHandler cc_ctrl_UserLocationHandler = new cc_ctrl_UserLocationHandler();

        cc_ctrl_UserLocationHandler.countryCode = 'US';
        cc_ctrl_UserLocationHandler.categoryId = 'a0bR0000001ENSwIAO';
        
        Pagereference page = cc_ctrl_UserLocationHandler.locationHandler();
        String category = page.getParameters().get('categoryId');
        //System.debug('-----category----- : ' + category);
        System.assertEquals('a0bR0000001ENSwIAO', category);
        System.assertEquals(true, page.getRedirect());
        
        Test.stopTest();
    }
    
    private static testmethod void testlocationHandlerWithSku(){
        cc_ctrl_test_UserLocationHandler.prepTestData();
        Test.startTest();

        cc_ctrl_UserLocationHandler cc_ctrl_UserLocationHandler = new cc_ctrl_UserLocationHandler();

        cc_ctrl_UserLocationHandler.countryCode = 'US';
        cc_ctrl_UserLocationHandler.sku = '9201-01';
        
        Pagereference page = cc_ctrl_UserLocationHandler.locationHandler();
        String skuValue = page.getParameters().get('sku');
        //System.debug('-----sku----- : ' + skuValue);
        System.assertEquals('9201-01', skuValue);
        System.assertEquals(true, page.getRedirect());
        
        Test.stopTest();
    }   
   
    private static testmethod void testlocationHandlerWithCategoryIdandSku(){
        cc_ctrl_test_UserLocationHandler.prepTestData();
        Test.startTest();

        cc_ctrl_UserLocationHandler cc_ctrl_UserLocationHandler = new cc_ctrl_UserLocationHandler();

        cc_ctrl_UserLocationHandler.countryCode = 'US';
        cc_ctrl_UserLocationHandler.categoryId = 'a0bR0000001ENSwIAO';
        cc_ctrl_UserLocationHandler.sku = '9201-01';
        
        Pagereference page = cc_ctrl_UserLocationHandler.locationHandler();
        String skuValue = page.getParameters().get('sku');
        //System.debug('-----sku----- : ' + skuValue);
        System.assertEquals('9201-01', skuValue);
        System.assertEquals(true, page.getRedirect());
        
        Test.stopTest();
    }      
}