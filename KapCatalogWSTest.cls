/**
 *
 * @author serge kandukuri
 **/

@isTest
private class KapCatalogWSTest {

   		         static testMethod void catalogTest() {
    
      				Test.startTest();
      				
      				KapCatalogWS kapcatalogws = new KapCatalogWS();
    				KapXmlResponseWS kapxml1 = new KapXmlResponseWS();			
      				kapxml1 = kapcatalogws.setOnlineExtensions('1001780230','05/14/2011'); 
      				
      				
      				Test.stopTest();
           
    											}
    											
    				
    							
    											
    											
}