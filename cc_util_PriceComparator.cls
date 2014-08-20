//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
global with sharing class cc_util_PriceComparator implements al.ObjectComparator {
	//==================================================
    // DERIVED METHODS
    //==================================================
    global Integer compare(Object object1, Object object2){
        cc_bean_ProductListViewData p1 = (cc_bean_ProductListViewData)object1;
        cc_bean_ProductListViewData p2 = (cc_bean_ProductListViewData)object2;
        Integer rc = 0;
        if(p1==null||p2==null||p1.priceListItem==null||p2.priceListItem==null){
        	return rc;
        }
        if(p1.priceListItem.Price__c < p2.priceListItem.Price__c) rc = -1;
        else if(p1.priceListItem.Price__c > p2.priceListItem.Price__c) rc = 1;
        
        return rc;
        
    }
    
    static testMethod void myUnitTest() {
		cc_bean_ProductListViewData bean1 = new cc_bean_ProductListViewData();
		cc_bean_ProductListViewData bean2 = new cc_bean_ProductListViewData();
		
		cc_util_PriceComparator util = new cc_util_PriceComparator();
		System.assert(util.compare(null, null) == 0);

    	E_PriceListItem__c p1 = new E_PriceListItem__c(Price__c = 1.00);
		E_PriceListItem__c p2 = new E_PriceListItem__c(Price__c = 2.00);
		
		bean1.priceListItem = p1;
		bean2.priceListItem = p2;
		System.assert(util.compare(bean1, bean2) == -1);
		System.assert(util.compare(bean2, bean1) == 1);
		
    }
}