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
private class cc_api_test_PricingEngine_va {
    
    public static void loadTestData() {
        cc_test_TestDataSetup.loadData();
        E_Product__c product1 = new E_Product__c(Name='product1', Sku__c='sku001', ProductStatus__c='Released');
        E_Product__c product2 = new E_Product__c(Name='product2', Sku__c='sku002', ProductStatus__c='Released');
        E_Product__c product3 = new E_Product__c(Name='product3', Sku__c='sku003', ProductStatus__c='Released');
        
        List<E_Product__c> pList = new List<E_Product__c> {product1, product2, product3};
        insert pList;
        
        E_Category__c root = new E_Category__c(Name='Root', CategoryID__c='Root');
        insert root;
        
        List<E_ProductCategory__c> pcs = new List<E_ProductCategory__c>{
                new E_ProductCategory__c(Category__c=root.id, Product__c=product1.id),
                new E_ProductCategory__c(Category__c=root.id, Product__c=product2.id),
                new E_ProductCategory__c(Category__c=root.id, Product__c=product3.id)
        };
        
        insert pcs;
        
        List<E_PriceListItem__c> priceLineList = new List<E_PriceListItem__c> ();
        priceLineList.add( new E_PriceListItem__c(Pricelist__r=new E_PriceList__c(PricelistId__c='1'), Product__c=product1.id, Price__c=200));
        priceLineList.add( new E_PriceListItem__c(Pricelist__r=new E_PriceList__c(PricelistId__c='1'), Product__c=product2.id, Price__c=200));
        priceLineList.add( new E_PriceListItem__c(Pricelist__r=new E_PriceList__c(PricelistId__c='1'), Product__c=product3.id, Price__c=200));
        priceLineList.add( new E_PriceListItem__c(Pricelist__r=new E_PriceList__c(PricelistId__c='2'), Product__c=product1.id, Price__c=180));
        priceLineList.add( new E_PriceListItem__c(Pricelist__r=new E_PriceList__c(PricelistId__c='2'), Product__c=product2.id, Price__c=220));
        priceLineList.add( new E_PriceListItem__c(Pricelist__r=new E_PriceList__c(PricelistId__c='2'), Product__c=product3.id, Price__c=200));
        
        insert priceLineList;
        
        List<E_ProductMedia__c> pMedias = new List<E_ProductMedia__c>();
        pMedias.add(new E_ProductMedia__c(Product__c=product1.id, MediaType__c='Product Search Image', ProductMediaSource__c='URI', URI__c='MyImageURI'));
        pMedias.add(new E_ProductMedia__c(Product__c=product2.id, MediaType__c='Product Search Image', ProductMediaSource__c='URI', URI__c='MyImageURI'));
        pMedias.add(new E_ProductMedia__c(Product__c=product3.id, MediaType__c='Product Search Image', ProductMediaSource__c='URI', URI__c='MyImageURI'));
        
        insert pMedias;
        
        //E_CompositeProduct__c cp0=new E_CompositeProduct__c( Component__c=bundleProduct.Id, Quantity__c=1, Optional__c=false);
        //insert cp0;
        
        
    }
    
    static testMethod void unitTestPriceSelection() {
        cc_api_test_PricingEngine_va.loadTestData();
         map<String, E_Product__c> sku2Product = new map<String, E_Product__c>();
        for(E_Product__c p : [select id, sku__c from E_Product__c where sku__c like 'sku%']) {
            sku2Product.put(p.sku__c, p);
        }
        system.RunAs(cc_test_TestDataSetup.testUser) {
            Test.startTest();
            List<E_PriceListItem__c> lines1 = cc_ctrl_PricingEngine_va.getPriceLines(null, cc_test_TestDataSetup.testAccount.Id, null, null, null );
                System.assertEquals(lines1.size() , 0);
            List<E_PriceListItem__c> lines2 = cc_ctrl_PricingEngine_va.getPriceLines(new List<String>{'sku001','sku002'},
                                                                     cc_test_TestDataSetup.testAccount.Id, null, 'USD', 'General' );
            System.assertEquals(4, lines2.size());
            
            Map<String,cc_bean_PriceInfo> priceMap = cc_ctrl_PricingEngine_va.getPriceMap(new List<String>{'sku001','sku002','sku003'}, cc_test_TestDataSetup.testAccount.Id, System.today(), null, null);
            System.assertNotEquals(null, priceMap);
            cc_bean_PriceInfo pib1 = priceMap.get('sku001');
            System.assertNotEquals(null, pib1);
            //System.debug('--- pib1=' + pib1);
            System.assertEquals(180.0, pib1.price);
            System.assertEquals(180.0, pib1.subAmount);
            insert new E_AccountGroupPriceList__c(AccountGroup__r = new E_AccountGroup__c(AccountGroupID__c='1'), Pricelist__r = new E_PriceList__c(PricelistId__c='2'), sequence__c=200);
            //test best price
            priceMap = cc_ctrl_PricingEngine_va.getPriceMap(new List<String>{'sku001','sku002','sku003'}, cc_test_TestDataSetup.testAccount.Id, System.today(), null, null);
            System.assertNotEquals(null, priceMap);
            pib1 = priceMap.get('sku001');
            System.assertNotEquals(null, pib1);
            //System.debug('--- pib1=' + pib1);
            System.assertEquals(180.0, pib1.price);
            System.assertEquals(180.0, pib1.subAmount);
            //test sequence selection method
            E_AccountGroup__c ag = new E_AccountGroup__c(AccountGroupID__c='1', PriceListSelectionMethod__c='Sequence Order');
            upsert ag AccountGroupID__c;
            priceMap = cc_ctrl_PricingEngine_va.getPriceMap(new List<String>{'sku001','sku002','sku003'}, cc_test_TestDataSetup.testAccount.Id, System.today(), null, null);
            System.assertNotEquals(null, priceMap);
            pib1 = priceMap.get('sku001');
            System.assertNotEquals(null, pib1);
            //System.debug('--- pib1=' + pib1);
            System.assertEquals(180.0, pib1.price);
            System.assertEquals(180.0, pib1.subAmount);
            Test.stopTest();
            
       }
       
    }
    
