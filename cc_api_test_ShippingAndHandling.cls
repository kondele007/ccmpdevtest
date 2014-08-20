//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
/* ============================================================
 * Unit test for cc_api_ShippingAndHandling
 * 
 * ============================================================
 */
@IsTest
private class cc_api_test_ShippingAndHandling {

    private static testmethod void testCheckForProductsWithMultipleStore(){
        // Build data
    	cc_test_PrepTestData.loadCustomSettings();
    	
        List<E_CartItem__c> cartItemList = new List<E_CartItem__c>();
        E_CartItem__c cartItem = new E_CartItem__c();
        String productId = 'a0tR00000005I7XIAU';
        Double qty = 1; 
            cartItem.Product__c = productId;
            cartItem.Quantity__c = qty;
            cartItem.StoreId__c = cc_util_CloudCraze.application.Default_Storefront__c;
            cartItemList.add(cartItem);
        cartItem = new E_CartItem__c();
        productId = 'a0tR00000005HXJIA2';
        qty = 2;
            cartItem.Product__c = productId;
            cartItem.Quantity__c = qty;
            cartItem.StoreId__c = cc_util_CloudCraze.application.Default_Storefront__c;
            cartItemList.add(cartItem);         
        // Build data  
        
        Test.startTest();
        
        cc_api_ShippingAndHandling cc_api_ShippingAndHandling = new cc_api_ShippingAndHandling();
        cc_api_ShippingAndHandling.cartItems = cartItemList;       
        //System.assertEquals(false, cc_api_ShippingAndHandling.checkForProductsWithMultipleStore());
        cc_api_ShippingAndHandling.checkForProductsWithMultipleStore();
        System.assertEquals(true, cc_api_ShippingAndHandling.checkForProductsWithMultipleStore());

        // Build data
        cartItemList = new List<E_CartItem__c>();
        cartItem = new E_CartItem__c();
        productId = 'a0tR00000005I7XIAU';
        qty = 1;
            cartItem.Product__c = productId;
            cartItem.Quantity__c = qty;
            cartItem.StoreId__c = cc_util_CloudCraze.application.Default_Storefront__c;
            cartItemList.add(cartItem);
        cartItem = new E_CartItem__c();
        productId = 'a0tR00000005HXJIA2';
        qty = 2; 
            cartItem.Product__c = productId;
            cartItem.Quantity__c = qty;
            cartItem.StoreId__c = cc_util_CloudCraze.application.Default_Storefront__c;
            cartItemList.add(cartItem);         
        // Build data  
        
        cc_api_ShippingAndHandling = new cc_api_ShippingAndHandling();
        cc_api_ShippingAndHandling.cartItems = cartItemList;       
        System.assertEquals(true, cc_api_ShippingAndHandling.checkForProductsWithMultipleStore());
        
        Test.stopTest();
    }

    private static testmethod void testGetShippingAttributes(){
        // Build data
        //cc_test_PrepTestData.loadCustomSettings();
		cc_test_TestDataSetup.loadData();
		System.runas(cc_test_TestDataSetup.testUser) {
        cc_bean_ShippingOptionsRequest shipOptionsRequest = new cc_bean_ShippingOptionsRequest();       
        shipOptionsRequest.recepientZipCode = '61614';
        shipOptionsRequest.recepientCountryCode = 'US';
		E_Product__c p = new E_Product__c(sku__c='sku1');
		insert p;
        List<E_CartItem__c> cartItemList = new List<E_CartItem__c>();
        E_CartItem__c cartItem = new E_CartItem__c(product__c=p.id);
        
        //String productId = 'a0tR00000005I5LIAU';
        Double qty = 1; 
            cartItem.Product__c = p.id;
            cartItem.Quantity__c = qty;
            cartItem.StoreId__c = cc_util_CloudCraze.application.Default_Storefront__c;
            cartItemList.add(cartItem);
        // Build data  
        
        Test.startTest();
        
        cc_api_ShippingAndHandling cc_api_ShippingAndHandling = new cc_api_ShippingAndHandling();
        cc_api_ShippingAndHandling.cartItems = cartItemList;
        shipOptionsRequest.storefront = cc_util_CloudCraze.getDefaultStorefrontSettings();

        shipOptionsRequest = cc_api_ShippingAndHandling.getShippingAttributes(shipOptionsRequest);
        if (shipOptionsRequest != null && shipOptionsRequest.shippingAttributesList != null && shipOptionsRequest.shippingAttributesList.size() > 0) {
            List<cc_bean_ShippingAttributes> shippingAttributesList = shipOptionsRequest.shippingAttributesList; 
            for (cc_bean_ShippingAttributes shipAttributes : shippingAttributesList) {
                //System.debug('-----shipAttributes.productId = ' + shipAttributes.productId);
                //System.debug('-----shipAttributes.weight = ' + shipAttributes.weight);                      
                //System.debug('-----shipAttributes.hazardousflag = ' + shipAttributes.hazardousflag);            
                //System.debug('-----shipAttributes.groundShippingRequired = ' + shipAttributes.groundShippingRequired);
                //System.debug('-----shipAttributes.overnightAirRequired = ' + shipAttributes.overnightAirRequired);
                //System.debug('-----shipAttributes.dryIceRequired = ' + shipAttributes.dryIceRequired);
                //System.debug('-----shipAttributes.dryIceWeight = ' + shipAttributes.dryIceWeight);
                //System.debug('-----shipAttributes.coolerPakRequired = ' + shipAttributes.coolerPakRequired);
            }           
        } else {
            System.assert(shipOptionsRequest!=null,'Environment Dependency: no shipping attributes data available.');
        }
        
        Test.stopTest();
		}
    }
    
