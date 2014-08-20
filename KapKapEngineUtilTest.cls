/******************************************************************************
** Module Name   : KapKapEngineUtilTest
** Description   : 
** 
** Technial Info : <Classes, Methods, etc>
** 
** Author(s)     : Chaitanya Katragadda() - Kaplan
** Revision History:-
** Version  Date    Author  Description of Action
** 1.0    04/26/2011       Initiated Script
******************************************************************************/

@isTest
private class KapKapEngineUtilTest {

    static testMethod void testGetKapEngineURL() {
        String result = '';
        
        result = KapKapEngineUtil.getKapEngineURL('Enrollments', 'qObjectId');
        System.assertEquals('enrollment/qObjectId', result);
        
        result = KapKapEngineUtil.getKapEngineURL('Product Enrollments', 'qObjectId');
        System.assertEquals('productenrollment/qObjectId', result);
        
        result = KapKapEngineUtil.getKapEngineURL('Event Enrollments', 'qObjectId');
        System.assertEquals('eventenrollment/qObjectId', result);
        
        result = KapKapEngineUtil.getKapEngineURL('Class Enrollments', 'qObjectId');
        System.assertEquals('classenrollment/qObjectId', result);
        
        result = KapKapEngineUtil.getKapEngineURL('Transactions', 'qObjectId');
        System.assertEquals('dkTransactions/qObjectId', result);
        
        result = KapKapEngineUtil.getKapEngineURL('Ship Orders', 'qObjectId');
        System.assertEquals('shiporders/qObjectId', result);
        
    }
        
         
      /*  
    static testMethod void testProcessKapEngineResponse_Enrollment() {
    
        String xmlResponseMessage = '';
       
        xmlResponseMessage  = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>  ';
        xmlResponseMessage = xmlResponseMessage + '<enrollment> ';
        xmlResponseMessage = xmlResponseMessage + '   <channel>40</channel>  ';
        xmlResponseMessage = xmlResponseMessage + '   <createdOn>2005-05-26</createdOn>  ';
        xmlResponseMessage = xmlResponseMessage + '   <enrollType>product</enrollType>  ';
        xmlResponseMessage = xmlResponseMessage + '   <entryDate>2001-04-23</entryDate>  ';
        xmlResponseMessage = xmlResponseMessage + '   <firstName>Evelyn</firstName>  ';
        xmlResponseMessage = xmlResponseMessage + '   <kbsEnrollmentId>41258537</kbsEnrollmentId>  ';
        xmlResponseMessage = xmlResponseMessage + '   <kbsStudentId>41269861</kbsStudentId>  ';
        xmlResponseMessage = xmlResponseMessage + '   <lastName>Laboy</lastName>  ';
        xmlResponseMessage = xmlResponseMessage + '   <modifiedOn>2008-06-04</modifiedOn>  ';
        xmlResponseMessage = xmlResponseMessage + '</enrollment> ';
                
        List<SObject> kapEngRes = KapKapEngineUtil.processKapEngineResponse(xmlResponseMessage);
        System.assert(kapEngRes != null);
        
    }
    */
    static testMethod void testProcessKapEngineResponse_Enrollment() {
    	       
        String xmlResponseMessage = KapKapEngineUtil.getTestEnrollmentDetails('Enrollment');
        System.assert(xmlResponseMessage != null);
                
        List<SObject> kapEngRes = KapKapEngineUtil.processKapEngineResponse(xmlResponseMessage);
        System.assert(kapEngRes != null);        
    }
    
    
    
