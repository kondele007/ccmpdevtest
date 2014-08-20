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
private class cc_api_test_JsonCategory {

    static testMethod void unitTest1() { 
    	cc_test_TestDataSetup.LoadData();
    	cc_test_TestDataSetup.loadCompositeProducts();
    	
    	E_Category__c root = [select id from E_Category__c where CategoryID__c=:cc_cnst_CloudCraze.DEFAULT_ROOT_CATEGORY_ID limit 1];
    	
    	E_Category__c directChild = [select id from E_Category__c where CategoryID__c='directChild' limit 1];
    	E_Category__c Handsets = [select id from E_Category__c where CategoryID__c='Handsets' limit 1];
    	
    	E_Product__c p = [select id from E_Product__c where sku__c='sku0014' limit 1];
    	Test.startTest(); 
    	System.assert(cc_api_JsonCategory.childCategories('source') != null);
    	System.assert(cc_api_JsonCategory.childCategories(Handsets.id) != null);
    	System.assert(cc_api_JsonCategory.addCategory(directChild.id, 'newChildCategory', 'newChildCategory') != null);
    	System.assert(cc_api_JsonCategory.addCategoryToRoot('newChildCategory2', 'newChildCategory2') != null);
    	E_Category__c newChildCategory2 = [select id from E_Category__c where Name='newChildCategory2' limit 1];
    	cc_api_JsonCategory.changeCategory(p.id, Handsets.id, directChild.id);
    	cc_api_JsonCategory.changeParent(Handsets.id, newChildCategory2.id);
    	 
    	System.assert(cc_api_JsonCategory.addProduct(root.id, 'newSku001', 'newSku001', 'newSku001', 'newSku001', 120.0, 'Regular', 'Released') != null); 
    	System.assert(cc_api_JsonCategory.addProduct(root.id, 'sku003', 'sku003', 'sku003', 'sku003', 120.0, 'Regular', 'Released') != null);
    	System.assert(cc_api_JsonCategory.addExistingProduct(root.id, 'sku004') != null);
    	
    	Test.stopTest(); 
	}
	
	static testMethod void unitTest2() { 
    	cc_test_TestDataSetup.LoadData();
    	cc_test_TestDataSetup.loadCompositeProducts();
    	E_Category__c root = [select id from E_Category__c where CategoryID__c= :cc_cnst_CloudCraze.DEFAULT_ROOT_CATEGORY_ID limit 1];
    	E_Product__c p = [select id from E_Product__c where sku__c='sku0014' limit 1];
    	E_Product__c bundleProduct = [select id from E_Product__c where sku__c='sku001' limit 1];
    	
    	Test.startTest();
    	System.assert(cc_api_JsonCategory.addBundleProduct(root.id, 'newSku002', 'newSku002', 'newSku002', 'newSku002', 120.0) != null); 
    	System.assert(cc_api_JsonCategory.addBundleProduct(root.id, 'sku001', 'sku001', 'sku001', 'sku001', 120.0) != null);
    	
    	System.assert(cc_api_JsonCategory.bundleProducts(bundleProduct.id) != null);
    	System.assert(cc_api_JsonCategory.addBundleProductItem(bundleProduct.id, p.id, 1, true, root.id) != null);
    	E_CompositeProduct__c comp1 = [select id from E_CompositeProduct__c where Composite__c=:bundleProduct.id and Component__c= :p.id limit 1];
    	System.assert(cc_api_JsonCategory.updateBundleProductItem(comp1.id, 2, false) != null);
    	
    	System.assert(cc_api_JsonCategory.deleteBundleProduct(root.id, p.id) != null);
    	System.assert(cc_api_JsonCategory.deleteBundleProductItem(bundleProduct.id) != null);
    	
    	Test.stopTest();
	}
}