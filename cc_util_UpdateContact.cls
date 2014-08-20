//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_util_UpdateContact {

//@future
public static void updateContacts(List <Id> updatedUsers )
{
    List<Contact> contactsToUpdate = new List<Contact>();
    Map <Id,User> users = new Map <Id,User> ([Select 
                                                    u.Username, 
                                                    u.Title, 
                                                    u.State,
                                                    u.Street, 
                                                    u.PostalCode, 
                                                    u.MobilePhone,
                                                    u.Phone, 
                                                    u.LastName, 
                                                    u.FirstName, 
                                                    u.Fax, 
                                                    u.Email, 
                                                    u.Department, 
                                                    u.Country, 
                                                    u.ContactId,
                                                    u.CompanyName, 
                                                    u.City,
                                                    u.IsPortalEnabled,
                                                    u.IsPortalSelfRegistered,
                                                    u.CompanyType__c
                                                   
                                            From User u
                                            Where Id in :updatedUsers
                                                    ]);
    
                                                    
    List<Id> contactIds = new List<Id>();
    for(Id userId: users.KeySet()){
        Id con = users.get(userId).ContactId;
        //System.debug('Contact ID on User >>>>>>>' + con);
        contactIds.add(con);
    }
    
    if(contactIds.size()==0)
          return;
    
    Map <Id,Contact> contacts = new Map <Id,Contact> ([Select c.Title,                          
                                c.Salutation,  
                                c.MobilePhone,                     
                                c.Phone,                            
                                c.OtherStreet,                  
                                c.OtherState,                       
                                c.OtherPostalCode,              
                                c.OtherPhone,                       
                                c.OtherCountry,                
                                c.OtherCity,
                                c.HasOptedOutOfEmail,                    
                                c.MailingStreet,                    
                                c.MailingState,                 
                                c.MailingPostalCode,                    
                                c.MailingCountry,                   
                                c.MailingCity,                      
                                c.LastName,                             
                                c.FirstName,                        
                                c.Fax,                              
                                c.Email,                            
                                c.Department,
                                c.CompanyName__c
                            From Contact c
                            where Id in :contactIds]);
                            
                            
    for (Id userId : users.KeySet()) {
        User u = users.get(userId);
            Contact c = contacts.get(u.ContactId);
            if(c==null)
              return;
            
            c.Title = u.Title;
            c.Phone = (u.Phone!=null) ? u.Phone : u.MobilePhone;
            c.MobilePhone = u.MobilePhone;
            c.MailingStreet = u.Street;
            c.MailingState = u.State;
            c.MailingPostalCode = u.PostalCode;
            c.MailingCountry = u.Country;
            c.MailingCity = u.City;
            c.LastName = u.LastName;
            c.FirstName = u.FirstName;
            c.Fax = u.Fax; 
            c.Email = u.Email; 
            c.Department = u.Department;
            
            //System.debug(LoggingLevel.INFO,'-------u.IsPortalEnabled------ ' + u.IsPortalEnabled); 
            //Used for firing off workflow when a Contact changes to Portal user
            c.IsPortalUser__c = u.IsPortalEnabled;
            c.SelfRegistered__c = u.IsPortalSelfRegistered;
            c.CompanyType__c = u.CompanyType__c;
            c.CompanyName__c = u.CompanyName;
           
            contactsToUpdate.add(c);
        }
        try
        {
         update contactsToUpdate;
        } catch(Exception e) {
        	//should log this error
        }
}

}