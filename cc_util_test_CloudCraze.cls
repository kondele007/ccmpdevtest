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
private class cc_util_test_CloudCraze {
    static testMethod void validateGetAccountID() {
        /** Commenting the following code as the query or the for loop does nothing **/
        /**List<E_ProductMedia__c> pml = [Select e.Id, e.Name, e.Product__c, e.URI__c from E_ProductMedia__c e LIMIT 10];
        for(E_ProductMedia__c pm : pml)
        {
            //System.debug('C:\\CloudCrazeImgs\\' + pm.URI__c + '_sb.jpg,' + 'L' + pm.URI__c + '.jpg,false,' + pm.Id );
            //System.debug('C:\\CloudCrazeImgs\\' + pm.URI__c + '_sc.jpg,' + 'S' + pm.URI__c + '.jpg,false,' + pm.Id );
        }**/
        //System.debug('ACCOUNT ID : ' + cc_util_CloudCraze.getAccountID());
        //System.assertEquals('0018000000Sk7oB', cc_util_CloudCraze.getAccountID());
        cc_test_TestDataSetup.loadData();
		System.runas(cc_test_TestDataSetup.testUser) {
        System.assert(cc_util_CloudCraze.getAccountID() != null);
		}
    }
    static testMethod void testGetBreadCrumRootLength(){
    	cc_test_PrepTestData.loadCustomSettings();
    	cc_test_PrepTestData.loadInitData();
    	cc_test_PrepTestData.loadTestCategoryData();
    	Test.startTest();

        System.AssertNotEquals(null, cc_util_CloudCraze.getRootBreadCrumbLength());

        Test.stopTest();
    }

    static testMethod void testGetRelatedProduct(){
        List<E_Product__c> productList = cc_test_PrepTestData.insertProduct(5);
        List<E_RelatedProduct__c> relProdList = cc_test_PrepTestData.insertRelatedProduct(productList[0].id, productList[1].id);
        Test.startTest();

        System.AssertNotEquals(null, cc_util_CloudCraze.getRelatedProducts(productList[0].id, relProdList[0].id));
        System.AssertEquals(relProdList[0].RelatedProductType__c,cc_cnst_PickListConstants.RELATEDPRODUCT_RELATED);
        
        Test.stopTest();
    }

    static testMethod void testgetHistoricalOrderedQty(){
        List<E_Product__c> productList = cc_test_PrepTestData.insertProduct(5);
        System.AssertEquals(10, cc_util_CloudCraze.getHistoricalOrderedQty(productList[0].id, productList[1].id));
    }
    static testMethod void testgetModifiedPrice(){
    	cc_test_TestDataSetup.loadData();
		System.runas(cc_test_TestDataSetup.testUser) {
        Double price= 25;
        Double modifier = 50;
        String valueType = 'Discount';
        //System.AssertEquals(Double.valueOf('12.5'), cc_util_CloudCraze.getModifiedPrice(price, valueType, modifier));
        cc_util_CloudCraze.getModifiedPrice(price, valueType, modifier);
         modifier = 12.5;
         //valueType = 'Absolute';
         valueType = cc_cnst_CloudCraze.DISCOUNTTYPE_ABSOLUTE;
        System.AssertEquals(Double.valueOf('12.5'), cc_util_CloudCraze.getModifiedPrice(price, valueType, modifier));
		}
    }
    static testMethod void validateGetAccountByName() {
        
        try
        {
            String testName = 'MyTestAccount';
//            Account a = new Account(Name='MyTestAccount');
 //           insert a;
		cc_api_dl_accountGroups ag = new cc_api_dl_accountGroups();
		ag.loadData();
		RecordType rt = [Select r.Name, r.Id From RecordType r where r.Name = 'Person Account' limit 1];		
		Account a = new Account(FirstName = '', LastName='MyTestAccount', RecordTypeID = rt.Id, E_AccountGroup__r= new E_AccountGroup__c(ACCOUNTGROUPID__C='1'), OwnerId=userInfo.getUserId());
		insert a;
            System.assertEquals(cc_util_CloudCraze.getAccountIdByName(testName), a.Id);
        }
        catch(cc_util_CloudCraze.CCAccountNotFoundException e)
        {
            System.assertEquals('PortalAccount',e.accountName );
        }
        catch(cc_util_CloudCraze.CCDuplicatedAccountException e)
        {
            System.assertEquals('PortalAccount', e.accountName );
            
        }
    }
    
/*
    static testMethod void validateGetAnonymousAccountID() {
        String anonymousName = cc_util_CloudCraze.getAnonymousUserName();
        Id anonymousID = cc_util_CloudCraze.getAnonymousAccountID();
        Account a = [select a.name from Account a where a.Id= :anonymousID];
        System.assertEquals(anonymousName, a.Name);
        //System.debug('---------------------' + a.Name);
    }
*/    
    static testMethod void validateToString() {
    	cc_test_TestDataSetup.loadData();
		System.runas(cc_test_TestDataSetup.testUser) {
        List<String> testStr = new List<String> { '12345', '890987' };
        String test = cc_util_CloudCraze.toString(testStr);
        test = test.replaceAll('\\{(.*)\\}','($1)');
        System.assertEquals('(\'12345\',\'890987\')', test);
		}
    }
    
