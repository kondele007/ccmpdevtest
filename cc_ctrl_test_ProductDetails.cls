@isTest
private class cc_ctrl_test_ProductDetails {

    static testMethod void testProductDetailsController() {
        cc_test_TestDataSetup.loadData();

		System.runAs(cc_test_TestDataSetup.testUser) {
			cc_ctrl_ProductDetail productDetailController = new cc_ctrl_ProductDetail();
			cc_ctrl_PDComponent pd = new cc_ctrl_PDComponent();
			System.assert(productDetailController.getProductDetailController() != null);

			PageReference productDetails = System.Page.ProductDetails;
			Test.setCurrentPage(productDetails);

			List<E_Product__c> productList = cc_test_PrepTestData.insertProduct(5);

			productDetailController.Sku = productList[0].Sku__c;
			pd.ProductDetailController = productDetailController.getProductDetailController();
			System.assertEquals(null, productDetailController.productDetail());

			ApexPages.currentPage().getParameters().put('productId', productList[0].id);
			System.assert(productDetailController.configureProduct() == null);

			cc_api_Cart cartApi = new cc_api_Cart();
			E_Cart__c cart = cartApi.createEmptyCart();
			ApexPages.currentPage().getParameters().put('cartID', cart.ID);
			productDetailController.currentProductID = productList[0].id;
			productDetailController.addProductsToCart();
			productDetailController.addSingleProductToCart();
			productDetailController.addMainProductToCart();
			productDetailController.doNothing();
			
			System.assert(pd.ProductDetailController != null);
			pd.getProductForm();
			pd.getStorefront();
			pd.addProductsToCart();
			pd.addRecentItemInPD();
			pd.addMainProductToCart();
			string sid = pd.storeId;
			pd.configureProduct();
			pd.getItemIncludedListViewData();
			pd.getAccessoryProductList();
			pd.getRelatedProductList();
			pd.getCrossSellProductList();
			pd.getUpSellProductList();
			pd.getRequiredItemList();
			pd.getCompetitiveProductList();
			pd.getComplementaryProductList();
		}
    }
}