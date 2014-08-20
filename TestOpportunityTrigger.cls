@isTest
private class TestOpportunityTrigger
{
	static RecordType accountRecordType;
	static RecordType opportunityRecordType;
	static State_Taxation__c testState;

	static void setup()
	{
		accountRecordType = [ SELECT Id FROM RecordType WHERE SObjectType = 'Account'  LIMIT 1 ];
		opportunityRecordType = [ SELECT Id FROM RecordType WHERE SObjectType = 'Opportunity' LIMIT 1 ];

		testState = new State_Taxation__c();
		insert testState;

		if( Kaplan_Custom_Config__c.getInstance('Kaplan Custom Config') == null )
		{
			Kaplan_Custom_Config__c newCustomSetting = new Kaplan_Custom_Config__c();
			newCustomSetting.Name = 'Kaplan Custom Config';
			newCustomSetting.ETL_Load_Username__c = 'someusername';
			System.runAs( KapTestUtil.ADMIN_USER )
			{
				insert newCustomSetting;
			}
		}
	}

	static testMethod void testPopulateTaxInformationLookup()
	{
		final Integer NUM_ACCOUNTS = 10;
		final Integer NUM_OPPTYS = 2;
		setup();

		List<Account> testAccounts = TestUtils.createAccounts( NUM_ACCOUNTS, accountRecordType.Id, false );
		for( Integer index = 0; index < testAccounts.size(); index++ )
		{
			testAccounts[index].BillingPostalCode = (testAccounts[index].BillingPostalCode + index).right(5) + '-1010';
		}
		insert testAccounts;

		List<Tax_Information__c> testTaxInformation = new List<Tax_Information__c>();
		for( Account anAccount : testAccounts )
		{
			Tax_Information__c newTaxInformation = new Tax_Information__c();
			newTaxInformation.Name = anAccount.BillingPostalCode.left(5);
			newTaxInformation.State__c = testState.Id;
			testTaxInformation.add( newTaxInformation );
		}
		insert testTaxInformation;

		List<Opportunity> testOpportunities = new List<Opportunity>();
		for( Account anAccount : testAccounts )
		{
			testOpportunities.addAll( TestUtils.createOpportunities( NUM_OPPTYS, anAccount.Id, opportunityRecordType.Id, false ) );
		}

		Test.startTest();

			insert testOpportunities;

		Test.stopTest();

		List<Opportunity> updatedOpportunities = [ SELECT Id, Account.BillingPostalCode, Taxation_Zip_Code__r.Name FROM Opportunity ];
		System.assertEquals( NUM_ACCOUNTS * NUM_OPPTYS, updatedOpportunities.size(), 'There should be as many opportunities as created' );
		for( Opportunity anOpportunity : updatedOpportunities )
		{
			System.assertEquals( anOpportunity.Account.BillingPostalCode.left(5), anOpportunity.Taxation_Zip_Code__r.Name, 'The Tax Information should match the Postal Zip' );
		}
	}

	static testMethod void testPrioritizeOpportunityZIPForTaxLookup()
	{
		final Integer NUM_ACCOUNTS = 10;
		final Integer NUM_OPPTYS = 2;
		final String OPPTY_ZIP = '95559';
		setup();

		Tax_Information__c taxForOppty = new Tax_Information__c();
		taxForOppty.Name = OPPTY_ZIP;
		taxForOppty.State__c = testState.Id;
		insert taxForOppty;

		List<Account> testAccounts = TestUtils.createAccounts( NUM_ACCOUNTS, accountRecordType.Id, true );

		List<Opportunity> testOpportunities = new List<Opportunity>();
		for( Account anAccount : testAccounts )
		{
			testOpportunities.addAll( TestUtils.createOpportunities( NUM_OPPTYS, anAccount.Id, opportunityRecordType.Id, false ) );
		}
		for( Opportunity anOpportunity : testOpportunities )
		{
			anOpportunity.Shipping_Zip__c = OPPTY_ZIP;
		}

		Test.startTest();

			insert testOpportunities;

		Test.stopTest();

		List<Opportunity> insertedOpptys = [ SELECT Id, Taxation_Zip_Code__c FROM Opportunity ];
		System.assertEquals( NUM_ACCOUNTS * NUM_OPPTYS, insertedOpptys.size(), 'There should be as many opportunities as created' );
		for( Opportunity anOpportunity : insertedOpptys )
		{
			System.assertEquals( taxForOppty.Id, anOpportunity.Taxation_Zip_Code__c, 'The Opportunity should look up to the zip on its own postal if one is available' );
		}
	}

	@isTest(SeeAllData=true)
	static void testTouchOLIsOnShippingRateChange()
	{
		final Integer OLD_SHIPPING = 123;
		final Integer NEW_SHIPPING = 432;
		final Integer NUM_OPPTYS = 10;
		setup();

		Product2 testProduct = TestUtils.createProducts( 1, false )[0];
		testProduct.Delivery_Model__c = 'Print';
		insert testProduct;
		PricebookEntry testPBE = TestUtils.createPricebookEntry( testProduct.Id, TestUtils.standardPricebook.Id, true );

		List<Opportunity> testOpportunities = TestUtils.createOpportunities( NUM_OPPTYS, null, opportunityRecordType.Id, true );
		List<OpportunityLineItem> testOLIs = new List<OpportunityLineItem>();
		for( Opportunity anOpportunity : testOpportunities )
		{
			// relying on workflow to carry shipping rate onto OLIs
			anOpportunity.Shipping_Rate__c = OLD_SHIPPING;

			OpportunityLineItem anOLI = TestUtils.createOLIs( 1, testPBE.Id, anOpportunity.Id, false )[0];
			testOLIs.add( anOLI );
		}
		update testOpportunities;
		insert testOLIs;

		Test.startTest();

			for( Opportunity anOpportunity : testOpportunities )
			{
				anOpportunity.Shipping_Rate__c = NEW_SHIPPING;
			}
			update testOpportunities;

		Test.stopTest();

		List<OpportunityLineItem> updatedOLIs = [ SELECT Id, OLI_Shipping_Rate__c FROM OpportunityLineItem WHERE Id IN :testOLIs ];
		System.assertEquals( NUM_OPPTYS, updatedOLIs.size(), 'There should be as many OLIs as Opportunities' );
		for( OpportunityLineItem anOLI : updatedOLIs )
		{
			// again relying on workflow to populate value on OLI
			System.assertEquals( NEW_SHIPPING, anOLI.OLI_Shipping_Rate__c, 'OLIs rely on a workflow to get a new shipping value when its opportunity is updated' );
		}
	}
}