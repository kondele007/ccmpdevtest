public with sharing class KapScheduler {

   public static Boolean runTestMethod = FALSE;
 
    public static void scheduleGetRealJobs() {
        KapScheduledGetRealBatch sb = new KapScheduledGetRealBatch();
        String cron_sched_01 = '00 00 * * * ? *';
        String cron_sched_02 = '00 06 * * * ? *';
        String cron_sched_03 = '00 12 * * * ? *';
        String cron_sched_04 = '00 18 * * * ? *';
        String cron_sched_05 = '00 24 * * * ? *';
        String cron_sched_06 = '00 30 * * * ? *';
        String cron_sched_07 = '00 36 * * * ? *';
        String cron_sched_08 = '00 42 * * * ? *';
        String cron_sched_09 = '00 48 * * * ? *';
        String cron_sched_10 = '00 54 * * * ? *';
        String cron_sched_11 = '00 56 * * * ? *';

        if(runTestMethod){
        system.schedule('Sched 1 - hh:00 min'+DateTime.Now()+'', cron_sched_01, sb);
        system.schedule('Sched 2 - hh:06 min'+DateTime.Now()+'', cron_sched_02, sb);
        system.schedule('Sched 3 - hh:12 min'+DateTime.Now()+'', cron_sched_03, sb);
        system.schedule('Sched 4 - hh:18 min'+DateTime.Now()+'', cron_sched_04, sb);
       // system.schedule('Sched 5 - hh:24 min'+DateTime.Now()+'', cron_sched_05, sb);
        }
        else{
        system.schedule('Sched 1 - hh:00 min'+DateTime.Now()+'', cron_sched_01, sb);system.schedule('Sched 2 - hh:06 min'+DateTime.Now()+'', cron_sched_02, sb);system.schedule('Sched 3 - hh:12 min'+DateTime.Now()+'', cron_sched_03, sb);system.schedule('Sched 4 - hh:18 min'+DateTime.Now()+'', cron_sched_04, sb);system.schedule('Sched 5 - hh:24 min'+DateTime.Now()+'', cron_sched_05, sb);system.schedule('Sched 6 - hh:30 min'+DateTime.Now()+'', cron_sched_06, sb);system.schedule('Sched 7 - hh:36 min'+DateTime.Now()+'', cron_sched_07, sb); system.schedule('Sched 8 - hh:42 min'+DateTime.Now()+'', cron_sched_08, sb);system.schedule('Sched 9 - hh:48 min'+DateTime.Now()+'', cron_sched_09, sb);system.schedule('Sched 10 - hh:54 min'+DateTime.Now()+'', cron_sched_10, sb);
        }     
    }
    
    
    private static void killCronScheduledJob(String cronSchedule) {
        List<CronTrigger> cts;
        
        cts = [SELECT Id FROM CronTrigger WHERE CronExpression = :cronSchedule];    
        
        if (cts.size() > 0)
            System.abortJob(cts[0].Id);
    }
    
    
    public static void unScheduleGetRealJobs(){
        String cron_sched_01 = '00 00 * * * ? *';
        String cron_sched_02 = '00 06 * * * ? *';
        String cron_sched_03 = '00 12 * * * ? *';
        String cron_sched_04 = '00 18 * * * ? *';
        String cron_sched_05 = '00 24 * * * ? *';
        String cron_sched_06 = '00 30 * * * ? *';
        String cron_sched_07 = '00 36 * * * ? *';
        String cron_sched_08 = '00 42 * * * ? *';
        String cron_sched_09 = '00 48 * * * ? *';
        String cron_sched_10 = '00 54 * * * ? *';
        
        killCronScheduledJob(cron_sched_01);    
        killCronScheduledJob(cron_sched_02);    
        killCronScheduledJob(cron_sched_03);    
        killCronScheduledJob(cron_sched_04);    
        killCronScheduledJob(cron_sched_05);    
        killCronScheduledJob(cron_sched_06);    
        killCronScheduledJob(cron_sched_07);    
        killCronScheduledJob(cron_sched_08);    
        killCronScheduledJob(cron_sched_09);    
        killCronScheduledJob(cron_sched_10);    
    }
    
    /*
    public static void unscheduleApexJobs(){
         List<AsyncApexJob> sJobList = [Select Id from AsyncApexJob where ApexClassId = '01pM0000000CgIB' and status != null];
         for(AsyncApexJob sJob :sJobList){
         System.abortJob(sJob.Id);
         }
    }
    */
    
   
}