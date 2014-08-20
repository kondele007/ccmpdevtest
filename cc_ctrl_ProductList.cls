//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without
//  modification is PROHIBITED.
//
//
global with sharing class cc_ctrl_ProductList extends cc_ctrl_ProductCatalog implements al.ObjectPaginatorListener {
	private String txtReturn = cc_util_logging.SUCCESS;
    private String txStatus = cc_util_logging.SUCCESS;
    private static String CLASSNAME = 'CloudCrazeUtils';
    private static String transactionLog = ''; 
    
        
	//==================================================
    // CONSTANTS
    //==================================================
	public static final String LANDING_PAGE = 'DEAD_LandingPage';
    public static final String QUICKORDER_VIEW = 'QuickOrder';
    public String VIEW_LIST = 'list';
    public String VIEW_DETAIL = 'detail';
	//==================================================
    // INSTANCE VARIABLES
    //==================================================
    public String sortOrder = null;
    public List<cc_bean_ProductListViewData> data = new List<cc_bean_ProductListViewData>();
    //==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public ID currentProductID { get; set; }
    public String currentCartID { get; set; }
    //public String viewState  {get; set;}
    public String operation {get; set;}

    public String currentCategory { get; set; }
    public Integer quantity {get;set;}
    // End conflicts

    public String PageTitle {get; set;}
    public String metaKeywords{get; set;}
    public String metaDescription {get; set;}

    public al.ObjectPaginator paginator {get; private set; }
    
    public List<cc_bean_ProductListViewData> cc_bean_ProductListViewData {get; private set;}
    public String searchString { get; set; }
    public Integer reviewCount{get;set;}
    public String thisCatName {get; set; }
    public String thisCatLongDesc {get; set; }


    //Set the navigation parameter to quick search if going through quick search
    public String navigationStr{get;set;}

    public Boolean displayCategoryBreadCrumb {get;set;}
    public Boolean displaySearchBreadCrumb {get;set;}
    public Boolean displayListView {get; set; }
    public Boolean displayTextView {get; set; }

    public String SORT_BY_NAME { get{ return 'byName';}}
    public String SORT_BY_PRICE { get { return 'byPrice';}}
    public String SORT_BY_RATING { get {return 'byRating';}}
    public String SORT_BY_DATE { get {return 'byDate';}}
    
    // building category list view in CCProductsInc.component no longer uses
    // this list.  However, cc_ctrl_HomePage still relies on this.
    
    public List<E_Category__c> childCatWithNoProdList {get; set; }
    // New list passed to CCProductsInc for category view.
    public List<cc_bean_CategoryListViewData> categoryData { get; set; }
    
    public Boolean noProductsRenderCat{get; set; }
    public Boolean leafCategory {get; set; }
    public Boolean renderNoProdMsg {get; set; }
    public Integer skipPage {
        get {
            if(skipPage < 0){
                skipPage = 0;
            }
            return skipPage;
        }
        set {
        	System.debug('--- setting skipPage to:' + value);
        	if(value == null) {
        		value = 0;
        	}
        	skipPage = value;
        }
    }
    public List<SelectOption> pageSizeOptions {
        get {
            if (pageSizeOptions == null) {
                pageSizeOptions = new List<SelectOption>();
                pageSizeOptions.add(new SelectOption('5','5'));
                pageSizeOptions.add(new SelectOption('25','25'));
                pageSizeOptions.add(new SelectOption('50','50'));
                pageSizeOptions.add(new SelectOption('100','100'));
            }
            return pageSizeOptions;
        }
        set;
    }

    public Integer pageSize {
    	get;
    	set {
            pageSize = value;
            if(paginator != null) {
        		paginator.setPageSize(value);
            }
	        Cookie sizeCookie = new Cookie('plps', String.valueOf(value), null, -1, false);
	        ApexPages.currentPage().setCookies(new Cookie[]{sizeCookie});
    	}
    }
    
    
    //==================================================
    // CONSTRUCTOR
    //==================================================
    public cc_ctrl_ProductList() {
    	super();
    	
    	System.debug('In Product List Controller');
    	quantity=1;
        readProductListViewCookie();
		displayListView = true;
		displayTextView = false;
		noProductsRenderCat = false;
		renderNoProdMsg = false;

		currentcartID=Apexpages.currentPage().getParameters().get('cartID');

		String tempID=ApexPages.currentPage().getParameters().get('productID');
		if(tempID == null) {
		    currentProductID=null;
		} else if(!(tempID.equals('') || tempID.equals('null'))) {
		    System.debug('--------Entering not null condition----------');
		    currentProductID=tempID;
		}

		//viewState=Apexpages.currentPage().getParameters().get('viewState');
		//if(viewState==NULL || viewState.equals('')) { viewState = LANDING_PAGE; }
		
		//System.debug('View State at cc_ctrl_ProductList: ' + viewState);
		PageTitle = storefront.SEO_Title_Site__c + '  |	 ' + storefront.SEO_Title_Detail__c;
		metaKeywords = storefront.SEO_Keywords__c;
		metaDescription = storefront.SEO_Description__c;
    }

    public cc_ctrl_ProductList(ApexPages.StandardController c) { this(); }
    public cc_ctrl_ProductList(cc_ctrl_HomePage tree) { this(); }
	public cc_ctrl_ProductList(cc_ctrl_MyAccount controller){ 
		this();
		
	}
	//==================================================
    // SERVICE METHODS
    //==================================================
	/**
	 * invoked from Products.page page action
	 */
    public void initProductList() {

		String op = Apexpages.currentPage().getParameters().get('operation');
		this.operation = op;

		if('quickSearch'.equals(op)) {
			String searchText = Apexpages.currentPage().getParameters().get('searchText');
			if(searchText != null && searchText.trim().length() != 0) {
				searchString = searchText;
				quickSearchNoReturn();
			}
	    } else {
			currentCategory=Apexpages.currentPage().getParameters().get('categoryID');
			System.Debug('CURRENTCTEGORYID'+currentCategory);
			listProduct();
	    }
    }

    public PageReference quickSearch() {
    	String methodName = 'quickSearch ';
		String currentCartID = Apexpages.currentPage().getParameters().get('cartID');
		String ipAddressLocation = Apexpages.currentPage().getParameters().get(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY);
		//String viewStateFromPage = Apexpages.currentPage().getParameters().get('viewState');

		displayCategoryBreadCrumb = false;
		displaySearchBreadCrumb = true;
		PageReference page=System.Page.Products;
		//viewState = 'ListView';
		try
		{
		navigationStr = 'CatalogSearchInc';
		
		displayListView = true;
		displayTextView = false;
		
        if(pageSize == null || pageSize < 5) {
        	pageSize = displayTextView ? 25 : 5;
        }
        List<Integer> pageSizeOptions = new List<Integer> {5,25,50,100};

		if (al.StringUtils.isNotBlank(searchString) && searchString.trim().length() > 1) {
		    searchString = String.escapeSingleQuotes(searchString);
		    System.debug ('sns1-1');
		    List<E_Product__c> results = searchForProducts(userLocale);
			System.debug('--- cc_ctrl_ProductList.quickSearch: results=' + results);
		    if (al.ArrayUtils.isEmpty(results)) {
				renderNoProdMsg = true;
				transactionLog = cc_util_logging.log(transactionLog, methodName + 'line 208: search string = ' + searchString + ' userLocale =' + userLocale);
		    }

            this.cc_bean_ProductListViewData = buildProductListViewData(results);

            System.debug('--- quickSearch: searchString=' + searchString);
            cc_hlpr_ProductSearchMatchComparator comparator = new cc_hlpr_ProductSearchMatchComparator(searchString);
            
            for(cc_bean_ProductListViewData v : cc_bean_ProductListViewData) {
                comparator.rankProduct(v);
            }  

            cc_bean_ProductListViewData =  cc_hlpr_CloudCrazeSorter.sortStandard(cc_bean_ProductListViewData);

            paginator = new al.ObjectPaginator(pageSize, pageSizeOptions, (al.ObjectPaginatorListener)this);
            paginator.setRecords((List<Object>)cc_bean_ProductListViewData); // triggers updatePage()
		} else {
            System.debug('----------cc_ctrl_ProductList.quickSearch-Not a valid search---------');
            paginator = new al.ObjectPaginator(pageSize, pageSizeOptions, (al.ObjectPaginatorListener)this);
            cc_bean_ProductListViewData = new List<cc_bean_ProductListViewData>();
            paginator.setRecords((List<Object>)cc_bean_ProductListViewData); // triggers updatePage()
            renderNoProdMsg = true;
            transactionLog = cc_util_logging.log(transactionLog, methodName + 'searchString is empty');
		}

		//viewState='ListView';
		this.thisCatName = '';
		this.thisCatLongDesc = '';
		
		paginator.setRecords((List<Object>)cc_bean_ProductListViewData); // triggers updatePage()

		
		page.getParameters().put('cartID', currentCartID);
		page.getParameters().put('operation', 'quickSearch');
		page.getParameters().put('searchText',searchString);
		page.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, ipAddressLocation);
		page.setRedirect(true);
        System.debug('--- forwarding to page: ' + page.getUrl());
        transactionLog = cc_util_logging.log(transactionLog, methodName + 'forwarding to page:' + page.getUrl());
        //set cookie
        setProductListViewCookie();
		}
		catch(Exception e) {
			String exceptionMessage = cc_util_logging.constructExceptionMessageString(e);   
            cc_util_logging.createExceptionWithoutFuture(CLASSNAME + '.' + methodName, e.getTypeName(), exceptionMessage, null, null);
		}
		finally {
			transactionLog = cc_util_logging.log(transactionLog, 'End ' + methodName + ' Method');
            cc_util_logging.addToCCLog(CLASSNAME, methodName, '', '', txStatus, transactionLog);
		}
		return page;
    }

    public void quickSearchNoReturn(){
		quickSearch();
    }

    public PageReference listProduct() {
    	String methodName = 'listProduct ';
    	transactionLog = '';
		//System.debug('-----cc_ctrl_ProductList.listProduct-Request values - viewStateFromPage : ' + Apexpages.currentPage().getParameters().get('viewState'));
		//System.debug('-----cc_ctrl_ProductList.listProduct-(Start of method)viewState : ' + viewState);
		searchString = null;
		displayCategoryBreadCrumb=true;
		displaySearchBreadCrumb=false;

		//TASK ID 31 VS START
		childCatWithNoProdList = new List<E_Category__c>();
		
		renderNoProdMsg	= false;
		// TASK ID 31 VS END

		//viewState='ListView';
		navigationStr='ListProduct';
		// Get the category IDs where the parent category ID matches the selected category

		List<E_Category__c> currentCatList = [select p.Name, p.LongDesc__c, (Select Id, Name, LongDesc__c, ShortDesc__c From CategoryI18Ns__r where Locale__c = :userLocale)
						      from E_Category__c p
						      where p.Id= :currentCategory
						      limit 1
						      ];
        System.debug('--- cc_ctrl_ProductList.listProduct: currentCatList=' + currentCatList);

		E_Category__c currentCat = null;
		if(currentCatList != null && currentCatList.size() > 0) {
		    currentCat = currentCatList[0];
		    
            System.debug('--- cc_ctrl_ProductList.listProduct: userLocale=' + userLocale + ', currentCat.CategoryI18Ns__r=' + currentCat.CategoryI18Ns__r);
		    if(currentCat.CategoryI18Ns__r != null && currentCat.CategoryI18Ns__r.size() > 0) {
		      this.thisCatName = currentCat.CategoryI18Ns__r[0].Name;
		      this.thisCatLongDesc = currentCat.CategoryI18Ns__r[0].LongDesc__c;
		    }else{
	          this.thisCatName = currentCat.Name;
	          this.thisCatLongDesc = currentCat.LongDesc__c;
    	    }
		} else {
		    this.thisCatName ='';
		}

		List<E_Category__c> childCategories = [Select CategoryId__c,
														Name,
														ShortDesc__c
														from E_category__c
														where ParentCategory__c = :currentCategory];
										       
		System.debug('-----cc_ctrl_ProductList.listProduct()-Parent Categories ---- : ' + childCategories);
		if(childCategories != null && childCategories.size() > 0) {
		    leafCategory = false;
		} else {
		    leafCategory = true;
		}
		if (leafCategory) {
		    childCategories = [Select CategoryID__c,
							       Name,
							       ShortDesc__c
						       from E_Category__c
						       where Id = :currentCategory
						       order by Sequence__c];
						       
		    System.debug('-----cc_ctrl_ProductList.listProduct()-Child only Categories ---- : ' + childCategories);
		}

		List<String> childCategoryIds = new List<String>();

		if(childCategories != null && childCategories.size() > 0) {
		    for(E_Category__c thisCat : childCategories){
				childCategoryIds.add(thisCat.CategoryID__c);
		    }
		}

		// Get the products that are in the selected category or the selected categories children
		List<E_ProductCategory__c> pdl = [Select p.Product__r.ID
						  from E_ProductCategory__c p
						  where p.Category__c = :currentCategory /**or p.Category__r.CategoryID__c IN :childCategoryIds **/ order by p.Sequence__c limit 1000]; //TASK ID 1 START Change ProductID to Sku



		//List<E_ProductCategory__c> pdl = [Select p.Product__r.ID from E_ProductCategory__c p where p.CategoryID__c = :currentCategory limit 1000];
		List<Id> ids = new List<Id>();
		for(E_ProductCategory__c pc: pdl){
		    ids.add(pc.Product__r.ID);
		}
		//List<String> statusCodes = new List<String>();
		//statusCodes.add(cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED);
		//statusCodes.add(cc_cnst_PickListConstants.PRODUCTSTATUS_NOTORDERABLE);
		//String query = 'select p.Id,p.Name, p.SKU__c, p.ShortDesc__c from E_Product__c p where p.Id in :ids limit 1000';
		//String query = 'select p.Id,p.Name, p.SKU__c, p.ShortDesc__c, p.ProductStatus__c from E_Product__c p where p.Id in :ids and p.StatusCode__r.Code__c IN :statusCodes limit 1000';
		//String query = 'select p.Id,p.Name, p.SKU__c, p.ShortDesc__c, p.ProductStatus__c from E_Product__c p where p.Id in :ids and p.ProductStatus__c IN :statusCodes AND p.ProductType__c != \'' + cc_cnst_PickListConstants.PRODUCTTYPE_COUPON + '\' limit 1000';

		//System.debug('-----cc_ctrl_ProductList.listProduct()-query :' + query);
		//List<sObject> results = Database.query(query);

		List<E_Product__c> productList = cc_dao_Product.readProductForStatusAndTypeWithID(ids, userLocale, new List<String> {cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED, cc_cnst_PickListConstants.PRODUCTSTATUS_NOTORDERABLE}, cc_cnst_PickListConstants.PRODUCTTYPE_COUPON);

		List<E_Product__c> sortedProductList = new List<E_Product__c>();
		//sortedProductList = productList;
		
		Map<String,E_Product__c> productMap = new Map<String,E_Product__c>();
		for(E_Product__c p : productList) {
			// System.debug('sns -- p: ' + p.ShortDesc__c);
		    productMap.put(p.Id,p);
		}


		for(E_ProductCategory__c pd:pdl) {
		    E_Product__c prod= productMap.get(pd.Product__r.ID);
		    if(prod!=null) {
				sortedProductList.add(prod);
		    }
		}
		System.debug('-----cc_ctrl_ProductList.listProduct()-sortedProductList :' + sortedProductList);
        
		this.cc_bean_ProductListViewData = buildProductListViewData(sortedProductList);

        if(pageSize == null || pageSize < 5) {
            pageSize = displayTextView ? 25 : 5;
        }
        List<Integer> pageSizeOptions = new List<Integer> {5,25,50,100};

        paginator = new al.ObjectPaginator(pageSize, pageSizeOptions, (al.ObjectPaginatorListener)this);
        paginator.setRecords((List<Object>)cc_bean_ProductListViewData); // triggers updatePage()
        System.debug('--- paginator: pageSize=' + paginator.getPageSize());

		// TASK ID 31 VS START
		if(cc_bean_ProductListViewData == null || cc_bean_ProductListViewData.size() == 0) {
		    childCatWithNoProdList = childCategories;
		    categoryData = buildCategoryListViewData(childCategories);
		    noProductsRenderCat = true;
		}

		if(leafCategory && paginator.RecordCount < 1)
		    renderNoProdMsg = true;
		    transactionLog = cc_util_logging.log(transactionLog, methodName + 'line 392 :');
		// TASK ID 31 VS END
		for(E_Product__c prod: sortedProductList){
		    System.debug('-------- listProducts: ' + prod.Id + ' -----------------');
		}
		// getBreadCrumbs();
		//System.debug('-----cc_ctrl_ProductList.listProduct-(End of method)viewState : ' + viewState);

		System.debug('cc_bean_ProductListViewData'+cc_bean_ProductListViewData);
		transactionLog = cc_util_logging.log(transactionLog, 'End ' + methodName + ' Method');
            cc_util_logging.addToCCLog(CLASSNAME, methodName, '', '', txStatus, transactionLog);
		return null;
    }

	public List<E_Category__c> getchildCatWithNoProd() {
		return childCatWithNoProdList;
    }
    
    public List<cc_bean_CategoryListViewData> getCategoryData() {
    	return categoryData;
    }
    
    public List<cc_bean_ProductListViewData> getData(){
		//System.debug('--- inside getData: data size = ' + data.size() + '---');
		//System.debug('%%%%%%%%%% viewing alt_message --> ' + data[0].Alt_Message + ' %%%%%%%%%');
		return data;
    }

    public void changeSortOrder(){
        System.Debug('--- changing sort order to = ' + sortOrder);
        System.debug('--- cc_bean_ProductListViewData size 111 = ' + cc_bean_ProductListViewData.size());
        // Sort the cc_bean_ProductListViewData by the specified sort order

        if(SORT_BY_PRICE == sortOrder){
            System.debug('--- sorting by price ---');
            cc_bean_ProductListViewData = (List<cc_bean_ProductListViewData>)al.ArrayUtils.qsort(cc_bean_ProductListViewData, new cc_util_PriceComparator(), false);
			System.debug('--- cc_bean_ProductListViewData size 222 = ' + cc_bean_ProductListViewData.size());
            paginator.setRecords((List<Object>)cc_bean_ProductListViewData);
        }
        else if(SORT_BY_NAME == sortOrder){
        	System.debug('--- sorting by name ---');
            cc_bean_ProductListViewData = (List<cc_bean_ProductListViewData>)al.ArrayUtils.qsort(cc_bean_ProductListViewData, new cc_util_NameComparator(), true);
			System.debug('--- cc_bean_ProductListViewData size 222 = ' + cc_bean_ProductListViewData.size());
            paginator.setRecords((List<Object>)cc_bean_ProductListViewData);
        }
        else if(SORT_BY_DATE == sortOrder){
            System.debug('--- sorting by date ---');
            cc_bean_ProductListViewData = (List<cc_bean_ProductListViewData>)al.ArrayUtils.qsort(cc_bean_ProductListViewData, new cc_util_ProductDateComparator(), true);
			System.debug('--- cc_bean_ProductListViewData size 222 = ' + cc_bean_ProductListViewData.size());
            paginator.setRecords((List<Object>)cc_bean_ProductListViewData);
        }
        else { // SORT_BY_RATING
            System.debug('--- sorting by rating ---');
            cc_bean_ProductListViewData = (List<cc_bean_ProductListViewData>)al.ArrayUtils.qsort(cc_bean_ProductListViewData, new cc_hlpr_RatingComparator(), true);
			System.debug('--- cc_bean_ProductListViewData size 222 = ' + cc_bean_ProductListViewData.size());
            paginator.setRecords((List<Object>)cc_bean_ProductListViewData);
        }
		System.debug('--- cc_bean_ProductListViewData size 333 = ' + cc_bean_ProductListViewData.size());
    }
	//==================================================
    // HELPER METHODS
    //==================================================
    // These fields conflict with cc_ctrl_HomePage -
    public cc_ctrl_ProductList getProductListController()  { return this ; }
    public List<E_Spec__c> getCurrentCategorySpec()
    {
        //return PromotionUtils.getCategorySpecs(currentCategory);
        return null;
    }
    
    public String getSortOrder(){
        if(sortOrder == null){
            sortOrder = SORT_BY_RATING;
        }
        return sortOrder;
    }
    public void setSortOrder(String sortOrder){
        this.sortOrder = sortOrder;
    }

    public void skipToLocation(){
        if(paginator != null){
        	System.debug('--- skipPage=' + skipPage);
        	if(skipPage == null) {
        		skipPage = 0;
        	}
            paginator.skipToPage(skipPage);
        }
    }
	
    global void handlePageChange(List<Object> newPage){
		data.clear();

		// Get all the productCategoryList objects
		// Update the  list of records that should be returned (set them in the paginator)
		if(paginator.page != null){
		    for(Object o: paginator.page) {
				data.add((cc_bean_ProductListViewData)o);
		    }
		}
    }

	// Takes a list of categories and builds a list of cc_bean_CategoryListViewData objects.  The returned
	// list will contain the fields that should be shown to the user.
	public List<cc_bean_CategoryListViewData> buildCategoryListViewData(List<E_Category__c> categoryList) {
		System.debug('--->1');
		List<cc_bean_CategoryListViewData> result = new List<cc_bean_CategoryListViewData>();
		
		List<Id> categoryIdList = new List<Id>();
		Map<Id, E_Category__c> categoryMap = new Map<Id,E_Category__c>();
		
		// Get list of product Ids and map them to their Category
		for (E_Category__c currentCategory : categoryList) {
			categoryIdList.add(currentCategory.Id);
			categoryMap.put(currentCategory.Id, currentCategory);
		}
		System.debug('buildCategoryListViewData--->categoryIdList =>' + categoryIdList);
/*		
		// Get list of E_CategoryMedia__c Ids
		Map<Id,Id> categoryMediaMap = new Map<Id,Id>();
		Map<Id,Id> attachmentMap = new Map<Id,Id>();
		List<Id> categoryMediaIds = new List<Id>();
		List<E_CategoryMedia__c> categoryMediaList = [select cm.Id, cm.Category__c
													from E_CategoryMedia__c cm
													where cm.isDeleted = false and
														cm.Category__c in :categoryIdList];	
		if (categoryMediaList.size() > 0) {
			for (E_CategoryMedia__c categoryMedia : categoryMediaList) {
				categoryMediaMap.put(categoryMedia.Id, categoryMedia.Category__c);
				categoryMediaIds.add(categoryMedia.Id);
			}
			
			// Get list of Attachment IDs
			// NOTE -- media:attachments should be 1:1.	 Currently the data model has them as
			// 1:n.  This section should not be worked until the relationship is resolved.
			// Further, this query should be something like "where mediaType=primaryThumbnail"
			// or something similar since this is used for the product list view and search
			// results view.
			// By Roy - just get small image for list view
			List<Attachment> attachmentList = [select attachment.Id,
													attachment.ParentId
												from Attachment attachment
												where attachment.ParentId in :categoryMediaIds and
												(not attachment.Name like '%\_%')];
			
			// The media Id is the parent Id, so use parent Id to lookup the product
			if (attachmentList.size() > 0) {
				for (Attachment attachment : attachmentList) {
					Id categoryId = categoryMediaMap.get(attachment.ParentId);
					if (categoryId != null && !attachmentMap.containsKey(categoryId)) {
						attachmentMap.put(categoryId, attachment.Id);
					}
				}
			}
		}
*/		
		cc_dao_CategoryMedia cmDAO = new cc_dao_CategoryMedia();
		Map<Id,String> idSearchMap = cmDAO.getCategorySearchMedia(categoryIdList);
		Map<Id,String> idSearchMap2 = cmDAO.getCategoryAltMessages(categoryIdList);
		System.debug('buildCategoryListViewData--->idSearchMap =>' + idSearchMap);
		for (E_Category__c category : categoryList) {
			cc_bean_CategoryListViewData clvd = new cc_bean_CategoryListViewData();
			clvd.category = category;
			clvd.mockCategory = new cc_bean_MockCategory(category);
			Id attachmentId = idSearchMap.get(category.Id);
			clvd.Alt_Message = idSearchMap2.get(category.Id);
			System.debug('ah ah ah attachmentId'); 
			System.debug('attachment ah ah ' + attachmentId);
			if (attachmentId != null) {
				clvd.attachmentId = attachmentId;
				System.debug('ah attachmentId ah ah ah ' + attachmentId);
			} 
			System.debug('ah attachmentId ah ah ah ' + attachmentId);
			/*else {
				attachmentId = attachmentMap.get(category.Id);
				if (attachmentId != null) {
					clvd.attachmentId = attachmentId;
				}
			}*/ 
			result.add(clvd);
		}
		return result;
	}

    public override List<cc_bean_ProductListViewData> buildProductListViewData(List<E_Product__c> pdl) {
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
		map<String, Decimal> basePriceMap = cc_ctrl_PricingEngine.getBasePrice(skuList);
        Map<Id, Decimal> qtyAvlMap = null;
        if(storefront.InventoryCheckFlag__c)
        	qtyAvlMap = cc_api_Inventory.getAvailabilityQty(productIdList);
        
		// Get Map<SKU ID, PriceListItem> of prices
		/*Map<String, E_PriceListItem__c> priceLineMap = cc_ctrl_PricingEngine.getLowestPriceLineMap(skuList,
		                                                  cc_util_CloudCraze.getAccountID(),
		                                                  Date.today(),
		                                                  cc_ctrl_PricingEngine.getCurrencyCode(),
		                                                  cc_ctrl_PricingEngine.getCustomerType());*/
		Map<String, cc_bean_PriceInfo> priceLineMap = cc_ctrl_PricingEngine.getPriceMap(skuList, cc_util_CloudCraze.getAccountID(), null, null, null);
       
       // System.debug(LoggingLevel.INFO,'sns priceLineMap: ' + priceLineMap);
		//System.debug(LoggingLevel.INFO,'sns base price map: ' + basePriceMap);
		cc_dao_ProductMedia pmDAO = new cc_dao_ProductMedia();
		Map<Id, cc_bean_MediaWrapper> idSearchMap = pmDAO.getProductSearchMedia(productIdList);
		Map<Id, String> idSearchMap2 = pmDAO.getProductAltMessages(productIdList);

		for(E_Product__c pd : pdl ) {
			cc_bean_ProductListViewData data = new cc_bean_ProductListViewData();
			data.product = pd;
			data.basePrice = basePriceMap.get(pd.sku__c);
			//System.debug(LoggingLevel.INFO,'base price m-->ap: ' + data.basePrice);
			data.mockProduct = new cc_bean_MockProduct(pd);
			data.ccProduct = new cc_bean_Product(pd);
			//System.debug(LoggingLevel.INFO,'--- cc_ctrl_ProductList.buildProductListViewData: data.product=' + data.product);
			if(priceLineMap != null && priceLineMap.containsKey(pd.SKU__c)) {
			     data.priceBean=priceLineMap.get(pd.SKU__c);
                 //data.priceListItem = data.priceBean.priceListItem;
			    //System.debug(LoggingLevel.INFO,'sns data.priceListItem = ' + data.priceListItem);
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

			//System.debug(LoggingLevel.INFO,'@@@@@@@@@@idSearchMaplength   :	' + idSearchMap.size());
			//System.debug(LoggingLevel.INFO,'@@@@@@@@@@idSearchMaplength2   :	 ' + idSearchMap2.size());
 
			//System.debug(LoggingLevel.INFO,'@@@@@@@@@@Alt message  :	' + data.Alt_Message);

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
			//system.debug(LoggingLevel.INFO,'ryl - product media idSearchMap->' + idSearchMap);
			//system.debug(LoggingLevel.INFO,'ryl - product media product id->' + pd.Id);
			if(idSearchMap.get(pd.Id) != null) {
			    data.mediaWrapper = idSearchMap.get(pd.Id);
			} 
			//data.averageReview = getAverageRating(getReviews(pd));
			data.averageReview = 0.0;
	        //inventory
	        if(storefront.InventoryCheckFlag__c && qtyAvlMap != null)
	        {
		        if(qtyAvlMap.get(pd.Id) != null){
					data.productInventory = qtyAvlMap.get(pd.Id);
		        }
	        }
	        else if(storefront.InventoryCheckFlag__c == false)
	        {
	        	//if feature Inventory is not enable, always return 1 as inventory quantity
	        	data.productInventory =1; 
	        }
			localproductListViewData.add(data);
		}
		//System.debug(LoggingLevel.INFO,'localproductListViewData: ' + localproductListViewData);
		noOfQueries = Limits.getQueries();
		//System.debug(LoggingLevel.INFO,'----Limits.getQueries()2----- : ' + noOfQueries);
		//System.debug('-----cc_ctrl_ProductList.buildProductListViewData()-localproductListViewData----:' + localproductListViewData);
		//System.debug(LoggingLevel.INFO,'-----Exit cc_ctrl_ProductList.buildProductListViewData()-----');

		return localproductListViewData;
    }

/* CC SaaS Mod - Schema Change - removed E_Review__c
    private List<E_Review__c> getReviews(E_Product__c prod) {
		return [Select e.Id, e.ReviewDate__c, e.Subject__c, e.User__c, e.UserReview__c, e.RatingCode__c, e.User__r.Contact.LastName, e.User__r.Contact.FirstName from E_Review__c e where e.Product__c = :prod.ID and e.Enabled__c = true and e.IsDeleted = false order by e.LastModifiedDate desc ];
    }
*/
/* CC SaaS Mod - Schema Change - removed E_Review__c
    public Double getAverageRating(List<E_Review__c> reviews) {
		reviewCount=reviews.size();
		integer count = reviewCount;
		double total = 0.0;
		for(E_Review__c r : reviews) {
			total += double.valueOf(r.RatingCode__c);
		}
		if(count != 0) {
			return total/count;
		} else {
			return 0.0;
		}
    }
*/
    private List<E_Product__c> searchForProducts(String locale) {
		System.debug('-----Enter cc_ctrl_ProductList.searchForProducts()-----');
		displayListView = true;
		displayTextView = false;
		String methodName = 'searchForProducts ';
		//modification for localization...
		List<List<sObject>> resultList = cc_util_Search.searchObjects(searchString, getSearchFields(),getReturningClause(locale));
		
		List<Id> productIds = new List<Id>();
		for(List<sObject> sObjs : resultList ) {
			for(sObject s : sObjs) {
				if(s instanceof E_Product__c) {
					E_Product__c prd = (E_Product__c) s;
				    productIds.add(prd.Id);
				} else if(s instanceof E_ProductItemI18N__c) {
					E_ProductItemI18N__c pi = (E_ProductItemI18N__c) s;
				    productIds.add(pi.Product__c);
				} else if(s instanceof E_ProductTab__c) {
					E_ProductTab__c tab = (E_ProductTab__c)s;
					productIds.add(tab.Product__c);
				} else if(s instanceof E_ProductSpecIndex__c) {
					E_ProductSpecIndex__c spec = (E_ProductSpecIndex__c)s;
					productIds.add(spec.Product__c);
				}
			}
		}
		String pids = '';
		for(String pid : productIds) {
			pids += pid;
			pid += ';';
		}
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'found ids ' + pids); 
		cc_dao_Product pDao = new cc_dao_Product();
		List<E_Product__c> pList = pDao.readProductWithID(productIds);
		
		if(pList == null){
			pList = new List<E_Product__c>();
		}
		cc_util_logging.addToCCLog(CLASSNAME, methodName, '', '', cc_util_logging.SUCCESS, transactionLog);
		return pList;
    }

    public String getSearchString() {
		if(searchString == null) searchString = 'Enter search text';
		return searchString;
    }

    public String getSearchFields(){
		return 'All fields';
    }