    static testMethod void unitTestPriceSelection2() {
        cc_api_test_PricingEngine_va.loadTestData();
         map<String, E_Product__c> sku2Product = new map<String, E_Product__c>();
        for(E_Product__c p : [select id, sku__c from E_Product__c where sku__c like 'sku%']) {
            sku2Product.put(p.sku__c, p);
        }
        system.RunAs(cc_test_TestDataSetup.testUser) {
            insert new E_AccountGroupPriceList__c(AccountGroup__r = new E_AccountGroup__c(AccountGroupID__c='1'), Pricelist__r = new E_PriceList__c(PricelistId__c='2'), sequence__c=200);
            Test.startTest();
            cc_bean_PriceInfo priceBean1 = cc_ctrl_PricingEngine_va.getPrice('sku001', cc_test_TestDataSetup.testAccount.Id, System.today(), null, null);
            System.assertEquals(180.0, priceBean1.price);
            List<E_PriceListItem__c> pList = cc_ctrl_PricingEngine_va.getLowestPriceLine(new List<String>{'sku001','sku002','sku003'}, cc_test_TestDataSetup.testAccount.Id, null, null, null );
            System.assert(pList != null);
            
            E_PriceListItem__c pli =  cc_ctrl_PricingEngine_va.getLowestPrice('sku001', cc_test_TestDataSetup.testAccount.Id, null, null, null );
            
            E_Rule__c ruleTest = new E_Rule__c(Relation__c=cc_cnst_PickListConstants.RULERELATION_SKU, Name__c='Tiered', RuleType__c=cc_cnst_PickListConstants.RULETYPE_TIERED, RuleSource__c = 'Pricing', Enabled__c=true );
            insert ruleTest;
            List<E_RuleTargetSKU__c> targetSKUs = new  List<E_RuleTargetSKU__c>();
            targetSKUs.add(new E_RuleTargetSKU__c(Rule__c = ruleTest.Id, Product__c=sku2Product.get('sku001').Id));
            insert targetSKUs;
            System.assertEquals(cc_ctrl_PricingEngine_va.getRules('sku001', cc_test_TestDataSetup.testAccount.Id, null, null, null).size(), 1);
            System.assertEquals(cc_ctrl_PricingEngine_va.getRules('sku001', cc_test_TestDataSetup.testAccount.Id, null, 'USD', 'General').size(), 0);
            ruleTest.CurrencyISOCode__c = 'USD';
            ruleTest.CustomerTypeCode__c = 'General';
            update ruleTest;
            System.assertEquals(cc_ctrl_PricingEngine_va.getRules('sku001', cc_test_TestDataSetup.testAccount.Id, null, 'USD', 'General').size(), 1);
            cc_ctrl_PricingEngine_va.getRulesForPLI(pList , cc_test_TestDataSetup.testAccount.Id, null, 'USD', 'General');
            Test.stopTest();
            
       }
       
    }

    static testMethod void unitTestPriceSelectionWithCart() {
        cc_api_test_PricingEngine_va.loadTestData();
        map<String, E_Product__c> sku2Product = new map<String, E_Product__c>();
        for(E_Product__c p : [select id, sku__c from E_Product__c where sku__c like 'sku%']) {
            sku2Product.put(p.sku__c, p);
        }
        system.RunAs(cc_test_TestDataSetup.testUser) {
            insert new E_AccountGroupPriceList__c(AccountGroup__r = new E_AccountGroup__c(AccountGroupID__c='1'), Pricelist__r = new E_PriceList__c(PricelistId__c='2'), sequence__c=200);
            Test.startTest();
            cc_api_Cart api = new cc_api_Cart();
            E_Cart__c testCart = api.createEmptyCart();
            System.assertNotEquals(null, testCart);
    
            // TEST QTY = 1
            String testCartEID = api.addToCart(sku2Product.get('sku001').Id, testCart.id, 1, true, 'bio');
            System.assertNotEquals(null, testCartEID);
            List<E_CartItem__c> items = api.getCartItems(testCartEID);
            
            System.assertEquals(1, items.size());
    
            Map<String,cc_bean_PriceInfo> priceMap = cc_ctrl_PricingEngine_va.getPriceMap(items, cc_test_TestDataSetup.testAccount.Id, System.today(), null, null);
            System.assertNotEquals(null, priceMap);
            cc_bean_PriceInfo pib1 = priceMap.get('sku001');
            System.assertNotEquals(null, pib1);
            //System.debug('--- pib1=' + pib1);
            System.assertEquals(180.0, pib1.price);
            System.assertEquals(180.0, pib1.subAmount);
    
            
            Test.stopTest();
            
       }
       
    }

}