    private static testmethod void testCheckToDisplayOrCallShipOptions(){
        cc_bean_ShippingOptionsRequest shipOptionsRequest = new cc_bean_ShippingOptionsRequest();       
        // Build data
        shipOptionsRequest.recepientStateCode = 'AK';
        List<cc_bean_ShippingAttributes> shipAttributesList = new List<cc_bean_ShippingAttributes>();
        cc_bean_ShippingAttributes shipAttributes = new cc_bean_ShippingAttributes();
        shipAttributes.groundShippingRequired = true;
        shipAttributesList.add(shipAttributes);
        shipOptionsRequest.shippingAttributesList = shipAttributesList;
        // Build data
        cc_api_ShippingAndHandling cc_api_ShippingAndHandling = new cc_api_ShippingAndHandling();
        boolean displayAndNotCallShipOptions = cc_api_ShippingAndHandling.checkToDisplayOrCallShipOptions(shipOptionsRequest);
        //System.debug('-----testCheckToDisplayOrCallShipOptions.displayAndNotCallShipOptions = ' + displayAndNotCallShipOptions);
        System.assert(!displayAndNotCallShipOptions);
        
        shipOptionsRequest = new cc_bean_ShippingOptionsRequest();      
        // Build data
        shipOptionsRequest.recepientStateCode = 'AK';
        shipAttributesList = new List<cc_bean_ShippingAttributes>();
        shipAttributes = new cc_bean_ShippingAttributes();
        shipAttributes.hazardousflag = true;
        shipAttributesList.add(shipAttributes);
        shipOptionsRequest.shippingAttributesList = shipAttributesList;
        // Build data
        cc_api_ShippingAndHandling = new cc_api_ShippingAndHandling();
        displayAndNotCallShipOptions = cc_api_ShippingAndHandling.checkToDisplayOrCallShipOptions(shipOptionsRequest);
        //System.debug('-----testCheckToDisplayOrCallShipOptions.displayAndNotCallShipOptions = ' + displayAndNotCallShipOptions);
        System.assert(!displayAndNotCallShipOptions);       
        
        shipOptionsRequest = new cc_bean_ShippingOptionsRequest();      
        // Build data
        shipOptionsRequest.recepientStateCode = 'IL';
        shipAttributesList = new List<cc_bean_ShippingAttributes>();
        shipAttributes = new cc_bean_ShippingAttributes();
        shipAttributes.dryIceRequired = true;
        shipAttributesList.add(shipAttributes);
        shipAttributes = new cc_bean_ShippingAttributes();
        shipAttributes.groundShippingRequired = true;
        shipAttributesList.add(shipAttributes);     
        shipOptionsRequest.shippingAttributesList = shipAttributesList;
        // Build data
        cc_api_ShippingAndHandling = new cc_api_ShippingAndHandling();
        displayAndNotCallShipOptions = cc_api_ShippingAndHandling.checkToDisplayOrCallShipOptions(shipOptionsRequest);
        //System.debug('-----testCheckToDisplayOrCallShipOptions.displayAndNotCallShipOptions = ' + displayAndNotCallShipOptions);
        System.assert(!displayAndNotCallShipOptions);       
        
        shipOptionsRequest = new cc_bean_ShippingOptionsRequest();      
        // Build data
        shipOptionsRequest.recepientStateCode = 'IL';
        shipAttributesList = new List<cc_bean_ShippingAttributes>();
        shipAttributes = new cc_bean_ShippingAttributes();
        shipAttributes.dryIceRequired = true;
        shipAttributesList.add(shipAttributes);
        shipAttributes = new cc_bean_ShippingAttributes();
        shipAttributes.overnightAirRequired = true;
        shipAttributesList.add(shipAttributes);     
        shipOptionsRequest.shippingAttributesList = shipAttributesList;
        // Build data
        cc_api_ShippingAndHandling = new cc_api_ShippingAndHandling();
        displayAndNotCallShipOptions = cc_api_ShippingAndHandling.checkToDisplayOrCallShipOptions(shipOptionsRequest);
        //System.debug('-----testCheckToDisplayOrCallShipOptions.displayAndNotCallShipOptions = ' + displayAndNotCallShipOptions);
        System.assert(displayAndNotCallShipOptions);        
        
        shipOptionsRequest = new cc_bean_ShippingOptionsRequest();      
        // Build data
        shipOptionsRequest.recepientStateCode = 'IL';
        shipAttributesList = new List<cc_bean_ShippingAttributes>();
        shipAttributes = new cc_bean_ShippingAttributes();
        shipAttributesList.add(shipAttributes);
        shipAttributes = new cc_bean_ShippingAttributes();
        shipAttributesList.add(shipAttributes);     
        shipOptionsRequest.shippingAttributesList = shipAttributesList;
        // Build data
        cc_api_ShippingAndHandling = new cc_api_ShippingAndHandling();
        displayAndNotCallShipOptions = cc_api_ShippingAndHandling.checkToDisplayOrCallShipOptions(shipOptionsRequest);
        //System.debug('-----testCheckToDisplayOrCallShipOptions.displayAndNotCallShipOptions = ' + displayAndNotCallShipOptions);
        System.assert(displayAndNotCallShipOptions);  
        
        shipOptionsRequest = new cc_bean_ShippingOptionsRequest();      
        // Build data
        shipOptionsRequest.recepientCountryCode = 'CA';
        shipAttributesList = new List<cc_bean_ShippingAttributes>();
        shipAttributes = new cc_bean_ShippingAttributes();
        shipAttributes.hazardousoutside48flag = true;
        shipAttributesList.add(shipAttributes);
        shipOptionsRequest.shippingAttributesList = shipAttributesList;
        // Build data
        cc_api_ShippingAndHandling = new cc_api_ShippingAndHandling();
        displayAndNotCallShipOptions = cc_api_ShippingAndHandling.checkToDisplayOrCallShipOptions(shipOptionsRequest);
        //System.debug('-----testCheckToDisplayOrCallShipOptions.displayAndNotCallShipOptions = ' + displayAndNotCallShipOptions);
        System.assert(!displayAndNotCallShipOptions);           
    }
        
