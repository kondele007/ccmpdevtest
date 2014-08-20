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
private class cc_extn_test_cart {
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
    		cc_extn_cart cartExt = new cc_extn_cart();
			cartExt = new cc_extn_cart(controller);
			
			// test notify
			cc_bean_MockContactAddress tBillingAddress = new cc_bean_MockContactAddress();
			tBillingAddress.city = 'city';
			cartExt.notify(controller, cc_cnst_CloudCraze.NT_BillingAddress, tBillingAddress);
			System.assertEquals('city', cartExt.tBillingAddress.city);
			
			cc_bean_MockContactAddress tShippingAddress = new cc_bean_MockContactAddress();
			tShippingAddress.city = 'city';
			cartExt.notify(controller, cc_cnst_CloudCraze.NT_ShippingAddress, tShippingAddress);
			System.assertEquals('city', cartExt.tShippingAddress.city);
			
			String poNumber = 'po';
			cartExt.notify(controller, cc_cnst_CloudCraze.NT_PONumber, poNumber);
			System.assertEquals('po', cartExt.poNumber);
			
			String selectedPaymentType = 'spt';
			cartExt.notify(controller, cc_cnst_CloudCraze.NT_SelectedPaymentType, selectedPaymentType);
			System.assertEquals('spt', cartExt.selectedPaymentType);
			
			cc_ctrl_hlpr_ShippingOption shippingOption = new cc_ctrl_hlpr_ShippingOption('provider', 'servicename', 0);
			cartExt.notify(controller, cc_cnst_CloudCraze.NT_SelectedShippingOptionObj, shippingOption);
			System.assertEquals('provider', cartExt.tSelectedShippingOptionObj.provider);

			// test other methods
			System.assert(cartExt.getCartInfo() != null);
			System.assert(cartExt.getName() == cc_extn_cart.name);
			System.assert(cartExt.getCartExtension() != null);
			System.assert(cartExt.getCartListViewData() != null);
			System.assertEquals(5, cartExt.getCCCartItemCount());
			System.assertEquals('10.00', cartExt.getCCCartTotal());
			System.assertEquals('10.00', cartExt.totalAmount);
			System.assert(cartExt.mergeCart() == null);
			System.assert(cartExt.editCart() != null);
			//System.assert(cartExt.buildCartListViewData2().size() > 0);
			cartExt.getCartListViewData();
			System.assert(cartExt.taxAmount == '0.00');
			System.assert(!cartExt.validInventory);
			//System.assert(cartExt.placeOrder() != null);
			cartExt.placeOrder();
    	}
    }
}