//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_bean_CategoryInfoI18N {
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public String locale {get;set;}
    public String categoryName {get;set;}
    public String categoryMapStr {get;set;}
    //==================================================
    // TEST METHOD
    //==================================================
    static testMethod void unitTest() {
    	cc_bean_CategoryInfoI18N bc = new cc_bean_CategoryInfoI18N();
    	bc.locale = '123';
    	bc.categoryName='123';
    	bc.categoryMapStr='123';
    	
    	System.assertEquals(bc.locale, '123');
    	System.assertEquals(bc.categoryName, '123');
    	System.assertEquals(bc.categoryMapStr, '123');
    	
    	
    }
}