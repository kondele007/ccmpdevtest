//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public without sharing class cc_ctrl_PricingEngine_va {
    public static map<String, Decimal> getBasePrice(List<String> prodIds) {
		System.debug('--- cc_ctrl_PricingEngine.getBasePrice: prodIds=' + prodIds);
		map<String, Decimal> priceMap = new map<String, Decimal>();
		String basePriceList = cc_cnst_CloudCraze.BASE_PRICE_LIST_NAME;
		System.debug('--- cc_ctrl_PricingEngine.getBasePrice: basePriceList=' + basePriceList);
		
		for(E_PriceListItem__c pli : [Select e.Product__r.sku__c, e.Pricelist__c, e.Price__c From E_PriceListItem__c e 
			where e.Product__r.sku__c in :prodIds and e.Pricelist__r.name= :basePriceList and e.StartDate__c <= TODAY and e.EndDate__c > TODAY]) {
			
			System.debug(LoggingLevel.INFO,'--- cc_ctrl_PricingEngine.getBasePrice: adding pli=' + pli + ', pli.product__r=' + pli.product__r);
			priceMap.put(pli.product__r.sku__c, pli.Price__c);
		}
		System.debug(LoggingLevel.INFO,'--- cc_ctrl_PricingEngine.getBasePrice: returning priceMap=' + priceMap);
		return priceMap; 
    }

	public static map<String, Decimal> getBasePrice(List<String> prodIds, String currencyCode, String customerType) {
		Map<String, Decimal> priceMap = new Map<String, Decimal>();
		String basePriceList = cc_cnst_CloudCraze.BASE_PRICE_LIST_NAME;
		List<E_PriceListItem__c> pricelines = [Select e.Product__r.sku__c, e.Pricelist__c, e.Price__c From E_PriceListItem__c e  where e.Product__r.sku__c in :prodIds and e.Pricelist__r.name= :basePriceList and e.Pricelist__r.CurrencyISOCode__c= :currencyCode and e.StartDate__c <= TODAY and e.EndDate__c > TODAY];
		for (E_PriceListItem__c pli : pricelines)
			priceMap.put(pli.product__r.sku__c, pli.Price__c);
		return priceMap; 
    }
	

    public static String getCurrencyCode()
    {
    	String ccode = null;
        User u = cc_api_User.getCurrentUser;

        if(u.CC_CurrencyCode__c != null && u.CC_CurrencyCode__c.trim().length() != 0)
        {
            ccode = u.CC_CurrencyCode__c;
        }
        else
        {
        	E_StorefrontSettings__c storefront = cc_util_CloudCraze.getDefaultStorefrontSettings();
        	if(storefront.DefaultCurrencyCode__c != null && storefront.DefaultCurrencyCode__c.trim().length() != 0) {
        		ccode = storefront.DefaultCurrencyCode__c;
        	}
        	else
        	{
                ccode = 'USD';
        	}
        }
        
        return ccode;
    }
    
    public static String getCustomerType()
    {
        return 'General';
    }

    /**
     * Gets the price lists sorted based on sequence defined.
     */
    public static List<ID> getAssignedPriceLists(ID accountID, Date targetDate)
    {
        System.debug(LoggingLevel.INFO,'----cc_ctrl_PricingEngine.getAssignedPriceLists query limits START: ' + Limits.getQueries());
        if(accountID == null)
        {
            accountID = cc_util_CloudCraze.getAnonymousAccountID();
        }
        if(targetDate == null)
        {
            targetDate = Date.today();
        }
        System.debug('getAssignedPriceLists ->' + accountID);
        System.debug('target date ->' + targetDate);
        
        Account acc = [select a.E_AccountGroup__c, a.E_AccountGroup__r.PriceListSelectionMethod__c from Account a where a.Id = :accountID and a.isDeleted = false];

        List<E_AccountGroupPriceList__c> ap;
        if(Test.isRunningTest()){
        	ap = [Select e.Pricelist__c, e.Sequence__c from E_AccountGroupPriceList__c e  
            where /*e.AccountGroup__c = :acc.E_AccountGroup__c and */ e.Enable__c = true and e.IsDeleted=false //and e.StartDate__c <= :targetDate 
            //and e.EndDate__c > :targetDate
            order by e.Sequence__c];        	
        }
        else{
        	ap = [Select e.Pricelist__c, e.Sequence__c from E_AccountGroupPriceList__c e  
            where e.AccountGroup__c = :acc.E_AccountGroup__c and  e.Enable__c = true and e.IsDeleted=false and e.StartDate__c <= :targetDate 
            and e.EndDate__c > :targetDate
            order by e.Sequence__c];
        }
            
         System.debug('---accoutn group pricelist after sort--' + ap);

        List<ID> priceListIDs = new List<ID>();
        for(E_AccountGroupPriceList__c a : ap)
        {
            priceListIDs.add(a.Pricelist__c);
        }
        System.debug(LoggingLevel.INFO,'----cc_ctrl_PricingEngine.getAssignedPriceLists query limits FINISH: ' + Limits.getQueries());
        return priceListIDs;
    }

    /**
     * Method to return one pricelist item per pricelist. If there are multiple prices defined within a 
     * pricelist, then the most recent price defined is considered.
     */
    public static List<E_PriceListItem__c> getPriceLines(List<String> skus, ID accountID, Date targetDate, String currencyCode, String customerType)
    {
        System.debug('--- getPriceLines: getQueries(1)=' + Limits.getQueries());
        List<E_PriceListItem__c> resultList = null;
        List<E_PriceListItem__c> sortedList = new List<E_PriceListItem__c>();
        
        //create a map of pricelist and pricelistitem. This map is to ensure that there is only one pricelist item per pricelist per sku. The key to this map is a combination 
        // of SKU and pricelist id.
        Map<String,E_PriceListItem__c> priceListItemMap=new Map<String,E_PriceListItem__c>();
        
        if(skus != null && skus.size() > 0)
        {
	        if(targetDate == null)
	        {
	            targetDate = Date.today();
	        }

	        if(currencyCode == null || currencyCode.trim().length()==0)
	        {
	            currencyCode = getCurrencyCode();
	        }
	        
	        if(customerType == null || customerType.trim().length()==0)
	        {
	            customerType = getCustomerType();
	        }
	        
	        System.debug('--- getPriceLines: currencyCode=' + currencyCode + ', customerType=' + customerType + ', targetDate=' + targetDate);
	        
	        //sort the pricelists by sequence defined.
	        List<ID> assigned = cc_ctrl_PricingEngine_va.getAssignedPriceLists(accountID, targetDate);
	        
	        System.debug('-----assigned pricelist ids----' + assigned);
	
	        if(Test.isRunningTest()){
		        resultList = [Select e.Product__c, e.Product__r.SKU__c, e.Price__c, e.Pricelist__c, e.Pricelist__r.AllowsDiscounts__c, e.Pricelist__r.name from E_PriceListItem__c e 
		            where e.Pricelist__c in :assigned and e.Product__r.SKU__c in :skus 
		            and e.IsDeleted = false //and e.StartDate__c <= :targetDate and e.EndDate__c > :targetDate
		            and e.Pricelist__r.Enabled__c = true and e.Pricelist__r.IsDeleted = false
		            //and e.Pricelist__r.StartDate__c <=  :targetDate
		            //and e.Pricelist__r.EndDate__c > :targetDate
		            //and e.Pricelist__r.CurrencyISOCode__c = :currencyCode 
		            order by e.Pricelist__c,e.StartDate__c desc
		            
		            //and e.Pricelist__r.CustomerTypeCode__c  = :customerType
		             ];	        	
	        }
	        else{
		        resultList = [Select e.Product__c, e.Product__r.SKU__c, e.Price__c, e.Pricelist__c, e.Pricelist__r.AllowsDiscounts__c, Pricelist__r.name from E_PriceListItem__c e 
		            where e.Pricelist__c in :assigned and e.Product__r.SKU__c in :skus 
		            and e.IsDeleted = false and e.StartDate__c <= :targetDate and e.EndDate__c > :targetDate
		            and e.Pricelist__r.Enabled__c = true and e.Pricelist__r.IsDeleted = false
		            and e.Pricelist__r.StartDate__c <=  :targetDate
		            and e.Pricelist__r.EndDate__c > :targetDate
		            and e.Pricelist__r.CurrencyISOCode__c = :currencyCode 
		            order by e.Pricelist__c,e.StartDate__c desc
		            
		            //and e.Pricelist__r.CustomerTypeCode__c  = :customerType
		             ];
	        }
            System.debug('--- getPriceLines: resultList=' + resultList);
            
            Set<String> skuSet = new Set<String>();
            String selectionMethod = cc_ctrl_PricingEngine_va.getPriceListSelectionMethod(accountID);
            System.debug('--- getPriceLines: selectionMethod=' + selectionMethod);
            if(cc_cnst_CloudCraze.PRICELIST_SELECTION_METHOD_SEQUENCE == selectionMethod)
            {
                // remove multiple pricelistlines for each sku so sortedList will only contain one pricelist item per sku
                for(ID pricelist : assigned)
                {
                    System.debug('--- getPriceLines: checking pricelist=' + pricelist);
                    // for each pricelist, loop through the items
                    // if an item is on the pricelist, and not in the skuSet, add it to the sortedList and the skuSet
                    for(E_PriceListItem__c item : resultList)
                    {
                        String sku = item.Product__r.SKU__c;
                        System.debug('--- getPriceLines: checking for sku=' + sku);
                        if(skuSet.contains(sku))
                        {
                            System.debug('--- getPriceLines: skuSet already contains sku=' + sku);
                            continue;
                        }
                        
                        if(item.Pricelist__c == pricelist)
                        {
                            sortedList.add(item);
                            skuSet.add(sku);
                            System.debug('--- getPriceLines: added to sortedList - item=' + item);
                            System.debug('--- getPriceLines: added to skuSet - sku=' + sku);
                        }
                    }
                }
            }
            else
            {
            	for(E_PriceListItem__c pricelistItemInstance:resultList){
            		if(priceListItemMap!=null && priceListItemMap.get(pricelistItemInstance.Product__r.SKU__c + priceListItemInstance.Pricelist__c) == null){
            			priceListItemMap.put(pricelistItemInstance.Product__r.SKU__c + priceListItemInstance.Pricelist__c,pricelistItemInstance);
            		}
            	}
                //sortedList = resultList;
                sortedList=priceListItemMap.values();
            }
        }

        System.debug('--- getPriceLines: returning sortedList=' + sortedList);
        System.debug('--- getPriceLines: getQueries(2)=' + Limits.getQueries());
        return sortedList;
    }

    public static Map<Id,E_Rule__c> getRulesForPLI(List<E_PriceListItem__c> pricelistItems, ID accountID, Date targetDate, String currencyCode, String customerType)
    {
        List<Id> pricelistItemIDs = new List<Id>();
        for(E_PriceListItem__c pli : pricelistItems)
        {
            pricelistItemIDs.add(pli.Id);
        }
        return getRulesForPLI(pricelistItemIDs, accountID, targetDate, currencyCode, customerType);
    }

    /**
    * Returns a list of instances of E_Rule__c based upon pricelist items, account id, target date, currency, and customer type.
    */
    public static Map<Id,E_Rule__c> getRulesForPLI(List<Id> pricelistItemIDs, ID accountID, Date targetDate, String currencyCode, String customerType)
    {
        Map<Id,E_Rule__c> rules = new Map<Id,E_Rule__c>();

        if(pricelistItemIDs.size() > 0)
        {

	        if(targetDate == null)
	        {
	            targetDate = Date.today();
	        } 
	        
	        if(currencyCode == null || currencyCode.trim().length()==0)
	        {
	            currencyCode = getCurrencyCode();
	        }
	        
	        if(customerType == null || customerType.trim().length()==0)
	        {
	            customerType = getCustomerType();
	        }
	        
	        System.debug('--- getRulesForPLI: pricelistItemIDs=' + pricelistItemIDs + ', targetDate=' + targetDate + ', currencyCode=' + currencyCode + ', customerType=' + customerType);

            List<E_RuleTargetPLI__c> rulePLIs = [select E_PriceListItem__c, E_Rule__r.Id, E_Rule__r.RuleType__c
                    from E_RuleTargetPLI__c
                    where E_PriceListItem__c in :pricelistItemIDs
                      and E_Rule__r.Enabled__c = true
                      and E_Rule__r.isDeleted = false
                      and E_Rule__r.StartDate__c <= :targetDate
                      and E_Rule__r.EndDate__c > :targetDate
                      and E_Rule__r.RuleSource__c = 'Pricing'
                      and E_Rule__r.CurrencyISOCode__c = :currencyCode
                      and E_Rule__r.CustomerTypeCode__c = :customerType
                    ];

	        for(E_RuleTargetPLI__c rulePLI : rulePLIs)
	        {
                rules.put(rulePLI.E_PriceListItem__c, rulePLI.E_Rule__r);
	        }
        }

        return rules;
    }
    
    public static cc_bean_PriceInfo getPrice(String sku, ID accountID, Date targetDate, String currencyCode, String customerType)
    {
    	return getPrice(sku, 1, accountID, targetDate, currencyCode, customerType);
    }

    public static cc_bean_PriceInfo getPrice(String sku, Double quantity, ID accountID, Date targetDate, String currencyCode, String customerType)
    {
        Map<String,Double> itemMap = new Map<String,Double> {sku => quantity};
        Map<String,cc_bean_PriceInfo> priceMap = getPriceMap(itemMap, accountID, targetDate, currencyCode, customerType);
        return priceMap.get(sku);
    }
    
    public static Map<String,cc_bean_PriceInfo> getPriceMap(List<String> skus, ID accountID, Date targetDate, String currencyCode, String customerType)
    {
        Map<String,Double> itemMap = new Map<String,Double>();
        for(String sku : skus) {
        	itemMap.put(sku, 1);
        }
        return getPriceMap(itemMap, accountID, targetDate, currencyCode, customerType);
    }

    /** 
     * Handles pricing of the passed in cart lines using the additional parameters as filter
     * criteria for the pricing data. 
     * @param items cart items
     * @param accountID account to which the pricing is tied
     * @param targetDate effective date to use for the prices
     * @param currencyCode currency of the pricelists
     * @param customerType type of the pricelists
     * @return map of sku to price information
     */
	public static Map<String,cc_bean_PriceInfo> getPriceMap(List<E_CartItem__c> items, ID accountID, Date targetDate, String currencyCode, String customerType) {
		return getPriceMap(items, accountID, targetDate, currencyCode, customerType, false);
    }
    
    /** 
     * Handles pricing of the passed in cart lines using the additional parameters as filter
     * criteria for the pricing data.  Will also optionally price the parent product of each line.
     * @param items cart items
     * @param accountID account to which the pricing is tied
     * @param targetDate effective date to use for the prices
     * @param currencyCode currency of the pricelists
     * @param customerType type of the pricelists
     * @param addParent whether or not to price the parent products
     * @return map of sku to price information
     */
	public static Map<String,cc_bean_PriceInfo> getPriceMap(List<E_CartItem__c> items, ID accountID, Date targetDate, String currencyCode, String customerType, boolean addParent) {
		Map<String,Double> itemMap = new Map<String,Double>();        
		for(E_CartItem__c item : items) {
		    if (!itemMap.containsKey(item.Product__r.SKU__c))
		        itemMap.put(item.Product__r.SKU__c, item.Quantity__c);
		    else
		        itemMap.put(item.Product__r.SKU__c, itemMap.get(item.Product__r.SKU__c) + item.Quantity__c);
			if (addParent && item.Product__r.ParentProduct__c != null) {
				if (!itemMap.containsKey(item.Product__r.ParentProduct__r.SKU__c))
			        itemMap.put(item.Product__r.ParentProduct__r.SKU__c, item.Quantity__c);
			    else
			        itemMap.put(item.Product__r.ParentProduct__r.SKU__c, itemMap.get(item.Product__r.SKU__c));
			}
		}
		return getPriceMap(itemMap, accountID, targetDate, currencyCode, customerType);
    }
    
    /**
     * if the same sku is on multiple lines, this collects them before running rules that apply to quantities
     */
    public static Map<String,cc_bean_PriceInfo> getPriceMap(Map<String,Double> itemMap, ID accountID, Date targetDate, String currencyCode, String customerType)
    {
        System.debug('----cc_ctrl_PricingEngine.getPriceMap query limits START: ' + Limits.getQueries());
        System.debug('--- getPriceMap: itemMap=' + itemMap);

        Map<String,cc_bean_PriceInfo> priceMap = new Map<String,cc_bean_PriceInfo>();

        if(itemMap != null && itemMap.size() > 0)
        {
            List<E_PriceListItem__c> plItems = cc_ctrl_PricingEngine_va.getPriceLines(new List<String>(itemMap.keySet()), accountID, targetDate, currencyCode, customerType);
            
            List<cc_bean_PriceInfo> priceBeans = new List<cc_bean_PriceInfo>();
            for(E_PriceListItem__c p1 : plItems)
            {
                cc_bean_PriceInfo bean = new cc_bean_PriceInfo();
                bean.priceListItem = p1;
                bean.quantity = itemMap.get(p1.Product__r.SKU__c);
                priceBeans.add(bean);
            }
            
            // get map of E_PriceListItem__c.Id => subAmount
            cc_ctrl_PricingEngine_va.applyRules(priceBeans, accountID, targetDate, currencyCode, customerType);

            for(cc_bean_PriceInfo priceBean : priceBeans)
            {
                System.debug('--- getPriceMap: current priceMap=' + priceMap);
                System.debug('--- getPriceMap: evaluating priceBean: ' + priceBean);

                String priceBeanSKU = priceBean.priceListItem.Product__r.SKU__c;
                
                if(!priceMap.containsKey(priceBeanSKU))
                {
                    priceMap.put(priceBeanSKU, priceBean);
                    System.debug('--- getPriceMap: added cc_bean_PriceInfo to priceMap: ' + priceBean);
                }
                else if(priceBean.subAmount != null)
                {
                    cc_bean_PriceInfo beanInMap = priceMap.get(priceBeanSKU);

                    if(priceBean.subAmount < beanInMap.subAmount)
                    {
                        priceMap.put(priceBeanSKU, priceBean);
                        System.debug('--- getPriceMap: updated subAmount in cc_bean_PriceInfo from ' + beanInMap.subAmount + ' to ' + priceBean.subAmount);
                    }
                }
            }
        }
        System.debug('--- getPriceMap: returning priceMap=' + priceMap);
        System.debug('----cc_ctrl_PricingEngine.getPriceMap query limits FINISH: ' + Limits.getQueries());
        return priceMap;
    }

    /**
     * Takes a list cc_bean_PriceInfo objects and their quantities and applies applicable pricing rules to each one
     */
    private static void applyRules(List<cc_bean_PriceInfo> priceBeans, ID accountID, Date targetDate, String currencyCode, String customerType)
    {
        System.debug('--- cc_ctrl_PricingEngine.applyRules: query limits START: ' + Limits.getQueries());
        cc_api_PricingRuleFactory factory = cc_api_PricingRuleFactory.getFactory();
        
        List<Id> priceListItemIds = new List<Id>();
        for(cc_bean_PriceInfo priceBean : priceBeans)
        {
            priceListItemIds.add(priceBean.priceListItem.Id);
        }
        
        Map<Id,E_Rule__c> pliRuleMap = cc_ctrl_PricingEngine_va.getRulesForPLI(priceListItemIds, accountID, targetDate, currencyCode, customerType);

        for(cc_bean_PriceInfo priceBean : priceBeans)
        {
            E_PriceListItem__c plItem = priceBean.priceListItem;
            Double pliQty = 1.0;
            Double pliPrice = null;
            Double pliSubAmount = null;

            if(priceBean.quantity != null && priceBean.quantity > 0.0)
            {
                pliQty = priceBean.quantity;
            }
            else
            {
                priceBean.quantity = pliQty;
            }

            if(plItem.Price__c == null)
            {
                priceBean.price = null;
                priceBean.subAmount = null;
            }
            else
            {
                pliPrice = plItem.Price__c;
                priceBean.price = pliPrice;

                System.debug('--- cc_ctrl_PricingEngine.applyRules: pliPrice=' + pliPrice + ', pliQty=' + pliQty);
    
                if(pliRuleMap.containsKey(plItem.Id))
                {
                    E_Rule__c rule = pliRuleMap.get(plItem.Id);
                    System.debug('--- cc_ctrl_PricingEngine.applyRules: RuleType=' + rule.RuleType__c);
                    cc_hlpr_PricingModifierBase priceModifier = factory.getModifier(rule.RuleType__c);
                    priceBean.ruleType = rule.RuleType__c;

                    if('stepped'.equalsIgnoreCase(rule.RuleType__c))
                    {
                        priceBean = priceModifier.applyModifierToBean(priceBean, rule.id);
                    }
                    else
                    {
                        priceBean.subAmount = priceModifier.applyModifier(pliQty.intValue(), pliPrice, rule.id);
                    }
                }
                else
                {
                    cc_hlpr_PricingModifierBase noRuleModifier = factory.getModifier(null);
                    System.debug('--- cc_ctrl_PricingEngine.applyRules: RuleType=null');
                    priceBean.subAmount =  noRuleModifier.applyModifier(pliQty.intValue(), pliPrice, null);
                }
                
                if(priceBean.subAmount == null)
                {
                    priceBean.price = null;
                }
                else
                {
                    priceBean.price = priceBean.subAmount / priceBean.quantity;
                }
            }

            System.debug('--- cc_ctrl_PricingEngine.applyRules: set priceBean=' + priceBean + ' for pli=' + plItem);
        }
        System.debug('--- cc_ctrl_PricingEngine.applyRules: query limits FINISH: ' + Limits.getQueries());
    }
    
    /**
	* Returns a list of instances of E_Rule__c based upon sku, account id, target date, currency, and customer type.
	*/
	public static List<E_Rule__c> getRules(String sku, ID accountID, Date targetDate, String currencyCode, String customerType )
	{
		return getRules(new String[]{sku}, accountID, targetDate, currencyCode, customerType );
	}
	/**
	* Returns a list of instances of E_Rule__c based upon skus, account id, target date, currency, and customer type.
	*/
	public static List<E_Rule__c> getRules(List<String> skus, ID accountID, Date targetDate, String currencyCode, String customerType )
	{
		if(targetDate == null)
		{
			targetDate = Date.today();
		} 
		
		List<ID> lr = new List<ID>();
		if(skus.size() > 0)
		{
			//collect all rule id and store them into lr
			//only collect rules whose RuleSource is 'Prcing', we deal 'Coupon' rule separately
			for(E_RuleTargetSKU__c r :[select e.Rule__r.ID from E_RuleTargetSKU__c e where e.Product__r.SKU__c in :skus and e.Rule__r.Enabled__c=true and e.Rule__r.isDeleted = false and e.Rule__r.StartDate__c <= :targetDate and e.Rule__r.EndDate__c > :targetDate and e.Rule__r.RuleSource__c = 'Pricing'])
			
			{
				lr.add(r.Rule__r.ID);
			}
		}
		
		String dynamicQuery = 'Select e.ID, e.RuleType__c from E_Rule__c e where e.IsDeleted = false and e.Enabled__c=true and e.RuleSource__c=\'Pricing\' and  e.StartDate__c <= :targetDate and e.EndDate__c > :targetDate';
		dynamicQuery += ' and e.ID in :lr';
		
		if(currencyCode != null && currencyCode.trim().length() > 0)
		{
			//dynamicQuery += ' and e.CurrencyCode__r.Code__c = :currencyCode';
			//dynamicQuery += ' and e.CurrencyCode__r.Code__c = :currencyCode';
			dynamicQuery += ' and e.CurrencyISOCode__c = :currencyCode';
		}
		if(customerType != null && customerType.trim().length() > 0)
		{
			//dynamicQuery += ' and e.CustomerType__r.Code__c  = :customerType';
			dynamicQuery += ' and e.CustomerTypeCode__c  = :customerType';
		}
		//System.debug('----------------' + dynamicQuery);
		return (List<E_Rule__c>) Database.query(dynamicQuery);
	}
    
    
    /**
     * gets the pricelist selection method from the current user's account group
     * defaults to Best Price
     */
    public static String getPriceListSelectionMethod(ID accountID)
    {
    	String selectionMethod = null;
    	System.debug('----accountID in pricelist selectionmethod is---' + accountID);
        List<Account> acc = [select a.E_AccountGroup__r.PriceListSelectionMethod__c from Account a where a.Id = :accountID and a.isDeleted = false];
        if(acc.size() > 0 && acc[0].E_AccountGroup__r.PriceListSelectionMethod__c != null)
        {
        	selectionMethod = acc[0].E_AccountGroup__r.PriceListSelectionMethod__c;
        }
        else
        {
        	selectionMethod = cc_cnst_CloudCraze.PRICELIST_SELECTION_METHOD_BEST_PRICE;
        }
        return selectionMethod;
    }
    public static Map<String, E_PriceListItem__c> getLowestPriceLineMap(List<String> skus, ID accountID, Date targetDate, String currencyCode, String customerType)
	{
		List<E_PriceListItem__c> pl = getPriceLines(skus, accountID, targetDate, currencyCode, customerType);
		Map<String, E_PriceListItem__c> skuMap = new Map<String, E_PriceListItem__c>();
		for(E_PriceListItem__c p : pl)
		{
			if(!skuMap.containsKey(p.Product__r.SKU__c))
			{
				skuMap.put(p.Product__r.SKU__c, p);
			}
			else
			{
				E_PriceListItem__c l = skuMap.get(p.Product__r.SKU__c);
				if(p.Price__c < l.Price__c)
				{
					skuMap.put(l.Product__r.SKU__c, l);
				}
			}
		}

		return skuMap;
	}
    
    public static List<E_PriceListItem__c> getLowestPriceLine(List<String> skus, ID accountID, Date targetDate, String currencyCode, String customerType)
	{
		Map<String, E_PriceListItem__c> skuMap = getLowestPriceLineMap(skus, accountID, targetDate, currencyCode, customerType);
		List<E_PriceListItem__c> ret = new List<E_PriceListItem__c>();
		Set<String> s = skuMap.keySet();
		for(String h : s)
		{
			ret.add(skuMap.get(h));
		}
		return ret;
	}
    
    
    public static E_PriceListItem__c getLowestPrice(String sku, ID accountID, Date targetDate, String currencyCode, String customerType)
	{
		E_PriceListItem__c ret = null;
		List<String> skus = new List<String> { sku };
		
		for(E_PriceListItem__c l : getLowestPriceLine(skus, accountID, targetDate, currencyCode, customerType))
		{
			ret = l;
			break;
		}
		return ret;
	}
    
}