    static testMethod void validateGetModifiedPrice() {
    	cc_test_TestDataSetup.loadData();
		System.runas(cc_test_TestDataSetup.testUser) {
        Double price=200;
        System.assertEquals(180.0, cc_util_CloudCraze.getModifiedPrice(price, cc_cnst_CloudCraze.DISCOUNTTYPE_PERCENTAGE, 10));
        System.assertEquals(10.0, cc_util_CloudCraze.getModifiedPrice(price, cc_cnst_CloudCraze.DISCOUNTTYPE_PRICE, 10));
        System.assertEquals(190.0, cc_util_CloudCraze.getModifiedPrice(price, cc_cnst_CloudCraze.DISCOUNTTYPE_ABSOLUTE, 10));
		}
    }
    
    static testMethod void testGetAnonymousAccountID() {
    	cc_test_PrepTestData.loadCustomSettings();
    	cc_test_PrepTestData.loadInitData();

    	Id accountId = cc_util_CloudCraze.getAnonymousAccountID();
    	System.assertNotEquals(accountId, null);
    }

    public static testMethod void testLocalNamespace() {
        System.assertNotEquals(null, cc_util_CloudCraze.localNamespace);
    }
    
    public static testMethod void testGetStateCodes(){
    	cc_test_TestDataSetup.loadData();
    	System.RunAs(cc_test_TestDataSetup.testUser){
          //Assumes there are Candian states populated
          List<StateCode__c> codes = cc_util_CustomSettings.getStateCodes('CA');
          System.assertNotEquals(null,codes);
          System.assertNotEquals(0,codes.size());
          for(StateCode__c code : codes){
            System.assertEquals('CA',code.CountryCode__c);
          }
    	}
    }
    
    private static void loadLanguages(){
        List<E_Language__c> testLanguages = new List<E_Language__c>();
        testLanguages.add(new E_Language__c(
        Language__c = 'English',
        Name='ES English',
        Locale__c = 'en_US',
        Storefront__c = 'abc'));
        testLanguages.add(new E_Language__c(
        Language__c = 'English',
        Name='DT English',
        Locale__c = 'en_US',
        Storefront__c = 'cde'));
        testLanguages.add(new E_Language__c(
        Language__c = 'German',
        Name='DT German',
        Locale__c = 'de',
        Storefront__c = 'cde'));
        testLanguages.add(new E_Language__c(
        Language__c = 'Albanian',
        Name='DT Albanian',
        Locale__c = 'al',
        Storefront__c = 'cde'));
        testLanguages.add(new E_Language__c(
        Language__c = 'Zhanian',
        Name='DT Zhanian',
        Locale__c = 'aa',
        Storefront__c = 'cde'));
        insert testLanguages;
    }
    
    static testMethod void testGetLangaugesWithStorefront(){
        loadLanguages();
        
        E_StorefrontSettings__c es_storefront = new E_StorefrontSettings__c();
        es_storefront.name = 'abc';
        
        E_StorefrontSettings__c dt_storefront = new E_StorefrontSettings__c();
        dt_storefront.name = 'cde';
        
        List<E_Language__c> languages = cc_util_CustomSettings.getLanguages(null);
        System.assertNotEquals(null,languages);
        System.assertEquals(0,languages.size());
    
        languages = cc_util_CustomSettings.getLanguages(es_storefront);
        System.assertNotEquals(null,languages);
        System.assertEquals(1,languages.size());
        
        languages = cc_util_CustomSettings.getLanguages(dt_storefront);
        System.assertNotEquals(null,languages);
        System.assertEquals(4,languages.size());
        //Test the sorting
        System.assertEquals('Albanian',languages.get(0).Language__c);
        System.assertEquals('English',languages.get(1).Language__c);
        System.assertEquals('German',languages.get(2).Language__c);     
        System.assertEquals('Zhanian',languages.get(3).Language__c);
    }
    
    static testMethod void testGetLanguageOptions(){
        loadLanguages();
        E_StorefrontSettings__c es_storefront = new E_StorefrontSettings__c();
        es_storefront.name = 'abc';
        
        E_StorefrontSettings__c dt_storefront = new E_StorefrontSettings__c();
        dt_storefront.name = 'cde';
        
        List<SelectOption> languages = cc_util_Picklist.getLanguageOptionsList(null);
        System.assertNotEquals(null,languages);
        //Should be 0, but there's a 'Please Select One' option added
        System.assertEquals(0,languages.size());
        
        languages = cc_util_Picklist.getLanguageOptionsList(es_storefront);
        System.assertNotEquals(null,languages);
        System.assertEquals(1,languages.size());
        
        languages = cc_util_Picklist.getLanguageOptionsList(dt_storefront);
        System.assertNotEquals(null,languages);
        System.assertEquals(4,languages.size());
        System.assertEquals('Albanian',languages.get(0).getLabel());
        System.assertEquals('al',languages.get(0).getValue());
        System.assertEquals('English',languages.get(1).getLabel());
        System.assertEquals('en_US',languages.get(1).getValue());
        System.assertEquals('German',languages.get(2).getLabel()); 
        System.assertEquals('de',languages.get(2).getValue()); 
        System.assertEquals('Zhanian',languages.get(3).getLabel());
        System.assertEquals('aa',languages.get(3).getValue());
    }
    
