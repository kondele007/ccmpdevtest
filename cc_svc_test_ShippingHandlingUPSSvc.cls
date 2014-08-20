//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
/* ============================================================
 * Unit test for cc_svc_ShippingAndHandlingUPS
 * 
 * ============================================================
 */ 
@IsTest
private class cc_svc_test_ShippingHandlingUPSSvc {

    private static void prepTestData() {
        cc_test_PrepTestData.loadCustomSettings();
        cc_test_PrepTestData.loadInitData();
    }

    private static testmethod void testBuildRatingServiceSelectionRequestXML(){ 
        cc_svc_test_ShippingHandlingUPSSvc.prepTestData();
        Test.startTest();

        cc_bean_ShippingOptionsRequest shipOptionsRequest = new cc_bean_ShippingOptionsRequest();
        // Build data
        shipOptionsRequest.recepientZipCode = '61614';
        shipOptionsRequest.recepientCountryCode = 'US'; 
        List<cc_bean_ShippingAttributes> shipAttributesList = new List<cc_bean_ShippingAttributes>();
        cc_bean_ShippingAttributes shipAttributes = new cc_bean_ShippingAttributes();       
        shipAttributes.weight = 5.5;
        shipAttributesList.add(shipAttributes);
        shipOptionsRequest.shippingAttributesList = shipAttributesList;             
        // Build data
        //cc_svc_ShippingAndHandlingUPS cc_svc_ShippingAndHandlingUPS = new cc_svc_ShippingAndHandlingUPS(cc_util_CloudCraze.application.Default_Storefront__c);
        E_StorefrontSettings__c storefront = cc_util_CloudCraze.getStorefrontSettings(cc_util_CloudCraze.application.Default_Storefront__c);
        cc_svc_ShippingAndHandlingUPS cc_svc_ShippingAndHandlingUPS = new cc_svc_ShippingAndHandlingUPS(storefront);
        cc_svc_ShippingAndHandlingUPS.shippingOptionsRequest = shipOptionsRequest;
        boolean requestXmlValid = false; 
        String xmlRequest = cc_svc_ShippingAndHandlingUPS.buildRatingServiceSelectionRequestXML();
        //System.debug(xmlRequest);       
        if (al.StringUtils.isNotBlank(xmlRequest)) {
            requestXmlValid = true;
        } 
        System.assertEquals(true, requestXmlValid);

        Test.stopTest();
    }
    
