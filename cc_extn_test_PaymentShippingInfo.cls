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
private class cc_extn_test_PaymentShippingInfo {

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
      		
    		// constructor
    		cc_ctrl_Checkout controller = new cc_ctrl_Checkout();
    		cc_extn_PaymentShippingInfo extn = new cc_extn_PaymentShippingInfo(controller);
    		
    		// test getters and setters
    		extn.cartBean.paymentMethod = 'cc';
    		System.assertEquals('show', extn.paymentTypeCCDisplayClass);
    		System.assertEquals('hide', extn.paymentTypePODisplayClass);
    		System.assertEquals('hide', extn.paymentTypeInstallmentsDisplayClass);

    		extn.cartBean.paymentMethod = 'po';
    		System.assertEquals('hide', extn.paymentTypeCCDisplayClass);
    		System.assertEquals('show', extn.paymentTypePODisplayClass);
    		System.assertEquals('hide', extn.paymentTypeInstallmentsDisplayClass);

    		extn.cartBean.paymentMethod = 'installments';
    		System.assertEquals('hide', extn.paymentTypeCCDisplayClass);
    		System.assertEquals('hide', extn.paymentTypePODisplayClass);
    		System.assertEquals('show', extn.paymentTypeInstallmentsDisplayClass);
    		 
    		System.assertNotEquals(null, extn.getName());
    		System.assertEquals(null, extn.gotoStep());
    		System.assertNotEquals(null, extn.getPaymentShippingInfo());
    		//System.assertEquals('0.00', extn.getSelectedShipmentValue());
    		//extn.getSelectedShipmentValue();
			System.assert(extn.getPaymentTypes().size() > 0);
    		//System.assertNotEquals(null, extn.getShipOptionsList());
    		//System.assertNotEquals(null, extn.getSelectedShipmentOption());
    		//System.assertNotEquals(null, extn.getDisplayShippingRegion());
    		//System.assertNotEquals(null, extn.getShippingOptionItems());
    		//extn.getShippingOptionItems();
    		//System.assertNotEquals(null, extn.shippingPrice());
    		//extn.shippingPrice();
    		System.assertNotEquals(null, extn.getPaymentTypes());

			// test other methods
			System.assertNotEquals(null, extn.savePayment());
    	}
    }
}