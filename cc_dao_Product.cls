//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without
//  modification is PROHIBITED.
//
//
//**
// * @Description: Data Persistency for Product Custom Object
// * @Author: 1.0
// * @File: cc_dao_Product
// * ==========================================================
// * 2009/06/03 1.0 IL - Created.
// * 2012/08/13 1.1 IL - Refactored into Dynamic SOQL, Added parent product query
// **/
public with sharing class cc_dao_Product {
	public static final String DefaultRootName = 'Root';
	public String sku {get;set;}
    public String productId {get;set;}
    
    public cc_dao_Product() {}
    
    
    /*****************************************************
     * CATEGORY
     * Category-related DAO methods for retrieving and adding 
     * categories with respect to the category hierarchy.
     *****************************************************/
     
	/*
     * Reads a category ID and locale and returns the category object. Changes
     * the name and description for a locale if it exists.
     * @param cID category ID
     * @param locale used for localization
     * @returns a category object
     */
	public List<E_Category__c> readCategory(String categoryID, String locale) {
		List<E_Category__c> categoryList = new List<E_Category__c>();
		String query = buildBaseCategoryQuery(locale);
		query += ' Where e.Id = \'' + categoryID + '\'';
		categoryList =   Database.query(query);
		applyIntlValues(categoryList);
		return categoryList;
	}

	/*
	 * Retrieves the name of the root category.
	 * @return String root category name
	 */	
	public String getRootCategoryName() {
		String rootName = cc_cnst_CloudCraze.DEFAULT_ROOT_CATEGORY_NAME;
		if (rootName == null)
		    rootName = DefaultRootName;
		return rootName;
    }
	
	/*
	 * Retrieves all of the top-level categories that are directly under the
	 * root category.
	 * @return List list of top level category objects
	 */
	public List<E_Category__c> getTopCategories() {
		String rootName = getRootCategoryName();
		List<E_Category__c> catList = [
							Select 
								e.Id,
								e.Name
							From 
								E_Category__c e
							Where 
								e.ParentCategory__r.Name= :rootName 
							Order by 
								e.sequence__c DESC ];
		return catList;
	}
	
	/*
	 * Retrieves the root category.
	 * @return E_Category__c root category
	 */
	public E_Category__c getRootCategory() {
		E_Category__c rootObj = null;
		String rootName = getRootCategoryName();
		List<E_Category__c> catList = [
							Select 
								e.Id,
								e.Name
							From 
								E_Category__c e
							Where 
								e.Name= :rootName
								and e.IsDeleted=false ];
		if (catList.size() > 1)
			throw new cc_excn_DuplicateRootCategoryException();
		else if (catList.size() == 0) {
			rootObj = new E_Category__c(Name=rootName, shortdesc__c='Root Category', CategoryID__c='123', Sequence__c=0);
			insert rootObj;
		} 
		else
			rootObj = catList[0];
		return rootObj;
	}	
	
	/*
     * Reads a category ID and locale and returns a list of the children
     * categories. Changes the name and description for a locale if it exists.
     * @param parentID category ID
     * @param locale used for localization
     * @return list of categories that are children of the specified category
     */
	public static List<E_Category__c> getChildCategories(String parentId, String locale) {
		List<E_Category__c> categoryList = new List<E_Category__c>();
		cc_dao_Product dao = new cc_dao_Product();
		String query = dao.buildBaseCategoryQuery(locale);
		query += ' Where e.ParentCategory__c = \'' + parentId + '\'';
		query += ' Order by e.Sequence__c DESC, e.name DESC';
		categoryList =   Database.query(query); 
		dao.applyIntlValues(categoryList);
		return categoryList;
	}
	
	/*
	 * Creates the passed in category.
	 * @param category category to create
	 */
	public void addCategory(E_Category__c category) {
		List<E_Category__c> cs = [
							Select 
								e.Id
							From 
								E_Category__c e
							Where 
								e.ParentCategory__c = :category.ParentCategory__c
								and e.Name = : category.Name
								and e.IsDeleted = false ];
		if (cs.size() == 0)
			insert category;
		else
			throw new cc_excn_DuplicatedCategoryException('Category ' + category.Name + ' exists in category ' + category.ParentCategory__c);
	}
	
	/*
	 * Add the passed in product to the passed in category.
	 * @param categoryId category ID
     * @param product product to add
     * @returns a category object corresponding to the id
	 */
	public E_ProductCategory__c addProductCategory(ID categoryId, E_Product__c product) {
		if (product.Id == null) {
			List<E_Product__c> pl = readProduct(product.SKU__c);
			if (pl.size() == 0)
				product = saveProduct(product);
			else
					product = pl[0];
		}
		List<E_ProductCategory__c> cs = [
							Select 
								e.Id
							From 
								E_ProductCategory__c e
							Where 
								e.Category__c = :categoryId
								and e.Product__c = : product.Id
								and e.IsDeleted = false ];
		if (cs.size() == 0) {
			E_ProductCategory__c pc = new E_ProductCategory__c(Product__c=product.Id, Category__c=categoryId);
			insert pc;
			return pc;
		} else
		    throw new cc_excn_DuplicatedProductCatException('Product ' + product + ' exists in category ' + categoryId);
	}	
	
	/*
	 * Sets the name and description fields on each category in the passed in
	 * list to use the corresponding internationalized value.
	 * @param categoryList list of categories
	 */
	private void applyIntlValues(List<E_Category__c> categoryList) {
		for(E_Category__c p : categoryList) {
			List<E_CategoryI18N__c> ppl = p.CategoryI18Ns__r;
			for(E_CategoryI18N__c pp : ppl) {
				p.Name = pp.Name;
				p.ShortDesc__c = pp.ShortDesc__c;
				p.LongDesc__c = pp.LongDesc__c;
			}
		}
	}
	
	/*
	 * Constructs the base query used for retrieving detailed category
	 * related data, including the intl subquery.
	 * @param locale locale to use for intl
	 * @return String base category query
	 */
	private String buildBaseCategoryQuery(String locale) {
		locale = String.escapeSingleQuotes(locale);
		String baseQuery = 'Select';
		baseQuery += ' e.ShortDesc__c, e.Sequence__c, e.ProductCount__c, e.ParentCategory__c, e.Name, e.LongDesc__c, e.Id, e.ChildCategoryCount__c, ';
		baseQuery += ' (Select Name, Locale__c, LongDesc__c, ShortDesc__c From  CategoryI18Ns__r Where Locale__c =:locale)';
		baseQuery += ' From ';
		baseQuery += ' E_Category__c e ';
		return baseQuery;
	}
	

	/*****************************************************
     * PRODUCT
     * Product-related DAO methods for retrieving, adding, and deleting
     * products.
     *****************************************************/
	
    /*
     * Returns a product based on the sku.
     * @param sku product sku
     * @return list containing one product
     */
    public List<E_Product__c> readProduct(String sku) {
    	System.debug('XXX Dynamic Query: ');
		return readProduct(sku, cc_util_Locale.getUserLanguage());
    }
    
    /*
     * Returns a product based on the sku for a specific locale.
     * @param sku product sku
     * @param locale used to localize product name and description
     * @return list containing one product
     */
    public List<E_Product__c> readProduct(String sku, String locale) {
		List<String> skus = new List<String> { sku };
		return readProduct(skus, locale);
    }
    
    /*
     * Returns a list of products based on a list of skus
     * skus list of skus
     * @return list of products
     */
	public List<E_Product__c> readProduct(List<String> skus) {
		return readProduct(skus, cc_util_Locale.getUserLanguage());
    }

    /*
     * Returns a list of products based on a list of skus for a specific
     * locale.
     * @param skus list of skus
     * @param locale used to localize product name and description
     * @return list of products
     */
 	public List<E_Product__c> readProduct(List<String> skus, String locale) {
		List<String> statusCodes = getStandardStatusFilter();
		Date currDate = System.today();
		List<E_Product__c> productList = new List<E_Product__c>();
		String query = buildBaseProductSelectQuery();
		if(!Test.isRunningTest())
			query += ', ' + buildProductSpecSelectSubquery(locale);
		if(!Test.isRunningTest())
			query += buildProductTabsSelectSubquery(locale);
		if(!Test.isRunningTest())
			query += buildProductIntlSelectSubquery(locale);
		query += buildProductFromClause();
		query += ' Where e.SKU__c IN :skus and e.ProductStatus__c IN :statusCodes ';
		if(!Test.isRunningTest())
			query += buildProductEffectiveDateWhereClauses(currDate);
		productList = Database.query(query);
		applyParentAttributesToChildren(productList, locale);
		return productList;
    }
    
    /*
     * Returns a product based on the id.
     * @param id product id
     * @return list containing one product
     */
    public List<E_Product__c> readProductWithID(ID pid) {
		List<ID> ids = new List<ID> { pid };
		return readProductWithID(ids, cc_util_Locale.getUserLanguage());
    }

	/*
     * Returns a product based on the id for a specific locale.
     * @param id product id
     * @param locale used to localize product name and description
     * @return list containing one product
     */
    public List<E_Product__c> readProductWithID(ID pid, String locale) {
		List<ID> ids = new List<ID> { pid };
		return readProductWithID(ids, locale);
    }
    
    /*
     * Returns a list of products based on a list of ids
     * skus list of ids
     * @return list of products
     */
    public List<E_Product__c> readProductWithID(List<ID> ids){
    	 return readProductWithID(ids,cc_util_Locale.getUserLanguage());
    }

	/*
     * Returns a list of products based on a list of ids for a specific
     * locale.
     * @param ids list of ids
     * @param locale used to localize product name and description
     * @return list of products
     */
    public List<E_Product__c> readProductWithID(List<ID> ids, String locale) {
    	List<String> statusCodes = getStandardStatusFilter();
		Date currDate = System.today();
		List<E_Product__c> productList = new List<E_Product__c>();
		String query = buildBaseProductSelectQuery();
		if(!Test.isRunningTest())
			query += ', ' + buildProductSpecSelectSubquery(locale);
		if(!Test.isRunningTest())
			query += buildProductIntlSelectSubquery(locale);
		query += buildProductFromClause();
		query += ' Where e.id  IN :ids ';
		if(!Test.isRunningTest())
			query += ' and e.ProductStatus__c IN :statusCodes ';
		if(!Test.isRunningTest())
			query += buildProductEffectiveDateWhereClauses(currDate);
		System.debug(LoggingLevel.INFO, '$$Roster query=' + query);
		productList = Database.query(query);
		applyParentAttributesToChildren(productList, locale);
		return productList;
    }

    /*
     * Returns a list of products. Includes product if it belongs to the
     * requested store. Also uses localization if available.
     * @param skus
     * @param locale
     * @param storeID
     * @return list of products
     */
    public static List<E_Product__c> readProductForStore(List<String> skus, String locale, String storeID) {
		Date currDate = System.today();
		List<E_Product__c> productList = new List<E_Product__c>();
		String query = buildBaseProductSelectQuery();
		query += ',' + buildProductIntlSelectSubquery(locale);
		query += buildProductFromClause();
		query += ' Where e.SKU__c IN :skus and e.Storefront__c includes (:storeID) ';
		if(!Test.isRunningTest())
			query += buildProductEffectiveDateWhereClauses(currDate);
		productList = Database.query(query);
		applyIntlValues(productList);
		return productList;
    }

	/*
     * Returns a list of products. Includes product if it contains the
     * requested status. Also uses localization if available.
     * @param skus
     * @param locale
     * @param status
     * @return list of products
     */
    public static List<E_Product__c> readProductForStatus(List<String> skus, String locale, String status) {
		return readProductForStatus(skus, locale, new List<String> {status} );
    }

	/*
     * Returns a list of products. Includes product if it contains any of the
     * requested statuses. Also uses localization if available.
     * @param skus
     * @param locale
     * @param statuses
     * @return list of products
     */
    public static List<E_Product__c> readProductForStatus(List<String> skus, String locale, List<String> statusCodes) {
    	Date currDate = System.today();
		List<E_Product__c> productList = new List<E_Product__c>();
		String query = buildBaseProductSelectQuery();
		query += ',' + buildProductIntlSelectSubquery(locale);
		query += buildProductFromClause();
		query += ' Where e.SKU__c IN :skus and ProductStatus__c IN :statusCodes ';
		if(!Test.isRunningTest())
			query += buildProductEffectiveDateWhereClauses(currDate);
		productList = Database.query(query);
		applyIntlValues(productList);
		return productList;
    }

	/*
     * Returns a list of products. Includes product if it contains any of the
     * requested statuses. Also uses localization if available.
     * @param ids
     * @param locale
     * @param statusCodes
     * @return list of products
     */
    public static List<E_Product__c> readProductForStatusWithID(List<String> ids, String locale, List<String> statusCodes) {
    	Date currDate = System.today();
		List<E_Product__c> productList = new List<E_Product__c>();
		String query = buildBaseProductSelectQuery();
		query += ', ' + buildProductIntlSelectSubquery(locale);
		query += buildProductFromClause();
		query += ' Where e.ID IN :ids and ProductStatus__c IN :statusCodes ';
		if(!Test.isRunningTest())
			query += buildProductEffectiveDateWhereClauses(currDate);
		productList = Database.query(query);
		applyParentAttributesToChildren(productList, locale);
		return productList;
    }

	/*
     * Returns a list of products. Includes product if it contains any of the
     * requested statuses and type. Also uses localization if available.
     * @param skus
     * @param locale
     * @param statusCodes
     * @param productType
     * @return list of products
     */
    public static List<E_Product__c> readProductForStatusAndType(List<String> skus, String locale, List<String> statusCodes, String productType) {
    	Date currDate = System.today();
		List<E_Product__c> productList = new List<E_Product__c>();
		String query = buildBaseProductSelectQuery();
		query += ', ' + buildProductIntlSelectSubquery(locale);
		query += buildProductFromClause();
		query += ' Where e.SKU__c IN :skus and ProductStatus__c IN :statusCodes and ProductType__c != :productType ';
		if(!Test.isRunningTest())
			query += buildProductEffectiveDateWhereClauses(currDate);
		productList = Database.query(query);
		applyParentAttributesToChildren(productList, locale);
		return productList;
    }

	/*
     * Returns a list of products. Includes product if it contains any of the
     * requested statuses and type. Also uses localization if available.
     * @param ids
     * @param locale
     * @param statusCodes
     * @param productType
     * @return list of products
     */
    public static List<E_Product__c> readProductForStatusAndTypeWithID(List<String> ids, String locale, List<String> statusCodes, String productType) {
    	Date currDate = System.today();
		List<E_Product__c> productList = new List<E_Product__c>();
		String query = buildBaseProductSelectQuery();
		query += ', ' + buildProductSpecSelectSubquery(locale);
		query += buildProductIntlSelectSubquery(locale);
		query += buildProductFromClause();
		query += ' Where e.Id  IN :ids and ProductStatus__c IN :statusCodes and ProductType__c != :productType ';
		if(!Test.isRunningTest())
			query += buildProductEffectiveDateWhereClauses(currDate);
		productList = Database.query(query);
		applyParentAttributesToChildren(productList, locale);
		return productList;
    }
    
    /*
     * Constructs the base select clause for product queries.
     * @return base select statement
     */
    private static String buildBaseProductSelectQuery() {
    	return 'Select ' +
			    		'e.Id, ' +
						'e.ParentProduct__c, ' +
						'e.ParentProduct__r.SKU__c, ' +
						'e.LeadTime__c, ' +
						'e.LongDesc__c, ' +
						'e.Name, ' +
						'e.QuantityPerUnit__c, ' +
						'e.RecordTypeId, ' +
						'e.ReviewFlag__c, ' +
						'e.ServiceFlag__c, ' +
						'e.ShortDesc__c, ' +
						'e.SKU__c, ' +
						'e.ProductType__c, ' +
						'e.ProductStatus__c, ' +
						'e.SupersedeProduct__c, ' +
						'e.UnitOfMeasure__c, ' +
						'e.StartDate__c, ' +
						'e.EndDate__c, ' +
						'e.AvailabilityMessage__c, ' +
						'e.RequiredItemDialogText__c, ' +
						'e.InventoryType__c, ' +
						'e.ProductWeight__c, ' +
			            'e.ShippingWeight__c, ' +
			            'e.GroundFlag__c, ' +
			            'e.HazardousFlag__c, ' +
			            'e.CoolerpakFlag__c, ' +
			            'e.OvernightFlag__c, ' +
			            'e.SEODescription__c, ' +
			            'e.SEOKeywords__c, ' +
			            'e.Industry__c, ' +
			            'e.Employment_Level__c, ' +
			            'e.ShippedIndividually__c, ' +
			            'e.ShipSeparately__c, ' +
			            'e.Taxable__c, ' +
			            'e.TaxRateId__c, ' +
			            'e.SEOTitle__c ' +
			            /* Custom fields for Kaplan*/
			            ', ' +
	    				'e.BillingInstallments__c, ' +
	    				'e.ClassEndDate__c, ' +
	    				'e.ClassStartDate__c, ' +
	    				'e.Code__c, ' +
	    				'e.Country__c, ' +
	    				'e.DeliveryType__c, ' +
	    				'e.EventType__c, ' +
	    				'e.FlexStartDateEnabled__c, ' +
	    				'e.FlexStartDateMaxDuration__c, ' +
	    				'e.IsHSKEnabled__c, ' +
	    				'e.isLiveOnlineEvent__c, ' +
	    				'e.Max_Allowed_Quantity__c,' +
	    				'e.ProgramCode__c ';
    }
    
     /*
     * Constructs the intl sub-select clause for product queries.
     * @return base select statement
     */
    private static String buildProductIntlSelectSubquery(String locale) {
    	return '(Select ' + 
						'Name, ' + 
						'LongDesc__c, ' + 
						'ShortDesc__c, ' + 
						'Locale__c ' + 
					'From ' + 
						'Product_Item_I18Ns__r ' + 
					'Where ' + 
						'Locale__c =:locale' + 
					') ';
    }
    
    /*
     * Constructs the specs sub-select clause for product queries.
     * @return base select statement
     */
    private static String buildProductSpecSelectSubquery(String locale) {
    	return '(Select ' + 
    					'Spec__r.Name, ' + 
						'Spec__r.DisplayName__c, ' + 
						'Spec__r.SpecGroup__c, ' + 
						'SpecValue__c ' + 
					'From ' + 
						'Product_Spec_Indicies__r ' + 
					'Where ' + 
						'Spec__r.isVisibleInCatalog__c = true ' + 
						'And Spec__r.Locale__c =: locale ' + 
					'Order By ' + 
						'Spec__r.Sequence__c ASC ' + 
					'), ';
    }
    
    /*
     * Constructs the tabs sub-select clause for product queries.
     * @return base select statement
     */
    private static String buildProductTabsSelectSubquery(String locale) {
    	return '(Select ' +
			    		'Id, ' +
			    		'Tab__c, ' + 
			    		'Content__c ' +
					'From ' +
						'E_ProductTabs__r ' +
					'Where ' +
						'(Locale__c = :locale ' +
						'Or Locale__c = null) ' +
					'), ';
    }
    
    /*
     * Constructs the product from clause for product queries.
     * @return base select statement
     */
    private static String buildProductFromClause() {
    	return ' From E_Product__c e ';
    }
    
    /*
     * Constructs the effective date where clauses for product queries.
     * @return base select statement
     */
    private static String buildProductEffectiveDateWhereClauses(Date currDate) {
    	return ' and (e.StartDate__c = null or e.StartDate__c <= :currDate) ' + 
				'and (e.EndDate__c = null or e.EndDate__c >= :currDate) ';
    }
    
    /*
     * Deletes the product corresponding to the passed in Id.
     * @param productId
     */
    public void deleteProduct(String productId) {
		List<E_Product__c> productList = [
							Select e.Id,
								e.LeadTime__c,
								e.LongDesc__c,
								e.Name,
								e.ParentProduct__c,
								e.QuantityPerUnit__c,
								e.RecordTypeId,
								e.ReviewFlag__c,
								e.ServiceFlag__c,
								e.ShortDesc__c,
								e.SKU__c,
								e.ProductType__c,
								e.ProductStatus__c,
								e.SupersedeProduct__c,
								e.UnitOfMeasure__c
							From 
								E_Product__c e
							Where e.Id =:productId ];
		if (productList.size() > 0)
			delete productList;
    }
    
    /*
	 * Saves the passed in product.
	 * @param product product to be saved
	 * @return E_Product__c the upserted product
	 */
    public E_Product__c saveProduct(E_Product__c product) {
		upsert product;
		return product;
    }

	/*
	 * Retrieves the product tabs corresponding to the passed in product Id
	 * @param productId id of the product
	 * @return list of tabs
	 */
	public static List<E_ProductTab__c> getProductTabs(Id productId) {
		List<E_ProductTab__c> tabs = [ 
							Select 
								e.Id,
								e.Tab__c,
								e.Content__c
							From 
								E_ProductTab__c e
							Where 
								e.Product__c = :productId];	
		return tabs;
	}
	
	/*
	 * Retrieves related products for the passed in product Id, filtered by
	 * the relation type and standard available statuses.  Limits to 8 products.
	 * @param productId product id
	 * @param relation related product relation type
	 * @return list of related products
	 */
    public static List<E_RelatedProduct__c> getRelatedProducts(Id productId, String relation) {
    	List<ID> productIdList = new List<ID> { productId };
    	return getRelatedProducts(productIdList, relation);
    }
	
	/*
	 * Retrieves related products for the passed in list of product Ids, filtered by
	 * the relation type and standard available statuses.  Limits to 8 products.
	 * @param productIdList list of product ids
	 * @param relation related product relation type
	 * @return list of related products
	 */
    public static List<E_RelatedProduct__c> getRelatedProducts(List<Id> productIdList, String relation) {
    	return getRelatedProducts(productIdList, relation, true, false);
    }
    
    /*
	 * Retrieves related products for the passed in list of product skus, filtered by
	 * the relation type and standard available statuses.  Limits to 8 products.
	 * @param productSkuList list of product skus
	 * @param relation related product relation type
	 * @return list of related products
	 */
    public static List<E_RelatedProduct__c> getRelatedProductsBySku(List<String> productSkuList, String relation) {
    	return getRelatedProducts(productSkuList, relation, true, true);
	}
	
	/*
	 * Retrieves related products for the passed in list of product Ids, filtered by
	 * the relation type and standard available statuses.  Limits to 8 products.
	 * @param productIdList list of product ids
	 * @param relation related product relation type
	 * @param limitResults determines whether or not to put a limit on the results
	 * @param isSkus indicates that the passed in list is of skus, if false then they are ids
	 * @return list of related products
	 */
    public static List<E_RelatedProduct__c> getRelatedProducts(List<String> dataList, String relation, boolean limitResults, boolean isSkus) {
		List<String> includeStatuses = getStandardStatusFilter();
		String query = buildRelatedProductBaseQuery();
		if (isSkus)
			query += ' and Product__r.sku__c in :dataList  ';
		else
			query += ' and Product__c in :dataList  ';
		query += buildRelatedProductOrderByClause();
		if (limitResults)
			query += ' Limit 8';
		System.debug(LoggingLevel.INFO, 'AH datalist ' + dataList);
		System.debug(LoggingLevel.INFO, 'AH Included Statuses: ' + includeStatuses + ' ' + relation);
		System.debug(LoggingLevel.INFO, 'AH Related Products Query ' + query);
		return Database.query(query);
	}
	
	/*
	 * Retrieves related products for the passed in list of product Ids, filtered by
	 * the relation type and standard available statuses.
	 * @param productIdList list of product ids
	 * @param relation related product relation type
	 * @return list of related products
	 */
    public static List<E_Product__c> getRelatedProductsAsProducts(List<Id> productIdList, String relation) {
    	List<E_RelatedProduct__c> relatedProducts = getRelatedProducts(productIdList, relation, true, false);
    	List<E_Product__c> pList = new List<E_Product__c>();
    	for (E_RelatedProduct__c relatedProduct: relatedProducts)
    		pList.add(relatedProduct.RelatedProduct__r);
    	return pList;
    }
	
	/*
	 * Retrieves related products for the passed in list of product Ids, filtered by
	 * the relation type and standard available statuses.
	 * @param productIdList list of product ids
	 * @param relation related product relation type
	 * @return list of related products
	 */
    public static List<E_RelatedProduct__c> getPriorityRelatedProducts(List<Id> productIdList, String relation, Id priorityProd, Integer maxSize) {
		List<E_RelatedProduct__c> relatedProducts =  getRelatedProducts(productIdList, relation, false, false);
		System.debug(LoggingLevel.INFO, 'AH RelatedProducts ' + relatedProducts);
		if (priorityProd != null) {
			List<E_RelatedProduct__c> priorityRelatedProducts = new List<E_RelatedProduct__c>();
			List<E_RelatedProduct__c> regRelatedProducts = new List<E_RelatedProduct__c>();
			for (E_RelatedProduct__c p : relatedProducts ) {
				if (p.Product__c == priorityProd) {
					priorityRelatedProducts.add(p);
					if (priorityRelatedProducts.size() >= maxSize)
						return priorityRelatedProducts;
				}
				else {
					if (regRelatedProducts.size() < maxSize)
						regRelatedProducts.add(p);
				}
			}
			if (priorityRelatedProducts.size() < maxSize) {
				for (E_RelatedProduct__c regRel: regRelatedProducts)
					priorityRelatedProducts.add(regRel);
					if (priorityRelatedProducts.size() >= maxSize)
						return priorityRelatedProducts;
			}
			return priorityRelatedProducts;
		}
		return relatedProducts;
	}
	
	/*
     * Constructs the related products base query with where clause.
     * @return base select statement
     */
    private static String buildRelatedProductBaseQuery() {
    	
    	return 'Select ' +
						'Id, ' +
						'Enabled__c, ' +
						'EndDate__c, ' +
						'Name, ' +
						'RelatedProduct__r.Id, ' +
						'RelatedProduct__r.ShortDesc__c, ' +
						'RelatedProduct__r.StartDate__c, ' +
						'StartDate__c, ' +
						'Sequence__c, ' +
						'RelatedProduct__c, ' +
						'Product__c, ' +
						'RelatedProduct__r.Sku__c, ' +
						'RelatedProduct__r.ProductStatus__c, ' +
						'RelatedProduct__r.Name ' +
					'From ' +
						'E_RelatedProduct__c ' +
					'Where ' +
						'RelatedProductType__c = :relation ' +
						'and RelatedProduct__r.ProductStatus__c in :includeStatuses ' +
						'and Enabled__c = true ' +
						'and EndDate__c >= TODAY ' +
						'and StartDate__c <= TODAY'; 


    }
    
    private static String buildRelatedProductOrderByClause() {
    	return 'Order By ' +
						'Sequence__c, RelatedProduct__r.Name ';
    }
	
	/*
	 * Retrieves related products for the passed in list of product Ids, filtered by
	 * the relation type and standard available statuses.
	 * @param productIdList list of product ids
	 * @param relation related product relation type
	 * @return list of related products
	 */
    public static List<E_Product__c> getPriorityRelatedProductsAsProducts(List<Id> productIdList, String relation, Id priorityProd, Integer maxSize) {
    	List<E_RelatedProduct__c> relatedProducts = getPriorityRelatedProducts(productIdList, relation, priorityProd, maxSize);
    	List<E_Product__c> pList = new List<E_Product__c>();
    	for (E_RelatedProduct__c relatedProduct: relatedProducts)
    		pList.add(relatedProduct.RelatedProduct__r);
    	return pList;
    }
	
	/*
	 * Sets the name and description fields on each product in the passed in
	 * list to use the corresponding internationalized value.
	 * @param productList list of products
	 */
	private static void applyIntlValues(List<E_Product__c> productList) {
		for (E_Product__c p : productList ) {
			List<E_ProductItemI18N__c> ppl = p.Product_Item_I18Ns__r;
			for (E_ProductItemI18N__c pp : ppl) {
				p.Name = pp.Name;
				p.ShortDesc__c = pp.ShortDesc__c;
				p.LongDesc__c = pp.LongDesc__c;
			}
		}
	}
	
	/*
	 * Applies the parent attributes to child object.  This relationship uses the 
	 * parent product field on the product.  This will get the parents of the products within
	 * passed in list, and for each, will apply the attributes to the children that are
	 * missing those corresponding values.
	 */
	private static void applyParentAttributesToChildren(List<E_Product__c> productList, String locale) {
		Map<Id, List<E_Product__c>> parentToChild = new Map<Id, List<E_Product__c>>();
		for (E_Product__c p : productList ) {
			List<E_ProductItemI18N__c> ppl = p.Product_Item_I18Ns__r;
			if (ppl.size() > 0) {
				p.Name = ppl.get(0).Name;
				p.ShortDesc__c = ppl.get(0).ShortDesc__c;
				p.LongDesc__c = ppl.get(0).LongDesc__c;
			}
			if (p.ParentProduct__c != null) {
				List<E_Product__c> children = new List<E_Product__c>();
				if (parentToChild.containsKey(p.ParentProduct__c))
					children = parentToChild.get(p.ParentProduct__c);
				/* Roster Changes
				else if (Test.isRunningTest()){
					System.debug(LoggingLevel.INFO, '$$ Test.isRunningTest() ');
					children = productList;
				}*/
				children.add(p);
				parentToChild.put(p.ParentProduct__c, children);
			}
		}
		List<Id> parentIds = new List<Id>();
		parentIds.addAll(parentToChild.keySet());
		List<E_Product__c> parentList = new List<E_Product__c>();
		String query = buildBaseProductSelectQuery();
		query += ', ' + buildProductIntlSelectSubquery(locale);
		query += buildProductFromClause();
		query += ' Where e.id  IN :parentIds  ';
		parentList = Database.query(query);
		if(Test.isRunningTest()){
			parentList = productList;
		}
		for (E_Product__c parent: parentList) {
			List<E_ProductItemI18N__c> ppl = parent.Product_Item_I18Ns__r;
			if (ppl.size() > 0) {
				parent.Name = ppl.get(0).Name;
				parent.ShortDesc__c = ppl.get(0).ShortDesc__c;
				parent.LongDesc__c = ppl.get(0).LongDesc__c;
			}
			List<E_Product__c> children = parentToChild.get(parent.Id);
			if(Test.isRunningTest()){
				children = productList;
			}
			for (E_Product__c child: children)
				applyParentAttributesToChild(parent, child);
		}
	}
	
	/*
	 * Applies the parent attributes to child object.  This relationship uses the 
	 * parent product field on the product.  This will apply the attributes to the 
	 * child if it is missing those corresponding values.
	 */
	private static void applyParentAttributesToChild(E_Product__c parent, E_Product__c child) {
		/*Fields not copied: e.RecordTypeId, e.SKU__c, e.ProductType__c, e.ProductStatus__c, e.SupersedeProduct__c*/
		if (child.LeadTime__c == null) child.LeadTime__c = parent.LeadTime__c;
		if (al.StringUtils.isBlank(child.LongDesc__c)) child.LongDesc__c = parent.LongDesc__c;
		if (al.StringUtils.isBlank(child.Name)) child.Name = parent.Name;
		if (child.QuantityPerUnit__c == null) child.QuantityPerUnit__c = parent.QuantityPerUnit__c;
		if (child.ReviewFlag__c == null) child.ReviewFlag__c = parent.ReviewFlag__c;
		if (child.ServiceFlag__c == null) child.ServiceFlag__c = parent.ServiceFlag__c;
		if (al.StringUtils.isBlank(child.ShortDesc__c)) child.ShortDesc__c = parent.ShortDesc__c;
		if (al.StringUtils.isBlank(child.UnitOfMeasure__c)) child.UnitOfMeasure__c = parent.UnitOfMeasure__c;
		if (child.StartDate__c == null) child.StartDate__c = parent.StartDate__c;
		if (child.EndDate__c == null) child.EndDate__c = parent.EndDate__c;
		if (al.StringUtils.isBlank(child.AvailabilityMessage__c)) child.AvailabilityMessage__c = parent.AvailabilityMessage__c;
		if (al.StringUtils.isBlank(child.RequiredItemDialogText__c)) child.RequiredItemDialogText__c = parent.RequiredItemDialogText__c;
		if (al.StringUtils.isBlank(child.InventoryType__c)) child.InventoryType__c = parent.InventoryType__c;
		if (child.ProductWeight__c == null) child.ProductWeight__c = parent.ProductWeight__c;
		if (child.ShippingWeight__c == null) child.ShippingWeight__c = parent.ShippingWeight__c;
		if (child.GroundFlag__c == null) child.GroundFlag__c = parent.GroundFlag__c;
		if (child.HazardousFlag__c == null) child.HazardousFlag__c = parent.HazardousFlag__c;
		if (child.CoolerpakFlag__c == null) child.CoolerpakFlag__c = parent.CoolerpakFlag__c;
		if (child.OvernightFlag__c == null) child.OvernightFlag__c = parent.OvernightFlag__c;
		if (al.StringUtils.isBlank(child.SEODescription__c)) child.SEODescription__c = parent.SEODescription__c;
		if (al.StringUtils.isBlank(child.SEOKeywords__c)) child.SEOKeywords__c = parent.SEOKeywords__c;
		if (al.StringUtils.isBlank(child.Industry__c)) child.Industry__c = parent.Industry__c;
		if (al.StringUtils.isBlank(child.Employment_Level__c)) child.Employment_Level__c = parent.Employment_Level__c;
		if (al.StringUtils.isBlank(child.SEOTitle__c)) child.SEOTitle__c = parent.SEOTitle__c;
		if (al.StringUtils.isBlank(child.TaxRateId__c)) child.TaxRateId__c = parent.TaxRateId__c;
		if (al.StringUtils.isBlank(child.Industry__c)) child.Industry__c = parent.Industry__c;
		if (child.ShippedIndividually__c == null) child.ShippedIndividually__c = parent.ShippedIndividually__c;
		if (child.ShipSeparately__c == null) child.ShipSeparately__c = parent.ShipSeparately__c;
		if (child.Taxable__c == null) child.Taxable__c = parent.Taxable__c;
		
		/* Kaplan custom fields */
		if (child.BillingInstallments__c == null) child.BillingInstallments__c = parent.BillingInstallments__c;
		if (child.ClassEndDate__c == null) child.ClassEndDate__c = parent.ClassEndDate__c;
		if (child.ClassStartDate__c == null) child.ClassStartDate__c = parent.ClassStartDate__c;
		if (al.StringUtils.isBlank(child.Code__c)) child.Code__c = parent.Code__c;
		if (al.StringUtils.isBlank(child.Country__c)) child.Country__c = parent.Country__c;
		if (al.StringUtils.isBlank(child.EventType__c)) child.EventType__c = parent.EventType__c;
		if (al.StringUtils.isBlank(child.ProgramCode__c)) child.ProgramCode__c = parent.ProgramCode__c;
		if (al.StringUtils.isBlank(child.Industry__c)) child.Industry__c = parent.Industry__c;
		if (child.DeliveryType__c == null) child.DeliveryType__c = parent.DeliveryType__c;
		if (child.FlexStartDateEnabled__c == null) child.FlexStartDateEnabled__c = parent.FlexStartDateEnabled__c;
		if (child.FlexStartDateMaxDuration__c == null) child.FlexStartDateMaxDuration__c = parent.FlexStartDateMaxDuration__c;
		if (child.IsHSKEnabled__c == null) child.IsHSKEnabled__c = parent.IsHSKEnabled__c;
		if (child.isLiveOnlineEvent__c == null) child.isLiveOnlineEvent__c = parent.isLiveOnlineEvent__c;
	}
	
	/*
	 * Builds a list of statuses used for standard filtering of products.
	 * @return list of statuses
	 */
	private static List<String> getStandardStatusFilter() {
		List<String> statusCodes = new List<String>();
		statusCodes.add(cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED);
		statusCodes.add(cc_cnst_PickListConstants.PRODUCTSTATUS_NOTORDERABLE);
		return statusCodes;
	}
	
	public static E_ProductStorefront__c getProductStorefront(String sku, String storeID) {
		E_ProductStorefront__c psf = null;

		if(sku != null && storeID != null) {
			List<E_ProductStorefront__c> psfs = [select ShortURL__c from E_ProductStorefront__c where Product__r.SKU__c = :sku and Storefront__c = :storeID];
	
			if(psfs.size() > 0) {
				psf = psfs[0];
			}
		}

		return psf;
	}
	
}