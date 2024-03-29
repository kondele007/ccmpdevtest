@isTest
private class massScheduledCleanupBatchTest {
public static testmethod void test() {
   
   Test.startTest();

   // Schedule the test job 
      String jobId = System.schedule('testMassScheduledApex',massScheduledCleanupBatch.CRON_EXP, new massScheduledCleanupBatch());
   // Get the information from the CronTrigger API object 
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

   // Verify the expressions are the same 
      System.assertEquals(massScheduledCleanupBatch.CRON_EXP, ct.CronExpression);
   // Verify the job has not run 
      System.assertEquals(0, ct.TimesTriggered);

   // Verify the next time the job will run 
      System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));
      
   Test.stopTest();
   
      }
   }