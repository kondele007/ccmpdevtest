/******************************************************************************
** Module Name   : KapEngineWS
** Description   : This is the interface class to the KapEngine Web Service
** 
** Technial Info : <Classes, Methods, etc>
** 
** Author(s)     : Serge Kandukuri (SK) - Kaplan Test Prep
**                 
** Revision History:-
** Version  Date        Author  Description of Action
** 1.0      03/01/2011  SK      Initiated Script
**          05/25/2011  GK      Bug Fix
******************************************************************************/
public with sharing class KapEngineWS {

    Kaplan_Custom_Config__c kap_config = Kaplan_Custom_Config__c.getValues('Kaplan Custom Config');
    String username = kap_config.KapEngineUsername__c; 
    String password = kap_config.kapEnginePassword__c;
    String Endpoint = kap_config.KapEngineEndpoint__c;
   
    public   KapXmlResponseWS  InvokeKapengine(String EndPoint,String Username,String Password ,String requestMethod)
    {
        KapXmlResponseWS response = new KapXmlResponseWS();
        try { 
            KapConnectionWS kapconnection = new KapConnectionWS();
            response=kapconnection.connection(Endpoint, Username, Password, requestMethod);
            return response;
        } catch(Exception e)
        {
            System.debug(e);
            throw new KapException('Webservice has failed to execute.',e);
        }
        return response;
    }


    // Enrollment information for salesforce from kapengine
    public KapXmlResponseWS getEnrollment(String EnrollmentId, String EnrollmentType)
    {  
        EnrollmentType = EnrollmentType.toLowerCase();
        
        String requestMethod='GET';
        KapXmlResponseWS KapXmlResponseWS = new KapXmlResponseWS();
        
        if ((EnrollmentType == 'product') || (EnrollmentType == 'free')) {
            EndPoint = EndPoint+'/productenrollment/'+EnrollmentId;    
        } else if (EnrollmentType == 'class') {
            EndPoint = EndPoint+'/classenrollment/'+EnrollmentId;    
        } else if ((EnrollmentType == 'event')  ) {
            EndPoint = EndPoint+'/eventenrollment/'+EnrollmentId;    
        } else {
            EndPoint = EndPoint+'/enrollment/'+EnrollmentId;    
        }
     
        KapXmlResponseWS=InvokeKapengine(EndPoint,username,password,requestMethod);
       
        return KapXmlResponseWS;
    }
    
    
    // shipment information for salesforce from kapengine
    public KapXmlResponseWS getShipment(String EnrollmentId)
    {
        String requestMethod='GET';  
        KapXmlResponseWS KapXmlResponseWS = new KapXmlResponseWS();
        EndPoint = EndPoint+'/shipment?kbsenrollmentid='+EnrollmentId; 
        KapXmlResponseWS=InvokeKapengine(EndPoint,username,password,requestMethod);
        
        return KapXmlResponseWS;
    }
    
    
    // transaction information for salesforce from kapengine
    public KapXmlResponseWS getTransaction(String EnrollmentId)
    {
        String requestMethod='GET';     
        KapXmlResponseWS KapXmlResponseWS = new KapXmlResponseWS();
        EndPoint = EndPoint+'/dktransaction?kbsenrollmentid='+EnrollmentId;
        KapXmlResponseWS=InvokeKapengine(EndPoint,username,password,requestMethod);
        
        return KapXmlResponseWS;
    }
    public KapXmlResponseWS getInteractions(String KbsStudentId)
    {
        String requestMethod='GET';     
        KapXmlResponseWS KapXmlResponseWS = new KapXmlResponseWS();
       // EndPoint = 'https://qa02api.kaplan.com/ke/3.0/student?kbsStudentId='+KbsStudentId;
       //  EndPoint = EndPoint+'/student?kbsStudentId='+KbsStudentId+'&infield=interactionType&invalues=Case%20Closed,Case%20Opened&inNot=true';
        
          EndPoint = Endpoint+'/interaction?kbsStudentId='+KbsStudentId+'&infield=interactionType&invalues=Case%20Closed,Case%20Opened&inNot=true'; 
        KapXmlResponseWS=InvokeKapengine(EndPoint,username,password,requestMethod);
        
        return KapXmlResponseWS;
    }
}