public with sharing class KapGetRealWS {

   
    Kaplan_Custom_Config__c kap_config = Kaplan_Custom_Config__c.getValues('Kaplan Custom Config');
    String username = kap_config.GetrealUsername__c; 
    String password = kap_config.GetrealPassword__c;
    String Endpoint = kap_config.GetrealEndpoint__c;
     
    
  
      public   KapXmlResponseWS  InvokeGetReal(String EndPoint,String Username,String Password ,String requestMethod,String requestBody)
        {
            
          KapXmlResponseWS response = new KapXmlResponseWS();
          
             try { 
                KapConnectionWS kapconnection = new KapConnectionWS();
                response=kapconnection.connectionGetReal(Endpoint, Username, Password, requestMethod,requestBody);
                return response;
                  }
             catch(Exception e)
                {
                    System.debug(e);
                    throw new KapException('Webservice has failed to execute.',e);
                }
             return response;
        }
  
  
    // Student Profile update to get real
    public KapXmlResponseWS StudentProfileUpdate(String requestBody)
    {
       
       String requestMethod='POST'; 	
       KapXmlResponseWS KapXmlResponse = new KapXmlResponseWS();
       KapXmlResponse = InvokeGetReal(Endpoint, Username, Password, requestMethod,requestBody);
       return KapXmlResponse;
    }
    // student relationship update to get real
    public KapXmlResponseWS StudentRelationshipUpdate(String requestBody)
    {
       
       String requestMethod='POST'; 	
       KapXmlResponseWS KapXmlResponse = new KapXmlResponseWS();
       KapXmlResponse = InvokeGetReal(Endpoint, Username, Password, requestMethod,requestBody);
       return KapXmlResponse;
    }
    // student activity update to get real
    public KapXmlResponseWS StudentActivityUpdate(String requestBody)
    {
       
       String requestMethod='POST'; 	
       KapXmlResponseWS KapXmlResponse = new KapXmlResponseWS();
       KapXmlResponse = InvokeGetReal(Endpoint, Username, Password, requestMethod,requestBody);
       return KapXmlResponse;
    }
    // case creation/close update to get real
    public KapXmlResponseWS CaseCreationCloseUpdate(String requestBody)
    {
       
       String requestMethod='POST'; 	
       KapXmlResponseWS KapXmlResponse = new KapXmlResponseWS();
       KapXmlResponse = InvokeGetReal(Endpoint, Username, Password, requestMethod,requestBody);
       return KapXmlResponse;
    }
    // case activity update to get real
    public KapXmlResponseWS CaseActivityUpdate(String requestBody)
    {
       
       String requestMethod='POST'; 	
       KapXmlResponseWS KapXmlResponse = new KapXmlResponseWS();
       KapXmlResponse = InvokeGetReal(Endpoint, Username, Password, requestMethod,requestBody);
       return KapXmlResponse;
    }
    
    

}