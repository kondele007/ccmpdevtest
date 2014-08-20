@isTest
private class cc_ctrl_test_CategoryTree {

    static testMethod void testCategoryTree() {
	 	cc_test_TestDataSetup.loadData();

		System.runAs(cc_test_TestDataSetup.testUser) {
			cc_ctrl_ProductDetail productDetailController = new cc_ctrl_ProductDetail();
			cc_ctrl_CategoryTree ga = new cc_ctrl_CategoryTree();
			PageReference productDetails = System.Page.ProductDetails;
			Test.setCurrentPage(productDetails);
			ga.ccCtrl = productDetailController.getProductDetailController();
			system.assert(ga.treeHtml != null);
		}
    }
}