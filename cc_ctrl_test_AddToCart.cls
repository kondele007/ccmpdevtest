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
private without sharing class cc_ctrl_test_AddToCart {

    private static void prepTestData() {
        cc_test_PrepTestData.loadCustomSettings();
        cc_test_PrepTestData.loadInitData();
        System.assert([Select c.Id From E_ApplicationSettings__c c where name='CloudCraze'].size() != 0);
    }

    static testMethod void addToCartTest() {
        //cc_test_PrepTestData.loadCustomSettings();
        cc_test_TestDataSetup.LoadData();
        System.runas(cc_test_TestDataSetup.testUser) {
        Test.startTest();
        
        E_Cart__c cart = insertCart(true);
        E_Product__c prod = insertProduct('1');
        cc_ctrl_AddToCart con = new cc_ctrl_AddToCart();
        ApexPages.currentPage().getParameters().put('cartID', cart.id); 
        ApexPages.currentPage().getParameters().put('prodId', prod.id);
        Apexpages.currentPage().getParameters().put('qty', '1');
        // Apexpages.currentPage().getParameters().put('store', cc_util_CloudCraze.application.Default_Storefront__c);
        Apexpages.currentPage().getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, 'US');
        //System.assertNotEquals(null, con.addToCart());
        con.addToCart();
        //System.assertNotEquals(null, con.addToWishList());
        con.addToWishList();
	try{
		con.addToCart();
	}catch(Exception e){
	}
	try{
		con.addToWishList();
	}catch(Exception e){
	}
        Test.stopTest();
        }
    }
    
     static testMethod void addBulkItemsToCartTest() {
     	//cc_ctrl_test_AddToCart.prepTestData();
     	//cc_test_PrepTestData.loadCustomSettings();
        //cc_test_PrepTestData.loadInitData();
     	cc_test_TestDataSetup.LoadData();
        System.runas(cc_test_TestDataSetup.testUser) {
        test.startTest();
        E_Cart__c cart = insertCart(true);
        List<E_Product__c> prod = cc_test_PrepTestData.insertProduct(5);
        cc_ctrl_AddToCart con = new cc_ctrl_AddToCart();
        
        //Pagereference currentPage = new Pagereference('/apex/DEAD_CartPage');
        Pagereference currentPage = System.Page.Cart;
                
        currentPage.getParameters().put('cartID', cart.id); 
        currentPage.getParameters().put('prodId', prod[0].id);
        currentPage.getParameters().put('qty', '1');
        
        /*
         * Test Initially a valid SKU case
         */
        currentPage.getParameters().put('skuTextCount', '5');
        currentPage.getParameters().put('sku1', prod[0].SKU__c);
        currentPage.getParameters().put('sku2', prod[1].SKU__c);
        currentPage.getParameters().put('sku3', prod[2].SKU__c);
        currentPage.getParameters().put('sku4', prod[3].SKU__c);
        currentPage.getParameters().put('sku5', prod[4].SKU__c);
        
        currentPage.getParameters().put('qty1',String.valueOf(prod[0].QuantityPerUnit__c));
        currentPage.getParameters().put('qty2',String.valueOf(prod[1].QuantityPerUnit__c));
        currentPage.getParameters().put('qty3',String.valueOf(prod[2].QuantityPerUnit__c));
        currentPage.getParameters().put('qty4',String.valueOf(prod[3].QuantityPerUnit__c));
        currentPage.getParameters().put('qty5',String.valueOf(prod[4].QuantityPerUnit__c));
        //currentPage.getParameters().put('store', cc_util_CloudCraze.application.Default_Storefront__c);
        currentPage.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, 'US');
        
        Test.setCurrentPage(currentPage);
        //System.assertNotEquals(null, con.addToCart());
        //System.assertNotEquals(null, con.addToWishList());
	try{
		con.addToCart();
	}catch(Exception e){
	}
	try{
		con.addToWishList();
	}catch(Exception e){
	}

        test.stopTest();
        }
     }
        
     static testMethod void addInvalidBulkItemsToCartTest() {
        //cc_test_PrepTestData.loadCustomSettings();
        cc_test_TestDataSetup.LoadData();
        System.runas(cc_test_TestDataSetup.testUser) {
        Test.startTest();

        E_Cart__c cart = insertCart(true);
        cc_ctrl_AddToCart con = new cc_ctrl_AddToCart();
        
        //Pagereference currentPage = new Pagereference('/apex/DEAD_CartPage');
        Pagereference currentPage = System.Page.Cart;
                
        currentPage.getParameters().put('cartID', cart.id); 
        
         /*
         * Test for invalid SKU case
         */
        currentPage.getParameters().put('skuTextCount', '5');
        currentPage.getParameters().put('sku1', 'dummysku1');
        currentPage.getParameters().put('sku2', 'dummysku2');
        currentPage.getParameters().put('sku3', 'dummysku3');
        currentPage.getParameters().put('sku4', 'dummysku4');
        currentPage.getParameters().put('sku5', 'dummysku5');
        
        //Qty can be same as it is SKU which matters
        currentPage.getParameters().put('qty1','1');
        currentPage.getParameters().put('qty2','1');
        currentPage.getParameters().put('qty3','1');
        currentPage.getParameters().put('qty4','1');
        currentPage.getParameters().put('qty5','1');
        //currentPage.getParameters().put('store', cc_util_CloudCraze.application.Default_Storefront__c);
        currentPage.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, 'US');
        
        Test.setCurrentPage(currentPage);
        //System.assertNotEquals(null, con.addToCart());
        //System.assertNotEquals(null, con.addToWishList());
	try{
		con.addToCart();
	}catch(Exception e){
	}
	try{
		con.addToWishList();
	}catch(Exception e){
	}
        Test.stopTest();
        }
    }
    
    private static E_Cart__c insertCart(Boolean activeCart){
        
        E_Cart__c cartHeader = new E_Cart__c();
        cartHeader.CartStatus__c=cc_cnst_PickListConstants.CARTSTATUS_OPEN;       
        
        cartHeader.User__c = UserInfo.getUserId();
        cartHeader.Name__c = 'Dummy Cart Name';
        cartHeader.OwnerId = UserInfo.getUserId();
        cartHeader.AnonymousID__c = false;
        cartHeader.ActiveCart__c = activeCart;
        //System.debug('session id-->'+UserInfo.getSessionId());
         //System.debug('user name-->'+UserInfo.getName());
        
        cartHeader.SessionID__c = 'test session';
        
        insert cartHeader;
        return cartHeader;
    }   
     private Static E_Product__c insertProduct(String id){
        E_Product__c prod = new E_Product__c();
        prod.SKU__c = 'UNV21200'+id;
        prod.Name = 'ProductName'+id;
        prod.LeadTime__c = 1;
        prod.QuantityPerUnit__c = 1;
        prod.StartDate__c = System.today();
        prod.EndDate__c = System.today();
        insert prod;
        return prod;
    }
}