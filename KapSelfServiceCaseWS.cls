/******************************************************************************
** Module Name   : KapSelfServiceCaseWS
** Description   : Class used to allow creation of Self Service Cases in Salesforce.com
**                 for use in Self Service Portal.
** 
** Technial Info : <Classes, Methods, etc>
** 
** Author(s)     : George Koodarappally (GK) - Acumen Solutions
** Revision History:-
** Version  Date        Author  Description of Action
** 1.0      09/15/2011  GK  Initiated Script
** 2.0      01/15/2012  Vineel Katipally - Rewrote the logic to route all cases to same queue irrespective of product line. Refactored to be more modular
******************************************************************************/

@RestResource(urlMapping='/SelfServiceCase/*') 
global class KapSelfServiceCaseWS {

/*
** DATA_VALIDATION
** IS EnrollmentId provided?
** IS AccountId provided?
** IS Type provided?
** IS Type_Detail provided?
** IS Status provided?
** IS Online Extension Date provided? (Only for Online Extension Cases)
** 
** IF EnrollmentIdProvided THEN
**   QUERY_FOR accountId FROM Enrollment__c
**   INITIATE Case FOR AccountId & EnrollmentId
** ELSE
**   IF NOT AccountIdProvided THEN
**     RAISE_ERROR NO_ENROLLMENT_ID_OR_ACCOUNT_ID
**   ELSE
**     
**
*/


@HttpGet   
    global static Case doGet(RestRequest req, RestResponse res) {
    
        String caseId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Case result = [SELECT Id, AccountId, Type, Origin, Type_Detail__c, Status, Subject FROM Case WHERE Id = :caseId];
        return result;    
    }
    
@HttpPost   
    global static String doPost(RestRequest req, RestResponse res) {
        String retStatus;
        String KBSEnrollmentId, KBSStudentId, caseType, caseSubject, status, strOnlineExtensionDate;
       
        // Read all the possible input parameters
        String JSONRequestBody = req.requestBody.toString();
        Map<String,String> JSONRequestParameters = (Map<String,String> )JSON.deserialize(JSONRequestBody, Map<String,String>.class);

        KBSEnrollmentId = JSONRequestParameters.get('KBSEnrollmentId');
        KBSStudentId = JSONRequestParameters.get('KBSStudentId');
        caseType = JSONRequestParameters.get('caseType');
        caseSubject = JSONRequestParameters.get('caseSubject');
        status = JSONRequestParameters.get('status');
        strOnlineExtensionDate = JSONRequestParameters.get('onlineExtensionDate');
        
        System.debug('********************* CreateSSCase Parameters (Begin) ********************');
        System.debug('Enrollment Id: '+KBSEnrollmentId);
        System.debug('Student Id: '+KBSStudentId);
        System.debug('Case Type: '+caseType);
        System.debug('Case Subject: '+caseSubject);
        System.debug('Status: '+status);
        System.debug('Online Extension Date: '+strOnlineExtensionDate);
        System.debug('********************* CreateSSCase Parameters (End) ********************');                                    
        
        if (isEmpty(KBSStudentId)) {
            retStatus = KapConstants.KAP_SSCASEWS_ERR_MISSING_STUDENT_ID;
            return retStatus;
        }
        
        if (isEmpty(status)) {
            retStatus = KapConstants.KAP_SSCASEWS_ERR_MISSING_STATUS;
            return retStatus;
        }
        
        if (isEmpty(caseType)) {
            retStatus = KapConstants.KAP_SSCASEWS_ERR_MISSING_CASE_TYPE;
            return retStatus;
        }                        
        
        // Only supported case types are online extension and password reset
        if (KapConstants.KAP_SSCASEWS_CLASS_EXTENSION.equals(caseType)) {
            return createExtensionCase(KBSEnrollmentId, KBSStudentId, caseSubject, status, strOnlineExtensionDate);
        } else if (KapConstants.KAP_SSCASEWS_RESET_PASSWORD.equals(caseType)) {        
            return createResetPasswordCase(KBSEnrollmentId, KBSStudentId, caseSubject, status, strOnlineExtensionDate);
        } 
        
        // Unsupported case type
        retStatus = KapConstants.KAP_SSCASEWS_ERR_UNSUPPORTED_TRANSACTION; 
        return retStatus;
    }    
    
    public static String createExtensionCase(String KBSEnrollmentId, String KBSStudentId, String caseSubject, String status, String strOnlineExtensionDate) {
        String retStatus;
        Date onlineExtensionDate;       
        
        if (isEmpty(KBSEnrollmentId)) {
            retStatus = KapConstants.KAP_SSCASEWS_ERR_MISSING_ENROLLMENT_ID;
            return retStatus;
        }
        
        if (isEmpty(strOnlineExtensionDate)) {
            retStatus = KapConstants.KAP_SSCASEWS_ERR_MISSING_ONLINE_EXTENSION_DATE;
            return retStatus;
        } else {
            try {               
                onlineExtensionDate = Date.valueOf(strOnlineExtensionDate);          
            } catch (Exception e) {
                System.debug(e);
                retStatus = KapConstants.KAP_SSCASEWS_ERR_MISSING_ONLINE_EXTENSION_DATE + ' - ' + strOnlineExtensionDate;
                return retStatus;
            } 
        }
        
        Account caseAccount;
        Enrollment__c caseEnrollment = loadEnrollmentFromKBSEnrollmentId(KBSEnrollmentId);
         if (caseEnrollment == null) {
            retStatus = KapConstants.KAP_SSCASEWS_ERR_INVALID_ENROLLMENT_ID + ' - ' + KBSEnrollmentId;
            return retStatus;
        } else {
            Account[] accounts = [SELECT Id, PersonContactId FROM Account WHERE Id = :caseEnrollment.Account__c];
            if (accounts.size() > 0)
                caseAccount = accounts[0];
        }        
            
        return createCase(caseEnrollment, caseAccount, KapConstants.KAP_SSCASEWS_CASE_TYPE_CLASS_EXTENSION, KapConstants.KAP_SSCASEWS_CASE_TYPE_DETAIL_CLASS_EXTENSION, caseSubject, status, onlineExtensionDate, KapConstants.KAP_SSCASEWS_RESOLUTION_TYPE_DETAIL_CLASS_EXTENSION);        
    }
    
    private static String createResetPasswordCase(String KBSEnrollmentId, String KBSStudentId, String caseSubject, String status, String strOnlineExtensionDate) {
        String retStatus;   
        Account caseAccount = loadAccountFromKBSStudentId(KBSStudentId);
        if(caseAccount == null) {
            retStatus = KapConstants.KAP_SSCASEWS_ERR_INVALID_STUDENT_ID + ' - ' + KBSStudentId;
            return retStatus;
        }
        return createCase(loadEnrollmentFromKBSEnrollmentId(KBSEnrollmentId), caseAccount, KapConstants.KAP_SSCASEWS_CASE_TYPE_PASSWORD_RESET, KapConstants.KAP_SSCASEWS_CASE_TYPE_DETAIL_PASSWORD_RESET, caseSubject, status, null, KapConstants.KAP_SSCASEWS_RESOLUTION_TYPE_PASSWORD_RESET); 
    }
    
    // Create a generic case object
    private static String createCase(Enrollment__c caseEnrollment, Account caseAccount, String caseType, String caseTypeDetail, String caseSubject, String status, Date onlineExtensionDate, String resolutionType) {
        String retStatus;
        String caseOwnerQueueName = KapConstants.KAP_SSCASEWS_SELF_SERVICE_QUEUE_NAME;
        Case SSCase;               
        BusinessHours caseBusinessHours;
        Group caseOwner;              
        
        BusinessHours[] busHours = [SELECT Id FROM BusinessHours WHERE Name = 'CCC Business Hours'];
        if (busHours.size() > 0) {
            caseBusinessHours = busHours[0];
        }               
        
        Group[] queues = [SELECT Name, Id FROM Group WHERE Type = 'Queue' AND Name = :caseOwnerQueueName];
        if (queues.size() > 0)
            caseOwner = queues[0];
        else {
            retStatus = KapConstants.KAP_SSCASEWS_ERR_NO_SUCH_QUEUE + caseOwnerQueueName;
            return retStatus;
        }
        
        //Generate Case Stub and populate fields
        SSCase = new Case();        
        SSCase.AccountId = caseAccount.Id;
        SSCase.ContactId = caseAccount.PersonContactId;
        if (caseEnrollment != null) {
            SSCase.Enrollment__c = caseEnrollment.Id;
        }
        SSCase.Caller_Type__c = 'Student';
        SSCase.Origin = 'Kaptest';
        //SSCase.Product_Line__c = productLine;
        SSCase.Type = caseType;
        SSCase.Type_Detail__c = caseTypeDetail;
        SSCase.Status = status;
        //SSCase.Subject = caseSubject;
        SSCase.BusinessHoursId = caseBusinessHours.Id;
        SSCase.OwnerId = caseOwner.Id;
        
        if (status == 'Closed') {
            SSCase.Online_Extension_Date__c = onlineExtensionDate;
            SSCase.Resolution_Type__c = resolutionType;
        } else if (status == 'New') {
            SSCase.Subject = isEmpty(caseSubject)?caseTypeDetail:caseSubject;            
        }
        
        System.debug('**********CREATING CASE: ' + SSCase);       
        //Save Case
        //insert SSCase;        
        try {
            insert SSCase;
        } catch (Exception e) {
            System.debug(e);
            retStatus = ''; // Unable to Save Case.
            return retStatus;
        }        
        
        //Return Salesforce Case Id OR Error Code to calling program
        retStatus = SSCase.Id;
        return retStatus;
    }
    
    private static Account loadAccountFromKBSStudentId(String KBSStudentId) {
        Account caseAccount;
        if(!isEmpty(KBSStudentId)) {
            Account[] accounts = [SELECT Id, PersonContactId FROM Account WHERE Student_ID_Display__c = :KBSStudentId];
            if (accounts.size() > 0) {
                caseAccount = accounts[0];
            }
        }
        return caseAccount; 
    }
    
    private static Enrollment__c loadEnrollmentFromKBSEnrollmentId(String KBSEnrollmentId) {
        Enrollment__c caseEnrollment;
        if(!isEmpty(KBSEnrollmentId)) {
            Enrollment__c[] enrollments = [SELECT Id, Account__c FROM Enrollment__c WHERE Enrollment_Id__c = :KBSEnrollmentId];
            if (enrollments.size() > 0) {
                caseEnrollment = enrollments[0];
            }
        }
        return caseEnrollment;  
    }
        
    public static Boolean isEmpty(String str) {
        return (((str != null) && (str.trim() != ''))?false:true);    
    } 
   
   
   public String TestData1(String KBSEnrollmentId,String KBSStudentId,String productLine,String caseType,String caseTypeDetail,String caseSubject,String status){
   
      String requestBody;
     
        requestBody = '{';
        requestBody = requestBody + '"KBSEnrollmentId" : "' + KBSEnrollmentId + '", ';
        requestBody = requestBody + '"KBSStudentId" : "' + KBSStudentId + '", ';
        requestBody = requestBody + '"productLine" : "' + productLine + '", ';
        requestBody = requestBody + '"caseType" : "' + caseType + '", ';
        requestBody = requestBody + '"caseTypeDetail" : "' + caseTypeDetail + '", ';
        //requestBody = requestBody + '"caseSubject" : "' + caseSubject + '", ';
        requestBody = requestBody + '"status" : "' + status + '", ';
       // requestBody = requestBody + '"onlineExtensionDate" : "' + onlineExtensionDate + '" ';
        requestBody = requestBody + '}'; 
        
        
      
     return requestBody;
   }

 
   static testMethod void selfServiceTest() {
        test.startTest();
         String KBSEnrollmentId, KBSStudentId, productLine, caseType, caseTypeDetail, caseSubject, status;
        Date onlineExtensionDate;
        RestRequest req = new RestRequest();
        RestResponse resp;
        String requestBody;

        Account testParentAccount = KapTestUtil.createTestAccount();
        Enrollment__c testEnrollment = KapTestUtil.createTestEnrollment(testParentAccount);
        
        KBSEnrollmentId = testEnrollment.Enrollment_Id__c;
        KBSStudentId = testParentAccount.Student_ID_Display__c;
        productLine = 'Grad';
        caseType = KapConstants.KAP_SSCASEWS_CASE_TYPE_CLASS_EXTENSION;
        caseTypeDetail = KapConstants.KAP_SSCASEWS_CASE_TYPE_DETAIL_CLASS_EXTENSION;
        caseSubject = 'Self Service Case';
        status = 'Closed';
        onlineExtensionDate = Date.today().addDays(10);
        
        requestBody = '{';
        requestBody = requestBody + '"KBSEnrollmentId" : "' + KBSEnrollmentId + '", ';
        requestBody = requestBody + '"KBSStudentId" : "' + KBSStudentId + '", ';
        requestBody = requestBody + '"productLine" : "' + productLine + '", ';
        requestBody = requestBody + '"caseType" : "' + caseType + '", ';
        requestBody = requestBody + '"caseTypeDetail" : "' + caseTypeDetail + '", ';
        //requestBody = requestBody + '"caseSubject" : "' + caseSubject + '", ';
        requestBody = requestBody + '"status" : "' + status + '", ';
        requestBody = requestBody + '"onlineExtensionDate" : "' + onlineExtensionDate + '" ';
        requestBody = requestBody + '}';

        req.requestBody = Blob.valueOf(requestBody);
         
        RestRequest req1 = new RestRequest();
        RestRequest req2 = new RestRequest();
        RestResponse resp1;
        //String requestBody1= KapSelfServiceCaseWS.TestData1('','','','','','','');
        //String requestBody2;
        
       // req1.requestBody = Blob.valueOf(requestBody1);
       // req2.requestBody = Blob.valueOf(requestBody2);
        
       // String post1= doPost(req1, resp);
       // String post2= doPost(req2, resp);  
        
        //KapSelfServiceCaseWS.doGet(req,resp);
        //kscw.doGet(req,resp);
        Case c;
        //Date d;
          String caseId ='';
    //  c.Id='500L0000000Ullz';
       // c = doGet(req,resp);
      String post= doPost(req, resp);
      String createPassC= createResetPasswordCase('','','','','');
      String newEXTcase = KapSelfServiceCaseWS.createExtensionCase('','','','','');
       String createCase=KapSelfServiceCaseWS.createCase(testEnrollment,testParentAccount,'','','','',onlineExtensionDate,'');
      String createResetPass=createResetPasswordCase('','','','','');
      Boolean isEmpty= isEmpty('');
      
      String retStatus;
          String test1= KapConstants.KAP_SSCASEWS_ERR_MISSING_STUDENT_ID;
          String test2= KapConstants.KAP_SSCASEWS_ERR_MISSING_STATUS;
          String test3=  KapConstants.KAP_SSCASEWS_ERR_MISSING_CASE_TYPE;
          String test4=   KapConstants.KAP_SSCASEWS_RESET_PASSWORD ;        
          String test5=  KapConstants.KAP_SSCASEWS_ERR_UNSUPPORTED_TRANSACTION; 
        String strOnlineExtensionDate='';
         Account caseAccount;
        Enrollment__c caseEnrollment = loadEnrollmentFromKBSEnrollmentId(KBSEnrollmentId);
         if (caseEnrollment == null) {
           retStatus = KapConstants.KAP_SSCASEWS_ERR_INVALID_ENROLLMENT_ID + ' - ' + '';
           // return retStatus;
        } else {
            Account[] accounts = [SELECT Id, PersonContactId FROM Account WHERE Id = :caseEnrollment.Account__c];
            if (accounts.size() > 0)
                caseAccount = accounts[0];
        }        
         if (isEmpty(strOnlineExtensionDate)) {
            retStatus = KapConstants.KAP_SSCASEWS_ERR_MISSING_ONLINE_EXTENSION_DATE;
           
        } else {
            try {               
                onlineExtensionDate =onlineExtensionDate;          
            } catch (Exception e) {
                System.debug(e);
                retStatus = KapConstants.KAP_SSCASEWS_ERR_MISSING_ONLINE_EXTENSION_DATE + ' - ' + onlineExtensionDate;
                
            } 
        }
      
        Enrollment__c e =  loadEnrollmentFromKBSEnrollmentId('');
        Account a = loadAccountFromKBSStudentId('');
        
        
        test.stopTest();
       
    
}
   
    
}