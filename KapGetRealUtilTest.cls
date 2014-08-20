@isTest
Private class KapGetRealUtilTest {
	/*
	** Test Plan
	** ==============================================================
	** Basic Student Data (Last Name, First Name, Middle Name)
	** Student - Addresses (Perm, Work, School, Other)
	** Student - Phones
	** Student - Emails
	** Student - International Info
	** Student Relationships
	** Student Activities/Interactions
	** Case
	** Case Activities/Interactions
	**
	** Test Data
	** ==============================================================
	** Create Account Record
	** Create Enrollment Record
	** Create Integration Object
	** Create Integration Object Fields
	** Create Relationship Record
	** Create Account Activity
	** Create Case Record
	** Create Case Activity
	*/

    
    static testMethod void testPositive_intialization(){
    	test.startTest();
    	
    	KapGetRealUtil.initGetRealResponseCodeText();
    	
    	test.stopTest();
    }
    
    static testMethod void testPositive_basicStudentData(){
    	// Add 'Test Account' to Account table
    	Account testAccount = KapTestUtil.createTestAccount();
    	
    	testAccount.LastName = 'Test_Acct_Last';
    	testAccount.FirstName = 'Test_Acct_First';
    	testAccount.Middle_Name__c = 'Test_Acct_Middle';
    	
    	update testAccount;
    
    	List<Integration_Object__c> intObjectList = [SELECT Id, Object_Id__c, Object_Type__c, Student_Id__c, Legacy_Parent_Id__c, User_Name__c, KBS_User_Id__c, Retry_Count__c, Record_Number__c, Message_Id_Suffix_Iterator__c  FROM Integration_Object__c WHERE Object_Id__c = :testAccount.Id];
    	
    	Integration_Object__c intObject;
    	if (intObjectList.size() == 0) {
    		intObject = KapTestUtil.createIntegrationObject('Account', testAccount.Id);
	    	List<String> changedValueList = new List<String>();
	    	
	    	changedValueList.add('lastname:Test_Acct_Last');
	    	changedValueList.add('firstname:Test_Acct_First');
	    	changedValueList.add('middle_name__c:Test_Acct_Middle');
	    	
	    	// Add 'Test Integration Object Fields' to Integration_Object__c table
	    	List<Integration_Object_Field__c> testIntegrationObjectFieldList = KapTestUtil.createIntegrationObjectFields(intObject, changedValueList);
	    } else {
    		intObject = intObjectList[0];
	    }
    	
    	System.assertEquals(intObject.Object_Id__c, testAccount.Id);
    	System.assertEquals(intObject.Object_Type__c, 'Account');
    	System.assertNotEquals(intObject.Student_Id__c, '');
    	
    	test.startTest();
    	
    	KapGetRealUtil.createMessageList(intObject);
    	
    	test.stopTest();
    }

    static testMethod void testPositive_StudentAddresses(){
    	// Add 'Test Account' to Account table
    	Account testAccount = KapTestUtil.createTestAccount();
    	
    	testAccount.BillingStreet = 'Permanent Address Street';
    	testAccount.Permanent_Address2__c = 'Permanent Address Line 2';
    	testAccount.Permanent_Address3__c = 'Permanent Address Line 3';
    	testAccount.BillingCity = 'Reston';
    	testAccount.BillingState = 'VA';
    	testAccount.BillingPostalCode = '20191';
    	testAccount.Permanent_Mailing_Flag__c = true;
    	
    	testAccount.ShippingStreet = 'Work Address Street';
    	testAccount.Work_Address_Line2__c = 'Work Address Line 2';
    	testAccount.Work_Address_Line3__c = 'Work Address Line 3';
    	testAccount.ShippingCity = 'Reston';
    	testAccount.ShippingState = 'VA';
    	testAccount.ShippingPostalCode = '20191';
    	testAccount.Work_Mailing_Flag__c = false;
    	
    	testAccount.School_Address_Line_1__c = 'School Address Street';
    	testAccount.School_Address_Line_2__c = 'School Address Line 2';
    	testAccount.School_Address_Line_3__c = 'School Address Line 3';
    	testAccount.School_City__c = 'Reston';
    	testAccount.School_State__c = 'VA';
    	testAccount.School_Postal_Code__c = '20191';
    	testAccount.School_Mailing_Flag__c = false;
    	
    	testAccount.Other_Address_Line_1__c = 'Other Address Street';
    	testAccount.Other_Address_Line_2__c = 'Other Address Line 2';
    	testAccount.Other_Address_Line_3__c = 'Other Address Line 3';
    	testAccount.Other_City__c = 'Reston';
    	testAccount.Other_State__c = 'VA';
    	testAccount.Other_Postal_Code__c = '20191';
    	testAccount.Other_Mailing_Flag__c = false;
    	
    	update testAccount;
    
    	List<Integration_Object__c> intObjectList = [SELECT Id, Object_Id__c, Object_Type__c, Student_Id__c, Legacy_Parent_Id__c, User_Name__c, KBS_User_Id__c, Retry_Count__c, Record_Number__c, Message_Id_Suffix_Iterator__c  FROM Integration_Object__c WHERE Object_Id__c = :testAccount.Id];
    	
    	Integration_Object__c intObject;
    	if (intObjectList.size() == 0) {
    		intObject = KapTestUtil.createIntegrationObject('Account', testAccount.Id);
	    	List<String> changedValueList = new List<String>();
	    	
	    	changedValueList.add('billingstreet:Permanent Address Street');
	    	changedValueList.add('permanent_address_2__c:Permanent Address Line 2');
	    	changedValueList.add('permanent_address_3__c:Permanent Address Line 3');
	    	changedValueList.add('billingcity:Reston');
	    	changedValueList.add('billingstate:VA');
	    	changedValueList.add('billingpostalcode:20191');
	    	changedValueList.add('permanent_mailing_flag__c:true');

	    	changedValueList.add('shippingstreet:Work Address Street');
	    	changedValueList.add('work_address_line2__c:Work Address Line 2');
	    	changedValueList.add('work_address_line3__c:Work Address Line 3');
	    	changedValueList.add('shippingcity:Reston');
	    	changedValueList.add('shippingstate:VA');
	    	changedValueList.add('shippingpostalcode:20191');
	    	changedValueList.add('work_mailing_flag__c:false');

	    	changedValueList.add('school_address_line_1__c:School Address Street');
	    	changedValueList.add('school_address_line_2__c:School Address Line 2');
	    	changedValueList.add('school_address_line_3__c:School Address Line 3');
	    	changedValueList.add('school_city__c:Reston');
	    	changedValueList.add('school_state__c:VA');
	    	changedValueList.add('school_postal_code__c:20191');
	    	changedValueList.add('school_mailing_flag__c:true');

	    	changedValueList.add('other_address_line_1__c:Other Address Street');
	    	changedValueList.add('other_address_line_2__c:Other Address Line 2');
	    	changedValueList.add('other_address_line_3__c:Other Address Line 3');
	    	changedValueList.add('other_city__c:Reston');
	    	changedValueList.add('other_state__c:VA');
	    	changedValueList.add('other_postal_code__c:20191');
	    	changedValueList.add('other_mailing_flag__c:true');
	    	
	    	// Add 'Test Integration Object Fields' to Integration_Object__c table
	    	List<Integration_Object_Field__c> testIntegrationObjectFieldList = KapTestUtil.createIntegrationObjectFields(intObject, changedValueList);
	    } else {
    		intObject = intObjectList[0];
	    }
    	
    	System.assertEquals(intObject.Object_Id__c, testAccount.Id);
    	System.assertEquals(intObject.Object_Type__c, 'Account');
    	System.assertNotEquals(intObject.Student_Id__c, '');
    	
    	test.startTest();
    	
    	KapGetRealUtil.createMessageList(intObject);
    	
    	test.stopTest();
    }

    static testMethod void testPositive_StudentPhones(){
    	// Add 'Test Account' to Account table
    	Account testAccount = KapTestUtil.createTestAccount();
    	
    	testAccount.Phone_1_Type__c = 'Home';
    	testAccount.Phone = '1111231234';
    	testAccount.Phone_1_Extension__c = '1234';
    	
    	testAccount.Phone_2_Type__c = 'Office';
    	testAccount.Phone_2__c = '1111231234';
    	testAccount.Phone_2_Extension__c = '1234';
    	
    	testAccount.Phone_3_Type__c = 'School';
    	testAccount.Phone_3__c = '1111231234';
    	testAccount.Phone_3_Extension__c = '1234';
    	
    	update testAccount;
    
    	List<Integration_Object__c> intObjectList = [SELECT Id, Object_Id__c, Object_Type__c, Student_Id__c, Legacy_Parent_Id__c, User_Name__c, KBS_User_Id__c, Retry_Count__c, Record_Number__c, Message_Id_Suffix_Iterator__c  FROM Integration_Object__c WHERE Object_Id__c = :testAccount.Id];
    	
    	Integration_Object__c intObject;
    	if (intObjectList.size() == 0) {
    		intObject = KapTestUtil.createIntegrationObject('Account', testAccount.Id);
	    	List<String> changedValueList = new List<String>();
	    	
	    	changedValueList.add('phone_1_type__c:Home');
	    	changedValueList.add('phone:1111231234');
	    	changedValueList.add('phone_1_extension__c:1234');
	    	
	    	changedValueList.add('phone_2_type__c:Office');
	    	changedValueList.add('phone_2__c:1111231234');
	    	changedValueList.add('phone_2_extension__c:1234');
	    	
	    	changedValueList.add('phone_3_type__c:School');
	    	changedValueList.add('phone_3__c:1111231234');
	    	changedValueList.add('phone_3_extension__c:1234');
	    	
	    	// Add 'Test Integration Object Fields' to Integration_Object__c table
	    	List<Integration_Object_Field__c> testIntegrationObjectFieldList = KapTestUtil.createIntegrationObjectFields(intObject, changedValueList);
	    } else {
    		intObject = intObjectList[0];
	    }
    	
    	System.assertEquals(intObject.Object_Id__c, testAccount.Id);
    	System.assertEquals(intObject.Object_Type__c, 'Account');
    	System.assertNotEquals(intObject.Student_Id__c, '');
    	
    	test.startTest();
    	
    	KapGetRealUtil.createMessageList(intObject);
    	
    	test.stopTest();
    }

    static testMethod void testNegative_StudentPhones(){
    	// Add 'Test Account' to Account table
    	Account testAccount = KapTestUtil.createTestAccount();
    	
    	testAccount.Phone_1_Type__c = 'Home';
    	testAccount.Phone_1_Extension__c = '1234';
    	
    	testAccount.Phone_2_Type__c = 'Office';
    	testAccount.Phone_2_Extension__c = '1234';
    	
    	testAccount.Phone_3_Type__c = 'School';
    	testAccount.Phone_3_Extension__c = '1234';
    	
    	update testAccount;
    
    	List<Integration_Object__c> intObjectList = [SELECT Id, Object_Id__c, Object_Type__c, Student_Id__c, Legacy_Parent_Id__c, User_Name__c, KBS_User_Id__c, Retry_Count__c, Record_Number__c, Message_Id_Suffix_Iterator__c  FROM Integration_Object__c WHERE Object_Id__c = :testAccount.Id];
    	
    	Integration_Object__c intObject;
    	if (intObjectList.size() == 0) {
    		intObject = KapTestUtil.createIntegrationObject('Account', testAccount.Id);
	    	List<String> changedValueList = new List<String>();
	    	
	    	changedValueList.add('phone_1_type__c:Home');
	    	changedValueList.add('phone_1_extension__c:1234');
	    	
	    	changedValueList.add('phone_2_type__c:Office');
	    	changedValueList.add('phone_2_extension__c:1234');
	    	
	    	changedValueList.add('phone_3_type__c:School');
	    	changedValueList.add('phone_3_extension__c:1234');
	    	
	    	// Add 'Test Integration Object Fields' to Integration_Object__c table
	    	List<Integration_Object_Field__c> testIntegrationObjectFieldList = KapTestUtil.createIntegrationObjectFields(intObject, changedValueList);
	    } else {
    		intObject = intObjectList[0];
	    }
    	
    	System.assertEquals(intObject.Object_Id__c, testAccount.Id);
    	System.assertEquals(intObject.Object_Type__c, 'Account');
    	System.assertNotEquals(intObject.Student_Id__c, '');
    	
    	test.startTest();
    	
    	KapGetRealUtil.createMessageList(intObject);
    	
    	test.stopTest();
    }

    static testMethod void testPositive_StudentEmails(){
    	// Add 'Test Account' to Account table
    	Account testAccount = KapTestUtil.createTestAccount();
    	
    	testAccount.PersonEmail = 'email_1@kaplan.com';
    	testAccount.Email_2__c = 'email_2@kaplan.com';

    	update testAccount;
    
    	List<Integration_Object__c> intObjectList = [SELECT Id, Object_Id__c, Object_Type__c, Student_Id__c, Legacy_Parent_Id__c, User_Name__c, KBS_User_Id__c, Retry_Count__c, Record_Number__c, Message_Id_Suffix_Iterator__c  FROM Integration_Object__c WHERE Object_Id__c = :testAccount.Id];
    	
    	Integration_Object__c intObject;
    	if (intObjectList.size() == 0) {
    		intObject = KapTestUtil.createIntegrationObject('Account', testAccount.Id);
	    	List<String> changedValueList = new List<String>();
	    	
	    	changedValueList.add('personemail:email_1@kaplan.com');
	    	changedValueList.add('email_2__c:email_2@kaplan.com');
	    	
	    	// Add 'Test Integration Object Fields' to Integration_Object__c table
	    	List<Integration_Object_Field__c> testIntegrationObjectFieldList = KapTestUtil.createIntegrationObjectFields(intObject, changedValueList);
	    } else {
    		intObject = intObjectList[0];
	    }
    	
    	System.assertEquals(intObject.Object_Id__c, testAccount.Id);
    	System.assertEquals(intObject.Object_Type__c, 'Account');
    	System.assertNotEquals(intObject.Student_Id__c, '');
    	
    	test.startTest();
    	
    	KapGetRealUtil.createMessageList(intObject);
    	
    	test.stopTest();
    }

    static testMethod void testPositive_StudentInternationalInfo(){
    	// Add 'Test Account' to Account table
    	Account testAccount = KapTestUtil.createTestAccount();
    	
    	testAccount.ABA_Number__c = '12345678';

    	update testAccount;
    
    	List<Integration_Object__c> intObjectList = [SELECT Id, Object_Id__c, Object_Type__c, Student_Id__c, Legacy_Parent_Id__c, User_Name__c, KBS_User_Id__c, Retry_Count__c, Record_Number__c, Message_Id_Suffix_Iterator__c  FROM Integration_Object__c WHERE Object_Id__c = :testAccount.Id];
    	
    	Integration_Object__c intObject;
    	if (intObjectList.size() == 0) {
    		intObject = KapTestUtil.createIntegrationObject('Account', testAccount.Id);
	    	List<String> changedValueList = new List<String>();
	    	
	    	changedValueList.add('aba_number__c:12345678');
	    	
	    	// Add 'Test Integration Object Fields' to Integration_Object__c table
	    	List<Integration_Object_Field__c> testIntegrationObjectFieldList = KapTestUtil.createIntegrationObjectFields(intObject, changedValueList);
	    } else {
    		intObject = intObjectList[0];
	    }
    	
    	System.assertEquals(intObject.Object_Id__c, testAccount.Id);
    	System.assertEquals(intObject.Object_Type__c, 'Account');
    	System.assertNotEquals(intObject.Student_Id__c, '');
    	
    	test.startTest();
    	
    	KapGetRealUtil.createMessageList(intObject);
    	
    	test.stopTest();
    }

    static testMethod void testPositive_StudentExclusions(){
    	// Add 'Test Account' to Account table
    	Account testAccount = KapTestUtil.createTestAccount();
    	
    	testAccount.Do_Not_Call2__c = false;
    	testAccount.Email_Opt_Out2__c = false;
    	testAccount.Do_Not_Mail_Flag__c = true;
    	testAccount.Do_Not_Share_Flag__c = true;

    	update testAccount;
    
    	List<Integration_Object__c> intObjectList = [SELECT Id, Object_Id__c, Object_Type__c, Student_Id__c, Legacy_Parent_Id__c, User_Name__c, KBS_User_Id__c, Retry_Count__c, Record_Number__c, Message_Id_Suffix_Iterator__c  FROM Integration_Object__c WHERE Object_Id__c = :testAccount.Id];
    	
    	Integration_Object__c intObject;
    	if (intObjectList.size() == 0) {
    		intObject = KapTestUtil.createIntegrationObject('Account', testAccount.Id);
	    	List<String> changedValueList = new List<String>();
	    	
	    	changedValueList.add('do_not_call2__c:false');
	    	changedValueList.add('email_opt_out2__c:false');
	    	changedValueList.add('do_not_mail_flag__c:true');
	    	changedValueList.add('do_not_share_flag__c:true');
	    	
	    	// Add 'Test Integration Object Fields' to Integration_Object__c table
	    	List<Integration_Object_Field__c> testIntegrationObjectFieldList = KapTestUtil.createIntegrationObjectFields(intObject, changedValueList);
	    } else {
    		intObject = intObjectList[0];
	    }
    	
    	System.assertEquals(intObject.Object_Id__c, testAccount.Id);
    	System.assertEquals(intObject.Object_Type__c, 'Account');
    	System.assertNotEquals(intObject.Student_Id__c, '');
    	
    	test.startTest();
    	
    	KapGetRealUtil.createMessageList(intObject);
    	
    	test.stopTest();
    }

    static testMethod void testPositive_StudentRelationships(){
    	// Add 'Test Account' to Account table
    	Account testAccount = KapTestUtil.createTestAccount();
     	// Add 'Test Relationship' to Relationship table
    	Relationship__c testRelationship = KapTestUtil.createTestRelationship(testAccount);
    
    	List<Integration_Object__c> intObjectList = [SELECT Id, Object_Id__c, Object_Type__c, Student_Id__c, Legacy_Parent_Id__c, User_Name__c, KBS_User_Id__c, Retry_Count__c, Record_Number__c, Message_Id_Suffix_Iterator__c  FROM Integration_Object__c WHERE Object_Id__c = :testRelationship.Id];
    	
    	Integration_Object__c intObject;
    	if (intObjectList.size() == 0) {
    		intObject = KapTestUtil.createIntegrationObject('Relationship__c', testRelationship.Id);
	    	List<String> changedValueList = new List<String>();
	    	
	    	changedValueList.add('relation_type__c:Parent');
	    	changedValueList.add('parent_first_name__c:Test_Parent_First');
	    	changedValueList.add('parent_last_name__c:Test_Parent_Last');
	    	changedValueList.add('phone_1__c:1111231234');
	    	changedValueList.add('phone_1_extension__c:1111');
	    	changedValueList.add('phone_2__c:2221231234');
	    	changedValueList.add('phone_2_extension__c:2222');
	    	changedValueList.add('email_1__c:test_rel_parent_email_1@yahoo.com');
	    	changedValueList.add('email_2__c:test_rel_parent_email_2@yahoo.com');
	    	changedValueList.add('legacy_parent_Id__c:test_rel_parent_email_2@yahoo.com');
	    	
	    	// Add 'Test Integration Object Fields' to Integration_Object__c table
	    	List<Integration_Object_Field__c> testIntegrationObjectFieldList = KapTestUtil.createIntegrationObjectFields(intObject, changedValueList);
	    } else {
    		intObject = intObjectList[0];
	    }
    	
    	System.assertEquals(intObject.Object_Id__c, testRelationship.Id);
    	System.assertEquals(intObject.Object_Type__c, 'Relationship__c');
    	System.assertNotEquals(intObject.Student_Id__c, '');
    	
    	test.startTest();
    	
    	KapGetRealUtil.createMessageList(intObject);
    	
    	test.stopTest();
    }

    static testMethod void testPositive_StudentActivites(){
    	// Add 'Test Account' to Account table
    	Account testAccount = KapTestUtil.createTestAccount();
    	// Add 'Test Account Activity' to Task table
    	Task testAccoutTask = KapTestUtil.createTestAccountActivity(testAccount);
    
    	List<Integration_Object__c> intObjectList = [SELECT Id, Object_Id__c, Object_Type__c, Student_Id__c, Legacy_Parent_Id__c, User_Name__c, KBS_User_Id__c, Retry_Count__c, Record_Number__c, Message_Id_Suffix_Iterator__c  FROM Integration_Object__c WHERE Object_Id__c = :testAccoutTask.Id];
    	
    	Integration_Object__c intObject;
    	if (intObjectList.size() == 0) {
    		intObject = KapTestUtil.createIntegrationObject('Account Task', testAccoutTask.Id);
	    	List<String> changedValueList = new List<String>();
	    	
	    	changedValueList.add('whatid:'+testAccount.Id);
	    	changedValueList.add('subject:Activty Subject');
	    	changedValueList.add('status:Not Started');
	    	
	    	// Add 'Test Integration Object Fields' to Integration_Object__c table
	    	List<Integration_Object_Field__c> testIntegrationObjectFieldList = KapTestUtil.createIntegrationObjectFields(intObject, changedValueList);
	    } else {
    		intObject = intObjectList[0];
	    }
    	
    	System.assertEquals(intObject.Object_Id__c, testAccoutTask.Id);
    	System.assertEquals(intObject.Object_Type__c, 'Account Task');
    	System.assertNotEquals(intObject.Student_Id__c, '');
    	
    	test.startTest();
    	
    	KapGetRealUtil.createMessageList(intObject);
    	
    	test.stopTest();
    }

    static testMethod void testPositive_StudentCase_STATUS_NEW(){
    	// Add 'Test Account' to Account table
    	Account testAccount = KapTestUtil.createTestAccount();
    	// Add 'Test Case' to Case table with owner = 'Test Queue'
    	Case testCase = KapTestUtil.createTestAccountCase(testAccount,'New');
    
    	List<Integration_Object__c> intObjectList = [SELECT Id, Object_Id__c, Object_Type__c, Student_Id__c, Legacy_Parent_Id__c, User_Name__c, KBS_User_Id__c, Retry_Count__c, Record_Number__c, Message_Id_Suffix_Iterator__c  FROM Integration_Object__c WHERE Object_Id__c = :testCase.Id];
    	
    	Integration_Object__c intObject;
    	if (intObjectList.size() == 0) {
    		intObject = KapTestUtil.createIntegrationObject('Case', testCase.Id);
	    	List<String> changedValueList = new List<String>();
	    	
	    	changedValueList.add('accountid:'+testAccount.Id);
	    	changedValueList.add('status:New');
	    	
	    	// Add 'Test Integration Object Fields' to Integration_Object__c table
	    	List<Integration_Object_Field__c> testIntegrationObjectFieldList = KapTestUtil.createIntegrationObjectFields(intObject, changedValueList);
	    } else {
    		intObject = intObjectList[0];
	    }
    	
    	System.assertEquals(intObject.Object_Id__c, testCase.Id);
    	System.assertEquals(intObject.Object_Type__c, 'Case');
    	System.assertNotEquals(intObject.Student_Id__c, '');
    	
    	test.startTest();
    	
    	KapGetRealUtil.createMessageList(intObject);
    	
    	test.stopTest();
    }

    static testMethod void testPositive_StudentCase_STATUS_CLOSED(){
    	// Add 'Test Account' to Account table
    	Account testAccount = KapTestUtil.createTestAccount();
    	// Add 'Test Case' to Case table with owner = 'Test Queue'
    	Case testCase = KapTestUtil.createTestAccountCase(testAccount,'Closed');
    
    	List<Integration_Object__c> intObjectList = [SELECT Id, Object_Id__c, Object_Type__c, Student_Id__c, Legacy_Parent_Id__c, User_Name__c, KBS_User_Id__c, Retry_Count__c, Record_Number__c, Message_Id_Suffix_Iterator__c  FROM Integration_Object__c WHERE Object_Id__c = :testCase.Id];
    	
    	Integration_Object__c intObject;
    	if (intObjectList.size() == 0) {
    		intObject = KapTestUtil.createIntegrationObject('Case', testCase.Id);
	    	List<String> changedValueList = new List<String>();
	    	
	    	changedValueList.add('accountid:'+testAccount.Id);
	    	changedValueList.add('status:Closed');
	    	
	    	// Add 'Test Integration Object Fields' to Integration_Object__c table
	    	List<Integration_Object_Field__c> testIntegrationObjectFieldList = KapTestUtil.createIntegrationObjectFields(intObject, changedValueList);
	    } else {
    		intObject = intObjectList[0];
	    }
    	
    	System.assertEquals(intObject.Object_Id__c, testCase.Id);
    	System.assertEquals(intObject.Object_Type__c, 'Case');
    	System.assertNotEquals(intObject.Student_Id__c, '');
    	
    	test.startTest();
    	
    	KapGetRealUtil.createMessageList(intObject);
    	
    	test.stopTest();
    }

    static testMethod void testPositive_CaseActivites(){
    	// Add 'Test Account' to Account table
    	Account testAccount = KapTestUtil.createTestAccount();
    	// Add 'Test Case' to Case table with owner = 'Test Queue'
    	Case testCase = KapTestUtil.createTestAccountCase(testAccount,'New');
    	// Add 'Test Case Activity' to Task table
    	Task testCaseTask = KapTestUtil.createTestCaseActivity(testCase);
    
    	List<Integration_Object__c> intObjectList = [SELECT Id, Object_Id__c, Object_Type__c, Student_Id__c, Legacy_Parent_Id__c, User_Name__c, KBS_User_Id__c, Retry_Count__c, Record_Number__c, Message_Id_Suffix_Iterator__c  FROM Integration_Object__c WHERE Object_Id__c = :testCaseTask.Id];
    	
    	Integration_Object__c intObject;
    	if (intObjectList.size() == 0) {
    		intObject = KapTestUtil.createIntegrationObject('Case Task', testCaseTask.Id);
	    	List<String> changedValueList = new List<String>();
	    	
	    	changedValueList.add('whatid:'+testCase.Id);
	    	changedValueList.add('subject:Activty Subject');
	    	changedValueList.add('status:Not Started');
	    	
	    	// Add 'Test Integration Object Fields' to Integration_Object__c table
	    	List<Integration_Object_Field__c> testIntegrationObjectFieldList = KapTestUtil.createIntegrationObjectFields(intObject, changedValueList);
	    } else {
    		intObject = intObjectList[0];
	    }
    	
    	System.assertEquals(intObject.Object_Id__c, testCaseTask.Id);
    	System.assertEquals(intObject.Object_Type__c, 'Case Task');
    	System.assertNotEquals(intObject.Student_Id__c, '');
    	
    	test.startTest();
    	
    	KapGetRealUtil.createMessageList(intObject);
    	
    	test.stopTest();
    }

    static testMethod void testPositive_handleGetRealResponse(){
    	// Add 'Test Account' to Account table
    	Account testAccount = KapTestUtil.createTestAccount();
    	
    	testAccount.LastName = 'Test_Acct_Last';
    	testAccount.FirstName = 'Test_Acct_First';
    	testAccount.Middle_Name__c = 'Test_Acct_Middle';

    	update testAccount;
    
    	List<Integration_Object__c> intObjectList = [SELECT Id, Object_Id__c, Object_Type__c, Student_Id__c, Legacy_Parent_Id__c, User_Name__c, KBS_User_Id__c, Retry_Count__c, Record_Number__c, Message_Id_Suffix_Iterator__c  FROM Integration_Object__c WHERE Object_Id__c = :testAccount.Id];
    	
    	Integration_Object__c intObject;
    	if (intObjectList.size() == 0) {
    		intObject = KapTestUtil.createIntegrationObject('Account', testAccount.Id);
	    	List<String> changedValueList = new List<String>();
	    	
	    	changedValueList.add('lastname:Test_Acct_Last');
	    	changedValueList.add('firstname:Test_Acct_First');
	    	changedValueList.add('middle_name__c:Test_Acct_Middle');
	    	
	    	// Add 'Test Integration Object Fields' to Integration_Object__c table
	    	List<Integration_Object_Field__c> testIntegrationObjectFieldList = KapTestUtil.createIntegrationObjectFields(intObject, changedValueList);
	    } else {
    		intObject = intObjectList[0];
	    }
    	
    	System.assertEquals(intObject.Object_Id__c, testAccount.Id);
    	System.assertEquals(intObject.Object_Type__c, 'Account');
    	System.assertNotEquals(intObject.Student_Id__c, '');
    	
    	test.startTest();
    	
    	String xmlRequest = KapGetRealUtil.createMessageList(intObject);
    	
        KapXmlResponseWS xmlResponse = new KapXmlResponseWS();
        
        xmlResponse.statusCode = 200;
        xmlResponse.xmlBody = '<response><service>person</service><action>realtime</action><payload><message_results client_name="salesforce"><message message_id="SFDC-STG-20110615-0083030-1"><person uid="1502257200" client_sys_id="500M0000000cv8gIAA" cmd="1"></person><result status="10"/></message></message_results></payload></response>';
        
        KapGetRealUtil.handleGetRealResponse(xmlRequest, (xmlResponse != null ? xmlResponse : new KapXmlResponseWS()), intObject);
    	
    	test.stopTest();
    }

    static testMethod void testNegative_handleGetRealResponse_STATUS_200_WITH_GR_ERROR(){
    	// Add 'Test Account' to Account table
    	Account testAccount = KapTestUtil.createTestAccount();
    	
    	testAccount.LastName = 'Test_Acct_Last';
    	testAccount.FirstName = 'Test_Acct_First';
    	testAccount.Middle_Name__c = 'Test_Acct_Middle';

    	update testAccount;
    
    	List<Integration_Object__c> intObjectList = [SELECT Id, Object_Id__c, Object_Type__c, Student_Id__c, Legacy_Parent_Id__c, User_Name__c, KBS_User_Id__c, Retry_Count__c, Record_Number__c, Message_Id_Suffix_Iterator__c  FROM Integration_Object__c WHERE Object_Id__c = :testAccount.Id];
    	
    	Integration_Object__c intObject;
    	if (intObjectList.size() == 0) {
    		intObject = KapTestUtil.createIntegrationObject('Account', testAccount.Id);
	    	List<String> changedValueList = new List<String>();
	    	
	    	changedValueList.add('lastname:Test_Acct_Last');
	    	changedValueList.add('firstname:Test_Acct_First');
	    	changedValueList.add('middle_name__c:Test_Acct_Middle');
	    	
	    	// Add 'Test Integration Object Fields' to Integration_Object__c table
	    	List<Integration_Object_Field__c> testIntegrationObjectFieldList = KapTestUtil.createIntegrationObjectFields(intObject, changedValueList);
	    } else {
    		intObject = intObjectList[0];
	    }
    	
    	System.assertEquals(intObject.Object_Id__c, testAccount.Id);
    	System.assertEquals(intObject.Object_Type__c, 'Account');
    	System.assertNotEquals(intObject.Student_Id__c, '');
    	
    	test.startTest();
    	
    	String xmlRequest = KapGetRealUtil.createMessageList(intObject);
    	
        KapXmlResponseWS xmlResponse = new KapXmlResponseWS();
        
        xmlResponse.statusCode = 200;
        xmlResponse.xmlBody = '<response><service>person</service><action>realtime</action><payload><message_results client_name="salesforce"><message message_id="SFDC-QA-20110525-0327481-1"><person uid="1518186638" client_sys_id="001M0000003SzE9IAK" cmd="1"></person><result status="-35"/></message></message_results></payload></response>';        

    	test.stopTest();
    }

    static testMethod void testNegative_handleGetRealResponse_STATUS_NOT_200(){
    	// Add 'Test Account' to Account table
    	Account testAccount = KapTestUtil.createTestAccount();
    	
    	testAccount.LastName = 'Test_Acct_Last';
    	testAccount.FirstName = 'Test_Acct_First';
    	testAccount.Middle_Name__c = 'Test_Acct_Middle';

    	update testAccount;
    
    	List<Integration_Object__c> intObjectList = [SELECT Id, Object_Id__c, Object_Type__c, Student_Id__c, Legacy_Parent_Id__c, User_Name__c, KBS_User_Id__c, Retry_Count__c, Record_Number__c, Message_Id_Suffix_Iterator__c  FROM Integration_Object__c WHERE Object_Id__c = :testAccount.Id];
    	
    	Integration_Object__c intObject;
    	if (intObjectList.size() == 0) {
    		intObject = KapTestUtil.createIntegrationObject('Account', testAccount.Id);
	    	List<String> changedValueList = new List<String>();
	    	
	    	changedValueList.add('lastname:Test_Acct_Last');
	    	changedValueList.add('firstname:Test_Acct_First');
	    	changedValueList.add('middle_name__c:Test_Acct_Middle');
	    	
	    	// Add 'Test Integration Object Fields' to Integration_Object__c table
	    	List<Integration_Object_Field__c> testIntegrationObjectFieldList = KapTestUtil.createIntegrationObjectFields(intObject, changedValueList);
	    } else {
    		intObject = intObjectList[0];
	    }
    	
    	System.assertEquals(intObject.Object_Id__c, testAccount.Id);
    	System.assertEquals(intObject.Object_Type__c, 'Account');
    	System.assertNotEquals(intObject.Student_Id__c, '');
    	
    	test.startTest();
    	
    	String xmlRequest = KapGetRealUtil.createMessageList(intObject);
    	
        KapXmlResponseWS xmlResponse = new KapXmlResponseWS();

        xmlResponse.statusCode = 400;
        xmlResponse.xmlBody = '<response><service>person</service><action>realtime</action><payload><message_results client_name="salesforce"><message message_id="SFDC-STG-20110615-0083030-1"><person uid="1502257200" client_sys_id="500M0000000cv8gIAA" cmd="1"></person><result status="10"/></message></message_results></payload></response>';
        
        KapGetRealUtil.handleGetRealResponse(xmlRequest, (xmlResponse != null ? xmlResponse : new KapXmlResponseWS()), intObject);
        
        xmlResponse.statusCode = 500;
        xmlResponse.xmlBody = '<response><service>person</service><action>realtime</action><payload><message_results client_name="salesforce"><message message_id="SFDC-STG-20110615-0083030-1"><person uid="1502257200" client_sys_id="500M0000000cv8gIAA" cmd="1"></person><result status="10"/></message></message_results></payload></response>';
        
        KapGetRealUtil.handleGetRealResponse(xmlRequest, (xmlResponse != null ? xmlResponse : new KapXmlResponseWS()), intObject);
    	
        xmlResponse.statusCode = 400;
        xmlResponse.xmlBody = '<html><head><title>Apache Tomcat/5.5.20 - Error report</title><style><!--H1 {font-family:Tahoma,Arial,sans-serif;color:white;background-color:#525D76;font-size:22px;} H2 {font-family:Tahoma,Arial,sans-serif;color:white;background-color:#525D76;font-size:16px;} H3 {font-family:Tahoma,Arial,sans-serif;color:white;background-color:#525D76;font-size:14px;} BODY {font-family:Tahoma,Arial,sans-serif;color:black;background-color:white;} B {font-family:Tahoma,Arial,sans-serif;color:white;background-color:#525D76;} P {font-family:Tahoma,Arial,sans-serif;background:white;color:black;font-size:12px;}A {color : black;}A.name {color : black;}HR {color : #525D76;}--></style> </head><body><h1>HTTP Status 400 - Invalid Request</h1><HR size="1" noshade="noshade"><p><b>type</b> Status report</p><p><b>message</b> <u>Invalid Request</u></p><p><b>description</b> <u>The request sent by the client was syntactically incorrect (Invalid Request).</u></p><HR size="1" noshade="noshade"><h3>Apache Tomcat/5.5.20</h3></body></html>';
        
        KapGetRealUtil.handleGetRealResponse(xmlRequest, (xmlResponse != null ? xmlResponse : new KapXmlResponseWS()), intObject);

    	test.stopTest();
    }

}