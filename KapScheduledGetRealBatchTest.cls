@isTest(seealldata=true)
private class KapScheduledGetRealBatchTest {
public static testmethod void test() {
   
   Test.startTest();
 //Insert Custom settings record 
    /****  List<Kaplan_Custom_Config__c> Kapconflist = new List<Kaplan_Custom_Config__c>();
      Kaplan_Custom_Config__c KapConfig =new Kaplan_Custom_Config__c();
      KapConfig.Name='Kap Cust con';
      KapConfig.GetReal_Max_Retry_Count__c=5;
      Kapconflist.add(KapConfig);
      insert KapConflist;  ****/

   // Schedule the test job 
      String jobId = System.schedule('testKapScheduledGetRealBatch',KapScheduledGetRealBatch.CRON_EXP, new KapScheduledGetRealBatch());
   // Get the information from the CronTrigger API object 
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

   // Verify the expressions are the same 
      System.assertEquals(KapScheduledGetRealBatch.CRON_EXP, ct.CronExpression);
   // Verify the job has not run 
      System.assertEquals(0, ct.TimesTriggered);

   // Verify the next time the job will run 
      System.assertEquals('2023-08-04 00:00:00', String.valueOf(ct.NextFireTime));
      
   Test.stopTest();
   
      }
   }