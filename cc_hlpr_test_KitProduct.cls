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
private class cc_hlpr_test_KitProduct {
 
    static testMethod void callAggregatedPriceTest() {
        E_CartItem__c cartItem = new E_CartItem__c();
        cartItem.SubAmount__c = 20;
        cartItem.Price__c = 20;
        E_Cart__c cart = new E_Cart__c();
        cart.SessionId__c = 'testSessionId';
        insert cart;
        cartItem.Cart__c = cart.Id;
        insert cartItem;
        E_CartItem__c cartItem2 = new E_CartItem__c();
        cartItem2.ParentCartItem__c = cartItem.Id;
        cartItem2.SubAmount__c = 20;
        cartItem2.Price__c = 20;
        E_Cart__c cart2 = new E_Cart__c();
        cart2.SessionId__c = 'testSessionId';
        insert cart2;
        cartItem2.Cart__c = cart2.Id;
        insert cartItem2;
		
		cc_hlpr_KitProduct testClass = new cc_hlpr_KitProduct();
		Decimal retVal = testclass.calAggregatedPrice(cartItem);
		system.assert(retVal == 0);
    }
    
    static testMethod void testCompositeProductUtils() {
    	String bundleProductSKU='sku0015';
    	cc_test_TestDataSetup.loadData();
    	cc_test_TestDataSetup.loadCompositeProducts(); 
    	Map<String, string> selectedOption = cc_test_TestDataSetup.getSelectedAggregatedProduct();
        map<String, E_Product__c> sku2Product = new map<String, E_Product__c>();
   		for(E_Product__c p : [select id, sku__c from E_Product__c where sku__c like 'sku%']) {
   			sku2Product.put(p.sku__c, p);
   		}
       
       	Test.startTest();
       	cc_api_Cart api = new cc_api_Cart();
       	api.selectedAggregatedProduct = selectedOption;
       	api.accountId = cc_test_TestDataSetup.testAccount.id;
       	E_Cart__c testCart = api.createEmptyCart();
       	String placeOrderCart1 = api.addToCart(sku2Product.get(bundleProductSKU).id, testCart.id, 1, true, cc_util_CloudCraze.application.Default_Storefront__c);
        
         E_CartItem__c newcartItem = [select id, SubAmount__c, (select id, price__c, quantity__c, SubAmount__c from Cart_Items__r) from E_CartItem__c where cart__c= :testCart.id and product__c=:sku2Product.get(bundleProductSKU).id limit 1];
         cc_hlpr_KitProduct testClass = new cc_hlpr_KitProduct();
         Decimal retVal = testClass.calAggregatedPrice(newcartItem);
        
        system.assert(retVal == 1260);
        Test.stopTest();
    	
    }
}