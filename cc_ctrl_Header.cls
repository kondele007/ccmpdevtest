//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without
//  modification is PROHIBITED.
//
//
public with sharing class cc_ctrl_Header  {
	private cc_ctrl_CloudCraze vParentController = null;
	public cc_ctrl_CloudCraze ccCtrl { 	
		get {return vParentController;} 
		set {
				vParentController = value;
		}
	}
	public map<string, string> widgetConfiguration { get { return vParentController.widgetConfiguration; } private set; }
	public string CurrentCartID { get{ return vParentController.getCartId(); } private set; } 
	public string CurrentProductID { get{ return vParentController.CurrentProductID; } set { vParentController.CurrentProductID=value;}} 
	public string ipAddressLocation {get {return vParentController.ipAddressLocation;} set { vParentController.ipAddressLocation = value;} } 
	public string ipAddressLocationKey {get {return cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY;} set;}  
	public String viewState { get{ return vParentController.viewState; } set { vParentController.viewState=value;}} 
	
	public String storeID {
    	get {
    		return vParentController.storeID;
    	}
    }
    
    public cc_api_PageConfiguration pageConfigAPI = cc_api_PageConfiguration.getInstance();
	public string searchString {get; set; }

	//==================================================
    // CONSTRUCTOR
    //==================================================
	public cc_ctrl_Header() {
		
	}

	public PageReference quickSearch()  {
		PageReference page=System.Page.Products;
		page.getParameters().put('cartID', currentCartID);
		page.getParameters().put('operation', 'quickSearch');
		page.getParameters().put('searchText',searchString);
		page.getParameters().put(ipAddressLocationKey, ipAddressLocation);
		page.setRedirect(true);
        //System.debug('--- forwarding to page: ' + page.getUrl());
        //set cookie
        //setProductListViewCookie();
		return page;
	}

	public PageReference editCart() {
        //System.debug(' >>> Inside EditCart viewState = ' + viewState);
        //System.debug(' >>> Inside EditCart currentCartID = ' + currentCartID);
        PageReference page = System.Page.Cart;
        page.getParameters().put('cartID', currentCartID);
        page.getParameters().put('productID', currentProductID);
        page.getParameters().put('viewState',viewState);
        page.getParameters().put('store', storeID);
        page.getParameters().put(ipAddressLocationKey, ipAddressLocation);
        page.setRedirect(true);

        return page;
    }

	public String currentTheme {
		get {
			if(currentTheme == null) {
				currentTheme = pageConfigAPI.getPageConfigurationValue(vParentController.storefront.Name + '.theme');
			}
			System.debug('--- cc_ctrl_StorefrontTemplate.getCurrentTheme: returning currentTheme=' + currentTheme);
			return currentTheme;
		}
		set;
	}
 	
	public String themeResourcePath {
		get {
			if(themeResourcePath == null) {
				themeResourcePath = cc_util_UserInterface.getStaticResource(currentTheme);
			}
			System.debug('--- cc_ctrl_StorefrontTemplate.themeResourcePath: returning themeResourcePath=' + themeResourcePath);
			return themeResourcePath;
		}
		set;
	}
	
 	public String getStorefrontHeaderLogo() {
 		//String defaultName = widgetConfiguration.get('H.Logo');//storefront.Name + '.HomePage.H.Logo';
 		//String thisName = cc_util_CloudCraze.getCurrentPageName() + '.H.Logo';
 		//String logoUrl = pageConfigAPI.getPageConfigurationValue(thisName, defaultName);
 		String logoUrl = widgetConfiguration.get('H.Logo'.toLowerCase());
		
 		if(logoUrl != null) {
 			logoUrl = themeResourcePath + '/' + logoUrl;
 		} else {
 			logoUrl = 'NotAvailable';
 		}
		System.debug('--- cc_ctrl_StorefrontTemplate.getStorefrontHeaderLogo: returning logoUrl=' + logoUrl);
    	return logoUrl; 		
 	}    

 	public String getStorefrontHeaderTagLine() {
 		//String defaultName = storefront.Name + '.HomePage.H.TagLine';
 		//String thisName = cc_util_CloudCraze.getCurrentPageName() + '.H.Tagline';
 		//String logoUrl = pageConfigAPI.getPageConfigurationValue(thisName, defaultName);
 		String taglineUrl = widgetConfiguration.get('H.Tagline'.toLowerCase());
 		if(taglineUrl != null) {
 			taglineUrl = themeResourcePath + '/' + taglineUrl;
 		} else {
 			taglineUrl = 'NotAvailable';
 		}
		System.debug('--- cc_ctrl_StorefrontTemplate.getStorefrontHeaderTagLine: returning logoUrl=' + taglineUrl);
    	return taglineUrl; 		
 	}
 	/*
 	public String getStorefrontHeaderLogo() {
 		String logoUrl = pageConfigAPI.getPageConfigurationValue(storefront.Name + '.HomePage.H.Logo');
 		if(logoUrl != null) {
 			logoUrl = themeResourcePath + '/' + logoUrl;
 		} else {
 			logoUrl = 'NotAvailable';
 		}
		System.debug('--- cc_ctrl_StorefrontTemplate.getStorefrontHeaderLogo: returning logoUrl=' + logoUrl);
    	return logoUrl; 		
 	}
 	*/   

}