    private static testmethod void testBuildPackageRequest(){
        cc_bean_ShippingOptionsRequest shipOptionsRequest = new cc_bean_ShippingOptionsRequest();       
        cc_bean_ShippingOptionsRequest newShipOptionsRequest = new cc_bean_ShippingOptionsRequest();        
        // Build data
        shipOptionsRequest.recepientStateCode = 'IL';
        List<cc_bean_ShippingAttributes> shipAttributesList = new List<cc_bean_ShippingAttributes>();
        // Hazardous - 1
        cc_bean_ShippingAttributes shipAttributes = new cc_bean_ShippingAttributes();
        shipAttributes.hazardousflag = true;
        shipAttributes.weight = 10;
        shipAttributesList.add(shipAttributes);
        // Hazardous - 2        
        shipAttributes = new cc_bean_ShippingAttributes();
        shipAttributes.hazardousflag = true;
        shipAttributes.weight = 20;     
        shipAttributesList.add(shipAttributes);
        // DryIce - 3       
        shipAttributes = new cc_bean_ShippingAttributes();
        shipAttributes.dryIceRequired = true;
        shipAttributes.weight = 10.1;
        shipAttributes.dryIceWeight = 9.9;              
        shipAttributesList.add(shipAttributes);             
        // CoolerPak - 4        
        shipAttributes = new cc_bean_ShippingAttributes();
        shipAttributes.coolerPakRequired = true;
        shipAttributes.weight = 20.1;
        shipAttributesList.add(shipAttributes);
        // DryIce - 5       
        shipAttributes = new cc_bean_ShippingAttributes();
        shipAttributes.dryIceRequired = true;
        shipAttributes.weight = 30.1;
        shipAttributes.dryIceWeight = 19.9;             
        shipAttributesList.add(shipAttributes);
        // CoolerPak - 6        
        shipAttributes = new cc_bean_ShippingAttributes();
        shipAttributes.coolerPakRequired = true;
        shipAttributes.weight = 100;
        shipAttributesList.add(shipAttributes);
        // 7        
        shipAttributes = new cc_bean_ShippingAttributes();
        shipAttributes.weight = 5.5;
        shipAttributesList.add(shipAttributes);
        // 8        
        shipAttributes = new cc_bean_ShippingAttributes();
        shipAttributes.weight = 4.5;
        shipAttributesList.add(shipAttributes);
        shipOptionsRequest.shippingAttributesList = shipAttributesList;
        // Build data
        cc_api_ShippingAndHandling cc_api_ShippingAndHandling = new cc_api_ShippingAndHandling();
        cc_api_ShippingAndHandling.MAX_PER_PACKAGE_WEIGHT = 150;
        newShipOptionsRequest = cc_api_ShippingAndHandling.buildPackageRequest(shipOptionsRequest);
        cc_bean_ShippingAttributes newShipAttributes = newShipOptionsRequest.shippingAttributesList.get(0);
        System.assertEquals(newShipAttributes.hazardousFlag, true);
        System.assertEquals(newShipAttributes.weight, 10);
        newShipAttributes = newShipOptionsRequest.shippingAttributesList.get(1);
        System.assertEquals(newShipAttributes.hazardousFlag, true);
        System.assertEquals(newShipAttributes.weight, 20);
        newShipAttributes = newShipOptionsRequest.shippingAttributesList.get(2);
        System.assertEquals(newShipAttributes.dryIceRequired, true);
        System.assertEquals(newShipAttributes.weight, 70.0);
        newShipAttributes = newShipOptionsRequest.shippingAttributesList.get(3);
        System.assertEquals(newShipAttributes.coolerPakRequired, true);
        System.assertEquals(newShipAttributes.weight, 120.1);
        newShipAttributes = newShipOptionsRequest.shippingAttributesList.get(4);
        System.assertEquals(newShipAttributes.weight, 10.0);
    }    

