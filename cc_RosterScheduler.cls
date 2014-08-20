global class cc_RosterScheduler implements Schedulable {

    String query;
    ID Opp_ID;
    String rosterMasterID;
    String fileName;
    String jobName; 

    global cc_RosterScheduler (String q, ID oppId, String name, String rosterId, String job){
       query = q;
       Opp_ID = oppId;
       fileName = name;
       rosterMasterID = rosterId;
       jobName = job;
    }

    global cc_RosterScheduler (String q, String name,String rosterId){  
       query = q;
       rosterMasterID = rosterId;
       fileName = name;
    }

    global void execute(SchedulableContext sc) {    
        //Number count = [SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND (Status = 'Processing' OR Status = 'Preparing')];
        System.debug(LoggingLevel.INFO, '$$cc_RosterScheduler Batch Job Number=' + [SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND (Status = 'Processing' OR Status = 'Preparing')]);
        if ([SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND (Status = 'Processing' OR Status = 'Preparing')] < 3){
            if(jobName.equalsIgnoreCase('cc_Roster_Preprocessor')){
                cc_Roster_Preprocessor rosterPreprocessor = new cc_Roster_Preprocessor(query,Opp_ID,fileName,rosterMasterID);
                ID batchprocessid = Database.executeBatch(rosterPreprocessor);       
            }
            if(jobName.equalsIgnoreCase('cc_Roster_Batchload')){
                cc_Roster_Batchload batchLoad = new cc_Roster_Batchload(query,Opp_ID,fileName,rosterMasterID);
                ID batchprocessid = Database.executeBatch(batchLoad,3);      
            }
            if(jobName.equalsIgnoreCase('cc_OrderPlaceCallOutInBatch')){
                cc_OrderPlaceCallOutInBatch orderPlaceCallout = new cc_OrderPlaceCallOutInBatch(query,fileName);
                ID batchprocessid = Database.executeBatch(orderPlaceCallout,1);      
            }
        } else {
           //schedule this same schedulable class again in 2 mins
           cc_RosterScheduler rosterSched = new cc_RosterScheduler(query, Opp_ID, fileName, rosterMasterID, jobName);
           Datetime dt = Datetime.now().addMinutes(2);
           String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
           Id schedId = System.Schedule('RosterLoadRetry'+timeForScheduler,timeForScheduler,rosterSched);
        }

    }
}