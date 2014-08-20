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
private class cc_ctrl_test_ProductListDisplayWidget {

    static testMethod void myUnitTest() {
    	cc_test_TestDataSetup.loadData();
    	System.runas(cc_test_TestDataSetup.testUser) {
    	cc_ctrl_ProductListDisplayWidget testClass = new cc_ctrl_ProductListDisplayWidget();
    	List<cc_bean_ProductListViewData> retVal = testClass.getDisplayList();
    	system.assert(retVal != null);
    	system.assert(retVal.size() == 0);
        E_Product__c p = createTestingProductInMemory(cc_util_RandomString.randomUUID());
        cc_dao_Product dao = new cc_dao_Product();
        E_Product__c updatedProduct = dao.saveProduct(p);
        List<Id> idList = new List<Id>();
        idList.add(updatedProduct.id);
        testClass.productIdList = idList;
        retVal = testClass.getDisplayList();
    	}
    }
    
    static E_Product__c createTestingProductInMemory(String sku)
    {
        E_Product__c p = new E_Product__c();
        p.SKU__c = sku;
        p.LongDesc__c = 'This is long description for testinf product';
        p.ShortDesc__c = 'This is short description for testing product';
        p.QuantityPerUnit__c = 1.0;
        p.UnitOfMeasure__c=cc_cnst_PickListConstants.UNITOFMEASURE_EACH;        
        p.ProductStatus__c = cc_cnst_PickListConstants.PRODUCTSTATUS_NOTORDERABLE;
        return p;
    }
}