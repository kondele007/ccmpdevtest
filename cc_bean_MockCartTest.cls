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
public with sharing class cc_bean_MockCartTest {

	static testMethod void mytestcase()
	{
		E_Cart__c cart = new E_Cart__c();
		cc_bean_MockCart mockcart = new cc_bean_MockCart(cart);
		mockcart.cartId = '1';
		cc_bean_MyCartItem cartItem = new cc_bean_MyCartItem();
		cartItem.cart = new E_Cart__c();
		cc_bean_MockCart mockcart1 = new cc_bean_MockCart(cartItem);
		cartItem.billingAddress = new E_ContactAddr__c();
		cartItem.shippingAddress = new E_ContactAddr__c();
		cartItem.getCartStatus();
		cartItem.getShippingName();
		cartItem.getBillingName();
		cartItem.getCartEmail();						
		cc_bean_MockOrder mockOrder = new cc_bean_MockOrder(new E_Order__c());
		cc_bean_MockOrder mockOrder2 = new cc_bean_MockOrder(new cc_bean_MyOrderItem());
		
		String fromPage = cc_cnst_UrlParams.FROM_PAGE;
		String EncId = cc_cnst_UrlParams.ORDER_ENC_ID;
		System.assertEquals(mockCart.cartid, '1');
	}

}