global class cc_Roster_Preprocessor implements Database.Batchable<sObject> {
	
	String query;
	ID Opp_ID;
	String rosterMasterID;
	String fileName;
	
	global cc_Roster_Preprocessor (String q, ID oppId, String name, String rosterId)
	{
	   query = q;
	   Opp_ID = oppId;
	   fileName = name;
	   rosterMasterID = rosterId;
	}
	global cc_Roster_Preprocessor (String q, String name,String rosterId)
	{	
	   query = q;
	   rosterMasterID = rosterId;
	   fileName = name;
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<CC_Rostering_Detail__c> rdList) {
        for(CC_Rostering_Detail__c rd : rdList){
            if(rd.Status__c == 'Loaded'){
                rdList = markDuplicate(rd, rdList);
                rdList = markMerged(rd, rdList); 
            }
        }
        update rdList;

	}
	
	global void finish(Database.BatchableContext BC) {
        cc_RosterScheduler rosterSched = new cc_RosterScheduler(query,Opp_ID,fileName,rosterMasterID, 'cc_Roster_Batchload');
        Datetime dt = Datetime.now().addSeconds(10);
        String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
        System.debug(LoggingLevel.INFO, '$$Roster timeForScheduler=' + timeForScheduler);
        Id schedId = System.Schedule('RosterBatchLoad'+timeForScheduler,timeForScheduler,rosterSched);
        System.debug(LoggingLevel.INFO, '$$Roster schedId=' + schedId);
        /*
        cc_Roster_Batchload batchLoad;
        if(Opp_ID == null){
            batchLoad = new cc_Roster_Batchload(query,fileName,rosterMasterID);
        }else{
            batchLoad = new cc_Roster_Batchload(query,Opp_ID,fileName,rosterMasterID);
        }
        ID batchprocessid = Database.executeBatch(batchLoad,7); 
        */      
        //batchLoad.execute();
	}

	public List<CC_Rostering_Detail__c> markDuplicate(CC_Rostering_Detail__c rdSample, List<CC_Rostering_Detail__c> scope){
    
    for(CC_Rostering_Detail__c rd : scope){
        if(rd.Status__c == 'Loaded'){
            //System.debug(LoggingLevel.INFO, '$$Roster rd=' + rd);
            //System.debug(LoggingLevel.INFO, '$$Roster rdSample=' + rdSample);
            //System.debug(LoggingLevel.INFO, '$$Roster rd.Id=' + rd.Id);
            if (rdSample.Student_ID__c != null
                && rdSample.Student_ID__c == rd.Student_ID__c
                && rdSample.Class_Code__c.equalsIgnoreCase(rd.Class_Code__c)
                && rdSample.Id != rd.Id){
                rd.Status__c = 'Duplicate';         
                rd.Notes__c = rdSample.Id;
                
            }
            if (rdSample.First_Name__c.equalsIgnoreCase(rd.First_Name__c) 
                && rdSample.Last_Name__c.equalsIgnoreCase(rd.Last_Name__c)
                && rdSample.Email__c.equalsIgnoreCase(rd.Email__c)
                && rdSample.Class_Code__c.equalsIgnoreCase(rd.Class_Code__c)
                && rdSample.Id != rd.Id){
                rd.Status__c = 'Duplicate';
                rd.Notes__c = rdSample.Id + ' - There was a duplicate classcode for this student on the roster.' ;
                
            }
        }          
    }
    return scope; 

	}


	public List<CC_Rostering_Detail__c> markMerged(CC_Rostering_Detail__c rdSample, List<CC_Rostering_Detail__c> scope){
        System.debug(LoggingLevel.INFO, '$$Roster Merged rdSample' + rdSample);    
    for(CC_Rostering_Detail__c rd : scope){
        if(rd.Status__c == 'Loaded'){
            //System.debug(LoggingLevel.INFO, '$$Roster Merged rd=' + rd);
            if(rdSample.Student_ID__c != null
                && rdSample.Student_ID__c == rd.Student_ID__c 
                && !rdSample.Class_Code__c.equalsIgnoreCase(rd.Class_Code__c)
                && rdSample.Id != rd.Id){
                //System.debug(LoggingLevel.INFO, '$$Roster Merged with Student ID Before=' + rd);
                rd.Status__c = 'Merged';
                rdSample.Class_Code__c = rdSample.Class_Code__c+','+rd.Class_Code__c;       
                rd.Notes__c = rdSample.Id;  
                //System.debug(LoggingLevel.INFO, '$$Roster Merged with Student ID After=' + rd);
            }   
            if(rdSample.First_Name__c.equalsIgnoreCase(rd.First_Name__c) 
                && rdSample.Last_Name__c.equalsIgnoreCase(rd.Last_Name__c)
                && rdSample.Email__c.equalsIgnoreCase(rd.Email__c)
                && !rdSample.Class_Code__c.equalsIgnoreCase(rd.Class_Code__c)
                && rdSample.Id != rd.Id){
                //System.debug(LoggingLevel.INFO, '$$Roster Merged without Student ID Before=' + rd);
                rdSample.Class_Code__c = rdSample.Class_Code__c+','+rd.Class_Code__c;
                rd.Status__c = 'Merged';
                rd.Notes__c = rdSample.Id;
                //System.debug(LoggingLevel.INFO, '$$Roster Merged without Student ID After=' + rd);            
            }
        }       
    }
    return scope;

	}
	
}