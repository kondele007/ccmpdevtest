/**
// * @Description: Extension to handle customized related item retrieval.
// * @Author: 1.0
// * @File: cc_kap_extn_RelatedItems_va
// * =======================================================================================
// * 2012/08/14 1.1 IL -  Created
**/
public without sharing class cc_kap_extn_RelatedItems_va {
	private static final String DEFAULT_RELATION_MODE = cc_cnst_PickListConstants.RELATEDPRODUCT_CROSSSELL;
	private static final Integer DEFAULT_MAX_ITEMS_TO_DISPLAY = 9;
	public cc_ctrl_RelatedItems c;
	public String relationMode { get; set; }
	public Boolean prioritizeByLastAdded { get; set; }
	public Integer maxItemsToDisplay { get; set; }
	public String cartCurrency { get; set; } 
	public List<cc_bean_ProductListViewData> relatedData { 
		get {
			 if (relatedData == null) 
			 	relatedData = getRelatedDataList(); 
			 	System.debug(LoggingLevel.INFO, 'ah relatedData ' + relatedData);
			 return relatedData; 
		} 
		private set; 
	}
	public Integer itemCount { 
		get { 
			if (relatedData == null) 
			 	relatedData = getRelatedDataList(); 
			return relatedData.size(); 
		} 
	}
	public String selectedProduct { get; set; }
	public String currentCartID {get; set; }
	
	public cc_kap_extn_RelatedItems_va() {
	}

	public cc_kap_extn_RelatedItems_va(cc_ctrl_RelatedItems c) {
		this.c = c;
	}

	/*
	 * Retrieves a list of related items prioritized based on the last item added to cart.
	 * If the cookie is not found, will default to whatever was retrieved.
	 */
	public List<Id> getPrioritizedRelatedItemIds() {
		if (!prioritizeByLastAdded)
	 		return c.getCrossSellItemIdsForLst();
	 	else {
	 		List<E_RelatedProduct__c> relatedProducts = getPrioritizedRelatedItems();
    		List<Id> relatedProductIds = new List<Id>();
    		for(E_RelatedProduct__c p :relatedProducts)
    			relatedProductIds.add(p.RelatedProduct__c);
    		return relatedProductIds;
	 	}
	}
	
	/*
	 * Retrieves a list of related items prioritized based on the last item added to cart.
	 * If the cookie is not found, will default to whatever was retrieved.
	 */
	public List<E_RelatedProduct__c> getPrioritizedRelatedItems() {
 		if (relationMode == null)
 			relationMode = DEFAULT_RELATION_MODE;
 		if (maxItemsToDisplay == null)
 			maxItemsToDisplay = DEFAULT_MAX_ITEMS_TO_DISPLAY;
 		String priorityProduct = cc_kap_utils_AppUtils.retrieveCookie(cc_kap_utils_AppConstants.COOKIE_LAST_ADDED_ID);
 		System.debug(LoggingLevel.INFO, 'AH priorityProduct ' + priorityProduct);
 		System.debug(LoggingLevel.INFO, 'AH c.productIdList ' + c.productIdList);
 		List<E_RelatedProduct__c> relatedProducts = cc_dao_Product.getPriorityRelatedProducts(c.productIdList, relationMode, priorityProduct, maxItemsToDisplay);
		return relatedProducts;
	}
	
	/**
	 * Constructs data used to populate the related items based on the related products
	 * @return list of product view beans..
	 */
	public List<cc_bean_ProductListViewData> getRelatedDataList() { 
		List<E_RelatedProduct__c> relatedProducts = getPrioritizedRelatedItems();
		System.debug(LoggingLevel.INFO, 'ah relatedproducts ' + relatedProducts);
		Id accountId = cc_util_CloudCraze.getAccountID();
		List<cc_bean_ProductListViewData> listData = new List<cc_bean_ProductListViewData>();
		List<String> skuList = new List<String>();
		List<String> productIdList = new List<String>();
		Map<Id, E_Product__c> productMap = new Map<Id,E_Product__c>();
		List<E_Product__c> pList = new List<E_Product__c>();
		for(E_RelatedProduct__c relatedProduct : relatedProducts) {
			E_Product__c prod = relatedProduct.RelatedProduct__r;
			if(productMap.get(prod.id) == null)
			{
				pList.add(prod);
				System.debug(LoggingLevel.INFO, 'AH product added ' + prod);
				System.debug(LoggingLevel.INFO, 'AH prodlist ' + pList);
				skuList.add(prod.sku__c);
				productIdList.add(prod.id);
				productMap.put(prod.id, prod);
			}
		}
	
		Map<String, cc_bean_PriceInfo> priceLineMap = cc_ctrl_PricingEngine.getPriceMap(skuList, accountId, Date.today(), cc_ctrl_PricingEngine.getCurrencyCode(), cc_ctrl_PricingEngine.getCustomerType());
		
		for (E_Product__c pd : pList ) {
			cc_bean_ProductListViewData dataBean = new cc_bean_ProductListViewData();
			dataBean.product = pd;
			System.debug(LoggingLevel.INFO, 'AH pad' + pd);
			System.debug(LoggingLevel.INFO, 'AH databean.product' + dataBean.product);
			//dataBean.mockProduct 
			//cc_bean_MockProduct mockProd = new cc_bean_MockProduct(pd);
			if (priceLineMap != null && priceLineMap.containsKey(pd.SKU__c))
			    dataBean.priceBean = priceLineMap.get(pd.SKU__c);
			else
				continue;
			listData.add(dataBean);
			
		}
		
		System.debug(LoggingLevel.INFO, 'ah listdata ' +listData);
		return listData;
	}
	
	/**
	 * Handles the add to cart from the related items listing.
	 */
	public PageReference addProductsToCartNew() {
		System.debug(LoggingLevel.INFO, 'AH addProductsToCartNew');
		String miscError = '';
		cc_kap_ctrl_PunchIn ctrl = new cc_kap_ctrl_PunchIn();
		cc_api_Cart cc_api_Cart = new cc_api_Cart();
		try{
			cc_api_Cart.addToCart(selectedProduct, currentCartID, 1, ctrl.storefront.Name);
		}
		catch (cc_excn_CartException ex) {
			miscError = ex.getMessage();
		}
		if (ctrl.storefront.RedirectToCartPage__c) {
			PageReference page = System.Page.Cart_va;
			page.getParameters().put('cartID', currentCartID);
	        page.getParameters().put('productID', selectedProduct);
	        page.getParameters().put('viewState','CartView');
	        page.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, ctrl.ipAddressLocation);
	        if (miscError != '')
	        	page.getParameters().put('miscError', miscError);
			page.setRedirect(true);
			System.debug(LoggingLevel.INFO, 'AH addProductsToCartNew page ' + page);
			return page;
		}
		else
			return null;
		return null;
    }	
	
}