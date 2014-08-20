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
private class cc_ctrl_test_MyOrderList {

   static testMethod void myUnitTest() {
	 	cc_test_TestDataSetup.loadData();
		insert new list<e_product__c>{new e_product__c(SKU__c='sku1', name='sku1'), new e_product__c(SKU__c='sku2', name='sku2'),
			new e_product__c(SKU__c='sku3', name='sku3'),  new e_product__c(SKU__c='sku4', name='sku4')};
		E_ContactAddr__c shipTo = new E_ContactAddr__c(
        AddressFirstline__c='100 Pine Street', City__c='SmallTown', DaytimePhone__c='(847) 555-1212',
        FirstName__c='Craig', HomePhone__c='(847) 555-1212', LastName__c='Traxler',
        PostalCode__c='60601', State__c='Idaho', StateISOCode__c='ID',
        CountryISOCode__c='USA');
        insert shipTo;
        E_ContactAddr__c billTo = new E_ContactAddr__c(
        AddressFirstline__c='100 Pine Street', City__c='SmallTown', DaytimePhone__c='(847) 555-1212',
        FirstName__c='Craig', HomePhone__c='(847) 555-1212', LastName__c='Traxler',
        PostalCode__c='60601', State__c='Idaho', StateISOCode__c='ID',
        CountryISOCode__c='USA');
        insert billTo;
		System.runAs(cc_test_TestDataSetup.testUser) {
			PageReference pr = system.page.MyAccount;
			Test.setCurrentPage(pr);
			cc_ctrl_MyAccount myAccount = new cc_ctrl_MyAccount(); 
			cc_ctrl_MyOrderList mol = new cc_ctrl_MyOrderList();
			system.assert(mol.getMyOrderController() != null);
			mol.myAccountController = myAccount;
			List<SelectOption> sol = mol.statusCodes;
			E_Cart__c testCart = new E_Cart__c(SessionID__c='anySessionId', Name__c='testCart', CartType__c=cc_cnst_PickListConstants.CARTTYPE_CART, billto__c=billto.id, shipto__c=shipto.id,
							CartStatus__c='Open', AnonymousID__c=false, User__c=UserInfo.getUserId());
			insert testCart;
			List<E_CartItem__c> cartItems = new List<E_CartItem__c> {
				new E_CartItem__c(Quantity__c=1, product__r=new E_Product__c(SKU__c='sku1'), cart__c=testCart.id, price__c=100, SubAmount__c=100.0, cartItemType__c='Major'),
				new E_CartItem__c(Quantity__c=1, product__r=new E_Product__c(SKU__c='sku2'), cart__c=testCart.id, price__c=100, SubAmount__c=100.0, cartItemType__c='Minor'),
				new E_CartItem__c(Quantity__c=1, product__r=new E_Product__c(SKU__c='sku3'), cart__c=testCart.id, price__c=100, SubAmount__c=100.0, cartItemType__c='Major'),
				new E_CartItem__c(Quantity__c=1, product__r=new E_Product__c(SKU__c='sku4'), cart__c=testCart.id, price__c=100, SubAmount__c=100.0, cartItemType__c='Minor')
			};
			insert cartItems;
			cc_api_cart api = new cc_api_cart();
			Id orderId = api.placeOrder(testCart.id);
			mol.selectedOrderNumber=orderId;
			mol.displayOrderSummary();
			system.debug('ryl--->' + mol.selectedOrderNumber);
			List<cc_bean_MyOrderItem> ol = mol.getOrderList();
			List<cc_bean_MockOrder> mockOrderList = mol.getMockOrderList();
			List<cc_bean_MyOrderItem> molis = mol.pageOrders;
			cc_bean_MyOrderItem so = mol.selectedOrder;
			mol.searchOrders();
			
		}
	 }
}