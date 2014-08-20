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
private class cc_ctrl_test_Admin {
	
    static testMethod void testAdminController() {
        cc_ctrl_Admin controller = new cc_ctrl_Admin();
        
        // test defaults
        System.assertEquals(cc_ctrl_Admin.TAB_INDEXING, controller.currentTab);
        System.assertEquals('cc_admin_Catalog', controller.currentPage);
		
		// test themes tab
    	PageReference adminPage = Page.cc_admin_Admin;
    	adminPage.getParameters().put('t', cc_ctrl_Admin.TAB_THEMES);
    	Test.setCurrentPage(adminPage);
    	
    	controller = new cc_ctrl_Admin();
        System.assertEquals(cc_ctrl_Admin.TAB_THEMES, controller.currentTab);
        System.assertEquals('cc_admin_Themes', controller.currentPage);
        
        // test gotoTab (setting tab and page to null so goes to default tab)
        controller.currentTab = null;
        controller.currentPage = null;
        controller.gotoTab();
        System.assertEquals(cc_ctrl_Admin.TAB_INDEXING, controller.currentTab);
        System.assertEquals('cc_admin_Catalog', controller.currentPage);
    }
}