@isTest
public  class KapTestUtil {

	public static Integer recordCounter = 0;

	/*
        Administrator User
    */
    public static User ADMIN_USER {
        get {
            if ( ADMIN_USER == null ){
                ADMIN_USER = [SELECT  Id FROM User WHERE  Profile.Name = 'System Administrator' and IsActive = true LIMIT 1];
            }
            return ADMIN_USER;
        }
        private set;
    }

	public static List<Campaign> createTestCampaigns( Integer numCampaigns, Boolean doInsert )
	{
		List<Campaign> testCampaigns = new List<Campaign>();
		for( Integer index = 0; index < numCampaigns; index++ )
		{
			Campaign newCampaign = new Campaign();
			newCampaign.Name = 'Test Campaign ' + recordCounter++;
			newCampaign.StartDate = Date.today();
			newCampaign.EndDate = Date.today().addDays(2);
			newCampaign.Start_Time__c = '8:00 AM';
			newCampaign.End_Time__c = '9:00 PM';
			testCampaigns.add( newCampaign );
		}
		if( doInsert )
		{
			insert testCampaigns;
		}
		return testCampaigns;
	}

	public static User createTestUser() {
		// Retrieve Profile info for 'Standard User'
    	Profile stdProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
    	return createUsers( 1, stdProfile.Id, true )[0];
	}

	public static List<User> createUsers( Integer numUsers, Id profileId, Boolean doInsert )
	{
		List<User> testUsers = new List<User>();
		for( Integer index = 0; index < numUsers; index++ )
		{
			User newUser = new User();
			newUser.FirstName = 'Test';
	    	newUser.LastName = 'User';
	    	newUser.Alias = 'tuser' + recordCounter++;
	    	newUser.Email = 'gkoodarappally@acumensolutions.com';
	    	newUser.Username = newUser.Alias + '@kaplan.com.kapdev';
	    	newUser.TimeZoneSidKey = 'America/New_York';
	    	newUser.LocaleSidKey = 'en_US';
	    	newUser.LanguageLocaleKey = 'en_US';
	    	newUser.EmailEncodingKey = 'ISO-8859-1';
	    	newUser.ProfileId = profileId;
	    	testUsers.add( newUser );
		}
		if( doInsert )
		{
			System.runAs( getSystemAdminTestUser() )
			{
				insert testUsers;
			}
		}
		return testUsers;
	}

	public static User getSystemAdminTestUser() {
    	return ADMIN_USER;
	}

	public static Group createTestQueue() {

    	// Add 'Test Queue' to Queue table
    	Group testQueue = new Group();
    	testQueue.Name = 'Test Queue';
    	testQueue.Type = 'Queue';

    	insert testQueue;

    	QueueSObject queueSObject = new QueueSObject();
    	queueSObject.QueueId = testQueue.Id;
    	queueSObject.SobjectType = 'Case';

    	insert queueSObject;

    	//Group testQueue = [SELECT Id, Name, Type FROM Group WHERE Name='Test Queue' AND Type = 'Queue' LIMIT 1];

    	return testQueue;
	}

	public static GroupMember createQueueMember(Id queueId, Id memberId) {
    	// Add 'Test User' to 'Test Queue' in GroupMember table
    	GroupMember testQueueMember = new GroupMember();
    	testQueueMember.GroupId = queueId; 			//Id of 'Test Queue'
    	testQueueMember.UserOrGroupId =  memberId;	//Id of 'Test User'

    	insert testQueueMember;

    	return testQueueMember;
	}

	public static Queue_Detail__c createQueuePriority() {
    	// Add 'Test Queue' to Queue_Detail__c table
    	Queue_Detail__c testQueuePriority = new Queue_Detail__c();
    	testQueuePriority.Name = 'Test Queue';
    	testQueuePriority.Priority__c = 10;

    	insert testQueuePriority;

    	return testQueuePriority;
	}

	public static Case createTestCase(Id ownerId) {
    	// Add 'Test Case' to Case table with owner = 'Test Queue'
    	Case testCase = new Case();
    	testCase.Description = 'Test Case Description.';
    	testCase.OwnerId = ownerId;		// Id of the 'Test Queue' queue

    	insert testCase;

    	return testCase;
	}

	public static List<Case> createTestCases( Integer numOfCases, Boolean doInsert )
	{
		List<Case> testCases = new List<Case>();
		for( Integer index = 0; index < numOfCases; index++ )
		{
			Case newCase = new Case();
			testCases.add( newCase );
		}
		if( doInsert )
		{
			insert testCases;
		}
		return testCases;
	}

