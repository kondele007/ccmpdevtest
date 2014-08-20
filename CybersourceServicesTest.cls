@isTest
private class CybersourceServicesTest
{
    public class MockPaymentBatchDetail implements HttpCalloutMock
    {
        public HttpResponse respond( HttpRequest request )
        {
            String responseBody = '<?xml version="1.0" encoding="utf-8"?>';
            responseBody += '<!DOCTYPE Report SYSTEM "https://ebc.cybersource.com/ebc/reports/dtd/pbdr_1_2.dtd">';
            responseBody += '<Report Name="Payment Batch Detail" Version="1.2" xmlns="https://ebc.cybersource.com/ebc/reports/dtd/pbdr_1_2.dtd" MerchantID="kaptest" ReportStartDate="2013-10-27T07:00:00-07:00" ReportEndDate="2013-10-28T07:00:00-07:00">';
                responseBody += '<Batches>';
                    responseBody += '<Batch BatchID="46532134321" BatchDate="2013-10-27">';
                        responseBody += '<Requests>';
                            responseBody += '<Request RequestID="45689654865321" MerchantReferenceNumber="32154321">';
                                responseBody += '<TransactionReferenceNumber>1111111</TransactionReferenceNumber>';
                                responseBody += '<TransactionId/>';
                                responseBody += '<PaymentMethod>American Express</PaymentMethod>';
                                responseBody += '<CurrencyCode>USD</CurrencyCode>';
                                responseBody += '<CustomerId/>';
                                responseBody += '<Amount>19.99</Amount>';
                                responseBody += '<Application>ics_bill</Application>';
                            responseBody += '</Request>';
                        responseBody += '</Requests>';
                    responseBody += '</Batch>';
                responseBody += '</Batches>';
            responseBody += '</Report>';

            HttpResponse newResponse = new HttpResponse();
            newResponse.setHeader( 'Content-Type', 'application/xml' );
            newResponse.setBody( responseBody );
            return newResponse;
        }
    }

