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
private class KapUtilTest {
	
    static testMethod void testPositive_getNextTicketId() {
    	// Load Test Data
    	// Add 'Test User' to User table
    	User testUser = KapTestUtil.createTestUser();
    	System.runAs(testUser) {
	    	// Add 'Test Queue' to Queue table
	    	Group testQueue = KapTestUtil.createTestQueue();
	    	//KapTestUtil.createTestQueueSObject(testQueue);
	    	// Add 'Test User' to 'Test Queue' in GroupMember table
	    	GroupMember testQueueMember = KapTestUtil.createQueueMember(testQueue.Id, testUser.Id);
	    	// Add 'Test Queue' to Queue_Detail__c table
	    	Queue_Detail__c testQueuePriority = KapTestUtil.createQueuePriority();
	    	// Add 'Test Case' to Case table with owner = 'Test Queue'
	    	Case testCase = KapTestUtil.createTestCase(testQueue.Id);
	
	    	test.startTest();
	    	
	    	Id id = KapUtil.getNextTicketId(testUser.Id);
	    	
	    	test.stopTest();
    	}
    }
    
    static testMethod void testNegative_getNextTicketId_NO_USER() {
    	// Load Test Data
    	// Add 'Test User' to User table
    	//User testUser = KapTestUtil.createTestUser();
    	User testUser = new User();
    	User sysAdminUser = KapTestUtil.getSystemAdminTestUser();
    	System.runAs(sysAdminUser) {
	    	// Add 'Test Queue' to Queue table
	    	Group testQueue = KapTestUtil.createTestQueue();
	    	//KapTestUtil.createTestQueueSObject(testQueue);
	    	// Add 'Test User' to 'Test Queue' in GroupMember table
	    	//GroupMember testQueueMember = KapTestUtil.createQueueMember(testQueue.Id, testUser.Id);
	    	// Add 'Test Queue' to Queue_Detail__c table
	    	Queue_Detail__c testQueuePriority = KapTestUtil.createQueuePriority();
	    	// Add 'Test Case' to Case table with owner = 'Test Queue'
	    	Case testCase = KapTestUtil.createTestCase(testQueue.Id);
	
	    	test.startTest();
	    	
	    	Id id = KapUtil.getNextTicketId(testUser.Id);
	    	
	    	test.stopTest();
	    }
    }
    
    
    static testMethod void testNegative_getNextTicketId_NO_QUEUE_MEMBER() {
    	// Load Test Data
    	// Add 'Test User' to User table
    	User testUser = KapTestUtil.createTestUser();
    	System.runAs(testUser) {
	    	// Add 'Test Queue' to Queue table
	    	Group testQueue = KapTestUtil.createTestQueue();
	    	//KapTestUtil.createTestQueueSObject(testQueue);
	    	// Add 'Test User' to 'Test Queue' in GroupMember table
	    	GroupMember testQueueMember = KapTestUtil.createQueueMember(testQueue.Id, testUser.Id);
	    	// Add 'Test Queue' to Queue_Detail__c table
	    	Queue_Detail__c testQueuePriority = KapTestUtil.createQueuePriority();
	    	// Add 'Test Case' to Case table with owner = 'Test Queue'
	    	Case testCase = KapTestUtil.createTestCase(testQueue.Id);
	
	    	test.startTest();
	    	
	    	Id id = KapUtil.getNextTicketId(testUser.Id);
	    	
	    	test.stopTest();
    	}
    }
    
    
    static testMethod void testNegative_getNextTicketId_NO_QUEUE() {
    	// Load Test Data
    	// Add 'Test User' to User table
    	User testUser = KapTestUtil.createTestUser();
    	System.runAs(testUser) {
	    	// Add 'Test Queue' to Queue table
	    	Group testQueue = KapTestUtil.createTestQueue();
	    	// Add 'Test User' to 'Test Queue' in GroupMember table
	    	GroupMember testQueueMember = KapTestUtil.createQueueMember(testQueue.Id, testUser.Id);
	    	// Add 'Test Queue' to Queue_Detail__c table
	    	Queue_Detail__c testQueuePriority = KapTestUtil.createQueuePriority();
	    	// Add 'Test Case' to Case table with owner = 'Test Queue'
	    	Case testCase = KapTestUtil.createTestCase(testQueue.Id);
	
	    	test.startTest();
	    	
	    	Id id = KapUtil.getNextTicketId(testUser.Id);
	    	
	    	test.stopTest();
    	}
    }
    
    
    static testMethod void testNegative_getNextTicketId_NO_QUEUE_PRIORITY() {
    	// Load Test Data
    	// Add 'Test User' to User table
    	User testUser = KapTestUtil.createTestUser();
    	System.runAs(testUser) {
	    	// Add 'Test Queue' to Queue table
	    	Group testQueue = KapTestUtil.createTestQueue();
	    	// Add 'Test User' to 'Test Queue' in GroupMember table
	    	GroupMember testQueueMember = KapTestUtil.createQueueMember(testQueue.Id, testUser.Id);
	    	// Add 'Test Queue' to Queue_Detail__c table
	    	//Queue_Detail__c testQueuePriority = KapTestUtil.createQueuePriority();
	    	// Add 'Test Case' to Case table with owner = 'Test Queue'
	    	Case testCase = KapTestUtil.createTestCase(testQueue.Id);
	
	   		test.startTest();
	    	
	    	Id id = KapUtil.getNextTicketId(testUser.Id);
	    	
	    	test.stopTest();
    	}
    }
    
