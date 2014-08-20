@isTest
private class EventServicesTest
{
    static testMethod void testAddCampaignToCalendar_CreateNewEvent()
    {
        Campaign testCampaign = KapTestUtil.createTestCampaigns( 1, true )[0];
        delete [ SELECT Id FROM Event ];

        Test.startTest();

            String returnedString = EventServices.addCampaignToCalendar( testCampaign.Id, UserInfo.getUserId() );

        Test.stopTest();

        List<Event> createdEvents = [ SELECT Id FROM Event ];
        System.assertEquals( 1, createdEvents.size(), 'There should be one event created' );
        System.assertEquals( null, returnedString, 'There should not be a message returned to the user' );
    }

    static testMethod void testAddCampaignToCalendar_UserAlreadyHasEvent()
    {
        Campaign testCampaign = KapTestUtil.createTestCampaigns( 1, true )[0];

        Test.startTest();

            String returnedString = EventServices.addCampaignToCalendar( testCampaign.Id, UserInfo.getUserId() );

        Test.stopTest();

        List<Event> createdEvents = [ SELECT Id FROM Event ];
        System.assertEquals( 1, createdEvents.size(), 'There should only be one auto-generated event for each user' );
        System.assertEquals( EventServices.EVENT_ALREADY_EXISTS, returnedString, 'The error string should communicate that there is already an event' );
    }

    static testMethod void testErrorHandling()
    {
        Campaign testCampaign = KapTestUtil.createTestCampaigns( 1, true )[0];
        testCampaign.StartDate = Date.today();
        testCampaign.EndDate = Date.today().addDays(-7);
        List<Event> initialEvents = [ SELECT Id FROM Event ];

        Test.startTest();

            // cause record failure by passing org id
            EventServices.createEventsForCampaigns( new Map<Id, Campaign>{ testCampaign.Id => testCampaign }, UserInfo.getOrganizationId() );
            EventServices.updateEventsForCampaigns( new Map<Id, Campaign>{ testCampaign.Id => testCampaign } );

        Test.stopTest();

        List<Event> createdEvents = [ SELECT Id FROM Event WHERE Id NOT IN :initialEvents ];
        System.assertEquals( 0, createdEvents.size(), 'There should be no events created for campaigns' );

        List<Event> updatedEvents = [ SELECT StartDateTime, EndDateTime FROM Event WHERE Id IN :initialEvents ];
        System.assertEquals( 1, updatedEvents.size(), 'There should only be one event that was created' );
        System.assert( updatedEvents[0].StartDateTime < updatedEvents[0].EndDateTime, 'The event should not have been updated' );
    }
}