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
private class KapTriggerUtilTest {

    static testMethod void testPositive_getChangedFields() {
    	// Add 'Test Account' to Account table
    	Account testAccountOld = KapTestUtil.createTestAccount();
    	// Add 'Test Relationship' to Relationship table
    	Relationship__c testRelationshipOld = KapTestUtil.createTestRelationship(testAccountOld);
    	// Add 'Test Account Activity' to Task table
    	Task testAccoutTaskOld = KapTestUtil.createTestAccountActivity(testAccountOld);
    	// Add 'Test Case' to Case table for parent 'testAccount'
    	Case testAccountCaseOld = KapTestUtil.createTestAccountCase(testAccountOld,'New');
    	
    	testAccountOld.LastName = 'Old Last Name';
    	
    	// Add 'Test Account' to Account table
    	Account testAccountNew = KapTestUtil.createTestAccount();
    	// Add 'Test Relationship' to Relationship table
    	Relationship__c testRelationshipNew = KapTestUtil.createTestRelationship(testAccountNew);
    	// Add 'Test Account Activity' to Task table
    	Task testAccoutTaskNew = KapTestUtil.createTestAccountActivity(testAccountNew);
    	// Add 'Test Case' to Case table for parent 'testAccount'
    	Case testAccountCaseNew = KapTestUtil.createTestAccountCase(testAccountNew,'New');
    	
    	testAccountNew.LastName = 'Old Last Name';
    	
    	test.startTest();
    	
    	KapTriggerUtil.getChangedFields(testAccountOld, testAccountNew);
    	KapTriggerUtil.getChangedFields(testRelationshipOld, testRelationshipNew);
    	KapTriggerUtil.getChangedFields(testAccoutTaskOld, testAccoutTaskNew);
    	KapTriggerUtil.getChangedFields(testAccountCaseOld, testAccountCaseNew);

    	test.stopTest();
	}   

    static testMethod void testPositive_getAllFields() {
    	// Add 'Test Account' to Account table
    	Account testAccountOld = KapTestUtil.createTestAccount();
    	// Add 'Test Relationship' to Relationship table
    	Relationship__c testRelationshipOld = KapTestUtil.createTestRelationship(testAccountOld);
    	// Add 'Test Account Activity' to Task table
    	Task testAccoutTaskOld = KapTestUtil.createTestAccountActivity(testAccountOld);
    	// Add 'Test Case' to Case table for parent 'testAccount'
    	Case testAccountCaseOld = KapTestUtil.createTestAccountCase(testAccountOld,'New');
    	
    	test.startTest();
    	
    	KapTriggerUtil.getAllFields(testAccountOld);
    	KapTriggerUtil.getAllFields(testRelationshipOld);
    	KapTriggerUtil.getAllFields(testAccoutTaskOld);        
    	KapTriggerUtil.getAllFields(testAccountCaseOld);
        
    	
    	test.stopTest();
	}   

    static testMethod void testPositive_onlyLegacyParentIdChanged() {
    	// Add 'Test Account' to Account table
    	Account testAccountOld = KapTestUtil.createTestAccount();
    	// Add 'Test Relationship' to Relationship table
    	Relationship__c testRelationshipOld = KapTestUtil.createTestRelationship(testAccountOld);
    	Relationship__c testRelationshipNew = KapTestUtil.createTestRelationship(testAccountOld);

    	testRelationshipNew.Legacy_Parent_Id__c = '12345678';
    	
    	test.startTest();
    	
    	KapTriggerUtil.onlyLegacyParentIdChanged(testRelationshipOld, testRelationshipNew);
    	
    	test.stopTest();
	}   

}