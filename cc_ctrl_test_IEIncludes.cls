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
private class cc_ctrl_test_IEIncludes {

    static testMethod void testIEIncludes() {
        cc_ctrl_IEIncludes controller = new cc_ctrl_IEIncludes();
        System.assertNotEquals(null, controller.obtainIE7StartBlock());
        System.assertNotEquals(null, controller.obtainIE7EndBlock());
    }
}