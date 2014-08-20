@isTest
private class KapAddRelatioshipParentAccountTest {

    static testMethod void testPositive_RelationshipWithLastFirstPhoneEmail() {
    	// Add 'Test Account' to Account table
    	Account testAccount = KapTestUtil.createTestAccount();
    	// Add 'Test Relationship' to Relationship table
    	Relationship__c testRelationship = KapTestUtil.createTestRelationship(testAccount);
    	
    	test.startTest();
    	
    	testRelationship.Parent_Last_Name__c = 'Test_Parent_Last';
    	testRelationship.Parent_First_Name__c = 'Test_Parent_First';
    	testRelationship.Phone_1__c = '1111231234';
    	testRelationship.Email_1__c = 'test_rel_parent_email_1@yahoo.com';
    	
    	update testRelationship;
    	
    	/*
    	Integration_Object__c intObject = [SELECT Id, Object_Id__c, Object_Type__c, Student_Id__c, Legacy_Parent_Id__c, User_Name__c, KBS_User_Id__c, Retry_Count__c, Record_Number__c, Message_Id_Suffix_Iterator__c  FROM Integration_Object__c WHERE Object_Id__c = :testRelationship.Id];
    	
    	System.assert(intObject != null);
    	System.assertEquals(intObject.Object_Id__c, testRelationship.Id);
    	System.assertEquals(intObject.Object_Type__c, 'Relationship__c');
    	
        List<Integration_Object_Field__c> intObjFieldList = [Select Id, Integration_Object__c from Integration_Object_Field__c where Integration_Object__c = :intObject.Id];
        System.assert(intObjFieldList != null);
        System.assert(intObjFieldList.size() > 0);        
		*/
		
    	test.stopTest();
	}   

    static testMethod void testPositive_RelationshipWithLastFirstPhone() {
    	// Add 'Test Account' to Account table
    	Account testAccount = KapTestUtil.createTestAccount();
    	// Add 'Test Relationship' to Relationship table
    	Relationship__c testRelationship = KapTestUtil.createTestRelationship(testAccount);
    	
    	test.startTest();
    	
    	testRelationship.Parent_Last_Name__c = 'Test_Parent_Last';
    	testRelationship.Parent_First_Name__c = 'Test_Parent_First';
    	testRelationship.Phone_1__c = '1111231234';
    	testRelationship.Email_1__c = '';
    	
    	update testRelationship;
    	
    	/*
    	Integration_Object__c intObject = [SELECT Id, Object_Id__c, Object_Type__c, Student_Id__c, Legacy_Parent_Id__c, User_Name__c, KBS_User_Id__c, Retry_Count__c, Record_Number__c, Message_Id_Suffix_Iterator__c  FROM Integration_Object__c WHERE Object_Id__c = :testRelationship.Id];
    	
    	System.assert(intObject != null);
    	System.assertEquals(intObject.Object_Id__c, testRelationship.Id);
    	System.assertEquals(intObject.Object_Type__c, 'Relationship__c');
    	
        List<Integration_Object_Field__c> intObjFieldList = [Select Id, Integration_Object__c from Integration_Object_Field__c where Integration_Object__c = :intObject.Id];
        System.assert(intObjFieldList != null);
        System.assert(intObjFieldList.size() > 0);        
		*/
		
    	test.stopTest();
	}   

