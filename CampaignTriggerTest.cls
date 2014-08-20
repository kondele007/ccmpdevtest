@isTest
public class CampaignTriggerTest
{
    static testMethod void testCreateEventsForCampaigns()
    {
        final Integer NUM_CAMPAIGNS = 10;

        List<Campaign> testCampaigns = KapTestUtil.createTestCampaigns( NUM_CAMPAIGNS, false );
        for( Integer index = 0; index < NUM_CAMPAIGNS; index++ )
        {
            testCampaigns[index].StartDate = Date.today().addMonths(index);
            testCampaigns[index].EndDate = testCampaigns[index].StartDate.addDays(5);
        }

        Test.startTest();

            insert testCampaigns;

        Test.stopTest();

        List<Event> createdEvents = [ SELECT Id, Auto_Generated__c, EndDateTime, StartDateTime, WhatId FROM Event ];
        System.assertEquals( NUM_CAMPAIGNS, createdEvents.size(), 'There should be as many Events as Campaigns' );

        Map<Id, Event> campaignIdToEvent = new Map<Id, Event>();
        for( Event anEvent : createdEvents )
        {
            campaignIdToEvent.put( anEvent.WhatId, anEvent );
            System.assert( anEvent.Auto_Generated__c, 'Every event created this way should be marked as auto generated' );
        }

        for( Campaign aCampaign : testCampaigns )
        {
            System.assert( campaignIdToEvent.containsKey( aCampaign.Id ), 'Every campaign should have an Event created for it' );
            Event createdEvent = campaignIdToEvent.get( aCampaign.Id );
            System.assertEquals( aCampaign.StartDate, createdEvent.StartDateTime.date(), 'The Campaigns start date should be set on the Event' );
            System.assertEquals( aCampaign.EndDate, createdEvent.EndDateTime.date(), 'The Campaigns end date should be set on the Event' );
        }
    }

    static testMethod void testUpdateEventsForCampaigns()
    {
        final Integer NUM_CAMPAIGNS = 10;

        List<Campaign> testCampaigns = KapTestUtil.createTestCampaigns( NUM_CAMPAIGNS, true );

        Test.startTest();

            for( Integer index = 0; index < NUM_CAMPAIGNS; index++ )
            {
                testCampaigns[index].StartDate = Date.today().addMonths(index);
                testCampaigns[index].EndDate = testCampaigns[index].StartDate.addDays(5);
            }
            update testCampaigns;

        Test.stopTest();

        List<Event> updatedEvents = [ SELECT Id, EndDateTime, StartDateTime, WhatId FROM Event ];
        System.assertEquals( NUM_CAMPAIGNS, updatedEvents.size(), 'There should be as many Events as Campaigns' );

        Map<Id, Event> campaignIdToEvent = new Map<Id, Event>();
        for( Event anEvent : updatedEvents )
        {
            campaignIdToEvent.put( anEvent.WhatId, anEvent );
        }

        for( Campaign aCampaign : testCampaigns )
        {
            Event createdEvent = campaignIdToEvent.get( aCampaign.Id );
            System.assertEquals( aCampaign.StartDate, createdEvent.StartDateTime.date(), 'The Campaigns start date should be set on the Event' );
            System.assertEquals( aCampaign.EndDate, createdEvent.EndDateTime.date(), 'The Campaigns end date should be set on the Event' );
        }
    }
}