	public static Account createTestAccount() {
    	// Add 'Test Account' to Account table
    	Id RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Person Account' LIMIT 1].Id;

    	Account testAccount = new Account();
    	testAccount.FirstName = 'TestFName';
    	testAccount.LastName = 'TestLName';
    	testAccount.Kaptest_Username__c = 'kaptestuser@kaplan.com';
    	testAccount.RecordTypeId = RecordTypeId;

    	insert testAccount;

    	return testAccount;
	}

	public static Enrollment__c createTestEnrollment(Account testParentAccount) {
    	// Add 'Test Enrollment' to Enrollment__c for Parent Account

    	Enrollment__c testEnrollment = new Enrollment__c();
    	testEnrollment.Account__c = testParentAccount.Id;
    	testEnrollment.Enrollment_Id__c = '1231231234';
    	testEnrollment.Enrollment_Type__c = 'Product';
    	testEnrollment.Product_Code__c = 'Product';
    	testEnrollment.Class_Code__c = 'Product';

    	insert testEnrollment;

    	return testEnrollment;
	}

	public static Relationship__c createTestRelationship(Account testParentAccount) {
    	// Add 'Test Relationship' to Relationship__c for Parent Account

    	Relationship__c testRelationship = new Relationship__c();
    	testRelationship.Account__c = testParentAccount.Id;
    	testRelationship.Relation_Type__c = 'Parent';
    	testRelationship.Parent_First_Name__c = 'Test_Parent_First';
    	testRelationship.Parent_Last_Name__c = 'Test_Parent_Last';
    	testRelationship.Phone_1__c = '1111231234';
    	testRelationship.Phone_1_Extension__c = '1111';
    	testRelationship.Phone_2__c = '2221231234';
    	testRelationship.Phone_2_Extension__c = '2222';
    	testRelationship.Email_1__c = 'test_rel_parent_email_1@yahoo.com';
    	testRelationship.Email_2__c = 'test_rel_parent_email_2@yahoo.com';
    	testRelationship.Legacy_Parent_Id__c = '123456789';

    	insert testRelationship;

    	return testRelationship;
	}

	public static Task createTestAccountActivity(Account testParentAccount) {
    	// Add 'Test Activity' for Parent Account

    	Task testTask = new Task();
    	testTask.WhatId = testParentAccount.Id;
    	//testTask.WhoId = 'Parent';
    	testTask.Subject = 'Activty Subject';
    	testTask.Status = 'Not Started';

    	insert testTask;

    	return testTask;
	}

	public static Case createTestAccountCase(Account testParentAccount, String caseStatus) {
    	// Add 'Test Case' to Case table with owner = 'Test Queue'
    	Case testCase = new Case();
    	testCase.AccountId = testParentAccount.Id;
    	testCase.Status = caseStatus;

    	insert testCase;

    	return testCase;
	}

	public static Task createTestCaseActivity(Case testParentCase) {
    	// Add 'Test Activity' for Parent Account

    	Task testTask = new Task();
    	testTask.WhatId = testParentCase.Id;
    	//testTask.WhoId = 'Parent';
    	testTask.Subject = 'Activty Subject';
    	testTask.Status = 'Not Started';

    	insert testTask;

    	return testTask;
	}

	public static Integration_Object__c createIntegrationObject(String objectType, String objectId) {
    	// Add 'Test Activity' for Parent Account

    	Integration_Object__c testIntegrationObject = new Integration_Object__c();
    	testIntegrationObject.Object_Type__c = objectType;
    	testIntegrationObject.Object_Id__c = objectId;
    	testIntegrationObject.Message_Id_Suffix_Iterator__c = 0;

    	insert testIntegrationObject;

    	return testIntegrationObject;
	}

	public static List<Integration_Object_Field__c> createIntegrationObjectFields(Integration_Object__c intObject, List<String> changedValueList) {
    	// Add 'Test Activity' for Parent Account
    	List<Integration_Object_Field__c> testIntegrationObjectFieldList = new List<Integration_Object_Field__c>();

		for (String value: changedValueList) {
			String changedField = value.split(':')[0];
			String changedValue = value.split(':')[1];

	    	Integration_Object_Field__c intObjField = new Integration_Object_Field__c(Integration_Object__c=intObject.Id, Changed_Field__c=changedField, Changed_Value__c=changedValue);
			testIntegrationObjectFieldList.add(intObjField);
		}

    	insert testIntegrationObjectFieldList;

    	return testIntegrationObjectFieldList;
	}

