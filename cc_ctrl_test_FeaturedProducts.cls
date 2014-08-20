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
private class cc_ctrl_test_FeaturedProducts {
  
   
    static testMethod void myUnitTest() {
        E_Product__c testP = new E_Product__c(SKU__c='sku1');
        insert testP;
        insert new list<E_FeaturedProduct__c> { new E_FeaturedProduct__c(Product__c=testP.id, type__c='Spotlight', Enabled__c = true),
        	new E_FeaturedProduct__c(Product__c=testP.id, type__c='Featured', Enabled__c = true) };
        
    	cc_ctrl_FeaturedProducts testClass = new cc_ctrl_FeaturedProducts();
        
        system.assert(testClass.featuredProductList != null);
        system.assert(testClass.spotLightProductList != null);
    }
    
}