    public class MockTransactionDetail implements HttpCalloutMock
    {
        public HttpResponse respond( HttpRequest request )
        {
            String responseBody = '<?xml version="1.0" encoding="utf-8"?>';
            responseBody += '<!DOCTYPE Report SYSTEM "https://ebc.cybersource.com/ebc/reports/dtd/pbdr_1_2.dtd">';
            responseBody += '<Report Name="Transaction Detail" Version="1.2" xmlns="https://ebc.cybersource.com/ebc/reports/dtd/tdr_1_12.dtd" MerchantID="kaptest" ReportStartDate="2013-10-27T07:00:00-07:00" ReportEndDate="2013-10-28T07:00:00-07:00">';
                responseBody += '<Requests>';
                    responseBody += '<Request RequestID="64654654654" RequestDate="2013-10-27T04:27:01-04:00" MerchantReferenceNumber="123654" Source="HOP" User="HOP" SubscriptionID="3828480216690178147361" TransactionReferenceNumber="789456123" eCommerceIndicator="7">';
                        responseBody += '<BillTo>';
                            responseBody += '<FirstName>Test</FirstName>';
                            responseBody += '<LastName>Testerson</LastName>';
                            responseBody += '<Address1>123 Fake St.</Address1>';
                            responseBody += '<City>San Marino</City>';
                            responseBody += '<State>CA</State>';
                            responseBody += '<Zip>91108</Zip>';
                            responseBody += '<Email>test@test.com.test</Email>';
                            responseBody += '<Country>US</Country>';
                            responseBody += '<Phone/>';
                        responseBody += '</BillTo>';
                        responseBody += '<ShipTo>';
                            responseBody += '<FirstName>Test</FirstName>';
                            responseBody += '<LastName>Testerson</LastName>';
                            responseBody += '<Address1>234 Fake St.</Address1>';
                            responseBody += '<City>San Marino</City>';
                            responseBody += '<State>CA</State>';
                            responseBody += '<Zip>91108</Zip>';
                            responseBody += '<Country>US</Country>';
                        responseBody += '</ShipTo>';
                        responseBody += '<PaymentMethod>';
                            responseBody += '<Card>';
                                responseBody += '<AccountSuffix>1111</AccountSuffix>';
                                responseBody += '<ExpirationMonth>2</ExpirationMonth>';
                                responseBody += '<ExpirationYear>1999</ExpirationYear>';
                                responseBody += '<CardType>Visa</CardType>';
                            responseBody += '</Card>';
                        responseBody += '</PaymentMethod>';
                        responseBody += '<LineItems>';
                            responseBody += '<LineItem Number="0">';
                                responseBody += '<FulfillmentType>P</FulfillmentType>';
                                responseBody += '<Quantity>1</Quantity>';
                                responseBody += '<UnitPrice>199.00</UnitPrice>';
                                responseBody += '<TaxAmount>0.00</TaxAmount>';
                                responseBody += '<ProductCode>default</ProductCode>';
                            responseBody += '</LineItem>';
                        responseBody += '</LineItems>';
                        responseBody += '<ApplicationReplies>';
                            responseBody += '<ApplicationReply Name="ics_bill">';
                                responseBody += '<RCode>1</RCode>';
                                responseBody += '<RFlag>SOK</RFlag>';
                                responseBody += '<RMsg>Request was processed successfully.</RMsg>';
                            responseBody += '</ApplicationReply>';
                            responseBody += '<ApplicationReply Name="ics_auth">';
                                responseBody += '<RCode>1</RCode>';
                                responseBody += '<RFlag>SOK</RFlag>';
                                responseBody += '<RMsg>Request was processed successfully.</RMsg>';
                            responseBody += '</ApplicationReply>';
                            responseBody += '<ApplicationReply Name="ics_pay_subscription_create">';
                                responseBody += '<RCode>1</RCode>';
                                responseBody += '<RFlag>SOK</RFlag>';
                                responseBody += '<RMsg>Request was processed successfully.</RMsg>';
                            responseBody += '</ApplicationReply>';
                        responseBody += '</ApplicationReplies>';
                        responseBody += '<PaymentData>';
                            responseBody += '<PaymentRequestID>123456789123456789123</PaymentRequestID>';
                            responseBody += '<PaymentProcessor>smartfdc</PaymentProcessor>';
                            responseBody += '<Amount>199.00</Amount>';
                            responseBody += '<CurrencyCode>USD</CurrencyCode>';
                            responseBody += '<TotalTaxAmount>0.00</TotalTaxAmount>';
                            responseBody += '<AuthorizationType>O</AuthorizationType>';
                            responseBody += '<AuthorizationCode>01089D</AuthorizationCode>';
                            responseBody += '<AVSResult>YYY</AVSResult>';
                            responseBody += '<AVSResultMapped>Y</AVSResultMapped>';
                            responseBody += '<CVResult>M</CVResult>';
                            responseBody += '<ACHVerificationResult>A</ACHVerificationResult>';
                            responseBody += '<RequestedAmount>199.00</RequestedAmount>';
                            responseBody += '<RequestedAmountCurrencyCode>USD</RequestedAmountCurrencyCode>';
                            responseBody += '<BinNumber>654865</BinNumber>';
                        responseBody += '</PaymentData>';
                        responseBody += '<MerchantDefinedData></MerchantDefinedData>';
                    responseBody += '</Request>';
                responseBody += '</Requests>';
            responseBody += '</Report>';

            HttpResponse newResponse = new HttpResponse();
            newResponse.setHeader( 'Content-Type', 'application/xml' );
            newResponse.setBody( responseBody );
            return newResponse;
        }
    }

    static void setup()
    {
        CybersourceSettings__c newSettings = new CybersourceSettings__c();
        newSettings.Payment_Report_Endpoint__c = 'somepaymentendpoint';
        newSettings.Transaction_Report_Endpoint__c = 'anothertransactionendpoint';
        newSettings.Password__c = 'somepassword';
        System.runAs( TestUtils.ADMIN_USER )
        {
            insert newSettings;
        }
    }

    static testMethod void testPaymentBatchDetailReport()
    {
        setup();

        Test.startTest();

            Test.setMock( HttpCalloutMock.class, new MockPaymentBatchDetail() );
            CybersourceServices.calloutPaymentBatchDetailReport();

        Test.stopTest();

        List<CyberSource__c> createdPaymentBatchRecords = [ SELECT Id, Report_Batch_ID__c, Request_ID__c, Merchant_Reference_Number__c,
                                                                Transaction_Reference_Number__c, Payment_Method__c, Payment_Amount__c
                                                            FROM CyberSource__c ];
        System.assertEquals( 1, createdPaymentBatchRecords.size(), 'There should be one record created from the callout' );
        System.assertEquals( '46532134321', createdPaymentBatchRecords[0].Report_Batch_ID__c, 'The batch Id should be set on the record' );
        System.assertEquals( '45689654865321', createdPaymentBatchRecords[0].Request_ID__c, 'The request Id should be set on the record' );
        System.assertEquals( '32154321', createdPaymentBatchRecords[0].Merchant_Reference_Number__c, 'The merchant reference number should be set on the record' );
        System.assertEquals( '1111111', createdPaymentBatchRecords[0].Transaction_Reference_Number__c, 'The transaction reference number should be set on the record' );
        System.assertEquals( 'American Express', createdPaymentBatchRecords[0].Payment_Method__c, 'The payment method should be set on the record' );
        System.assertEquals( 19.99, createdPaymentBatchRecords[0].Payment_Amount__c, 'The payment amount should be set on the record' );
    }

