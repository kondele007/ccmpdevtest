//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_api_User {
	//==================================================
    // STATIC VARIABLE
    //==================================================
	//currUser is a singleton, it is shared in current request.
    private static User currUser = null; 
    //==================================================
    // STATIC PROPERTY
    //==================================================
    public static User getCurrentUser {
        get {
        	if(currUser != null)
        	{
        		return currUser;
        	}
			String userId = UserInfo.getUserId();
			if(userId != null && !userId.equals('')) {
            	currUser = [
            	  SELECT 
            	    u.Title, u.user_salutation__c,u.ID, u.CC_CurrencyCode__c, u.ContactId, 
            	    u.FirstName, u.LastName, u.Phone, u.MobilePhone, u.Email, u.CompanyName,
            	    u.Tax_Exempt__c, u.Street, u.City, u.State, u.PostalCode, u.Country, 
            	    u.UserType, u.Contact.Account.Name, u.Contact.Phone, 
        	    u.Contact.Account.PreventNewAddrCheckout__c, u.Contact.Account.PreventAddrBookSave__c
            	  FROM User u where u.id = :userId];
			}
           	return currUser;
        }
    }

	 public static User getUserById(String userId) {
       User u = null;
		if(userId != null && !userId.equals('')) {
        	u = [
        	  SELECT 
        	    u.Title, u.user_salutation__c,u.ID, u.CC_CurrencyCode__c, u.ContactId, 
        	    u.FirstName, u.LastName, u.Phone, u.MobilePhone, u.Email, u.CompanyName,
        	    u.Tax_Exempt__c, u.Street, u.City, u.State, u.PostalCode, u.Country, 
        	    u.UserType, u.Contact.Account.Name, u.Contact.Phone, 
        	    u.Contact.Account.PreventNewAddrCheckout__c, u.Contact.Account.PreventAddrBookSave__c
        	  FROM User u where u.id = :userId];
		}
       	return u;
        
    }
    
    public static User getCurrentUserProfile() {
    	return cc_api_User.getUserProfile(UserInfo.getUserId());
    }
    
    public static User getUserProfile(String userId) {
    	return cc_dao_User.getUserProfile(userId);
    }
    
    public static Id getCurrentUserContactId() {
    	return cc_api_User.getUserContactId(UserInfo.getUserId());
    }
    
    public static Id getUserContactId(String userId) {
    	return cc_dao_User.getUserContactId(userId);
    }
    
    public static Contact getCurrentUserContact() {
    	return cc_api_User.getUserContact(UserInfo.getUserId());
    }
    
    public static Contact getUserContact(String userId) {
    	return cc_dao_User.getUserContact(userId);
    }

    //==================================================
    // STATIC SERVICE METHODS
    //==================================================
    public static void saveUser(ID currentUserID, String firstName, String lastName, String homePhone, String workPhone) {
    	
		if(currentUserID != null) {
        	currUser = [Select u.ContactId, u.FirstName, u.LastName, u.Phone, u.MobilePhone, u.Email from User u where u.id = :currentUserID];
        	currUser.FirstName = firstName;
        	currUser.LastName = lastName;
        	currUser.MobilePhone=homePhone;
        	currUser.Phone=workPhone;
        	//user.Email=emailAddress;        	
        	//System.debug('>>>>>>>>>>>>>FirstName: ' + firstName );
        	//System.debug('>>>>>>>>>>>>>LastName: ' + lastName );
        	update currUser;
		}
    }
    
    public static User getUserByEmail(String email){
      if(!al.StringUtils.isEmpty(email)){
        List<User> users = [Select Id from User where email=:email LIMIT 1];
        if(users != null && !users.isEmpty()){
        	return users.get(0);
        }
      }
      return null;
    }
}