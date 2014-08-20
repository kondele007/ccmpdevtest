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
private class KapEnrollmentProPurchaseHistory_AIAUTest {
    
    private static Kaplan_Custom_Config__c kap_config = Kaplan_Custom_Config__c.getValues('Kaplan Custom Config');
    private static String etlLoadUsername = String.valueOf(kap_config.ETL_Load_Username__c);
    

    static testMethod void myUnitTest() {
    	// Add 'Test Account' to Account table
    	Account testAccount = KapTestUtil.createTestAccount();
    	// Add 'Test Enrollment' to Enrollment table
    	Enrollment__c testEnrollment = KapTestUtil.createTestEnrollment(testAccount);
    	
    	test.startTest();
    	
    	testEnrollment.Product_Code__c = 'GMAT';
    	testEnrollment.Class_Code__c = 'GMAT01';
    	update testEnrollment;
    	
    	/*
    	Integration_Object__c intObject = [SELECT Id, Object_Id__c, Object_Type__c, Student_Id__c, Legacy_Parent_Id__c, User_Name__c, KBS_User_Id__c, Retry_Count__c, Record_Number__c, Message_Id_Suffix_Iterator__c  FROM Integration_Object__c WHERE Object_Id__c = :testEnrollment.Id];
    	
    	System.assert(intObject != null);
    	System.assertEquals(intObject.Object_Id__c, testEnrollment.Id);
    	System.assertEquals(intObject.Object_Type__c, 'Enrollment__c');
    	
        List<Integration_Object_Field__c> intObjFieldList = [Select Id, Integration_Object__c from Integration_Object_Field__c where Integration_Object__c = :intObject.Id];
        System.assert(intObjFieldList != null);
        System.assert(intObjFieldList.size() > 0);        
		*/
		
    	test.stopTest();
	}   

	/*
    static testMethod void KapEnrollmentProPurchaseHistoryTriggerTest() {
        
        User userInfo = [Select Id, Name from User where Username =: etlLoadUsername Limit 1];
        
        Account acc = new Account(Name='George-003 Smith-008', Student_Id_Display__c='123', Product_Purchase_History__c='12345', Classcode_Purchase_History__c='CL41', Kaptest_Username__c='chaitu.katragadda@kaplan.com');
        Test.startTest();
        insert acc;
        System.runAs(userInfo) {
	        Enrollment__c enrObj = new Enrollment__c(Enrollment_Type__c='Product',product_code__c='12345', Class_Code__c='CL41', Enrollment_Id__c='41258537',
	                                Account__c = acc.Id);
	        insert enrObj;
	        
	        enrObj.Class_Code__c='CL42';
	        update enrObj;
        }
        Test.stopTest();
    }
    */
}