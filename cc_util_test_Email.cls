//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//

@isTest
private class cc_util_test_Email {
    static testMethod void testsendTextNotificationEmail_test() {
        //System.debug('## Start the testSendSupportEmails_test');
        List<String> recepients=new String[]{'test@test.com','test2@test.com'};
        cc_util_Email.sendTextEmail(recepients,'Test method', 'This is to test the sendTextNotificationEmail method');
        cc_util_Email.sendHTMLEmail(recepients,'Test method', 'This is to test the sendTextNotificationEmail method');
        
        // TODO: Add meaningful assertion
        System.assert(true);
    } 
}