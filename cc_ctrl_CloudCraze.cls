//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
 
public with sharing virtual class cc_ctrl_CloudCraze {
	public String omnitureId { get; set; }
	
	public static boolean logSetting = (E_ApplicationSettings__c.getValues('CloudCraze') != null) ? 
		E_ApplicationSettings__c.getValues('CloudCraze').ShowPageLog__c : false;
	public string getCCDebugLog() {
		return cc_util_logging.getDebugLog();
	}
	private map<string, cc_ExtensionBase> childExtensions = new map<string, cc_ExtensionBase>();
	public cc_ExtensionBase addExtension(String name, cc_ExtensionBase ext) {
		childExtensions.put(name, ext);
		return ext;
	}
	public cc_ExtensionBase getExtension(string name) {
		return childExtensions.get(name);
	}
	public cc_ExtensionBase removeExtension(string name) {
		if(childExtensions.containsKey(name)) {
			return childExtensions.remove(name);
		} else {
			return null;
		}
	}
	public virtual void notifyChildren() {
		Set<String> keys = childExtensions.keyset();
		for(String key: keys) {
			if(childExtensions.containsKey(key)) {
				childExtensions.get(key).notify(this);
			}
		}
	}
	
	public virtual void notifyChildren(String notificationType, Object notificationValue) {
		System.debug(LoggingLevel.INFO, 'notifyChildren : type = ' + notificationType + ' value=' +  notificationValue);
		Set<String> keys = childExtensions.keyset();
		for(String key: keys) {
			System.debug(LoggingLevel.INFO, 'notifyChildren : extension = ' + key );
			childExtensions.get(key).notify(this, notificationType, notificationValue);
		}
	}
	
	public virtual List<Object> queryChildren(String query) {
		List<Object> ret = new List<Object>();
		Set<String> keys = childExtensions.keyset();
		System.debug(LoggingLevel.INFO, 'childExtensions : keyset = ' + keys);
		for(String key: keys) {
			if(childExtensions.containsKey(key)) {
				Object qResult = childExtensions.get(key).query(this, query);
				if(qResult != null)
				{
					ret.add(qResult);
				}
			}
		}
		return ret;
	}
	public cc_ctrl_CloudCraze getCloudCrazeController() {System.debug('************cc_ctrl_CloudCraze line 66 viewState = '+ viewState + '*******************'); return this; }
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
    /**
    Have to add this for Kaplan since site footer his hard coded into the Checkout Template
    */
    public Boolean printViewEnabled{get; set;}
    /**
    End Kaplan
    */
    public E_StorefrontSettings__c storefront {get; private set;}
    public String PageTitle {get; private set;}
    public String metaKeywords{get; private set;}
    public String metaDescription {get; private set;}
    public String store {get;set;}
    public String ccCartId {get; set; } 
    public String viewState {get; set; }
    public string currentProductID {get; set;} //move to cc_extn_ProductCatalog
	public string ipAddressLocation {get; set;} 
	public string ipAddressLocationKey {get {return cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY;} set;} 
    public Boolean getIPAddressSafe() {return cc_util_CloudCraze.isIPAddressSafe(store, ipAddressLocation); }
    public String pageName { get; set; }
    public map<string, string> widgetConfiguration { get; set; }
    private map<string, list<string>> googleAnalyticsAttributes = new map<string, list<string>>();
    public virtual map<string, list<string>> getGoogleAnalyticsAttributes() {
    	if(googleAnalyticsAttributes.size() == 0) {
    		googleAnalyticsAttributes.put('_setAccount', new list<string> {googleAnalyticsAcountIdAndPropIndex});
    		string trackPage = '/'+pageName;
    		if(viewState != null){
    			trackPage += '/' + viewState;
    		}
    		googleAnalyticsAttributes.put('_trackPageview', new list<string> {trackPage});
    	}
    	return googleAnalyticsAttributes;	
    }
    public String blankPage {get { return 'cc_store_Blank'; }} // including in page forces top level controller to be constructed first in the request chain
	
    public String googleAnalyticsAcountIdAndPropIndex { //common
        get {
            return storefront.Google_Analytics_Account__c;
        } set; }
    public List<String> messages { get; set; }
    public String userLocale {
    	get {
    		if(userLocale == null) {
    			userLocale = cc_util_Locale.getUserLanguage();
    		}
    		return userLocale;
        }
        set;
    } 
    
    public void removeCurrentCart() {
    	Cookie cartIdCookie = new Cookie('currentCartId',null,null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{cartIdCookie});
        CCCartId = null;
    }
    
    public String getCartId() {
		//System.debug('getCartId 1-->' + ccCartId);
		if(ccCartId == null || ccCartId.trim().length() == 0) {
			ccCartId=Apexpages.currentPage().getParameters().get('cartID');
			if(ccCartId == null || ccCartId.trim().length() == 0) {
				//if current user is not a guest(anonymous) user, retrieve current user's last active cart as current cart
				if(!cc_util_CloudCraze.isGuest()) {
					cc_api_cart api = new cc_api_cart();
					E_Cart__c c = api.getActiveCartOwnedBy(UserInfo.getUserId());
					if(c != null) {
						ccCartId = c.EncryptedId__c;
					}
				}
			}
		}
		return ccCartId;
	}
	
    //move to cc-extn_cart
	public Integer getCCCartItemCount()
    {
        cc_api_Cart api = new cc_api_Cart();
        Integer cicount = api.getCartItemCount(ccCartId);
              
        return cicount;
    } 
    
    //move to cc-extn_cart
    public String getCCCartTotal() {
        String cTotal = '0.00';
        cc_api_Cart api = new cc_api_Cart();
        Decimal total = api.getCartTotal(ccCartId);            
        if(total > 0)
        {
            return String.valueOf(total);
        }
        else
        {
            return cTotal; 
        }
    }   
    // storeID is deprecated, reference storefront.Name instead
    public String storeID {
    	get {
    		return storefront != null ? storefront.Name : null;
    	}
    }
    
    public String storeSSLUrl {
    	get {
    		return storefront !=null ?
    		   'https://' + storefront.Site_Secure_Domain__c + '/' + store + '/' :
    		   null;
    	}
    }
    
    public String currentSiteUrl {
    	get {
    		String siteUrl = Site.getCurrentSiteUrl();
    		//System.debug('--- cc_ctrl_CloudCraze.currentSiteUrl: returning siteUrl=' + siteUrl);
    		if(siteUrl != null) {
	    		siteUrl = siteUrl.substring(0, siteUrl.length() - 1);
    		}
    		return siteUrl;
    	}
    }
    //==================================================
    // CONSTRUCTOR
    //==================================================
    public cc_ctrl_CloudCraze() {
    	widgetConfiguration = new map<string, string>();
    	googleAnalyticsAttributes = new map<string, list<string>>();
    	store = ApexPages.currentPage().getParameters().get('store');
    	
    	ccCartId = getCartId();
    	if(store == null) {
    		store = Site.getPrefix();
    	}

    	if(store == null) {
    		store = cc_util_CloudCraze.application.Default_Storefront__c;
    	}

    	storefront = cc_util_CloudCraze.getStorefrontSettings(store);

        PageTitle = storefront.SEO_Title_Site__c + '  |  ' + storefront.SEO_Title_Detail__c;
        metaKeywords = storefront.SEO_Keywords__c;
        metaDescription = storefront.SEO_Description__c;
        messages= new List<String> ();
        viewState=Apexpages.currentPage().getParameters().get('viewState');
        ipAddressLocation = Apexpages.currentPage().getParameters().get(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY);
        pageName = cc_util_CloudCraze.getCurrentPageName();
        String uiKey = cc_api_PageUIKey.getUIKeyForPage(pageName);
        widgetConfiguration = buildWidgetConfiguration(store, uiKey);
    	/**
    	Kaplan
    	*/
    	String sPrintView = Apexpages.currentPage().getParameters().get('printView');
    	if(sPrintView != null && sPrintView == 'true')
    		printViewEnabled = true;
    	else
    		printViewEnabled = false;
    	//init omniture id 
    	if(!Test.isRunningTest())
    		omnitureId = Kaplan_Custom_Config__c.getValues('Kaplan Custom Config').OmnitureId__c;
    }
    
    public Component.Apex.OutputPanel getPageLog() {
        Component.Apex.OutputPanel dynOutPanel= new Component.Apex.OutputPanel(layout='none');
        if(cc_ctrl_CloudCraze.logSetting) {
        	Component.Apex.messages msgs = new Component.Apex.messages();
        	dynOutPanel.childComponents.add(msgs);
        }
        return dynOutPanel;
    }
    
    public map<string, string> buildWidgetConfiguration(string store, string pageName) {
    	map<string, string> wdgtMap = new map<string, string>();
    	cc_api_PageConfiguration instance = cc_api_PageConfiguration.getInstance();
    	wdgtMap = instance.getAttributeMap(store, pageName);
    	return wdgtMap;
    }
    
}