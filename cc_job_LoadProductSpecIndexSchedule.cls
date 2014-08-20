global class cc_job_LoadProductSpecIndexSchedule  implements Schedulable{
   global static String CRON_EXP = '0 0 0 * * ?'; // Runs every day at midnight
   global static String query = 'Select e.Id From E_Product__c e';
   global void execute(SchedulableContext ctx) {
   	  //CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime FROM
	//					CronTrigger WHERE id = :ctx.getTriggerId()];
   	//  System.assertEquals(CRON_EXP, ct.CronExpression);
	//  System.assertEquals(0, ct.TimesTriggered);
   	  //cc_job_LoadProductSpecIndex b = new cc_job_LoadProductSpecIndex(query); 
   	  cc_job_LoadProductSpecIndex lpsi=new cc_job_LoadProductSpecIndex('Select Id from E_Product__c LIMIT 5');
      Database.executebatch(lpsi,5);  
   }
} 

/*
System script for scheduling
cc_job_LoadProductSpecIndexSchedule p = new cc_job_LoadProductSpecIndexSchedule();
String sch = '0 0 0 * * ?';    // Runs every day at midnight
system.schedule('Load Product Spec Index', sch, p);

*/