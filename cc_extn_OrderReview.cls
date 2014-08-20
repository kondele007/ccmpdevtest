public without sharing class cc_extn_OrderReview extends cc_ExtensionBase {
    public static final String name = 'OrderReviewInfo';
    public cc_ctrl_CheckOut checkOutController {get;set;}
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
                List<E_CartItem__c> cartItems = cc_dao_cart.getDisplayCartItems(cartBean.encryptedId);
                /** Kaplan Phase 1 Begin */
                this.isFreeEvent = cc_kap_utils_Cart.isFreeEventCart(cartItems);
                this.freeEventFlag = String.valueof(isFreeEvent);
                this.displayRulesApi = new cc_kap_api_rules_CartRules(cartItems, cartBean.currencyCode);
                this.installMessages = displayRulesApi.installmentMessages;
                if (cartItems != null  && cartItems.size() > 0)
                    cartListViewData = cc_hlpr_Cart.buildCartViewData(displayRulesApi, cartHasCouponLineItem);
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
                    System.debug(LoggingLevel.INFO,'@@JLLHERE');
                    if( clvd.dataRulesBean != null && !al.StringUtils.isEmpty(clvd.dataRulesBean.sbuCode) )
                    {
                        cartBean.sbuCode = clvd.dataRulesBean.sbuCode;
                        cartSBUCode = clvd.dataRulesBean.sbuCode;
                        System.debug(LoggingLevel.INFO,'@@cartSBUCode='+ cartSBUCode);
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

    //JLL 3/25/2014 IBFee reintroduction
    public E_Cart__c cart {get;set;}
    public String successCouponMessage { get; set; }

    public cc_kap_IBFee_Util IBFeeUtil {
        get{
            if(IBFeeUtil == null)
                IBFeeUtil = new cc_kap_IBFee_Util();
            return IBFeeUtil;
        }
        set;
    }
    
    public String cartSBUCode {get;set;}
    public String uiKey {get;set;}
    public String cartCurrency { get; set; }
    
    public String IBFeeSKU{get; set;}

    public Decimal dueToday{
        get {
            if(uiKey != null && uiKey.equals(cc_kap_utils_AppConstants.PAGE_UI_KEY_CART)){
                return dueTodayPrice;
            }else{
                return dueTodayPrice + cartShipAmount;
            }
        }
        set;
    }
    
    public cc_api_Cart cartAPI{
        get{
            if(cartAPI == null)
                cartAPI = new cc_api_Cart();
            return cartAPI;
        }
        set;
    }

    public Boolean installmentsAvailable {get;set;}
    public Decimal totalInstallmentPrice {get;set;}
    public Decimal dueTodayPrice {get;set;}
    public Decimal discounts {get;set;}

    //==================================================
    // CONSTRUCTORS
    //==================================================
    public cc_extn_OrderReview(cc_ctrl_CloudCraze c) {
        super(c);
        
        // add references to parent
        checkOutController = (cc_ctrl_CheckOut) parentController;
        cartBean = checkOutController.cartBean;
        cartSBUCode = ApexPages.currentPage().getParameters().get('ccbuid');
        System.debug(LoggingLevel.INFO,'@@Cart SBU Code' + cartSBUCode);
        cartItemList = getCartItems();
        this.cart = cartBean.dataObject;
        updateCouponInfo();
        //JLL IB FEE Fix
        if(al.StringUtils.isBlank(cartCurrency))
            cartCurrency = cartBean.currencyCode;
        if(al.StringUtils.isBlank(cartCurrency))
            cartCurrency = 'USD';
        if(IBFeeUtil != null && al.StringUtils.isBlank(IBFeeSKU))
           if(cartSBUCode!=null){//Added Null pointer check--Sai
            IBFeeSKU = IBFeeUtil.getMatchingIBFeeSKU(cartSBUCode,cartCurrency);
            }
        System.debug(LoggingLevel.INFO,'@@Adding IB Fee SKU' + IBFeeSKU);
        processInstallmentsForHeaderLevel();
    }

    //==================================================
    // OVERRIDE METHODS
    //==================================================
    public override string getName() {
        return name;
    }

    public override PageReference gotoStep() {
        return checkOutController.gotoStep(cc_extn_OrderReview.name);
    }

    //==================================================
    // HELPER METHODS
    //==================================================
    public cc_extn_OrderReview getOrderReviewInfo() { return this; }

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
        return cc_hlpr_Cart.placeOrderAndRedirect(cartBean.sfid);
    }
    
    public PageReference selectCoupon(){
        couponCode = selectedCoupon;
        return addCoupon();
    }

    public PageReference addCoupon(){
        //system.debug('----------------------------------------------addToCart');
        //String viewState = 'CartView';
        Boolean useNewCoupon = false;
        cc_api_Cart cc_api_Cart = new cc_api_Cart();
        this.cart = cc_api_Cart.retrieveCart(cartBean.sfid);
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

        System.debug(LoggingLevel.INFO, 'JLLLLLL - ' + couponCode);
        System.debug(LoggingLevel.INFO, 'JLLLLLL - ' + displayRulesApi.cartLines);
        System.debug(LoggingLevel.INFO, 'JLLLLLL - ' + useNewCoupon);
        couponMessage = cc_api_Cart.addCoupon(cart, couponCode, displayRulesApi.cartLines,useNewCoupon);
        System.debug(LoggingLevel.INFO, 'JLLLLLL - ' + couponMessage);
        // initialize attributes
        selectedCoupon = null;
        couponList.clear();

        E_Coupon__c coupon = cc_api_Cart.getCoupon(couponCode);
        if('SelectCoupon'.equals(couponMessage)){
            // Warn the user and ask which coupon to use
            List<E_CartCoupon__c> cartCoupons = cc_api_Cart.getCartCoupons(cart.ID);
            couponMessage = 'Only one coupon per cart may be used.';
            
            // Issue# 104 - changed name to code
            //couponList.add(new SelectOption(cartCoupons[0].Coupon__r.CouponCode__c, cartCoupons[0].Coupon__r.Rule__r.Name__c));
            //couponList.add(new SelectOption(coupon.CouponCode__c,coupon.Rule__r.Name__c));
            couponList.add(new SelectOption(cartCoupons[0].Coupon__r.CouponCode__c, cartCoupons[0].Coupon__r.CouponCode__c));
            couponList.add(new SelectOption(coupon.CouponCode__c, coupon.CouponCode__c));
        }else {
            if('Success'.equals(couponMessage)){
                //couponMessage set in component
                couponMessage = '';
            }else if('CouponAlreadyAdded'.equals(couponMessage)){
                couponMessage = 'The coupon entered is already in your cart.';
            }else if ('InvalidCoupon'.equals(couponMessage)){
                couponMessage = 'We\'re sorry! This code is invalid or has expired.';

            }else if ('MinAmountNotMet'.equals(couponMessage)){
                couponMessage = 'Your cart total is not high enough for this coupon.';
            }else if ('MissingRequiredSKU'.equals(couponMessage)){
                couponMessage = 'The product required for this coupon is not in your cart.';
            }else if ('MinQuantityNotMet'.equals(couponMessage)){
                couponMessage = 'Your cart quantity is not high enough for this coupon.';
            }

             // Get the updated list
            /** Kaplan Phase 1 Begin */
            List<E_CartItem__c> cartItems = cc_dao_cart.getDisplayCartItems(cartBean.encryptedId);
            displayRulesApi = new cc_kap_api_rules_CartRules(cartItems);
            if (cartItems != null  && cartItems.size() > 0)
                cartListViewData = cc_hlpr_Cart.buildCartViewData(displayRulesApi, cartHasCouponLineItem);
            /** Kaplan Phase 1 End */
            couponName = null;
            couponId = null;
            updateCouponInfo();
            //JLL IB FEE Fix
            processInstallmentsForHeaderLevel();
            cc_kap_utils_Cart.calculateCartTotals(displayRulesApi.cartLines);
            update displayRulesApi.cartLines;
            //system.debug('-----------coupon name: ' + couponName);
        }
        
        if(cartBean.payInInstallments)
            addIBFee();
        else
            removeIBFee();
        
        //JLL 5/5 might want to still call refresh cart but not return it
        //return refreshCart();
        System.debug(LoggingLevel.INFO, 'JLLLLLL - ' + couponList.size());
        return null;
    }
    
    
    /** Kaplan Phase 1 Begin */
    public PageReference updateCartCheckout() {
        if (displayRulesApi.cartLines == null || displayRulesApi.cartLines.size() < 1) {
             List<E_CartItem__c> cartItems = cc_dao_cart.getDisplayCartItems(cartBean.encryptedId);
            displayRulesApi = new cc_kap_api_rules_CartRules(cartItems);
        }
        if (displayRulesApi.cartLines != null  && displayRulesApi.cartLines.size() > 0)
                cartListViewData = cc_hlpr_Cart.buildCartViewData(displayRulesApi, cartHasCouponLineItem);
                Map <String, String> lineIDMap = new Map <String, String>() ;       
        for(cc_bean_CartItem pc : cartListViewData){
            List<cc_kap_rules_bean_CartDataInstallPrice> installPriceLstBean = pc.dataRulesBean.availableInstallments;
                if(installPriceLstBean != null && installPriceLstBean.size()>1)
                {
                    for(cc_kap_rules_bean_CartDataInstallPrice installment: installPriceLstBean){
                        if(installment.installments == 3 && cart.Pay_in_Installments__c){
                             lineIDMap.put(pc.dataRulesBean.line.Product__r.SKU__c, 'true');
                        }
                    }
                }
        }
        if (displayRulesApi.cartLines != null && displayRulesApi.cartLines.size() > 0) {
            for (E_CartItem__c line : displayRulesApi.cartLines) {
                //String installment = ApexPages.currentPage().getParameters().get('billingOpt' + line.Product__r.SKU__c);
                //if (installment != null)
                if (lineIDMap.get(line.Product__r.SKU__c) != null)
                    line.Billing_Installments__c = 3;
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
        this.cart = cartBean.dataObject;
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
            //JLL FIX for if IB was selected on payment page...
            updateCartCheckout();
            //end fix
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
    //JLL IBFee reintroduction 3/25/2014

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
                            System.debug(LoggingLevel.INFO,'@@1.discounts='+ discounts);
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
                    System.debug(LoggingLevel.INFO,'@@2.discounts='+ discounts);
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
    public List<E_CartItem__c> cartItemList {get; set; }
    public  List<E_CartItem__c> getCartItems() {
                if(checkoutController.ccCartId == null)
                    return null;
                //reset inventory status. buildCartListViewData will set it back to false if needed
                //System.debug('----IN GETCARTITEMS------');
                //this.validInventory = true;
                cc_api_Cart api = new cc_api_Cart();

                //System.debug('currentCartID####'+currentCartID);


                //List<E_CartItem__c> cartItemList = api.getCartItems(currentCartID);
                cartItemList = cc_dao_cart.getDisplayCartItems(checkoutController.ccCartId);
                //System.debug('cartItemList####'+cartItemList);

                if(cartItemList != null  && cartItemList.size()> 0){
                    if(displayRulesApi == null)
                        displayRulesApi = new cc_kap_api_rules_CartRules(cartItemList);
                    //System.debug('-----cartItemList----' + cartItemList);
                    //cartListViewData = cc_hlpr_Cart.buildCartViewData(displayRulesApi, cartHasCouponLineItem);
                    this.cartListViewData = buildCartListViewData2(cartItemList);
                    List<cc_bean_CartItem> cartListViewDatatemp = new List<cc_bean_CartItem>();
                    List<cc_bean_CartItem> cartListViewDatasorted = new List<cc_bean_CartItem>();
                    cc_bean_CartItem cartItemTemp;
                    if(this.cartListViewData != null){
                        cartListViewDatatemp =  this.cartListViewData;
                        //cartListViewDatatemp = buildCartListViewData2(cartItemList);
                          for(cc_bean_CartItem cartItem: cartListViewDatatemp){
                            if(cartItem.dataRulesBean == null || !cartItem.dataRulesBean.IBFee){
                              System.debug(LoggingLevel.INFO,'cartItem####'+cartItem);
                                cartListViewDatasorted.add (cartItem);
                            }else{
                                cartItemTemp = cartItem;
                            }
                          }
                          if(cartItemTemp != null){
                            cartListViewDatasorted.add(cartItemTemp);
                          }
                          System.debug(LoggingLevel.INFO,'cartListViewDatasorted####'+cartListViewDatasorted.size());
                          System.debug(LoggingLevel.INFO,'cartListViewData before clear####'+cartListViewData.size());
                          this.cartListViewData.clear();
                          this.cartListViewData.addall(cartListViewDatasorted);
                          //cartListViewData = cartListViewDatasorted;
                          System.debug(LoggingLevel.INFO,'cartListViewData after reloaded####'+cartListViewData);
                        }    
                    }

                //System.debug('cartListViewData####'+this.cartListViewData);

                Integer noOfQueries = Limits.getQueries();
                //system.debug('----Limits.getQueries()-cc_ctrl_Cart.getCartItems---- : ' + noOfQueries);
                return cartItemList;
            }   
    public PageReference addIBFee(){
        if(!al.StringUtils.isBlank(IBFeeSKU)){
            System.debug(LoggingLevel.INFO,'@@Adding IB Fee to Cart' + IBFeeSKU);
            cartAPI.addToCart(IBFeeSKU, checkOutController.ccCartId, 1, cc_util_CloudCraze.isGuest()?true:false, cartCurrency, cart.CustomerTypeCode__c, true, checkOutController.storeID);
        }
        cart.Pay_in_Installments__c = true;
        cartBean.payInInstallments = true;
        cart.due_today__c = dueTodayPrice;
        cart.second_payment__c = totalInstallmentPrice;
        cart.third_payment__c = totalInstallmentPrice;
        update cart;
        //JLL Fix
        cc_kap_utils_Cart.calculateCartTotals(displayRulesApi.cartLines);
        update displayRulesApi.cartLines;
        cartListViewData = null;
        cartItemList = getCartItems();
        processInstallmentsForHeaderLevel();
        Map <String, String> lineIDMap = new Map <String, String>() ;
        for(cc_bean_CartItem pc : cartListViewData){
            List<cc_kap_rules_bean_CartDataInstallPrice> installPriceLstBean = pc.dataRulesBean.availableInstallments;
            if(installPriceLstBean != null && installPriceLstBean.size()>1)
                {
                for(cc_kap_rules_bean_CartDataInstallPrice installment: installPriceLstBean){
                    if(installment.installments == 3 && cart.Pay_in_Installments__c){
                        lineIDMap.put(pc.dataRulesBean.line.Product__r.SKU__c, 'true');
                    }
                }
            }
        }
        if (cartItemList != null && cartItemList.size() > 0) {
            for (E_CartItem__c line : cartItemList) {
                //String installment = ApexPages.currentPage().getParameters().get('billingOpt' + line.Product__r.SKU__c);
                //if (installment != null)
                if (lineIDMap.get(line.Product__r.SKU__c) != null)
                    line.Billing_Installments__c = 3;
            }
            update cartItemList;
        }
        return null;
    }
    
    public PageReference removeIBFee(){
        System.debug(LoggingLevel.INFO, 'JLL HEREERERERERERE' + cart.Pay_in_Installments__c);
        if(cart.Pay_in_Installments__c != null && cart.Pay_in_Installments__c){
            cart.Pay_in_Installments__c = false;
            cartBean.payInInstallments = false;
            cart.due_today__c = null;
            cart.second_payment__c = null;
            cart.third_payment__c = null;
            System.debug(LoggingLevel.INFO, 'JLL HEREERERERERERE');
            if (cartItemList != null && cartItemList.size() > 0) {
                System.debug(LoggingLevel.INFO, 'JLL HEREEREREREREREdddddddddd');
                for (E_CartItem__c thisCartItem : cartItemList) {
                    if(thisCartItem.Product__r != null){
                        if(IBFeeSKU != null && IBFeeSKU.equals(thisCartItem.Product__r.SKU__c)){
                            thisCartItem.Quantity__c = 0;
                        }else{
                            System.debug(LoggingLevel.INFO, 'JLL HEREEREREREREREssssssssss');
                            thisCartItem.Billing_Installments__c = 1;
                            thisCartItem.AmountOwed__c = thisCartItem.SubAmount__c;
                        }
                    }
                }
                System.debug(LoggingLevel.INFO, 'JLL HEREERERERERERE');
                update cartItemList;
                update cart;
                cartAPI.updateCart(cartItemList, cartCurrency, cart.CustomerTypeCode__c);
            }       
        }
        cartListViewData = null;
        cartItemList = getCartItems();
        processInstallmentsForHeaderLevel();
        return null;
    }
    
    private PageReference refreshCart()
    {
        //cc_extn_OrderReview reviewInfo = new cc_extn_OrderReview();
        //reviewInfo.cartListViewData;
        PageReference page = System.Page.CheckOutNew;
        page.getParameters().put('cartID', checkoutController.ccCartId);
        //page.getParameters().put('productID', currentProductID);
        page.getParameters().put('ViewState','OrderPaymentReview');
        page.getParameters().put('store', checkoutController.storeID);
        //page.getParameters().put('continueHistoryCount', String.valueOf(ctrlCart.continueHistoryCount++));
        //page.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, ipAddressLocation);
        Page.getParameters().put('couponMessage',couponMessage);
        Page.getParameters().put('successCouponMessage',successCouponMessage);
        page.setRedirect(true);
        return page;
    }
    public Boolean showDiscounts{
        get {
            if(discounts == null || discounts.intValue() == 0)
                return false;   
            return true;    
        }
        set;
    }
    
    public String PayInFull{
        
        get{
            if(cart.Pay_in_Installments__c)
                return ' ';
            else
                return ' checked ';
        }
        set;
    } 
    
    public String PayInInstallments{
        
        get{
            if(cart.Pay_in_Installments__c)
                return ' checked ';
            else
                return ' ';
        }
        set;
    }
    
//JLL IB Fee fix
    public Decimal couponDiscountAmount{get; set;}
    public List<cc_bean_CartItem> buildCartListViewData2(List<E_CartItem__c> pdl) {
        if (al.ArrayUtils.isEmpty(cartListViewData)) {
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

            couponDiscountAmount = 0;
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
                    if(pi.AbsoluteDiscount__c != null)
                        couponDiscountAmount += pi.AbsoluteDiscount__c;
                }
                if(pd.AbsoluteDiscount__c != null)
                    couponDiscountAmount += pd.AbsoluteDiscount__c;
            }
            skuList.addAll(skuSet);
            productIdList.addAll(productIdSet);
            Map<String, cc_bean_PriceInfo> priceLineMap=new Map<String,cc_bean_PriceInfo>();
            cc_dao_ProductMedia productMedia=new cc_dao_ProductMedia();
            Map<Id,cc_bean_MediaWrapper> imageMap=productMedia.getProductThumbnailMedia(productIdList);

            Map<String,String> translatedMap = getTranslatedProductNames(skuList);
            cc_dao_ProductMedia pmDAO=new cc_dao_ProductMedia();
            Map<Id,cc_bean_MediaWrapper> thumbnailMap = pmDAO.getProductThumbnailMedia(productIdList);
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
                }

                /** Kaplan Phase 1 End */
                

                /************* CASE # 1732 - Begin ************/

                List<E_CartItem__c> cartItem = new List<E_CartItem__c>();
                cartItem.add(pd);
                cc_kap_api_rules_CartRules cartRulesAPI = new cc_kap_api_rules_CartRules(cartItem);
                Set<String> kbsProgramCodeSet = displayRulesApi.getSpecValues(cc_kap_utils_AppConstants.SPEC_KBS_PROGRAM_CODE);
                List<String> kbsProgramCodeList = new List<String>(); 
                if(kbsProgramCodeSet != null){
                    kbsProgramCodeList.addAll(kbsProgramCodeSet);
                    currentMajorItem.kbsProgramCode = kbsProgramCodeList.get(0);
                }               

                /************* CASE # 1732 - End ************/

                cartListViewData.add(currentMajorItem);


                evenLine = !evenLine;
            }
            Integer noOfQueries = Limits.getQueries();
        }

        return cartListViewData;
    }
    
    private Map<String,String> getTranslatedProductNames(List<String> skus){
        Map<String,String> ans = new Map<String,String>();
    
        List<E_Product__c> products =
            [Select Sku__c,(Select Name From Product_Item_I18Ns__r) From E_Product__c Where Sku__c=:skus];
    
        String translatedName = null;
        for(E_Product__c product : products){
            translatedName = null;
            for(E_ProductItemI18N__c item : product.Product_Item_I18Ns__r){
            translatedName = item.Name;
            }
            ans.put(product.Sku__c,translatedName);
        }
        return ans;
    }
    
    private cc_bean_CartItem assemblyListViewData(
        E_CartItem__c thisCartItem, List<Id> productIdList,
        Map<String, cc_bean_PriceInfo> priceLineMap,
        Map<String,String> translatedMap,
        Map<Id,cc_bean_MediaWrapper> thumbnailMap,
        boolean evenLine) 
        {
            cc_bean_CartItem data = new cc_bean_CartItem();
            data.cartItemType = thisCartItem.cartItemType__c;
            if (thisCartItem.ParentCartItem__r != null) {
                data.parentProductType = thisCartItem.ParentCartItem__r.Product__r.ProductType__c;
        }
        data.product = thisCartItem.product__r;
        data.mockProduct = new cc_bean_MockProduct(thisCartItem.product__r);
        data.quantity = thisCartItem.Quantity__c.IntValue();
        data.SubAmount = thisCartItem.SubAmount__c.setScale(2, System.RoundingMode.UP);
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
        data.translatedProductName = translatedMap.get(thisCartItem.Product__r.SKU__c);
        if (thumbnailMap.get(thisCartItem.product__r.Id) != null) {
            data.mediaWrapper = new cc_bean_MediaWrapper();
            data.mediaWrapper.uri = thumbnailMap.get(
                thisCartItem.product__r.Id
            ).uri;
            data.mediaWrapper.sourceType = thumbnailMap.get(
                thisCartItem.product__r.Id
            ).sourceType;
        }
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
}