    static testMethod void testNegative_getNextTicketId_NO_CASE() {
    	// Load Test Data
    	// Add 'Test User' to User table
    	User testUser = KapTestUtil.createTestUser();
    	System.runAs(testUser) {
	    	// Add 'Test Queue' to Queue table
	    	Group testQueue = KapTestUtil.createTestQueue();
	    	// Add 'Test User' to 'Test Queue' in GroupMember table
	    	GroupMember testQueueMember = KapTestUtil.createQueueMember(testQueue.Id, testUser.Id);
	    	// Add 'Test Queue' to Queue_Detail__c table
	    	Queue_Detail__c testQueuePriority = KapTestUtil.createQueuePriority();
	    	// Add 'Test Case' to Case table with owner = 'Test Queue'
	    	//Case testCase = KapTestUtil.createTestCase(testQueue.Id);
	
	    	test.startTest();
	    	
	    	Id id = KapUtil.getNextTicketId(testUser.Id);
	    	
	    	test.stopTest();
    	}
    }
    
    
    
    static testMethod void testPositive_assignTicketToUser() {
    	// Load Test Data
    	// Add 'Test User' to User table
    	User testUser = KapTestUtil.createTestUser();
    	System.runAs(testUser) {
	    	// Add 'Test Queue' to Queue table
	    	Group testQueue = KapTestUtil.createTestQueue();
	    	// Add 'Test User' to 'Test Queue' in GroupMember table
	    	GroupMember testQueueMember = KapTestUtil.createQueueMember(testQueue.Id, testUser.Id);
	    	// Add 'Test Queue' to Queue_Detail__c table
	    	Queue_Detail__c testQueuePriority = KapTestUtil.createQueuePriority();
	    	// Add 'Test Case' to Case table with owner = 'Test Queue'
	    	Case testCase = KapTestUtil.createTestCase(testQueue.Id);
	
	    	test.startTest();
	    	
	    	KapUtil.assignTicketToUser(testCase.Id, testUser.Id);
	    	
	    	test.stopTest();
    	}
    	
    }
    
    static testMethod void testNegative_assignTicketToUser_NO_CASE() {
    	// Load Test Data
    	// Add 'Test User' to User table
    	User testUser = KapTestUtil.createTestUser();
    	System.runAs(testUser) {
	    	// Add 'Test Queue' to Queue table
	    	Group testQueue = KapTestUtil.createTestQueue();
	    	// Add 'Test User' to 'Test Queue' in GroupMember table
	    	GroupMember testQueueMember = KapTestUtil.createQueueMember(testQueue.Id, testUser.Id);
	    	// Add 'Test Queue' to Queue_Detail__c table
	    	Queue_Detail__c testQueuePriority = KapTestUtil.createQueuePriority();
	    	// Add 'Test Case' to Case table with owner = 'Test Queue'
	    	Case testCase = new Case();
	
	    	test.startTest();
	    	
	    	try {
	    		KapUtil.assignTicketToUser(testCase.Id, testUser.Id);
	    	} catch (KapException ke) {
	    	}
	    	
	    	test.stopTest();
    	}
    }
    
