/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 *
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class kapAddChangedTaskRecToInt_AIAUTest {

    @isTest(SeeAllData=true)
    static void myUnitTest() {
        // Add 'Test Account' to Account table
        Account testAccount = KapTestUtil.createTestAccount();
        // Add 'Test Case' to Case table for parent 'testAccount'
        Case testAccountCase = KapTestUtil.createTestAccountCase(testAccount,'New');

        test.startTest();

        Task testAccoutTask = KapTestUtil.createTestAccountActivity(testAccount);

        testAccoutTask.Status = 'Completed';
        update testAccoutTask;

        // Add 'Test Case Activity' to Task table
        Task testCaseTask = KapTestUtil.createTestCaseActivity(testAccountCase);

        testCaseTask.Status = 'Completed';
        update testCaseTask;

        /*
        Integration_Object__c intObject = [SELECT Id, Object_Id__c, Object_Type__c, Student_Id__c, Legacy_Parent_Id__c, User_Name__c, KBS_User_Id__c, Retry_Count__c, Record_Number__c, Message_Id_Suffix_Iterator__c  FROM Integration_Object__c WHERE Object_Id__c = :testAccoutTask.Id];

        System.assert(intObject != null);
        System.assertEquals(intObject.Object_Id__c, testAccoutTask.Id);
        System.assertEquals(intObject.Object_Type__c, 'Account Task');

        List<Integration_Object_Field__c> intObjFieldList = [Select Id, Integration_Object__c from Integration_Object_Field__c where Integration_Object__c = :intObject.Id];
        System.assert(intObjFieldList != null);
        System.assert(intObjFieldList.size() > 0);
        */

        test.stopTest();
    }

    private static testMethod void testKapAddChangedTaskRecordToIntegration_TaskNotRelatedToObject () {

        final Integer NUM_OF_TASKS = 10;

        System.runAs( KapTestUtil.ADMIN_USER )
        {
            insert new Kaplan_Custom_Config__c (Name = 'Kaplan Custom Config', ETL_Load_Username__c = 'some@username.com');
        }

        List<Task> testTasks = new List<Task>();
        for ( Integer i = 0 ; i < NUM_OF_TASKS ; ++i )
        {
            testTasks.add ( new Task( Subject = 'Activty Subject', Status = 'Not Started' ) );
        }

        Test.startTest();
            insert testTasks;
        Test.stopTest();

        Set<String> taskIds = new Set<String>();
        for ( Task t : testTasks )
        {
            taskIds.add(t.Id);
        }

        List<Integration_Object__c> actualIntegrations = [SELECT Status__c, Student_Id__c , User_Name__c, KBS_User_Id__c,
                                                                 Retry_Count__c, Message_Id_Suffix_Iterator__c
                                                         FROM Integration_Object__c
                                                         WHERE Object_Id__c IN :taskIds];

       // System.assertEquals( NUM_OF_TASKS, actualIntegrations.size(), 'There should be on integration per task');

        for ( Integration_Object__c  integration: actualIntegrations )
        {
            System.assertEquals('New', integration.Status__c) ;
            System.assertEquals(Userinfo.getUserName(), integration.User_Name__c) ;
            System.assertEquals(0 , integration.Retry_Count__c) ;
            System.assertEquals(0 , integration.Message_Id_Suffix_Iterator__c) ;
        }

    }

}