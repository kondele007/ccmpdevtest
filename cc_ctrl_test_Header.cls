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
private class cc_ctrl_test_Header {
	static testMethod void testConstructor() {
		cc_test_TestDataSetup.loadData();
		System.RunAs(cc_test_TestDataSetup.testUser){
			cc_api_Cart api = new cc_api_Cart();        
			E_Cart__c cart = api.createEmptyCart('USD', 'Commercial');
			List<E_Product__c> products = cc_test_PrepTestData.insertProduct(2);
			List<E_CartItem__c> cartItems = cc_test_PrepTestData.insertCartItems(products, cart.Id);
			
			PageReference page = new PageReference('/apex/Heaer');
			page.getParameters().put('cartID', cart.Id);
			Test.setCurrentPage(page);
	
			Test.startTest();
			cc_ctrl_CloudCraze ctrlCC = new cc_ctrl_CloudCraze();
			cc_ctrl_Header ctrlHeader = new cc_ctrl_Header();
			ctrlHeader.ccCtrl = ctrlCC;
			System.AssertEquals(2, ctrlCC.getCCCartItemCount());
			
			// System.debug('--- controller.googleAnalyticsAcountIdAndPropIndex=' + controller.googleAnalyticsAcountIdAndPropIndex);
			ctrlHeader.searchString = 'product name';
			System.assert(ctrlHeader.quickSearch() != null);
			System.assert(ctrlheader.editCart() != null);
			Test.stopTest();
		}
	}
}