/*
	 public String getReturningClause(String locale){
		System.debug('-----cc_ctrl_ProductList.getReturningClause-IPAddressLocation : ' + Apexpages.currentPage().getParameters().get(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY));
		String userLocation = Apexpages.currentPage().getParameters().get(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY);
		String returnClause = '';

		//disable storefront from search criteria till we revisit storefront feature
		returnClause = 'E_Product__c(Id'
		    + ' WHERE ProductStatus__c IN (\'' + cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED + '\', \'' + cc_cnst_PickListConstants.PRODUCTSTATUS_NOTORDERABLE + '\')'
		    + ' AND ProductType__c != \'' + cc_cnst_PickListConstants.PRODUCTTYPE_COUPON + '\''
		    + ' AND Storefront__c includes (\'' + storefront.Name + '\')'
		    + ')';

		returnClause += ', E_ProductItemI18N__c(Product__c'
		    + ' WHERE Product__r.ProductStatus__c IN (\'' + cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED + '\', \'' + cc_cnst_PickListConstants.PRODUCTSTATUS_NOTORDERABLE + '\')'
		    + ' AND Product__r.ProductType__c != \'' + cc_cnst_PickListConstants.PRODUCTTYPE_COUPON + '\''
		    + ' AND locale__c = \'' + locale + '\''
		    + ' AND Product__r.Storefront__c includes (\'' + storefront.Name + '\')'
		    + ')';

		returnClause += ', E_ProductTab__c(Product__c'
		    + ' WHERE Product__r.ProductStatus__c IN (\'' + cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED + '\', \'' + cc_cnst_PickListConstants.PRODUCTSTATUS_NOTORDERABLE + '\')'
		    + ' AND Product__r.ProductType__c != \'' + cc_cnst_PickListConstants.PRODUCTTYPE_COUPON + '\''
		    + ' AND locale__c = \'' + locale + '\''
		    + ' AND Product__r.Storefront__c includes (\'' + storefront.Name + '\')'
		    + ')';

		returnClause += ', E_ProductSpecIndex__c(Product__c'
		    + ' WHERE Product__r.ProductStatus__c IN (\'' + cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED + '\', \'' + cc_cnst_PickListConstants.PRODUCTSTATUS_NOTORDERABLE + '\')'
		    + ' AND Product__r.ProductType__c != \'' + cc_cnst_PickListConstants.PRODUCTTYPE_COUPON + '\''
		    + ' AND Product__r.Storefront__c includes (\'' + storefront.Name + '\')'
		    + ')';

		System.debug('-----cc_ctrl_ProductList.getReturningClause-returnClause : ' + returnClause);
		return returnClause;
    }
  */  
      
   
    public String getReturningClause(String locale){
		System.debug('-----cc_ctrl_ProductList.getReturningClause-IPAddressLocation : ' + Apexpages.currentPage().getParameters().get(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY));
		String userLocation = Apexpages.currentPage().getParameters().get(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY);
		String returnClause = '';

		//disable storefront from search criteria till we revisit storefront feature
		returnClause = '{0}E_Product__c(Id'
		    + ' WHERE {0}ProductStatus__c IN (\'\'' + cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED + '\'\', \'\'' + cc_cnst_PickListConstants.PRODUCTSTATUS_NOTORDERABLE + '\'\')'
		    + ' AND {0}ProductType__c != \'\'' + cc_cnst_PickListConstants.PRODUCTTYPE_COUPON + '\'\''
		    + ' AND Storefront__c includes (\'\'' + storefront.Name + '\'\')'
		    + ')';

		returnClause += ', {0}E_ProductItemI18N__c({0}Product__c'
		    + ' WHERE {0}Product__r.{0}ProductStatus__c IN (\'\'' + cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED + '\'\', \'\'' + cc_cnst_PickListConstants.PRODUCTSTATUS_NOTORDERABLE + '\'\')'
		    + ' AND {0}Product__r.{0}ProductType__c != \'\'' + cc_cnst_PickListConstants.PRODUCTTYPE_COUPON + '\'\''
		    + ' AND {0}locale__c = \'\'' + locale + '\'\''
		    + ' AND {0}Product__r.{0}Storefront__c includes (\'\'' + storefront.Name + '\'\')'
		    + ')';

		returnClause += ', {0}E_ProductTab__c({0}Product__c'
		    + ' WHERE {0}Product__r.{0}ProductStatus__c IN (\'\'' + cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED + '\'\', \'\'' + cc_cnst_PickListConstants.PRODUCTSTATUS_NOTORDERABLE + '\'\')'
		    + ' AND {0}Product__r.{0}ProductType__c != \'\'' + cc_cnst_PickListConstants.PRODUCTTYPE_COUPON + '\'\''
		    + ' AND {0}locale__c = \'\'' + locale + '\'\''
		    + ' AND {0}Product__r.{0}Storefront__c includes (\'\'' + storefront.Name + '\'\')'
		    + ')';

		returnClause += ', {0}E_ProductSpecIndex__c({0}Product__c'
		    + ' WHERE {0}Product__r.{0}ProductStatus__c IN (\'\'' + cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED + '\'\', \'\'' + cc_cnst_PickListConstants.PRODUCTSTATUS_NOTORDERABLE + '\'\')'
		    + ' AND {0}Product__r.{0}ProductType__c != \'\'' + cc_cnst_PickListConstants.PRODUCTTYPE_COUPON + '\'\''
		    + ' AND {0}Product__r.{0}Storefront__c includes (\'\'' + storefront.Name + '\'\')'
		    + ')';
		//System.debug(LoggingLevel.INFO,'-----cc_ctrl_ProductList.getReturningClause-returnClause 1 : ' + returnClause);
		String param0 = cc_util_CloudCraze.localNamespace;
		returnClause = String.format(returnClause, new List<String> {param0} );
		
		//System.debug(LoggingLevel.INFO,'-----cc_ctrl_ProductList.getReturningClause-returnClause 2 : ' + returnClause);
		return returnClause;
    }


    public List<cc_bean_ProductListViewData> relatedProducts(Id productID, String typeCode) {
		System.debug('-------------------------------' + productID);
		System.debug('-------------------------------' + typeCode);
		List<String> prodSkuList = new List<String>();
		List<E_Product__c> prodList = new List<E_Product__c>();
		List<E_RelatedProduct__c> related = [Select 
						     e.RelatedProduct__r.SKU__c
						     from E_RelatedProduct__c e
						     where e.enabled__c=true and e.isDeleted=false and
						     e.Product__c = :productID and
						     e.RelatedProductType__c = :typeCode
						     and e.StartDate__c <= :System.Today() and e.EndDate__c > :System.Today()
						     ];
		for(E_RelatedProduct__c rp : related) {
			System.debug('------888888---------' + rp.RelatedProduct__r.SKU__c);
			//prodList.add(rp.RelatedProduct__r);
			prodSkuList.add(rp.RelatedProduct__r.SKU__c);
		}
		cc_dao_product prodDao = new cc_dao_product();
		prodList = prodDao.readProduct(prodSkuList);
		List<cc_bean_ProductListViewData> localProductListViewData = new List<cc_bean_ProductListViewData>();
		localProductListViewData = buildProductListViewData(prodList);
		return localProductListViewData;
    }
	
    public override PageReference addRelatedProductsToCart() {
		String ipAddressLocation = Apexpages.currentPage().getParameters().get(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY);
		String currentCategory = Apexpages.currentPage().getParameters().get('categoryID');
		System.debug('-----cc_ctrl_ProductList.addRelatedProductsToCart()-Request values-currentCategory : ' + currentCategory);
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
		System.debug('StoreID: ' + StoreID);
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
				currentCartID = cc_api_Cart.addToCart( sProduct.productListViewData.product.ID, currentCartID, 1, storeID );
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


    public List<cc_bean_ProductListViewData> accessories {
		get { return relatedProducts(currentProductID, cc_cnst_PickListConstants.RELATEDPRODUCT_RELATED); }
		private set;
	}

    public List<cc_bean_ProductListViewData> relatedItems {
		get { return relatedProducts(currentProductID, cc_cnst_PickListConstants.RELATEDPRODUCT_COMPETITIVE); }
		private set;
    }

    //public ID selectedProduct { get;set; }

    public List<cc_bean_SelectableProduct> selectableProductList = new List<cc_bean_SelectableProduct>();

    public List<cc_bean_SelectableProduct> getSelectableProductList() {
		return selectableProductList;
    }

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

    public void renderListView() {
        displayListView = true;
        displayTextView = false;
        pageSize = 5;
        setProductListViewCookie();
    }

    public void renderTextView() {
        displayListView = false;
        displayTextView = true;
        pageSize = 25;
        setProductListViewCookie();
    }

    public void setProductListViewCookie() {
    	String view = VIEW_LIST;
    	if(displayListView) {
    		view = VIEW_DETAIL;
    	}

    	Cookie viewCookie = new Cookie('plv', view, null, -1, false);
        Cookie sizeCookie = new Cookie('plps', String.valueOf(pageSize), null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{viewCookie,sizeCookie});
    }

    public void readProductListViewCookie() {
    	// defaults
        displayListView = true;
        displayTextView = false;

        // plv = product list view
    	Cookie viewCookie = ApexPages.currentPage().getCookies().get('plv');
    	if(viewCookie != null) {
    		String view = viewCookie.getValue();
    		if(VIEW_DETAIL == view) {
		        displayListView = true;
		        displayTextView = false;
    		}
    	}

    	// plps = product list page size
        Cookie sizeCookie = ApexPages.currentPage().getCookies().get('plps');
        if(sizeCookie != null) {
            String size = sizeCookie.getValue();
            if(size != null) {
            	pageSize = Integer.valueOf(size);
            }
        } else {
            pageSize = displayTextView ? 25 : 5;
        }
    }
}