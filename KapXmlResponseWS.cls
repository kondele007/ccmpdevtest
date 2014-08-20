/**
 * @author serge kandukuri
 */
public with sharing class KapXmlResponseWS {

        public String xmlBody {get; set;}
        public Integer statusCode {get; set;}
        
        public String toDisplayString() {
            return xmlBody + ', '
            + statusCode;
        } 
        
        static testMethod void testXmlResponse(){  

      KapXmlResponseWS kapresponsews = new KapXmlResponseWS();
      
      String kapxml1 = kapresponsews.toDisplayString(); 
    
           } 
    
        

}