    private static testmethod void testGetShippingServiceAndCost(){
        cc_svc_test_ShippingHandlingUPSSvc.prepTestData();
        
        Test.startTest();

        cc_bean_ShippingOptionsRequest shipOptionsRequest = new cc_bean_ShippingOptionsRequest();
        // Build data
        shipOptionsRequest.recepientZipCode = '61614';
        shipOptionsRequest.recepientCountryCode = 'US'; 
        List<cc_bean_ShippingAttributes> shipAttributesList = new List<cc_bean_ShippingAttributes>();
        cc_bean_ShippingAttributes shipAttributes = new cc_bean_ShippingAttributes();       
        shipAttributes.weight = 5.5;
        shipAttributesList.add(shipAttributes);
        shipOptionsRequest.shippingAttributesList = shipAttributesList;             
        // Build data       
        String responseXml = '<?xml version="1.0"?><RatingServiceSelectionResponse><Response><ResponseStatusCode>1</ResponseStatusCode><ResponseStatusDescription>Success</ResponseStatusDescription></Response><RatedShipment><Service><Code>03</Code></Service><RatedShipmentWarning>Your invoice may vary from the displayed reference rates</RatedShipmentWarning><BillingWeight><UnitOfMeasurement><Code>LBS</Code></UnitOfMeasurement><Weight>6.0</Weight></BillingWeight><TransportationCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>6.56</MonetaryValue></TransportationCharges><ServiceOptionsCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>0.00</MonetaryValue></ServiceOptionsCharges><TotalCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>6.56</MonetaryValue></TotalCharges><GuaranteedDaysToDelivery/><ScheduledDeliveryTime/><RatedPackage><TransportationCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>6.56</MonetaryValue></TransportationCharges><ServiceOptionsCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>0.00</MonetaryValue></ServiceOptionsCharges><TotalCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>6.56</MonetaryValue></TotalCharges><Weight>5.5</Weight><BillingWeight><UnitOfMeasurement><Code>LBS</Code></UnitOfMeasurement><Weight>6.0</Weight></BillingWeight></RatedPackage></RatedShipment><RatedShipment><Service><Code>12</Code></Service><RatedShipmentWarning>Your invoice may vary from the displayed reference rates</RatedShipmentWarning><BillingWeight><UnitOfMeasurement><Code>LBS</Code></UnitOfMeasurement><Weight>6.0</Weight></BillingWeight><TransportationCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>11.02</MonetaryValue></TransportationCharges><ServiceOptionsCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>0.00</MonetaryValue></ServiceOptionsCharges><TotalCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>11.02</MonetaryValue></TotalCharges><GuaranteedDaysToDelivery>3</GuaranteedDaysToDelivery><ScheduledDeliveryTime/><RatedPackage><TransportationCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>11.02</MonetaryValue></TransportationCharges><ServiceOptionsCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>0.00</MonetaryValue></ServiceOptionsCharges><TotalCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>11.02</MonetaryValue></TotalCharges><Weight>5.5</Weight><BillingWeight><UnitOfMeasurement><Code>LBS</Code></UnitOfMeasurement><Weight>6.0</Weight></BillingWeight></RatedPackage></RatedShipment><RatedShipment><Service><Code>59</Code></Service><RatedShipmentWarning>Your invoice may vary from the displayed reference rates</RatedShipmentWarning><BillingWeight><UnitOfMeasurement><Code>LBS</Code></UnitOfMeasurement><Weight>6.0</Weight></BillingWeight><TransportationCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>17.41</MonetaryValue></TransportationCharges><ServiceOptionsCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>0.00</MonetaryValue></ServiceOptionsCharges><TotalCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>17.41</MonetaryValue></TotalCharges><GuaranteedDaysToDelivery>2</GuaranteedDaysToDelivery><ScheduledDeliveryTime>10:30 A.M.</ScheduledDeliveryTime><RatedPackage><TransportationCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>17.41</MonetaryValue></TransportationCharges><ServiceOptionsCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>0.00</MonetaryValue></ServiceOptionsCharges><TotalCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>17.41</MonetaryValue></TotalCharges><Weight>5.5</Weight><BillingWeight><UnitOfMeasurement><Code>LBS</Code></UnitOfMeasurement><Weight>6.0</Weight></BillingWeight></RatedPackage></RatedShipment><RatedShipment><Service><Code>02</Code></Service><RatedShipmentWarning>Your invoice may vary from the displayed reference rates</RatedShipmentWarning><BillingWeight><UnitOfMeasurement><Code>LBS</Code></UnitOfMeasurement><Weight>6.0</Weight></BillingWeight><TransportationCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>14.98</MonetaryValue></TransportationCharges><ServiceOptionsCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>0.00</MonetaryValue></ServiceOptionsCharges><TotalCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>14.98</MonetaryValue></TotalCharges><GuaranteedDaysToDelivery>2</GuaranteedDaysToDelivery><ScheduledDeliveryTime/><RatedPackage><TransportationCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>14.98</MonetaryValue></TransportationCharges><ServiceOptionsCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>0.00</MonetaryValue></ServiceOptionsCharges><TotalCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>14.98</MonetaryValue></TotalCharges><Weight>5.5</Weight><BillingWeight><UnitOfMeasurement><Code>LBS</Code></UnitOfMeasurement><Weight>6.0</Weight></BillingWeight></RatedPackage></RatedShipment><RatedShipment><Service><Code>13</Code></Service><RatedShipmentWarning>Your invoice may vary from the displayed reference rates</RatedShipmentWarning><BillingWeight><UnitOfMeasurement><Code>LBS</Code></UnitOfMeasurement><Weight>6.0</Weight></BillingWeight><TransportationCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>44.68</MonetaryValue></TransportationCharges><ServiceOptionsCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>0.00</MonetaryValue></ServiceOptionsCharges><TotalCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>44.68</MonetaryValue></TotalCharges><GuaranteedDaysToDelivery>1</GuaranteedDaysToDelivery><ScheduledDeliveryTime>3:00 P.M.</ScheduledDeliveryTime><RatedPackage><TransportationCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>44.68</MonetaryValue></TransportationCharges><ServiceOptionsCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>0.00</MonetaryValue></ServiceOptionsCharges><TotalCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>44.68</MonetaryValue></TotalCharges><Weight>5.5</Weight><BillingWeight><UnitOfMeasurement><Code>LBS</Code></UnitOfMeasurement><Weight>6.0</Weight></BillingWeight></RatedPackage></RatedShipment><RatedShipment><Service><Code>14</Code></Service><RatedShipmentWarning>Your invoice may vary from the displayed reference rates</RatedShipmentWarning><BillingWeight><UnitOfMeasurement><Code>LBS</Code></UnitOfMeasurement><Weight>6.0</Weight></BillingWeight><TransportationCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>81.92</MonetaryValue></TransportationCharges><ServiceOptionsCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>0.00</MonetaryValue></ServiceOptionsCharges><TotalCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>81.92</MonetaryValue></TotalCharges><GuaranteedDaysToDelivery>1</GuaranteedDaysToDelivery><ScheduledDeliveryTime>8:00 A.M.</ScheduledDeliveryTime><RatedPackage><TransportationCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>81.92</MonetaryValue></TransportationCharges><ServiceOptionsCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>0.00</MonetaryValue></ServiceOptionsCharges><TotalCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>81.92</MonetaryValue></TotalCharges><Weight>5.5</Weight><BillingWeight><UnitOfMeasurement><Code>LBS</Code></UnitOfMeasurement><Weight>6.0</Weight></BillingWeight></RatedPackage></RatedShipment><RatedShipment><Service><Code>01</Code></Service><RatedShipmentWarning>Your invoice may vary from the displayed reference rates</RatedShipmentWarning><BillingWeight><UnitOfMeasurement><Code>LBS</Code></UnitOfMeasurement><Weight>6.0</Weight></BillingWeight><TransportationCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>49.22</MonetaryValue></TransportationCharges><ServiceOptionsCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>0.00</MonetaryValue></ServiceOptionsCharges><TotalCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>49.22</MonetaryValue></TotalCharges><GuaranteedDaysToDelivery>1</GuaranteedDaysToDelivery><ScheduledDeliveryTime>10:30 A.M.</ScheduledDeliveryTime><RatedPackage><TransportationCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>49.22</MonetaryValue></TransportationCharges><ServiceOptionsCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>0.00</MonetaryValue></ServiceOptionsCharges><TotalCharges><CurrencyCode>USD</CurrencyCode><MonetaryValue>49.22</MonetaryValue></TotalCharges><Weight>5.5</Weight><BillingWeight><UnitOfMeasurement><Code>LBS</Code></UnitOfMeasurement><Weight>6.0</Weight></BillingWeight></RatedPackage></RatedShipment></RatingServiceSelectionResponse>'; 
        cc_hlpr_XMLDom theXMLDom = new cc_hlpr_XMLDom(responseXml);
    
        //cc_svc_ShippingAndHandlingUPS cc_svc_ShippingAndHandlingUPS = new cc_svc_ShippingAndHandlingUPS(cc_util_CloudCraze.application.Default_Storefront__c);
        E_StorefrontSettings__c storefront = cc_util_CloudCraze.getStorefrontSettings(cc_util_CloudCraze.application.Default_Storefront__c);
        cc_svc_ShippingAndHandlingUPS cc_svc_ShippingAndHandlingUPS = new cc_svc_ShippingAndHandlingUPS(storefront);
        cc_svc_ShippingAndHandlingUPS.shippingOptionsRequest = shipOptionsRequest;
        cc_bean_ShippingOptions shipOptions = cc_svc_ShippingAndHandlingUPS.getShippingServiceAndCost(theXMLDom);
        
        System.assertEquals(true, shipOptions.status);
        System.assertEquals(cc_cnst_UPSXMLTag.SHIPPINGPROVIDER, shipOptions.shippingProvider);         
        List<cc_bean_ShippingServicesAndCostDetails> shippingServicesAndCostList = shipOptions.shippingServicesAndCostDetails;
        for (cc_bean_ShippingServicesAndCostDetails shippingServicesAndCost : shippingServicesAndCostList) {
            System.assertEquals('$', shippingServicesAndCost.currencyCode);                 
            //System.debug('-----shipService = ' + shippingServicesAndCost.shipService);
            //System.debug('-----currencyCode = ' + shippingServicesAndCost.currencyCode);
            //System.debug('-----shipCost = ' + shippingServicesAndCost.shipCost);                    
        }
        
        Test.stopTest();
    }
}