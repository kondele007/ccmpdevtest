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
 * The @isTest class annotation indicates this class only contains test;
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage. 
 */
@isTest
private class KapEnrollmentDetailsControllerTest {

     
     
    public static KapEnrollmentDetailsController kapEnrollmentDetails;
    
    private static void setup() {
    	Id RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Person Account' LIMIT 1].Id;
        
        Account acc = new Account(LastName='Smith-008', FirstName='George-003', Student_Id_Display__c='123', Kaptest_Username__c='chaitu.katragadda@kaplan.com', RecordTypeId = RecordTypeId);
        insert acc;
        
        Enrollment__c enrObj = new Enrollment__c(Enrollment_Type__c='Product', Enrollment_Id__c='41258537',
                                Account__c = acc.Id, Student_Id__c=41269861);
        insert enrObj;
        
        ApexPages.currentPage().getParameters().put('enrollmentId',enrObj.Id);
        kapEnrollmentDetails  = new KapEnrollmentDetailsController();
        
        KapXmlresponseWS xmlres = new KapXmlresponseWS();
        
    }
    
    public static testMethod void testisProductEnrollment() {
        setup();        
        boolean isProduct = kapEnrollmentDetails.isProductEnrollment();
        System.assertEquals(isProduct, true);
    }
    
    public static testMethod void testisClassEnrollment() {
        setup();        
        boolean isClassEnrollment = kapEnrollmentDetails.isClassEnrollment();
        System.assertEquals(isClassEnrollment, false);
    }   
    
    public static testMethod void testisEventEnrollment() {
        setup();        
        boolean isEventEnrollment = kapEnrollmentDetails.isEventEnrollment();
        System.assertEquals(isEventEnrollment, false);
    }
    
     public static testMethod void testgetShowEnrollment() {
        setup();        
        boolean getShowEnrollment = kapEnrollmentDetails.getShowEnrollment();
        System.assertEquals(getShowEnrollment, false);
    }
    
    public static testMethod void testgetShowTransactions() {
        setup();        
        boolean getShowTransactions = kapEnrollmentDetails.getShowTransactions();
        System.assertEquals(getShowTransactions, false);
    }
    
    public static testMethod void testgetShowShipOrders() {
        setup();        
        boolean getShowShipOrders = kapEnrollmentDetails.getShowShipOrders();
        System.assertEquals(getShowShipOrders, false);
    }
    
    public static testMethod void testgetAccount() {
        setup();        
        kapEnrollmentDetails.getAccount();
    }
    
    public static testMethod void testgetEnrollment() {
        setup();        
        kapEnrollmentDetails.getEnrollment();
    }
    /*
    public static testMethod void testgetEnrollmentList() {
        setup();        
        kapEnrollmentDetails.getEnrollmentList();
    }
    */
     public static testMethod void testgetTempEnrollment() {
        setup();        
        kapEnrollmentDetails.getTempEnrollment();
    }
    
     public static testMethod void testgetTempTransaction() {
        setup(); 
        
      
        kapEnrollmentDetails.getTempTransaction();
     
       
        
    }
    
    public static testMethod void testgetTransactionList() {
        setup();        
        kapEnrollmentDetails.getTransactionList();
    }
    
    public static testMethod void testgetTempShipOrder() {
        setup();        
        kapEnrollmentDetails.getTempShipOrder();
    }
    
     public static testMethod void testgetShipOrderList() {
        setup();        
        kapEnrollmentDetails.getShipOrderList();
    }
    
    
}