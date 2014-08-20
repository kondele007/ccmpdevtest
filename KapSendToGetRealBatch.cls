/******************************************************************************
** Module Name   : KapSendToGetRealBatch
** Description   : A Batch job for sending GetReal messages to the GetReal
**                 server.
** 
** Technial Info : <Classes, Methods, etc>
** 
** Author(s)     : George Koodarappally (GK) - Acumen Solutions
** Revision History:-
** Version  Date        Author  Description of Action
** 1.0      03/01/2011  GK      Initiated Script
** 2.0      10/04/2011  GK      Modifications to handle GetReal code errors
******************************************************************************/

global class KapSendToGetRealBatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    Global String query;
    Global integer numRecs, numTotal, numSuccess, numFailure;
    
    private static Kaplan_Custom_Config__c kap_config = Kaplan_Custom_Config__c.getValues('Kaplan Custom Config');
    private static Integer getRealMaxRetryCount = Integer.valueOf(kap_config.GetReal_Max_Retry_Count__c);
    public static String CRON_EXP = '0 0 0 5 5 ? 2025';
    
    global KapSendToGetRealBatch(){
        numRecs = numTotal = numSuccess = numFailure = 0;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        
        System.Debug('***************************************');
        System.Debug('Hello from Batch');
        System.Debug('***************************************');

        query = 'SELECT Id, Object_Id__c, Object_Type__c, Student_Id__c, Legacy_Parent_Id__c, User_Name__c, KBS_User_Id__c, Retry_Count__c, Record_Number__c, Message_Id_Suffix_Iterator__c FROM Integration_Object__c';
        query = query+' WHERE Status__c IN (\'New\',\'Retry\') ';
        query = query+' AND Retry_Count__c < '+getRealMaxRetryCount;
        query = query+' ORDER BY LastModifiedDate ASC';
        
        System.Debug('***************************************');
        System.Debug('In Batch "start": query = '+query);
        System.Debug('***************************************');
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        Integration_Object__c intObject;
        String xmlRequest;
        Boolean bMessageGenerated, bGetRealMessageSent;
        
        if (scope.size() == 0)
            return;
        
        for (sObject s: scope) {
            intObject = (Integration_Object__c)s;
            
            System.Debug('***************************************');
            System.Debug('In Batch Execute; Object Id: '+intObject.Id);
            System.Debug('***************************************');
            
            KapXmlResponseWS xmlResponse;
            KapGetRealWS getRealWSStub = new KapGetRealWS();
            //String xmlRequest='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><message_batch client_name="iap-dev" message_group_id="1290402"><message message_id="11200045422"><person client_sys_id="IAP1297292289378" uid="1501200166"><f_name>Restinger</f_name><l_name>Security</l_name></person></message></message_batch>';
            
            bMessageGenerated = false;
            bGetRealMessageSent = false;
            
            try {
                xmlRequest = KapGetRealUtil.createMessageList(intObject);
                bMessageGenerated = true;
                xmlRequest = xmlRequest.replaceAll('><','>\n<');
                
                System.Debug('***************************************');
                System.Debug('In Batch Execute; GetReal Request : '+xmlRequest);
                System.Debug('***************************************');
            } catch (Exception e) {
                System.Debug(e);
                KapGetRealUtil.handleGetRealError('Unable to generate outbound XML request', '', xmlResponse, intObject); 
            }
                
            if (bMessageGenerated) {
                try {
                    xmlResponse = getRealWSStub.StudentProfileUpdate(xmlRequest);
                    bGetRealMessageSent = true;
                    
                    System.Debug('***************************************');
                    System.Debug('In Batch Execute; GetReal Request : '+xmlRequest);
                    System.Debug('In Batch Execute; GetReal Response : '+xmlResponse);
                    System.Debug('***************************************');
                } catch (Exception e) {
                    System.Debug(e);
                    KapGetRealUtil.handleGetRealError('Error sending out GetReal XML request', xmlRequest, xmlResponse, intObject); 
                }
            }
            
            if (bGetRealMessageSent) {
                KapGetRealUtil.handleGetRealResponse(xmlRequest, xmlResponse, intObject); 
            }
        }
    }
    
    global void finish(Database.BatchableContext BC){
        System.Debug('***************************************');
        System.Debug('Goodbye from Batch');
        System.Debug('***************************************');
    }
}