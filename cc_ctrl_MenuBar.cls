//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_ctrl_MenuBar {
	
    //==================================================
    // INSTANCE PROPERTIES
    //==================================================
	public cc_ctrl_CloudCraze ccCtrl {get;set;}

    public String menuHtml {
    	get {
    		if(menuHtml == null) {
    			menuHtml = getMenuHtmlFromCache();
    		}
    		return menuHtml;
    	}
    	set;
    }
    
    //==================================================
    // CONSTRUCTOR
    //==================================================
    public cc_ctrl_MenuBar() {}
    
    //==================================================
    // SERVICE METHODS
    //==================================================
    public String getMenuHtmlFromCache() {
    	String menuHtml = cc_api_HtmlCache.getMenuHtml(ccCtrl.storefront.Name, 'en_US');
    	if(menuHtml == null) {
    		menuHtml = '';
    	}
    	return menuHtml;
    }
    
}