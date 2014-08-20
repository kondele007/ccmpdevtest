@isTest
private class AccountTriggerTest
{
    static List<User> testUsers;
    static RecordType accountRecordType;

    static void setup()
    {
        System.runAs( KapTestUtil.ADMIN_USER )
        {
            insert new Kaplan_Custom_Config__c (Name = 'Kaplan Custom Config', ETL_Load_Username__c = 'some@username.com');
        }

        Profile standardProfile = [ SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1 ];
        testUsers = KapTestUtil.createUsers( 4, standardProfile.Id, true );

        accountRecordType = [ SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Partner' LIMIT 1 ];
    }

    static testMethod void testInsertAccountWithSharedUsers()
    {
        final Integer NUM_ACCOUNTS = 10;
        setup();

        List<Account> testAccounts = KapTestUtil.createAccounts( NUM_ACCOUNTS, accountRecordType.Id, false );
        for( Account anAccount : testAccounts )
        {
            anAccount.Health_Program_Mngr__c = testUsers[0].Id;
            anAccount.Regional_Acct_Dir__c = testUsers[1].Id;
            anAccount.Regional_Med_Prog_Dir__c = testUsers[2].Id;
            anAccount.Med_Program_Consultant__c = testUsers[3].Id;
        }

        Test.startTest();

            insert testAccounts;

        Test.stopTest();

        Map<Id, Set<Id>> accountToShareIds = new Map<Id, Set<Id>>();
        for( AccountShare createdShare : [ SELECT Id, AccountId, UserOrGroupId FROM AccountShare WHERE RowCause = :AccountServices.MANUAL_ROWCAUSE ] )
        {
            if( !accountToShareIds.containsKey( createdShare.AccountId ) )
            {
                accountToShareIds.put( createdShare.AccountId, new Set<Id>() );
            }
            accountToShareIds.get( createdShare.AccountId ).add( createdShare.UserOrGroupId );
        }
        System.assertEquals( NUM_ACCOUNTS, accountToShareIds.size(), 'There should be shares created for every account' );
        for( Set<Id> seenIds : accountToShareIds.values() )
        {
            System.assertEquals( AccountServices.LOOKUP_SHARE_FIELDS.size(), seenIds.size(), 'There should be a share created for every user assigned in a lookup' );
            for( User aUser : testUsers )
            {
                System.assert( seenIds.contains( aUser.Id ), 'Every user should have a share created' );
            }
        }
    }

    static testMethod void testNullAndUpdateAccountWithSharedUsers()
    {
        final Integer NUM_ACCOUNTS = 10;
        setup();

        List<Account> testAccounts = KapTestUtil.createAccounts( NUM_ACCOUNTS, accountRecordType.Id, false );
        for( Account anAccount : testAccounts )
        {
            anAccount.Health_Program_Mngr__c = testUsers[0].Id;
            anAccount.Regional_Acct_Dir__c = testUsers[1].Id;
            anAccount.Regional_Med_Prog_Dir__c = testUsers[2].Id;
            anAccount.Med_Program_Consultant__c = testUsers[3].Id;
        }
        insert testAccounts;

        Test.startTest();

            for( Account anAccount : testAccounts )
            {
                anAccount.Health_Program_Mngr__c = testUsers[3].Id;
                anAccount.Regional_Acct_Dir__c = null;
                anAccount.Regional_Med_Prog_Dir__c = testUsers[3].Id;
                anAccount.Med_Program_Consultant__c = null;
            }
            update testAccounts;

        Test.stopTest();

        List<AccountShare> sharesAfterUpdate = [ SELECT Id, UserOrGroupId FROM AccountShare WHERE RowCause = :AccountServices.MANUAL_ROWCAUSE ];
        System.assertEquals( NUM_ACCOUNTS, sharesAfterUpdate.size(), 'There should be one manual share left per Account' );
        for( AccountShare aShare : sharesAfterUpdate )
        {
            System.assertEquals( testUsers[3].Id, aShare.UserOrGroupId, 'The only share remaining should be for the last User on the lookups' );
        }
    }
}