    static testMethod void testProcessKapEngineResponse_ProductEnrollment() {
    
        String xmlResponseMessage = '';

            xmlResponseMessage = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>  ';
            xmlResponseMessage = xmlResponseMessage + '<productEnrollment> ';
            xmlResponseMessage = xmlResponseMessage + '   <balanceDue>0</balanceDue>  ';
            xmlResponseMessage = xmlResponseMessage + '   <createdOn>2005-06-19</createdOn>  ';
            xmlResponseMessage = xmlResponseMessage + '   <expirationDate>2005-07-20</expirationDate>  ';
            xmlResponseMessage = xmlResponseMessage + '   <installmentBillingFlag>false</installmentBillingFlag>  ';
            xmlResponseMessage = xmlResponseMessage + '   <kbsEnrollmentId>56117690</kbsEnrollmentId>  ';
            xmlResponseMessage = xmlResponseMessage + '   <kbsProductId>727</kbsProductId>  ';
            xmlResponseMessage = xmlResponseMessage + '   <kbsProgramId>97</kbsProgramId>  ';
            xmlResponseMessage = xmlResponseMessage + '   <kbsStudentId>55920696</kbsStudentId>  ';
            xmlResponseMessage = xmlResponseMessage + '   <modifiedOn>2010-07-09</modifiedOn>  ';
            
            xmlResponseMessage = xmlResponseMessage + '   <productCode>USMLQB1A</productCode>  ';
            xmlResponseMessage = xmlResponseMessage + '   <revenueCenterCode>0068</revenueCenterCode>  ';
            xmlResponseMessage = xmlResponseMessage + '   <revenueKbsCenterId>392</revenueKbsCenterId>  ';
            xmlResponseMessage = xmlResponseMessage + '   <serviceStartDate>2005-06-19</serviceStartDate>  ';
            xmlResponseMessage = xmlResponseMessage + '   <startDate>2005-06-19</startDate>  ';
            xmlResponseMessage = xmlResponseMessage + '   <status>Alumnus</status>  ';
            xmlResponseMessage = xmlResponseMessage + '   <studyCenterCode>0068</studyCenterCode>  ';
            xmlResponseMessage = xmlResponseMessage + '   <studyKbsCenterId>392</studyKbsCenterId>  ';
            xmlResponseMessage = xmlResponseMessage + '   <sumBilling>179</sumBilling>  ';
            xmlResponseMessage = xmlResponseMessage + '   <sumPayment>179</sumPayment>  ';
            
            xmlResponseMessage = xmlResponseMessage + '   <enrollment> ';
            xmlResponseMessage = xmlResponseMessage + '       <channel>20</channel>  ';
            xmlResponseMessage = xmlResponseMessage + '       <createdOn>2005-06-19</createdOn>  ';
            xmlResponseMessage = xmlResponseMessage + '       <enrollType>product</enrollType>  ';
            xmlResponseMessage = xmlResponseMessage + '       <entryDate>2005-06-19</entryDate>  ';
            xmlResponseMessage = xmlResponseMessage + '       <firstName>Juan Carlos</firstName>  ';
            xmlResponseMessage = xmlResponseMessage + '       <kbsEnrollmentId>56117690</kbsEnrollmentId>  ';
            xmlResponseMessage = xmlResponseMessage + '       <kbsStudentId>55920696</kbsStudentId>  ';
            xmlResponseMessage = xmlResponseMessage + '       <lastName>Buitrago</lastName>  ';
            xmlResponseMessage = xmlResponseMessage + '       <modifiedOn>2005-07-20</modifiedOn>  ';
            xmlResponseMessage = xmlResponseMessage + '       <student> ';
            xmlResponseMessage = xmlResponseMessage + '           <centerCode>0068</centerCode>  ';
            xmlResponseMessage = xmlResponseMessage + '           <channel>20</channel>  ';
            xmlResponseMessage = xmlResponseMessage + '           <createdOn>2004-08-10</createdOn>  ';
            xmlResponseMessage = xmlResponseMessage + '           <doNotCallFlag>false</doNotCallFlag>  ';
            xmlResponseMessage = xmlResponseMessage + '           <doNotEmailFlag>false</doNotEmailFlag>  ';
            xmlResponseMessage = xmlResponseMessage + '           <doNotMailFlag>false</doNotMailFlag>  ';
            xmlResponseMessage = xmlResponseMessage + '           <doNotShareFlag>false</doNotShareFlag>  ';
            xmlResponseMessage = xmlResponseMessage + '           <email1>jcbuitrago@gmail.com</email1>  ';
            xmlResponseMessage = xmlResponseMessage + '           <entryDate>2004-08-10</entryDate>  ';
            xmlResponseMessage = xmlResponseMessage + '           <firstName>Juan Carlos</firstName>  ';
            xmlResponseMessage = xmlResponseMessage + '           <hotFlag>false</hotFlag>  ';
            xmlResponseMessage = xmlResponseMessage + '           <kbsCenterId>392</kbsCenterId>  ';
            xmlResponseMessage = xmlResponseMessage + '           <kbsStudentId>55920696</kbsStudentId>  ';
            xmlResponseMessage = xmlResponseMessage + '           <kbsSystemId>1000275195</kbsSystemId>  ';
            xmlResponseMessage = xmlResponseMessage + '           <lastName>Buitrago</lastName>  ';
            xmlResponseMessage = xmlResponseMessage + '           <leadSourceId>4</leadSourceId>  ';
            xmlResponseMessage = xmlResponseMessage + '           <leadSourceName>Career Center/Planning Office</leadSourceName>  ';
            xmlResponseMessage = xmlResponseMessage + '           <natDoNotCallFlag>false</natDoNotCallFlag>  ';
            xmlResponseMessage = xmlResponseMessage + '           <phone1>8095419698</phone1>  ';
            xmlResponseMessage = xmlResponseMessage + '           <phone1Type>Home</phone1Type>  ';
            
            xmlResponseMessage = xmlResponseMessage + '           <primaryAddress> ';
            xmlResponseMessage = xmlResponseMessage + '               <address1>C/ Fernando Escobar Hurtado No. 23</address1>  ';
            xmlResponseMessage = xmlResponseMessage + '               <address2>Apto. 3 2Do Piso, Piantini</address2>  ';
            xmlResponseMessage = xmlResponseMessage + '               <city>Santo Domingo</city>  ';
            xmlResponseMessage = xmlResponseMessage + '               <stateProvince>DN</stateProvince>  ';
            xmlResponseMessage = xmlResponseMessage + '               <country>Dominican Republic</country>  ';
            xmlResponseMessage = xmlResponseMessage + '           </primaryAddress> ';
            xmlResponseMessage = xmlResponseMessage + '           <status>Unassigned</status>  ';
            xmlResponseMessage = xmlResponseMessage + '           <upperFirstName>JUAN CARLOS</upperFirstName>  ';
            xmlResponseMessage = xmlResponseMessage + '           <upperLastName>BUITRAGO</upperLastName>  ';
            xmlResponseMessage = xmlResponseMessage + '       </student> ';
            xmlResponseMessage = xmlResponseMessage + '   </enrollment> ';
            xmlResponseMessage = xmlResponseMessage + '</productEnrollment> ';
    
            List<SObject> kapEngRes = KapKapEngineUtil.processKapEngineResponse(xmlResponseMessage);
            System.assert(kapEngRes != null);        
    }
    
