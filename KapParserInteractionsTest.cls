/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class KapParserInteractionsTest {

     static testMethod void ParserInterTest() {
     Account acc = new Account(firstName='George-016', lastName='Smith-013', Student_ID_Display__c='1518163236');
     Test.startTest();
     insert acc;
     System.debug('----------------29----acc:'+acc);
     
     User u = [Select Id, Name from User where Id =:UserInfo.getUserId()];
     System.runAs(u) {
     KapParserInteractions parseinte = new KapParserInteractions(new ApexPages.Standardcontroller(acc));
         
     Interaction__c InteList = new Interaction__c();  
     
     //String str = '<Enrollment__cs><Enrollment__c><name>Test1</name><age>25</age></Enrollment__c><Enrollment__c><name>Test2</name><age>25</age></Enrollment__c></Enrollment__cs>';
     String str = '<interactionsroot><interactions><interactions><interaction><name>Test1</name><age>25</age></interaction><interaction><name>Test2</name><age>25</age></interaction></interactions></interactions></interactionsroot>';
         
     Dom.Document doc = new Dom.Document(); 
     doc.load(str); 
     
     /*List<Map<String, String>> sObjList = obj.parseXMLDoc(Dom.Document doc);


     System.debug('---------------------------sObj.size():'+sObjList.size());


     for (Map<String, String> sObj : sObjList) {
     System.debug('------------------------final sobj::'+sObj);
     }*/
     parseinte.init();
   /*
     parseinte.isValidmodifiedOn(null);
     parseinte.isValidmodifiedOn(System.today());
     
    parseinte.isValidInteractionType(null);
    parseinte.isValidInteractionType('Case ReOpened');
    parseinte.isValidInteractionDate(null);
    parseinte.isValidInteractionDate(system.today());
    parseinte.nullSafeDate(null);
    parseinte.nullSafeDate(String.valueOf(System.today()));
    parseinte.nullSafeInteger(null);
    parseinte.nullSafeInteger('10');
    
    parseinte.parseXMLDoc(doc);
    */
     }
         
         
    
   } 
    
    
     
       
}