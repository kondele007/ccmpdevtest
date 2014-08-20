public with sharing class CybersourceServices
{
    /**
    *   @throws - System.CalloutException, System.DmlException
    */
    public static void calloutPaymentBatchDetailReport()
    {
        calloutPaymentBatchDetailReport( System.now().addDays( -1 ) );
    }

    /**
    *   @throws - System.CalloutException, System.DmlException
    */
    @future(callout=true)
    public static void calloutPaymentBatchDetailReport( DateTime targetTime )
    {
        CybersourceSettings__c credentials = CybersourceSettings__c.getInstance();
        String endpoint = credentials.Payment_Report_Endpoint__c;
        endpoint = String.format( endpoint, new List<String>{ targetTime.format('yyyy/MM/dd'), credentials.Account_Name__c } );

        String userpass = credentials.Username__c + ':' + credentials.Password__c;
        String encodedAuthstring = EncodingUtil.base64Encode( Blob.valueOf( userpass ) );

        HttpRequest reportRequest = new HttpRequest();
        reportRequest.setEndpoint( endpoint );
        reportRequest.setMethod( 'GET' );
        reportRequest.setHeader( 'Authorization', 'BASIC ' + encodedAuthstring );

        Http sender = new Http();
        HttpResponse reportResponse = sender.send( reportRequest );

        Dom.Document responseDoc = new Dom.Document();
        try
        {
            responseDoc.load( reportResponse.getBody() );
        }
        catch( System.XmlException ex )
        {
            System.debug( ex );
            throw new CybersourceException( 'Response has unexpected XML format' );
        }
        Dom.XmlNode rootNode = responseDoc.getRootElement();
        final String PAYMENT_BATCH_NS = rootNode.getNamespace();
        Dom.XmlNode batchesNode = rootNode.getChildElement( 'Batches', PAYMENT_BATCH_NS );
        Dom.XmlNode batchNode = batchesNode.getChildElement( 'Batch', PAYMENT_BATCH_NS );
        if( batchNode == NULL )
        {
            throw new CybersourceException( 'Report does not have any content' );
        }
        Dom.XmlNode requestsNode = batchNode.getChildElement( 'Requests', PAYMENT_BATCH_NS );
        List<Dom.XmlNode> requestsChildNodes = requestsNode.getChildElements();

        Date batchDate = Date.valueOf( batchNode.getAttribute( 'BatchDate', null ) );

        RecordType paymentRecordType = [ SELECT Id FROM RecordType WHERE SObjectType = 'CyberSource__c' AND DeveloperName = 'CS_Payment' AND IsActive = TRUE LIMIT 1 ];
        List<CyberSource__c> recordsToCreate = new List<CyberSource__c>();
        Set<String> merchantIds = new Set<String>();
        for( Dom.XmlNode aNode : requestsChildNodes )
        {
            CyberSource__c newPaymentDetail = new CyberSource__c();
            newPaymentDetail.RecordTypeId = paymentRecordType.Id;
            newPaymentDetail.Report_Name__c = rootNode.getAttribute( 'Name', null );
            newPaymentDetail.Report_Version__c = rootNode.getAttribute( 'Version', null );
            newPaymentDetail.Report_Merchant_ID__c = rootNode.getAttribute( 'MerchantID', null );
            newPaymentDetail.Report_Start_Date__c = (DateTime)JSON.deserialize( '"' + rootNode.getAttribute( 'ReportStartDate', null ) + '"', DateTime.class );
            newPaymentDetail.Report_End_Date__c = (DateTime)JSON.deserialize( '"' + rootNode.getAttribute( 'ReportEndDate', null ) + '"', DateTime.class );
            newPaymentDetail.Report_Batch_Date__c = batchDate;
            newPaymentDetail.Report_Batch_ID__c = batchNode.getAttribute( 'BatchID', null );
            newPaymentDetail.Request_ID__c = aNode.getAttribute( 'RequestID', null );
            newPaymentDetail.Merchant_Reference_Number__c = aNode.getAttribute( 'MerchantReferenceNumber', null );
            newPaymentDetail.Transaction_Reference_Number__c = getTextOrNullFromChildElement( aNode, 'TransactionReferenceNumber', PAYMENT_BATCH_NS );
            newPaymentDetail.Transaction_ID__c = getTextOrNullFromChildElement( aNode, 'TransactionId', PAYMENT_BATCH_NS );
            newPaymentDetail.Payment_Method__c = getTextOrNullFromChildElement( aNode, 'PaymentMethod', PAYMENT_BATCH_NS );
            newPaymentDetail.Payment_Currency_Code__c = getTextOrNullFromChildElement( aNode, 'CurrencyCode', PAYMENT_BATCH_NS );
            newPaymentDetail.Customer_ID__c = getTextOrNullFromChildElement( aNode, 'CustomerId', PAYMENT_BATCH_NS );
            newPaymentDetail.Payment_Amount__c = Decimal.valueof( getTextOrNullFromChildElement( aNode, 'Amount', PAYMENT_BATCH_NS ) );
            newPaymentDetail.Application__c = getTextOrNullFromChildElement( aNode, 'Application', PAYMENT_BATCH_NS );
            newPaymentDetail.Unique_Id__c = newPaymentDetail.Request_ID__c + newPaymentDetail.RecordTypeId;
            recordsToCreate.add( newPaymentDetail );

            merchantIds.add( newPaymentDetail.Merchant_Reference_Number__c );
        }

        relateCybersourceDetailToCart( recordsToCreate, merchantIds );
        upsert recordsToCreate CyberSource__c.Unique_Id__c;
    }

    /**
    *   @throws - System.CalloutException, System.DmlException
    */
    public static void calloutTransactionDetailReport()
    {
        calloutTransactionDetailReport( System.now().addDays( -1 ) );
    }

    /**
    *   @throws - System.CalloutException, System.DmlException
    */
    @future(callout=true)
    public static void calloutTransactionDetailReport( DateTime targetTime )
    {
        CybersourceSettings__c credentials = CybersourceSettings__c.getInstance();
        String endpoint = credentials.Transaction_Report_Endpoint__c;
        endpoint = String.format( endpoint, new List<String>{ targetTime.format('yyyy/MM/dd'), credentials.Account_Name__c } );

        String userpass = credentials.Username__c + ':' + credentials.Password__c;
        String encodedAuthstring = EncodingUtil.base64Encode( Blob.valueOf( userpass ) );

        HttpRequest reportRequest = new HttpRequest();
        reportRequest.setEndpoint( endpoint );
        reportRequest.setMethod( 'GET' );
        reportRequest.setHeader( 'Authorization', 'BASIC ' + encodedAuthstring );

        Http sender = new Http();
        HttpResponse reportResponse = sender.send( reportRequest );
        Dom.Document responseDoc = new Dom.Document();
        try
        {
            responseDoc.load( reportResponse.getBody() );
        }
        catch( System.XmlException ex )
        {
            System.debug( ex );
            throw new CybersourceException( 'Response has unexpected XML format' );
        }
        Dom.XmlNode rootNode = responseDoc.getRootElement();
        final String TRANSACTION_DETAIL_NS = rootNode.getNamespace();
        Dom.XmlNode requestsNode = rootNode.getChildElement( 'Requests', TRANSACTION_DETAIL_NS );
        List<Dom.XmlNode> requestChildNodes = requestsNode.getChildElements();

        RecordType transactionRecordType = [ SELECT Id FROM RecordType WHERE SObjectType = 'CyberSource__c' AND DeveloperName = 'CS_Transaction' AND IsActive = TRUE LIMIT 1 ];
        List<CyberSource__c> recordsToCreate = new List<CyberSource__c>();
        Set<String> merchantIds = new Set<String>();
        for( Dom.XmlNode aNode : requestChildNodes )
        {
            CyberSource__c newTransactionDetail = new CyberSource__c();
            newTransactionDetail.RecordTypeId = transactionRecordType.Id;
            newTransactionDetail.Report_Name__c = rootNode.getAttribute( 'Name', null );
            newTransactionDetail.Report_Version__c = rootNode.getAttribute( 'Version', null );
            newTransactionDetail.Report_Start_Date__c = (DateTime)JSON.deserialize( '"' + rootNode.getAttribute( 'ReportStartDate', null ) + '"', DateTime.class );
            newTransactionDetail.Report_End_Date__c = (DateTime)JSON.deserialize( '"' + rootNode.getAttribute( 'ReportEndDate', null ) + '"', DateTime.class );

            newTransactionDetail.Request_ID__c = aNode.getAttribute( 'RequestID', null );
            newTransactionDetail.Merchant_Reference_Number__c = aNode.getAttribute( 'MerchantReferenceNumber', null );
            newTransactionDetail.Source__c = aNode.getAttribute( 'Source', null );
            newTransactionDetail.User__c = aNode.getAttribute( 'User', null );
            newTransactionDetail.Subscription_ID__c = aNode.getAttribute( 'SubscriptionID', null );
            newTransactionDetail.Transaction_Reference_Number__c = aNode.getAttribute( 'TransactionReferenceNumber', null );
            newTransactionDetail.eCommerce_Indicator__c = aNode.getAttribute( 'eCommerceIndicator', null );
            newTransactionDetail.Request_Date__c = (DateTime)JSON.deserialize( '"' + aNode.getAttribute( 'RequestDate', null ) + '"', DateTime.class );

            Dom.XmlNode billTo = aNode.getChildElement( 'BillTo', TRANSACTION_DETAIL_NS );
            newTransactionDetail.Billing_First_Name__c = getTextOrNullFromChildElement( billTo, 'FirstName', TRANSACTION_DETAIL_NS );
            newTransactionDetail.Billing_Last_Name__c = getTextOrNullFromChildElement( billTo, 'LastName', TRANSACTION_DETAIL_NS );
            newTransactionDetail.Billing_Address__c = getTextOrNullFromChildElement( billTo, 'Address1', TRANSACTION_DETAIL_NS );
            newTransactionDetail.Billing_City__c = getTextOrNullFromChildElement( billTo, 'City', TRANSACTION_DETAIL_NS );
            newTransactionDetail.Billing_State__c = getTextOrNullFromChildElement( billTo, 'State', TRANSACTION_DETAIL_NS );
            newTransactionDetail.Billing_Zip__c = getTextOrNullFromChildElement( billTo, 'Zip', TRANSACTION_DETAIL_NS );
            newTransactionDetail.Billing_Email__c = getTextOrNullFromChildElement( billTo, 'Email', TRANSACTION_DETAIL_NS );
            newTransactionDetail.Billing_Country__c = getTextOrNullFromChildElement( billTo, 'Country', TRANSACTION_DETAIL_NS );
            newTransactionDetail.Billing_Phone__c = getTextOrNullFromChildElement( billTo, 'Phone', TRANSACTION_DETAIL_NS );

            Dom.XmlNode shipTo = aNode.getChildElement( 'ShipTo', TRANSACTION_DETAIL_NS );
            if( shipTo != NULL )
            {
                newTransactionDetail.Shipping_First_Name__c = getTextOrNullFromChildElement( shipTo, 'FirstName', TRANSACTION_DETAIL_NS );
                newTransactionDetail.Shipping_Last_Name__c = getTextOrNullFromChildElement( shipTo, 'LastName', TRANSACTION_DETAIL_NS );
                newTransactionDetail.Shipping_Address__c = getTextOrNullFromChildElement( shipTo, 'Address1', TRANSACTION_DETAIL_NS );
                newTransactionDetail.Shipping_City__c = getTextOrNullFromChildElement( shipTo, 'City', TRANSACTION_DETAIL_NS );
                newTransactionDetail.Shipping_State__c = getTextOrNullFromChildElement( shipTo, 'State', TRANSACTION_DETAIL_NS );
                newTransactionDetail.Shipping_Zip__c = getTextOrNullFromChildElement( shipTo, 'Zip', TRANSACTION_DETAIL_NS );
                newTransactionDetail.Shipping_Country__c = getTextOrNullFromChildElement( shipTo, 'Country', TRANSACTION_DETAIL_NS );
            }

            Dom.XmlNode paymentMethod = aNode.getChildElement( 'PaymentMethod', TRANSACTION_DETAIL_NS );
            Dom.XmlNode paymentCard = paymentMethod.getChildElement( 'Card', TRANSACTION_DETAIL_NS );
            newTransactionDetail.Card_Account_Suffix__c = getTextOrNullFromChildElement( paymentCard, 'AccountSuffix', TRANSACTION_DETAIL_NS );
            newTransactionDetail.Card_Expiration_Month__c = getTextOrNullFromChildElement( paymentCard, 'ExpirationMonth', TRANSACTION_DETAIL_NS);
            newTransactionDetail.Card_Expiration_Year__c = getTextOrNullFromChildElement( paymentCard, 'ExpirationYear', TRANSACTION_DETAIL_NS );
            newTransactionDetail.Card_Type__c = getTextOrNullFromChildElement( paymentCard, 'CardType', TRANSACTION_DETAIL_NS );

            Dom.XmlNode lineItems = aNode.getChildElement( 'LineItems', TRANSACTION_DETAIL_NS );
            if( lineItems != NULL )
            {
                Dom.XmlNode singleLineItem = lineItems.getChildElement( 'LineItem', TRANSACTION_DETAIL_NS );
                newTransactionDetail.Line_Item_Number__c = singleLineItem.getAttribute( 'Number', null );
                newTransactionDetail.Line_Item_Fulfillment_Type__c = getTextOrNullFromChildElement( singleLineItem, 'FulfillmentType', TRANSACTION_DETAIL_NS );
                newTransactionDetail.Line_Item_Quantity__c = getTextOrNullFromChildElement( singleLineItem, 'Quantity', TRANSACTION_DETAIL_NS);
                newTransactionDetail.Line_Item_Unit_Price__c = Decimal.valueof(getTextOrNullFromChildElement( singleLineItem, 'UnitPrice', TRANSACTION_DETAIL_NS ));
                newTransactionDetail.Line_Item_Tax_Amount__c = Decimal.valueof(getTextOrNullFromChildElement( singleLineItem, 'TaxAmount', TRANSACTION_DETAIL_NS ));
                newTransactionDetail.Line_Item_Product_Code__c = getTextOrNullFromChildElement( singleLineItem, 'ProductCode', TRANSACTION_DETAIL_NS );
            }

            Dom.XmlNode applicationReplies = aNode.getChildElement( 'ApplicationReplies', TRANSACTION_DETAIL_NS );
            for( Dom.XmlNode aChildNode : applicationReplies.getChildElements() )
            {
                if( aChildNode.getAttribute( 'Name', null ) == 'ics_bill' )
                {
                    newTransactionDetail.Billing_Application_Reply_Name__c = aChildNode.getAttribute( 'Name', null );
                    newTransactionDetail.Billing_Application_Reply_Code__c = getTextOrNullFromChildElement( aChildNode, 'RCode', TRANSACTION_DETAIL_NS );
                    newTransactionDetail.Billing_Application_Reply_Flag__c = getTextOrNullFromChildElement( aChildNode, 'RFlag', TRANSACTION_DETAIL_NS );
                    newTransactionDetail.Billing_Application_Reply_Message__c = getTextOrNullFromChildElement( aChildNode, 'RMsg', TRANSACTION_DETAIL_NS );
                }
                else if( aChildNode.getAttribute( 'Name', null ) == 'ics_auth' )
                {
                    newTransactionDetail.Authorization_Application_Reply_Name__c = aChildNode.getAttribute( 'Name', null );
                    newTransactionDetail.Authorization_Application_Reply_Code__c = getTextOrNullFromChildElement( aChildNode, 'RCode', TRANSACTION_DETAIL_NS );
                    newTransactionDetail.Authorization_Application_Reply_Flag__c = getTextOrNullFromChildElement( aChildNode, 'RFlag', TRANSACTION_DETAIL_NS );
                    newTransactionDetail.Authorization_Application_Reply_Message__c = getTextOrNullFromChildElement( aChildNode, 'RMsg', TRANSACTION_DETAIL_NS );
                }
                else if( aChildNode.getAttribute( 'Name', null ) == 'ics_pay_subscription_create' )
                {
                    newTransactionDetail.Payment_Application_Reply_Name__c = aChildNode.getAttribute( 'Name', null );
                    newTransactionDetail.Payment_Application_Reply_Code__c = getTextOrNullFromChildElement( aChildNode, 'RCode', TRANSACTION_DETAIL_NS );
                    newTransactionDetail.Payment_Application_Reply_Flag__c = getTextOrNullFromChildElement( aChildNode, 'RFlag', TRANSACTION_DETAIL_NS );
                    newTransactionDetail.Payment_Application_Reply_Message__c = getTextOrNullFromChildElement( aChildNode, 'RMsg', TRANSACTION_DETAIL_NS );
                }
            }

            Dom.XmlNode paymentData = aNode.getChildElement( 'PaymentData', TRANSACTION_DETAIL_NS );
            if( paymentData != NULL )
            {
                newTransactionDetail.Payment_Request_ID__c = getTextOrNullFromChildElement( paymentData, 'PaymentRequestID', TRANSACTION_DETAIL_NS );
                newTransactionDetail.Payment_Processor__c = getTextOrNullFromChildElement( paymentData, 'PaymentProcessor', TRANSACTION_DETAIL_NS );
                newTransactionDetail.Payment_Amount__c = Decimal.valueof(getTextOrNullFromChildElement( paymentData, 'Amount', TRANSACTION_DETAIL_NS ));
                newTransactionDetail.Payment_Currency_Code__c = getTextOrNullFromChildElement( paymentData, 'CurrencyCode', TRANSACTION_DETAIL_NS );
                newTransactionDetail.Payment_Tax_Amount__c = Decimal.valueof(getTextOrNullFromChildElement( paymentData, 'TotalTaxAmount', TRANSACTION_DETAIL_NS ));
                newTransactionDetail.Payment_Authorization_Type__c = getTextOrNullFromChildElement( paymentData, 'AuthorizationType', TRANSACTION_DETAIL_NS );
                newTransactionDetail.Payment_Authorization_Code__c = getTextOrNullFromChildElement( paymentData, 'AuthorizationCode', TRANSACTION_DETAIL_NS );
                newTransactionDetail.Payment_AVS_Result__c = getTextOrNullFromChildElement( paymentData, 'AVSResult', TRANSACTION_DETAIL_NS );
                newTransactionDetail.Payment_AVS_Result_Mapped__c = getTextOrNullFromChildElement( paymentData, 'AVSResultMapped', TRANSACTION_DETAIL_NS );
                newTransactionDetail.Payment_CV_Result__c = getTextOrNullFromChildElement( paymentData, 'CVResult', TRANSACTION_DETAIL_NS );
                newTransactionDetail.Payment_ACH_Verification_Result__c = getTextOrNullFromChildElement( paymentData, 'ACHVerificationResult', TRANSACTION_DETAIL_NS );
                newTransactionDetail.Payment_Requested_Amount_Currency_Code__c = getTextOrNullFromChildElement( paymentData, 'RequestedAmountCurrencyCode', TRANSACTION_DETAIL_NS );
                newTransactionDetail.Payment_Bin_Number__c = getTextOrNullFromChildElement( paymentData, 'BinNumber', TRANSACTION_DETAIL_NS );

                String requestedAmount = getTextOrNullFromChildElement( paymentData, 'RequestedAmount', TRANSACTION_DETAIL_NS );
                newTransactionDetail.Payment_Requested_Amount__c = requestedAmount == NULL ? 0.0 : Decimal.valueOf( requestedAmount );
            }
            newTransactionDetail.Unique_Id__c = newTransactionDetail.Request_ID__c + newTransactionDetail.RecordTypeId;

            recordsToCreate.add( newTransactionDetail );

            merchantIds.add( newTransactionDetail.Merchant_Reference_Number__c );
        }

        relateCybersourceDetailToCart( recordsToCreate, merchantIds );
        upsert recordsToCreate CyberSource__c.Unique_Id__c;
    }

    private static void relateCybersourceDetailToCart( List<CyberSource__c> incomingCybersourceDetails, Set<String> merchantIds )
    {
        List<E_Cart__c> merchants = [ SELECT Id, Name FROM E_Cart__c WHERE Name IN :merchantIds ];
        Map<String, E_Cart__c> merchantsByName = new Map<String, E_Cart__c>();
        for( E_Cart__c aMerchant : merchants )
        {
            merchantsByName.put( aMerchant.Name, aMerchant );
        }
        for( CyberSource__c aPaymentDetail : incomingCybersourceDetails )
        {
            if( merchantsByName.containsKey( aPaymentDetail.Merchant_Reference_Number__c ) )
            {
                aPaymentDetail.Merchant__c = merchantsByName.get( aPaymentDetail.Merchant_Reference_Number__c ).Id;
            }
        }
    }

    private static String getTextOrNullFromChildElement( Dom.XmlNode theNode, String theTag, String nameSpace )
    {
        String toReturn = null;
        if( theNode.getChildElement( theTag, nameSpace ) != NULL )
        {
            toReturn = theNode.getChildElement( theTag, nameSpace ).getText();
        }
        return toReturn;
    }

    public class CybersourceException extends Exception {}
}