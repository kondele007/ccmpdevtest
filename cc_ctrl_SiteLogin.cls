//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
/**
 * An apex page controller that exposes the site login functionality
 */
public without sharing class cc_ctrl_SiteLogin extends cc_ctrl_CloudCraze {
	public cc_ctrl_SiteLogin getSiteLoginController() { return this;}
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public String username {get; set;}
    public String password {get; set;}
	public String messageCss {get; set; }
	public Boolean message {get; set; }
	public String messageString {get; set; }
	public String startUrl { get; set; }
	public Boolean wasCartAnonymous { get; set; }
	public string vState {get; set;}
	public String currentCartID {get;set;}
	
	//==================================================
    // CONSTRUCTORS
    //==================================================
   	public cc_ctrl_SiteLogin()
   	{
   		super();
		message = false;
		messageCss = '';
   	    messageString = Apexpages.currentPage().getParameters().get('message');
		if(messageString != null && messageString != '')
		{
			if(messageString == 'message_pwd')
			{
				message = true;
				messageCss = 'success-msg';
				messageString = cc_cnst_CloudCraze.PASSWORD_SENT;
			}
			else if(messageString == 'message_login') 
			{
				this.message = true;
				this.messageCss = 'error-msg';
				this.messageString = cc_cnst_CloudCraze.INVALID_USERNAME_PWD;
			}
		}
		
		startUrl = Apexpages.currentPage().getParameters().get('startUrl');
		currentCartID = getCartId();
		
		if(startUrl != null){
			if(currentCartID != '' && currentCartID != null && startUrl.contains('CheckOut')){
				vstate='checkout';
			}
		}	
		
		System.debug('sns - CCSiteLoginConstructor');
		System.debug('sns - viewState: ' + viewState);
		System.debug('sns - currentCartID: ' + currentCartID);
		System.debug('sns - startUrl: ' + startUrl);
	}
    
	//==================================================
    // HELPER METHODS
    //==================================================
	private String determineStartUrl() {		
		wasCartAnonymous = true;

    	if(currentCartID == null || currentCartID == '') {
	    	List<E_Cart__c> lastActiveCart  = cc_dao_Cart.getActiveCartOwnedByUserName(username);
	    	/*
	    	[ select EncryptedID__c 
	    									    from E_Cart__c 
                                                where Owner.Username = :username 
                                                    and ActiveCart__c = true
                                                    and isDeleted = false
                                                limit 1 ];
	    	*/
	    	if (lastActiveCart != null && lastActiveCart.size() > 0) {
	    		currentCartID = lastActiveCart[0].EncryptedID__c;
	    		wasCartAnonymous = false;
	    	}
    	}
    	
    	String startPage = 'HomePage?';
    	
    	if(viewState == 'wishlists') {
    		startPage='{!$Page.MyAccount}?viewstate=wishlists&';
    	}
    	
    	if(viewState == 'checkout') {
    		startPage='{!$Page.CheckOutNew}?viewState=InfoView&';
    	}
    	System.debug('ryl-> startUrl 1' + startPage);    	
    	if(startUrl == null || startUrl == '') {
         	startUrl =  startPage + 'store=' + storefront.Name + '&' + cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY + '=' + ipAddressLocation + '&cartID=' + currentCartID;    		
    	}
    	System.debug('ryl-> startUrl 2' + startUrl); 
		return startUrl;
	}
	
	public void handleLoggedInUser()
	{
		User loggedinUser = [Select id from User where UserName = :username limit 1];

		if(viewState != null && viewState == 'wishlists')
		{
			cc_api_Cart cc_api_Cart = new cc_api_Cart();
			cc_api_Cart.addToWishList(currentProductID, 1, loggedinUser.id);
		}

		if(currentCartID != null && currentCartID != '' && wasCartAnonymous)
		{
			List<E_Cart__c> updateCart = new List<E_Cart__c>();
			E_Cart__c anonCart = cc_dao_Cart.retrieveCartHeader(currentCartID);
			if(anonCart != null)
			{
				System.debug(LoggingLevel.INFO, '--- cc_ctrl_SiteLogin.handleLoggedInUser: reassigning cart account: anonCart=' + anonCart);
				anonCart.ActiveCart__c = true;
				anonCart.OwnerId = loggedinUser.Id;
				anonCart.User__c = loggedinUser.Id;
				anonCart.AnonymousID__c = false;
				anonCart.Account__c = cc_util_CloudCraze.getAccountID(loggedinUser);
				updateCart.add(anonCart);	
			}
  	
			List<E_Cart__c> deactiveOldCart = cc_dao_Cart.getActiveCartOwnedBy(loggedinUser.Id);
			/*
			[Select EncryptedID__c, ActiveCart__c  from E_Cart__c where OwnerId = :loggedinUser.Id];
			*/
			if(deactiveOldCart != null && deactiveOldCart.size() > 0) {
				for(E_Cart__c thisCart : deactiveOldCart) {
					
					if(thisCart.EncryptedID__c != currentCartID) {
						thisCart.ActiveCart__c = false;
						updateCart.add(thisCart);
					}			
				}
			}
			update updateCart;	
		}
	}
	//==================================================
    // SERVICE METHODS
    //==================================================
    public PageReference login()
    {
        startUrl = determineStartUrl();
        System.debug('sns -- startUrl: ' + startUrl);

        PageReference loginPage = Site.login(username, password, startUrl);
		
        if(loginPage == null)
        {
        	System.debug('sns - loginPage is null in cc_ctrl_SiteLogin.login()');
        	
            this.message = true;
	        this.messageCss = 'error-msg';
	        this.messageString = cc_cnst_CloudCraze.INVALID_USERNAME_PWD;
            loginPage = new PageReference('/apex/CCSiteLogin?store=' + storefront.Name + '&' + cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY + '=' + ipAddressLocation + '&cartID=' + currentCartID);
            //loginPage.getParameters().put('message', String.valueOf('message_login'));
            //loginPage.setRedirect(true);
        }
        else
        {
			this.handleLoggedInUser();
		}
        return loginPage;
    }
    
    public PageReference siteRegister()
    {
		PageReference pageRef = new PageReference('/apex/CCSiteRegister?store=' + storefront.Name + '&' + cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY + '=' + ipAddressLocation + '&cartID=' + currentCartID+'&viewState='+vState+'&productID='+currentProductID);
    	return pageRef;
    }    
   
	public PageReference forwardIfLoggedIn() {
		PageReference page = null;
		System.debug('--- cc_ctrl_SiteLogin.forwardIfLoggedIn: storefront.Allow_Anonymous_Browsing__c=' + storefront.Allow_Anonymous_Browsing__c + ', cc_util_CloudCraze.isGuest=' + cc_util_CloudCraze.isGuest());
		if(!storefront.Allow_Anonymous_Browsing__c && !cc_util_CloudCraze.isGuest()) {
			page = new PageReference('/apex/HomePage');
        	page.getParameters().put('cartID', currentCartID);
        	page.setRedirect(true);
		}
		return page;
	}
}