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
private class cc_extn_test_UserInfo {
	 
	/* TODO: reintroduce after adding address book functionality back into userInfo
	static void setupAddresses() {
		insert new list<E_ContactAddr__c> { 
		new E_ContactAddr__c(
				ContactAddrId__c = 'myTestShipTo',
	        	DaytimePhone__c='(847) 555-1212',
	        	FirstName__c='Craig', LastName__c='Traxler',
	        	HomePhone__c='(847) 555-1212',
	        	AddressFirstline__c='100 Pine Street',
	        	City__c='SmallTown',
	        	PostalCode__c='60601',
	        	State__c='Idaho',
	        	StateISOCode__c='ID',
	        	CountryISOCode__c='US'
			),
			 new E_ContactAddr__c(
				ContactAddrId__c = 'myTestBillTo',
	        	DaytimePhone__c='(847) 555-1212',
	        	FirstName__c='Craig', LastName__c='Traxler',
	        	HomePhone__c='(847) 555-1212',
	        	AddressFirstline__c='100 Pine Street',
	        	City__c='SmallTown',
	        	PostalCode__c='60601',
	        	State__c='Idaho',
	        	StateISOCode__c='ID',
	        	CountryISOCode__c='US'
			)
		};   
	}
	
	static testMethod void testLoadSaveAddressFromAddressBook() {
		cc_test_PrepTestData.loadAllCustomSettings();
    	cc_test_PrepTestData.loadInitData();
    	
    	User testPortalUser = cc_test_PrepTestData.insertPortalUser('test1');
	   	System.runAs (testPortalUser) {
	   		cc_extn_test_UserInfo.setupAddresses();
	   		User cUser = cc_api_user.getUserById(userinfo.getUserId());
	   		List<E_AddressBook__c> entries = new List<E_AddressBook__c>();
    		entries.add(new E_AddressBook__c(Account__c = cUser.contact.account.id, E_ContactAddress__r = new E_ContactAddr__c(ContactAddrId__c='myTestBillTo'),
    			AddressType__c  = 'Billing', Default__c  = true, owner__c=userinfo.getuserid()));
    		entries.add(new E_AddressBook__c(Account__c = cUser.contact.account.id, E_ContactAddress__r = new E_ContactAddr__c(ContactAddrId__c='myTestShipTo'),
    			AddressType__c  = 'Shipping', Default__c  = true, owner__c=userinfo.getuserid()));
    		insert entries;
    		cc_api_Cart api = new cc_api_Cart();
    		
        	api.accountId = cUser.contact.account.id;
        	E_Cart__c testCart = api.createEmptyCart();
        	PageReference page = System.Page.CheckoutNew;
        	page.getParameters().put('cartID', testCart.EncryptedId__c);
        	page.getParameters().put('viewState', 'InfoView');
        	Test.setCurrentPage(page);
        	cc_ctrl_CheckOut checkout = new cc_ctrl_CheckOut();
        	cc_extn_UserInfo extn = new cc_extn_UserInfo(checkout);
        	
        	System.assert(extn.query(checkout, cc_ExtensionBase.Query_BillingAddress) != null);
        	System.assert(extn.query(checkout, cc_ExtensionBase.Query_ShippingAddress) != null);
        	System.assert(extn.query(checkout, null) == null);
        	
        	// test getters
        	System.assert(extn.getBillingStateList().size() > 0);
        	System.assert(extn.getBillingStateListCA().size() > 0);
        	System.assert(extn.getShippingStateListCA().size() > 0);
        	System.assert(extn.getShippingStateList().size() > 0);
        	System.assert(extn.getSalutation().size() > 0);
        	
        	// test other methods
        	System.assert(extn.getUserInfo() != null);
        	
        	//extn.loadAddress();
        	System.assertEquals(extn.firstName, 'Test portal user') ;
        	System.assertEquals(extn.lastName, 'Tester') ;
        	System.debug('ryl-->Shipping Address' + extn.shippingAddress);
        	cc_bean_MockContactAddress mockBilling = new cc_bean_MockContactAddress(extn.billingAddress);
        	cc_bean_MockContactAddress mockShipping = new cc_bean_MockContactAddress(extn.shippingAddress);
        	System.assertEquals(extn.emailAddress, 'test1@testorg.com') ;
        	
        	System.debug('ryl-->mockBilling' + mockBilling);
        	System.debug('ryl-->mockShipping' + mockShipping);
        	System.debug('ryl-->billingState = ' + extn.billState);
        	System.debug('ryl-->shipState = ' + extn.shipState);
        	extn.saveAddress();
        	extn.selectedAddressId = extn.shippingAddress.id;
        	extn.selectedAddressType = 'Billing';
        	extn.selectThisAddress();
        	
        	extn.selectedFlag = false;
        	extn.copyBilling2Shipping();
        	//System.assert(extn.billingAddress.City__c != extn.shippingAddress.City__c);
        	extn.selectedFlag = true;
        	extn.copyBilling2Shipping();
        	System.assert(extn.billingAddress.City__c == extn.shippingAddress.City__c);
        	
        	System.assertEquals('(555) 555-5555', extn.formatPhoneNumber('555-555-5555'));
	   	}
	}
	*/
	
	static testMethod void test2() {
    	cc_test_TestDataSetup.loadData();

    	System.RunAs(cc_test_TestDataSetup.testUser) {
	   		
    		cc_api_Cart api = new cc_api_Cart();
        	E_Cart__c testCart = api.createEmptyCart();

        	PageReference page = System.Page.CheckoutNew;
        	page.getParameters().put('cartID', testCart.EncryptedId__c);
        	page.getParameters().put('viewState', 'InfoView');
        	Test.setCurrentPage(page);

        	cc_ctrl_CheckOut checkout = new cc_ctrl_CheckOut();
        	cc_extn_UserInfo extn = new cc_extn_UserInfo(checkout);
        	
        	// test getters and setters
        	System.assert(extn.countryList.size() > 0);
        	System.assert(extn.stateListUS.size() > 0);
        	System.assert(extn.stateListCA.size() > 0);
        	System.assert(extn.salutationList.size() > 0);

    		System.assertNotEquals(null, extn.getName());
    		System.assertEquals(null, extn.gotoStep());
    		System.assertNotEquals(null, extn.getUserInfo());
        	
        	System.assertEquals(null, extn.saveAddress());
	   	}
	}
}