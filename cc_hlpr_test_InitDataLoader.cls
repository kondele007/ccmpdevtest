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
private class cc_hlpr_test_InitDataLoader {

    static testMethod void myUnitTest2() {
    	cc_test_TestDataSetup.loadData();
        cc_hlpr_InitLoadCustomSettings.loadCountryCodes(new Set<String> {'US','ZA'});
         CountryCode__c c = CountryCode__c.getValues('ZA');
         System.assertEquals('South Africa', c.Country__c);
    }
    
    static testMethod void myUnitTest3() {
         cc_hlpr_InitLoadCustomSettings.loadStateCodes();
         Map<String, StateCode__c> m = StateCode__c.getAll();
         System.assertEquals(m.size(), 64);
         System.assertEquals(m.get('CA_ON').Code__c, 'ON');
         System.assertEquals(m.get('CA_ON').CountryCode__c, 'CA');
         System.assertEquals(m.get('CA_ON').State__c, 'Ontario');
		 
    }
    
    static testMethod void myUnitTest4() {
         cc_hlpr_InitLoadCustomSettings.loadPageConfigurations();
         Map<String, PageConfiguration__c> m = PageConfiguration__c.getAll();
         System.assertEquals(m.size(), 1);
         System.assertEquals(m.get('HomepageLeftNav').Value__c, 'aw_LeftNavInc');
		 
    }
    
    static testMethod void myUnitTest6() {
         cc_hlpr_InitLoadCustomSettings.loadCurrencyCodes();
         Map<String, CurrencyCode__c> m = CurrencyCode__c.getAll();
         System.assertEquals(m.size(), 1);
         System.assertEquals(m.get('USD').CURRENCY_NAME__C, 'USD');
		 
    }
    
    static testMethod void myUnitTest10() {
         cc_hlpr_InitDataSet.initialize();
         cc_hlpr_InitDataSet.loadAccountGroup();
         
         cc_hlpr_InitDataSet.loadAccount();
         cc_hlpr_InitDataSet.loadPriceList();
         cc_hlpr_InitDataSet.loadAccountGroupPriceList();
         system.assert([select id from E_AccountGroup__c where name = 'PortalAccount'].size() != 0);
    }
    
    static testMethod void myUnitTest11() {
         cc_hlpr_InitLoadCustomSettings.loadCloudCrazeApplicationSettings();
         Map<String, E_ApplicationSettings__c> m = E_ApplicationSettings__c.getAll();
         System.assertEquals(m.size(), 1);
         System.assertEquals('DefaultStore', m.get('CloudCraze').Default_Storefront__c);
    }

    static testMethod void myUnitTest12() {
         cc_hlpr_InitLoadCustomSettings.loadCloudCrazeStorefrontSettings();
         Map<String, E_StorefrontSettings__c> m = E_StorefrontSettings__c.getAll();
         System.assertEquals(m.size(), 1);
         System.assertEquals('PortalAccount', m.get('DefaultStore').Customer_Portal_Account_Name__c);
    }
}