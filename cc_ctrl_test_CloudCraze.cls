@isTest
private class cc_ctrl_test_CloudCraze {
	private static String TEST_NUMBER = 'testNumber';
	
	class TestExtension extends cc_ExtensionBase {
		public Integer testNumber;
		
		public override string getName() { return 'TestExtension'; }
		public TestExtension(cc_ctrl_CloudCraze c) { super(c); }
		
		public override void notify(Object subject, String notificationType, Object notificationValue) {
			if (notificationType.equalsIgnoreCase(TEST_NUMBER)) {
				testNumber = (Integer) notificationValue;
			}
		}

		public override Object query(Object subject, String q) {
			if (q.equalsIgnoreCase(TEST_NUMBER)) {
				return testNumber;
			}
			return null;
		}

	}
	
    static testMethod void testConstructor() {
    	cc_test_TestDataSetup.loadData();
    	System.RunAs(cc_test_TestDataSetup.testUser){
    	E_StorefrontSettings__c setting = new E_StorefrontSettings__c(
    	  name='ab',
    	  Site_Secure_Domain__c='www.salesforce.com'
    	);
    	insert setting;
    	cc_ctrl_CloudCraze nullStore = new cc_ctrl_CloudCraze();
    	ApexPages.currentPage().getParameters().put('store','ab');
    	cc_ctrl_CloudCraze controller = new cc_ctrl_CloudCraze();
    	System.assertEquals('ab',controller.storeID);
    	System.assertEquals('https://www.salesforce.com/ab/',controller.storeSSLUrl);
    	}
    }
    
    static testMethod void myUnitTest() {
    	cc_test_TestDataSetup.loadData();
    	cc_ctrl_CloudCraze controller = new cc_ctrl_CloudCraze();
    	TestExtension ext1 = new TestExtension(controller);
    	
    	// test add/get
    	System.assert(controller.getExtension('TestExtension') != null);

    	// test query
    	ext1.testNumber = 1;
    	List<Object> testNumbers = controller.queryChildren(TEST_NUMBER);
    	Integer sum = 0;
    	for (Object num : testNumbers) {
    		System.debug('sns num = ' + (Integer) num);
    		sum += (Integer) num;
    	}
    	System.assertEquals(1, sum);
    	
    	// test notify
    	controller.notifyChildren();
    	controller.notifyChildren(TEST_NUMBER, 4);
    	System.assertEquals(4, ext1.testNumber);
    	
    	// test remove
    	System.assert(controller.removeExtension('TestExtension') != null);
    	System.assert(controller.removeExtension('non-existent') == null);
    	
    	// test other methods
    	System.assert(controller.getCloudCrazeController() != null);
    	System.assert(controller.userLocale != null);
    	
    	String siteUrl = controller.currentSiteUrl; //just for test coverage
    }
}