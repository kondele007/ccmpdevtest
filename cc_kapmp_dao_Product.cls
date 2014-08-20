public with sharing class cc_kapmp_dao_Product {
    public static final string PRODUCTSTATUS_NOTORDERABLE = 'Not Orderable';
    public static final string PRODUCTSTATUS_RELEASED = 'Released';
	
	 /*
     * Returns a list of products based on a list of skus
     * skus list of skus
     * @return list of products
     */
	public List<ccrz__E_Product__c> readProduct(List<String> skus) {
		return readProduct(skus, cc_kapmp_util_Locale.getUserLanguage());
    }
    
    /*
     * Returns a list of products based on a list of skus for a specific
     * locale.
     * @param skus list of skus
     * @param locale used to localize product name and description
     * @return list of products
     */
 	public List<ccrz__E_Product__c> readProduct(List<String> skus, String locale) {
		List<String> statusCodes = getStandardStatusFilter();
		Date currDate = System.today();
		List<ccrz__E_Product__c> productList = new List<ccrz__E_Product__c>();
		String query = buildBaseProductSelectQuery();
		query += ', ' + buildProductSpecSelectSubquery(locale);
		query += ', ' + buildProductTabsSelectSubquery(locale);
		query += ', ' + buildProductIntlSelectSubquery(locale);
		query += ', ' + buildProductGuidesSelectSubquery();
		query += buildProductFromClause();
		query += ' Where e.ccrz__SKU__c IN :skus and e.ccrz__ProductStatus__c IN :statusCodes ';
		query += buildProductEffectiveDateWhereClauses(currDate);
		productList = Database.query(query);
		// applyParentAttributesToChildren(productList, locale);
		return productList;
    }
	/*
	 * Builds a list of statuses used for standard filtering of products.
	 * @return list of statuses
	 */
	private static List<String> getStandardStatusFilter() {
		List<String> statusCodes = new List<String>();
		statusCodes.add(PRODUCTSTATUS_RELEASED);
		statusCodes.add(PRODUCTSTATUS_NOTORDERABLE);
		return statusCodes;
	}

	/*
     * Constructs the base select clause for product queries.
     * @return base select statement
     */
    private static String buildBaseProductSelectQuery() {
    	return 'Select ' +
			    		'e.Id, ' +
						'e.ccrz__ParentProduct__c, ' +
						'e.ccrz__ParentProduct__r.ccrz__SKU__c, ' +
						'e.ccrz__ParentProduct__r.Name, ' +
						'e.ccrz__ParentProduct__r.ccrz__ShortDesc__c, ' +
						'e.ccrz__ParentProduct__r.ccrz__LongDesc__c, ' +
						'e.ccrz__LeadTime__c, ' +
						'e.ccrz__LongDesc__c, ' +
						'e.Name, ' +
						'e.ccrz__QuantityPerUnit__c, ' +
						'e.RecordTypeId, ' +
						'e.ccrz__ReviewFlag__c, ' +
						'e.ccrz__ServiceFlag__c, ' +
						'e.ccrz__ShortDesc__c, ' +
						'e.ccrz__SKU__c, ' +
						'e.ccrz__ProductType__c, ' +
						'e.ccrz__ProductStatus__c, ' +
						'e.ccrz__SupersedeProduct__c, ' +
						'e.ccrz__UnitOfMeasure__c, ' +
						'e.ccrz__StartDate__c, ' +
						'e.ccrz__EndDate__c, ' +
						'e.ccrz__AvailabilityMessage__c, ' +
						'e.ccrz__TotalRating__c, ' + 
						'e.ccrz__AverageRating__c, ' +
						'e.ccrz__NumberOfReviews__c, ' +
						'e.ccrz__RequiredItemDialogText__c, ' +
						'e.ccrz__InventoryType__c, ' +
						'e.ccrz__ProductWeight__c, ' +
			            'e.ccrz__ShippingWeight__c, ' +
			            'e.ccrz__GroundFlag__c, ' +
			            'e.ccrz__HazardousFlag__c, ' +
			            'e.ccrz__CoolerpakFlag__c, ' +
			            'e.ccrz__OvernightFlag__c, ' +
			            'e.ccrz__SEODescription__c, ' +
			            'e.ccrz__SEOKeywords__c, ' +
			            'e.ccrz__Industry__c, ' +
			            'e.ccrz__Employment_Level__c, ' +
			            'e.ccrz__ShippedIndividually__c, ' +
			            'e.ccrz__ShipSeparately__c, ' +
			            'e.ccrz__Taxable__c, ' +
			            'e.ccrz__TaxRateId__c, ' +
			            'e.ccrz__Sequence__c, ' +
			            'e.ccrz__SEOTitle__c ';
    }

    /*
     * Constructs the specs sub-select clause for product queries.
     * @return base select statement
     */
    private static String buildProductSpecSelectSubquery(String locale) {
    	return '(Select ' + 
    					'ccrz__Spec__r.Name, ' + 
						'ccrz__Spec__r.ccrz__DisplayName__c, ' + 
						'ccrz__Spec__r.ccrz__SpecGroup__c, ' + 
						'ccrz__SpecValue__c ' + 
					'From ' + 
						'ccrz__Product_Spec_Indicies__r ' + 
					'Where ' + 
						'ccrz__Spec__r.ccrz__isVisibleInCatalog__c = true ' + 
						'And ccrz__Spec__r.ccrz__Locale__c =: locale ' + 
					'Order By ' + 
						'ccrz__Spec__r.ccrz__Sequence__c ASC ' + 
					') ';
    }
    /*
     * Constructs the tabs sub-select clause for product queries.
     * @return base select statement
     */
    private static String buildProductTabsSelectSubquery(String locale) {
    	return '(Select ' +
			    		'Id, ' +
			    		'ccrz__Tab__c, ' + 
			    		'ccrz__Content__c ' +
					'From ' +
						'ccrz__E_ProductTabs__r ' +
					'Where ' +
						'(ccrz__Locale__c = :locale ' +
						'Or ccrz__Locale__c = null) ' +
					'Order By ' +
						'ccrz__Sequence__c ' +
					') ';
    }
    
    /*
     * Constructs the tabs sub-select clause for product queries.
     * @return base select statement
     */
    private static String buildProductGuidesSelectSubquery() {
    	return '(Select ' +
			    		'Id, ' +
			    		'ccrz__DisplayType__c, ' + 
			    		'ccrz__Required__c, ' + 
			    		'ccrz__RelatedProductGroup__c, ' +
			    		'ccrz__Sequence__c, ' +
			    		'ccrz__RelatedProductGroup__r.Name ' +
					'From ' +
						'ccrz__E_ProductGuides__r ' +
					'Order By ' + 
						'ccrz__Sequence__c ASC ' + 
					') ';
    }
    
    /*
     * Constructs the product from clause for product queries.
     * @return base select statement
     */
    private static String buildProductFromClause() {
    	return ' From ccrz__E_Product__c e ';
    }
    
    /*
     * Constructs the effective date where clauses for product queries.
     * @return base select statement
     */
    private static String buildProductEffectiveDateWhereClauses(Date currDate) {
    	return ' and (e.ccrz__StartDate__c = null or e.ccrz__StartDate__c <= :currDate) ' + 
				'and (e.ccrz__EndDate__c = null or e.ccrz__EndDate__c >= :currDate) ';
    }
	
	/*
     * Constructs the intl sub-select clause for product queries.
     * @return base select statement
     */
    private static String buildProductIntlSelectSubquery(String locale) {
    	return '(Select ' + 
						'Name, ' + 
						'ccrz__LongDesc__c, ' + 
						'ccrz__ShortDesc__c, ' + 
						'ccrz__Locale__c ' + 
					'From ' + 
						'ccrz__Product_Item_I18Ns__r ' + 
					'Where ' + 
						'ccrz__Locale__c =:locale' + 
					') ';
    }

}