    static testMethod void testProcessKapEngineResponse_ClassEnrollment() {
    
        String xmlResponseMessage = '';
       
         xmlResponseMessage  = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>  ';
         xmlResponseMessage = xmlResponseMessage + '<classEnrollment> ';
            xmlResponseMessage = xmlResponseMessage + '   <classCode>MCTO5014A</classCode>  ';
            xmlResponseMessage = xmlResponseMessage + '   <createdOn>2005-05-25</createdOn>  ';
            xmlResponseMessage = xmlResponseMessage + '   <kbsClassId>1000544186</kbsClassId>  ';
            xmlResponseMessage = xmlResponseMessage + '   <kbsEnrollmentId>41793834</kbsEnrollmentId>  ';
            xmlResponseMessage = xmlResponseMessage + '   <kbsStudentId>41790128</kbsStudentId>  ';
            xmlResponseMessage = xmlResponseMessage + '   <modifiedOn>2009-10-22</modifiedOn>  ';
            xmlResponseMessage = xmlResponseMessage + '   <productEnrollment> ';
            xmlResponseMessage = xmlResponseMessage + '       <balanceDue>0</balanceDue>  ';
            xmlResponseMessage = xmlResponseMessage + '       <createdOn>2005-05-25</createdOn>  ';
            xmlResponseMessage = xmlResponseMessage + '       <expirationDate>2005-08-20</expirationDate>  ';
            xmlResponseMessage = xmlResponseMessage + '       <installmentBillingFlag>false</installmentBillingFlag>  ';
            xmlResponseMessage = xmlResponseMessage + '       <kbsEnrollmentId>41793834</kbsEnrollmentId>  ';
            xmlResponseMessage = xmlResponseMessage + '       <kbsProductId>33</kbsProductId>  ';
            xmlResponseMessage = xmlResponseMessage + '       <kbsProgramId>9</kbsProgramId>  ';
            xmlResponseMessage = xmlResponseMessage + '       <kbsStudentId>41790128</kbsStudentId>  ';
            xmlResponseMessage = xmlResponseMessage + '       <modifiedOn>2010-08-30</modifiedOn>  ';
            xmlResponseMessage = xmlResponseMessage + '       <productCode>MCAT</productCode>  ';
            xmlResponseMessage = xmlResponseMessage + '       <revenueCenterCode>0226</revenueCenterCode>  ';
            xmlResponseMessage = xmlResponseMessage + '       <revenueKbsCenterId>157</revenueKbsCenterId>  ';
            xmlResponseMessage = xmlResponseMessage + '       <serviceStartDate>2005-05-25</serviceStartDate>  ';
            xmlResponseMessage = xmlResponseMessage + '       <startDate>2005-06-05</startDate>  ';
            xmlResponseMessage = xmlResponseMessage + '       <status>Alumnus</status>  ';
            xmlResponseMessage = xmlResponseMessage + '       <studyCenterCode>0226</studyCenterCode>  ';
            xmlResponseMessage = xmlResponseMessage + '       <studyKbsCenterId>157</studyKbsCenterId>  ';
            xmlResponseMessage = xmlResponseMessage + '       <sumBilling>212</sumBilling>  ';
            xmlResponseMessage = xmlResponseMessage + '       <sumPayment>212</sumPayment>  ';
            xmlResponseMessage = xmlResponseMessage + '       <enrollment> ';
            xmlResponseMessage = xmlResponseMessage + '           <channel>40</channel>  ';
            xmlResponseMessage = xmlResponseMessage + '           <createdOn>2005-05-25</createdOn>  ';
            xmlResponseMessage = xmlResponseMessage + '           <enrollType>product</enrollType>  ';
            xmlResponseMessage = xmlResponseMessage + '           <entryDate>2005-05-25</entryDate>  ';
            xmlResponseMessage = xmlResponseMessage + '           <firstName>Amber</firstName>  ';
            xmlResponseMessage = xmlResponseMessage + '           <kbsEnrollmentId>41793834</kbsEnrollmentId>  ';
            xmlResponseMessage = xmlResponseMessage + '           <kbsStudentId>41790128</kbsStudentId>  ';
            xmlResponseMessage = xmlResponseMessage + '           <lastName>Liu</lastName>  ';
            xmlResponseMessage = xmlResponseMessage + '           <modifiedOn>2005-08-20</modifiedOn>  ';
            xmlResponseMessage = xmlResponseMessage + '           <student> ';
            xmlResponseMessage = xmlResponseMessage + '               <centerCode>0226</centerCode>  ';
            xmlResponseMessage = xmlResponseMessage + '               <channel>10</channel>  ';
            xmlResponseMessage = xmlResponseMessage + '               <createdOn>2004-06-08</createdOn>  ';
            xmlResponseMessage = xmlResponseMessage + '               <doNotCallFlag>false</doNotCallFlag>  ';
            xmlResponseMessage = xmlResponseMessage + '               <doNotEmailFlag>false</doNotEmailFlag>  ';
            xmlResponseMessage = xmlResponseMessage + '               <doNotMailFlag>false</doNotMailFlag>  ';
            xmlResponseMessage = xmlResponseMessage + '               <doNotShareFlag>false</doNotShareFlag>  ';
            xmlResponseMessage = xmlResponseMessage + '               <email1>amber.liu@utoronto.ca</email1>  ';
            xmlResponseMessage = xmlResponseMessage + '               <entryDate>2004-06-08</entryDate>  ';
            xmlResponseMessage = xmlResponseMessage + '               <firstName>Amber</firstName>  ';
            xmlResponseMessage = xmlResponseMessage + '               <hotFlag>false</hotFlag>  ';
            xmlResponseMessage = xmlResponseMessage + '               <kbsCenterId>157</kbsCenterId>  ';
            xmlResponseMessage = xmlResponseMessage + '               <kbsStudentId>41790128</kbsStudentId>  ';
            xmlResponseMessage = xmlResponseMessage + '               <kbsSystemId>41790128</kbsSystemId>  ';
            xmlResponseMessage = xmlResponseMessage + '               <lastName>Liu</lastName>  ';
            xmlResponseMessage = xmlResponseMessage + '               <leadSourceId>5</leadSourceId>  ';
            xmlResponseMessage = xmlResponseMessage + '               <leadSourceName>Career/Grad Fair   On Campus</leadSourceName>  ';
            xmlResponseMessage = xmlResponseMessage + '               <natDoNotCallFlag>false</natDoNotCallFlag>  ';
            xmlResponseMessage = xmlResponseMessage + '               <phone1>9057639346</phone1>  ';
            xmlResponseMessage = xmlResponseMessage + '               <primaryAddress> ';
            xmlResponseMessage = xmlResponseMessage + '                   <address1>150 Rideau Drive</address1>  ';
            xmlResponseMessage = xmlResponseMessage + '                   <city>Richmond Hill</city>  ';
            xmlResponseMessage = xmlResponseMessage + '                   <stateProvince>ON</stateProvince>  ';
            xmlResponseMessage = xmlResponseMessage + '                   <postalCode>L4B4J1</postalCode>  ';
            xmlResponseMessage = xmlResponseMessage + '                   <country>Canada</country>  ';
            xmlResponseMessage = xmlResponseMessage + '               </primaryAddress> ';
            xmlResponseMessage = xmlResponseMessage + '               <status>Upsell Unassigned</status>  ';
            xmlResponseMessage = xmlResponseMessage + '               <upperFirstName>AMBER</upperFirstName>  ';
            xmlResponseMessage = xmlResponseMessage + '               <upperLastName>LIU</upperLastName>  ';
            xmlResponseMessage = xmlResponseMessage + '           </student> ';
            xmlResponseMessage = xmlResponseMessage + '       </enrollment> ';
            xmlResponseMessage = xmlResponseMessage + '   </productEnrollment> ';
            xmlResponseMessage = xmlResponseMessage + '</classEnrollment> ';
                
            List<SObject> kapEngRes = KapKapEngineUtil.processKapEngineResponse(xmlResponseMessage);
            System.assert(kapEngRes != null);
        
    }
    
    
    static testMethod void testProcessKapEngineResponse_EventEnrollment() {
    
        String xmlResponseMessage = '';
       
            xmlResponseMessage = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>  ';
            xmlResponseMessage = xmlResponseMessage + '<eventEnrollment> ';
            xmlResponseMessage = xmlResponseMessage + '   <centerCode>0221</centerCode>  ';
            xmlResponseMessage = xmlResponseMessage + '   <createdOn>2004-03-11</createdOn>  ';
            xmlResponseMessage = xmlResponseMessage + '   <eventCode>LKOT4001</eventCode>  ';
            xmlResponseMessage = xmlResponseMessage + '   <eventType>other marketing</eventType>  ';
            xmlResponseMessage = xmlResponseMessage + '   <expirationDate>2004-03-11</expirationDate>  ';
            xmlResponseMessage = xmlResponseMessage + '   <kbsCenterId>185</kbsCenterId>  ';
            xmlResponseMessage = xmlResponseMessage + '   <kbsEnrollmentId>41513897</kbsEnrollmentId>  ';
            xmlResponseMessage = xmlResponseMessage + '   <kbsEventId>1000032899</kbsEventId>  ';
            xmlResponseMessage = xmlResponseMessage + '   <kbsStudentId>41519867</kbsStudentId>  ';
            xmlResponseMessage = xmlResponseMessage + '   <modifiedOn>2006-12-07</modifiedOn>  ';
            xmlResponseMessage = xmlResponseMessage + '   <startDate>2004-03-11</startDate>  ';
            xmlResponseMessage = xmlResponseMessage + '   <status>Enrolled</status>  ';
            xmlResponseMessage = xmlResponseMessage + '   <enrollment> ';
            xmlResponseMessage = xmlResponseMessage + '       <channel>40</channel>  ';
            xmlResponseMessage = xmlResponseMessage + '       <createdOn>2004-03-10</createdOn>  ';
            xmlResponseMessage = xmlResponseMessage + '       <enrollType>event</enrollType>  ';
            xmlResponseMessage = xmlResponseMessage + '       <entryDate>2004-03-10</entryDate>  ';
            xmlResponseMessage = xmlResponseMessage + '       <firstName>Pam</firstName>  ';
            xmlResponseMessage = xmlResponseMessage + '       <kbsEnrollmentId>41513897</kbsEnrollmentId>  ';
            xmlResponseMessage = xmlResponseMessage + '       <kbsStudentId>41519867</kbsStudentId>  ';
            xmlResponseMessage = xmlResponseMessage + '       <lastName>Hrick</lastName>  ';
            xmlResponseMessage = xmlResponseMessage + '       <modifiedOn>2006-12-07</modifiedOn>  ';
            xmlResponseMessage = xmlResponseMessage + '       <student> ';
            xmlResponseMessage = xmlResponseMessage + '           <centerCode>0221</centerCode>  ';
            xmlResponseMessage = xmlResponseMessage + '           <channel>40</channel>  ';
            xmlResponseMessage = xmlResponseMessage + '           <createdOn>2004-03-10</createdOn>  ';
            xmlResponseMessage = xmlResponseMessage + '           <doNotCallFlag>false</doNotCallFlag>  ';
            xmlResponseMessage = xmlResponseMessage + '           <doNotEmailFlag>false</doNotEmailFlag>  ';
            xmlResponseMessage = xmlResponseMessage + '           <doNotMailFlag>false</doNotMailFlag>  ';
            xmlResponseMessage = xmlResponseMessage + '           <doNotShareFlag>false</doNotShareFlag>  ';
            xmlResponseMessage = xmlResponseMessage + '           <email1>pric015@uottawa.ca</email1>  ';
            xmlResponseMessage = xmlResponseMessage + '           <entryDate>2004-03-10</entryDate>  ';
            xmlResponseMessage = xmlResponseMessage + '           <firstName>Pam</firstName>  ';
            xmlResponseMessage = xmlResponseMessage + '           <hotFlag>false</hotFlag>  ';
            xmlResponseMessage = xmlResponseMessage + '           <kbsCenterId>185</kbsCenterId>  ';
            xmlResponseMessage = xmlResponseMessage + '           <kbsStudentId>41519867</kbsStudentId>  ';
            xmlResponseMessage = xmlResponseMessage + '           <kbsSystemId>41519867</kbsSystemId>  ';
            xmlResponseMessage = xmlResponseMessage + '           <lastName>Hrick</lastName>  ';
            xmlResponseMessage = xmlResponseMessage + '           <leadSourceId>54</leadSourceId>  ';
            xmlResponseMessage = xmlResponseMessage + '           <leadSourceName>Word of Mouth</leadSourceName>  ';
            xmlResponseMessage = xmlResponseMessage + '           <natDoNotCallFlag>false</natDoNotCallFlag>  ';
            xmlResponseMessage = xmlResponseMessage + '           <phone1>6137450218</phone1>  ';
            xmlResponseMessage = xmlResponseMessage + '           <phone1Type>Home</phone1Type>  ';
            xmlResponseMessage = xmlResponseMessage + '           <primaryAddress> ';
            xmlResponseMessage = xmlResponseMessage + '               <address1>665 Bathgate Drive</address1>  ';
            xmlResponseMessage = xmlResponseMessage + '               <address2>Apt 1112</address2>  ';
            xmlResponseMessage = xmlResponseMessage + '               <city>Ottawa</city>  ';
            xmlResponseMessage = xmlResponseMessage + '               <stateProvince>ON</stateProvince>  ';
            xmlResponseMessage = xmlResponseMessage + '               <postalCode>K1K3Y4</postalCode>  ';
            xmlResponseMessage = xmlResponseMessage + '               <country>Canada</country>  ';
            xmlResponseMessage = xmlResponseMessage + '           </primaryAddress> ';
            xmlResponseMessage = xmlResponseMessage + '           <status>Unassigned</status>  ';
            xmlResponseMessage = xmlResponseMessage + '           <upperFirstName>PAM</upperFirstName>  ';
            xmlResponseMessage = xmlResponseMessage + '           <upperLastName>HRICK</upperLastName>  ';
            xmlResponseMessage = xmlResponseMessage + '       </student> ';
            xmlResponseMessage = xmlResponseMessage + '   </enrollment> ';
            xmlResponseMessage = xmlResponseMessage + '</eventEnrollment> ';
                
        List<SObject> kapEngRes = KapKapEngineUtil.processKapEngineResponse(xmlResponseMessage);
        System.assert(kapEngRes != null);
        
    }
    
          
    static testMethod void testProcessKapEngineResponse_TestTranscations() {
    
        String xmlResponseMessage = '';
        
        xmlResponseMessage = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?> ';
        xmlResponseMessage = xmlResponseMessage + '<dkTransactions> ';
       /* xmlResponseMessage = xmlResponseMessage + '   <dkTransaction>';
        xmlResponseMessage = xmlResponseMessage + '     <dkTransactionId>TEST_DATA</dkTransactionId> ';
        xmlResponseMessage = xmlResponseMessage + '     <cdcModifiedOn>2008-06-04</cdcModifiedOn> ';
        xmlResponseMessage = xmlResponseMessage + '     <kbsEnrollmentId>TEST_DATA</kbsEnrollmentId> ';
        xmlResponseMessage= xmlResponseMessage + '     <relatedToDKTxnId>TEST_DATA</relatedToDKTxnId> ';
        xmlResponseMessage = xmlResponseMessage + '     <receiptNumber>TEST_DATA</receiptNumber> ';
        xmlResponseMessage = xmlResponseMessage + '     <journalNumber>TEST_DATA</journalNumber> ';
        xmlResponseMessage = xmlResponseMessage + '     <entryDate>2008-06-04</entryDate> ';
        xmlResponseMessage= xmlResponseMessage + '     <jnlPostedDate>2008-06-04</jnlPostedDate> ';
        xmlResponseMessage = xmlResponseMessage + '     <jnlEomDate>2008-06-04</jnlEomDate> ';
        xmlResponseMessage = xmlResponseMessage + '     <txnCode>TEST_DATA</txnCode> ';
        xmlResponseMessage = xmlResponseMessage + '     <txnType>TEST_DATA</txnType> ';
        xmlResponseMessage= xmlResponseMessage + '     <status>TEST_DATA</status> ';
        xmlResponseMessage = xmlResponseMessage + '     <discountCode>TEST_DATA</discountCode> ';
        xmlResponseMessage = xmlResponseMessage + '     <bundleDiscountCode>TEST_DATA</bundleDiscountCode> ';
        xmlResponseMessage = xmlResponseMessage + '     <ccCkType>TEST_DATA</ccCkType> ';
        xmlResponseMessage = xmlResponseMessage + '     <ccCkNumber>TEST_DATA</ccCkNumber> ';
        xmlResponseMessage = xmlResponseMessage + '     <ccAuthCode>TEST_DATA</ccAuthCode> ';
        xmlResponseMessage = xmlResponseMessage+ '     <ccBatchId>TEST_DATA</ccBatchId> ';
        xmlResponseMessage = xmlResponseMessage + '     <initialFee>99.99</initialFee> ';
        xmlResponseMessage = xmlResponseMessage + '     <initialAdj>99.99</initialAdj> ';
        xmlResponseMessage = xmlResponseMessage + '     <initialDisc>99.99</initialDisc> ';
        xmlResponseMessage = xmlResponseMessage + '     <billingCr>99.99</billingCr> ';
        xmlResponseMessage = xmlResponseMessage + '     <billingDr>99.99</billingDr> ';
        xmlResponseMessage = xmlResponseMessage + '     <cashCr>99.99</cashCr> ';
        xmlResponseMessage = xmlResponseMessage + '     <cashDr>99.99</cashDr> ';
        xmlResponseMessage = xmlResponseMessage + '     <tuitionFlag>1</tuitionFlag> ';
        xmlResponseMessage = xmlResponseMessage + '     <voidFlag>1</voidFlag> ';
        xmlResponseMessage = xmlResponseMessage + '     <autoFlag>0</autoFlag> ';
        xmlResponseMessage = xmlResponseMessage + '     <ibFlag>1</ibFlag> ';
        xmlResponseMessage = xmlResponseMessage + '  </dkTransaction> ';*/
        xmlResponseMessage = xmlResponseMessage + '   <dkTransaction>';
        xmlResponseMessage = xmlResponseMessage + '     <dkTransactionId>TEST_DATA</dkTransactionId> ';
        xmlResponseMessage = xmlResponseMessage + '     <cdcModifiedOn>2008-06-04</cdcModifiedOn> ';
        xmlResponseMessage = xmlResponseMessage + '     <kbsEnrollmentId>TEST_DATA</kbsEnrollmentId> ';
        xmlResponseMessage = xmlResponseMessage + '     <relatedToDKTxnId>TEST_DATA</relatedToDKTxnId> ';
        xmlResponseMessage = xmlResponseMessage + '     <receiptNumber>TEST_DATA</receiptNumber> ';
        xmlResponseMessage = xmlResponseMessage + '     <journalNumber>TEST_DATA</journalNumber> ';
        xmlResponseMessage = xmlResponseMessage + '     <entryDate>2008-06-04</entryDate> ';
        xmlResponseMessage = xmlResponseMessage + '     <jnlPostedDate>2008-06-04</jnlPostedDate> ';
        xmlResponseMessage = xmlResponseMessage + '     <jnlEomDate>2008-06-04</jnlEomDate> ';
        xmlResponseMessage = xmlResponseMessage + '     <txnCode>TEST_DATA</txnCode> ';
        xmlResponseMessage = xmlResponseMessage + '     <txnType>TEST_DATA</txnType> ';
        xmlResponseMessage = xmlResponseMessage + '     <status>TEST_DATA</status> ';
        xmlResponseMessage = xmlResponseMessage + '     <discountCode>TEST_DATA</discountCode> ';
        xmlResponseMessage = xmlResponseMessage + '     <bundleDiscountCode>TEST_DATA</bundleDiscountCode> ';
        xmlResponseMessage = xmlResponseMessage + '     <ccCkType>TEST_DATA</ccCkType> ';
        xmlResponseMessage = xmlResponseMessage + '     <ccCkNumber>TEST_DATA</ccCkNumber> ';
        xmlResponseMessage = xmlResponseMessage + '     <ccAuthCode>TEST_DATA</ccAuthCode> ';
        xmlResponseMessage = xmlResponseMessage + '     <ccBatchId>TEST_DATA</ccBatchId> ';
        xmlResponseMessage = xmlResponseMessage + '     <initialFee>99.99</initialFee> ';
        xmlResponseMessage = xmlResponseMessage + '     <initialAdj>99.99</initialAdj> ';
        xmlResponseMessage = xmlResponseMessage + '     <initialDisc>99.99</initialDisc> ';
        xmlResponseMessage = xmlResponseMessage + '     <billingCr>99.99</billingCr> ';
        xmlResponseMessage = xmlResponseMessage + '     <billingDr>99.99</billingDr> ';
        xmlResponseMessage = xmlResponseMessage + '     <cashCr>99.99</cashCr> ';
        xmlResponseMessage = xmlResponseMessage + '     <cashDr>99.99</cashDr> ';
        xmlResponseMessage = xmlResponseMessage + '     <tuitionFlag>1</tuitionFlag> ';
        xmlResponseMessage = xmlResponseMessage + '     <voidFlag>1</voidFlag> ';
        xmlResponseMessage = xmlResponseMessage + '     <autoFlag>0</autoFlag> ';
        xmlResponseMessage = xmlResponseMessage + '     <ibFlag>1</ibFlag> ';
        xmlResponseMessage = xmlResponseMessage + '  </dkTransaction> ';
        xmlResponseMessage = xmlResponseMessage + '</dkTransactions> ';
        
        List<SObject> kapEngRes = KapKapEngineUtil.processKapEngineResponse(xmlResponseMessage);
        System.assert(kapEngRes != null);  
    }
    
