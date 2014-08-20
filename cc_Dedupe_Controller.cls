public class cc_Dedupe_Controller {
    
    String rosteringMasterId;
    List<RosterDetailWrapper> rosterDetailList = new List<RosterDetailWrapper>();
    Integer count = 0;
    Map<id,CC_Rostering_Detail__c> mapRosterDetail = new Map<id,CC_Rostering_Detail__c>();

     public cc_Dedupe_Controller() {
        rosteringMasterId = ApexPages.currentPage().getParameters().get('id');
     
     }

     public List<RosterDetailWrapper> getRosterDetails(){
        List<CC_Rostering_Detail__c> rdList = [Select First_Name__c,Last_Name__c,Email__c,Program_Of_Interest__c,Student_Id__c, Notes__c from CC_Rostering_Detail__c where Status__c = 'Dedupe' and CC_Rostering_Master__c = :rosteringMasterId Limit 15];
        Account personAccount;
        List<cc_Dedupe_Data> dedDupeDataList;
        for(CC_Rostering_Detail__c rd : rdList){
            mapRosterDetail.put(rd.id,rd);
            dedDupeDataList = new List<cc_Dedupe_Data>();
            count++;
            dedDupeDataList.add(new cc_Dedupe_Data(rd, count));
            String[] accountIds = getAccountIds(rd.Notes__c);
            System.debug(LoggingLevel.INFO,'accountIds' + accountIds);
            for (Integer i=0;i<accountIds.size();i++){
                System.debug(LoggingLevel.INFO,'accountIds Array' + accountIds[i]);
                personAccount = [Select ID, FirstName, LastName, PersonEmail,Programs_Of_Interest__c, Student_ID__c, IsPortalUser__pc from Account where ID = :accountIds[i]];
                dedDupeDataList.add(new cc_Dedupe_Data(personAccount, count, rd.id));
            }
            rosterDetailList.add(new RosterDetailWrapper(dedDupeDataList));
        }
        System.debug(LoggingLevel.INFO,'rosterDetailList' + rosterDetailList);
        System.debug(LoggingLevel.INFO,'Map Content' + mapRosterDetail);
        System.debug(LoggingLevel.INFO,'Map keys' + mapRosterDetail.keySet());
        return rosterDetailList; 
     }

    public PageReference uploadRoster() {
        rosterDetailList.clear();
        List<CC_Rostering_Detail__c> rdList = new List<CC_Rostering_Detail__c>();
        for(CC_Rostering_Detail__c rd : mapRosterDetail.values()){
            System.debug(LoggingLevel.INFO,'uploadRoster - CC_Rostering_Detail__c' + rd);
            rdList.add(rd);
        }
        System.debug(LoggingLevel.INFO,'uploadRoster - rdList' + rdList);
        update rdList;

        E_Rostering_Master__c rm = [Select id, Name, Opportunity__r.id from E_Rostering_Master__c where id =: rosteringMasterId];
        ID OppId = rm.Opportunity__r.Id;
        String query = 'select Id,  First_Name__c, Last_Name__c, Email__c, Street_Address_Line_1__c, Street_Address_Line_2__c, State__c, City__c, Zipcode__c, CC_Rostering_Master__c, Country__c, Phone__c, Program_Of_Interest__c, School_Id__c, Graduation_Year__c, Student_Id__c, Center_Code__c, Do_Not_Email__c, Do_Not_Call__c, Channel__c, Start_Date__c, End_Date__c, Class_Code__c, Transaction_Code__c, Balance_Due__c, Lead_Source_ID__c, Status__c, Notes__c from CC_Rostering_Detail__c where CC_Rostering_Master__c = \'' + rosteringMasterId+ '\' and Status__c IN( \'' +'DedupeCreate'+'\',\''+'DedupeMerge'+ '\')'  ;
        System.debug(LoggingLevel.INFO, '$$Roster query=' + query);
        System.debug(LoggingLevel.INFO, '$$Roster opp=' + OppId);
        cc_RosterScheduler rosterSched = new cc_RosterScheduler(query,OppId,'Dedupe_err_'+rm.Name,rm.Id, 'cc_Roster_Batchload');
        Datetime dt = Datetime.now().addSeconds(10);
        String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
        System.debug(LoggingLevel.INFO, '$$Roster timeForScheduler=' + timeForScheduler);
        Id schedId = System.Schedule('RosterDedupeProcessor'+timeForScheduler,timeForScheduler,rosterSched);
        System.debug(LoggingLevel.INFO, '$$Roster schedId=' + schedId);
/*
        cc_Roster_Batchload batchLoad;
        //if(OppId == null){
            //batchLoad = new cc_Roster_Batchload(query,'Dedupe_err_'+rm.Name, rm.Id);
        //}else{
            batchLoad = new cc_Roster_Batchload(query,OppId,'Dedupe_err_'+rm.Name, rm.Id);
        //}
        ID batchprocessid = Database.executeBatch(batchLoad,11);       
        //batchLoad.execute();
*/
        ApexPages.Message successMsg = new ApexPages.Message(ApexPages.severity.INFO,'The Job to upload the Dedupe Records has been submitted. You will be notified by email when it is complete.');
        ApexPages.addMessage(successMsg);
        return null;
    }

    public PageReference cancel() {
        rosterDetailList.clear();
        return null;
    }

    public PageReference getSelected() {
        String rosterID = ApexPages.currentPage().getParameters().get('rosterId');
        String type = ApexPages.currentPage().getParameters().get('source');
        string recordID = ApexPages.currentPage().getParameters().get('recordId');
        CC_Rostering_Detail__c rd = mapRosterDetail.get(rosterID);
        System.debug(LoggingLevel.INFO,'getSelected - CC_Rostering_Detail__c' + rd);        
        System.debug(LoggingLevel.INFO,'getSelected - rosterID' + rosterID);
        System.debug(LoggingLevel.INFO,'getSelected - type' + type);
        System.debug(LoggingLevel.INFO,'getSelected - recordID' + recordID);
        if(type.equalsIgnoreCase('Roster')){
            rd.Status__c = 'DedupeCreate';
            rd.Notes__c = '';
        }else{
            rd.Status__c = 'DedupeMerge';
            rd.Notes__c = recordID;
        }
        System.debug(LoggingLevel.INFO,'---------- rd.Notes__c ---------- ' + rd.Notes__c);
        update rd;
        return null;
    }

     public String[] getAccountIds(String accountIds){
        String[] inputValues = new String[]{};
        String accountIdValues;
        String value;
        inputvalues = accountIds.split(',');  
        System.debug(LoggingLevel.INFO,'inputvalues' + inputvalues);    
        for (Integer i=0;i<inputValues.size();i++){
            value = inputValues[i];
                if(!value.startsWith('--')){
                    if(accountIdValues == null){
                        accountIdValues = value;
                    }else{
                        accountIdValues = accountIdValues + ',' + value;
                    }
                }
            System.debug(LoggingLevel.INFO,'value' + value);
        }
        return accountIdValues.split(',');

     }


     public class RosterDetailWrapper {
         public List<cc_Dedupe_Data> deDupeList{get; set;}
         public Boolean selected{get; set;}
         public RosterDetailWrapper(List<cc_Dedupe_Data> dedupeDataList) {
            deDupeList = dedupeDataList;
         }
     }

    public class cc_Dedupe_Data {
        public ID recordID {get; set;}
        public String type {get; set;}
        public String fName {get; set;}
        public String lName {get; set;}
        public String email {get; set;}
        public Integer index {get; set;}
        public ID rosterDetailID {get; set;}
        public String programOfInterest {get; set;}
        public Decimal studentID {get; set;}
        public Boolean isPortalUser {get; set;}
        public cc_Dedupe_Data(CC_Rostering_Detail__c rd, Integer num) {
            System.debug(LoggingLevel.INFO,'cc_Dedupe_Data Constructor for Rostering Detail' + rd.id); 
            type = 'Roster';
            fName = rd.First_Name__c;
            lName = rd.Last_Name__c;
            email = rd.Email__c;
            recordID = rd.ID;
            index = num;
            rosterDetailID = rd.ID;
            programOfInterest = rd.Program_Of_Interest__c;
            studentID = rd.Student_Id__c;
            //isPortalUser = null;

        }

        public cc_Dedupe_Data(Account acc, Integer num, ID rosterID) {
            System.debug(LoggingLevel.INFO,'cc_Dedupe_Data Constructor for Account' + acc.id); 
            type = 'Org';
            fName = acc.FirstName;
            lName = acc.LastName;
            email = acc.PersonEmail;
            recordID = acc.ID;
            index = num;
            rosterDetailID = rosterID;
            programOfInterest = acc.Programs_Of_Interest__c;
            studentID = acc.Student_ID__c;
            isPortalUser = acc.IsPortalUser__pc;

        }
    }
 }