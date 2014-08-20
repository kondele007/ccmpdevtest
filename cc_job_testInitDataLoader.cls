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
private class cc_job_testInitDataLoader {

	
	static testMethod void unitTest() {
		
		
		List<E_product__c> productList = new List<E_product__c> {
			new E_product__c(Name='sku1', SKU__c='sku1', ProductStatus__c='Released'),
			new E_product__c(Name='sku2', SKU__c='sku2', ProductStatus__c='Released'),
			new E_product__c(Name='sku3', SKU__c='sku3', ProductStatus__c='Released'),
			new E_product__c(Name='sku4', SKU__c='sku4', ProductStatus__c='Released'),
			new E_product__c(Name='sku5', SKU__c='sku5', ProductStatus__c='Released'),
			new E_product__c(Name='sku6', SKU__c='sku6', ProductStatus__c='Released'),
			new E_product__c(Name='sku7', SKU__c='sku7', ProductStatus__c='Released'),
			new E_product__c(Name='sku8', SKU__c='sku8', ProductStatus__c='Released'),
			new E_product__c(Name='sku9', SKU__c='sku9', ProductStatus__c='Released'),
			new E_product__c(Name='sku10', SKU__c='sku10', ProductStatus__c='Released')
		};
		
		Test.startTest();
		
		
		cc_job_InitDataLoader testClass = new cc_job_InitDataLoader(productList);
		integer batchSize = 200;
		Database.executeBatch(testClass, batchSize);
		Test.stopTest();
		System.assert(true);
	}
	
}