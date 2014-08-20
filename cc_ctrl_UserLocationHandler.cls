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
 * This controller class calls the business layer to handle the user's location request.
 * 
 */ 
public with sharing class cc_ctrl_UserLocationHandler extends cc_ctrl_CloudCraze {
    //==================================================
    // INSTANCE PROPERTIES
    //==================================================
	public String countryCode {get; set;}
    public String categoryId {get; set;}
    public String sku {get; set;}
    private boolean isSite {get; set;}
    private String baseURL {get; set;}
	public String googlePathAndKey { 
        get {
            if (isSite) {
                googlePathAndKey = GOOGLE_URLANDPATH + storefront.Google_Maps_API_Key_External__c;              
            } else {
                googlePathAndKey = GOOGLE_URLANDPATH + storefront.Google_Maps_API_Key_Internal__c;              
            }
            //System.debug('-----googlePathAndKey----- : ' + googlePathAndKey);           
            return googlePathAndKey;
        } set; }    

	
	//==================================================
    // CONSTANTS
    //==================================================
	private static final String CATEGORY_ID = 'categoryId'; 
    private static final String PRODUCT_LIST_PAGE = 'Products';    
    private static final String SKU_KEY = 'sku';    
    private static final String PRODUCT_DETAILS_PAGE = 'ProductDetails';    
    private static final String ACCESS_ALLOWED_PAGE = 'HomePage';
    private static final String ACCESS_NOT_ALLOWED_PAGE = 'AccessRestricted';   
    private static final String IP_ADDRESS_LOCATION = cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY;
    private static final String GOOGLE_URLANDPATH = 'https://www.google.com/jsapi?key=';
     
    //==================================================
    // CONSTRUCTOR
    //==================================================
    public cc_ctrl_UserLocationHandler(){
        categoryId=Apexpages.currentPage().getParameters().get('categoryId');
        sku=Apexpages.currentPage().getParameters().get('sku');     
        //System.debug('-----cc_ctrl_UserLocationHandler.categoryId = ' + categoryId);      
        //System.debug('-----cc_ctrl_UserLocationHandler.sku = ' + sku);        
        
        String domain = Site.getDomain();
        isSite = storefront.Site_Unsecure_Domain__c.equalsIgnoreCase(domain) || storefront.Site_Secure_Domain__c.equalsIgnoreCase(domain);
        
        if(isSite) {
            //System.debug(' Site.getPrefix() ' + Site.getPrefix());
            //System.debug(' storefront.Site_Secure_Domain__c ' + storefront.Site_Secure_Domain__c);
            
            if(Site.getPrefix()==null){
              baseURL = 'https://' + storefront.Site_Secure_Domain__c + '/';   
            }
            else{
              baseURL = 'https://' + storefront.Site_Secure_Domain__c + Site.getPrefix() + '/';
            }
            
        } else {
            baseURL = storefront.SF_Server_URL__c + '/apex/';
        }
        //System.debug('-----baseURL----- : ' + baseURL);
    }
            
    
    //==================================================
    // SERVICE METHODS
    //==================================================
    /**
     * This method handles the redirection, based on user's location.
     */ 
    public PageReference locationHandler() {
        //System.debug('-----cc_ctrl_UserLocationHandler.countryCode = ' + countryCode);
        boolean isUserLocationRestricted = false;
        PageReference page = new PageReference(baseURL + ACCESS_ALLOWED_PAGE);
        try {
            if (al.StringUtils.isNotBlank(categoryId)) {
                page = new PageReference(baseURL + PRODUCT_LIST_PAGE);
                page.getParameters().put(CATEGORY_ID, categoryId);              
            }
            if (al.StringUtils.isNotBlank(sku)) {
                page = new PageReference(baseURL + PRODUCT_DETAILS_PAGE);
                page.getParameters().put(SKU_KEY, sku);                 
            }          
            if (al.StringUtils.isNotBlank(countryCode)) {
                cc_api_UserLocationHandler cc_api_UserLocationHandler = new cc_api_UserLocationHandler();
                isUserLocationRestricted = cc_api_UserLocationHandler.isUserLocationRestricted(countryCode);
                if (isUserLocationRestricted) {
                    page = new PageReference(baseURL + ACCESS_NOT_ALLOWED_PAGE);
                } else {
                    page.getParameters().put(IP_ADDRESS_LOCATION, cc_util_CustomSettings.encodeCountryCode(countryCode));              
                }
            } else {
                page.getParameters().put(IP_ADDRESS_LOCATION, '');
            }

            //System.debug('-----cc_ctrl_UserLocationHandler.page = ' + page);
            page.setRedirect(true);
        } catch (System.Exception e) {
            //System.debug('ERROR: '+ e);
        }
        return page;
    }
    
    
}