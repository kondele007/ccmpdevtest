/**
 *  @author Serge Kandukuri
 */
@isTest
private class KapConnectionWSTest {

      static testMethod void testConnection(){  
      
      Test.startTest();
      KapConnectionWS kapconnectionws = new KapConnectionWS();
      KapXmlResponseWS kapxml1 = new KapXmlResponseWS();
      KapXmlResponseWS kapxml2 = new KapXmlResponseWS();
      KapXmlResponseWS kapxml3 = new KapXmlResponseWS();
      KapXmlResponseWS kapxml4 = new KapXmlResponseWS();
      KapXmlResponseWS kapxml5 = new KapXmlResponseWS();
      
      
      kapxml1 = kapconnectionws.connection('Endpoint','username', 'password', 'GET');  
      kapxml2 = kapconnectionws.connectionGetReal('endpoint','username','password','POST','requestBody');  
      kapxml3 = kapconnectionws.connectionOnlineExtension('endpoint','username','password','PUT','requestBody');  
      kapxml4 = kapconnectionws.connectionPasswordReset('endpoint','username','password','POST','requestBody');
      kapxml5 = kapconnectionws.connectionRTCAP('123456');
      
      Test.stopTest();  
      
     
           }    
}