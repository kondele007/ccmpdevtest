public with sharing class cc_ctrl_CheckOut extends cc_ctrl_CloudCraze {

	//==================================================
	// INSTANCE PROPERTIES
	//==================================================
	public E_Cart__c cart {get;set;}
	public cc_bean_Cart cartBean {get;set;}
	public string removedCoupon {get; set;}
	public string removedCouponPriceList{get; set;}

	//==================================================
	// CONSTRUCTORS
	//==================================================
	public cc_ctrl_CheckOut() {
		super();
        System.debug(LoggingLevel.INFO, '************cc_ctrl_CheckOut line 14 viewState = '+ viewState + '*******************');
       //AH this change needs deployed to prd
       removedCoupon = 'false'; 
      //  removedCoupon=Apexpages.currentPage().getParameters().get('couponRemoved');
        String removedCouponCookie = cc_kap_utils_AppUtils.retrieveCookie('removedCouponCookie');
        removedCouponPriceList = cc_kap_utils_AppUtils.retrieveCookie('PriceListCookie');
        if(removedCouponCookie != null) {
           removedCoupon = 'true';
           removedCouponCookie = null; 
        }
     
       
        loadCurrentCart();
        if(!Test.isRunningTest() && cart.TotalQuantity__c==0)
        {
        	throw new cc_excn_CartException('Cart is empty!');
        }  
        if(cart == null) {
            throw new cc_excn_CartException('Cart is null!');
        }

		System.debug('************cc_ctrl_CheckOut line 20 viewState = '+ viewState + '*******************');
	}
	
	//==================================================
	// HELPER METHODS
	//==================================================
	public cc_ctrl_CheckOut getCheckOutController() {
		System.debug('************cc_ctrl_CheckOut line 27 viewState = '+ viewState + '*******************');
		return this;
	}

	public void loadCurrentCart() {
		ccCartId = getCartId();
		cc_api_Cart cApi = new cc_api_Cart();
		cart = cApi.retrieveCart(ccCartId);
		cartBean = new cc_bean_Cart(cart);
		System.debug(LoggingLevel.INFO, '--- cc_ctrl_CheckOut.loadCurrentCart: cartBean=' + cartBean);
	}

 	//==================================================
	// SERVICE METHODS
	//==================================================
 	public PageReference nextStep(String currentStep) {
		System.debug(LoggingLevel.INFO, '--- cc_ctrl_CheckOut.nextStep: currentStep=' + currentStep);

		if(messages.size() > 0) {
			System.debug(LoggingLevel.INFO, '--- cc_ctrl_CheckOut.nextStep: current page has messages=' + messages);
			return null;
		}
		
		if('UserInfo'.equalsIgnoreCase(currentStep)) {
			viewState = 'OrderPaymentReview';
		} else if('PaymentShippingInfo'.equalsIgnoreCase(currentStep)) {
			viewState  = 'OrderReview';
		}
		
		System.debug(LoggingLevel.INFO, '--- cc_ctrl_CheckOut.nextStep: next viewState=' + viewState);
        return System.Page.CheckoutNew;
	}
	
	public PageReference gotoStep(String stepName) {
		viewState = stepName;
		return null;
	}
	
	public PageReference gotoUserInfo() {
		return gotoStep('InfoView');
	}

	public PageReference gotoPaymentView() {
		return gotoStep('OrderPaymentReview');
	}
}