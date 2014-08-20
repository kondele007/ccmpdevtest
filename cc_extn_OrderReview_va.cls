public without sharing class cc_extn_OrderReview_va extends cc_ExtensionBase_va {
	public static final String name = 'OrderReviewInfo';
	public cc_ctrl_CheckOut_va checkOutController {get;set;}
	public cc_bean_Cart cartBean {get;set;}	

	/** Kaplan Phase 1 Begin */
	private cc_kap_api_rules_CartRules displayRulesApi {get; set;}
	public List<String> installMessages { get; private set; }
	private Map<String, Decimal> totals {get; set; }
	public String authCode { get; set; }
    public String subscriptionId { get; set; }
    public String cardNumber { get; set; }
    public String cardType { get; set; }
    public String hopErrorMessage { get; set; }
    public String expMonth { get; set; }
    public String expYear { get; set; }
    public String programCode{get; set;}
    public String kbsProgramCodes{get; set;} // Case # 00001814 ----- cw ----- 
        
    public boolean containsShippableItems {get; private set; }
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
    public String freeEventFlag { get; private set; }
	/** Kaplan Phase 1 End */

	public List<cc_bean_CartItem> cartListViewData {
		get {
			if(cartListViewData == null) {
				System.debug(LoggingLevel.INFO, 'cc_extn_OrderReview.getCartListViewData: cartBean.encryptedId=' + cartBean.encryptedId);
	            List<E_CartItem__c> cartItems = cc_dao_cart_va.getDisplayCartItems(cartBean.encryptedId);
				/** Kaplan Phase 1 Begin */
				this.isFreeEvent = cc_kap_utils_Cart.isFreeEventCart(cartItems);
				this.freeEventFlag = String.valueof(isFreeEvent);
				this.displayRulesApi = new cc_kap_api_rules_CartRules(cartItems, cartBean.currencyCode);
				this.installMessages = displayRulesApi.installmentMessages;
	            if (cartItems != null  && cartItems.size() > 0)
	            	cartListViewData = cc_hlpr_Cart_va.buildCartViewData(displayRulesApi, cartHasCouponLineItem);
	            containsShippableItems = displayRulesApi.cartHasSpec(cc_kap_utils_AppConstants.SPEC_SHIPPABLE, '1');
	        	Set<String> programCodes = displayRulesApi.getSpecValues(cc_kap_utils_AppConstants.SPEC_PROGRAM_CODE);
	        	List<String> codes = new List<String>();
	        	if (programCodes != null) {
	        		codes.addAll(programCodes);
                    programCode = codes.get(0);                 
	        	}	        	

                /************* CASE # 1732 - Begin ************/
                for(cc_bean_CartItem clvd : cartListViewData){
                    for(E_CartItem__c ci : cartItems){
                        if(ci.Product__c == clvd.product.id){

                            List<E_CartItem__c> cartItem = new List<E_CartItem__c>();
                            cartItem.add(ci);
                            cc_kap_api_rules_CartRules cartRulesAPI = new cc_kap_api_rules_CartRules(cartItem);
                            Set<String> kbsProgramCodeSet = displayRulesApi.getSpecValues(cc_kap_utils_AppConstants.SPEC_KBS_PROGRAM_CODE);
                            List<String> kbsProgramCodeList = new List<String>(); 

                            if(kbsProgramCodeSet != null){
                                kbsProgramCodeList.addAll(kbsProgramCodeSet);
                                clvd.kbsProgramCode = kbsProgramCodeList.get(0);

                                // Case # 00001814 ----- Begin ----- cw -----  
                                kbsProgramCodes = '';                           
                                kbsProgramCodes = kbsProgramCodeList.get(0);

                                if(kbsProgramCodeList.size() > 1){
                                    for(integer i = 1; i <= kbsProgramCodeList.size() - 1; i++){
                                        kbsProgramCodes = kbsProgramCodes + ',' + kbsProgramCodeList.get(i);
                                    }
                                }         
                                kbsProgramCodes.trim();
                                // Case # 00001814 ----- End ----- cw -----     
                            }  
                        }
                    }
                } 
                /************* CASE # 1732 - End ************/
	        
	            //updateCouponInfo();
	            /** Kaplan Phase 1 End */
			}
			return cartListViewData;
		}
		set;
	}

	// TODO: refactor updateCouponInfo to use a coupon bean as part of cc_bean_Cart
	public String couponId {get;set;}
	public String couponCode {get;set;}
	public String couponName {get;set;}
    public E_Coupon__c coupon {get;set;}
    public String selectedCoupon { get; set; }
    public String couponMessage { get; set; }
    public String requiredSKU {get;set;}
    public Boolean applyToAll {get;set;}
    public Boolean cartHasCouponLineItem {get;set;}
    public List<SelectOption> couponList {
	    get {
	        if(couponList == null)
	            couponList = new List<SelectOption>();
	        return couponList;
	    }
	    set;}
    
    public Double cartSubAmount {
    	get {
			cc_api_Cart api = new cc_api_Cart();
			Double sub = api.getCartTotal(cartBean.sfid);
			if(sub != null) {
	   			cartSubAmount = Decimal.valueOf(sub).setScale(2);
			}
    		return cartSubAmount;
    	}
    	set;
    }
    
    public Double cartShipAmount {
    	get {
    		if (cartBean.shipAmount == null || cartBean.shipAmount == 0.00) {
    			List<cc_bean_CartItem> currItems = cartListViewData;
    			if (displayRulesApi != null)
    				cartBean.shipAmount = cc_kap_utils_Cart.calculateLineBasedShipping(displayRulesApi, cartBean.shipToAddress.country, cartSubAmount);
    			else
    				cartBean.shipAmount = cc_kap_utils_Cart.calculateLineBasedShipping(cartBean.encryptedId, cartBean.shipToAddress.country, cartSubAmount);
    		}
    		return Decimal.valueOf(cartBean.shipAmount != null ? cartBean.shipAmount : 0.0).setScale(2);
    	}
    	set;
    }
    
    public Double cartTaxAmount {
    	get {
			/*Double tax = cc_hlpr_Cart.getCartTaxAmount(cartBean.sfid, cartBean.shipToAddress.postalCode);
			if(tax != null) {
				cartTaxAmount = Decimal.valueOf(tax).setScale(2);
			}
			return cartTaxAmount;*/
			return 0.0;
    	}
    	set;
    }

    public Double cartTotalAmount {
        get {
        	Double totalAmount = cartSubAmount;
            Double ship = cartShipAmount;
            Double tax = cartTaxAmount;
            if (ship != null)
            	totalAmount += ship;
            if(tax != null)
            	totalAmount += tax;
   			totalAmount = Decimal.valueOf(totalAmount).setScale(2);
            return totalAmount;
        }
    }
    
    public Double cartDueNowTotalAmount {
        get {
            totals = cc_kap_utils_Cart.calculateCartTotals(displayRulesApi.cartLines);
        	Double totalAmount = totals.get(cc_kap_utils_AppConstants.TOTALS_UPFRONT);
            Double ship = cartShipAmount;
            Double tax = cartTaxAmount;
            if (ship != null)
            	totalAmount += ship;
            if(tax != null)
            	totalAmount += tax;
   			totalAmount = Decimal.valueOf(totalAmount).setScale(2);
            return totalAmount;
        }
    }

	//==================================================
	// CONSTRUCTORS
	//==================================================
	public cc_extn_OrderReview_va(cc_ctrl_CloudCraze_va c) {
		super(c);
		
		// add references to parent
		checkOutController = (cc_ctrl_CheckOut_va) parentController;
		cartBean = checkOutController.cartBean;
	}

	//==================================================
	// OVERRIDE METHODS
	//==================================================
	public override string getName() {
		return name;
	}

	public override PageReference gotoStep() {
		return checkOutController.gotoStep(cc_extn_OrderReview_va.name);
	}

	//==================================================
	// HELPER METHODS
	//==================================================
	public cc_extn_OrderReview_va getOrderReviewInfo() { return this; }

	// TODO: refactor updateCouponInfo to use a coupon bean as part of cc_bean_Cart
    public void updateCouponInfo() {
        String relation='';
        //system.debug('-----------------------currentCartID: ##' + currentCartID + '##');
        couponName = null;
        couponId = null;
        this.coupon = null;
        requiredSKU = null;
        applyToAll = false;
        if(cartBean != null){
        	 cc_api_Cart cartAPI = new cc_api_Cart();
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
	    //System.debug('----Limits.getQueries()-CartExtensions.updateCouponInfo---- : ' + noOfQueries);
	    //System.debug('-------------- updateCouponInfo relation: ' + relation);
	    //System.debug('-------------- updateCouponInfo requiredSKU: ' + requiredSKU);
	    //System.debug('-------------- updateCouponInfo couponName: ' + couponName);
	    //System.debug('-------------- updateCouponInfo applyToAll: ' + applyToAll);
	    //System.debug('-------------- updateCouponInfo coupon: ' + coupon);
    }
    
	public PageReference placeOrder(){
		return cc_hlpr_Cart_va.placeOrderAndRedirect(cartBean.sfid);
    }
    
    public PageReference selectCoupon(){
        couponCode = selectedCoupon;
        return addCoupon();
    }

    public PageReference addCoupon(){
        //system.debug('----------------------------------------------addToCart');
        String viewState = 'CartView';
        Boolean useNewCoupon = false;
        cc_api_Cart cc_api_Cart = new cc_api_Cart();
        E_Cart__c cart = cc_api_Cart.retrieveCart(cartBean.sfid);
        couponMessage = null;
        couponList.clear();

        //system.debug('----------------------------------------------cc_api_Cart.addToCart');
        if(selectedCoupon != null){
            // Assign the selected coupon
            useNewCoupon = true;
        }

       /* if(displayRulesApi.cartLines == null || cartItemList.size() < 1){
           cartItemList = getCartItems();
        }*/

        /*if(cartItemList != null && cartItemList.size() > 0){
            //System.debug('---------Updating cartItemList');
            Map<String, Double> quantityMap = new Map<String, Double>();
            for(cc_bean_CartItem wishListItem: cartListViewData){
                quantityMap.put(wishListItem.product.ID, wishListItem.quantity);
                //System.debug('---------wishListItem,quantity: ' +  wishListItem.product.ID + ',' +  wishListItem.product.Name + ',' + wishListItem.quantity);
            }
            for(E_CartItem__c thisCartItem : cartItemList){
//                String qty = ApexPages.currentPage().getParameters().get('qtyhdn['+thisCartItem.productId__r.SKU__c+']');
                Double qty = quantityMap.get(thisCartItem.Product__c);
                //System.Debug('Quantity'+qty);
                //if(qty != null && qty != '')
                    thisCartItem.Quantity__c = qty;
                    //System.debug('Updating quantity: ' + qty);
            }

        }*/

        couponMessage = cc_api_Cart.addCoupon(cart, couponCode, displayRulesApi.cartLines,useNewCoupon);

        // initialize attributes
        selectedCoupon = null;
        couponList.clear();

        E_Coupon__c coupon = cc_api_Cart.getCoupon(couponCode);
        if('SelectCoupon'.equals(couponMessage)){
            // Warn the user and ask which coupon to use
            List<E_CartCoupon__c> cartCoupons = cc_api_Cart.getCartCoupons(cart.ID);
            couponMessage = 'Only one coupon per cart may be used.';
            couponList.add(new SelectOption(cartCoupons[0].Coupon__r.CouponCode__c, cartCoupons[0].Coupon__r.Rule__r.Name__c));
            couponList.add(new SelectOption(coupon.CouponCode__c,coupon.Rule__r.Name__c));
        }else {
            if('Success'.equals(couponMessage)){
                couponMessage = 'The coupon has been added to your cart.';
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

             // Get the updated list
		/** Kaplan Phase 1 Begin */
        List<E_CartItem__c> cartItems = cc_dao_cart_va.getDisplayCartItems(cartBean.encryptedId);
		displayRulesApi = new cc_kap_api_rules_CartRules(cartItems);
        if (cartItems != null  && cartItems.size() > 0)
        	cartListViewData = cc_hlpr_Cart_va.buildCartViewData(displayRulesApi, cartHasCouponLineItem);
        /** Kaplan Phase 1 End */
        couponName = null;
        couponId = null;
        updateCouponInfo();
	cc_kap_utils_Cart.calculateCartTotals(displayRulesApi.cartLines);
	update displayRulesApi.cartLines;
        //system.debug('-----------coupon name: ' + couponName);
        }
        return null;
    }
    
    
    /** Kaplan Phase 1 Begin */
	public PageReference updateCartCheckout() {
		if (displayRulesApi.cartLines == null || displayRulesApi.cartLines.size() < 1) {
	         List<E_CartItem__c> cartItems = cc_dao_cart_va.getDisplayCartItems(cartBean.encryptedId);
			displayRulesApi = new cc_kap_api_rules_CartRules(cartItems);
		}
	    if (displayRulesApi.cartLines != null  && displayRulesApi.cartLines.size() > 0)
	        	cartListViewData = cc_hlpr_Cart_va.buildCartViewData(displayRulesApi, cartHasCouponLineItem);
        if (displayRulesApi.cartLines != null && displayRulesApi.cartLines.size() > 0) {
            for (E_CartItem__c line : displayRulesApi.cartLines) {
            	String installment = ApexPages.currentPage().getParameters().get('billingOpt' + line.Product__r.SKU__c);
            	if (installment != null)
            		line.Billing_Installments__c = Integer.valueOf(installment);
            }
        }
        Map<String, Decimal> totals = cc_kap_utils_Cart.updateCartTotalsAndShipping(displayRulesApi.cartLines, cartBean.shipToAddress.country, false);
        cc_api_Cart cc_api_Cart = new cc_api_Cart();
        cc_api_Cart.updateCart(displayRulesApi.cartLines);
	    cartListViewData = null;
	    totals = null;
	    return null;
	}
	
	/**
	 * Tied to an action function to be called from the child window, allowing the HOP to
	 * place the order and refresh the parent window. Place order initiated from the HOP 
	 * which will pass additional data such as the auth code, the subscription id and the cardnumber.
	 */
	public PageReference hopPlaceOrder() {
		//JLL - dupe order fix
		//refresh the order to see if its actually already been placed
		System.debug('ah hop place order start');
		E_Cart__c cart = cartBean.dataObject;
		E_Cart__c freshCart = [select CartStatus__c from E_Cart__c where Id =: cart.Id];
		if(freshCart.CartStatus__c == cc_cnst_PickListConstants.CARTSTATUS_OPEN){
			System.debug('ah set payment details');
			hopErrorMessage = null;
			cartBean.paymentMethod = 'cc';
			cartBean.creditCard.cardType = cardType;
			cartBean.creditCard.cardNumber = cardNumber;
			cartBean.creditCard.authCode = authCode;
			cartBean.creditCard.subscriptionId = subscriptionId;
			cartBean.creditCard.expiryMonth = expMonth;
			cartBean.creditCard.expiryYear = expYear;
			cart = cartBean.dataObject; 
			update cart;
			System.debug('curr cart ah ' +cart);
			createPayment(cart.Id);
			return placeOrder();
		}
		else{
			hopErrorMessage = 'This order has already been placed.';
			System.debug('-----Caught duplicate Order Place------');
			throw new cc_excn_CartException('This order has already been placed.');
		}
	}
	
	private void createPayment(Id cartId) {
		E_PaymentDetail__c payment = new E_PaymentDetail__c();
		payment.Authorization_Code__c = authCode;
		payment.Credit_Card_Type__c = cardType;
		payment.Expiration_Month__c = expMonth;
		payment.Expiration_Year__c = Integer.valueOf(expYear);
		payment.Masked_Card_Number__c = cardNumber;
		payment.Subscription_Id__c = subscriptionId;
		payment.CC_Cart__c = cartId;
		payment.Settlement_Date__c = System.now();
		upsert payment;
	}
	
	/**
	 * Tied to an action function to be called from the child window, allowing the HOP to
	 * push payment errors and refresh the parent window.
	 */
	public PageReference hopFailure() {
		return null;
	}
	/** Kaplan Phase 1 End */
	
    
}