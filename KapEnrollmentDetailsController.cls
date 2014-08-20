/******************************************************************************
** Module Name   : KapEnrollmentDetailsController
** Description   : Controller for the KapEnrollmentDetails VF Page
**                 The constructor calls the KapEngine Web Service
**                 to retrieve Enrollment, Transaction and Ship Order
**                 Details. 
** 
** Technial Info : <Classes, Methods, etc>
** 
** Author(s)     : George Koodarappally (GK) - Acumen Solutions
** Revision History:-
** Version      Date            Author  Description of Action
** 1.0          03/01/2011      GK              Initiated Script
******************************************************************************/

public with sharing class KapEnrollmentDetailsController {
    private final Account account;
    private final Enrollment__c enrollment;
    private final Temp_Enrollment__c tempEnrollment;
    private final Temp_Transaction__c tempTransaction;
    private final Temp_Ship_Order__c tempShipOrder;
    
    private List<Enrollment__c> enrollmentList;
    private List<Temp_Transaction__c> transactionList;
    private List<Temp_Ship_Order__c> shipOrderList;
    
    private final Id accountId, enrollmentId;
    
    private String errorString;
    private Decimal totalShipmentCost=0.0;
    private Decimal totalEnrollmentCost;
    private Decimal ShipmentCost;

    public kapEnrollmentDetailsController() {

        enrollmentId = ApexPages.currentPage().getParameters().get('enrollmentId');
        system.debug('*************************enrollmentId:'+enrollmentId);
        accountId = [SELECT Account__c FROM Enrollment__c WHERE Id = :enrollmentId].Account__c;
        
        account = [SELECT Id, FirstName, LastName, Phone, PersonEmail, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry FROM Account WHERE Id = :accountId];
        enrollment = [SELECT Id, Enrollment_Type__c, Enrollment_Id__c,Total_Shipment__c,Total_Enrollment_fee__c FROM Enrollment__c WHERE Id = :enrollmentId];
        //enrollmentList = [SELECT Id, Enrollment_Type__c, Enrollment_Id__c FROM Enrollment__c];
        
        tempEnrollment          = getTempEnrollmentFromKapEngine();
        if (tempEnrollment == null) {
                errorString = 'Unable to retrieve Enrollment Details from KapEngine';
                ApexPages.Message errMesg = new ApexPages.Message(ApexPages.Severity.ERROR, errorString);
                ApexPages.addMessage(errMesg);
        }
        
        transactionList         = getTransactionsFromKapEngine();
        shipOrderList           = getShipOrdersFromKapEngine();
        
    }
    

private  Temp_Enrollment__c getTempEnrollmentFromKapEngine(){
        List<Temp_Enrollment__c> tempEnrollments;
        Temp_Enrollment__c enrollmentDetail;
        String urlType, enrollmentId, enrollmentURL, xmlResponseString;
        KapXmlResponseWS kapXmlResponseWS;
        KapEngineWS kapEngine = new KapEngineWS();
        
        urlType = enrollment.Enrollment_Type__c;
        enrollmentId = enrollment.Enrollment_Id__c;
        
        //enrollmentURL = KapKapEngineUtil.getKapEngineURL(urlType, enrollmentId);
        kapXmlResponseWS = kapEngine.getEnrollment(enrollmentId, urlType);
        if(kapXmlResponseWS != null) {
                xmlResponseString = kapXmlResponseWS.xmlBody;
                //xmlResponseString = KapKapEngineUtil.getTestEnrollmentDetails(urlType);
                System.debug('==============================================');
                System.debug(xmlResponseString);
                System.debug('==============================================');
                tempEnrollments = ((List<Temp_Enrollment__c>)KapKapEngineUtil.processKapEngineResponse(xmlResponseString));
                if (tempEnrollments.Size() > 0) {
                        enrollmentDetail = tempEnrollments[0];
                }
        }
        return enrollmentDetail;
    }
    
    
private  List<Temp_Transaction__c> getTransactionsFromKapEngine(){
        List<Temp_Transaction__c> tempTransactions;
        String urlType, enrollmentId, transactionURL, xmlResponseString;
        KapXmlResponseWS kapXmlResponseWS;
        KapEngineWS kapEngine = new KapEngineWS();
        
        enrollmentId = enrollment.Enrollment_Id__c;
    
        //transactionURL = KapKapEngineUtil.getKapEngineURL(urlType, enrollmentId);
        kapXmlResponseWS = kapEngine.getTransaction(enrollmentId);
        if(kapXmlResponseWS != null) {
                xmlResponseString = kapXmlResponseWS.xmlBody;
                //xmlResponseString = KapWebServices.getEnrollmentDetails(transactionURL);
                //xmlResponseString = KapKapEngineUtil.getTestTransactions();
                tempTransactions = (List<Temp_Transaction__c>)KapKapEngineUtil.processKapEngineResponse(xmlResponseString);
        }
         //Decimal enrollmentTotal1=0.00;
        //enrollment.Total_Shipment__c=tempTransactions.
        //enrollmentTotal1=getTempEnrollmentFromKapEngine().Total_Payment_Made__c;
       
        //enrollment.Total_Enrollment_fee__c=0.00;
       // enrollment.Total_Shipment__c=0.00;
        
        return tempTransactions;
    }
    
 
    private  List<Temp_Ship_Order__c> getShipOrdersFromKapEngine(){
        List<Temp_Ship_Order__c> tempShipOrders;
        String urlType, enrollmentId, shipOrderURL, xmlResponseString;
        KapXmlResponseWS kapXmlResponseWS;
        KapEngineWS kapEngine = new KapEngineWS();
        
        enrollmentId = enrollment.Enrollment_Id__c;
        
        
        kapXmlResponseWS = kapEngine.getShipment(enrollmentId);
        if(kapXmlResponseWS != null) {
                xmlResponseString = kapXmlResponseWS.xmlBody;
               
                tempShipOrders = (List<Temp_Ship_Order__c>)KapKapEngineUtil.processKapEngineResponse(xmlResponseString);
              
               Decimal enrollmentTotal=0.00;
               
                if(tempShipOrders.size()>0){
                        Decimal totalShipmentCost1=0.0;
                        for(integer i=0;i<tempShipOrders.size();i++) {
                Decimal ShipmentCost1=(Decimal)tempShipOrders[i].Shipping_Charge__c;
                
           
                
                System.debug(' shipping charge'+ShipmentCost1);
               enrollmentTotal=getTempEnrollmentFromKapEngine().Total_Payment_Made__c;
                                        
            totalShipmentCost1=ShipmentCost1+totalShipmentCost;
           
                        }
          
    //        enrollment.Total_Shipment__c=totalShipmentCost1;
            enrollment.Total_Enrollment_fee__c=0.00;
         //   enrollment.Total_Enrollment_fee__c= enrollmentTotal-totalShipmentCost1;
            System.debug(' total enrollment charge'+enrollment.Total_Enrollment_fee__c);
            System.debug(' total shipping charge'+enrollment.Total_Shipment__c);
           
                }
                
        }
        
        
        
        
        return tempShipOrders;
    }
    /*
    
     private  List<Temp_Ship_Order__c> getShipOrdersFromKapEngine(){
      List<Temp_Ship_Order__c> tempShipOrders;
      String urlType, enrollmentId, shipOrderURL, xmlResponseString;
      KapXmlResponseWS kapXmlResponseWS;
      KapEngineWS kapEngine = new KapEngineWS();
      
      enrollmentId = enrollment.Enrollment_Id__c;
      
      //shipOrderURL = KapKapEngineUtil.getKapEngineURL(urlType, enrollmentId);
      kapXmlResponseWS = kapEngine.getShipment(enrollmentId);
      if(kapXmlResponseWS != null) {
        xmlResponseString = kapXmlResponseWS.xmlBody;
        //xmlResponseString = KapWebServices.getEnrollmentDetails(shipOrderURL);
        //xmlResponseString = KapKapEngineUtil.getTestShipOrders();
        tempShipOrders = (List<Temp_Ship_Order__c>)KapKapEngineUtil.processKapEngineResponse(xmlResponseString);
      }
      return tempShipOrders;
    }
    */
    
    
    public boolean isProductEnrollment() {
        return (enrollment.Enrollment_Type__c == 'Product'?true:false);
    }
    
    
    public boolean isClassEnrollment() {
        return (enrollment.Enrollment_Type__c == 'Class'?true:false);
    }
    
    
    public boolean isEventEnrollment() {
        return (enrollment.Enrollment_Type__c == 'Event'?true:false);
    }
    
    
    public boolean getShowEnrollment() {
        return (tempEnrollment != null?true:false);
    }
    
    
    public boolean getShowTransactions() {
        return ((transactionList != null && transactionList.size() > 0)?true:false);
    }
    
    
    public boolean getShowShipOrders() {
        return ((shipOrderList != null && shipOrderList.size() > 0)?true:false);
    }
    
    
    public Account getAccount() {
        return account;
    }
    
    
    public Enrollment__c getEnrollment() {
        return enrollment;
    }
    
    /*
    public List<Enrollment__c> getEnrollmentList() {
        return enrollmentList;
    }
    */
    
    public Temp_Enrollment__c getTempEnrollment() {
        return tempEnrollment;
    }
    
    
    public Temp_Transaction__c getTempTransaction() {
        return tempTransaction;
    }
    
    
    public List<Temp_Transaction__c> getTransactionList() {
        return transactionList;
    }
    
    
    public Temp_Ship_Order__c getTempShipOrder() {
        return tempShipOrder;
    }
    
    
    public List<Temp_Ship_Order__c> getShipOrderList() {
        return shipOrderList;
    }
}