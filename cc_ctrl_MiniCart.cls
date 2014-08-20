public with sharing class cc_ctrl_MiniCart extends cc_ctrl_CloudCraze{
	
	public E_Cart__c cart {get;set;}
	public cc_bean_Cart cartBean {get;set;}
	public String freeEventFlag { get; private set; }
	private cc_kap_api_rules_CartRules displayRulesApi {get; set;}
	public Boolean cartHasCouponLineItem {get;set;}
	public boolean containsShippableItems {get; private set; }
	public String programCode{get; set;}
	public List<String> installMessages { get; private set; }
	public E_Coupon__c coupon {get;set;}
	public Boolean applyToAll {get;set;}
	public String selectedCoupon { get; set; }
	public String couponId {get;set;}
	
	public String couponMessage { get; set; }
	public String successCouponMessage { get; set; }
	public String couponName {get;set;}
	public String requiredSKU {get;set;}
	public Boolean installmentsAvailable {get;set;}
	public Decimal totalInstallmentPrice {get;set;}
	public Decimal dueTodayPrice {get;set;}
	public Decimal discounts {get;set;}
	public List<cc_bean_CartItem> cartListViewData {get;set;}
	public cc_ctrl_StorefrontTemplate storefrontTemplateCls {get;set;}
	public cc_ctrl_MiniCart getMiniCartController() { return this; }
	public List<E_CartItem__c> cartItemList {get; set; }
	public String cartCurrency {get;set;}
	public cc_ctrl_Cart ctrlCart {get;set;}
	public String cartSBUCode {get;set;}
	public String uiKey {get;set;}
	private Map<String, List<E_ProductSpecIndex__c>> transientSpecMap;
	
	public cc_kap_IBFee_Util IBFeeUtil {
		get{
			if(IBFeeUtil == null)
				IBFeeUtil = new cc_kap_IBFee_Util();
			return IBFeeUtil;
		}
		set;
	}
	
	public String couponCode{
		get{
			couponCode = Apexpages.currentPage().getParameters().get('couponCode');	
			return couponCode;
		}
		set;
	}
	
	
	
	public List<SelectOption> couponList {
	    get {
	        if(couponList == null)
	            couponList = new List<SelectOption>();
	        return couponList;
	    }
	    set;
	}
	
	
	public cc_ctrl_MiniCart()
	{
		uiKey = cc_api_PageUIKey.getUIKeyForPage(pageName);
		loadMiniCart();
		storefrontTemplateCls = new cc_ctrl_StorefrontTemplate();
		couponMessage = ApexPages.currentPage().getParameters().get('couponMessage');
		successCouponMessage = ApexPages.currentPage().getParameters().get('successCouponMessage');
	}
	
	public List<String> getPageStyles() {
		List<String> styles = storefrontTemplateCls.getPageResources(cc_cnst_PageConfiguration.RESOURCE_CSS);
		return styles;
	}
	
	public List<String> getPageJs() {
		List<String> jsList = storefrontTemplateCls.getPageResources(cc_cnst_PageConfiguration.RESOURCE_JS);
		return jsList;
	}
	
	public PageReference selectCoupon(){
        couponCode = selectedCoupon;
        return addCoupon();
    }
    
    public PageReference addCoupon(){
        System.debug(LoggingLevel.INFO, '********AddCoupon********');
        String viewState = 'CartView';
        Boolean useNewCoupon = false;//Always use the entered coupon and apply it to the Cart
        E_Cart__c cart = cartAPI.retrieveCart(cartBean.sfid);
        couponMessage = null;
        successCouponMessage = 'FALSE';
        
        List<E_CartCoupon__c> cartCoupons = cartAPI.getCartCoupons(cart.ID);
        
        if(cartCoupons != null && cartCoupons.size() >0)
        {
        	useNewCoupon = true;
        	for(E_CartCoupon__c cartCoupon:cartCoupons){
        		String cartCouponCode = cartCoupon.Coupon__r.CouponCode__c;
        		if(cartCouponCode!= null && cartCouponCode.equals(couponCode))
        			useNewCoupon = false;
        	}
        }
        
		if(displayRulesApi == null)
		{
			
			if(cartItemList == null)
				cartItemList = getCartItems();
		}
		System.debug(LoggingLevel.INFO, '$$Calling AddCoupon=' + couponCode);
        couponMessage = cartAPI.addCoupon(cart, couponCode, displayRulesApi.cartLines,useNewCoupon);
        // initialize attributes
        selectedCoupon = null;
        if(couponList != null)
        	couponList.clear();

        E_Coupon__c coupon = cartAPI.getCoupon(couponCode);
        if('SelectCoupon'.equals(couponMessage)){
            // Warn the user and ask which coupon to use
            cartCoupons = cartAPI.getCartCoupons(cart.ID);
            couponMessage = 'Only one coupon per cart may be used.';
            couponList.add(new SelectOption(cartCoupons[0].Coupon__r.CouponCode__c, cartCoupons[0].Coupon__r.Rule__r.Name__c));
            couponList.add(new SelectOption(coupon.CouponCode__c,coupon.Rule__r.Name__c));
        }else {
            if('Success'.equals(couponMessage)){
                couponMessage = 'The coupon has been added to your cart.';
                successCouponMessage = 'TRUE';
            }else if('CouponAlreadyAdded'.equals(couponMessage)){
                couponMessage = 'The coupon entered is already in your cart.';
            }else if ('InvalidCoupon'.equals(couponMessage)){
                couponMessage = 'The coupon is not valid';

            }else if ('MinAmountNotMet'.equals(couponMessage)){
                couponMessage = 'Your cart total is not high enough for this coupon.';
            }else if ('MissingRequiredSKU'.equals(couponMessage)){
                couponMessage = 'The product required for this coupon is not in your cart.';
            }else if ('MinQuantityNotMet'.equals(couponMessage)){
                couponMessage = 'Your cart quantity is not high enough for this coupon.';
            }

	        couponName = null;
	        couponId = null;
	        System.debug(LoggingLevel.INFO,'@@displayRulesApi.cartLines Before'+displayRulesApi.cartLines);
			cc_kap_utils_Cart.calculateCartTotals(displayRulesApi.cartLines);
	        System.debug(LoggingLevel.INFO,'@@displayRulesApi.cartLines After'+displayRulesApi.cartLines);
			update displayRulesApi.cartLines;
			//System.debug(LoggingLevel.INFO,'@@After adding coupon, loading Cart again....');
			loadMiniCart();//Load Cart again , so the Installment Fees gets recalculated again.
			cart.due_today__c = dueTodayPrice;
    		cart.second_payment__c = totalInstallmentPrice;
    		cart.third_payment__c = totalInstallmentPrice;
    		update cart;
			return refreshCart();
        }
        return null;
    }
    
    public cc_api_Cart cartAPI{
    	get{
    		if(cartAPI == null)
    			cartAPI = new cc_api_Cart();
    		return cartAPI;
    	}
    	set;
    }
    
     public void updateCouponInfo() {
        String relation='';
        couponName = null;
        couponId = null;
        this.coupon = null;
        requiredSKU = null;
        applyToAll = false;
        if(cartBean != null){
             List<E_CartCoupon__c> cartCoupons = cartAPI.getCartCoupons(cartBean.sfid);
             if(cartCoupons != null){
                if(cartCoupons.size()>0){
                    couponCode = cartCoupons.get(0).Coupon__r.CouponCode__c;
                    this.coupon = cartAPI.getCoupon(couponCode);
                }
             }
        }
        // If it's sku-related, add the sku
        // Else if it's an absolute, non-sku related, set sku to NONE
        // Else set sku to all
        if(this.coupon!=null){
            couponName = coupon.Rule__r.Name__c;
            couponId = coupon.Id;
            couponCode = coupon.CouponCode__c;
            relation = coupon.Rule__r.Relation__c;
            if('SKU'.equalsIgnoreCase(coupon.Rule__r.Relation__c)){
                List<E_RuleTargetSKU__c> ruleTargetSKU = [select e.Product__c,e.RuleTargetSKUID__c
                                                          from E_RuleTargetSKU__c e
                                                          where e.Rule__c = :coupon.Rule__c LIMIT 1];
                if(ruleTargetSKU != null && ruleTargetSKU.size() > 0){
					// requiredSKU = ruleTargetSKU.get(0).RuleTargetSKUID__c;
                    requiredSKU = ruleTargetSKU.get(0).Product__c;
                    applyToAll = false;
                }
            } else if ('SPEC'.equalsIgnoreCase(coupon.Rule__r.Relation__c)){
                applyToAll = false;
            }else if(coupon.DiscountType__c == 'Absolute'){
                requiredSKU = couponCode;
                applyToAll = true;
            }else {
                applyToAll = true;
            }
        }

	    Integer noOfQueries = Limits.getQueries();
	    
    }
	
	public Double cartSubAmount {
    	get {
			Double sub = cartAPI.getCartTotal(cartBean.sfid);
			if(sub != null) {
	   			cartSubAmount = Decimal.valueOf(sub).setScale(2);
			}
    		return cartSubAmount;
    	}
    	set;
    }
	
	public void loadMiniCart() {
		ccCartId = getCartId();
		cart = cartAPI.retrieveCart(ccCartId);
		cartBean = new cc_bean_Cart(cart);
		System.debug(LoggingLevel.INFO,'TO--cartItemList before'+cartItemList);
		cartItemList = getCartItems();
		System.debug(LoggingLevel.INFO,'TO--cartItemList after'+cartItemList);
		processInstallmentsForHeaderLevel();
	}
	
	public void processInstallmentsForHeaderLevel()
	{
		installmentsAvailable = false;
		if(cartListViewData != null)
		{
			totalInstallmentPrice = 0.0;
			dueTodayPrice = 0.0;
			discounts = 0.0;
			Decimal firstInstallmentPrice = 0.0;
			for(cc_bean_CartItem pc : cartListViewData){
				System.debug(LoggingLevel.INFO, 'TO--pc'+pc);
				System.debug(LoggingLevel.INFO, 'TO--pc.dataRulesBean'+pc.dataRulesBean);
				System.debug(LoggingLevel.INFO, 'TO--pc.dataRulesBean.availableInstallments'+pc.dataRulesBean.availableInstallments);
				List<cc_kap_rules_bean_CartDataInstallPrice> installPriceLstBean = pc.dataRulesBean.availableInstallments;
				if(installPriceLstBean != null && installPriceLstBean.size()>1)
				{
					installmentsAvailable = true;
					for(cc_kap_rules_bean_CartDataInstallPrice installment: installPriceLstBean){
						if(installment.installments == 3){
							//totalInstallmentPrice = totalInstallmentPrice + installment.offeredPrice;
							System.debug(LoggingLevel.INFO,'@@Amount installment.offeredPrice='+ installment.offeredPrice);
							System.debug(LoggingLevel.INFO,'@@Amount installment.discountedPrice='+ installment.discountedPrice);
							System.debug(LoggingLevel.INFO,'@@Amount installment.Mod='+ Math.mod((installment.discountedPrice).intValue(),3));
							System.debug(LoggingLevel.INFO,'@@Amount installment.diff='+ (installment.discountedPrice - installment.discountedPrice.round(System.RoundingMode.DOWN)));
							totalInstallmentPrice = totalInstallmentPrice + installment.offeredPrice.round(System.RoundingMode.DOWN);
							firstInstallmentPrice = firstInstallmentPrice + installment.offeredPrice.round(System.RoundingMode.DOWN) + Math.mod((installment.discountedPrice).intValue(),3) + (installment.discountedPrice - installment.discountedPrice.round(System.RoundingMode.DOWN));
						}
						else if(installment.installments == 1 && installment.couponDiscount != null){
							discounts = discounts + installment.couponDiscount;
							//discounts = discounts + installment.couponDiscount.round(System.RoundingMode.DOWN);
							//System.debug(LoggingLevel.INFO,'@@1.discounts='+ discounts);
						}
					}		
				}
				else if(pc.cartItemType != 'Coupon')
				{
					if(pc.absoluteDiscount != null)
						dueTodayPrice = dueTodayPrice + (pc.totalListPrice - pc.absoluteDiscount);
					else
						dueTodayPrice = dueTodayPrice + pc.totalListPrice;	
					discounts = discounts + pc.totalDiscount;
					//System.debug(LoggingLevel.INFO,'@@2.discounts='+ discounts);
				}
				else if(pc.cartItemType == 'Coupon')
				{
					discounts = pc.SubAmount;
				}
			}
			//dueTodayPrice = dueTodayPrice + totalInstallmentPrice;
			dueTodayPrice = dueTodayPrice + firstInstallmentPrice;
			//dueTodayPrice = dueTodayPrice.divide(1,2,System.RoundingMode.UP);
			//totalInstallmentPrice = totalInstallmentPrice.divide(1,2,System.RoundingMode.UP);
			//discounts = discounts.divide(1,2,System.RoundingMode.UP);
		}
	}
	
	public Decimal dueToday{
		get {
			if(uiKey.equals(cc_kap_utils_AppConstants.PAGE_UI_KEY_CART)){
				return dueTodayPrice;
			}else{
				return dueTodayPrice + cartShipAmount;
			}
		}
		set;
	}
	
	
	
	public  List<E_CartItem__c> getCartItems() {
		if(ccCartId == null)
			return null;
	    cartItemList = cc_dao_cart.getDisplayCartItems(ccCartId);
        if(cartItemList != null  && cartItemList.size()> 0){
        	cartListViewData = buildCartListViewData2(cartItemList);
        	//ctrlCart.cartListViewData = cartListViewData;
        }
	    Integer noOfQueries = Limits.getQueries();
	    return cartItemList;
	}
	
	public List<cc_bean_CartItem> buildCartListViewData2(List<E_CartItem__c> pdl) {
		//if (al.ArrayUtils.isEmpty(cartListViewData)) {
            cartHasCouponLineItem = false; // reset
            cartListViewData = new List<cc_bean_CartItem>();

            // Get list of product SKUs and list of ProductIDs
            List<String> skuList = new List<String>();
            Set<String> skuSet = new Set<String>();
            List<Id> productIdList = new List<Id>();

            Set<Id> productIdSet = new Set<Id>();
            Map<Id, E_Product__c> productMap = new Map<Id,E_Product__c>();
            Map<String,Double> skuMap = new Map<String,Double>();
            
            /** Kaplan Phase 1 Begin */
        	displayRulesApi = new cc_kap_api_rules_CartRules(pdl);
        	displayRulesApi.constructLineData();
        	containsShippableItems = displayRulesApi.cartHasSpec(cc_kap_utils_AppConstants.SPEC_SHIPPABLE, '1');
        	Set<String> programCodes = displayRulesApi.getSpecValues(cc_kap_utils_AppConstants.SPEC_PROGRAM_CODE);
        	List<String> codes = new List<String>();
        	if (programCodes != null) {
        		codes.addAll(programCodes);
        		programCode = codes.get(0);
        	}
        	/** Kaplan Phase 1 End */

            for(E_CartItem__c pd : pdl){
               	skuMap.put(pd.Product__r.SKU__c, pd.Quantity__c);
                skuSet.add(pd.Product__r.sku__c);
                productIdSet.add(pd.Product__r.Id);
                productMap.put(pd.Product__r.id, pd.Product__r);
                for(E_CartItem__c pi : pd.Cart_Items__r) {
                	skuMap.put(pi.Product__r.SKU__c, pi.Quantity__c);
                	skuSet.add(pi.Product__r.sku__c);
                	productIdSet.add(pi.Product__r.Id);
                	productMap.put(pi.Product__r.id, pi.Product__r);
                }
            }
            skuList.addAll(skuSet);
            productIdList.addAll(productIdSet);
            Map<String, cc_bean_PriceInfo> priceLineMap=new Map<String,cc_bean_PriceInfo>();

            Map<String,String> translatedMap = null;
            //cc_dao_ProductMedia pmDAO=new cc_dao_ProductMedia();
			Map<Id,cc_bean_MediaWrapper> thumbnailMap = null;
            //system.debug('pdl in cart extension'+pdl);
            //jll keeping track of even vs. odd lines, also redoing how minor lines are done
            boolean evenLine = false;
            for(E_CartItem__c pd : pdl) {
            	cc_bean_CartItem currentMajorItem = (assemblyListViewData(
            	   pd, productIdList,
            	   priceLineMap,translatedMap, thumbnailMap, evenLine)
                );
            	if(pd.Cart_Items__r != null) {
            		cc_bean_CartItem cartViewData = null;
            		boolean evenSubLine = false;
	            	for (E_CartItem__c pi : pd.Cart_Items__r) {
	            		currentMajorItem.minorLines.add(assemblyListViewData(
                            pi, productIdList, priceLineMap,translatedMap,
                            thumbnailMap, evenSubLine)
                        );
                        evenSubLine = !evenSubLine;
	            	}
            	}
            	/** Kaplan Phase 1 Begin */
            	currentMajorItem.dataRulesBean = displayRulesApi.getDisplayRuleBean(pd.Product__r.SKU__c);
            	if (currentMajorItem.dataRulesBean != null && currentMajorItem.dataRulesBean.availableInstallments != null) {
            		currentMajorItem.totalDiscount = currentMajorItem.dataRulesBean.availableInstallments.get(0).totalDiscount*currentMajorItem.quantity;
            		currentMajorItem.totalListPrice = currentMajorItem.dataRulesBean.availableInstallments.get(0).listPrice*currentMajorItem.quantity; 
            	}
            	if( currentMajorItem.dataRulesBean != null && !al.StringUtils.isEmpty(currentMajorItem.dataRulesBean.sbuCode) )
            	{
            		cartBean.sbuCode = currentMajorItem.dataRulesBean.sbuCode;
            		cartSBUCode = currentMajorItem.dataRulesBean.sbuCode;
            		System.debug(LoggingLevel.INFO,'@@cartSBUCode='+ cartSBUCode);
            	}
	        	/** Kaplan Phase 1 End */
	        	System.debug(LoggingLevel.INFO,'@@TO currentMajorItem='+ currentMajorItem);
// TO: Prod Fix
	        	if(currentMajorItem.product.EndDate__c >= Date.today()){
            		cartListViewData.add(currentMajorItem);
            		evenLine = !evenLine;
	        	}
            }
            Integer noOfQueries = Limits.getQueries();
		//}

        return cartListViewData; 
	}
	
	private cc_bean_CartItem assemblyListViewData(
        E_CartItem__c thisCartItem, List<Id> productIdList,
        Map<String, cc_bean_PriceInfo> priceLineMap,
        Map<String,String> translatedMap,
        Map<Id,cc_bean_MediaWrapper> thumbnailMap,
        boolean evenLine
    ) {
        cc_bean_CartItem data = new cc_bean_CartItem();
        data.cartItemType = thisCartItem.cartItemType__c;
        if (thisCartItem.ParentCartItem__r != null) {
        	data.parentProductType = thisCartItem.ParentCartItem__r.Product__r.ProductType__c;
        }
        data.product = thisCartItem.product__r;
        data.mockProduct = new cc_bean_MockProduct(thisCartItem.product__r);
        
        data.quantity = thisCartItem.Quantity__c.IntValue();
        data.SubAmount = thisCartItem.SubAmount__c.setScale(
            2, System.RoundingMode.UP
        );
        
        data.displaySubAmount = String.valueOf(data.SubAmount);
        data.price = thisCartItem.Price__c;
        data.absoluteDiscount = thisCartItem.AbsoluteDiscount__c;
        data.percentDiscount = thisCartItem.PercentDiscount__c;
        if (thisCartItem.cartItemType__c == 'Major') {
	        if (thisCartItem.Cart_Item_Pricing_Tiers__r != null
                && thisCartItem.Cart_Item_Pricing_Tiers__r.size() > 1
            ) {
		        for (E_CartItemPricingTier__c tier
                    : thisCartItem.Cart_Item_Pricing_Tiers__r
                ) {
		        	if (tier.Quantity__c != null) {
                        data.pricingTiers.add(
                            new cc_bean_CartItem.PricingTier(
                                tier.Quantity__c.intValue(), tier.Price__c
                            )
                        );
		        	}
		        }
	        }
        } else if (thisCartItem.cartItemType__c == 'Coupon') {
        	cartHasCouponLineItem = true;
        }
        data.appliedCoupon = thisCartItem.Coupon__c;
        data.itemID = thisCartItem.Id;
        
        //data.translatedProductName = translatedMap.get(thisCartItem.Product__r.SKU__c);
        /*
        if (thumbnailMap.get(thisCartItem.product__r.Id) != null) {
        	data.mediaWrapper = new cc_bean_MediaWrapper();
            data.mediaWrapper.uri = thumbnailMap.get(
                thisCartItem.product__r.Id
            ).uri;
            data.mediaWrapper.sourceType = thumbnailMap.get(
                thisCartItem.product__r.Id
            ).sourceType;
        }
        */
        List<Id> singleIDList = new List<Id>();
        singleIDList.add(thisCartItem.product__r.Id);
        
        data.evenLineNumber = evenLine;
        /** Kaplan Phase 1 Begin */
    	data.dataRulesBean = displayRulesApi.getDisplayRuleBean(thisCartItem.Product__r.SKU__c);
    	if (data.dataRulesBean != null && data.dataRulesBean.availableInstallments != null) {
            data.totalDiscount = data.dataRulesBean.availableInstallments.get(0).totalDiscount*data.quantity;
            data.totalListPrice = data.dataRulesBean.availableInstallments.get(0).listPrice*data.quantity;
    	}
    	/** Kaplan Phase 1 End */
        return data;
    }
	
	public boolean isFreeEvent { 
    	get {
    		if (freeEventFlag == null || freeEventFlag == '') {
				if (displayRulesApi == null)
	    			freeEventFlag = String.valueof(cc_kap_utils_Cart.isFreeEventCart(cartBean.encryptedId)); 
	    		else 
	    			freeEventFlag = String.valueof(cc_kap_utils_Cart.isFreeEventCart(displayRulesApi.cartLines)); 
    		}
    		return Boolean.valueOf(freeEventFlag);
    	}
    	private set; 
    }
	
	
	
	public Boolean showShipping {
		get {
			if(cartShipAmount == null || cartShipAmount.intValue() == 0)
				return false;
			return true;
		}
		set;
	}
	
	public Boolean showDiscounts{
		get {
			if(discounts == null || discounts.intValue() == 0)
				return false;	
			return true;	
		}
		set;
	}
	
	
	
	public Double cartGrandTotal {
		get{
			System.debug(LoggingLevel.INFO, '$$$ uiKey=' + uiKey);
			System.debug(LoggingLevel.INFO, '$$$ cartSubAmount=' + cartSubAmount);
			System.debug(LoggingLevel.INFO, '$$$ cartShipAmount=' + cartShipAmount);
			System.debug(LoggingLevel.INFO, '$$$ cc_kap_utils_AppConstants.PAGE_UI_KEY_CART=' + cc_kap_utils_AppConstants.PAGE_UI_KEY_CART);
			if(uiKey.equals(cc_kap_utils_AppConstants.PAGE_UI_KEY_CART)){
				return cartSubAmount;
			}else{
			return cartSubAmount + cartShipAmount;
			}	
		}
		set;
		
	}
	
	 public Double cartShipAmount {
    	get {
    		//if (cartBean.shipAmount == null || cartBean.shipAmount.intValue() == 0) {
    			//List<cc_bean_CartItem> currItems = cartListViewData;
    			if(cartBean.shipToAddress != null && cartBean.shipToAddress.country != null)
    			{
	    			if (displayRulesApi != null)
	    				cartBean.shipAmount = cc_kap_utils_Cart.calculateLineBasedShipping(displayRulesApi, cartBean.shipToAddress.country, cartSubAmount);
	    			else
	    				cartBean.shipAmount = cc_kap_utils_Cart.calculateLineBasedShipping(cartBean.encryptedId, cartBean.shipToAddress.country, cartSubAmount);
    			}
    		//}
    		return Decimal.valueOf(cartBean.shipAmount != null ? cartBean.shipAmount : 0.0).setScale(2);
    	}
    	set;
    }
    
    public Double cartDiscount {
    	get {
    		return 0.00;
    	}
    }
	
	public String getCCTax() {
        String cTotal = '0.00';
        return cTotal; 
        
    }
    
    public String displayCDN {
    	get {
    		cartCurrency = cartBean.currencyCode;
    		if(al.StringUtils.isBlank(cartCurrency) || cartCurrency.equals('USD'))
    			return '';
    		else
    			return 'CDN'; 
    	}
    	set;
    }
    
    
    public String IBFeeSKU{
    	get{
    		if(al.StringUtils.isBlank(cartCurrency))
    			cartCurrency = cartBean.currencyCode;
    		if(al.StringUtils.isBlank(cartCurrency))
    			cartCurrency = 'USD';
    		if(IBFeeUtil != null && al.StringUtils.isBlank(IBFeeSKU))
    			IBFeeSKU = IBFeeUtil.getMatchingIBFeeSKU(cartSBUCode,cartCurrency);
    			System.debug(LoggingLevel.INFO,'@@TO IBFeeSKU Returned' +IBFeeSKU);
    		return IBFeeSKU;
    	}
    	set;
    }
    
    public PageReference addIBFee(){
    	boolean IBFeeAlreadyAdded = false;
    	String flexDateStr = null;
    	if (cartItemList == null || cartItemList.size() < 1) {
	        cartItemList = getCartItems();
    	}
        if (cartItemList != null && cartItemList.size() > 0) {
	    	for (E_CartItem__c thisCartItem : cartItemList) {
	    		if(thisCartItem.Product__r != null){
	    		flexDateStr = ApexPages.currentPage().getParameters().get('datePicker' + thisCartItem.Product__r.SKU__c);
		    		if(IBFeeSKU != null && IBFeeSKU.equals(thisCartItem.Product__r.SKU__c)){
		    			IBFeeAlreadyAdded = true;
		    		}
	    		}
	    	}
    	}
    	System.debug(LoggingLevel.INFO,'@@TO flexDateStr=' + flexDateStr);
    	if(!IBFeeAlreadyAdded && !al.StringUtils.isBlank(IBFeeSKU)){
    		System.debug(LoggingLevel.INFO,'@@Adding IB Fee to Cart');
    		cartAPI.addToCart(IBFeeSKU, ccCartId, 1, cc_util_CloudCraze.isGuest()?true:false, cartCurrency, cart.CustomerTypeCode__c, true, storeID);
    		//updateCouponInfo();
    		System.debug(LoggingLevel.INFO,'@@ Perf Before'+dueTodayPrice);
    		System.debug(LoggingLevel.INFO,'@@ Perf Before'+totalInstallmentPrice);
    		//loadMiniCart();
    		//Performance Changes
    		cartItemList = getCartItems();
    		processInstallmentsForHeaderLevel();
    		System.debug(LoggingLevel.INFO,'@@ Perf After'+dueTodayPrice);
    		System.debug(LoggingLevel.INFO,'@@ Perf After'+totalInstallmentPrice);
    		//cartSubAmount = this.cartSubAmount;
    		cart.Pay_in_Installments__c = true;
    		cart.due_today__c = dueTodayPrice;
    		cart.second_payment__c = totalInstallmentPrice;
    		cart.third_payment__c = totalInstallmentPrice;
    		update cart;
    		//JLL Fix
			cc_kap_utils_Cart.calculateCartTotals(displayRulesApi.cartLines);
			update displayRulesApi.cartLines;
    		return refreshCart();
    	}
    	return null;
    }
    
    public PageReference removeIBFee(){
    	if (cartItemList == null || cartItemList.size() < 1) {
	        cartItemList = getCartItems();
	    }
	    if (cartItemList != null && cartItemList.size() > 0) {
	    	for (E_CartItem__c thisCartItem : cartItemList) {
	    		if(thisCartItem.Product__r != null){
	    			System.debug(LoggingLevel.INFO,'@@TO IBFeeSKU' + IBFeeSKU);
		    		if(IBFeeSKU != null && IBFeeSKU.equals(thisCartItem.Product__r.SKU__c)){
		    			thisCartItem.Quantity__c = 0;
		    			//cartAPI.updateCart(cartItemList, cartCurrency, cart.CustomerTypeCode__c);
		    			cart.Pay_in_Installments__c = false;
		    			cart.due_today__c = null;
    					cart.second_payment__c = null;
    					cart.third_payment__c = null;
    					update cart;
		    			//loadMiniCart();
		    			//return refreshCart();
		    			//break;
		    			/*Fixed Prodcution issue where the Order was charged as IB Order even
		    			though Cyversource was charged full amount.
		    			The Billing installment flag has to be reset to 1 when the IB product is removed.
		    			JIRA - SFI-1271
		    			Production Support - CloudCraze #00001549
		    			*/	
		    		}else{
		    			thisCartItem.Billing_Installments__c = 1;
		    			thisCartItem.AmountOwed__c = thisCartItem.SubAmount__c;
		    		}
	    		}
	    	} 
	    	cartAPI.updateCart(cartItemList, cartCurrency, cart.CustomerTypeCode__c);   	
	    	return refreshCart();
	    }
    	return null;
    } 
    
    public String PayInFull{
    	
    	get{
    		if(cartBean.payInInstallments)
    			return ' ';
    		else
    			return ' checked ';
    	}
    	set;
    } 
    
    public String PayInInstallments{
    	
    	get{
    		if(cartBean.payInInstallments)
    			return ' checked ';
    		else
    			return ' ';
    	}
    	set;
    }
    
    private PageReference refreshCart()
    {
    	if(uiKey != null && uiKey.equals(cc_kap_utils_AppConstants.PAGE_UI_KEY_CART))
		{
			ctrlCart = new cc_ctrl_Cart();
			ctrlCart.cartItemList = ctrlCart.getCartItems();
	    	System.debug(LoggingLevel.INFO, '$$continueHistoryCount Before=' + ctrlCart.continueHistoryCount);
			
			PageReference page = System.Page.Cart;
			page.getParameters().put('cartID', ccCartId);
	        page.getParameters().put('productID', currentProductID);
	        page.getParameters().put('viewState','CartView');
	        page.getParameters().put('store', storeID);
	        page.getParameters().put('continueHistoryCount', String.valueOf(++ctrlCart.continueHistoryCount));
	        System.debug(LoggingLevel.INFO, '$$continueHistoryCount After=' + ctrlCart.continueHistoryCount);
	        page.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, ipAddressLocation);
	        Page.getParameters().put('couponMessage',couponMessage);
	        Page.getParameters().put('successCouponMessage',successCouponMessage);
			page.setRedirect(true);
			return page;
		}
		else
		{
			//cc_extn_OrderReview reviewInfo = new cc_extn_OrderReview();
			//reviewInfo.cartListViewData;
			
			PageReference page = System.Page.CheckOutNew;
			page.getParameters().put('cartID', ccCartId);
	        //page.getParameters().put('productID', currentProductID);
	        page.getParameters().put('ViewState','OrderPaymentReview');
	        page.getParameters().put('store', storeID);
	        //page.getParameters().put('continueHistoryCount', String.valueOf(ctrlCart.continueHistoryCount++));
	        //page.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, ipAddressLocation);
	        Page.getParameters().put('couponMessage',couponMessage);
	        Page.getParameters().put('successCouponMessage',successCouponMessage);
			page.setRedirect(true);
			return page;
		}
		return null;
    } 
}