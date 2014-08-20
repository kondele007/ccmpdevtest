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
 * An apex page controller that exposes the change password functionality
 */
public class cc_ctrl_ChangePassword extends cc_ctrl_CloudCraze {
	public cc_ctrl_ChangePassword getChangePasswordController() { return this;}
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
	public cc_ctrl_MyAccount myAccountController {get;set;}

    public String messageCss { get; set; }
    public String messageString { get; set; }
    
    public String oldPassword { get; set;}
    public String newPassword { get; set;}
    public String verifyNewPassword { get; set;}
    public String currentCartID { get; set;}
    
    public String returnUrl { get; set; }
    public String userLanguageCode { get; set; }
    
	//==================================================
    // CONSTRUCTORS
    //==================================================
    public cc_ctrl_ChangePassword() {
    	super();
        messageCss = '';
        messageString = '';
        returnUrl = Apexpages.currentPage().getParameters().get('retURL');
        currentCartID = getCartID();
    }

    public cc_ctrl_ChangePassword(cc_ctrl_MyAccount myAccount) {
    	this();
    	myAccountController = myAccount;
    }
    
    //==================================================
    // SERVICE METHODS
    //==================================================
    // Used when user enters temporary password then they forget their password
    public PageReference resetPassword() {
        PageReference page = Site.changePassword(newPassword, verifyNewPassword);
        if (page == null) {
            page = new PageReference('/apex/CCChangePassword?store=' + storefront.Name + '&' + cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY + '=' + ipAddressLocation + '&cartID=' + currentCartID);
            messageCss = 'error-msg';
            if (!isValidPassword()) {
                messageString = 'Passwords don\'t match.';
            } else if (newPassword == null || newPassword == '') {
                messageString = 'Password can\'t be blank.';
            } else if (newPassword.length() < 8) {
                messageString = 'Password must be at least 8 characters long.';
            } else {
                messageString = 'Invalid password. It is either too similar to old passwords or does not contain a mix of alpha and numeric characters';
            }
        } else {
            page = new PageReference('/apex/HomePage?store=' + storefront.Name + '&' + cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY + '=' + ipAddressLocation + '&cartID=' + currentCartID);
        }
        
        return page;
    }
    
    public PageReference changePassword() {
        //System.debug(newPassword+' '+verifyNewPassword+' '+oldPassword);
        PageReference page =  Site.changePassword(newPassword, verifyNewPassword, oldPassword);
        //System.debug('-----cc_ctrl_ChangePassword.changePassword-page : ' + page);
        if (page == null) {
            //System.debug('-----cc_ctrl_ChangePassword.changePassword-Invalid password');
            page = new PageReference('/apex/CCChangePassword?store=' + storefront.Name + '&' + cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY + '=' + ipAddressLocation + '&cartID=' + currentCartID);
        } else {
            //System.debug('-----cc_ctrl_ChangePassword.changePassword-Valid password');
            page = new PageReference('/apex/HomePage?store=' + storefront.Name + '&' + cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY + '=' + ipAddressLocation + '&cartID=' + currentCartID);
        }
        //System.debug('After Password Change');
        //System.debug(page);
        return page;
    }
    
    public PageReference changePasswordForMyAccount(){
		myAccountController.clearPageMessages();
		List<String> errors = myAccountController.errorMessages;

        //System.debug(newPassword + ' ' + verifyNewPassword + ' ' + oldPassword);
		if(oldPassword == null || oldPassword.length() == 0) {
			errors.add('Current Password is required');
		}
        
		if(newPassword == null || newPassword.length() == 0) {
			errors.add('New Password is required');
		}

		if(verifyNewPassword == null || verifyNewPassword.length() == 0) {
			errors.add('Confirm New Password is required');
		}
		
		if(newPassword != verifyNewPassword) {
			errors.add('Confirm New Password must match New Password');
		}

		if(errors.size() == 0) {
			try {
	        	PageReference page = Site.changePassword(newPassword, verifyNewPassword, oldPassword);
	        	if(page == null) {
	        		for(ApexPages.Message message : ApexPages.getMessages()) {
	        			errors.add(message.getDetail());
	        		}
	        	}
			} catch(Exception e) {
				errors.add('Unable to update password: ' + e.getMessage());
			}
		}

		if(errors.size() == 0) {
			myAccountController.successMessages.add('Successfully updated your password');
			myAccountController.viewState = myAccountController.ACCOUNT_INFO_VIEW;
		}

		return null;
    }
    
    //==================================================
    // HELPER METHODS
    //==================================================
    private boolean isValidPassword() {
        return newPassword == verifyNewPassword;
    }
}