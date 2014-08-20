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
private class cc_ctrl_test_RecentlyVisited {

    static testMethod void testItAll() {
    	E_Product__c product = cc_test_PrepTestData.insertProduct(1)[0];
    	cc_test_TestDataSetup.LoadData();
        System.runas(cc_test_TestDataSetup.testUser) {
    	Test.startTest();
    	
        cc_ctrl_RecentlyVisited controller = new cc_ctrl_RecentlyVisited();
        controller.currentProductID = product.Id;
        controller.setCookieValue('one:a,two:b,three:c');
        String cookieValue = controller.getCookieValue();
        String cookieJSON = controller.getCookieJSON();
        controller.setCookieJSON('test');
        List<cc_bean_RecentItem> recentItems = controller.recentItems;
        
        // TODO: Add meaningful assertion
        System.assert(true);
        
        
        Test.stopTest();
        }
    }
}