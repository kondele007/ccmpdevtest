global class massScheduledCleanupBatch implements Schedulable{

   public static String CRON_EXP = '0 0 0 3 9 ? 2022';
    global void execute(SchedulableContext SC) {      
       deleteIntegrationObjects();
       deleteInteractions();
      // disablePortalUsers();                       
    }
    
    global void deleteIntegrationObjects() {
       MassDeleteRecords massdelete = new MassDeleteRecords('SELECT ID FROM integration_object__c WHERE (GetReal_Status_Code__c = 10 and lastModifiedDate < LAST_N_DAYS:7) or (lastModifiedDate < LAST_N_DAYS:30)');
       Database.executeBatch(massdelete);         
    }
    
    global void deleteInteractions() {
       MassDeleteRecords massdelete  = new MassDeleteRecords('SELECT ID FROM interaction__c where lastModifiedDate < YESTERDAY');
       Database.executeBatch(massdelete);         
    }
    
    /***global void disablePortalUsers() {
       datetime myDateTime = datetime.now();
       datetime newDateTime = myDateTime.addHours(-3);           
       String newDateTimeString = newDateTime.format('yyyy-MM-dd') + 'T' + newDateTime.format('HH:mm:ss') + 'Z';                    
       String query = 'SELECT ID FROM User WHERE isActive=true and IsPortalSelfRegistered = true and lastLoginDate < ' + newDateTimeString;              
       
       MassUpdate massupdate = new MassUpdate(query, 'IsActive', false);
       Database.executeBatch(massupdate );    
    }****/

}