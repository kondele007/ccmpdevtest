public with sharing class ImplementationServices
{
    public static void setSalesRepFromOpportunity( List<Implementation__c> incomingImplementations )
    {
        Set<Id> opportunityIds = new Set<Id>();
        for( Implementation__c anImplementation : incomingImplementations )
        {
            opportunityIds.add( anImplementation.Opportunity__c );
        }
        Map<Id, Opportunity> opportunitiesWithOwners = new Map<Id, Opportunity>([ SELECT Id, OwnerId FROM Opportunity WHERE Id IN :opportunityIds ]);
        for( Implementation__c anImplementation : incomingImplementations )
        {
            if( opportunitiesWithOwners.containsKey( anImplementation.Opportunity__c ) )
            {
                anImplementation.Sales_Rep__c = opportunitiesWithOwners.get( anImplementation.Opportunity__c ).OwnerId;
            }
        }
    }
}