	public static List<Account> createAccounts( Integer numAccounts, Id recordTypeId, Boolean doInsert )
	{
		List<Account> testAccounts = new List<Account>();
		for( Integer index = 0; index < numAccounts; index++ )
		{
			Account newAccount = new Account();
			newAccount.Name = 'TestAccount' + index;
			newAccount.RecordTypeId = recordTypeId;
			testAccounts.add( newAccount );
		}
		if( doInsert )
		{
			insert testAccounts;
		}
		return testAccounts;
	}

	public static List<Opportunity> createOpportunities( Integer numOpportunities, Boolean doInsert )
	{
		List<Opportunity> testOpportunities = new List<Opportunity>();
		for( Integer index = 0; index < numOpportunities; index++ )
		{
			Opportunity newOpportunity = new Opportunity();
			newOpportunity.Name = 'Test Opportunity ' + index;
			newOpportunity.StageName = 'Prospecting';
			newOpportunity.CloseDate = Date.today();
			testOpportunities.add( newOpportunity );
		}
		if( doInsert )
		{
			insert testOpportunities;
		}
		return testOpportunities;
	}

	public static List<Implementation__c> createImplementations( Integer numImplementations, Boolean doInsert )
	{
		List<Implementation__c> testImplementations = new List<Implementation__c>();
		for( Integer index = 0; index < numImplementations; index++ )
		{
			Implementation__c newImpl = new Implementation__c();
			testImplementations.add( newImpl );
		}
		if( doInsert )
		{
			insert testImplementations;
		}
		return testImplementations;
	}

    public static List<E_Cart__c> createCarts( Integer numCarts, Boolean doInsert )
    {
        List<E_Cart__c> testCarts = new List<E_Cart__c>();
        for( Integer index = 0; index < numCarts; index++ )
        {
            E_Cart__c newCart = new E_Cart__c();
            newCart.SessionId__c = UserInfo.getSessionId();
            testCarts.add( newCart );
        }
        if( doInsert )
        {
            insert testCarts;
        }
        return testCarts;
    }

    public static List<E_Order__c> createOrders( Integer numOrders, Id cartId, Boolean doInsert )
    {
        List<E_Order__c> testOrders = new List<E_Order__c>();
        for( Integer index = 0; index < numOrders; index++ )
        {
            E_Order__c newOrder = new E_Order__c();
            newOrder.OriginatedCart__c = cartId;
            testOrders.add( newOrder );
        }
        if( doInsert )
        {
            insert testOrders;
        }
        return testOrders;
    }

    static testMethod void myUnitTest() {

    	System.runAs( ADMIN_USER )
		{
			insert new Kaplan_Custom_Config__c (Name = 'Kaplan Custom Config', ETL_Load_Username__c = 'some@username.com');
		}

    	test.startTest();

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
	    	// Add 'Test Case Activity' to Task table
	    	Task testCaseTask = KapTestUtil.createTestCaseActivity(testCase);
    	}

    	// Retrieve an Active User with 'System Administrator' Profile
    	User sysAdmUser = getSystemAdminTestUser();

    	// Add 'Test Account' to Account table
    	Account testAccount = KapTestUtil.createTestAccount();
    	// Add 'Test Enrollment' to Enrollment table
    	Enrollment__c testEnrollment = KapTestUtil.createTestEnrollment(testAccount);
    	// Add 'Test Relationship' to Relationship table
    	Relationship__c testRelationship = KapTestUtil.createTestRelationship(testAccount);
    	// Add 'Test Account Activity' to Task table
    	Task testAccoutTask = KapTestUtil.createTestAccountActivity(testAccount);
    	// Add 'Test Case' to Case table for parent 'testAccount'
    	Case testAccountCase = KapTestUtil.createTestAccountCase(testAccount,'New');


    	// Add 'Test Integration Object' to Integration_Object__c table
    	Integration_Object__c testIntegrationObject = KapTestUtil.createIntegrationObject('Account', testAccount.Id);

    	List<String> changedValueList = new List<String>();

    	changedValueList.add('lastname:Test_Acct_Last');
    	changedValueList.add('firstname:Test_Acct_First');
    	changedValueList.add('middle_name__c:Test_Acct_Middle');

    	// Add 'Test Integration Object Fields' to Integration_Object__c table
    	List<Integration_Object_Field__c> testIntegrationObjectFieldList = KapTestUtil.createIntegrationObjectFields(testIntegrationObject, changedValueList);

    	test.stopTest();
    }

}