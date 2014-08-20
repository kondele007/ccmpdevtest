//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_util_Email {
	//==================================================
     // SERVICE METHODS
     //================================================== 
	public static void sendTextEmail(List<String> recipients,String emailSubject,String textBody) { 
	    // Create a new single email message object
	    // that will send out a single email to the addresses in the To, CC & BCC list.
	    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();	    
	    //the email is not saved as an activity.
	    mail.setSaveAsActivity(false);
	    // Assign the addresses for the To lists to the mail object.
	    mail.setToAddresses(recipients);	      
	    // Specify the subject line for your email address.
	    mail.setSubject(emailSubject);
	    // Set to True if you want to BCC yourself on the email.
	    mail.setBccSender(false);
	    // The email address of the user executing the Apex Code will be used.
	    mail.setUseSignature(false);
	    // Specify the text content of the email.
	    mail.setPlainTextBody(textBody);
	    // Send the email you have created.
	    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}
	
	public static void sendHTMLEmail(List<String> recipients,String emailSubject,String htmlBody) { 
	    // Create a new single email message object
	    // that will send out a single email to the addresses in the To, CC & BCC list.
	    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();	    
	    //the email is not saved as an activity.
	    mail.setSaveAsActivity(false);
	    // Assign the addresses for the To lists to the mail object.
	    mail.setToAddresses(recipients);	      
	    // Specify the subject line for your email address.
	    mail.setSubject(emailSubject);
	    // Set to True if you want to BCC yourself on the email.
	    mail.setBccSender(false);
	    // The email address of the user executing the Apex Code will be used.
	    mail.setUseSignature(false);
	    // Specify the html content of the email.
	    mail.setHtmlBody(htmlBody);
	    // Send the email you have created.
	    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	}

    /**
     * null     => false
     * ''       => false
     * ' '      => false
     * 'x'      => false
     * 'x@'     => false
     * 'x@x'    => true
     */
    public static Boolean isValidEmailAddress(String str){
        if(str != null && str.trim() != null && str.trim().length() > 0){
            final String[] split = str.split('@');
            if(split != null && split.size() == 2){
                return true;
            }
        }
        return false;
    }

    public static Boolean isNotValidEmailAddress(String str){
        return !isValidEmailAddress(str);
    }
}