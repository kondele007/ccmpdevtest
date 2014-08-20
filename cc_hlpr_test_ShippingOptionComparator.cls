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
private class cc_hlpr_test_ShippingOptionComparator {

    static testMethod void testComparator() {
        cc_ctrl_hlpr_ShippingOption ship2 = new cc_ctrl_hlpr_ShippingOption('Two', 'test2', 20.00);
        cc_ctrl_hlpr_ShippingOption ship3 = new cc_ctrl_hlpr_ShippingOption('Three', 'test3', 30.00);
        cc_ctrl_hlpr_ShippingOption ship1 = new cc_ctrl_hlpr_ShippingOption('One', 'test1', 10.00);
        
        List<cc_ctrl_hlpr_ShippingOption> shipList = new List<cc_ctrl_hlpr_ShippingOption> {ship2, ship3, ship1};
        cc_hlpr_ShippingOptionComparator comparator = new cc_hlpr_ShippingOptionComparator();
        Test.startTest();
        
        System.assert(shipList[1].price > shipList[2].price);
        
        try {
            al.ArrayUtils.qsort(shipList, comparator);
        } catch(al.IllegalArgumentException e) {}

        System.assert(shipList[0].price < shipList[1].price);
        System.assert(shipList[1].price < shipList[2].price);
        
        String[] badList = new String[] {'one','two'};
        try {
        	al.ArrayUtils.qsort(badList, comparator);
        } catch(al.IllegalArgumentException e) {}

        Test.stopTest();
    }
}