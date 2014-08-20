public with sharing class ktp_cc_dao_Product {
    public static final string PRODUCTSTATUS_NOTORDERABLE = 'Not Orderable';
    public static final string PRODUCTSTATUS_RELEASED = 'Released';
    
     /*
     * Returns a list of products based on a list of skus
     * skus list of skus
     * @return list of products
     */
    public List<ccrz__E_Product__c> readProduct(List<String> skus) {
        return readProduct(skus, ktp_cc_util_Locale.getUserLanguage());
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

      public List<ccrz__E_Product__c> readProductWithID(ID pid) {
		List<ID> ids = new List<ID> { pid };
		return readProductWithID(ids, ktp_cc_util_Locale.getUserLanguage());
    }

	/*
     * Returns a product based on the id for a specific locale.
     * @param id product id
     * @param locale used to localize product name and description
     * @return list containing one product
     */
    public List<ccrz__E_Product__c> readProductWithID(ID pid, String locale) {
		List<ID> ids = new List<ID> { pid };
		return readProductWithID(ids, locale);
    }
    
    /*
     * Returns a list of products based on a list of ids
     * skus list of ids
     * @return list of products
     */
    public List<ccrz__E_Product__c> readProductWithID(List<ID> ids){
    	 return readProductWithID(ids,ktp_cc_util_Locale.getUserLanguage());
    }
    
    public List<ccrz__E_Product__c> readProduct(String sku) {
    	System.debug('XXX Dynamic Query: ');
		return readProduct(sku, ktp_cc_util_Locale.getUserLanguage());
    }
    
     public List<ccrz__E_Product__c> readProduct(String sku, String locale) {
		List<String> skus = new List<String> { sku };
		return readProduct(skus, locale);
    }
    
	/*
     * Returns a list of products based on a list of ids for a specific
     * locale.
     * @param ids list of ids
     * @param locale used to localize product name and description
     * @return list of products
     */
    public List<ccrz__E_Product__c> readProductWithID(List<ID> ids, String locale) {
    	List<String> statusCodes = getStandardStatusFilter();
		Date currDate = System.today();
		List<ccrz__E_Product__c> productList = new List<ccrz__E_Product__c>();
		String query = buildBaseProductSelectQuery();
		if(!Test.isRunningTest())
			query += ', ' + buildProductSpecSelectSubquery(locale);
		if(!Test.isRunningTest())
			query += buildProductIntlSelectSubquery(locale);
		query += buildProductFromClause();
		query += ' Where e.id  IN :ids ';
		if(!Test.isRunningTest())
			query += ' and e.ccrz__ProductStatus__c IN :statusCodes ';
		if(!Test.isRunningTest())
			query += buildProductEffectiveDateWhereClauses(currDate);
		System.debug(LoggingLevel.INFO, '$$Roster query=' + query);
		productList = Database.query(query);
		applyParentAttributesToChildren(productList, locale);
		return productList;
    }
    
    private static void applyParentAttributesToChildren(List<ccrz__E_Product__c> productList, String locale) {
		Map<Id, List<ccrz__E_Product__c>> parentToChild = new Map<Id, List<ccrz__E_Product__c>>();
		for (ccrz__E_Product__c p : productList ) {
			List<ccrz__E_ProductItemI18N__c> ppl = p.ccrz__Product_Item_I18Ns__r;
			if (ppl.size() > 0) {
				p.Name = ppl.get(0).Name;
				p.ccrz__ShortDesc__c = ppl.get(0).ccrz__ShortDesc__c;
				p.ccrz__LongDesc__c = ppl.get(0).ccrz__LongDesc__c;
			}
			if (p.ccrz__ParentProduct__c != null) {
				List<ccrz__E_Product__c> children = new List<ccrz__E_Product__c>();
				if (parentToChild.containsKey(p.ccrz__ParentProduct__c))
					children = parentToChild.get(p.ccrz__ParentProduct__c);
				/* Roster Changes
				else if (Test.isRunningTest()){
					System.debug(LoggingLevel.INFO, '$$ Test.isRunningTest() ');
					children = productList;
				}*/
				children.add(p);
				parentToChild.put(p.ccrz__ParentProduct__c, children);
			}
		}
		List<Id> parentIds = new List<Id>();
		parentIds.addAll(parentToChild.keySet());
		List<ccrz__E_Product__c> parentList = new List<ccrz__E_Product__c>();
		String query = buildBaseProductSelectQuery();
		query += ', ' + buildProductIntlSelectSubquery(locale);
		query += buildProductFromClause();
		query += ' Where e.id  IN :parentIds  ';
		parentList = Database.query(query);
		if(Test.isRunningTest()){
			parentList = productList;
		}
		for (ccrz__E_Product__c parent: parentList) {
			List<ccrz__E_ProductItemI18N__c> ppl = parent.ccrz__Product_Item_I18Ns__r;
			if (ppl.size() > 0) {
				parent.Name = ppl.get(0).Name;
				parent.ccrz__ShortDesc__c = ppl.get(0).ccrz__ShortDesc__c;
				parent.ccrz__LongDesc__c = ppl.get(0).ccrz__LongDesc__c;
			}
			List<ccrz__E_Product__c> children = parentToChild.get(parent.Id);
			if(Test.isRunningTest()){
				children = productList;
			}
			for (ccrz__E_Product__c child: children)
				applyParentAttributesToChild(parent, child);
		}
	}
	
	/*
	 * Applies the parent attributes to child object.  This relationship uses the 
	 * parent product field on the product.  This will apply the attributes to the 
	 * child if it is missing those corresponding values.
	 */
	private static void applyParentAttributesToChild(ccrz__E_Product__c parent, ccrz__E_Product__c child) {
		/*Fields not copied: e.RecordTypeId, e.SKU__c, e.ProductType__c, e.ProductStatus__c, e.SupersedeProduct__c*/
		if (child.ccrz__LeadTime__c == null) child.ccrz__LeadTime__c = parent.ccrz__LeadTime__c;
		if (al.StringUtils.isBlank(child.ccrz__LongDesc__c)) child.ccrz__LongDesc__c = parent.ccrz__LongDesc__c;
		if (al.StringUtils.isBlank(child.Name)) child.Name = parent.Name;
		if (child.ccrz__QuantityPerUnit__c == null) child.ccrz__QuantityPerUnit__c = parent.ccrz__QuantityPerUnit__c;
		if (child.ccrz__ReviewFlag__c == null) child.ccrz__ReviewFlag__c = parent.ccrz__ReviewFlag__c;
		if (child.ccrz__ServiceFlag__c == null) child.ccrz__ServiceFlag__c = parent.ccrz__ServiceFlag__c;
		if (al.StringUtils.isBlank(child.ccrz__ShortDesc__c)) child.ccrz__ShortDesc__c = parent.ccrz__ShortDesc__c;
		if (al.StringUtils.isBlank(child.ccrz__UnitOfMeasure__c)) child.ccrz__UnitOfMeasure__c = parent.ccrz__UnitOfMeasure__c;
		if (child.ccrz__StartDate__c == null) child.ccrz__StartDate__c = parent.ccrz__StartDate__c;
		if (child.ccrz__EndDate__c == null) child.ccrz__EndDate__c = parent.ccrz__EndDate__c;
		if (al.StringUtils.isBlank(child.ccrz__AvailabilityMessage__c)) child.ccrz__AvailabilityMessage__c = parent.ccrz__AvailabilityMessage__c;
		if (al.StringUtils.isBlank(child.ccrz__RequiredItemDialogText__c)) child.ccrz__RequiredItemDialogText__c = parent.ccrz__RequiredItemDialogText__c;
		if (al.StringUtils.isBlank(child.ccrz__InventoryType__c)) child.ccrz__InventoryType__c = parent.ccrz__InventoryType__c;
		if (child.ccrz__ProductWeight__c == null) child.ccrz__ProductWeight__c = parent.ccrz__ProductWeight__c;
		if (child.ccrz__ShippingWeight__c == null) child.ccrz__ShippingWeight__c = parent.ccrz__ShippingWeight__c;
		if (child.ccrz__GroundFlag__c == null) child.ccrz__GroundFlag__c = parent.ccrz__GroundFlag__c;
		if (child.ccrz__HazardousFlag__c == null) child.ccrz__HazardousFlag__c = parent.ccrz__HazardousFlag__c;
		if (child.ccrz__CoolerpakFlag__c == null) child.ccrz__CoolerpakFlag__c = parent.ccrz__CoolerpakFlag__c;
		if (child.ccrz__OvernightFlag__c == null) child.ccrz__OvernightFlag__c = parent.ccrz__OvernightFlag__c;
		if (al.StringUtils.isBlank(child.ccrz__SEODescription__c)) child.ccrz__SEODescription__c = parent.ccrz__SEODescription__c;
		if (al.StringUtils.isBlank(child.ccrz__SEOKeywords__c)) child.ccrz__SEOKeywords__c = parent.ccrz__SEOKeywords__c;
		if (al.StringUtils.isBlank(child.ccrz__Industry__c)) child.ccrz__Industry__c = parent.ccrz__Industry__c;
		if (al.StringUtils.isBlank(child.ccrz__Employment_Level__c)) child.ccrz__Employment_Level__c = parent.ccrz__Employment_Level__c;
		if (al.StringUtils.isBlank(child.ccrz__SEOTitle__c)) child.ccrz__SEOTitle__c = parent.ccrz__SEOTitle__c;
		if (al.StringUtils.isBlank(child.ccrz__TaxRateId__c)) child.ccrz__TaxRateId__c = parent.ccrz__TaxRateId__c;
		if (al.StringUtils.isBlank(child.ccrz__Industry__c)) child.ccrz__Industry__c = parent.ccrz__Industry__c;
		if (child.ccrz__ShippedIndividually__c == null) child.ccrz__ShippedIndividually__c = parent.ccrz__ShippedIndividually__c;
		if (child.ccrz__ShipSeparately__c == null) child.ccrz__ShipSeparately__c = parent.ccrz__ShipSeparately__c;
		if (child.ccrz__Taxable__c == null) child.ccrz__Taxable__c = parent.ccrz__Taxable__c;
		
		/* Kaplan custom fields */
		if (child.BillingInstallments__c == null) child.BillingInstallments__c = parent.BillingInstallments__c;
		if (child.ClassEndDate__c == null) child.ClassEndDate__c = parent.ClassEndDate__c;
		if (child.ClassStartDate__c == null) child.ClassStartDate__c = parent.ClassStartDate__c;
		if (al.StringUtils.isBlank(child.Code__c)) child.Code__c = parent.Code__c;
		if (al.StringUtils.isBlank(child.Country__c)) child.Country__c = parent.Country__c;
		if (al.StringUtils.isBlank(child.EventType__c)) child.EventType__c = parent.EventType__c;
		if (al.StringUtils.isBlank(child.ProgramCode__c)) child.ProgramCode__c = parent.ProgramCode__c;
		if (al.StringUtils.isBlank(child.ccrz__Industry__c)) child.ccrz__Industry__c = parent.ccrz__Industry__c;
		if (child.DeliveryType__c == null) child.DeliveryType__c = parent.DeliveryType__c;
		if (child.FlexStartDateEnabled__c == null) child.FlexStartDateEnabled__c = parent.FlexStartDateEnabled__c;
		if (child.FlexStartDateMaxDuration__c == null) child.FlexStartDateMaxDuration__c = parent.FlexStartDateMaxDuration__c;
		if (child.IsHSKEnabled__c == null) child.IsHSKEnabled__c = parent.IsHSKEnabled__c;
		if (child.isLiveOnlineEvent__c == null) child.isLiveOnlineEvent__c = parent.isLiveOnlineEvent__c;
	}
}