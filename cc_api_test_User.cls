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
private class cc_api_test_User {

    static testMethod void myUnitTest() {
        cc_api_User.saveUser(UserInfo.getUserId(),  'firstName', 'lastName', 'homePhone', 'workPhone');
        
        // TODO: implement unit test
        System.assert(true);
        
    }
}