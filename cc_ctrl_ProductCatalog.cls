//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public abstract class cc_ctrl_ProductCatalog extends cc_ctrl_CloudCraze {
	//==================================================
    // INSTANCE VARIABLES
    //==================================================
	private ApexPages.StandardController controller;
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
	public string selectedProduct { get;set; }
	
	public Integer quantity {get;set;}
	public List<cc_bean_SelectableProduct> selectableProductList { get; set; }
	public String currentCategory { get; set; }
	public string currentProductID { get; set; }
	public String currentCartID { get; set; }
	public String PageTitle { get; set; }
	public String metaKeywords { get; set; }
	public String metaDescription { get; set; }
	public String viewState	{ get; set; }
	public String ipAddressLocation { get;set; }
	public String SKU { get; set; }
	//==================================================
    // INTERFACE METHODS
    //==================================================
	public virtual void initialize()
	{
		System.debug('ginger-->cc_ctrl_ProductCatalog:initialize');
		selectableProductList = new List<cc_bean_SelectableProduct>();
		currentCartID=ApexPages.currentPage().getParameters().get('cartID');
		currentProductID = ApexPages.currentPage().getParameters().get('prodID');
		currentCategory = ApexPages.currentPage().getParameters().get('categoryID');
		quantity=1;
		//TASK ID 1 START Change ProductID to Sku
		SKU = ApexPages.currentPage().getParameters().get('sku');
	    System.debug('ginger-->cc_ctrl_ProductCatalog:SKU=' + SKU);
	    if((''.equals(SKU)) || ('null'.equals(SKU))) {
			//System.debug('--------Entering not null condition----------');
			SKU=null;
	    }
	    
	    List<E_Product__c> PageTitleList = [Select SEOTitle__c,
	    											SEOKeywords__c,
	    											SEODescription__c
												from E_Product__c
												where SKU__c = :SKU
												limit 1];
												
	    //System.debug('PageTitleList.size ++++++++++++++++++++++++ ' + PageTitleList.size());
	
	    PageTitle = storefront.SEO_Title_Site__c;
	    if(PageTitleList.size() > 0 && PageTitleList.get(0).SEOTitle__c != null && PageTitleList.get(0).SEOTitle__c != '') {
			PageTitle += '	|  ' + PageTitleList.get(0).SEOTitle__c;
	    }
	}
	//==================================================
    // CONSTRUCTOR
    //==================================================
	public cc_ctrl_ProductCatalog()
	{
		initialize();
	}
	
	public cc_ctrl_ProductCatalog(ApexPages.StandardController c){
		this();
		controller = c;
	}
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public List<cc_bean_SelectableProduct> requiredItems {
		get {
			List<cc_bean_ProductListViewData> prodList;
			//selectedProduct = ApexPages.currentPage().getParameters().get('selectedProduct');
			System.debug('--------------- requiredItems: selectedProduct1: ' + selectedProduct);
			System.debug('--------------- requiredItems: selectedProduct2: ' + currentProductID);
			currentCartID=ApexPages.currentPage().getParameters().get('cartID');
			if(ApexPages.currentPage().getParameters().get('selectedProduct') != null)
			{
				currentProductID=ApexPages.currentPage().getParameters().get('selectedProduct');
			}
			
			System.debug('--------------- requiredItems: selectedProduct: ' + selectedProduct);
			System.debug('--------------- requiredItems: currentProductID: ' + currentProductID);
			System.debug('--------------- requiredItems: currentCartID: ' + currentCartID);


			// This is the real query
			if(currentProductID!=null){
				prodList = relatedProducts(currentProductID, cc_cnst_PickListConstants.RELATEDPRODUCE_REQUIREDITEM);
			}
			else{
				prodList = relatedProducts(selectedProduct, cc_cnst_PickListConstants.RELATEDPRODUCE_REQUIREDITEM);
			} 
			System.debug('--- prodList:' + prodList);

			selectableProductList.clear();

			for(cc_bean_ProductListViewData data: prodList){
			    cc_bean_SelectableProduct sProduct = new cc_bean_SelectableProduct();
			    sProduct.productListViewData = data;
			    selectableProductList.add(sProduct);
			    System.debug('--- added cc_bean_SelectableProduct:' + sProduct);
			}

			return selectableProductList;
		}
		private set;
    }
    //==================================================
    // HELPER METHODS
    //==================================================
	public List<cc_bean_ProductListViewData> relatedProducts(string productID, String typeCode) {
		System.debug('-------------------------------' + productID);
		System.debug('-------------------------------' + typeCode);
		List<E_Product__c> prodList = new List<E_Product__c>();
		List<E_RelatedProduct__c> related = new List<E_RelatedProduct__c>();
		
		
		if(productID instanceof Id) {
			related = [Select e.Product__c, e.RelatedProduct__r.Id, e.RelatedProduct__r.Name,
						     e.RelatedProduct__r.SKU__c, 
						     e.RelatedProduct__r.UnitOfMeasure__c, e.RelatedProduct__r.ProductStatus__c, 
						     e.RelatedProduct__r.ProductType__c,e.RelatedProduct__r.ShortDesc__c 
						     from E_RelatedProduct__c e
						     where e.enabled__c=true and e.isDeleted=false and
						     e.Product__c = :productID and
						     e.RelatedProductType__c = :typeCode
						     and e.StartDate__c <= :System.Today() and e.EndDate__c > :System.Today()
						     ];
		} else {
			related = [Select e.Product__c, e.RelatedProduct__r.Id, e.RelatedProduct__r.Name,
						     e.RelatedProduct__r.SKU__c,
						     e.RelatedProduct__r.UnitOfMeasure__c, e.RelatedProduct__r.ProductStatus__c, 
						     e.RelatedProduct__r.ProductType__c,e.RelatedProduct__r.ShortDesc__c 
						     from E_RelatedProduct__c e
						     where e.enabled__c=true and e.isDeleted=false and
						     e.Product__r.sku__c = :productID and
						     e.RelatedProductType__c = :typeCode
						     and e.StartDate__c <= :System.Today() and e.EndDate__c > :System.Today()
						     ];
		}
		
		for(E_RelatedProduct__c rp : related) {
			System.debug('------888888---------' + rp.RelatedProduct__r.SKU__c);
			prodList.add(rp.RelatedProduct__r);
		}
		List<cc_bean_ProductListViewData> localProductListViewData = new List<cc_bean_ProductListViewData>();
		localProductListViewData = buildProductListViewData(prodList);
		return localProductListViewData;
    }
    
    public virtual List<cc_bean_ProductListViewData> buildProductListViewData(List<E_Product__c> pdl) {
		System.debug('-----Enter cc_ctrl_ProductList.buildProductListViewData()-----');
		Integer noOfQueries = Limits.getQueries();
		System.debug('----Limits.getQueries()1----- : ' + noOfQueries);
		List<cc_bean_ProductListViewData> localproductListViewData = new List<cc_bean_ProductListViewData>();

		System.debug('--------- productCategoryList product count: ' + pdl.size() + ' -------');

		// Get list of product SKUs and list of ProductIDs
		List<String> skuList = new List<String>();
		List<Id> productIdList = new List<Id>();
		Map<Id, E_Product__c> productMap = new Map<Id,E_Product__c>();
		for(E_Product__c pd : pdl) {
		    skuList.add(pd.SKU__c);
		    productIdList.add(pd.Id);
		    productMap.put(pd.Id, pd);
		}

		// Get Map<SKU ID, PriceListItem> of prices
		/*Map<String, E_PriceListItem__c> priceLineMap = cc_ctrl_PricingEngine.getLowestPriceLineMap(skuList,
		                                                  cc_util_CloudCraze.getAccountID(),
		                                                  Date.today(),
		                                                  cc_ctrl_PricingEngine.getCurrencyCode(),
		                                                  cc_ctrl_PricingEngine.getCustomerType());*/
		Map<String, cc_bean_PriceInfo> priceLineMap = cc_ctrl_PricingEngine.getPriceMap(skuList, cc_util_CloudCraze.getAccountID(), null, null, null);
       
        System.debug('sns priceLineMap: ' + priceLineMap);
		
		cc_dao_ProductMedia pmDAO = new cc_dao_ProductMedia();
		Map<Id, cc_bean_MediaWrapper> idSearchMap = pmDAO.getProductSearchMedia(productIdList);
		Map<Id, String> idSearchMap2 = pmDAO.getProductAltMessages(productIdList);

		for(E_Product__c pd : pdl ) {
			cc_bean_ProductListViewData data = new cc_bean_ProductListViewData();
			data.product = pd;
			data.mockProduct = new cc_bean_MockProduct(pd);
			if(priceLineMap != null && priceLineMap.containsKey(pd.SKU__c)) {
			     data.priceBean=priceLineMap.get(pd.SKU__c);
                 //data.priceListItem = data.priceBean.priceListItem;
			    //System.debug('sns data.priceListItem = ' + data.priceListItem);
			}
			else
			{
				//skip this product
                continue;
			}
			//		  productPricemap.put(pd.Id, data.priceListItem.Price__c);

			/* String idSearchMapString = idSearchMap.get(pd.Id);
			   List<String> splitted = idSearchMapString.split(':',2);*/
			
			data.Alt_Message = idSearchMap2.get(pd.Id);

			System.debug('@@@@@@@@@@idSearchMaplength   :	' + idSearchMap.size());
			System.debug('@@@@@@@@@@idSearchMaplength2   :	 ' + idSearchMap2.size());
 
			System.debug('@@@@@@@@@@Alt message  :	' + data.Alt_Message);

			/*Id attId;
			  if(splitted.get(0).length() >= 15)
			  {
			  attId = splitted.get(0);
			  }

			  if(splitted.get(1).length() > 0)
			  {
			  data.Alt_Message = splitted.get(1);
			  }
			*/
			if(idSearchMap.get(pd.Id) != null) {
			    data.mediaWrapper = idSearchMap.get(pd.Id);
			} 
			//data.averageReview = getAverageRating(getReviews(pd));
			data.averageReview = 0.0;
			localproductListViewData.add(data);
		}
		noOfQueries = Limits.getQueries();
		System.debug('----Limits.getQueries()2----- : ' + noOfQueries);
		System.debug('-----cc_ctrl_ProductList.buildProductListViewData()-localproductListViewData----:' + localproductListViewData);
		System.debug('-----Exit cc_ctrl_ProductList.buildProductListViewData()-----');

		return localproductListViewData;
    }
    //==================================================
    // SERVICE METHODS
    //==================================================
	public virtual void doNothing()
	{
		System.debug('-----cc_ctrl_ProductCatalog.doNothing : selectedProduct' + selectedProduct);
		System.debug('-----cc_ctrl_ProductCatalog.doNothing : currentCartID' + currentCartID);
	}
	public virtual PageReference addRelatedProductsToCart() {
		//    String strQty = Apexpages.currentPage().getParameters().get('qty');
		String ipAddressLocation = Apexpages.currentPage().getParameters().get(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY);
		String currentCategory = Apexpages.currentPage().getParameters().get('categoryID');
		System.debug('-----cc_ctrl_ProductList.addRelatedProductsToCart()-Request values-currentCategory : ' + currentCategory);
		//  currentProductID = selectedProduct;
		//selectedProduct = ApexPages.currentPage().getParameters().get('selectedProduct');
		currentCartID=ApexPages.currentPage().getParameters().get('cartID');
		String prodId=ApexPages.currentPage().getParameters().get('prodID');
		System.debug('currentProductID: 0->' + currentProductID);
		if(selectedProduct != null)
		{
			currentProductID = selectedProduct;
		}

		System.debug('-----------\n--------------\n-------- addRelatedProductsToCart');
		System.debug('cartID: ' + currentCartID);
		System.debug('currentProductID: ' + currentProductID);
		System.debug('strQty: ' + quantity);
		System.debug('ipAddressLocation: ' + ipAddressLocation);
		System.debug('selectedProduct: ' + selectedProduct);
		System.debug('selectableProductList: ' + selectableProductList);
		System.debug('prodId: ' + prodId);

		cc_api_Cart cc_api_Cart = new cc_api_Cart();
		if (al.StringUtils.isNotBlank(currentCategory)) {
		    cc_api_Cart.categoryId = currentCategory;
		}
		System.debug('-------------- addRelatedProductsToCart: currentProductID - ' + currentProductID);
		for(cc_bean_SelectableProduct sProduct : selectableProductList) {
		    System.debug('-------------- addRelatedProductsToCart: selectableProductID, selected: ' + sProduct.productListViewData.product.ID + ',' + sProduct.selected);
		    if(sProduct.selected) {
				currentCartID = cc_api_Cart.addToCart( sProduct.productListViewData.product.ID, currentCartID, 1, storefront.Name );
		    }
		}

		PageReference page = System.Page.AddToCart; //new PageReference('/apex/AddToCart');
		page.getParameters().put('prodId', currentProductID);
		page.getParameters().put('categoryID', currentCategory);
		page.getParameters().put('cartID', currentCartID);
		page.getParameters().put('qty', String.valueOf(quantity));
		page.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, ipAddressLocation);
		page.setRedirect(true);
		return page;
    }
    
    public virtual PageReference addProductsToCart() {
		String ipAddressLocation = Apexpages.currentPage().getParameters().get(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY);
		String currentCategory = Apexpages.currentPage().getParameters().get('categoryID');
		System.debug('-----cc_ctrl_ProductList.addRelatedProductsToCart()-Request values-currentCategory : ' + currentCategory);
		//  currentProductID = selectedProduct;
		//selectedProduct = ApexPages.currentPage().getParameters().get('selectedProduct');
		currentCartID=ApexPages.currentPage().getParameters().get('cartID');
		String prodId=ApexPages.currentPage().getParameters().get('prodID');
		System.debug('currentProductID: 0->' + currentProductID);
		if(selectedProduct != null)
		{
			currentProductID = selectedProduct;
		}

		System.debug('-----------\n--------------\n-------- addProductsToCart');
		System.debug('cartID: ' + currentCartID);
		System.debug('currentProductID: ' + currentProductID);
		System.debug('strQty: ' + quantity);
		System.debug('ipAddressLocation: ' + ipAddressLocation);
		System.debug('selectedProduct: ' + selectedProduct);
		System.debug('selectableProductList: ' + selectableProductList);
		System.debug('prodId: ' + prodId);

		cc_api_Cart cc_api_Cart = new cc_api_Cart();
		if (al.StringUtils.isNotBlank(currentCategory)) {
		    cc_api_Cart.categoryId = currentCategory;
		}
		System.debug('-------------- addRelatedProductsToCart: currentProductID - ' + currentProductID);
		for(cc_bean_SelectableProduct sProduct : selectableProductList) {
		    System.debug('-------------- addRelatedProductsToCart: selectableProductID, selected: ' + sProduct.productListViewData.product.ID + ',' + sProduct.selected);
		    if(sProduct.selected) {
				currentCartID = cc_api_Cart.addToCart( sProduct.productListViewData.product.ID, currentCartID, 1, storefront.Name );
		    }
		} 
		//add main product
		currentCartID = cc_api_Cart.addToCart(currentProductID, currentCartID, quantity, storefront.Name);
		
		PageReference page = System.Page.AddToCart; //new PageReference('/apex/AddToCart');
		page.getParameters().put('prodId', currentProductID);
		page.getParameters().put('categoryID', currentCategory);
		page.getParameters().put('cartID', currentCartID);
		page.getParameters().put('qty', String.valueOf(quantity));
		page.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, ipAddressLocation);
		page.setRedirect(true);
		return page;
    }	
    
    public virtual PageReference addProductsToCartNew() {
    	System.debug('-----------\n--------------\n-------- addProductsToCartNew');
    	//ipAddressLocation is defined in parent calsss
		//--String ipAddressLocation = Apexpages.currentPage().getParameters().get(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY);
		//currentCategory is a class instance var
		//String currentCategory = Apexpages.currentPage().getParameters().get('categoryID');
		//System.debug('-----cc_ctrl_ProductList.addRelatedProductsToCart()-Request values-currentCategory : ' + currentCategory);
		//  currentProductID = selectedProduct;
		//selectedProduct = ApexPages.currentPage().getParameters().get('selectedProduct');
		//use parent's cccartid
		//currentCartID=ApexPages.currentPage().getParameters().get('cartID');
		//currentProductID is an instance var
		//String prodId=ApexPages.currentPage().getParameters().get('prodID');
		//System.debug('currentProductID: 0->' + currentProductID);
		
		if(selectedProduct != null)
		{
			currentProductID = selectedProduct;
		}

		//System.debug('-----------\n--------------\n-------- addProductsToCart');
		//System.debug('cartID: ' + ccCartId);
		//System.debug('currentProductID: ' + currentProductID);
		//System.debug('strQty: ' + quantity);
		//System.debug('ipAddressLocation: ' + ipAddressLocation);
		//System.debug('selectedProduct: ' + selectedProduct);
		//System.debug('selectableProductList: ' + selectableProductList);
		//System.debug('prodId: ' + currentProductID);

		cc_api_Cart cartApi = new cc_api_Cart();
		if (al.StringUtils.isNotBlank(currentCategory)) {
		    cartApi.categoryId = currentCategory;
		}
		
		map<string, double> skuQtyMap = new map<string, double>();
		if(currentProductID != null) {
			skuQtyMap.put(currentProductID, quantity);
		}
		for(cc_bean_SelectableProduct sProduct : selectableProductList) {
			skuQtyMap.put(sProduct.productListViewData.product.sku__c, 1);
		}
		E_Cart__c cart = cartApi.getActiveCartOwnedBy(userInfo.getUserId());
		if(cart == null) {
			cart = cartAPi.createEmptyCart();
		}
		cc_api_addToCart add2CartApi = new cc_api_addToCart(this);
		add2CartApi.currentCartId = cart.id;
		add2CartApi.skuQtyMap = skuQtyMap;
		add2CartApi.addToCartBulkItems();
		
		if(storefront.RedirectToCartPage__c) {
			PageReference page = System.Page.Cart; //new PageReference('/apex/AddToCart');
			page.getParameters().put('cartID', add2CartApi.currentEncryptedCartID);
	        page.getParameters().put('productID', currentProductID);
	        page.getParameters().put('viewState','CartView');
	        page.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, ipAddressLocation);
			page.setRedirect(true);

			return page;
		}
		else {
			cccartId = add2CartApi.currentEncryptedCartID;
			return null;
		}
    }	
}