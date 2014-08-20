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
private class cc_ctrl_test_InitData {

    static testMethod void testLoadCustomSettings() {
        cc_ctrl_InitData controller = new cc_ctrl_InitData();
        controller.loadCustomSettings();
        
        // TODO: Add meaningful assertion
        System.assert(true);
    }

    static testMethod void testLoadInitData() {
        cc_ctrl_InitData controller = new cc_ctrl_InitData();

        controller.resetAccountPriceList();
        controller.loadInitialDataSet();
        
        // TODO: Add meaningful assertion
        System.assert(true);
    }
    static testMethod void myUnitTest() {
		cc_ctrl_InitData ctrl = new cc_ctrl_InitData();
		System.assert(ctrl.loadCustomSettings() == null);
		System.assert(ctrl.resetAccountPriceList() == null);
		System.assert(ctrl.loadInitialDataSet() == null);
		System.assert(ctrl.resetProductCategories() == null);
		System.assert(ctrl.loadCloudCrazeData() == null);
	}
}