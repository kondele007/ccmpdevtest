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
private class cc_extn_test_HomePage {

	private static void prepTestData() {
        cc_test_PrepTestData.loadCustomSettings();
        cc_test_PrepTestData.loadInitData();
        cc_test_PrepTestData.loadTestCategoryData();
    }
    
    static testMethod void myUnitTest() {
    	prepTestData();
    	
    	cc_ctrl_HomePage homePageController = new cc_ctrl_HomePage();
        cc_extn_HomePage homePageExtension = new cc_extn_HomePage(homePageController);
        system.assert(homePageExtension != null);
    }
}