    static testMethod void testPositive_RelationshipWithLastFirstEmail() {
    	// Add 'Test Account' to Account table
    	Account testAccount = KapTestUtil.createTestAccount();
    	// Add 'Test Relationship' to Relationship table
    	Relationship__c testRelationship = KapTestUtil.createTestRelationship(testAccount);
    	
    	test.startTest();
    	
    	testRelationship.Parent_Last_Name__c = 'Test_Parent_Last';
    	testRelationship.Parent_First_Name__c = 'Test_Parent_First';
    	testRelationship.Phone_1__c = '';
    	testRelationship.Email_1__c = 'test_rel_parent_email_1@yahoo.com';
    	
    	update testRelationship;
    	
    	/*
    	Integration_Object__c intObject = [SELECT Id, Object_Id__c, Object_Type__c, Student_Id__c, Legacy_Parent_Id__c, User_Name__c, KBS_User_Id__c, Retry_Count__c, Record_Number__c, Message_Id_Suffix_Iterator__c  FROM Integration_Object__c WHERE Object_Id__c = :testRelationship.Id];
    	
    	System.assert(intObject != null);
    	System.assertEquals(intObject.Object_Id__c, testRelationship.Id);
    	System.assertEquals(intObject.Object_Type__c, 'Relationship__c');
    	
        List<Integration_Object_Field__c> intObjFieldList = [Select Id, Integration_Object__c from Integration_Object_Field__c where Integration_Object__c = :intObject.Id];
        System.assert(intObjFieldList != null);
        System.assert(intObjFieldList.size() > 0);        
		*/
		
    	test.stopTest();
	}   

    static testMethod void testPositive_RelationshipWithLastFirst() {
    	// Add 'Test Account' to Account table
    	Account testAccount = KapTestUtil.createTestAccount();
    	// Add 'Test Relationship' to Relationship table
    	Relationship__c testRelationship = KapTestUtil.createTestRelationship(testAccount);
    	
    	test.startTest();
    	
    	testRelationship.Parent_Last_Name__c = 'Test_Parent_Last';
    	testRelationship.Parent_First_Name__c = 'Test_Parent_First';
    	testRelationship.Phone_1__c = '';
    	testRelationship.Email_1__c = '';
    	
    	update testRelationship;
    	
    	/*
    	Integration_Object__c intObject = [SELECT Id, Object_Id__c, Object_Type__c, Student_Id__c, Legacy_Parent_Id__c, User_Name__c, KBS_User_Id__c, Retry_Count__c, Record_Number__c, Message_Id_Suffix_Iterator__c  FROM Integration_Object__c WHERE Object_Id__c = :testRelationship.Id];
    	
    	System.assert(intObject != null);
    	System.assertEquals(intObject.Object_Id__c, testRelationship.Id);
    	System.assertEquals(intObject.Object_Type__c, 'Relationship__c');
    	
        List<Integration_Object_Field__c> intObjFieldList = [Select Id, Integration_Object__c from Integration_Object_Field__c where Integration_Object__c = :intObject.Id];
        System.assert(intObjFieldList != null);
        System.assert(intObjFieldList.size() > 0);        
		*/
		
    	test.stopTest();
	}   


    static testMethod void testNegative_RelationshipWithLastFirstPhoneEmail() {
    	// Add 'Test Account' to Account table
    	Account testAccount = KapTestUtil.createTestAccount();
    	// Add 'Test Relationship' to Relationship table
    	Relationship__c testRelationship = KapTestUtil.createTestRelationship(testAccount);
    	
    	test.startTest();
    	
    	testRelationship.Parent_Last_Name__c = 'Test_Parent_Last_X';
    	testRelationship.Parent_First_Name__c = 'Test_Parent_First_X';
    	testRelationship.Phone_1__c = '1111231234-X';
    	testRelationship.Email_1__c = 'test_rel_parent_email_1@yahoo.comX';
    	
    	update testRelationship;
    	
    	/*
    	Integration_Object__c intObject = [SELECT Id, Object_Id__c, Object_Type__c, Student_Id__c, Legacy_Parent_Id__c, User_Name__c, KBS_User_Id__c, Retry_Count__c, Record_Number__c, Message_Id_Suffix_Iterator__c  FROM Integration_Object__c WHERE Object_Id__c = :testRelationship.Id];
    	
    	System.assert(intObject != null);
    	System.assertEquals(intObject.Object_Id__c, testRelationship.Id);
    	System.assertEquals(intObject.Object_Type__c, 'Relationship__c');
    	
        List<Integration_Object_Field__c> intObjFieldList = [Select Id, Integration_Object__c from Integration_Object_Field__c where Integration_Object__c = :intObject.Id];
        System.assert(intObjFieldList != null);
        System.assert(intObjFieldList.size() > 0);        
		*/
		
    	test.stopTest();
	}   
}