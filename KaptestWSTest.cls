/**
 * @author serge kandukuri
 */

@isTest
private class KaptestWSTest {

    static testMethod void kaptestest() {
      
      Test.startTest();
      KaptestWS kaptestws = new KaptestWS();
      KapXmlResponseWS kapxml1 = new KapXmlResponseWS();
      KapXmlResponseWS kapxml2 = new KapXmlResponseWS();  
      kapxml1 = kaptestws.setHardPasswordReset('test','test123'); 
      //kapxml2 = kaptestws.sendPasswordEmail('41258537'); 
      Test.stopTest();
    
           } 
       
        static testMethod void kapXmlresTest() {
        Test.startTest();
        KapXmlResponseWS kxrw = new KapXmlResponseWS();
        kxrw.toDisplayString();
        Test.stopTest();
    }    
    
}