    static testMethod void testNegative_assignTicketToUser_NO_USER() {
    	// Load Test Data
    	// Add 'Test User' to User table
    	User testUser = new User();
    	User sysAdminUser = KapTestUtil.getSystemAdminTestUser();
    	System.runAs(sysAdminUser) {
	    	// Add 'Test Queue' to Queue table
	    	Group testQueue = KapTestUtil.createTestQueue();
	    	//KapTestUtil.createTestQueueSObject(testQueue);
	    	// Add 'Test User' to 'Test Queue' in GroupMember table
	    	//GroupMember testQueueMember = KapTestUtil.createQueueMember(testQueue.Id, testUser.Id);
	    	// Add 'Test Queue' to Queue_Detail__c table
	    	//Queue_Detail__c testQueuePriority = KapTestUtil.createQueuePriority();
	    	// Add 'Test Case' to Case table with owner = 'Test Queue'
	    	Case testCase = KapTestUtil.createTestCase(testQueue.Id);
	
	    	test.startTest();
	    	
	    	try {
	    		KapUtil.assignTicketToUser(testCase.Id, testUser.Id);
	    	} catch (KapException ke) {
	    	}
	    	
	    	test.stopTest();
    	}
    }
    
    
	static testMethod void testPositive_getEncryptedKapTestLoginName() {
    	// Load Test Data
    	// Add 'Test User' to User table
    	User testUser = KapTestUtil.createTestUser();

    	test.startTest();
    	
    	KapUtil.getEncryptedKapTestLoginName(testUser.Id);
    	
    	test.stopTest();
    }
    
    
    static testMethod void testNegative_getEncryptedKapTestLoginName_NO_USER() {
    	// Load Test Data
    	// Add 'Test User' to User table
    	User testUser = new User();

    	test.startTest();
    	
    	try {
    		KapUtil.getEncryptedKapTestLoginName(testUser.Id);
    	} catch (KapException ke) {
    	}
    	
    	test.stopTest();
    }
    
    
	static testMethod void testPositive_getEncryptedKapTestLoginNameForStudent() {
    	// Load Test Data
    	// Add 'Test Account' to Account table
    	Account testAccount = KapTestUtil.createTestAccount();

    	test.startTest();
    	
    	KapUtil.getEncryptedKapTestLoginNameForStudent(testAccount.Id);
    	
    	test.stopTest();
    }
    
    
    static testMethod void testNegative_getEncryptedKapTestLoginNameForStudent_NO_STUDENT() {
    	// Load Test Data
    	// Add 'Test User' to User table
    	Account testAccount = new Account();

    	test.startTest();
    	
    	try {
    		KapUtil.getEncryptedKapTestLoginNameForStudent(testAccount.Id);
    	} catch (KapException ke) {
    	} catch (Exception e) {
    	}
    	
    	test.stopTest();
    }
    
    
	static testMethod void testPositive_getEncryptedKapTestLoginNameForUser() {
    	// Load Test Data
    	// Add 'Test User' to User table
    	User testUser = KapTestUtil.createTestUser();

    	test.startTest();
    	
    	KapUtil.getEncryptedKapTestLoginNameForUser(testUser.Id);
    	
    	test.stopTest();
    }
    
    
    static testMethod void testNegative_getEncryptedKapTestLoginNameForUser_NO_STUDENT() {
    	// Load Test Data
    	// Add 'Test User' to User table
    	User testUser = new User();
 
    	test.startTest();
    	
    	try {
    		KapUtil.getEncryptedKapTestLoginNameForUser(testUser.Id);
    	} catch (KapException ke) {
    	} catch (Exception e) {
    	}
    	
    	test.stopTest();
    }
    
    
	static testMethod void testPositive_getShipmentTrackingURL() {
    	// Load Test Data
    	String trackingNo = '123123123123';

    	test.startTest();
    	
    	KapUtil.getShipmentTrackingURL(trackingNo);
    	
    	test.stopTest();
    }
    
    
    static testMethod void testNegative_getShipmentTrackingURL_NO_TRACKING_NUM() {
    	// Load Test Data
    	String trackingNo;

    	test.startTest();
    	
    	KapUtil.getShipmentTrackingURL(trackingNo);
    	
    	test.stopTest();
    }
    
    
    static testMethod void test_handleNullString() {
    	// Load Test Data
    	String NullString;
    	String NotNullString = 'This is a Not Null string.';

    	test.startTest();
    	
    	KapUtil.handleNullString(NullString);
    	KapUtil.handleNullString(NotNullString);
    	
    	test.stopTest();
    }
    
    
    static testMethod void test_truncateSFDCUserNameSuffix() {
    	// Load Test Data
    	String NullString;
    	String sfdcUserNameString = 'testuser@kaplan.com';

    	test.startTest();
    	
    	KapUtil.truncateSFDCUserNameSuffix(NullString);
    	KapUtil.truncateSFDCUserNameSuffix(sfdcUserNameString);
    	
    	test.stopTest();
    }
    
    
    static testMethod void test_BooleanStringToIntegerString() {
    	// Load Test Data
    	String NullString;
    	String trueBooleanString = 'true';
    	String falseBooleanString = 'false';

    	test.startTest();
    	
    	KapUtil.BooleanStringToIntegerString(NullString);
    	KapUtil.BooleanStringToIntegerString(trueBooleanString);
    	KapUtil.BooleanStringToIntegerString(falseBooleanString);
    	
    	test.stopTest();
    }

}