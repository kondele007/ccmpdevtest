@isTest
private class ImplementationServicesTests
{
    static testMethod void test()
    {
        final Integer NUM_RECORDS = 15;

        Profile standardProfile = [ SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1 ];
        List<User> testOwners = KapTestUtil.createUsers( NUM_RECORDS, standardProfile.Id, true );

        List<Opportunity> testOpportunities = new List<Opportunity>();
        for( User anOwner : testOwners )
        {
            Opportunity newOpportunity = KapTestUtil.createOpportunities( 1, false )[0];
            newOpportunity.OwnerId = anOwner.Id;
            testOpportunities.add( newOpportunity );
        }
        insert testOpportunities;

        List<Implementation__c> testImplementations = new List<Implementation__c>();
        for( Opportunity anOpportunity : testOpportunities )
        {
        	Implementation__c testImplementation = KapTestUtil.createImplementations( 1, false )[0];
        	testImplementation.Opportunity__c = anOpportunity.Id;
        	testImplementations.add( testImplementation );
        }
        testImplementations[0].Opportunity__c = null;

        Test.startTest();

            ImplementationServices.setSalesRepFromOpportunity( testImplementations );

        Test.stopTest();

        Map<Id, Opportunity> opportunitiesMap = new Map<Id, Opportunity>( testOpportunities );
        for( Implementation__c anImpl : testImplementations )
        {
            if( opportunitiesMap.containsKey( anImpl.Opportunity__c ) )
            {
            	System.assertEquals( opportunitiesMap.get( anImpl.Opportunity__c ).OwnerId, anImpl.Sales_Rep__c, 'The owner on the Opportunity should be set on the Impl' );
            }
            else
            {
            	System.assertEquals( null, anImpl.Sales_Rep__c, 'The sales rep should not be modified if there is no owner set' );
            }
        }
    }
}