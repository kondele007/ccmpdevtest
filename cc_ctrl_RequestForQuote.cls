public with sharing class cc_ctrl_RequestForQuote {

    //==================================================
    // PROPERTIES
    //==================================================
    public cc_ctrl_CloudCraze cloudCrazeController {get;set;}
    public cc_bean_RequestForQuote rfq {get;set;}
    public Boolean isGuest {get;set;}

    //==================================================
    // CONSTRUCTORS
    //==================================================
    public cc_ctrl_RequestForQuote() {
    	isGuest = cc_util_CloudCraze.isGuest();

    	if(isGuest) {
	    	rfq = cc_api_RequestForQuote.initRequestForQuoteForUser();
    	} else {
	    	rfq = cc_api_RequestForQuote.initRequestForQuoteForUser(UserInfo.getUserId());
    	}
    }

    //==================================================
    // METHODS
    //==================================================
    public PageReference saveRequestForQuote() {
    	E_StorefrontSettings__c storefront = cloudCrazeController.storefront;

    	// populate common fields
    	rfq.leadSource = 'Web';

    	if(cloudCrazeController.ccCartId != null) {
    		cc_api_Cart capi = new cc_api_Cart();
    		E_Cart__c cart = capi.retrieveCartHeader(cloudCrazeController.ccCartId);
    		rfq.cartId = cart.Id;
    		rfq.cart = cart;
    		rfq.amount = cart.SubtotalAmount_2__c;
    	}
    	
    	if(isGuest) {
    		// populate lead-only fields
    		rfq.leadStatus = 'Open - Not Contacted';
    		rfq.website = Site.getCurrentSiteUrl();
    	} else {
    		// populate opportunity-only fields
			rfq.opportunityName = 'CloudCraze ' + storefront.name + ' RFQ for ' + rfq.firstName + ' ' + rfq.lastName;
    		rfq.closeDate = System.today() + 30;
    		rfq.stage = 'Prospecting';
    	}
    	
    	try {
    		System.debug(LoggingLevel.ERROR, '--- cc_ctrl_RequestForQuote.saveRequestForQuote: inserting rfq=' + rfq);
			insert rfq.dataObject;
    	} catch(DmlException e) {
    		System.debug(LoggingLevel.ERROR, '--- cc_ctrl_RequestForQuote.saveRequestForQuote: unable to save rfq: ' + e.getMessage());
    	}
    	
    	return null;
    }
}