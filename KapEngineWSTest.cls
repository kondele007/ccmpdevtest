/**
 * @author serge kandukuri
 */
@isTest
private class KapEngineWSTest {

    static testMethod void kapenginetest() {

      Test.startTest();
      KapEngineWS kapenginews = new KapEngineWS();
      KapXmlResponseWS kapxml1 = new KapXmlResponseWS();
      KapXmlResponseWS kapxml2 = new KapXmlResponseWS();
      KapXmlResponseWS kapxml3 = new KapXmlResponseWS();
      kapxml1 = kapenginews.getEnrollment('41258537',''); 
      kapxml2 = kapenginews.getShipment('41258537'); 
      kapxml3 = kapenginews.getTransaction('41258537');  
      Test.stopTest();
           } 
       
        static testMethod void kapXmlresTest() {
        Test.startTest();
        KapXmlResponseWS kxrw = new KapXmlResponseWS();
        kxrw.toDisplayString();
        Test.stopTest();
    }    
    
               }