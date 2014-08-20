//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_ctrl_ShippingAndHandling { 
	//==================================================
    // CONSTANTS
    //==================================================
    public static final String SHIP_REQUEST_VIEW = 'ShipRequestView';    
    public static final String SHIP_OPTIONS_VIEW = 'ShipOptionsView'; 
    private static final String PAGE_REFERENCE_FULL_URL = '/apex/ShippingEstimates';    
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public String zipCode {get;set;}
    public String stateCode {get;set;}
    public String countryCode {get;set;}
    public String cartId {get;set;}
    public cc_bean_ShippingOptions fedExShipOptions {get;set;}    
    public cc_bean_ShippingOptions upsShipOptions {get;set;}    
    public String viewState  {get; set; }
    
	//==================================================
    // CONSTRUCTOR
    //==================================================
    public cc_ctrl_ShippingAndHandling() {
        //System.debug('-----In cc_ctrl_ShippingAndHandling constructor---');
        //viewState = Apexpages.currentPage().getParameters().get('viewState');
        if(viewState == null) {
           viewState = SHIP_REQUEST_VIEW;
        }
    }
    //==================================================
    // SERVICE METHODS
    //==================================================            
    public PageReference getShippingOptions() {
        cc_bean_ShippingOptionsRequest shipOptionsRequest = new cc_bean_ShippingOptionsRequest(); 
        Long startTime = datetime.now().getTime();      
        if (al.StringUtils.isNotBlank(countryCode) && al.StringUtils.isNotBlank(stateCode) && al.StringUtils.isNotBlank(zipCode) && al.StringUtils.isNotBlank(cartId)) {
            shipOptionsRequest.recepientZipCode = zipCode;
            shipOptionsRequest.recepientStateCode = stateCode;
            shipOptionsRequest.recepientCountryCode = countryCode;
            shipOptionsRequest.cartId = cartId;         
            cc_api_ShippingAndHandling cc_api_ShippingAndHandling = new cc_api_ShippingAndHandling();
            List<cc_bean_ShippingOptions> shipOptionsList = cc_api_ShippingAndHandling.getShippingOptionsForCart(shipOptionsRequest);
            for (cc_bean_ShippingOptions cc_bean_ShippingOptions : shipOptionsList) {
                if (cc_bean_ShippingOptions.shippingProvider.equals(cc_cnst_FedExXMLTag.SHIPPINGPROVIDER)) {
                    fedExShipOptions = cc_bean_ShippingOptions;
                } else if (cc_bean_ShippingOptions.shippingProvider.equals(cc_cnst_UPSXMLTag.SHIPPINGPROVIDER)) {
                    upsShipOptions = cc_bean_ShippingOptions;
                }   
            }       
        } else {
            //System.debug('-----Country/State/Zip/Cart Id is missing-----');         
        }
        PageReference page = new PageReference(PAGE_REFERENCE_FULL_URL);        
        page.getParameters().put('viewState', SHIP_OPTIONS_VIEW);
        viewState = SHIP_OPTIONS_VIEW;      
        Long endTime = datetime.now().getTime();
        Long totalTime = endTime - startTime;  
        //System.debug('-----Time in cc_ctrl_ShippingAndHandling ----- = ' + totalTime + ' ms');        
        return null;
    }
}