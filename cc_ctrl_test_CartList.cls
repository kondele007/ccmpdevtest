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
private class cc_ctrl_test_CartList {

    static testMethod void testSelectOptionMethods() {
        cc_test_PrepTestData.loadCustomSettings();
        Test.startTest();
        
        cc_ctrl_MyAccount myAccount = new cc_ctrl_MyAccount();
        cc_ctrl_CartList cartList = new cc_ctrl_CartList(myAccount);
        System.assertNotEquals(null, cartList.statusCodes);
        myAccount.viewState=myAccount.CARTS_VIEW;
        
        Test.stopTest();
    }

    static testMethod void testgetCartList(){
        cc_test_PrepTestData.loadCustomSettings();
        Test.startTest();

        cc_ctrl_MyAccount myAccount = new cc_ctrl_MyAccount();
        cc_ctrl_CartList cartList = new cc_ctrl_CartList(myAccount);
        E_Cart__c cart = insertCart(true, cc_cnst_PickListConstants.CARTSTATUS_OPEN);
        System.assertNotEquals(null, cartList.getCartList());
        
        Test.stopTest();
    }
    static testMethod void testDisplayCartSummary(){
        //cc_test_PrepTestData.loadCustomSettings();
        cc_test_TestDataSetup.loadData();
		System.runas(cc_test_TestDataSetup.testUser) {
        Test.startTest();

        cc_ctrl_MyAccount myAccount = new cc_ctrl_MyAccount();
        cc_ctrl_CartList cartList = new cc_ctrl_CartList(myAccount);
        cc_api_Cart capi = new cc_api_Cart();
        E_Cart__c cart1 = capi.createEmptyCart();
        E_Cart__c cart2 = capi.createEmptyCart();
        cartList.status = 'Open';
        cartList.searchCarts();
        System.Assert(2 <= cartList.getCartList().size());
        
        Test.stopTest();
		}
    }
    
    static testMethod void testEmptyConstructor() {
        cc_test_PrepTestData.loadCustomSettings();
        System.assert([Select c.Id From E_ApplicationSettings__c c where name='CloudCraze'].size() != 0);
        Test.startTest();

    	cc_ctrl_CartList controller = new cc_ctrl_CartList();
    	//System.assert(controller.store == cc_util_CloudCraze.application.Default_Storefront__c);
    	String store = cc_util_CloudCraze.application.Default_Storefront__c;
    	
    	Test.stopTest();
    }

    private static E_Cart__c insertCart(Boolean activeCart, String cartStatus){
        E_Cart__c cartHeader = new E_Cart__c();
        cartHeader.CartStatus__c = cartStatus;
        cartHeader.User__c = UserInfo.getUserId();
        cartHeader.Name__c = 'Dummy Cart Name';
        cartHeader.OwnerId = UserInfo.getUserId();
        cartHeader.AnonymousID__c = false;
        cartHeader.ActiveCart__c = activeCart;
        cartHeader.SessionID__c = 'dummy session';
        insert cartHeader;
        return cartHeader;
    }   
}