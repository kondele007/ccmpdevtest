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
private class cc_hlpr_test_BundleProduct {
	 
    static testMethod void myUnitTest() {
    	String bundleProductSKU='sku001';
    	cc_test_TestDataSetup.loadData();
    	System.assert([Select c.Id From E_ApplicationSettings__c c where name='CloudCraze'].size() != 0);
    	cc_test_TestDataSetup.loadCompositeProducts(); 
    	Map<String, string> selectedOption = cc_test_TestDataSetup.getSelectedAggregatedProduct();
    	System.debug('ryl-selectedOption-->' + selectedOption);
    	System.debug('ryl-account id-->' + cc_test_TestDataSetup.testAccount.id);
    	String prodStatus=cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED;
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
       
        Test.stopTest();
    }
}