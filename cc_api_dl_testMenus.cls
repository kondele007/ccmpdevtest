/**
 * Tests both loading menus and menu items
 */
@isTest
public with sharing class cc_api_dl_testMenus {

    @isTest static void testLoadingMenus() {
    	cc_test_PrepTestData.loadCustomSettings();

        cc_api_dl_menus menus = new cc_api_dl_menus();
        menus.loadData();
        System.assertEquals(1, [select count() From E_Menu__c]);
        //System.assertEquals(1, [select count() From E_HtmlCache__c where HtmlType__c = :cc_cnst_PickListConstants.HTML_CACHE_TYPE_MENU]);

		cc_api_dl_MenuItems menuItems = new cc_api_dl_MenuItems();
		menuItems.loadData();
        System.assertEquals(1, [select count() From E_MenuItem__c]);
        //System.assertEquals(1, [select count() From E_HtmlCache__c where HtmlType__c = :cc_cnst_PickListConstants.HTML_CACHE_TYPE_MENU]);
    }
}