     static testMethod void testProcessKapEngineResponse_ShipOrders() {
    
        String xmlResponseMessage = '';
        
        xmlResponseMessage = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?> ';
        xmlResponseMessage = xmlResponseMessage + '<shipments> ';
        xmlResponseMessage = xmlResponseMessage + '  <shipment> ';
        xmlResponseMessage = xmlResponseMessage + '     <kbsShipmentId>TEST_DATA</kbsShipmentId> ';
        xmlResponseMessage = xmlResponseMessage + '     <sourceSystem>TEST_DATA</sourceSystem> ';
        xmlResponseMessage = xmlResponseMessage + '     <createdOn>2008-06-04</createdOn> ';
        xmlResponseMessage = xmlResponseMessage + '     <modifiedOn>2008-06-04</modifiedOn> ';
        xmlResponseMessage = xmlResponseMessage + '     <kbsEnrollmentId>TEST_DATA</kbsEnrollmentId> ';
        xmlResponseMessage = xmlResponseMessage + '     <line1>TEST_DATA</line1> ';
        xmlResponseMessage = xmlResponseMessage + '     <Line2>TEST_DATA</Line2> ';
        xmlResponseMessage = xmlResponseMessage + '     <city>TEST_DATA</city> ';
        xmlResponseMessage = xmlResponseMessage + '     <country>TEST_DATA</country> ';
        xmlResponseMessage = xmlResponseMessage + '     <state>TEST_DATA</state> ';
        xmlResponseMessage = xmlResponseMessage + '     <zip>TEST_DATA</zip> ';
        xmlResponseMessage = xmlResponseMessage + '     <trackingNumber>TEST_DATA</trackingNumber> ';
        xmlResponseMessage = xmlResponseMessage + '     <shipDate>2008-06-04</shipDate> ';
        xmlResponseMessage = xmlResponseMessage + '     <status>TEST_DATA</status> ';
        xmlResponseMessage = xmlResponseMessage + '     <sentDate>2008-06-04</sentDate> ';
        xmlResponseMessage = xmlResponseMessage + '     <responseDate>2008-06-04</responseDate> ';
        xmlResponseMessage = xmlResponseMessage + '     <queuedDate>2008-06-04</queuedDate> ';
        xmlResponseMessage = xmlResponseMessage + '     <batchfilename>TEST_DATA</batchfilename> ';
        xmlResponseMessage = xmlResponseMessage + '     <shippingMethod>TEST_DATA</shippingMethod> ';
        xmlResponseMessage = xmlResponseMessage + '     <shippingCharge>99.99</shippingCharge> ';
        xmlResponseMessage = xmlResponseMessage + '     <warehouseRecognition>TEST_DATA</warehouseRecognition> ';
        xmlResponseMessage = xmlResponseMessage + '     <carrierCode>TEST_DATA</carrierCode> ';
        xmlResponseMessage = xmlResponseMessage + '     <overrideComment>TEST_DATA</overrideComment> ';
        xmlResponseMessage = xmlResponseMessage + '     <shipNowFlag>true</shipNowFlag> ';
        xmlResponseMessage = xmlResponseMessage + '     <emailSentFlag>false</emailSentFlag> ';
        xmlResponseMessage = xmlResponseMessage + '     <secondShipmentFlag>true</secondShipmentFlag> ';
        xmlResponseMessage = xmlResponseMessage + '  </shipment> ';
        xmlResponseMessage = xmlResponseMessage + '  <shipment> ';
        xmlResponseMessage = xmlResponseMessage + '     <kbsShipmentId>TEST_DATA</kbsShipmentId> ';
        xmlResponseMessage = xmlResponseMessage + '     <sourceSystem>TEST_DATA</sourceSystem> ';
        xmlResponseMessage = xmlResponseMessage + '     <createdOn>2008-06-04</createdOn> ';
        xmlResponseMessage= xmlResponseMessage + '     <modifiedOn>2008-06-04</modifiedOn> ';
        xmlResponseMessage = xmlResponseMessage + '     <kbsEnrollmentId>TEST_DATA</kbsEnrollmentId> ';
        xmlResponseMessage = xmlResponseMessage + '     <line1>TEST_DATA</line1> ';
        xmlResponseMessage = xmlResponseMessage + '     <Line2>TEST_DATA</Line2> ';
        xmlResponseMessage = xmlResponseMessage + '     <city>TEST_DATA</city> ';
        xmlResponseMessage = xmlResponseMessage + '     <country>TEST_DATA</country> ';
        xmlResponseMessage = xmlResponseMessage + '     <state>TEST_DATA</state> ';
        xmlResponseMessage = xmlResponseMessage + '     <zip>TEST_DATA</zip> ';
        xmlResponseMessage = xmlResponseMessage + '     <trackingNumber>TEST_DATA</trackingNumber> ';
        xmlResponseMessage = xmlResponseMessage + '     <shipDate>2008-06-04</shipDate> ';
        xmlResponseMessage = xmlResponseMessage + '     <status>TEST_DATA</status> ';
        xmlResponseMessage = xmlResponseMessage + '     <sentDate>2008-06-04</sentDate> ';
        xmlResponseMessage = xmlResponseMessage + '     <responseDate>2008-06-04</responseDate> ';
        xmlResponseMessage = xmlResponseMessage + '     <queuedDate>2008-06-04</queuedDate> ';
        xmlResponseMessage = xmlResponseMessage + '     <batchfilename>TEST_DATA</batchfilename> ';
        xmlResponseMessage = xmlResponseMessage + '     <shippingMethod>TEST_DATA</shippingMethod> ';
        xmlResponseMessage = xmlResponseMessage + '     <shippingCharge>99.99</shippingCharge> ';
        xmlResponseMessage = xmlResponseMessage + '     <warehouseRecognition>TEST_DATA</warehouseRecognition> ';
        xmlResponseMessage = xmlResponseMessage + '     <carrierCode>TEST_DATA</carrierCode> ';
        xmlResponseMessage = xmlResponseMessage + '     <overrideComment>TEST_DATA</overrideComment> ';
        xmlResponseMessage = xmlResponseMessage + '     <shipNowFlag>false</shipNowFlag> ';
        xmlResponseMessage = xmlResponseMessage + '     <emailSentFlag>true</emailSentFlag> ';
        xmlResponseMessage = xmlResponseMessage + '     <secondShipmentFlag>false</secondShipmentFlag> ';
        xmlResponseMessage = xmlResponseMessage + '  </shipment> ';
        xmlResponseMessage = xmlResponseMessage + '</shipments> ';
        
         List<SObject> kapEngRes = KapKapEngineUtil.processKapEngineResponse(xmlResponseMessage);
        System.assert(kapEngRes != null);  
    }
    
    static testMethod void testgetTestEnrollmentDetails() {
    	String response = KapKapEngineUtil.getTestEnrollmentDetails('Enrollment');
        System.assert(response != null);		
    	
    	response = KapKapEngineUtil.getTestEnrollmentDetails('Class');
        System.assert(response != null);
        
        response = KapKapEngineUtil.getTestEnrollmentDetails('Product');
        System.assert(response != null);
        
        response = KapKapEngineUtil.getTestEnrollmentDetails('Event');
        System.assert(response != null);
    }
    
    static testMethod void testgetTestTransactions() {
    	String response = KapKapEngineUtil.getTestTransactions();
        System.assert(response != null);
    }
    
    static testMethod void testgetTestShipOrders() {
    	String response = KapKapEngineUtil.getTestShipOrders();
        System.assert(response != null);
    }
}