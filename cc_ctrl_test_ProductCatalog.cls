@isTest
private class cc_ctrl_test_ProductCatalog {
	private class Impl extends cc_ctrl_ProductCatalog {
		
	}
	
    static testMethod void genericTest() {
    	cc_test_TestDataSetup.loadData();
    	System.assert([Select c.Id From E_ApplicationSettings__c c where name='CloudCraze'].size() != 0);
    	System.runas(cc_test_TestDataSetup.testUser) {
    	Impl controller = new Impl();
    	 
    	controller.initialize();
    	
    	List<cc_bean_SelectableProduct> selectableProducts = controller.requiredItems;
    	
    	E_Product__c product = new E_Product__c();
    	List<cc_bean_ProductListViewData> viewData = controller.relatedProducts(product.Id, 'typecode');
    	
    	List<E_Product__c> productList = new List<E_Product__c>();
    	productList.add(product);
    	viewData = controller.buildProductListViewData(productList);
    	
    	PageReference pageReference = controller.addRelatedProductsToCart();
    	
    	pageReference = controller.addProductsToCart();
    	}
    }
    
    static testMethod void addToCartTest() {
     	
     	cc_test_TestDataSetup.LoadData();
     	
        cc_api_dl_products prods = new cc_api_dl_products();
        prods.loadData();
        cc_api_dl_priceListLines priceLines = new cc_api_dl_priceListLines();
        priceLines.loadData();
        
        List<E_RelatedProduct__c> related = new List<E_RelatedProduct__c> {
        	new E_RelatedProduct__c(Product__r=new e_product__c(sku__c='99991'), RelatedProduct__r = new e_product__c(sku__c='99990'), RelatedProductType__c=cc_cnst_PickListConstants.RELATEDPRODUCE_REQUIREDITEM ),
        	new E_RelatedProduct__c(Product__r=new e_product__c(sku__c='99991'), RelatedProduct__r = new e_product__c(sku__c='99992'), RelatedProductType__c=cc_cnst_PickListConstants.RELATEDPRODUCE_REQUIREDITEM ),
        	new E_RelatedProduct__c(Product__r=new e_product__c(sku__c='99991'), RelatedProduct__r = new e_product__c(sku__c='99993'), RelatedProductType__c=cc_cnst_PickListConstants.RELATEDPRODUCE_REQUIREDITEM )};
        insert related;
        
        	
        System.runas(cc_test_TestDataSetup.testUser) {
        	Test.startTest();
	
      
        	cc_ctrl_Homepage homepageCtrl = new cc_ctrl_Homepage();
        	homepageCtrl.initialize();
        	Pagereference currentPage = System.Page.HomePage;
        	homepageCtrl.selectedProduct = '99991';
        	homepageCtrl.selectableProductList = homepageCtrl.requiredItems;
        	system.debug('ryl-> homepageCtrl.selectableProductList' + homepageCtrl.selectableProductList);
        	
        	
        	Test.setCurrentPage(currentPage);
        	cc_api_cart cartApi = new cc_api_cart();
        	
        	E_Cart__c cart = cartApi.createEmptyCart();
        	cart = [select id, encryptedID__c from e_cart__c where id = :cart.id];
        	
        	
			ApexPages.currentPage().getParameters().put('cartID', cart.encryptedID__c);
			ApexPages.currentPage().getParameters().put('prodID', '99991');
			Apexpages.currentPage().getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, 'GA');
			homepageCtrl.quantity=2;
			ApexPages.currentPage().getParameters().put('sku', '99991');
		
        	homepageCtrl.addProductsToCartNew();
        	E_Cart__c c=cc_dao_Cart.retrieveCartHeaderAddressesLineItems(cart.id);
        	System.debug('ryl-> add2Cart->' + c);
        	for(e_cartitem__c ci : c.E_CartItems__r) {
        		System.debug('ryl-> add2Cart->' + ci);
        	}
        	
        test.stopTest();
        }
     }
     
}