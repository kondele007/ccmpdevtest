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
private class cc_ctrl_test_QuickOrder {
	// Could not deploy to Qualcomm with this test class

	static testMethod void testAddToCartBulkItems() {
		cc_test_TestDataSetup.loadData();
		System.RunAs(cc_test_TestDataSetup.testUser) {
		//cc_test_PrepTestData.loadCustomSettings();
		List<cc_ctrl_QuickOrder.skuText> skuTextList = new List<cc_ctrl_QuickOrder.skuText>();
		Integer count = 0;
		while (count < 5) {
			cc_ctrl_QuickOrder.skuText skuT = new cc_ctrl_QuickOrder.skuText();
			skuT.value='Test';
			skuT.sNo=1;
			skuTextList.add(skuT);
			count++;
		}
		cc_ctrl_QuickOrder.skuText nullQty = new cc_ctrl_QuickOrder.skuText();
		nullQty.selectedQty=null;
		skuTextList.add(nullQty);
		cc_ctrl_HomePage tree = new cc_ctrl_HomePage();
		ApexPages.currentPage().getParameters().put('cartID', '12345678');
		ApexPages.currentPage().getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, 'g');
		cc_ctrl_QuickOrder qoeTree = new cc_ctrl_QuickOrder(tree);
		cc_ctrl_QuickOrder qoe = new cc_ctrl_QuickOrder();
		qoe.cloudCrazeController = tree;
		//qoe.getSkuTextValues();
		//qoe.setSkuTextValues(skuTextList);
		System.assertEquals(null, qoe.addToCartBulkItems());
		}
	}
	
	

    
    static testMethod void myUnitTest() {
    	
        cc_ctrl_QuickOrder.skuText skuText = new cc_ctrl_QuickOrder.skuText();
        System.assertEquals(0, skuText.sNo);
        System.assertEquals('', skuText.value);
        System.assertEquals('1', skuText.selectedQty);

        
    }
}