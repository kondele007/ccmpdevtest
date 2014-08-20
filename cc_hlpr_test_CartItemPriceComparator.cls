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
private class cc_hlpr_test_CartItemPriceComparator {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        cc_hlpr_CartItemPriceComparator cartItemPriceInstance=new cc_hlpr_CartItemPriceComparator();
        
        E_CartItem__c cartItemInstance1=new E_CartItem__c();
        cartItemInstance1.Price__c=23;
        
        E_CartItem__c cartItemInstance2=new E_CartItem__c();
        cartItemInstance2.Price__c=23;
               
        System.assertEquals(0,cartItemPriceInstance.compare(cartItemInstance1, cartItemInstance2));
        
        cartItemInstance2.Price__c=45;
        System.assertEquals(-1,cartItemPriceInstance.compare(cartItemInstance1, cartItemInstance2));
         
        cartItemInstance2.Price__c=21;
        System.assertEquals(1,cartItemPriceInstance.compare(cartItemInstance1, cartItemInstance2));
               
    }
}