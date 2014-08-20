/**
 * @author serge kandukuri
 */
@isTest
private class KapGetRealWSTest {

    		static testMethod void getrealwsTest() {
    			 
    			 Test.startTest();
    			 
    			 KapGetRealWS kapgetrealws = new KapGetRealWS();
    			 KapXmlResponseWS kapxmlresponse1 = new KapXmlResponseWS();
    			 KapXmlResponseWS kapxmlresponse2 = new KapXmlResponseWS();
    			 KapXmlResponseWS kapxmlresponse3 = new KapXmlResponseWS();
    			 KapXmlResponseWS kapxmlresponse4 = new KapXmlResponseWS();
    			 KapXmlResponseWS kapxmlresponse5 = new KapXmlResponseWS();
    			 
    			 String requestBody='<?xml version="1.0" encoding="UTF-8" standalone="yes"?><message_batch client_name="iap-dev" message_group_id="1290402"><message message_id="11200045422"><person client_sys_id="IAP1297292289378" uid="1501200166"><f_name>Restinger</f_name><l_name>Security</l_name></person></message></message_batch>';
    	
                 kapxmlresponse1 = kapgetrealws.StudentProfileUpdate(requestBody);
   
   				 kapxmlresponse2 = kapgetrealws.StudentRelationshipUpdate(requestBody);
   
   				 kapxmlresponse3 = kapgetrealws.StudentActivityUpdate(requestBody);
    
   				 kapxmlresponse4 = kapgetrealws.CaseCreationCloseUpdate(requestBody);
    
  			     kapxmlresponse5 = kapgetrealws.CaseActivityUpdate(requestBody);
                 
                 Test.StopTest();
          
           
       						     }
}