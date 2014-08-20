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
private class cc_hlpr_test_CompositeProductHelperBase {

    private class myCompositeProductHelperBaseTest extends cc_hlpr_CompositeProductHelperBase {
         
    } 
  
    static testMethod void testCalAggregatedPrice() {
        cc_hlpr_CompositeProductHelperBase cc_hlpr_CompositeProductHelperBase = new myCompositeProductHelperBaseTest();
        E_CartItem__c cartItem = new E_CartItem__c();
        cartItem.Price__c = 10;
        cartItem.SubAmount__c = 10;
        Decimal cartItemPrice = cc_hlpr_CompositeProductHelperBase.calAggregatedPrice(cartItem);
        System.debug('-----cc_hlpr_test_CompositeProductHelperBase.testCalAggregatedPrice-cartItemPrice----- = ' + cartItemPrice);
        System.assertEquals(cartItemPrice, 10);  
    }
    
    static testMethod void testAddComponentProductsToCart() {
        cc_hlpr_CompositeProductHelperBase cc_hlpr_CompositeProductHelperBase = new myCompositeProductHelperBaseTest();
        E_CartItem__c cartItem = new E_CartItem__c();
        cartItem.Price__c = 10;
        Map<String, String> selectedAggregate = new Map<String, String>();
//        Account testAccount = new Account();
//        testAccount.Name = 'testaccount';
//        insert testAccount;
	cc_api_dl_accountGroups ag = new cc_api_dl_accountGroups();
	ag.loadData();

	RecordType rt = [Select r.Name, r.Id From RecordType r where r.Name = 'Person Account' limit 1];
		
	Account testAccount = new Account(FirstName = '', LastName='testaccount', RecordTypeID = rt.Id, E_AccountGroup__r= new E_AccountGroup__c(ACCOUNTGROUPID__C='1'), OwnerId=userInfo.getUserId());
	insert testAccount;

        //System.debug('-----cc_hlpr_test_CompositeProductHelperBase.testAddComponentProductsToCart-testAccount---- : ' + testAccount); 
        cc_hlpr_CompositeProductHelperBase.addComponentProductsToCart(cartItem, testAccount.Id,Date.today(), 'USD', 'Portal', false, selectedAggregate);
        //System.debug('-----cc_hlpr_test_CompositeProductHelperBase.testAddComponentProductsToCart-----');
   		//System.assert(testAccount.Name == 'testaccount');
    }    
}