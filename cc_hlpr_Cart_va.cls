/**
// * Created by CloudCraze, LLC.
// * Copyright 2010-12 CloudCraze, LLC. All rights reserved
// * @Description: Extension to handle customized related item retrieval.
// * @Author: 1.0
// * @File: cc_hlpr_Cart
// * =======================================================================================
// * 2012/09/5 1.1 IL -  Refactored
**/
public with sharing class cc_hlpr_Cart_va {

	/**
	 * Creates a list of cart beans using the passed in data, which includes the cart lines, flags, and rules
	 * API.  This will build the data to be used for both display and UI interaction purposes.
	 * @param hasCouponLine flag set based on whether or not there are coupons
	 * @param rulesAPI the rules API which is used to construct the lines, and rules for processing.
	 * @return list of cart beans
	 */
	 public static List<cc_bean_CartItem> buildCartViewData(cc_kap_api_rules_CartRules displayRulesApi, boolean hasCouponLine) {
	 	List<cc_bean_CartItem> viewData = new List<cc_bean_CartItem>();
	 	hasCouponLine = false;
	 	Set<String> skus = new Set<String>();
	 	List<Id> productIDs = new List<Id>();
	 	/** Kaplan Phase 1 Begin */
    	displayRulesApi.constructLineData();
    	/** Kaplan Phase 1 End */
	 	for (E_CartItem__c line: displayRulesApi.cartLines) {
	 		skus.add(line.Product__r.sku__c);
	 		productIDs.add(line.Product__r.Id);
	 		 for (E_CartItem__c minorLine: line.Cart_Items__r) {
	 		 	skus.add(minorLine.Product__r.sku__c);
	 			productIDs.add(minorLine.Product__r.Id);
	 		 }
	 	}
	 	Map<String,String> intlNames = cc_hlpr_Cart_va.getTranslatedProductNames(skus);
	 	cc_dao_ProductMedia pmDAO = new cc_dao_ProductMedia();
		Map<Id,cc_bean_MediaWrapper> thumbnailMap = pmDAO.getProductThumbnailMedia(productIDs);
		boolean evenLine = false;
		for (E_CartItem__c line: displayRulesApi.cartLines) {
			cc_bean_CartItem majorLineBean = buildCartLineViewData(line, productIDs, intlNames, thumbnailMap, evenLine, hasCouponLine, displayRulesApi);
			if (line.Cart_Items__r != null) {
				boolean evenSubLine = false;
				for (E_CartItem__c minorLine : line.Cart_Items__r) {
					majorLineBean.minorLines.add(buildCartLineViewData(minorLine, productIDs, intlNames, thumbnailMap, evenSubLine, hasCouponLine, displayRulesApi));
					evenSubLine = !evenSubLine;
				}
			}
			/** Kaplan Phase 1 Begin */
        	majorLineBean.dataRulesBean = displayRulesApi.getDisplayRuleBean(line.Product__r.SKU__c);
        	if (majorLineBean.dataRulesBean.availableInstallments != null) {
        		majorLineBean.totalDiscount = majorLineBean.dataRulesBean.availableInstallments.get(0).totalDiscount*majorLineBean.quantity;
        		majorLineBean.totalListPrice = majorLineBean.dataRulesBean.availableInstallments.get(0).listPrice*majorLineBean.quantity; 
        	}
        	/** Kaplan Phase 1 End */
			viewData.add(majorLineBean);
			evenLine = !evenLine;
		}
	 	return viewData;
	 }
	 
	 /**
	  * Builds the view data for the passed in line using the supporting data. 
	  * @param line cart line to use for the bean
	  * @param productIDs list of product ids in the cart
	  * @param intlNames map to internationalized names
	  * @param thumbnailMap map of image
	  * @param evenLine used for ui display
	  * @param hasCouponLine flag set based on whether or not there are coupons
	  * @param rulesAPI the rules API which is used to construct the lines, and rules for processing.
	  * @return cart line data bean
	  */
	 public static cc_bean_CartItem buildCartLineViewData(E_CartItem__c line, List<Id> productIDs, Map<String,String> intlNames,  
	 												Map<Id,cc_bean_MediaWrapper> thumbnailMap, boolean evenLine, boolean hasCouponLine, cc_kap_api_rules_CartRules displayRulesApi) {
		cc_bean_CartItem lineData = new cc_bean_CartItem();
		lineData.cartItemType = line.CartItemType__c;
		if (line.ParentCartItem__r != null)
        	lineData.parentProductType = line.ParentCartItem__r.Product__r.ProductType__c;
        lineData.product = line.product__r;
        lineData.mockProduct = new cc_bean_MockProduct(line.Product__r);
        lineData.quantity = line.Quantity__c.intValue();
        lineData.subAmount = line.SubAmount__c.setScale(2, System.RoundingMode.UP);
        lineData.displaySubAmount = String.valueOf(lineData.subAmount);
        lineData.price = line.Price__c;
        lineData.absoluteDiscount = line.AbsoluteDiscount__c;
        lineData.percentDiscount = line.PercentDiscount__c;
		if (line.CartItemType__c == 'Major') {
			if (line.Cart_Item_Pricing_Tiers__r != null && line.Cart_Item_Pricing_Tiers__r.size() > 1) {
				for (E_CartItemPricingTier__c tier: line.Cart_Item_Pricing_Tiers__r) {
					if (tier.Quantity__c != null)
                        lineData.pricingTiers.add(new cc_bean_CartItem.PricingTier(tier.Quantity__c.intValue(), tier.Price__c));
		        }
	        }
        } 
        else if (line.cartItemType__c == 'Coupon')
			hasCouponLine = true;
		lineData.appliedCoupon = line.Coupon__c;
		lineData.itemID = line.Id;
		lineData.translatedProductName = intlNames.get(line.Product__r.SKU__c);
		if (thumbnailMap.get(line.Product__r.Id) != null) {
			lineData.mediaWrapper = new cc_bean_MediaWrapper();
            lineData.mediaWrapper.uri = thumbnailMap.get(line.Product__r.Id).uri;
            lineData.mediaWrapper.sourceType = thumbnailMap.get(line.Product__r.Id).sourceType;
		}
        lineData.evenLineNumber = evenLine;
        /** Kaplan Phase 1 Begin */
        lineData.dataRulesBean = displayRulesApi.getDisplayRuleBean(line.Product__r.SKU__c);
    	if (lineData.dataRulesBean.availableInstallments != null) {
            lineData.totalDiscount = lineData.dataRulesBean.availableInstallments.get(0).totalDiscount*lineData.quantity;
            lineData.totalListPrice = lineData.dataRulesBean.availableInstallments.get(0).listPrice*lineData.quantity;
    	}
    	/** Kaplan Phase 1 End */
		return lineData;
	}
	
	/**
	 * Builds a map of sku to internationalized name
	 * @param skus list of skus
	 * @return map of sku to intl name
	 */
    public static Map<String,String> getTranslatedProductNames(List<String> skus){
		List<E_Product__c> products = [Select Sku__c,(Select Name From Product_Item_I18Ns__r) From E_Product__c Where Sku__c=:skus];
		return processIntlData(products);
    }
    
    /**
	 * Builds a map of sku to internationalized name
	 * @param skus list of skus
	 * @return map of sku to intl name
	 */
    public static Map<String,String> getTranslatedProductNames(Set<String> skus){
		List<E_Product__c> products = [Select Sku__c,(Select Name From Product_Item_I18Ns__r) From E_Product__c Where Sku__c=:skus];
		return processIntlData(products);
    }
    
    /**
	 * Builds a map of sku to internationalized name
	 * @param product list of products
	 * @return map of sku to intl name
	 */
    private static Map<String, String> processIntlData(List<E_Product__c> products) {
    	Map<String,String> nameData = new Map<String,String>();
		for (E_Product__c product : products) {
			for (E_ProductItemI18N__c item : product.Product_Item_I18Ns__r) {
				nameData.put(product.Sku__c,item.Name);
				break;
			}
		}
		return nameData;
	}
	
	/**
	 * Calculates cart tax amount using internal tax calc processing
	 * @return tax amount
	 */
	public static Decimal getCartTaxAmount(Id cartId, String shipToPostalCode) {
    	Decimal taxDecimal = 0.00;
        cc_ctrl_TaxCalculation cc_ctrl_TaxCalculation = new cc_ctrl_TaxCalculation();
        cc_bean_TaxCalculation taxCalcBean = new cc_bean_TaxCalculation();
        cc_bean_TaxCalculationList cc_bean_TaxCalculationList = new cc_bean_TaxCalculationList();
        // first do aggregate total for non-training classes
        List<AggregateResult> taxabletotal = [SELECT SUM(SubAmount__c)Tax_Total FROM E_CartItem__c where Product__r.Taxable__c = true AND Cart__c = :cartId];
        for(AggregateResult t: taxabletotal) {
            taxCalcBean.subTotal = (Double)t.get('Tax_Total');
            if (taxCalcBean.subTotal == null)
            	taxCalcBean.subTotal = 0.0;
           	taxCalcBean.zipCode = shipToPostalCode;
            taxCalcBean.lineKey = '-1'; //temp val to represent "all non training lines"
            break;   
        }
        cc_bean_TaxCalculationList.addTaxCalculationBean(taxCalcBean);          
        List<Decimal> taxAmounts = cc_ctrl_TaxCalculation.getTaxAmounts(cc_bean_TaxCalculationList);
        for(Decimal d : taxAmounts)
           	taxDecimal += d;
        return taxDecimal;
    }
    
    /**
     * Handles the execution of the place order api call, and subsequent redirect
     * to the apporiate order view display.  Also handles removal of the cart cookie
     * if the order is successfully placed.
     * @param Id cart id
     * @return PageReference  page to redirect to, null if order placement fails
     */
    public static PageReference placeOrderAndRedirect(Id cartId) {
    	/************* CASE # 1660 - Begin ************/

    	String sbu = null;
    	String productNames = null;

    	/************* CASE # 1660 - End ************/

    	PageReference pageRef = null;
        cc_api_Cart cartAPI = new cc_api_Cart();
        Id orderID = cartAPI.placeOrder(cartId);
        if (orderID != null) {
			E_Order__c order = [Select EncryptedId__c, OriginatedCart__r.EncryptedId__c, CurrencyISOCode__c From E_Order__c where Id = :orderID]; // CASE # 1660 - ADDED CurrencyISOCode__c,OriginatedCart__c.id to query
			
			/************* CASE # 1660 - Begin ************/

			List<E_CartItem__c> cartItems = cc_dao_cart_va.getDisplayCartItems(order.OriginatedCart__r.EncryptedId__c);	
			cc_kap_api_rules_CartRules cartRulesAPI = new cc_kap_api_rules_CartRules(cartItems, order.CurrencyISOCode__c);

			productNames = cartItems.get(0).Product__r.Name;

			for(integer i = 1; i < cartItems.size(); i++){
	    		productNames = productNames + ', ' + cartItems.get(i).Product__r.Name;
	    	}

	    	sbu = getSpecs(cartRulesAPI.getSpecValues(cc_kap_utils_AppConstants.SPEC_SBU), false);

			Cookie productNamesCookie = new Cookie('ccprodnames', productNames,null,-1,false);
			Cookie kbsProgramCodesCookie = new Cookie('cckpgid',getSpecs(cartRulesAPI.getSpecValues(cc_kap_utils_AppConstants.SPEC_KBS_PROGRAM_CODE), true),null,-1,false);			
			Cookie sbuCookie = new Cookie('ccbuid',sbu,null,-1,false);

			ApexPages.currentPage().setCookies(new Cookie[]{kbsProgramCodesCookie, sbuCookie, productNamesCookie});

			/************* CASE # 1660 - End ************/

			/***********************
			BEGIN Kaplan customizations
			***********************/
			System.debug(LoggingLevel.INFO, '******sendOrderToKaplan*******');
			cc_kap_api_services.sendOrderToKaplan(orderID);
			/***********************
			END Kaplan customizations
			***********************/
			removeCurrentCart();	            
			pageRef = System.Page.OrderView_va;
			pageRef.getParameters().clear();
			pageref.setRedirect(true);
			
			pageRef.getParameters().put('o', order.EncryptedId__c);		

			/************* CASE # 1660 - Begin ************/

			pageRef.getParameters().put('cckpgid', getSpecs(cartRulesAPI.getSpecValues(cc_kap_utils_AppConstants.SPEC_KBS_PROGRAM_CODE), false));
			pageRef.getParameters().put('ccpgid', getSpecs(cartRulesAPI.getSpecValues(cc_kap_utils_AppConstants.SPEC_PROGRAM_CODE), false));
			pageRef.getParameters().put('ccbuid', sbu);


			/************* CASE # 1660 - End ************/

        }
		return pageref;
    }

    /************* CASE # 1660 - Begin ************/

    private static String getSpecs(Set<String> specValuesSet, boolean getAll){ 
    	String specs = ' ';	    	
    	List<String> specValuesList = new List<String>(); 

    	if (specValuesSet != null) {
    		specValuesList.addAll(specValuesSet);  
    		specs = specValuesList.get(0);	  	

    		if(getAll){
    			specs = specValuesList.get(specValuesList.size()-1);
    			for(integer i = specValuesList.size() - 2; i >= 0; i--){
	    			specs = specs + ', ' + specValuesList.get(i);
	    		}
			}		        		
    	}   
    	return specs;
    }

    /************ CASE # 1660 - End *************/
    
    /**
     * Resets the cart cookie and sets it in the current page.
     */
    public static void removeCurrentCart() {
    	Cookie cartIdCookie = new Cookie('currentCartId',null,null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{cartIdCookie});
    }
    
}