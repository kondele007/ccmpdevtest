/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private without sharing class cc_util_test_Cart {
    static testMethod void getCartProductQuantitiesTest() {
    	//delete [select id from E_CartItem__c];
    	//delete [select id from E_Product__c ];
        //delete [select id from E_Cart__c];
		cc_test_TestDataSetup.LoadData();
    	System.runas(cc_test_TestDataSetup.testUser) {
        E_Product__c testProduct = new E_Product__c(Name='classtest', SKU__c='testsku');
        insert testProduct;
        
        cc_api_Cart cc_api_Cart = new cc_api_Cart();
        E_Cart__c cart = cc_api_Cart.createEmptyCart();
        
    	E_CartItem__c cartItem = new E_CartItem__c(Cart__c=cart.Id, Price__c=1.00, Product__c = testProduct.Id, Quantity__c = 2);
    	insert cartItem;
    	
        List<E_CartItem__c> cartItemList = new List<E_CartItem__c>();
        cartItemList.add(cartItem);
        
        
        Map<Id,Integer> returnVal = cc_util_Cart.getCartProductQuantities(cartItemList);
        
        system.assert(returnVal != null);
    	}
    }
    
    
    static testMethod void getCartTotalQuantityTest() {
        //delete [select id from E_CartItem__c];
        //delete [select id from E_Product__c ];
        //delete [select id from E_Cart__c];
		cc_test_TestDataSetup.LoadData();
    	System.runas(cc_test_TestDataSetup.testUser) {
        E_Product__c testProduct = new E_Product__c(Name='classtest', SKU__c='testsku');
        insert testProduct;
        
        cc_api_Cart cc_api_Cart = new cc_api_Cart();
        E_Cart__c cart = cc_api_Cart.createEmptyCart();
        
        E_CartItem__c cartItem = new E_CartItem__c(Cart__c=cart.Id, Price__c=1.00, Product__c = testProduct.Id, Quantity__c = 2);
        insert cartItem;
        
        List<E_CartItem__c> cartItemList = new List<E_CartItem__c>();
        cartItemList.add(cartItem);
        
        Integer returnVal = cc_util_Cart.getCartTotalQuantity(cartItemList);
       
       	system.assertEquals(returnVal, 2);
    	}
    }
    
    
    static testMethod void getCartProductMapTest() {
        //delete [select id from E_CartItem__c];
        //delete [select id from E_Product__c];
        //delete [select id from E_Cart__c];
		cc_test_TestDataSetup.LoadData();
    	System.runas(cc_test_TestDataSetup.testUser) {
        E_Product__c testProduct = new E_Product__c(Name='classtest', SKU__c='testsku');
        insert testProduct;
        
        cc_api_Cart cc_api_Cart = new cc_api_Cart();
        E_Cart__c cart = cc_api_Cart.createEmptyCart();
        
        E_CartItem__c cartItem = new E_CartItem__c(Cart__c=cart.Id, Price__c=1.00, Product__c = testProduct.Id, Quantity__c = 2);
        insert cartItem;
        
        List<E_CartItem__c> cartItemList = new List<E_CartItem__c>();
        cartItemList.add(cartItem);
         
        Map<Id,E_CartItem__c> returnVal = cc_util_Cart.getCartProductMap(cartItemList);
        
        system.assert(returnVal != null);
    	}
    }
    
}