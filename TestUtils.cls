@isTest
public  class TestUtils {

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

    public static Pricebook2 standardPricebook
    {
        get
        {
            if( standardPricebook == null )
            {
                standardPricebook = [ SELECT Id FROM Pricebook2 WHERE IsActive = TRUE AND IsStandard = TRUE LIMIT 1 ];
            }
            return standardPricebook;
        }
        private set;
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
            System.runAs( ADMIN_USER )
            {
                insert testUsers;
            }
        }
        return testUsers;
    }

    public static List<Account> createAccounts( Integer numAccounts, Id recordTypeId, Boolean doInsert )
    {
        List<Account> testAccounts = new List<Account>();
        for( Integer index = 0; index < numAccounts; index++ )
        {
            Account newAccount = new Account();
            newAccount.Name = 'TestAccount' + index;
            newAccount.RecordTypeId = recordTypeId;
            newAccount.BillingState = 'NY';
            newAccount.BillingPostalCode = '10010';
            testAccounts.add( newAccount );
        }
        if( doInsert )
        {
            insert testAccounts;
        }
        return testAccounts;
    }

    public static List<Opportunity> createOpportunities( Integer numOpportunities, Id accountId, Id recordTypeId, Boolean doInsert )
    {
        List<Opportunity> testOpportunities = new List<Opportunity>();
        for( Integer index = 0; index < numOpportunities; index++ )
        {
            Opportunity newOpportunity = new Opportunity();
            newOpportunity.Name = 'Test Opportunity' + recordCounter++;
            newOpportunity.StageName = 'Qualified';
            newOpportunity.CloseDate = Date.today();
            newOpportunity.RecordTypeId = recordTypeId;
            newOpportunity.AccountId = accountId;
            newOpportunity.Event_Type__c='Conference';
            newOpportunity.Programs__c='GMAT';
            newOpportunity.Semester__c='2014';
            newOpportunity.Deal_Type__c='International';
            newOpportunity.Customer_Type__c='Student Pay';
            
            testOpportunities.add( newOpportunity );
        }
        if( doInsert )
        {
            insert testOpportunities;
        }
        return testOpportunities;
    }

    public static List<OpportunityLineItem> createOLIs( Integer numOLIs, Id pricebookEntryId, Id opportunityId, Boolean doInsert )
    {
        List<OpportunityLineItem> testOLIs = new List<OpportunityLineItem>();
        for( Integer index = 0; index < numOLIs; index++ )
        {
            OpportunityLineItem newOLI = new OpportunityLineItem();
            newOLI.PricebookEntryId = pricebookEntryId;
            newOLI.OpportunityId = opportunityId;
            newOLI.Quantity = 1;
            newOLI.UnitPrice = 1.0;
            testOLIs.add( newOLI );
        }
        if( doInsert )
        {
            insert testOLIs;
        }
        return testOLIs;
    }

    public static List<Product2> createProducts( Integer numProducts, Boolean doInsert )
    {
        List<Product2> testProducts = new List<Product2>();
        for( Integer index = 0; index < numProducts; index++ )
        {
            Product2 newProduct = new Product2();
            newProduct.Name = 'Test Product ' + index;
            testProducts.add( newProduct );
        }
        if( doInsert )
        {
            insert testProducts;
        }
        return testProducts;
    }

    public static PricebookEntry createPricebookEntry( Id productId, Id pricebookId, Boolean doInsert )
    {
        PricebookEntry newPBE = new PricebookEntry();
        newPBE.Product2Id = productId;
        newPBE.Pricebook2Id = pricebookId;
        newPBE.UnitPrice = 1.0;
        newPBE.IsActive = true;
        if( doInsert )
        {
            insert newPBE;
        }
        return newPBE;
    }
}