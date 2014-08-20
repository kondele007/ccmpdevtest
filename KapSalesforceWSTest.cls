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
private class KapSalesforceWSTest {

    static testMethod void testPositive_getNextTicket() {
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
	        
	        KapSalesforceWS.getNextTicket(testUser.Id);
	        
	        test.stopTest();
    	}
    }


    static testMethod void testPositive_getEncryptedLoginNameForUser() {
    	// Load Test Data
    	// Add 'Test User' to User table
    	User testUser = KapTestUtil.createTestUser();
    	
        test.startTest();
        
        KapSalesforceWS.getEncryptedLoginNameForUser(testUser.Id);
        
        test.stopTest();
    }


    static testMethod void testPositive_getEncryptedLoginNameForStudent() {
    	// Load Test Data
    	// Add 'Test Account' to Account table
    	Account testAccount = KapTestUtil.createTestAccount();
    	
        test.startTest();
        
        KapSalesforceWS.getEncryptedLoginNameForStudent(testAccount.Id);
        
        test.stopTest();
    }
}