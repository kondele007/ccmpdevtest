@isTest
private class cc_ctrl_test_admin_Catalog {

    static testMethod void testCategoryRefresh() {
        cc_hlpr_InitLoadCustomSettings.loadCloudCrazeApplicationSettings();
        cc_hlpr_InitLoadCustomSettings.loadCloudCrazeStorefrontSettings();
        cc_hlpr_InitLoadCustomSettings.loadLanguageCodes();
        cc_hlpr_InitLoadCategories.loadTestCategories();

		Test.startTest();
        cc_ctrl_admin_Catalog controller = new cc_ctrl_admin_Catalog();
		controller.loadBreadCrumbs();
		controller.refreshCategoryCaches();
		controller.refreshMenuCaches();
		controller.refreshProductSpecIndexData();
		Test.stopTest();
    }
}