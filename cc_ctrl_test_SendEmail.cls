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
private class cc_ctrl_test_SendEmail {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        cc_ctrl_SendEmail email = new cc_ctrl_SendEmail();
        email.subject = 'Subject';
        email.body = 'body';
        email.emailer();
        
        // TODO: Add meaningful assertion
        System.assert(true);
    }
}