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
private class cc_ctrl_test_promotionExtension {

    static testMethod void myUnitTest() {
        cc_test_TestDataSetup.LoadData();
        System.assert([Select c.Id From E_ApplicationSettings__c c where name='CloudCraze'].size() != 0);
    	System.runas(cc_test_TestDataSetup.testUser) {
	        PageReference pageRef = Page.Products;
	        Test.setCurrentPage(pageRef);
	        cc_ctrl_HomePage controller = new cc_ctrl_HomePage();
	        cc_ctrl_promotion promotion = new cc_ctrl_promotion(controller);
	        ApexPages.currentPage().getParameters().put('viewState', 'CartView');
	        cc_api_Cart capi = new cc_api_Cart();
	        E_Cart__c cart = capi.createEmptyCart();
	        ApexPages.currentPage().getParameters().put('cartID', cart.EncryptedId__c);
	        promotion.getPromotionBeanMap('CartView');
	        promotion.getPromotionBeanMapList('CartView');
	        cc_ctrl_promotionExtension ext = new cc_ctrl_promotionExtension();
	        ext.parentController = promotion;
	        ext.outerController = promotion;
	        ext.locationType = 'Landing Page';
	        ext.getPromotions();
	        ext.getImageUri();
	        ext.getImageSource();
	        ext.getAltMsg();
	        ext.getPageType();
    	}
    }
}