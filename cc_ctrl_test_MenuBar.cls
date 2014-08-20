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
private class cc_ctrl_test_MenuBar {

    static testMethod void testMenuBar() {
        cc_hlpr_InitLoadCustomSettings.loadCloudCrazeApplicationSettings();
        cc_hlpr_InitLoadCustomSettings.loadCloudCrazeStorefrontSettings();
    	cc_ctrl_CloudCraze ccCtrl = new cc_ctrl_CloudCraze();

    	cc_ctrl_MenuBar controller = new cc_ctrl_MenuBar();
    	controller.ccCtrl = ccCtrl;

    	System.assertEquals('', controller.menuHtml);
    }

}