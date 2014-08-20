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
 * An apex page controller that exposes the site forgot password functionality
 */
public with sharing class cc_ctrl_ForgotPassword extends cc_ctrl_CloudCraze {
	public cc_ctrl_ForgotPassword getForgotPasswordController() { return this;}
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public String username {get; set;}
    public String password {get;set;}
	public String currentCartID {get; set;}     
    public String ipAddressLocation{get; set; } 
        
	public String ipAddressLocationKey { 
		get {
			return cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY;
		} set; }
		
    public Boolean error {get; set; }
    
    //==================================================
    // CONSTRUCTOR
    //==================================================   
    public cc_ctrl_ForgotPassword() {
    	super();
		ipAddressLocation = Apexpages.currentPage().getParameters().get(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY);       
   		currentCartID=Apexpages.currentPage().getParameters().get('cartID');
    	error = false;
    }
	
	//==================================================
    // SERVICE METHODS
    //==================================================
  	public PageReference forgotPassword() {
  		boolean success = Site.forgotPassword(username);
  		PageReference pr = new PageReference('/apex/CCSiteLogin?store=' + storefront.Name + '&' + cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY + '=' + ipAddressLocation + '&cartID=' + currentCartID);
  		//System.debug('-----cc_ctrl_ForgotPassword.forgotPassword-success : ' + success);
  		if (success) { 
  			return gotoLoginPage(pr);
	  		
  		}else{
  			error = true;
  			pr = new PageReference('/apex/CCForgotPassword?store=' + storefront.Name + '&' + cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY + '=' + ipAddressLocation + '&cartID=' + currentCartID);
			//System.debug('-----cc_ctrl_ForgotPassword.forgotPassword-pr : ' + pr);  			
  			return pr;
  		}
  		
  	}

  	public PageReference gotoLoginPage(PageReference pr){
  			pr.getParameters().put('message', String.valueOf('message_pwd'));
	  		pr.setRedirect(true); 			
  			return pr;
  	}
}