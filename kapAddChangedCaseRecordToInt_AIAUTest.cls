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
private class kapAddChangedCaseRecordToInt_AIAUTest {


    static testMethod void myUnitTest() {
    	// Add 'Test Account' to Account table
    	Account testAccount = KapTestUtil.createTestAccount();
    	// Add 'Test Case' to Case table for parent 'testAccount'
    	Case testAccountCase = KapTestUtil.createTestAccountCase(testAccount,'New');
    	
    	
    	test.startTest();
    	
    	testAccountCase.Description = 'Updated Description';
    	update testAccountCase;
    	
    	testAccountCase.Status = 'Closed';
    	update testAccountCase;
    	
    	/*
    	Integration_Object__c intObject = [SELECT Id, Object_Id__c, Object_Type__c, Student_Id__c, Legacy_Parent_Id__c, User_Name__c, KBS_User_Id__c, Retry_Count__c, Record_Number__c, Message_Id_Suffix_Iterator__c  FROM Integration_Object__c WHERE Object_Id__c = :testAccountCase.Id];
    	
    	System.assert(intObject != null);
    	System.assertEquals(intObject.Object_Id__c, testAccountCase.Id);
    	System.assertEquals(intObject.Object_Type__c, 'Case');
    	
        List<Integration_Object_Field__c> intObjFieldList = [Select Id, Integration_Object__c from Integration_Object_Field__c where Integration_Object__c = :intObject.Id];
        System.assert(intObjFieldList != null);
        System.assert(intObjFieldList.size() > 0);        
		*/
		
    	test.stopTest();
	}   

}