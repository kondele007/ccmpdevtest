/**
 * @author serge kandukuri
 */
public with sharing class KapCatalogWS {
    
  
      Kaplan_Custom_Config__c kap_config = Kaplan_Custom_Config__c.getValues('Kaplan Custom Config');
      String username = kap_config.catalogUsername__c; 
      String password = kap_config.catalogPassword__c;
      String Endpoint = kap_config.catalogEndpoint__c;
      List<Id> userIdList = new List<Id>();
      Map<Id, String> mapIdToUserName = new Map<Id, String>();
       List<User> userList;
        String usrId = UserInfo.getUserId(); 
         
         user currentUser = [SELECT username FROM User WHERE Id = :usrId limit 1]; 
         
         String userNow=String.valueOf(currentUser.username);
         
         String currentKbsuser= kaputil.truncateSFDCUserNameSuffix(userNow);
         
        // String currentKbsuser='rlockhart2';
        
         
      
   public   KapXmlResponseWS  InvokeCatalog(String EndPoint,String Username,String Password ,String requestMethod,String requestBody)
        {
            System.debug('parsed username is '+currentKbsuser);
          KapXmlResponseWS response = new KapXmlResponseWS();
          
             try { 
                KapConnectionWS kapconnection = new KapConnectionWS();
                response=kapconnection.connectionOnlineExtension(Endpoint, Username, Password, requestMethod,requestBody);
                return response;
                  }
            catch(Exception e)
                {
                    System.debug(e);
                    throw new KapException('Webservice has failed to execute.',e);
                }
             return response;
        }
    
    // Online extensions from catalog
    public KapXmlResponseWS setOnlineExtensions(String enrollmentid,String enddate)
    {   
         String requestMethod='PUT';    
         String requestBody='<?xml version="1.0" encoding="UTF-8" standalone="yes"?> <update><purchaseId>'+enrollmentid
                              +'</purchaseId><expirationDate>'+enddate+'</expirationDate><clientName>'+currentKbsuser+'</clientName></update>';
         KapXmlResponseWS KapXmlResponseWS = new KapXmlResponseWS();
         KapXmlResponseWS = InvokeCatalog(EndPoint,Username,Password,requestMethod,requestBody);
         return KapXmlResponseWS;
    }
   

}