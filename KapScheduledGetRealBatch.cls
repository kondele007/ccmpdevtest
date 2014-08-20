/******************************************************************************
** Module Name   : KapScheduledGetRealBatch
** Description   : A Schedulable class for scheduling GetReal Batch
**                 integration jobs.
**                 A job can be scheduled at a minimum every hour 
**                 Upto 10 jobs can be scheduled per org to give us an
**                 interval of 6 minutes each
**                      KapScheduledGetRealBatch sb = new KapScheduledGetRealBatch();
**                      String cron_sched_00 = '00 00 * * * * *';
**                          ... 
**                      String cron_sched_nn = '00 xx * * * * *';
**                          ... 
**                      String cron_sched_54 = '00 54 * * * * *';
**                      system.schedule('Sched 1 - hh:00 min', cron_sched_01, sb);
**                          . 
**                          . 
**                          . 
**                      system.schedule('Sched n - hh:nn min', cron_sched_nn, sb);
**                          . 
**                          . 
**                          . 
**                      system.schedule('Sched 10 - hh:54 min', cron_sched_54, sb);
**
**                  The batch size for the batch job is specfied as 1 since Salesforce.com
**                  allows only 1 Http callout per batch invocation.
** 
** Technial Info : <Classes, Methods, etc>
** 
** Author(s)     : George Koodarappally (GK) - Acumen Solutions
** Revision History:-
** Version  Date        Author  Description of Action
** 1.0      03/01/2011  GK  Initiated Script
******************************************************************************/

global class KapScheduledGetRealBatch implements Schedulable{
 public static String CRON_EXP = '0 0 0 4 8 ? 2023';
//Added the above line to be used in the test class
    global void execute(SchedulableContext SC) {
        KapSendToGetRealBatch b = new KapSendToGetRealBatch();
        database.executebatch(b, 1);
    }

}