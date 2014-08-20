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
private class cc_extn_test_ProductCatalog {

    static testMethod void myUnitTest() {
    	cc_test_TestDataSetup.loadData();
    	System.RunAs(cc_test_TestDataSetup.testUser) {
    		// insert mock cart
      		E_Cart__c cart = (new cc_api_Cart()).createEmptyCart('USD', 'Commercial');	
      		List<E_Product__c> productList = cc_test_PrepTestData.insertProduct(5);
      		List<E_CartItem__c> items = cc_test_PrepTestData.insertCartItems(productList,cart.id);
      		for (E_CartItem__c item : items) { item.Subamount__c = 2.00; }
      		update items;
      		ApexPages.currentPage().getParameters().put('cartID',cart.EncryptedId__c);
      
      		// construct
    		cc_ctrl_Checkout controller = new cc_ctrl_Checkout();
			cc_extn_ProductCatalog extn = new cc_extn_ProductCatalog(controller);
			
			// test query
			extn.currentProductID = productList[0].id;
			System.assertEquals(productList[0].id, extn.query(controller, cc_extensionBase.Query_ProductIdId));
			System.assertEquals(null, extn.query(controller, null));
			
			System.assert(extn.quickSearch() != null);
			System.assert(extn.getProductCatalog() != null);
    	}
    }
}