    static testMethod void testTransactionDetailReport()
    {
        setup();

        Test.startTest();

            Test.setMock( HttpCalloutMock.class, new MockTransactionDetail() );
            CybersourceServices.calloutTransactionDetailReport();

        Test.stopTest();

        List<CyberSource__c> createdTransactionRecords = [ SELECT Id, Transaction_Reference_Number__c, Merchant_Reference_Number__c, Billing_Email__c,
                                                                Shipping_Address__c, Card_Account_Suffix__c, Line_Item_Fulfillment_Type__c,
                                                                Authorization_Application_Reply_Flag__c, Payment_Request_ID__c
                                                            FROM CyberSource__c ];
        System.assertEquals( 1, createdTransactionRecords.size(), 'There should be one record created from the callout' );
        System.assertEquals( '789456123', createdTransactionRecords[0].Transaction_Reference_Number__c, 'The reference id should be set on the record' );
        System.assertEquals( '123654', createdTransactionRecords[0].Merchant_Reference_Number__c, 'The reference id should be set on the record' );
        System.assertEquals( 'test@test.com.test', createdTransactionRecords[0].Billing_Email__c, 'The billing email should be set on the record' );
        System.assertEquals( '234 Fake St.', createdTransactionRecords[0].Shipping_Address__c, 'The shipping address should be set on the record' );
        System.assertEquals( '1111', createdTransactionRecords[0].Card_Account_Suffix__c, 'The card suffix should be set on the record' );
        System.assertEquals( 'P', createdTransactionRecords[0].Line_Item_Fulfillment_Type__c, 'The line item fulfillment type should be set on the record' );
        System.assertEquals( '1111', createdTransactionRecords[0].Card_Account_Suffix__c, 'The card suffix should be set on the record' );
        System.assertEquals( 'SOK', createdTransactionRecords[0].Authorization_Application_Reply_Flag__c, 'The ics bill code should be set on the record' );
        System.assertEquals( '123456789123456789123', createdTransactionRecords[0].Payment_Request_ID__c, 'The ics bill code should be set on the record' );
    }

    static testMethod void testScheduleCallouts()
    {
        final String CRON_EXP = '0 0 0 3 9 ? 2022';
        setup();

        String jobId = System.schedule('TestScheduleCybersourceCallout', CRON_EXP, new CybersourceScheduler());

        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals( CRON_EXP, ct.CronExpression );

        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));
    }

    static testMethod void testReparentPaymentBatch()
    {
        final Integer NUM_RECORDS = 15;

        RecordType paymentRecordType = [ SELECT Id FROM RecordType WHERE DeveloperName = 'CS_Payment' AND SObjectType = 'CyberSource__c' ];
        RecordType transactionRecordType = [ SELECT Id FROM RecordType WHERE DeveloperName = 'CS_Transaction' AND SObjectType = 'CyberSource__c' ];

        List<CyberSource__c> testCybersources = new List<CyberSource__c>();
        for( Integer index = 0; index < NUM_RECORDS; index++ )
        {
            CyberSource__c newPayment = new CyberSource__c();
            newPayment.RecordTypeId = paymentRecordType.Id;
            newPayment.Transaction_Reference_Number__c = '' + index;

            CyberSource__c newTransaction = newPayment.clone(false, false);
            newTransaction.RecordTypeId = transactionRecordType.Id;

            testCybersources.add( newPayment );
            testCybersources.add( newTransaction );
        }
        insert testCybersources;

        Test.startTest();

            Database.executeBatch( new CybersourceScheduler() );

        Test.stopTest();

        List<CyberSource__c> updatedPayments = [ SELECT Id, Transaction_Reference_Number__c, Transaction__r.Transaction_Reference_Number__c
                                                    FROM CyberSource__c WHERE RecordTypeId = :paymentRecordType.Id ];
        System.assertEquals( NUM_RECORDS, updatedPayments.size(), 'There should be as many payments as created' );
        for( CyberSource__c aPayment : updatedPayments )
        {
            System.assertEquals( aPayment.Transaction_Reference_Number__c, aPayment.Transaction__r.Transaction_Reference_Number__c, 'The payment should look up to a transaction with the same reference' );
        }
    }
}