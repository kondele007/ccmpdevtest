public with sharing class cc_dao_User {

	public static User getUserProfile(String userId) {
		User u = null;
            
        List<User> us = [select 
                              User_Industry__c
                              , ContactTypeRole__c
                              , FirstName
                              , LastName
                              , Username
                              , Email
                              , Phone
                              , MobilePhone
                              , Department
                              , CompanyName
                              , Title
                              , User_Salutation__c 
                              , CompanyType__c
                              , LanguageLocaleKey
                              , LocaleSidKey
                              , CC_CurrencyCode__c
                              , Contact.firstName
                              , Contact.lastName
                              , Contact.Email
                              , Contact.Phone                              
                              , Contact.MailingStreet
                              , Contact.MailingCity
                              , Contact.MailingState
                              , Contact.MailingPostalCode
                              , Contact.MailingCountry
                              , Contact.OtherStreet
                              , Contact.OtherCity
                              , Contact.OtherState
                              , Contact.OtherPostalCode
                              , Contact.OtherCountry
                              , Contact.AccountId
                              , Contact.CompanyName__c
                         from User where User.ID = :userID];

        if(us.size() == 1) {
        	u = us[0];
        }

		return u;
	}

    public static Id getUserContactId(String userId) {
    	Id contactId = null;
    	List<User> users = [select ContactId from User where Id = :userId];
    	if(users.size() > 0) {
    		contactId = users[0].ContactId;
    	}
    	return contactId;
    }

    public static Contact getUserContact(String userId) {
    	Contact userContact = null;
    	List<User> users = [select
    			Contact.FirstName,
    			Contact.LastName,
    			Contact.CompanyName__c,
    			Contact.Email,
    			Contact.Phone,
    			Contact.MobilePhone,
    			Contact.Account.PreventNewAddrCheckout__c
    			from User where Id = :userId];
    	if(users.size() > 0) {
    		userContact = users[0].Contact;
    	}
    	return userContact;
    }
}