//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
global with sharing class cc_util_ProductDateComparator implements al.ObjectComparator {
	//==================================================
    // DERIVED METHODS
    //==================================================
	global Integer compare(Object object1, Object object2){
		cc_bean_ProductListViewData p1 = (cc_bean_ProductListViewData)object1;
		cc_bean_ProductListViewData p2 = (cc_bean_ProductListViewData)object2;
		Integer rc = 0;

		// compare dates only *New 
		if (p1.product.StartDate__c > p2.product.StartDate__c) rc = -1;
		else if (p1.product.StartDate__c < p2.product.StartDate__c) rc = 1;
		
		/*
		// if start date years are the same, then sort by name
		if (rc == 0) {
			if (p1.product.Name < p2.product.Name) rc = -1;
			else if (p1.product.Name > p2.product.Name) rc = 1;
		}
		*/  
		return rc;    
	}
	
	static testMethod void myUnitTest() {
		List<E_Product__c> products = cc_test_PrepTestData.insertProduct(2);
		
		cc_bean_ProductListViewData bean1 = new cc_bean_ProductListViewData();
		bean1.product = products[0];
		
		cc_bean_ProductListViewData bean2 = new cc_bean_ProductListViewData();
		bean2.product = products[1];
		
		cc_util_ProductDateComparator util = new cc_util_ProductDateComparator();
		System.assert(util.compare(bean1, bean2) == 0);
		
		
	}
}