    private static testmethod void testCalculateShipWeight(){
        cc_api_ShippingAndHandling cc_api_ShippingAndHandling = new cc_api_ShippingAndHandling();
        Decimal shipWeight = cc_api_ShippingAndHandling.calculateShipWeight(10, 10, 10);
        System.assertEquals(30, shipWeight);
    
        shipWeight = cc_api_ShippingAndHandling.calculateShipWeight(0, 10, 10);
        System.assertEquals(20, shipWeight);
    
        shipWeight = cc_api_ShippingAndHandling.calculateShipWeight(0, 10, 0);
        System.assertEquals(10, shipWeight);
    
        shipWeight = cc_api_ShippingAndHandling.calculateShipWeight(null, 10, null);
        System.assertEquals(10, shipWeight);
    
        shipWeight = cc_api_ShippingAndHandling.calculateShipWeight(null, null, null);
        System.assertEquals(0, shipWeight);                                                            
    }

    private static testmethod void testCalculateWeightWithQuantity(){
        // Build data
        cc_test_PrepTestData.loadCustomSettings();

        List<E_CartItem__c> cartItemList = new List<E_CartItem__c>();
        E_CartItem__c cartItem = new E_CartItem__c();
        String productId = 'a0MA000000005dfMAA';
        Double qty = 2; 
            cartItem.Product__c = productId;
            cartItem.Quantity__c = qty;
            cartItem.StoreId__c = cc_util_CloudCraze.application.Default_Storefront__c;
            cartItemList.add(cartItem);
        cartItem = new E_CartItem__c();
        productId = 'a0MA000000005dhMAA';
        qty = 3;
            cartItem.Product__c = productId;
            cartItem.Quantity__c = qty;
            cartItem.StoreId__c = cc_util_CloudCraze.application.Default_Storefront__c;           
            cartItemList.add(cartItem);
        cartItem = new E_CartItem__c();
        productId = 'a0MA000000005djMAA';
        qty = 1;
            cartItem.Product__c = productId;
            cartItem.Quantity__c = qty;
            cartItem.StoreId__c = cc_util_CloudCraze.application.Default_Storefront__c;
            cartItemList.add(cartItem);
        cartItem = new E_CartItem__c();         
        productId = 'a0MA000000005dlMAA';
        qty = 4;
            cartItem.Product__c = productId;
            cartItem.Quantity__c = qty;
            cartItem.StoreId__c = cc_util_CloudCraze.application.Default_Storefront__c;
            cartItemList.add(cartItem);         
        // Build data                   

        Test.startTest();
        
        cc_api_ShippingAndHandling cc_api_ShippingAndHandling = new cc_api_ShippingAndHandling();
        cc_api_ShippingAndHandling.cartItems = cartItemList;
        Decimal weight = cc_api_ShippingAndHandling.calculateWeightWithQuantity(10, 'a0MA000000005dfMAA');
        System.assertEquals(20.0, weight);
        
        weight = cc_api_ShippingAndHandling.calculateWeightWithQuantity(9, 'a0MA000000005dhMAA');
        System.assertEquals(27.0, weight);
        
        weight = cc_api_ShippingAndHandling.calculateWeightWithQuantity(5, 'a0MA000000005djMAA');
        System.assertEquals(5.0, weight);   
        
        weight = cc_api_ShippingAndHandling.calculateWeightWithQuantity(5, 'a0MA000000005dlMAA');
        System.assertEquals(20.0, weight);    
        
        Test.stopTest();                                                                                                                                                                                                
    }    
}