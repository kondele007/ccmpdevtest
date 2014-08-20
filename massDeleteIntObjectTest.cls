@isTest
private class massDeleteIntObjectTest {
    public static testMethod void testBatch() {
    // Create 200 integration objects - this simulates one execute.  
    // Important - the Salesforce.com test framework only allows you to 
    // test one execute.  
    
       List <Integration_object__c> intobjects= new List<Integration_object__c>();
          for(integer i = 0; i<200; i++){
             Integration_Object__c intobject = new Integration_object__c(name='intobject'+i, object_id__c = '12345');
             intobjects.add(intobject);
          }
       
       insert intobjects;
       
       Test.StartTest();
       MassDeleteRecords massdelete = new MassDeleteRecords('SELECT ID FROM integration_object__c WHERE object_id__c=\'12345\' LIMIT 200');

       ID batchprocessid = Database.executeBatch(massdelete);
       Test.StopTest();
    
       System.AssertEquals(
               database.countquery('SELECT COUNT() FROM integration_object__c WHERE object_id__c=\'12345\''),
               0);  
       
    }
}