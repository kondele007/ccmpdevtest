/******************************************************************************
** Module Name   : KapKapEngineUtil
** Description   : Utility class containg methods to be used in the KapEngine
**                 integration code.
** 
** Technial Info : <Classes, Methods, etc>
** 
** Author(s)     : George Koodarappally (GK) - Acumen Solutions
** Revision History:-
** Version  Date        Author  Description of Action
** 1.0      03/01/2011  GK  Initiated Script
******************************************************************************/

public with sharing class KapKapEngineUtil {
  
    public Decimal shippingtotal144                { get; set; }
    private static String getNodeChildElementText(DOM.XMLNode xmlNode, String childElement) {
        /*
        ** This is a 'safe' version of the XMLNode.getChildElement() method.
        ** The method generates a run-time error if the child element is missing in 
        ** the node.
        ** This was written to handle KapEngine response messages whose child entities
        ** are dynamically generated and may or may not be present depending on
        ** data conditions.
        */
        try {
            return xmlNode.getChildElement(childElement, null).getText();
        } catch (Exception e) {
            System.debug(e);
        }
        
        return '';
    }


    private static String getNodeChildElementNumber(DOM.XMLNode xmlNode, String childElement) {
        /*
        ** This is a 'safe' version of the XMLNode.getChildElement() method.
        */
        try {
            return xmlNode.getChildElement(childElement, null).getText();
        } catch (Exception e) {
            System.debug(e);
        }
        
        return '0';
    }


    private static String getNodeChildElementDate(DOM.XMLNode xmlNode, String childElement) {
        /*
        ** This is a 'safe' version of the XMLNode.getChildElement() method.
        */
        try {
            return xmlNode.getChildElement(childElement, null).getText();
        } catch (Exception e) {
            System.debug(e);
        }
        
        return '1900-01-01';
    }


    public static String getKapEngineURL(String urlType, String queryObjectId) {
        String urlString = '';
        
        if (urlType == 'Enrollments') {
            urlString = KapConstants.KAP_KAPENGINE_ENROLLMENT_URL;
        } else if (urlType == 'Product Enrollments') {
            urlString = KapConstants.KAP_KAPENGINE_PROD_ENROLLMENT_URL;
        } else if (urlType == 'Event Enrollments') {
            urlString = KapConstants.KAP_KAPENGINE_EVENT_ENROLLMENT_URL;
        } else if (urlType == 'Class Enrollments') {
            urlString = KapConstants.KAP_KAPENGINE_CLASS_ENROLLMENT_URL;
        } else if (urlType == 'Transactions') {
            urlString = KapConstants.KAP_KAPENGINE_TRANSACTION_URL;
        } else if (urlType == 'Ship Orders') {
            urlString = KapConstants.KAP_KAPENGINE_SHIP_ORDER_URL;
        }
        
        urlString = urlString + queryObjectId;
        
        return urlString;
    }
    
    
    public static List<SObject> processKapEngineResponse(String xmlResponseMessage) {
        Dom.Document xmlDoc;
        Dom.XMLNode xmlNode;
        String nodeName;
        SObject sfdcObject;
        List<SObject> sfdcObjects;
        
        xmlResponseMessage = xmlResponseMessage.replaceAll('><','>\n<');
        
        System.Debug('***************************************');
        System.Debug('XML Response : ' + xmlResponseMessage);
        System.Debug('***************************************');

        xmlDoc = new Dom.Document();
        xmlDoc.load(xmlResponseMessage);
        xmlNode = xmlDoc.getRootElement();
        nodeName = xmlNode.getName();
        sfdcObjects = new List<SObject>();
        
        System.Debug('***************************************');
        System.Debug('Processing Node : ' + nodeName);
        System.Debug('***************************************');

        if (nodeName == KapConstants.KAP_ENROLLMENT_NODE_NAME) {
            sfdcObject = getEnrollmentDetails(xmlNode);
            sfdcObjects.add(sfdcObject);
        } else if (nodeName == KapConstants.KAP_PROD_ENROLLMENT_NODE_NAME) {
            sfdcObject = getProductEnrollmentDetails(xmlNode);
            sfdcObjects.add(sfdcObject);
        } else if (nodeName == KapConstants.KAP_CLASS_ENROLLMENT_NODE_NAME) {
            sfdcObject = getClassEnrollmentDetails(xmlNode);
            sfdcObjects.add(sfdcObject);
        } else if (nodeName == KapConstants.KAP_EVENT_ENROLLMENT_NODE_NAME) {
            sfdcObject = getEventEnrollmentDetails(xmlNode);
            sfdcObjects.add(sfdcObject);
        } else if (nodeName == KapConstants.KAP_TRANSACTIONS_NODE_NAME) {
            sfdcObjects = getTransactions(xmlNode);
        } else if (nodeName == KapConstants.KAP_SHIP_ORDERS_NODE_NAME) {
            sfdcObjects = getShipOrders(xmlNode);
        } else {
            sfdcObject = null;
        }
        
        return sfdcObjects;
    }

    
    public static Temp_Enrollment__c clearTempEnrollmentRecord(Temp_Enrollment__c tempEnrollment) {
        tempEnrollment.Enrollment_Id__c = '';
        tempEnrollment.Enrollment_Type__c = '';
        tempEnrollment.Student_Id__c = '';
        tempEnrollment.First_Name__c = '';
        tempEnrollment.Last_Name__c = '';
        tempEnrollment.Channel__c = '';
        tempEnrollment.Start_Date__c = Date.valueOf('1900-01-01');
        tempEnrollment.Service_Start_Date__c = Date.valueOf('1900-01-01');
        tempEnrollment.Course_Expiration_Date__c = Date.valueOf('1900-01-01');
        tempEnrollment.Status__c = '';
        tempEnrollment.Class_Code__c = '';
        tempEnrollment.Product_Code__c = '';
        tempEnrollment.Revenue_Center_Code__c = '';
        tempEnrollment.Revenue_Center_Code__c = '';
        tempEnrollment.Study_Center_Code__c = '';
        tempEnrollment.Installment_Billing_Flag__c = false;
        tempEnrollment.Balance_Due__c = 0.00;
        //tempEnrollment.Total_Cost_of_Course__c = 0.00;
       // tempEnrollment.Total_Payment_Made__c = 0.00;
        
        
        
        tempEnrollment.Legacy_Created_On__c = Date.valueOf('1900-01-01');
        tempEnrollment.Legacy_Modified_On__c = Date.valueOf('1900-01-01');
        
        return tempEnrollment;
    }
    
    
    public static Enrollment__c getEnrollmentDetails(Dom.XMLNode xmlNode) {
        Enrollment__c enrollmentRec = new Enrollment__c();
        String tempDate;
        
        enrollmentRec.Channel__c                = getNodeChildElementText(xmlNode,'channel');
        //enrollmentRec.Legacy_Created_On__c    = getNodeChildElementText(xmlNode,'createdOn');
        enrollmentRec.Enrollment_Type__c        = getNodeChildElementText(xmlNode,'enrollType');
        //enrollmentRec.Entry_Date__c           = getNodeChildElementText(xmlNode,'entryDate');
        //enrollmentRec.First_Name__c             = getNodeChildElementText(xmlNode,'firstName');
        enrollmentRec.Enrollment_Id__c          = getNodeChildElementText(xmlNode,'kbsEnrollmentId');
        enrollmentRec.Student_Id__c             = Decimal.ValueOf(getNodeChildElementNumber(xmlNode,'kbsStudentId'));
        //enrollmentRec.Last_Name__c              = getNodeChildElementText(xmlNode,'lastName');
        //enrollmentRec.Legacy_Modified_On__c   = getNodeChildElementText(xmlNode,'modifiedOn');
        
        return enrollmentRec;
    }
    
    
    public static Temp_Enrollment__c getProductEnrollmentDetails(Dom.XMLNode xmlNode) {
        Temp_Enrollment__c enrollmentRec = clearTempEnrollmentRecord(new Temp_Enrollment__c());
        String tempDate;
        Dom.XMLNode parentEnrollmentXmlNode, parentStudentXmlNode;
        
        enrollmentRec.Balance_Due__c            = Decimal.ValueOf(getNodeChildElementNumber(xmlNode,'balanceDue'));
        enrollmentRec.Installment_Billing_Flag__c = Boolean.ValueOf(getNodeChildElementText(xmlNode,'installmentBillingFlag'));
        //enrollmentRec.Installment_Billing_Flag__c = '1';
        //enrollmentRec.Product_Id__c           = getNodeChildElementText(xmlNode,'kbsProductId');
        //enrollmentRec.Program_Id__c           = getNodeChildElementText(xmlNode,'kbsProgramId');
        enrollmentRec.Channel__c                = getNodeChildElementText(xmlNode,'channel');
        enrollmentRec.Student_Id__c             = getNodeChildElementText(xmlNode,'kbsStudentId');
        enrollmentRec.Product_Code__c           = getNodeChildElementText(xmlNode,'productCode');
        enrollmentRec.Revenue_Center_Code__c    = getNodeChildElementText(xmlNode,'revenueCenterCode');
        //enrollmentRec.Center_Id__c            = getNodeChildElementText(xmlNode,'revenueKbsCenterId');
        enrollmentRec.Status__c                 = getNodeChildElementText(xmlNode,'status');
        enrollmentRec.Study_Center_Code__c      = getNodeChildElementText(xmlNode,'studyCenterCode');
        //enrollmentRec.Study_Center_Id__c      = getNodeChildElementText(xmlNode,'studyKbsCenterId');
        enrollmentRec.Total_Cost_of_Course__c            = Decimal.ValueOf(getNodeChildElementNumber(xmlNode,'sumBilling'));
        enrollmentRec.Total_Payment_Made__c            = Decimal.ValueOf(getNodeChildElementNumber(xmlNode,'sumPayment'));
         
       
        parentEnrollmentXmlNode = xmlNode.getChildElement('enrollment', null);
        if (parentEnrollmentXmlNode != null) {
            if ((enrollmentRec.Channel__c == null ) || (enrollmentRec.Channel__c == ''))
                enrollmentRec.Channel__c                = getNodeChildElementText(parentEnrollmentXmlNode,'channel');
        }
        
        if (parentEnrollmentXmlNode != null) {
            parentStudentXmlNode    = parentEnrollmentXmlNode.getChildElement('student', null);
            if (parentStudentXmlNode != null) {
                if ((enrollmentRec.Channel__c == null ) || (enrollmentRec.Channel__c == ''))
                    enrollmentRec.Channel__c            = getNodeChildElementText(parentStudentXmlNode,'channel');
            }
        }

        tempDate = getNodeChildElementDate(xmlNode,'createdOn');
        if (tempDate != '1900-01-01')
            enrollmentRec.Legacy_Created_On__c      = Date.valueOf(getNodeChildElementDate(xmlNode,'createdOn'));
            
        tempDate = getNodeChildElementDate(xmlNode,'expirationDate');
        if (tempDate != '1900-01-01')
            enrollmentRec.Course_Expiration_Date__c        = Date.valueOf(getNodeChildElementDate(xmlNode,'expirationDate'));
            
        tempDate = getNodeChildElementDate(xmlNode,'modifiedOn');
        if (tempDate != '1900-01-01')
            enrollmentRec.Legacy_Modified_On__c     = Date.valueOf(getNodeChildElementDate(xmlNode,'modifiedOn'));
            
        tempDate = getNodeChildElementDate(xmlNode,'serviceStartDate');
        if (tempDate != '1900-01-01')
            enrollmentRec.Service_Start_Date__c     = Date.valueOf(getNodeChildElementDate(xmlNode,'serviceStartDate'));
            
        tempDate = getNodeChildElementDate(xmlNode,'startDate');
        if (tempDate != '1900-01-01')
            enrollmentRec.Start_Date__c             = Date.valueOf(getNodeChildElementDate(xmlNode,'startDate'));
        
        return enrollmentRec;
    }
    
    
    public static Temp_Enrollment__c getClassEnrollmentDetails(Dom.XMLNode xmlNode) {
        Temp_Enrollment__c enrollmentRec = clearTempEnrollmentRecord(new Temp_Enrollment__c());
        Dom.XMLNode parentProductXmlNode;
        String tempDate;
        
        enrollmentRec.Class_Code__c             = getNodeChildElementText(xmlNode,'classCode');
        //enrollmentRec.Class_Id__c             = getNodeChildElementText(xmlNode,'kbsClassId');
        enrollmentRec.Enrollment_Id__c          = getNodeChildElementText(xmlNode,'kbsEnrollmentId');
        enrollmentRec.Student_Id__c             = getNodeChildElementText(xmlNode,'kbsStudentId');
        
        parentProductXmlNode    = xmlNode.getChildElement('productEnrollment', null);
        
        enrollmentRec.Product_Code__c           = getNodeChildElementText(parentProductXmlNode,'productCode');
        enrollmentRec.Balance_Due__c            = Decimal.ValueOf(getNodeChildElementNumber(parentProductXmlNode,'balanceDue'));
        enrollmentRec.Installment_Billing_Flag__c = Boolean.ValueOf(getNodeChildElementText(xmlNode,'installmentBillingFlag'));
        //enrollmentRec.Installment_Billing_Flag__c = '1';
        //enrollmentRec.Product_Id__c           = getNodeChildElementText(xmlNode,'kbsProductId');
        //enrollmentRec.Program_Id__c           = getNodeChildElementText(xmlNode,'kbsProgramId');
        enrollmentRec.Product_Code__c           = getNodeChildElementText(parentProductXmlNode,'productCode');
        enrollmentRec.Revenue_Center_Code__c    = getNodeChildElementText(parentProductXmlNode,'revenueCenterCode');
        //enrollmentRec.Center_Id__c            = getNodeChildElementText(xmlNode,'revenueKbsCenterId');
        enrollmentRec.Status__c                 = getNodeChildElementText(parentProductXmlNode,'status');
        enrollmentRec.Study_Center_Code__c      = getNodeChildElementText(parentProductXmlNode,'studyCenterCode');
        //enrollmentRec.Study_Center_Id__c      = getNodeChildElementText(xmlNode,'studyKbsCenterId');
        enrollmentRec.Total_Cost_of_Course__c            = Decimal.ValueOf(getNodeChildElementNumber(parentProductXmlNode,'sumBilling'));
        enrollmentRec.Total_Payment_Made__c            = Decimal.ValueOf(getNodeChildElementNumber(parentProductXmlNode,'sumPayment'));

        enrollmentRec.Legacy_Created_On__c      = Date.valueOf(getNodeChildElementDate(xmlNode,'createdOn'));
        enrollmentRec.Legacy_Modified_On__c     = Date.valueOf(getNodeChildElementDate(xmlNode,'modifiedOn'));
        enrollmentRec.Course_Expiration_Date__c        = Date.valueOf(getNodeChildElementDate(parentProductXmlNode,'expirationDate'));
        enrollmentRec.Service_Start_Date__c     = Date.valueOf(getNodeChildElementDate(parentProductXmlNode,'serviceStartDate'));
        enrollmentRec.Start_Date__c             = Date.valueOf(getNodeChildElementDate(parentProductXmlNode,'startDate'));
         
        
     //   enrollmentRec.Total_Enrollment_fee__c=enrollmentRec.Total_Payment_Made__c;
        
         
        return enrollmentRec;
    }
    
    
    public static Temp_Enrollment__c getEventEnrollmentDetails(Dom.XMLNode xmlNode) {
        Temp_Enrollment__c enrollmentRec = clearTempEnrollmentRecord(new Temp_Enrollment__c());
        String tempDate;
        
        enrollmentRec.Center_Code__c            = getNodeChildElementText(xmlNode,'centerCode');
        enrollmentRec.Event_Code__c             = getNodeChildElementText(xmlNode,'eventCode');
        enrollmentRec.Event_Type__c             = getNodeChildElementText(xmlNode,'eventType');
        //enrollmentRec.Center_Id__c            = getNodeChildElementText(xmlNode,'kbsCenterId');
        enrollmentRec.Enrollment_Id__c          = getNodeChildElementText(xmlNode,'kbsEnrollmentId');
        //enrollmentRec.Event_Id__c             = getNodeChildElementText(xmlNode,'kbsEventId');
        enrollmentRec.Student_Id__c             = getNodeChildElementText(xmlNode,'kbsStudentId');
        enrollmentRec.Status__c                 = getNodeChildElementText(xmlNode,'status');
        
        enrollmentRec.Legacy_Created_On__c      = Date.valueOf(getNodeChildElementDate(xmlNode,'createdOn'));
        enrollmentRec.Course_Expiration_Date__c        = Date.valueOf(getNodeChildElementDate(xmlNode,'expirationDate'));
        enrollmentRec.Legacy_Modified_On__c     = Date.valueOf(getNodeChildElementDate(xmlNode,'modifiedOn'));
        enrollmentRec.Start_Date__c             = Date.valueOf(getNodeChildElementDate(xmlNode,'startDate'));

        return enrollmentRec;
    }
    
    
    public static Temp_Transaction__c getTransactionRec(Dom.XMLNode xmlNode) {
        Temp_Transaction__c transactionRec = new Temp_Transaction__c();
        String tempDate;

        transactionRec.Transaction_Id__c        = getNodeChildElementText(xmlNode,'dkTransactionId');
        transactionRec.CDC_Modified_On__c       = getNodeChildElementText(xmlNode,'cdcModifiedOn');
        transactionRec.Enrollment_Id__c         = getNodeChildElementText(xmlNode,'kbsEnrollmentId');
        //transactionRec.channel__c             = getNodeChildElementText(xmlNode,'relatedToDKTxnId');
        transactionRec.Receipt_Number__c        = getNodeChildElementText(xmlNode,'receiptNumber');
        transactionRec.Journal_Number__c        = getNodeChildElementText(xmlNode,'journalNumber');
        transactionRec.Txn_Type__c              = getNodeChildElementText(xmlNode,'txnType');
        transactionRec.Txn_Code__c              = getNodeChildElementText(xmlNode,'txnCode');
        transactionRec.Status__c                = getNodeChildElementText(xmlNode,'status');
        transactionRec.Discount_Code__c         = getNodeChildElementText(xmlNode,'discountCode');
        transactionRec.Bundle_Discount_Code__c  = getNodeChildElementText(xmlNode,'bundleDiscountCode');
        transactionRec.CC_CK_Type__c            = getNodeChildElementText(xmlNode,'ccCkType');
        transactionRec.CC_CK_Number__c          = getNodeChildElementText(xmlNode,'ccCkNumber');
        transactionRec.CC_Auth_Code__c          = getNodeChildElementText(xmlNode,'ccAuthCode');
        //transactionRec.CC_Batch_Id__c           = getNodeChildElementText(xmlNode,'ccBatchId');
        transactionRec.Initial_Fee__c           = Decimal.ValueOf(getNodeChildElementNumber(xmlNode,'initialFee'));
        transactionRec.Initial_Adj__c           = Decimal.ValueOf(getNodeChildElementNumber(xmlNode,'initialAdj'));
        transactionRec.Initial_Disc__c          = Decimal.ValueOf(getNodeChildElementNumber(xmlNode,'initialDisc'));
        transactionRec.Billing_CR__c            = Decimal.ValueOf(getNodeChildElementNumber(xmlNode,'billingCr'));
        transactionRec.Billing_DR__c            = Decimal.ValueOf(getNodeChildElementNumber(xmlNode,'billingDr'));
        transactionRec.Cash_CR__c               = Decimal.ValueOf(getNodeChildElementNumber(xmlNode,'cashCr'));
        transactionRec.Cash_DR__c               = Decimal.ValueOf(getNodeChildElementNumber(xmlNode,'cashDr'));
        transactionRec.Tuition_Flag__c          = Boolean.ValueOf(getNodeChildElementText(xmlNode,'tuitionFlag'));
        transactionRec.Void_Flag__c             = Boolean.ValueOf(getNodeChildElementText(xmlNode,'voidFlag'));
        transactionRec.Auto_Flag__c             = Boolean.ValueOf(getNodeChildElementText(xmlNode,'autoFlag'));
 
        transactionRec.Entry_Date__c            = Date.valueOf(getNodeChildElementDate(xmlNode,'entryDate'));
        transactionRec.Journal_Posted_Date__c   = Date.valueOf(getNodeChildElementDate(xmlNode,'jnlPostedDate'));
        transactionRec.Journal_EOM_Date__c      = Date.valueOf(getNodeChildElementDate(xmlNode,'jnlEomDate'));

        return transactionRec;
    }
     
     
    public static List<Temp_Transaction__c> getTransactions(Dom.XMLNode xmlNode) {
        List<Temp_Transaction__c> transactions = new List<Temp_Transaction__c>();
        Temp_Transaction__c transactionRec = new Temp_Transaction__c();
        
        List<Dom.XMLNode> transactionNodes;
        
        transactionNodes = xmlNode.getChildren();
        System.Debug('***************************************');
        System.Debug('No. of Transaction Child Nodes: ' + transactionNodes.Size());
        System.Debug('***************************************');
        
        for (Dom.XMLNode childTxnNode: transactionNodes) {
            System.Debug('***************************************');
            System.Debug('Child Node Details: ' + childTxnNode.getName());
            System.Debug('***************************************');
            if (childTxnNode.getName() == KapConstants.KAP_TRANSACTION_NODE_NAME) {
                transactionRec = getTransactionRec(childTxnNode);
                transactions.add(transactionRec);
            }
        }
        
        System.Debug('***************************************');
        System.Debug('No. of Transactions: ' + transactions.Size());
        System.Debug('***************************************');

        return transactions;
    }
    
    
    public static Temp_Ship_Order__c getShipOrderRec(Dom.XMLNode xmlNode) {
        Temp_Ship_Order__c shipOrderRec = new Temp_Ship_Order__c();
        String tempDate;
        
        shipOrderRec.Shipment_Id__c             = getNodeChildElementText(xmlNode,'kbsShipmentId');
        //shipOrderRec.Source_System__c         = getNodeChildElementText(xmlNode,'sourceSystem');
        //shipOrderRec.Enrollment_Id__c             = getNodeChildElementText(xmlNode,'kbsEnrollmentId');
        shipOrderRec.Ship_Address_1__c          = getNodeChildElementText(xmlNode,'line1');
        shipOrderRec.Ship_Address_2__c          = getNodeChildElementText(xmlNode,'line2');
        shipOrderRec.Ship_City__c               = getNodeChildElementText(xmlNode,'city');
        shipOrderRec.Ship_Country__c            = getNodeChildElementText(xmlNode,'country');
        shipOrderRec.Ship_State__c              = getNodeChildElementText(xmlNode,'state');
        shipOrderRec.Ship_Postal_Code__c        = getNodeChildElementText(xmlNode,'zip');
        shipOrderRec.Tracking_Number__c         = getNodeChildElementText(xmlNode,'trackingNumber');
        shipOrderRec.Ship_Status__c             = getNodeChildElementText(xmlNode,'status');
        shipOrderRec.Batch_File_Name__c         = getNodeChildElementText(xmlNode,'batchfilename');
        shipOrderRec.Shipping_Method__c         = getNodeChildElementText(xmlNode,'shippingMethod');
        shipOrderRec.Shipping_Charge__c         = Decimal.ValueOf(getNodeChildElementNumber(xmlNode,'shippingCharge'));
        shipOrderRec.Warehouse_Recognition__c   = getNodeChildElementText(xmlNode,'warehouseRecognition');
        shipOrderRec.Carrier_Code__c            = getNodeChildElementText(xmlNode,'carrierCode');
        shipOrderRec.Override_Comment__c        = getNodeChildElementText(xmlNode,'overrideComment');
        shipOrderRec.Is_Ship_Now_Flag__c        = Boolean.ValueOf(getNodeChildElementText(xmlNode,'shipNowFlag'));
        shipOrderRec.Email_Sent_Flag__c         = Boolean.ValueOf(getNodeChildElementText(xmlNode,'emailSentFlag'));
        shipOrderRec.Second_Shipment_Flag__c    = Boolean.ValueOf(getNodeChildElementText(xmlNode,'secondShipmentFlag'));
        shipOrderRec.Total_Shipment_Fee__c      = 0;
        
        //shipOrderRec.Legacy_Created_On__c         = Date.valueOf(getNodeChildElementText(xmlNode,'createdOn'));
        //shipOrderRec.Legacy_Modified_On__c        = Date.valueOf(getNodeChildElementText(xmlNode,'modifiedOn'));
        tempDate = getNodeChildElementDate(xmlNode,'shipDate');
        if (tempDate != '1900-01-01')
            shipOrderRec.Ship_Date__c               = Date.valueOf(getNodeChildElementDate(xmlNode,'shipDate'));
            
        tempDate = getNodeChildElementDate(xmlNode,'sentDate');
        if (tempDate != '1900-01-01')
            shipOrderRec.Send_Date__c               = Date.valueOf(getNodeChildElementDate(xmlNode,'sentDate'));
            
        tempDate = getNodeChildElementDate(xmlNode,'responseDate');
        if (tempDate != '1900-01-01')
            shipOrderRec.Response_Date__c           = Date.valueOf(getNodeChildElementDate(xmlNode,'responseDate'));
            
        tempDate = getNodeChildElementDate(xmlNode,'queuedDate');
        if (tempDate != '1900-01-01')
            shipOrderRec.Queued_Date__c             = Date.valueOf(getNodeChildElementDate(xmlNode,'queuedDate'));

        return shipOrderRec;
    }
     
  
     
    public Static List<Temp_Ship_Order__c> getShipOrders(Dom.XMLNode xmlNode) {
        List<Temp_Ship_Order__c> shipOrders = new List<Temp_Ship_Order__c>();
    
    //  shippingtotal144test=33.3;
         //added 
         Decimal shippingTotal=0.00;
         Decimal oldshippingFee=0.00;
        Temp_Ship_Order__c shipOrderRec = new Temp_Ship_Order__c();
        List<Dom.XMLNode> shipOrderNodes;
        
        shipOrderNodes = xmlNode.getChildren();
        
        for (Dom.XMLNode childShipNode: shipOrderNodes) {
            if (childShipNode.getName() == KapConstants.KAP_SHIP_ORDER_NODE_NAME) {
                shipOrderRec = getShipOrderRec(childShipNode);
                
            shippingTotal+=shipOrderRec.Shipping_Charge__c;
           // shippingTotal=ShippingTotal+1.00;
           shipOrderRec.Total_Shipment_Fee__c=shippingTotal;
                shipOrders.add(shipOrderRec);
            }
          
        }
        
        System.debug('total shipping fee is '+shippingTotal);
        
        Enrollment__c enrollment = new Enrollment__c();
        enrollment.Total_Shipment__c=shippingTotal;
       // insert enrollment;
        System.debug('total shipping fee  from enrollment is '+enrollment.Total_Shipment__c+'enrollment id is'+shipOrders);
       
     
            
        return shipOrders;
    }
   
  
  
    
  /*  
    public Decimal getShipOrdersFee() {
        
         Dom.Document xmlDoc;
        Dom.XMLNode xmlNode;
        String nodeName;
        

        xmlDoc = new Dom.Document();
        xmlNode = xmlDoc.getRootElement();
        nodeName = xmlNode.getName();
        
        List<Temp_Ship_Order__c> shipOrders = getShipOrders(xmlNode);
        
         //added 
         Decimal shippingTotal=0.00;
         Decimal oldshippingFee=0.00;
        Temp_Ship_Order__c shipOrderRec = new Temp_Ship_Order__c();
        List<Dom.XMLNode> shipOrderNodes;
        
        shipOrderNodes = xmlNode.getChildren();
        
        for (List<Temp_Ship_Order__c> shipOrders1 : shipOrders) {
           
                
            shippingTotal+=shipOrders.Shipping_Charge__c;
           
              
           
          
        }
        
        System.debug('total shipping fee is '+shippingTotal);
        
      
        
        return shippingTotal;
    }
    
   
    */
    
    
    public static String getTrackingURL(Dom.XMLNode xmlNode) {
        
        return null;
    }
    
    
    public static String getTestEnrollmentDetails(String enrollmentType) {
        String xmlString;
        List<String> listEnrollments = new List<String>();
        
        if (enrollmentType == 'Enrollment') {
            
            //Base Enrollment Details
            xmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>  ';
            xmlString = xmlString + '<enrollment> ';
            xmlString = xmlString + '   <channel>40</channel>  ';
            xmlString = xmlString + '   <createdOn>2005-05-26</createdOn>  ';
            xmlString = xmlString + '   <enrollType>product</enrollType>  ';
            xmlString = xmlString + '   <entryDate>2001-04-23</entryDate>  ';
            xmlString = xmlString + '   <firstName>Evelyn</firstName>  ';
            xmlString = xmlString + '   <kbsEnrollmentId>41258537</kbsEnrollmentId>  ';
            xmlString = xmlString + '   <kbsStudentId>41269861</kbsStudentId>  ';
            xmlString = xmlString + '   <lastName>Laboy</lastName>  ';
            xmlString = xmlString + '   <modifiedOn>2008-06-04</modifiedOn>  ';
            xmlString = xmlString + '</enrollment> ';
            
            /*
            //Extended Enrollment Details
            xmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?> ';
            xmlString = xmlString + '<enrollment> ';
            xmlString = xmlString + '   <channel>40</channel>  ';
            xmlString = xmlString + '   <createdOn>2005-05-26</createdOn>  ';
            xmlString = xmlString + '   <enrollType>product</enrollType>  ';
            xmlString = xmlString + '   <entryDate>2001-04-23</entryDate>  ';
            xmlString = xmlString + '   <firstName>Evelyn</firstName>  ';
            xmlString = xmlString + '   <kbsEnrollmentId>41258537</kbsEnrollmentId>  ';
            xmlString = xmlString + '   <kbsStudentId>41269861</kbsStudentId>  ';
            xmlString = xmlString + '   <lastName>Laboy</lastName>  ';
            xmlString = xmlString + '   <modifiedOn>2008-06-04</modifiedOn>  ';
            xmlString = xmlString + '   <student> ';
            xmlString = xmlString + '       <centerCode>0231</centerCode>  ';
            xmlString = xmlString + '       <channel>40</channel>  ';
            xmlString = xmlString + '       <createdOn>2008-06-04</createdOn>  ';
            xmlString = xmlString + '       <doNotCallFlag>false</doNotCallFlag>  ';
            xmlString = xmlString + '       <doNotEmailFlag>false</doNotEmailFlag>  ';
            xmlString = xmlString + '       <doNotMailFlag>false</doNotMailFlag>  ';
            xmlString = xmlString + '       <doNotShareFlag>false</doNotShareFlag>  ';
            xmlString = xmlString + '       <entryDate>2000-11-20</entryDate>  ';
            xmlString = xmlString + '       <externalSystem>DKPROXY</externalSystem>  ';
            xmlString = xmlString + '       <firstName>Evelyn</firstName>  ';
            xmlString = xmlString + '       <hotFlag>false</hotFlag>  ';
            xmlString = xmlString + '       <kbsCenterId>155</kbsCenterId>  ';
            xmlString = xmlString + '       <kbsStudentId>41269861</kbsStudentId>  ';
            xmlString = xmlString + '       <kbsSystemId>1004044431</kbsSystemId>  ';
            xmlString = xmlString + '       <lastName>Laboy</lastName>  ';
            xmlString = xmlString + '       <leadSourceId>49</leadSourceId>  ';
            xmlString = xmlString + '       <leadSourceName>Tabling - On Campus</leadSourceName>  ';
            xmlString = xmlString + '       <middleName>M</middleName>  ';
            xmlString = xmlString + '       <natDoNotCallFlag>false</natDoNotCallFlag>  ';
            xmlString = xmlString + '       <phone1>7878362071</phone1>  ';
            xmlString = xmlString + '       <phone1Type>Other</phone1Type>  ';
            xmlString = xmlString + '       <phone2>7878362071</phone2>  ';
            xmlString = xmlString + '       <phone2Type>Other</phone2Type>  ';
            xmlString = xmlString + '       <primaryAddress> ';
            xmlString = xmlString + '           <address1>Urb. Kennedy #89</address1>  ';
            xmlString = xmlString + '           <address2>Calle B</address2>  ';
            xmlString = xmlString + '           <city>Penuelas</city>  ';
            xmlString = xmlString + '           <stateProvince>PR</stateProvince>  ';
            xmlString = xmlString + '           <postalCode>00624</postalCode>  ';
            xmlString = xmlString + '           <country>United States</country>  ';
            xmlString = xmlString + '       </primaryAddress> ';
            xmlString = xmlString + '       <upperFirstName>EVELYN</upperFirstName>  ';
            xmlString = xmlString + '       <upperLastName>LABOY</upperLastName>  ';
            xmlString = xmlString + '   </student> ';
            xmlString = xmlString + '</enrollment> ';
            */
        
        } else if (enrollmentType == 'Class') {
        
            //Extended Class Enrollment Details
            xmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>   ';
            xmlString = xmlString + '<classEnrollment> ';
            xmlString = xmlString + '   <classCode>MCTO5014A</classCode>  ';
            xmlString = xmlString + '   <createdOn>2005-05-25</createdOn>  ';
            xmlString = xmlString + '   <kbsClassId>1000544186</kbsClassId>  ';
            xmlString = xmlString + '   <kbsEnrollmentId>41793834</kbsEnrollmentId>  ';
            xmlString = xmlString + '   <kbsStudentId>41790128</kbsStudentId>  ';
            xmlString = xmlString + '   <modifiedOn>2009-10-22</modifiedOn>  ';
            xmlString = xmlString + '   <productEnrollment> ';
            xmlString = xmlString + '       <balanceDue>0</balanceDue>  ';
            xmlString = xmlString + '       <createdOn>2005-05-25</createdOn>  ';
            xmlString = xmlString + '       <expirationDate>2005-08-20</expirationDate>  ';
            xmlString = xmlString + '       <installmentBillingFlag>false</installmentBillingFlag>  ';
            xmlString = xmlString + '       <kbsEnrollmentId>41793834</kbsEnrollmentId>  ';
            xmlString = xmlString + '       <kbsProductId>33</kbsProductId>  ';
            xmlString = xmlString + '       <kbsProgramId>9</kbsProgramId>  ';
            xmlString = xmlString + '       <kbsStudentId>41790128</kbsStudentId>  ';
            xmlString = xmlString + '       <modifiedOn>2010-08-30</modifiedOn>  ';
            xmlString = xmlString + '       <productCode>MCAT</productCode>  ';
            xmlString = xmlString + '       <revenueCenterCode>0226</revenueCenterCode>  ';
            xmlString = xmlString + '       <revenueKbsCenterId>157</revenueKbsCenterId>  ';
            xmlString = xmlString + '       <serviceStartDate>2005-05-25</serviceStartDate>  ';
            xmlString = xmlString + '       <startDate>2005-06-05</startDate>  ';
            xmlString = xmlString + '       <status>Alumnus</status>  ';
            xmlString = xmlString + '       <studyCenterCode>0226</studyCenterCode>  ';
            xmlString = xmlString + '       <studyKbsCenterId>157</studyKbsCenterId>  ';
            xmlString = xmlString + '       <sumBilling>212</sumBilling>  ';
            xmlString = xmlString + '       <sumPayment>212</sumPayment>  ';
            xmlString = xmlString + '       <enrollment> ';
            xmlString = xmlString + '           <channel>40</channel>  ';
            xmlString = xmlString + '           <createdOn>2005-05-25</createdOn>  ';
            xmlString = xmlString + '           <enrollType>product</enrollType>  ';
            xmlString = xmlString + '           <entryDate>2005-05-25</entryDate>  ';
            xmlString = xmlString + '           <firstName>Amber</firstName>  ';
            xmlString = xmlString + '           <kbsEnrollmentId>41793834</kbsEnrollmentId>  ';
            xmlString = xmlString + '           <kbsStudentId>41790128</kbsStudentId>  ';
            xmlString = xmlString + '           <lastName>Liu</lastName>  ';
            xmlString = xmlString + '           <modifiedOn>2005-08-20</modifiedOn>  ';
            xmlString = xmlString + '           <student> ';
            xmlString = xmlString + '               <centerCode>0226</centerCode>  ';
            xmlString = xmlString + '               <channel>10</channel>  ';
            xmlString = xmlString + '               <createdOn>2004-06-08</createdOn>  ';
            xmlString = xmlString + '               <doNotCallFlag>false</doNotCallFlag>  ';
            xmlString = xmlString + '               <doNotEmailFlag>false</doNotEmailFlag>  ';
            xmlString = xmlString + '               <doNotMailFlag>false</doNotMailFlag>  ';
            xmlString = xmlString + '               <doNotShareFlag>false</doNotShareFlag>  ';
            xmlString = xmlString + '               <email1>amber.liu@utoronto.ca</email1>  ';
            xmlString = xmlString + '               <entryDate>2004-06-08</entryDate>  ';
            xmlString = xmlString + '               <firstName>Amber</firstName>  ';
            xmlString = xmlString + '               <hotFlag>false</hotFlag>  ';
            xmlString = xmlString + '               <kbsCenterId>157</kbsCenterId>  ';
            xmlString = xmlString + '               <kbsStudentId>41790128</kbsStudentId>  ';
            xmlString = xmlString + '               <kbsSystemId>41790128</kbsSystemId>  ';
            xmlString = xmlString + '               <lastName>Liu</lastName>  ';
            xmlString = xmlString + '               <leadSourceId>5</leadSourceId>  ';
            xmlString = xmlString + '               <leadSourceName>Career/Grad Fair   On Campus</leadSourceName>  ';
            xmlString = xmlString + '               <natDoNotCallFlag>false</natDoNotCallFlag>  ';
            xmlString = xmlString + '               <phone1>9057639346</phone1>  ';
            xmlString = xmlString + '               <primaryAddress> ';
            xmlString = xmlString + '                   <address1>150 Rideau Drive</address1>  ';
            xmlString = xmlString + '                   <city>Richmond Hill</city>  ';
            xmlString = xmlString + '                   <stateProvince>ON</stateProvince>  ';
            xmlString = xmlString + '                   <postalCode>L4B4J1</postalCode>  ';
            xmlString = xmlString + '                   <country>Canada</country>  ';
            xmlString = xmlString + '               </primaryAddress> ';
            xmlString = xmlString + '               <status>Upsell Unassigned</status>  ';
            xmlString = xmlString + '               <upperFirstName>AMBER</upperFirstName>  ';
            xmlString = xmlString + '               <upperLastName>LIU</upperLastName>  ';
            xmlString = xmlString + '           </student> ';
            xmlString = xmlString + '       </enrollment> ';
            xmlString = xmlString + '   </productEnrollment> ';
            xmlString = xmlString + '</classEnrollment> ';
        
        } else if (enrollmentType == 'Product') {


            //Extended Product Enrollment Details
            xmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>  ';
            xmlString = xmlString + '<productEnrollment> ';
            xmlString = xmlString + '   <balanceDue>0</balanceDue>  ';
            xmlString = xmlString + '   <createdOn>2005-06-19</createdOn>  ';
            xmlString = xmlString + '   <expirationDate>2005-07-20</expirationDate>  ';
            xmlString = xmlString + '   <installmentBillingFlag>false</installmentBillingFlag>  ';
            xmlString = xmlString + '   <kbsEnrollmentId>56117690</kbsEnrollmentId>  ';
            xmlString = xmlString + '   <kbsProductId>727</kbsProductId>  ';
            xmlString = xmlString + '   <kbsProgramId>97</kbsProgramId>  ';
            xmlString = xmlString + '   <kbsStudentId>55920696</kbsStudentId>  ';
            xmlString = xmlString + '   <modifiedOn>2010-07-09</modifiedOn>  ';
            xmlString = xmlString + '   <productCode>USMLQB1A</productCode>  ';
            xmlString = xmlString + '   <revenueCenterCode>0068</revenueCenterCode>  ';
            xmlString = xmlString + '   <revenueKbsCenterId>392</revenueKbsCenterId>  ';
            xmlString = xmlString + '   <serviceStartDate>2005-06-19</serviceStartDate>  ';
            xmlString = xmlString + '   <startDate>2005-06-19</startDate>  ';
            xmlString = xmlString + '   <status>Alumnus</status>  ';
            xmlString = xmlString + '   <studyCenterCode>0068</studyCenterCode>  ';
            xmlString = xmlString + '   <studyKbsCenterId>392</studyKbsCenterId>  ';
            xmlString = xmlString + '   <sumBilling>179</sumBilling>  ';
            xmlString = xmlString + '   <sumPayment>179</sumPayment>  ';
            xmlString = xmlString + '   <enrollment> ';
            xmlString = xmlString + '       <channel>20</channel>  ';
            xmlString = xmlString + '       <createdOn>2005-06-19</createdOn>  ';
            xmlString = xmlString + '       <enrollType>product</enrollType>  ';
            xmlString = xmlString + '       <entryDate>2005-06-19</entryDate>  ';
            xmlString = xmlString + '       <firstName>Juan Carlos</firstName>  ';
            xmlString = xmlString + '       <kbsEnrollmentId>56117690</kbsEnrollmentId>  ';
            xmlString = xmlString + '       <kbsStudentId>55920696</kbsStudentId>  ';
            xmlString = xmlString + '       <lastName>Buitrago</lastName>  ';
            xmlString = xmlString + '       <modifiedOn>2005-07-20</modifiedOn>  ';
            xmlString = xmlString + '       <student> ';
            xmlString = xmlString + '           <centerCode>0068</centerCode>  ';
            xmlString = xmlString + '           <channel>20</channel>  ';
            xmlString = xmlString + '           <createdOn>2004-08-10</createdOn>  ';
            xmlString = xmlString + '           <doNotCallFlag>false</doNotCallFlag>  ';
            xmlString = xmlString + '           <doNotEmailFlag>false</doNotEmailFlag>  ';
            xmlString = xmlString + '           <doNotMailFlag>false</doNotMailFlag>  ';
            xmlString = xmlString + '           <doNotShareFlag>false</doNotShareFlag>  ';
            xmlString = xmlString + '           <email1>jcbuitrago@gmail.com</email1>  ';
            xmlString = xmlString + '           <entryDate>2004-08-10</entryDate>  ';
            xmlString = xmlString + '           <firstName>Juan Carlos</firstName>  ';
            xmlString = xmlString + '           <hotFlag>false</hotFlag>  ';
            xmlString = xmlString + '           <kbsCenterId>392</kbsCenterId>  ';
            xmlString = xmlString + '           <kbsStudentId>55920696</kbsStudentId>  ';
            xmlString = xmlString + '           <kbsSystemId>1000275195</kbsSystemId>  ';
            xmlString = xmlString + '           <lastName>Buitrago</lastName>  ';
            xmlString = xmlString + '           <leadSourceId>4</leadSourceId>  ';
            xmlString = xmlString + '           <leadSourceName>Career Center/Planning Office</leadSourceName>  ';
            xmlString = xmlString + '           <natDoNotCallFlag>false</natDoNotCallFlag>  ';
            xmlString = xmlString + '           <phone1>8095419698</phone1>  ';
            xmlString = xmlString + '           <phone1Type>Home</phone1Type>  ';
            xmlString = xmlString + '           <primaryAddress> ';
            xmlString = xmlString + '               <address1>C/ Fernando Escobar Hurtado No. 23</address1>  ';
            xmlString = xmlString + '               <address2>Apto. 3 2Do Piso, Piantini</address2>  ';
            xmlString = xmlString + '               <city>Santo Domingo</city>  ';
            xmlString = xmlString + '               <stateProvince>DN</stateProvince>  ';
            xmlString = xmlString + '               <country>Dominican Republic</country>  ';
            xmlString = xmlString + '           </primaryAddress> ';
            xmlString = xmlString + '           <status>Unassigned</status>  ';
            xmlString = xmlString + '           <upperFirstName>JUAN CARLOS</upperFirstName>  ';
            xmlString = xmlString + '           <upperLastName>BUITRAGO</upperLastName>  ';
            xmlString = xmlString + '       </student> ';
            xmlString = xmlString + '   </enrollment> ';
            xmlString = xmlString + '</productEnrollment> ';
        
        } else if (enrollmentType == 'Event') {
            
            //Extended Event Enrollment Details
            xmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>  ';
            xmlString = xmlString + '<eventEnrollment> ';
            xmlString = xmlString + '   <centerCode>0221</centerCode>  ';
            xmlString = xmlString + '   <createdOn>2004-03-11</createdOn>  ';
            xmlString = xmlString + '   <eventCode>LKOT4001</eventCode>  ';
            xmlString = xmlString + '   <eventType>other marketing</eventType>  ';
            xmlString = xmlString + '   <expirationDate>2004-03-11</expirationDate>  ';
            xmlString = xmlString + '   <kbsCenterId>185</kbsCenterId>  ';
            xmlString = xmlString + '   <kbsEnrollmentId>41513897</kbsEnrollmentId>  ';
            xmlString = xmlString + '   <kbsEventId>1000032899</kbsEventId>  ';
            xmlString = xmlString + '   <kbsStudentId>41519867</kbsStudentId>  ';
            xmlString = xmlString + '   <modifiedOn>2006-12-07</modifiedOn>  ';
            xmlString = xmlString + '   <startDate>2004-03-11</startDate>  ';
            xmlString = xmlString + '   <status>Enrolled</status>  ';
            xmlString = xmlString + '   <enrollment> ';
            xmlString = xmlString + '       <channel>40</channel>  ';
            xmlString = xmlString + '       <createdOn>2004-03-10</createdOn>  ';
            xmlString = xmlString + '       <enrollType>event</enrollType>  ';
            xmlString = xmlString + '       <entryDate>2004-03-10</entryDate>  ';
            xmlString = xmlString + '       <firstName>Pam</firstName>  ';
            xmlString = xmlString + '       <kbsEnrollmentId>41513897</kbsEnrollmentId>  ';
            xmlString = xmlString + '       <kbsStudentId>41519867</kbsStudentId>  ';
            xmlString = xmlString + '       <lastName>Hrick</lastName>  ';
            xmlString = xmlString + '       <modifiedOn>2006-12-07</modifiedOn>  ';
            xmlString = xmlString + '       <student> ';
            xmlString = xmlString + '           <centerCode>0221</centerCode>  ';
            xmlString = xmlString + '           <channel>40</channel>  ';
            xmlString = xmlString + '           <createdOn>2004-03-10</createdOn>  ';
            xmlString = xmlString + '           <doNotCallFlag>false</doNotCallFlag>  ';
            xmlString = xmlString + '           <doNotEmailFlag>false</doNotEmailFlag>  ';
            xmlString = xmlString + '           <doNotMailFlag>false</doNotMailFlag>  ';
            xmlString = xmlString + '           <doNotShareFlag>false</doNotShareFlag>  ';
            xmlString = xmlString + '           <email1>pric015@uottawa.ca</email1>  ';
            xmlString = xmlString + '           <entryDate>2004-03-10</entryDate>  ';
            xmlString = xmlString + '           <firstName>Pam</firstName>  ';
            xmlString = xmlString + '           <hotFlag>false</hotFlag>  ';
            xmlString = xmlString + '           <kbsCenterId>185</kbsCenterId>  ';
            xmlString = xmlString + '           <kbsStudentId>41519867</kbsStudentId>  ';
            xmlString = xmlString + '           <kbsSystemId>41519867</kbsSystemId>  ';
            xmlString = xmlString + '           <lastName>Hrick</lastName>  ';
            xmlString = xmlString + '           <leadSourceId>54</leadSourceId>  ';
            xmlString = xmlString + '           <leadSourceName>Word of Mouth</leadSourceName>  ';
            xmlString = xmlString + '           <natDoNotCallFlag>false</natDoNotCallFlag>  ';
            xmlString = xmlString + '           <phone1>6137450218</phone1>  ';
            xmlString = xmlString + '           <phone1Type>Home</phone1Type>  ';
            xmlString = xmlString + '           <primaryAddress> ';
            xmlString = xmlString + '               <address1>665 Bathgate Drive</address1>  ';
            xmlString = xmlString + '               <address2>Apt 1112</address2>  ';
            xmlString = xmlString + '               <city>Ottawa</city>  ';
            xmlString = xmlString + '               <stateProvince>ON</stateProvince>  ';
            xmlString = xmlString + '               <postalCode>K1K3Y4</postalCode>  ';
            xmlString = xmlString + '               <country>Canada</country>  ';
            xmlString = xmlString + '           </primaryAddress> ';
            xmlString = xmlString + '           <status>Unassigned</status>  ';
            xmlString = xmlString + '           <upperFirstName>PAM</upperFirstName>  ';
            xmlString = xmlString + '           <upperLastName>HRICK</upperLastName>  ';
            xmlString = xmlString + '       </student> ';
            xmlString = xmlString + '   </enrollment> ';
            xmlString = xmlString + '</eventEnrollment> ';
        
        }
        
        listEnrollments.add(xmlString);
        
        return xmlString;
    }
    
    
    public static String getTestTransactions() {
        String xmlString;
        List<String> listTransactions = new List<String>();
        
        xmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?> ';
        xmlString = xmlString + '<dkTransactions> ';
        xmlString = xmlString + '   <dkTransaction>';
        xmlString = xmlString + '       <transactionId>TEST_DATA</transactionId> ';
        xmlString = xmlString + '       <cdcModifiedOn>2008-06-04</cdcModifiedOn> ';
        xmlString = xmlString + '       <kbsEnrollmentId>TEST_DATA</kbsEnrollmentId> ';
        xmlString = xmlString + '       <relatedToDKTxnId>TEST_DATA</relatedToDKTxnId> ';
        xmlString = xmlString + '       <receiptNumber>TEST_DATA</receiptNumber> ';
        xmlString = xmlString + '       <journalNumber>TEST_DATA</journalNumber> ';
        xmlString = xmlString + '       <entryDate>2008-06-04</entryDate> ';
        xmlString = xmlString + '       <jnlPostedDate>2008-06-04</jnlPostedDate> ';
        xmlString = xmlString + '       <jnlEomDate>2008-06-04</jnlEomDate> ';
        xmlString = xmlString + '       <txnCode>TEST_DATA</txnCode> ';
        xmlString = xmlString + '       <txnType>TEST_DATA</txnType> ';
        xmlString = xmlString + '       <status>TEST_DATA</status> ';
        xmlString = xmlString + '       <discountCode>TEST_DATA</discountCode> ';
        xmlString = xmlString + '       <bundleDiscountCode>TEST_DATA</bundleDiscountCode> ';
        xmlString = xmlString + '       <ccCkType>TEST_DATA</ccCkType> ';
        xmlString = xmlString + '       <ccCkNumber>TEST_DATA</ccCkNumber> ';
        xmlString = xmlString + '       <ccAuthCode>TEST_DATA</ccAuthCode> ';
        xmlString = xmlString + '       <ccBatchId>TEST_DATA</ccBatchId> ';
        xmlString = xmlString + '       <initialFee>99.99</initialFee> ';
        xmlString = xmlString + '       <initialAdj>99.99</initialAdj> ';
        xmlString = xmlString + '       <initialDisc>99.99</initialDisc> ';
        xmlString = xmlString + '       <billingCr>99.99</billingCr> ';
        xmlString = xmlString + '       <billingDr>99.99</billingDr> ';
        xmlString = xmlString + '       <cashCr>99.99</cashCr> ';
        xmlString = xmlString + '       <cashDr>99.99</cashDr> ';
        xmlString = xmlString + '       <tuitionFlag>1</tuitionFlag> ';
        xmlString = xmlString + '       <voidFlag>1</voidFlag> ';
        xmlString = xmlString + '       <autoFlag>0</autoFlag> ';
        xmlString = xmlString + '       <ibFlag>1</ibFlag> ';
        xmlString = xmlString + '   </dkTransaction> ';
        xmlString = xmlString + '   <dkTransaction>';
        xmlString = xmlString + '       <transactionId>TEST_DATA</transactionId> ';
        xmlString = xmlString + '       <cdcModifiedOn>2008-06-04</cdcModifiedOn> ';
        xmlString = xmlString + '       <kbsEnrollmentId>TEST_DATA</kbsEnrollmentId> ';
        xmlString = xmlString + '       <relatedToDKTxnId>TEST_DATA</relatedToDKTxnId> ';
        xmlString = xmlString + '       <receiptNumber>TEST_DATA</receiptNumber> ';
        xmlString = xmlString + '       <journalNumber>TEST_DATA</journalNumber> ';
        xmlString = xmlString + '       <entryDate>2008-06-04</entryDate> ';
        xmlString = xmlString + '       <jnlPostedDate>2008-06-04</jnlPostedDate> ';
        xmlString = xmlString + '       <jnlEomDate>2008-06-04</jnlEomDate> ';
        xmlString = xmlString + '       <txnCode>TEST_DATA</txnCode> ';
        xmlString = xmlString + '       <txnType>TEST_DATA</txnType> ';
        xmlString = xmlString + '       <status>TEST_DATA</status> ';
        xmlString = xmlString + '       <discountCode>TEST_DATA</discountCode> ';
        xmlString = xmlString + '       <bundleDiscountCode>TEST_DATA</bundleDiscountCode> ';
        xmlString = xmlString + '       <ccCkType>TEST_DATA</ccCkType> ';
        xmlString = xmlString + '       <ccCkNumber>TEST_DATA</ccCkNumber> ';
        xmlString = xmlString + '       <ccAuthCode>TEST_DATA</ccAuthCode> ';
        xmlString = xmlString + '       <ccBatchId>TEST_DATA</ccBatchId> ';
        xmlString = xmlString + '       <initialFee>99.99</initialFee> ';
        xmlString = xmlString + '       <initialAdj>99.99</initialAdj> ';
        xmlString = xmlString + '       <initialDisc>99.99</initialDisc> ';
        xmlString = xmlString + '       <billingCr>99.99</billingCr> ';
        xmlString = xmlString + '       <billingDr>99.99</billingDr> ';
        xmlString = xmlString + '       <cashCr>99.99</cashCr> ';
        xmlString = xmlString + '       <cashDr>99.99</cashDr> ';
        xmlString = xmlString + '       <tuitionFlag>1</tuitionFlag> ';
        xmlString = xmlString + '       <voidFlag>1</voidFlag> ';
        xmlString = xmlString + '       <autoFlag>0</autoFlag> ';
        xmlString = xmlString + '       <ibFlag>1</ibFlag> ';
        xmlString = xmlString + '   </dkTransaction> ';
        xmlString = xmlString + '</dkTransactions> ';
        
        listTransactions.add(xmlString);
        return xmlString;
    }
    
    
    public static String getTestShipOrders() {
        String xmlString;
        List<String> listShipOrders = new List<String>();
        
        xmlString = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?> ';
        xmlString = xmlString + '<shipOrders> ';
        xmlString = xmlString + '   <shipOrder> ';
        xmlString = xmlString + '       <kbsShipmentId>TEST_DATA</kbsShipmentId> ';
        xmlString = xmlString + '       <sourceSystem>TEST_DATA</sourceSystem> ';
        xmlString = xmlString + '       <createdOn>2008-06-04</createdOn> ';
        xmlString = xmlString + '       <modifiedOn>2008-06-04</modifiedOn> ';
        xmlString = xmlString + '       <kbsEnrollmentId>TEST_DATA</kbsEnrollmentId> ';
        xmlString = xmlString + '       <Line1>TEST_DATA</Line1> ';
        xmlString = xmlString + '       <Line2>TEST_DATA</Line2> ';
        xmlString = xmlString + '       <City>TEST_DATA</City> ';
        xmlString = xmlString + '       <Country>TEST_DATA</Country> ';
        xmlString = xmlString + '       <State>TEST_DATA</State> ';
        xmlString = xmlString + '       <zip>TEST_DATA</zip> ';
        xmlString = xmlString + '       <trackingNumber>TEST_DATA</trackingNumber> ';
        xmlString = xmlString + '       <shipDate>2008-06-04</shipDate> ';
        xmlString = xmlString + '       <status>TEST_DATA</status> ';
        xmlString = xmlString + '       <sendDate>2008-06-04</sendDate> ';
        xmlString = xmlString + '       <responseDate>2008-06-04</responseDate> ';
        xmlString = xmlString + '       <queuedDate>2008-06-04</queuedDate> ';
        xmlString = xmlString + '       <batchFileName>TEST_DATA</batchFileName> ';
        xmlString = xmlString + '       <shippingMethod>TEST_DATA</shippingMethod> ';
        xmlString = xmlString + '       <shippingCharge>99.99</shippingCharge> ';
        xmlString = xmlString + '       <warehouseRecognition>TEST_DATA</warehouseRecognition> ';
        xmlString = xmlString + '       <carrierCode>TEST_DATA</carrierCode> ';
        xmlString = xmlString + '       <overrideComment>TEST_DATA</overrideComment> ';
        xmlString = xmlString + '       <isShipNowFlag>true</isShipNowFlag> ';
        xmlString = xmlString + '       <emailSentFlag>false</emailSentFlag> ';
        xmlString = xmlString + '       <secondShipmentFlag>true</secondShipmentFlag> ';
        xmlString = xmlString + '   </shipOrder> ';
        xmlString = xmlString + '   <shipOrder> ';
        xmlString = xmlString + '       <kbsShipmentId>TEST_DATA</kbsShipmentId> ';
        xmlString = xmlString + '       <sourceSystem>TEST_DATA</sourceSystem> ';
        xmlString = xmlString + '       <createdOn>2008-06-04</createdOn> ';
        xmlString = xmlString + '       <modifiedOn>2008-06-04</modifiedOn> ';
        xmlString = xmlString + '       <kbsEnrollmentId>TEST_DATA</kbsEnrollmentId> ';
        xmlString = xmlString + '       <Line1>TEST_DATA</Line1> ';
        xmlString = xmlString + '       <Line2>TEST_DATA</Line2> ';
        xmlString = xmlString + '       <City>TEST_DATA</City> ';
        xmlString = xmlString + '       <Country>TEST_DATA</Country> ';
        xmlString = xmlString + '       <State>TEST_DATA</State> ';
        xmlString = xmlString + '       <zip>TEST_DATA</zip> ';
        xmlString = xmlString + '       <trackingNumber>TEST_DATA</trackingNumber> ';
        xmlString = xmlString + '       <shipDate>2008-06-04</shipDate> ';
        xmlString = xmlString + '       <status>TEST_DATA</status> ';
        xmlString = xmlString + '       <sendDate>2008-06-04</sendDate> ';
        xmlString = xmlString + '       <responseDate>2008-06-04</responseDate> ';
        xmlString = xmlString + '       <queuedDate>2008-06-04</queuedDate> ';
        xmlString = xmlString + '       <batchFileName>TEST_DATA</batchFileName> ';
        xmlString = xmlString + '       <shippingMethod>TEST_DATA</shippingMethod> ';
        xmlString = xmlString + '       <shippingCharge>99.99</shippingCharge> ';
        xmlString = xmlString + '       <warehouseRecognition>TEST_DATA</warehouseRecognition> ';
        xmlString = xmlString + '       <carrierCode>TEST_DATA</carrierCode> ';
        xmlString = xmlString + '       <overrideComment>TEST_DATA</overrideComment> ';
        xmlString = xmlString + '       <isShipNowFlag>false</isShipNowFlag> ';
        xmlString = xmlString + '       <emailSentFlag>true</emailSentFlag> ';
        xmlString = xmlString + '       <secondShipmentFlag>false</secondShipmentFlag> ';
        xmlString = xmlString + '   </shipOrder> ';
        xmlString = xmlString + '</shipOrders> ';
        
        listShipOrders.add(xmlString);
        return xmlString;
    }
}