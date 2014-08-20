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
private class cc_util_test_LocaleUtils {

    static testMethod void testItAll() {
    	cc_test_TestDataSetup.LoadData();
        System.runas(cc_test_TestDataSetup.testUser) {
    	PageReference page = new PageReference('/apex/CCException');
    	page.getHeaders().put('Accept-Language', 'en-us,en;q=0.5,en');
    	Test.setCurrentPage(page);

    	Test.startTest();

    	System.AssertNotEquals(null, cc_util_Locale.getUserLanguage());
    	System.AssertNotEquals(null, cc_util_Locale.getLangCodeByBrowser());
        System.AssertNotEquals(null, cc_util_Locale.SUPPORTED_LANGUAGE_CODES);
        System.AssertNotEquals(null, cc_util_Locale.DEFAULTS);
        System.AssertNotEquals(null, cc_util_Locale.splitAndFilterAcceptLanguageHeader('one,two,three'));
        System.AssertNotEquals(null, cc_util_Locale.normalizeLocale('en_US'));
        System.AssertNotEquals(null, cc_util_Locale.getUserCurrency());
    	
    	Test.stopTest();
        }
    }
}