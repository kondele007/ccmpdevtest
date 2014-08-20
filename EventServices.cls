global with sharing class EventServices
{
    public static final String EVENT_ALREADY_EXISTS = 'This Campaign is already on your calendar.';

    webservice static String addCampaignToCalendar( Id campaignId, Id ownerId )
    {
        String returnString = null;

        List<Event> existingEvent = [ SELECT Id FROM Event WHERE WhatId = :campaignId AND OwnerId = :ownerId ];
        if( existingEvent.isEmpty() )
        {
            List<Campaign> theCampaign = [ SELECT Id, Location__c, Account__c, StartDate, Start_Time__c, EndDate, End_Time__c, Type,Campaign.Name FROM Campaign WHERE Id = :campaignId ];
            createEventsForCampaigns( new Map<Id, Campaign>( theCampaign ), ownerId );
        }
        else
        {
            returnString = EVENT_ALREADY_EXISTS;
        }

        return returnString;
    }

    public static void createEventsForCampaigns( Map<Id, Campaign> incomingCampaigns, Id ownerId )
    {
        Set<Id> accountIds = new Set<Id>();
        for( Campaign aCampaign : incomingCampaigns.values() )
        {
            accountIds.add( aCampaign.Account__c );
        }
        Map<Id, Account> accountsMap = new Map<Id, Account>([ SELECT Id, Name FROM Account WHERE Id IN :accountIds ]);

        List<Event> eventsToCreate = new List<Event>();
        for( Campaign aCampaign : incomingCampaigns.values() )
        {
            String accountName = accountsMap.containsKey(aCampaign.Account__c) ? accountsMap.get(aCampaign.Account__c).Name : '';

            Event newEvent = new Event();
            newEvent.Subject = aCampaign.Name;
            newEvent.WhatId = aCampaign.Id;
            newEvent.OwnerId = ownerId;
            newEvent.Location = aCampaign.Location__c;

            String startDatetimeToParse = aCampaign.StartDate.format() + ' ' + aCampaign.Start_Time__c;
            String endDatetimeToParse = aCampaign.EndDate.format() + ' ' + aCampaign.End_Time__c;

            newEvent.StartDateTime = DateTime.parse( startDatetimeToParse );
            newEvent.EndDateTime = DateTime.parse( endDatetimeToParse );
            newEvent.Auto_Generated__c = TRUE;
            eventsToCreate.add( newEvent );
        }
        try
        {
            insert eventsToCreate;
        }
        catch( System.DmlException ex )
        {
            for( Integer errorIndex = 0; errorIndex < ex.getNumDml(); errorIndex++ )
            {
                Id errorId = eventsToCreate[ ex.getDmlIndex(errorIndex) ].WhatId;
                incomingCampaigns.get( errorId ).addError( ex.getDmlMessage(errorIndex) );
            }
        }
    }

    public static void updateEventsForCampaigns( Map<Id, Campaign> incomingCampaigns )
    {
        List<Event> childEvents = [ SELECT Id, WhatId FROM Event WHERE WhatId IN :incomingCampaigns.values() AND Auto_Generated__c = TRUE ];
        for( Event anEvent : childEvents )
        {
            Campaign aCampaign = incomingCampaigns.get( anEvent.WhatId );
            String startDatetimeToParse = aCampaign.StartDate.format() + ' ' + aCampaign.Start_Time__c;
            String endDatetimeToParse = aCampaign.EndDate.format() + ' ' + aCampaign.End_Time__c;

            anEvent.StartDateTime = DateTime.parse( startDatetimeToParse );
            anEvent.EndDateTime = DateTime.parse( endDatetimeToParse );
        }

        try
        {
            update childEvents;
        }
        catch( System.DmlException ex )
        {
            for( Integer errorIndex = 0; errorIndex < ex.getNumDml(); errorIndex++ )
            {
                Id errorId = childEvents[ ex.getDmlIndex(errorIndex) ].WhatId;
                incomingCampaigns.get( errorId ).addError( ex.getDmlMessage( errorIndex ) );
            }
        }
    }
}