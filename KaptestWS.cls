/**
 * @author serge kandukuri
 */
public with sharing class KaptestWS {
    
   
     
    Kaplan_Custom_Config__c kap_config = Kaplan_Custom_Config__c.getValues('Kaplan Custom Config');
    String username = kap_config.KaptestUsername__c; 
    String password = kap_config.kaptestPassword__c;
    String Endpoint = kap_config.KaptestEndpoint__c;
     
    // KapEngineUsername username1;
    
      public   KapXmlResponseWS  InvokeKaptest(String EndPoint,String Username,String Password ,String requestMethod,String requestBody)
        {
            
          KapXmlResponseWS response = new KapXmlResponseWS();
          
             try { 
                KapConnectionWS kapconnection = new KapConnectionWS();
                response=kapconnection.connectionPasswordReset(Endpoint, Username, Password, requestMethod,requestBody);
                return response;
                  }
            catch(Exception e)
                {
                    System.debug(e);
                    throw new KapException('Webservice has failed to execute.',e);
                }
             return response;
        }
    
    
     
    
    // Hard password reset  information for salesforce to  kaptest
    public KapXmlResponseWS setHardPasswordReset(String username,String password)
    {  
       String requestMethod='POST'; 	
       
       String requestBody='username='+username+'&newPassword='+password;
       KapXmlResponseWS KapXmlResponse = new KapXmlResponseWS();
       
       KapXmlResponse = InvokeKaptest(Endpoint, Username, Password, requestMethod,requestBody);
       return KapXmlResponse;
    }
 
     // password emailed to the user
     /*
     public KapXmlResponseWS sendPasswordEmail(String username)
    {
       String requestMethod='POST'; 	
       KapXmlResponseWS KapXmlResponse = new KapXmlResponseWS();
       EndPoint = EndPoint+'/dktransaction?kbsenrollmentid=';
       KapXmlResponse=InvokeKaptest(Endpoint, Username, Password, requestMethod);
       return KapXmlResponse;
    }
    */
    




}