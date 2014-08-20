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
private class cc_test_ExtensionBase {
	private static String TEST_NUMBER = 'testNumber';
	
	class TestExtension extends cc_ExtensionBase {
		public Integer testNumber;
		public override string getName() { return 'TestExtension'; }
		public TestExtension(cc_ctrl_CloudCraze c) { super(c); }
	}
	
    static testMethod void myUnitTest() {
    	cc_test_TestDataSetup.loadData();
    	cc_ctrl_CloudCraze controller = new cc_ctrl_CloudCraze();
    	TestExtension ext1 = new TestExtension(controller);
    	System.assert(ext1 != null);
    	ext1.notify(null);
    	ext1.notify(null, '', null);
    	ext1.query(null, '');
    }
}