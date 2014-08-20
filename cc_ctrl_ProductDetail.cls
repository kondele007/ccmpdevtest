//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without
//  modification is PROHIBITED.
//
//
public with sharing virtual class cc_ctrl_ProductDetail extends cc_ctrl_ProductCatalog {
	public cc_ctrl_ProductDetail getProductDetailController() { return this; }
	//==================================================
    // INSTANCE VARIABLES
    //==================================================
    private List<String> v_skuList = new List<String> ();
	private	List<Id> v_idList = new List<Id>();
	private	List<E_Product__c> v_pList = new List<E_Product__c>();
	private	Id v_ccAccountId = cc_util_CloudCraze.getAccountID();
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
	public Double qty { get; set; }
	public cc_bean_ProductForm productForm { get;set; }
	public Integer reviewCount { get;set; }
	public Double addProductQuantity { get; set; }
	public List<cc_bean_ProductListViewData> itemIncludedListViewData { get; set; }
	public List<cc_bean_ProductListViewData> relatedProductList {get; set;}
	public List<cc_bean_ProductListViewData> crossSellProductList { get; set; }
	public List<cc_bean_ProductListViewData> upSellProductList { get; set; }
	public List<cc_bean_ProductListViewData> requiredItemList { get; set; }
	public List<cc_bean_ProductListViewData> competitiveProductList { get; set ;}
	public List<cc_bean_ProductListViewData> complementaryProductList { get; set ;}
	public List<cc_bean_ProductListViewData> accessoryProductList { get; set ;}
	public String aggregatedProductState { get; set; }
	public Map<String, List<cc_bean_MediaWrapper>> productMediaMap { get; set; }
	public map<String, Decimal> basePriceMap {get; set; }
	public map<string, E_CompositeProduct__c> compositeMap {get; set; }
	private List<E_Product__c> productList { get; set; }
	public String relatedProductId { get; set; }
	public String requiredDialogTitle {
	    get {
            System.debug('--- cc_ctrl_ProductDetail.requiredDialogTitle: cc_bean_ProductForm.product=' + productForm.product);
			if(productForm != null && productForm.product != null
								&& productForm.product.RequiredItemDialogText != null
								&& productForm.product.RequiredItemDialogText != '') {
		    	return productForm.product.RequiredItemDialogText;
			}
			return cc_cnst_CloudCraze.REQUIRED_ITEMS_DIALOG_DEFAULT_TEXT;
	    }
	}
	
	public String shortURL {
		get {
			if(shortURL == null && SKU != null && storefront.Name != null) {
				shortURL = cc_api_Product.getShortURL(SKU, storefront.Name);
			}
			return shortURL;
		}
		set;
	}

	//==================================================
    // DERIVED METHODS
    //==================================================
	public virtual override void initialize()
	{
		super.initialize();
		productList = new List<E_Product__c> ();
		itemIncludedListViewData = new List<cc_bean_ProductListViewData>();
		relatedProductList = new List<cc_bean_ProductListViewData> ();
		crossSellProductList = new List<cc_bean_ProductListViewData> ();
		upSellProductList = new List<cc_bean_ProductListViewData> ();
		requiredItemList = new List<cc_bean_ProductListViewData> ();
		competitiveProductList = new List<cc_bean_ProductListViewData> ();
		complementaryProductList = new List<cc_bean_ProductListViewData> ();
		accessoryProductList = new List<cc_bean_ProductListViewData> ();
		productMediaMap = new Map<String, List<cc_bean_MediaWrapper>> ();
		basePriceMap = new map<String, Decimal>();
		compositeMap =new map<string, E_CompositeProduct__c> ();
		aggregatedProductState='None';
	}

	//==================================================
    // CONSTRUCTOR
    //==================================================
	public cc_ctrl_ProductDetail() {
		super();
	    this.qty = 1;
	}

	//==================================================
    // SERVICE METHODS
    //==================================================
    /* CC SaaS Mod - Schema Change - removed E_Review__c
	public PageReference saveReview() {
		String subject = ApexPages.currentPage().getParameters().get('ReviewSubject');
		String review = ApexPages.currentPage().getParameters().get('Review');
		String rating = ApexPages.currentPage().getParameters().get('rating');
		String productId = ApexPages.currentPage().getParameters().get('productId');
		
		E_Review__c r = new E_Review__c();
		
		r.Enabled__c = true;
		r.Product__c = productId;
		r.RatingCode__c = rating;

		r.ReviewDate__c = Date.today();
		r.Subject__c = subject;
		r.UserReview__c = review;
		r.User__c = userInfo.getUserId();
		insert r;
		
		currentProductID = productId;
		return readProduct();
	}
	*/

/* CC SaaS Mod - Schema Change - removed E_Review__c
	public Double getAverageRating() {
		return getAverageRating(productForm.reviews);
	}
*/
	public void addRecentItemInPD() {
			if (this.currentProductID!=null) {
				ID userId = UserInfo.getUserId();
				//System.debug('------------------------productDetail: user id= ' + userId);
				List<E_RecentItem__c> l = [Select e.Id,
												e.Product__c,
												e.User__c
											from E_RecentItem__c e
											where e.Product__c = :currentProductID
											and e.User__c = :userId];
				//TASK ID 1 END Change ProductID to Sku

				//System.debug('------------------------------productDetail: count of E_RecentItem__c = ' + l.size());
				if(l.size() == 0) {
					E_RecentItem__c item =  new E_RecentItem__c(Product__c=productList[0].id, User__c=UserInfo.getUserId());
					insert item;
					//System.debug('----------------------productDetail: E_RecentItem__c	id = ' + item.Id);
				}
		    }
	}

	public PageReference productDetail() {
		System.debug(LoggingLevel.INFO, 'cc_ctrl_ProductDetail.productDetail: sku=' + SKU + ', currentProductID=' + currentProductID);
		//TASK ID 1 START Change ProductID to Sku
		//System.debug('-------------------------------productDetail: id= ' + SKU);
		if(SKU != null || currentProductID != null) {
			cc_dao_Product cc_dao_Product = new cc_dao_Product();
			if(SKU != null) {
				productList = cc_dao_Product.readProduct(SKU);
			} else if(currentProductID != null) {
				productList = cc_dao_Product.readProductWithID(currentProductID);
			}
			System.debug(LoggingLevel.INFO, 'cc_ctrl_ProductDetail.productDetail: productList=' + productList);

			if (al.ArrayUtils.isNotEmpty(this.productList)) {
				this.currentProductID = this.productList[0].id;
		//IL - XSRF fixes to async javascript.
		//		ID userId = UserInfo.getUserId();
		//		//System.debug('------------------------productDetail: user id= ' + userId);
		//		List<E_RecentItem__c> l = [Select e.Id,
		//										e.Product__c,
		//										e.User__c
		//									from E_RecentItem__c e
		//									where e.Product__c = :currentProductID
		//									and e.User__c = :userId];
		//		//TASK ID 1 END Change ProductID to Sku
		//
		//		//System.debug('------------------------------productDetail: count of E_RecentItem__c = ' + l.size());
		//		if(l.size() == 0) {
		//			E_RecentItem__c item =  new E_RecentItem__c(Product__c=productList[0].id, User__c=UserInfo.getUserId());
		//			insert item;
		//			//System.debug('----------------------productDetail: E_RecentItem__c	id = ' + item.Id);
		//		}
		//IL - XSRF fixes to async javascript.
		   }
		}
		return readProduct();
	}
	public PageReference readProduct() {

		System.debug('----Limits.getQueries()-cc_ctrl_ProductDetail.readProduct1---- : ' + Limits.getQueries());
		if(productForm == null)
		    productForm = new cc_bean_ProductForm();

		collectProductRelatedData(productList, productForm);
		System.debug('JWL: readProduct');
        System.debug('JWL: readProduct relatedProductList: ' + this.accessoryProductList);

		System.debug('----Limits.getQueries()-cc_ctrl_ProductDetail.readProduct2---- : ' + Limits.getQueries());

		productForm.aggregatedProductState = this.aggregatedProductState;

		if(productForm.aggregatedProductState == 'Top')
		{
			productForm.aggregatedProductAggregates = cc_util_CompositeProduct.getTopLevelAggregateProducts(currentProductID);
			productForm.aggregatesViewData = cc_util_CompositeProduct.getListViewData(cc_util_CompositeProduct.getTopAggregates(currentProductID), cc_util_CloudCraze.getAccountID());
		}
		else if(productForm.aggregatedProductState == 'Child')
		{
			productForm.aggregatedProductAggregates = cc_util_CompositeProduct.getChildAggregatesSelectOption(currentProductID);
			productForm.aggregatesViewData = cc_util_CompositeProduct.getListViewData(cc_util_CompositeProduct.getChildAggregates(currentProductID), cc_util_CloudCraze.getAccountID());
		}
		System.debug('Roy 123 state=' + productForm.aggregatedProductState + ' productForm.topAggregatedProductAggregates -->' +productForm.aggregatedProductAggregates);
		System.debug('----Limits.getQueries()-cc_ctrl_ProductDetail.readProduc4---- : ' + Limits.getQueries());


		System.debug('----Limits.getQueries()-cc_ctrl_ProductDetail.readProduct5---- : ' + Limits.getQueries());
		//System.debug('-----cc_ctrl_ProductDetail.readProduct-productForm : ' + productForm);
		return null;
	}

	public PageReference configureProduct()
	{
		return null;
		//commented by roy
		/*
		PageReference nextPage = System.Page.ConfigureProduct;
		nextPage.getParameters().put('viewState', 'ConfigListView' );
		nextPage.getParameters().put('cartID', currentCartID );
		nextPage.getParameters().put('sku', sku);
		nextPage.getParameters().put('categoryID', currentCategory );
		nextPage.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, ipAddressLocation );
		nextPage.setRedirect(true);
		return nextPage;
		*/
	}
	public void addSingleProductToCart() {
		System.debug('ryl->cc_ctrl_ProductListDisplayWidgetz:addSingleProductToCart');
		System.debug('ryl->relatedProductId: 0->' + relatedProductId);
		System.debug('ryl->currentCartID: ' + currentCartID);
		System.debug('ryl->quantity: ' + qty);
		System.debug('ryl->sku: ' + sku);


		cc_api_Cart cc_api_Cart = new cc_api_Cart();
		if (al.StringUtils.isNotBlank(currentCategory)) {
		    cc_api_Cart.categoryId = currentCategory;
		}
		System.debug('ryl->check point 1');
		currentCartID = cc_api_Cart.addToCart( relatedProductId, currentCartID, qty, cc_cnst_CloudCraze.DEFAULT_STOREFRONT_NAME );
		ccCartId = currentCartID;
		/*
		System.debug('ryl->new cart id = ' + currentCartID);
		PageReference page = System.Page.ProductDetails;
		page.getParameters().put('cartID', currentCartID);
		page.getParameters().put('sku', SKU);
		page.getParameters().put('viewState', 'DetailView');
		page.getParameters().put('navigationStr', 'navigationStr');
		page.setRedirect(true);
		return page;
		*/

		/*
		PageReference page = System.currentPageReference();
		page.getParameters().put('prodId', currentProductID);
		page.getParameters().put('categoryID', currentCategory);
		page.getParameters().put('cartID', currentCartID);
		page.getParameters().put('qty', String.valueOf(quantity));
		page.setRedirect(true);
		return page;
		*/

    }
	public virtual override PageReference addProductsToCart() {
		currentCartID=ApexPages.currentPage().getParameters().get('cartID');
		System.debug('-----cc_ctrl_ProductDetail.addProductsToCart : aggregatedProductAggregates' + productForm.aggregatedProductAggregates);
		System.debug('-----cc_ctrl_ProductDetail.addProductsToCart : curretCartId' + currentCartID);
		System.debug('-----cc_ctrl_ProductDetail.addProductsToCart : currentProductID' + currentProductID);
		System.debug('-----cc_ctrl_ProductDetail.addProductsToCart : currentCategory' + currentCategory);
		System.debug('-----cc_ctrl_ProductDetail.addProductsToCart : quantity' + quantity);

		String ipAddressLocation = Apexpages.currentPage().getParameters().get(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY);
		//String currentCategory = Apexpages.currentPage().getParameters().get('categoryID');
		System.debug('roy lou-----cc_ctrl_ProductDetail.addProductsToCart2()-Request values-currentCategory : ' + currentCategory);
		//  currentProductID = selectedProduct;
		//selectedProduct = ApexPages.currentPage().getParameters().get('selectedProduct');
		//currentCartID=ApexPages.currentPage().getParameters().get('cartID');
		//String prodId=ApexPages.currentPage().getParameters().get('prodID');
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
		//System.debug('prodId: ' + prodId);

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

		if(productForm.aggregatedProductAggregates != null)
		{
			Map<String, String> selectedAggregatedAggregateMap = new Map<String, String>();
			for(cc_util_CompositeProduct.NamedSelectOptionList nso :productForm.aggregatedProductAggregates)
			{
				selectedAggregatedAggregateMap.put(nso.parentId, nso.selectedOption);
			}
			cc_api_Cart.selectedAggregatedProduct = selectedAggregatedAggregateMap;
		}

		currentCartID = cc_api_Cart.addToCart(currentProductID, currentCartID, quantity, storefront.Name);
		ccCartId=currentCartID;
		//String url = ApexPages.currentPage().geturl();

		//page. setRedirect(false);
		if(storefront.PDP_RedirectToCartPage__c) {
			PageReference page = System.Page.Cart; //new PageReference('/apex/AddToCart');
			page.getParameters().put('cartID', currentCartID);
	        page.getParameters().put('productID', currentProductID);
	        page.getParameters().put('viewState','CartView');
	        page.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, ipAddressLocation);
			page.setRedirect(true);


			return page;
		}
		else {
			return null;
		}

    }

	public PageReference AddMainProductToCart() {
		if(selectedProduct != null) {
			list<E_RelatedProduct__c> l = cc_dao_product.getRelatedProductsBySku(new List<String> {selectedProduct}, cc_cnst_PickListConstants.RELATEDPRODUCE_REQUIREDITEM );
			if(l == null || l.size() == 0) {
				return this.addProductsToCart();
			}
		}
		return null;
	}
	public override void doNothing()
	{
		super.doNothing();
		System.debug('-----cc_ctrl_ProductDetail.doNothing : aggregatedProductAggregates' + productForm.aggregatedProductAggregates);
		System.debug('-----cc_ctrl_ProductDetail.doNothing : curretCartId' + currentCartID);
		System.debug('-----cc_ctrl_ProductDetail.doNothing : currentProductID' + currentProductID);

	}
	//==================================================
    // HELPER METHODS
    //==================================================
    /* CC SaaS Mod - Schema Change - removed E_Review__c
	public Double getAverageRating(List<E_Review__c> reviews) {
		reviewCount=reviews.size();
		integer count = reviewCount;
		double total = 0.0;
		for (E_Review__c r : reviews) { total += double.valueOf(r.RatingCode__c); }
		if (count != 0) { return total / count; }
		else { return 0.0; }
	}
	*/
	private void collectProductRelatedData(List<E_Product__c> prodList, cc_bean_ProductForm productForm) {
		System.debug('--- cc_ctrl_ProductDetail.collectProductRelatedData: prodList=' + prodList);
		System.debug('--- cc_ctrl_ProductDetail.collectProductRelatedData: productForm=' + productForm);
		System.debug('----Limits.getQueries()-collectProductRelatedData---- : begin' + Limits.getQueries());

		List<String> includeStatuses = new List<String>();
		includeStatuses.add('Not Orderable');
		includeStatuses.add('Released');

		//add related items
		List<E_Product__c> l_relatedProductList = new List<E_Product__c> ();
		List<E_Product__c> l_crossSellProductList = new List<E_Product__c> ();
		List<E_Product__c> l_upSellProductList = new List<E_Product__c> ();
		List<E_Product__c> l_requiredItemList = new List<E_Product__c> ();
		List<E_Product__c> l_competitiveProductList = new List<E_Product__c> ();
		List<E_Product__c> l_itemIncludedList = new List<E_Product__c> ();
		List<E_Product__c> l_complementaryProductList = new List<E_Product__c> ();
		List<E_Product__c> l_accessoryProductList = new List<E_Product__c> ();

		for(E_Product__c prod: prodList) {
			productForm.tabs = cc_api_Product.getProductTabBeans(prod.E_ProductTabs__r);
			productForm.product = new cc_bean_Product(prod);
			List<E_RelatedProduct__c> rpList = [Select Id,
							Sequence__c,
							RelatedProduct__c,
							RelatedProduct__r.Sku__c,
							RelatedProduct__r.Name,
							RelatedProduct__r.LeadTime__c,

							RelatedProduct__r.LongDesc__c,
							RelatedProductType__c,
							RelatedProduct__r.ParentProduct__c,
							RelatedProduct__r.QuantityPerUnit__c,
							RelatedProduct__r.RecordTypeId,
							RelatedProduct__r.ReviewFlag__c,
							RelatedProduct__r.ServiceFlag__c,
							RelatedProduct__r.ShortDesc__c,
							RelatedProduct__r.ProductType__c,
							RelatedProduct__r.ProductStatus__c,
							RelatedProduct__r.SupersedeProduct__c,
							RelatedProduct__r.UnitOfMeasure__c,
							RelatedProduct__r.StartDate__c,
							RelatedProduct__r.EndDate__c,
							RelatedProduct__r.AvailabilityMessage__c,
							RelatedProduct__r.RequiredItemDialogText__c

						FROM E_RelatedProduct__c
						WHERE Product__c = :prod.id
							and RelatedProduct__r.isDeleted = false
							and RelatedProduct__r.ProductStatus__c in :includeStatuses
						ORDER BY Sequence__c, RelatedProduct__r.Name];

			/*
			for(E_RelatedProduct__c rp: rpList)
			{
				v_skuList.add(rp.RelatedProduct__r.SKU__c);
				v_idList.add(rp.RelatedProduct__c);
				v_pList.add(rp.RelatedProduct__r);
				if(rp.RelatedProductType__c.equals('Related'))
				{
					l_relatedProductList.add(rp.RelatedProduct__r);
				}
				else if(rp.RelatedProductType__c.equals('CrossSell'))
				{
					l_crossSellProductList.add(rp.RelatedProduct__r);
				}
				else if(rp.RelatedProductType__c.equals('UpSell'))
				{
					l_upSellProductList.add(rp.RelatedProduct__r);
				}
				else if(rp.RelatedProductType__c.equals('RequiredItem'))
				{
					l_requiredItemList.add(rp.RelatedProduct__r);
				}
				else if(rp.RelatedProductType__c.equals('Competitive'))
				{
					l_competitiveProductList.add(rp.RelatedProduct__r);
				}
				else if(rp.RelatedProductType__c.equals('Complementary'))
				{
					l_complementaryProductList.add(rp.RelatedProduct__r);
				}
				else if(rp.RelatedProductType__c.equals('Accessories'))
				{
					l_accessoryProductList.add(rp.RelatedProduct__r);
				}

			}
			//add main product
			v_skuList.add(prod.Sku__c);
			//add component products if there is any
			if(prod.ProductType__c.equals('Aggregated'))
			{
				//this is a top level aggregated product
				aggregatedProductState = 'Top';
			}
			if(prod.productType__c.equals('Bundle') || prod.productType__c.equals('Kit'))
			{
				List<E_CompositeProduct__c> compositeProducts = [select bp.Component__c,
							bp.Component__r.id,
		                    bp.Component__r.SKU__c,
		                    bp.Component__r.Name,
		                    bp.Component__r.ProductType__c,
		                    bp.Component__r.LeadTime__c,
							bp.quantity__c,
							bp.Component__r.LongDesc__c,
							bp.Component__r.ParentProduct__c,
							bp.Component__r.QuantityPerUnit__c,
							bp.Component__r.RecordTypeId,
							bp.Component__r.ReviewFlag__c,
							bp.Component__r.ServiceFlag__c,
							bp.Component__r.ShortDesc__c,
							bp.Component__r.ProductStatus__c,
							bp.Component__r.SupersedeProduct__c,
							bp.Component__r.UnitOfMeasure__c,
							bp.Component__r.StartDate__c,
							bp.Component__r.EndDate__c,
							bp.Component__r.AvailabilityMessage__c,
							bp.Component__r.RequiredItemDialogText__c
		              from E_CompositeProduct__c bp
		              where bp.Composite__r.id = :prod.id];
				for(E_CompositeProduct__c cp : compositeProducts)
				{
					v_skuList.add(cp.Component__r.SKU__c);
					v_idList.add(cp.Component__c);
					v_pList.add(cp.Component__r);
					l_itemIncludedList.add(cp.Component__r);
					compositeMap.put(cp.Component__c, cp);
					if(cp.Component__r.ProductType__c.equals('Aggregated'))
					{
						aggregatedProductState = 'Child';
					}
				}
			
			}
			*/
		}
		cc_dao_ProductMedia pmDAO = new cc_dao_ProductMedia();
		Map<String,cc_bean_PriceInfo> priceMap = cc_ctrl_PricingEngine.getPriceMap(v_skuList, v_ccAccountId, System.today(), null, null);
		if(productForm.product != null) {
			productForm.priceBean = priceMap.get(productForm.product.sku);
		}
        //productForm.priceListItem = productForm.priceBean.priceListItem;
        //productForm.price = productForm.priceBean.price;
		List<cc_bean_EProductImageID> ids = new List<cc_bean_EProductImageID>();
		productMediaMap =  pmDao.getProductMediaByType(currentProductID);
		List<cc_bean_MediaWrapper> alternateImgs = productMediaMap.get(cc_cnst_CloudCraze.PM_AlternateImage);

		List<cc_bean_MediaWrapper> alternateThumbnailImgs = productMediaMap.get(cc_cnst_CloudCraze.PM_AlternateThumbnail);

		System.debug('--- cc_ctrl_ProductDetail.collectProductRelatedData: v_skuList=' + v_skuList);
		basePriceMap = cc_ctrl_PricingEngine.getBasePrice(v_skuList);
		System.debug('--- cc_ctrl_ProductDetail.collectProductRelatedData: basePriceMap=' + basePriceMap);
		productForm.basePrice = basePriceMap.get(productForm.product.sku);
		System.debug('--- cc_ctrl_ProductDetail.collectProductRelatedData: productForm.basePrice=' + productForm.basePrice);

		/*
		 * Added by prakash to avoid null pointer exception
		 */

		if(alternateThumbnailImgs!=null && alternateImgs!=null){
		    for(integer i = 0; i < alternateImgs.size(); i++ ) {
                if (i < alternateThumbnailImgs.size()) { /* added by scott to avoid list index out of bounds exception */
				    ids.add(new cc_bean_EProductImageID(alternateImgs[i].uri, alternateImgs[i].sourceType, alternateThumbnailImgs[i].uri, alternateThumbnailImgs[i].sourceType) );
				    System.debug('ah testing loop' + alternateThumbnailImgs[i].uri);
                }
			}
		}

		cc_bean_MediaWrapper mi = pmDao.getProductImage(new List<String> {currentProductID},
													cc_util_Locale.getUserLanguage()).get(currentProductID);
		System.debug(LoggingLevel.INFO, '--- cc_ctrl_ProductDetail.collectProductRelatedData: mi=' + mi);
		cc_bean_MediaWrapper thumb = pmDao.getProductThumbnailMedia(new List<String> {currentProductID},
													cc_util_Locale.getUserLanguage()).get(currentProductID);
		System.debug(LoggingLevel.INFO, '--- cc_ctrl_ProductDetail.collectProductRelatedData: thumb=' + thumb);
		if(mi != null)
		{
			productForm.mainImage=mi.uri;
			productForm.thumbImage=thumb.uri;
			productForm.sourceType=mi.sourceType;
			productForm.Alt_Message = mi.altMessage;
			productForm.imageIds = ids;
			System.debug('ah testing'+ids);
		}
		else
		{
			productForm.mainImage=null;
			productForm.sourceType=null;
			productForm.Alt_Message = null;
		}
		System.debug('----Limits.getQueries()-cc_ctrl_ProductDetail.readProduct3---- : ' + Limits.getQueries());
		productForm.imageIds = ids;

		Map<Id, cc_bean_MediaWrapper> idSearchMap = pmDAO.getProductSearchMedia(v_idList);
		itemIncludedListViewData = buildProductListViewData(l_itemIncludedList, priceMap, idSearchMap);
		if(itemIncludedListViewData != null) {
			for (cc_bean_ProductListViewData data : itemIncludedListViewData) {
				E_CompositeProduct__c cp1 = compositeMap.get(data.mockProduct.id);
				if(cp1 != null) {
					if(cp1.quantity__c != null) {
						data.qty = cp1.quantity__c.intValue();
					}
				}
			}
		}
		relatedProductList = buildProductListViewData(l_relatedProductList, priceMap, idSearchMap);
		crossSellProductList = buildProductListViewData(l_crossSellProductList, priceMap, idSearchMap);
		upSellProductList = buildProductListViewData(l_upSellProductList, priceMap, idSearchMap);
		requiredItemList = buildProductListViewData(l_requiredItemList, priceMap, idSearchMap);
		competitiveProductList = buildProductListViewData(l_competitiveProductList, priceMap, idSearchMap);
		complementaryProductList = buildProductListViewData(l_complementaryProductList, priceMap, idSearchMap);
		accessoryProductList = buildProductListViewData(l_accessoryProductList, priceMap, idSearchMap);

		List<Id> currentProductIDList = new List<Id>();
		currentProductIDList.add(currentProductID);
        if(storefront.InventoryCheckFlag__c){
	        Map<Id, Decimal> qtyMap = cc_api_Inventory.getAvailabilityQty(currentProductIDList);
	        if(qtyMap.get(currentProductID) != null){
				productForm.productInventory = qtyMap.get(currentProductID);
	        }
        }
		System.debug('----Limits.getQueries()-cc_ctrl_ProductDetail.readAllRelatedProducts---- : ' + Limits.getQueries());
	}

	private List<cc_bean_ProductListViewData> buildProductListViewData(List<E_Product__c> pList, Map<String,cc_bean_PriceInfo> priceMap, Map<Id, cc_bean_MediaWrapper> idSearchMap)
	{
		List<cc_bean_ProductListViewData> viewDataList = new List<cc_bean_ProductListViewData> ();
		for(E_Product__c pd : pList ) {
			cc_bean_ProductListViewData data = new cc_bean_ProductListViewData();
			data.product = pd;
			data.mockProduct = new cc_bean_MockProduct(pd);
			if(priceMap != null && priceMap.containsKey(pd.SKU__c)) {
			    data.priceBean = priceMap.get(pd.SKU__c);
			    System.debug('sns data.priceListItem = ' + data.priceBean);
			}
			else
			{
				//skip this product
                continue;
			}

			if(idSearchMap.get(pd.Id) != null) {
			    data.mediaWrapper = idSearchMap.get(pd.Id);
			}

			viewDataList.add(data);
		}
		return viewDataList;
	}
/* CC SaaS Mod - Schema Change - removed E_Review__c
	public List<E_Review__c> getReviews(E_Product__c prod) {
		return [Select e.Id,
				       e.ReviewDate__c,
				       e.Subject__c,
				       e.User__c,
				       e.UserReview__c,
				       e.RatingCode__c,
				       e.User__r.Contact.LastName,
				       e.User__r.Contact.FirstName
				   from E_Review__c e
				   where e.Product__c = :prod.ID
				   and e.Enabled__c = true
				   and e.IsDeleted = false
				   order by e.LastModifiedDate desc];
	}
*/
	
}