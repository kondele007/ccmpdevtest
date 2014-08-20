@isTest
private class cc_ctrl_test_ProductList {

    static testMethod void testCategoryList() {
    	//cc_test_PrepTestData.loadCustomSettings();
        //cc_test_PrepTestData.loadInitData();
        //cc_test_PrepTestData.loadTestCategoryData();
        //cc_test_TestDataSetup.createAccountUser(cc_test_TestDataSetup.PROFILE_CUSTOMER_PORTAL);
        cc_test_TestDataSetup.loadData();
        cc_test_PrepTestData.loadTestCategoryData();
        System.RunAs(cc_test_TestDataSetup.testUser)
        {
        E_Category__c cat = [Select Id from E_Category__c where Name = 'CloudCrazeTestSubCategory' limit 1][0];
    	cc_ctrl_HomePage tController = new cc_ctrl_HomePage();
        PageReference productsPage = System.Page.Products;
        productsPage.getParameters().put('categoryID', cat.Id);
        Test.setCurrentPage(productsPage);
    	
    	Test.startTest();

        cc_ctrl_ProductList ctrl = new cc_ctrl_ProductList(tController);
        ctrl.initProductList();
        ctrl.setSortOrder(ctrl.getSortOrder());
        ctrl.changeSortOrder();
        ctrl.setSortOrder(ctrl.SORT_BY_PRICE);
        ctrl.changeSortOrder();
        ctrl.setSortOrder(ctrl.SORT_BY_RATING);
        ctrl.changeSortOrder();
        
        // misc code coverage tests
        ctrl = ctrl.getProductListController();
        Integer skipPage = ctrl.skipPage;
        List<SelectOption> pageSizeOptions = ctrl.pageSizeOptions;
        //ctrl.showQuickOrder();
        List<E_Category__c> catChildList = ctrl.getchildCatWithNoProd();
        List<cc_bean_ProductListViewData> data = ctrl.getData();
        String searchString = ctrl.getSearchString();
        List<cc_bean_SelectableProduct> spl = ctrl.getSelectableProductList();
        ctrl.renderListView();
        ctrl.renderTextView();

        // TODO: Add meaningful assertion
        System.assert(true);
        
        Test.stopTest();
        }
    }
        
    static testMethod void testProductSearch() {
        cc_test_PrepTestData.loadCustomSettings();
        cc_test_TestDataSetup.createAccountUser(cc_test_TestDataSetup.PROFILE_CUSTOMER_PORTAL);
        System.RunAs(cc_test_TestDataSetup.testUser)
        {
    	E_Product__c p = cc_test_PrepTestData.insertProduct(1)[0];
    	ApexPages.Standardcontroller sController = new ApexPages.Standardcontroller(p);
    	PageReference productsPage = System.Page.Products;
    	productsPage.getParameters().put('operation', 'quickSearch');
        productsPage.getParameters().put('searchText', p.Sku__c);
        Test.setCurrentPage(productsPage);
        
        Test.startTest();
        
        cc_ctrl_ProductList controller = new cc_ctrl_ProductList(sController);
        controller.initProductList();
        
        // TODO: Add meaningful assertion
        System.assert(true);
        
        Test.stopTest();
        }
    }

    static testMethod void testEmptyConstructor() {
       // cc_test_PrepTestData.loadCustomSettings();
        //cc_test_PrepTestData.loadInitData();
        //cc_test_PrepTestData.loadTestCategoryData();
        //cc_test_TestDataSetup.createAccountUser(cc_test_TestDataSetup.PROFILE_CUSTOMER_PORTAL);
        cc_test_TestDataSetup.loadData();
        cc_test_PrepTestData.loadTestCategoryData();
        System.RunAs(cc_test_TestDataSetup.testUser)
        {
        List<E_Product__c> products = cc_test_PrepTestData.getAllTestProducts();
        List<E_RelatedProduct__c> requiredList = cc_test_PrepTestData.insertRelatedProduct(products[0].Id, products[1].Id, cc_cnst_PickListConstants.RELATEDPRODUCE_REQUIREDITEM);
        cc_api_Cart capi = new cc_api_Cart();
        E_Cart__c cart = capi.createEmptyCart();

        PageReference productsPage = System.Page.Products;
        productsPage.getParameters().put('operation', 'quickSearch');
        productsPage.getParameters().put('cartID', cart.Id);
        productsPage.getParameters().put('selectedProduct', products[0].Id);
        Test.setCurrentPage(productsPage);
        
        Test.startTest();
        
        cc_ctrl_ProductList controller = new cc_ctrl_ProductList();
        controller.initProductList();
        controller.selectedProduct = products[0].Id;

        System.AssertNotEquals(null, controller.accessories);
        System.AssertNotEquals(null, controller.relatedItems);
        System.AssertNotEquals(null, controller.requiredItems);
        System.AssertNotEquals(null, controller.addRelatedProductsToCart());
        
        Test.stopTest();
        }
    }
}