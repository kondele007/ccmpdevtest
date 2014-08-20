//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_hlpr_BreadCrumbInfoI18N {
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public String breadCrumb {get;set;}
    public String breadCrumbURL {get;set;}
    public String locale {get;set;}
    public String breadCrumbWithLocale {get;set;}
    public String sequenceName {get;set;}
    public String categoryName {get;set;}
    public String topLevelCategory {get;set;}
    public Integer topLevelIndex {get;set;}
    
    //==================================================
    // TEST METHOD
    //==================================================
    static testMethod void unitTest() {
    	cc_hlpr_BreadCrumbInfoI18N bc = new cc_hlpr_BreadCrumbInfoI18N();
    	bc.breadCrumb = '123';
    	bc.breadCrumbURL='123';
    	bc.breadCrumbWithLocale='123';
    	bc.categoryName='123';
    	bc.locale='123';
    	bc.sequenceName='123';
    	bc.topLevelCategory='123';
    	bc.topLevelIndex=123;
    	System.assertEquals(bc.breadCrumb, '123');
    	System.assertEquals(bc.breadCrumbWithLocale, '123');
    	System.assertEquals(bc.breadCrumbURL, '123');
    	System.assertEquals(bc.categoryName, '123');
    	System.assertEquals(bc.locale, '123');
    	System.assertEquals(bc.sequenceName, '123');
    	System.assertEquals(bc.topLevelCategory, '123');
    	System.assertEquals(bc.topLevelIndex, 123);
    	
    }
}