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
private class cc_ctrl_test_Banner {

    static testMethod void toggleCounterTest() {
        cc_ctrl_Banner c = new cc_ctrl_Banner();
        c.count = 0;
        c.toggleCounter();
        System.assertEquals(c.count, 1);
    }
}