    static testMethod void testGetLanguageByLocale(){
      insert new E_Language__c(Name='Name', Language__c='Language',Locale__c='lo_LO',LanguageCode__c='lo',Storefront__c='langTest');  
      E_StorefrontSettings__c valid = new E_StorefrontSettings__c(name='langTest');
      E_StorefrontSettings__c invalid = new E_StorefrontSettings__c(name='invalid');
      System.assertEquals('lo',cc_util_CustomSettings.getLanguageCodeByLocale(valid, 'lo_LO'));
      System.assertEquals(null,cc_util_CustomSettings.getLanguageCodeByLocale(null, 'lo_LO'));    
      System.assertEquals(null,cc_util_CustomSettings.getLanguageCodeByLocale(invalid, 'lo_LO')); 
      System.assertEquals(null,cc_util_CustomSettings.getLanguageCodeByLocale(valid, 'test'));     
    }
    
    static testMethod void testGetStateCodeByCode(){
      insert new StateCode__c(Name='AA_BB',Code__c='AA',CountryCode__c='AA',State__c='BB');
      StateCode__c test1 = cc_util_CustomSettings.getStateCodeByCode('AA','BB');   
      System.assertNotEquals(null,test1);
      System.assertEquals('AA',test1.CountryCode__c);
      System.assertEquals('BB',test1.State__c);
      
      StateCode__c test2 = cc_util_CustomSettings.getStateCodeByCode('ZZZ', 'QQQ');
      System.assertEquals(null,test2);
    }
    
    static testMethod void testGetCurrencyCodeByISOCode(){
      insert new CurrencyCode__c(Name='test');
      CurrencyCode__c code = cc_util_CustomSettings.getCurrencyCodeByISOCode('test');
      System.assertEquals('test',code.Name);
      
      CurrencyCode__c code2 = cc_util_CustomSettings.getCurrencyCodeByISOCode('invalid');
      System.assertEquals(null,code2);
    }
    
    static testMethod void testGetStateCodeByName(){
      insert new StateCode__c(Name='state',CountryCode__c='ZZ',State__c='State',Code__c='test');
      StateCode__c code = cc_util_CustomSettings.getStateCodeByName('ZZ', 'State');
      System.assertNotEquals(null,code);
      System.assertEquals('State',code.State__c);
      System.assertEquals('ZZ',code.CountryCode__c);
      System.assertEquals('test',code.Code__c);
      
      StateCode__c code2 = cc_util_CustomSettings.getStateCodeByName('ZZ','Invalid');  
      System.assertEquals(null,code2);
    }
    
    static testMethod void testGetCountryCodeByName(){
    	cc_test_TestDataSetup.loadData();
      insert new CountryCode__c(Name='Code',Country__c='Country',Storefront__c=cc_util_CloudCraze.application.Default_Storefront__c);
      CountryCode__c country = cc_util_CustomSettings.getCountryCodeByName('Country');
      System.assertNotEquals(null,country);
      System.assertEquals('Country',country.Country__c);
      
      System.assertEquals(null,cc_util_CustomSettings.getCountryCodeByName('InvalidCountry'));
      
      CountryCode__c code = cc_util_CustomSettings.getCountryCodeByCode('Code');
      System.assertNotEquals(null,code);
      System.assertEquals('Code',code.Name);
      //System.assertEquals(null,cc_util_CustomSettings.getCountryCodeByCode(null));
      System.assertEquals(null,cc_util_CustomSettings.getCountryCodeByCode('invalid')); 
      
      List<CountryCode__c> countries = cc_util_CustomSettings.getCountryCodes();
      System.assertNotEquals(null,countries);
      System.assert(countries.size()>0);
      
      List<SelectOption> countryOptions = cc_util_Picklist.getCountryOptionsList();
      System.assertNotEquals(null,countryOptions);
      System.assert(countryOptions.size()>1);   
    }
    
    static testMethod void testGetStateOptionsList(){
      cc_test_TestDataSetup.loadData();
      insert new StateCode__c(Name='state',CountryCode__c='ZZ',State__c='State',Code__c='State');
      
      List<SelectOption> states = cc_util_Picklist.getAllStateOptionsList(); 
      System.assertNotEquals(null,states);
      System.assert(states.size()>1);
      
      List<SelectOption> zzStates = cc_util_Picklist.getStateOptionsList('ZZ');
      System.assertNotEquals(null,zzStates);
      System.assertEquals(2,zzStates.size());
      System.assertEquals('State',zzStates.get(1).getLabel());
    }
}