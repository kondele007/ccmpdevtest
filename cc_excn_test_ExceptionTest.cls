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
 * Unit test for cc_ctrl_ExceptionController
 * 
 * ============================================================
 */
@IsTest
private class cc_excn_test_ExceptionTest { 
    private static final String STORE = 'Default';
    private static final String CART_ID = 'd1c4b2ee-9717-40a8-b5ac-5ef514ed6f8a';
    private static final String IP_ADDRESS_LOCATION = 'VVM=';
    private static final String REF_URL = 'https://licorcraze.ecommsb.cs2.force.com/catalog/MyAccount?cartID=d1c4b2ee-9717-40a8-b5ac-5ef514ed6f8a&g=VVM=&store=env';
    
    private static testmethod void testExceptionControllerWithoutRefUrl(){
        cc_test_PrepTestData.loadCustomSettings();
        PageReference page = new PageReference('/apex/CCException');
        page.getParameters().put('cartID', CART_ID);
        page.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, IP_ADDRESS_LOCATION);
        Test.setCurrentPage(page);

        Test.startTest();

        cc_ctrl_ExceptionController cc_ctrl_ExceptionController = new cc_ctrl_ExceptionController();
        System.assertEquals(CART_ID, page.getParameters().get('cartID'));
        System.assertEquals(IP_ADDRESS_LOCATION, page.getParameters().get(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY));
        
        Test.stopTest();
    }
    
    private static testmethod void testExceptionControllerWithRefUrl(){
        cc_test_PrepTestData.loadCustomSettings();
        PageReference page = new PageReference('/apex/CCException');
        page.getParameters().put('refURL', REF_URL);
        Test.setCurrentPage(page);

        Test.startTest();

        cc_ctrl_ExceptionController cc_ctrl_ExceptionController = new cc_ctrl_ExceptionController();
        System.assertEquals(REF_URL, page.getParameters().get('refURL'));
        
        Test.stopTest();
    }    
}