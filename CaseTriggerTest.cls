@isTest
private class CaseTriggerTest
{
	static testMethod void testMapCaseToPersonByStudentID()
	{
		final Integer NUM_ACCOUNTS = 15;

		RecordType personAccountType = [ SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'PersonAccount' ];
		List<Account> testAccounts = new List<Account>();
		for( Integer index = 0; index < NUM_ACCOUNTS; index++ )
		{
			Account newAccount = new Account();
			newAccount.LastName = 'somename'+index;
			newAccount.Student_ID_Display__c = ''+index;
			testAccounts.add( newAccount );
		}
		insert testAccounts;

		List<Case> testCases = new List<Case>();
		for( Account anAccount : testAccounts )
		{
			Case newCase = KapTestUtil.createTestCases( 1, false )[0];
			newCase.Student_Id__c = anAccount.Student_ID_Display__c;
			newCase.Payment_Mode__c = 'some mode';
			testCases.add( newCase );
		}

		Test.startTest();

			CaseServices.mapCaseToPersonByStudentID( testCases );

		Test.stopTest();

		Map<Id, Account> accountsMap = new Map<Id, Account>( testAccounts );
		for( Case aCase : testCases )
		{
			System.assertEquals( CaseServices.OVERSEAS_CASE_DETAIL, aCase.Type_Detail__c, 'Type detail should have been set properly on the Case' );
			System.assertEquals( CaseServices.OVERSEAS_CASE_TYPE, aCase.Type, 'Type should have been set properly on the Case' );
			System.assertEquals( CaseServices.OVERSEAS_CASE_STATUS, aCase.Status, 'Type should have been set properly on the Case' );
			System.assertEquals( accountsMap.get( aCase.AccountId ).Student_ID_Display__c, aCase.Student_Id__c, 'The Case should have been mapped to the same id account' );
		}
	}

	static testMethod void testMapCaseToPerson_Insert()
	{
		final Integer NUM_ACCOUNTS = 15;

		Kaplan_Custom_Config__c newSetting = new Kaplan_Custom_Config__c();
		newSetting.Name = 'Kaplan Custom Config';
		newSetting.ETL_Load_Username__c = 'someusername';
		System.runAs( KapTestUtil.ADMIN_USER )
		{
			insert newSetting;
		}

		RecordType personAccountType = [ SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'PersonAccount' ];
		List<Account> testAccounts = new List<Account>();
		for( Integer index = 0; index < NUM_ACCOUNTS; index++ )
		{
			Account newAccount = new Account();
			newAccount.LastName = 'somename'+index;
			newAccount.Student_ID_Display__c = ''+index;
			testAccounts.add( newAccount );
		}
		insert testAccounts;

		List<Case> testCases = new List<Case>();
		for( Account anAccount : testAccounts )
		{
			Case newCase = KapTestUtil.createTestCases( 1, false )[0];
			newCase.Student_Id__c = anAccount.Student_ID_Display__c;
			newCase.Payment_Mode__c = 'some mode';
			testCases.add( newCase );
		}

		Test.startTest();

			insert testCases;

		Test.stopTest();

		List<Case> updatedCases = [ SELECT Id, Account.Student_ID_Display__c, Student_Id__c FROM Case ];
		System.assertEquals( NUM_ACCOUNTS, updatedCases.size(), 'There should be as many Cases as created' );
		for( Case aCase : updatedCases )
		{
			System.assertEquals( aCase.Account.Student_ID_Display__c, aCase.Student_Id__c, 'The cases should have been mapped to an account with the same id' );
		}
	}
}