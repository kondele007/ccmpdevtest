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
private class cc_ctrl_test_CyberSourceHOP {

    static testMethod void myUnitTest() {
    	cc_test_PrepTestData.loadCustomSettings();
        //cc_ctrl_CyberSourceHOP controller = new cc_ctrl_CyberSourceHOP();
        //controller.transactionType = 'test';
        //controller.amount = '100.0';
        //controller.currencyString = 'USD';
        //controller.timeString='1/1/1970';
        //controller.publicDigest = '123456';
        //controller.publicSubscriptionDigest='123456';
        //controller.billingphone = '123-345-8888';
        //controller.Shippingphone='123-456-789';
        //controller.currentCartID = '123';
        //controller.cart = new e_cart__c();
        //controller.ipAddressLocation = '123';
        //controller.billingAddress = new cc_bean_MockContactAddress(new E_ContactAddr__c());
        //controller.shippingAddress = new cc_bean_MockContactAddress(new E_ContactAddr__c());
		//System.AssertEquals(controller.transactionType, 'test');
		//System.AssertEquals(controller.amount, '100.0');
        //System.AssertEquals(controller.currencyString , 'USD');
        //System.AssertEquals(controller.timeString,'1/1/1970');
        //System.AssertEquals(controller.publicDigest , '123456');
        //System.AssertEquals(controller.publicSubscriptionDigest,'123456');
        //System.AssertEquals(controller.billingphone , '123-345-8888');
        //System.AssertEquals(controller.Shippingphone,'123-456-789');
        //System.AssertEquals(controller.currentCartID , '123');
        //System.AssertNotEquals(null, controller.cart );
        //System.AssertEquals(controller.ipAddressLocation , '123');
		
    	//System.AssertNotEquals(null, controller.ipAddressLocationKey);
        //System.AssertNotEquals(null, controller.getPrivateKey());
        //System.AssertNotEquals(null, controller.getSerialNumber());
        //controller.getSerialNumber();
        //controller.currencyString = null;
        //System.AssertNotEquals(null, controller.getPublicDigest());
        //controller.getPublicDigest();
        //System.AssertNotEquals(null, controller.getPublicSubscriptionDigest());
        //controller.getPublicSubscriptionDigest();
        //controller.createSubscriptionSignature();
        //controller.createSubscriptionSignature();
        //controller.createSignature();
        //controller.createSignature();
        
    }
    static testMethod void cartTest1() {
        cc_test_PrepTestData.loadCustomSettings();
        //System.assert([Select c.Id From E_ApplicationSettings__c c where name='CloudCraze'].size() != 0);
        cc_test_PrepTestData.loadInitData();
        cc_test_PrepTestData.loadTestCategoryData();
        User u = cc_api_User.getCurrentUser;
        Test.startTest();

        cc_api_Cart api = new cc_api_Cart();        
        E_Cart__c cart = api.createEmptyCart('USD', 'Commercial');
        List<E_Product__c> productList = cc_test_PrepTestData.insertProduct(5);
        for(E_Product__c prod:productList){
            api.addToCart(prod.Id, cart.Id, 1,false, 'USD', 
                          'Commercial', cc_util_CloudCraze.application.Default_Storefront__c);
        }
        E_ContactAddr__c address = new E_ContactAddr__c(
        AddressFirstline__c='100 Pine Street', City__c='SmallTown', DaytimePhone__c='(847) 555-1212',
        FirstName__c='Craig', HomePhone__c='(847) 555-1212', LastName__c='Traxler',
        PostalCode__c='60601', State__c='Idaho', StateISOCode__c='ID',
        CountryISOCode__c='US');
        ID id = cc_dao_AddressBook.saveAddressDetails(address);
        cart.BillTo__c = address.Id;
        cart.ShipTo__c = address.Id;
        update cart;
        Test.setCurrentPage(Page.HOPIFrame);
        ApexPages.currentPage().getParameters().put('cartID', cart.EncryptedId__c);
       	cc_ctrl_CyberSourceHOP controller = new cc_ctrl_CyberSourceHOP();
       	System.debug(controller.billingAddress);
       	System.debug(controller.shippingAddress);
       	controller.processCart();
        Test.stopTest();
    }
}