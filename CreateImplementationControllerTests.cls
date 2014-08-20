@isTest
private class CreateImplementationControllerTests
{
	@isTest(SeeAllData=true)
    static void testCreateImplementation()
    {
        final String BILLING_STATE = 'NY';
        final String REGION = 'some region';
        final List<String> TYPE_CONTROLS = new List<String>{ 'Type1', 'Type2', 'Type3' };

        OpportunityToImplementationFields__c newSetting = new OpportunityToImplementationFields__c();
        newSetting.Name = 'Grade_Level__c';
        newSetting.Implementation_Field__c = 'Grade_Level__c';
        System.runAs( KapTestUtil.ADMIN_USER )
        {
            delete OpportunityToImplementationFields__c.getAll().values();
            insert newSetting;
        }

        List<Product2> testProducts = new List<Product2>();
        List<Type_Control__c> testControls = new List<Type_Control__c>();
        for( String aType : TYPE_CONTROLS )
        {
            Product2 aProduct = new Product2();
            aProduct.Name = 'TestProduct';
            aProduct.Type_Deliverable__c = aType;
            testProducts.add( aProduct );

            Type_Control__c newControl = new Type_Control__c();
            newControl.Name = aType;
            testControls.add( newControl );
        }
        insert testProducts;
        insert testControls;
        List<PricebookEntry> standardEntries = new List<PricebookEntry>();
        Pricebook2 standardBook = [ SELECT Id FROM Pricebook2 WHERE IsStandard = TRUE LIMIT 1 ];
        for( Product2 aProduct : testProducts )
        {
            PricebookEntry newEntry = new PricebookEntry();
            newEntry.Pricebook2Id = standardBook.Id;
            newEntry.Product2Id = aProduct.Id;
            newEntry.UnitPrice = 20;
            newEntry.IsActive = true;
            standardEntries.add( newEntry );
        }
        insert standardEntries;

        RecordType accountRecordType = [ SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Company' LIMIT 1 ];
        Account testAccount = KapTestUtil.createAccounts( 1, accountRecordType.Id, false )[0];
        testAccount.BillingState = BILLING_STATE;
        testAccount.BillingPostalCode = '10010';
        testAccount.Region__c = REGION;
        insert testAccount;

        Opportunity testOpportunity = KapTestUtil.createOpportunities( 1, false )[0];
        testOpportunity.AccountId = testAccount.Id;
        testOpportunity.Grade_Level__c = 'some grade';
        insert testOpportunity;

        List<OpportunityLineItem> testOLIs = new List<OpportunityLineItem>();
        for( PricebookEntry anEntry : standardEntries )
        {
            OpportunityLineItem newOLI = new OpportunityLineItem();
            newOLI.PricebookEntryId = anEntry.Id;
            newOLI.OpportunityId = testOpportunity.Id;
            newOLI.Quantity = 1;
            newOLI.UnitPrice = 10;
            testOLIs.add( newOLI );
        }
        insert testOLIs;

        delete [ SELECT Id FROM Territory_Control__c ];
        Territory_Control__c territoryControl = new Territory_Control__c();
        territoryControl.Name = BILLING_STATE;
        territoryControl.User__c = UserInfo.getUserId();
        insert territoryControl;

        ApexPages.StandardController stdCont = new ApexPages.StandardController( testOpportunity );
        CreateImplementationController customController = new CreateImplementationController( stdCont );

        Test.startTest();

            customController.createImplementation();

        Test.stopTest();

        List<Implementation__c> createdImplementations = [ SELECT Id, Opportunity__c, OwnerId, Grade_Level__c
                                                            FROM Implementation__c WHERE Opportunity__c = :testOpportunity.Id ];
        System.assertEquals( 1, createdImplementations.size(), 'There should have been an implementation created' );
        System.assertEquals( testOpportunity.Id, createdImplementations[0].Opportunity__c, 'The Implementation should be created for the target opportunity' );
        System.assertEquals( testOpportunity.Grade_Level__c, createdImplementations[0].Grade_Level__c, 'The Implementation should be created for the target opportunity' );
        System.assertEquals( territoryControl.User__c, createdImplementations[0].OwnerId, 'The Implementation should be owned by whoever is on the territory control' );

        List<Task> createdTasks = [ SELECT Id, OwnerId FROM Task WHERE WhatId IN :createdImplementations ];
        System.assertEquals( 1, createdTasks.size(), 'There should only be one task created for the Implementation' );
        System.assertEquals( createdImplementations[0].OwnerId, createdTasks[0].OwnerId, 'The created Task should have the same Owner as the Implementation' );

        List<Deliverables__c> createdDeliverables = [ SELECT Id, (SELECT Id FROM R00N30000000uxssEAA) FROM Deliverables__c WHERE Implementation__c IN :createdImplementations ];
        System.assertEquals( TYPE_CONTROLS.size(), createdDeliverables.size(), 'There should be as many deliverables as product types' );
        for( Deliverables__c aDeliverable : createdDeliverables )
        {
            System.assertEquals( 1, aDeliverable.getSObjects('R00N30000000uxssEAA').size(), 'There should be one product per deliverable' );
        }
    }
}