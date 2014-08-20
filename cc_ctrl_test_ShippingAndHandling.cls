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
 * Unit test for cc_ctrl_ShippingAndHandling
 * 
 * ============================================================
 */
@IsTest
private class cc_ctrl_test_ShippingAndHandling { 
    
    private static testmethod void testGetShippingOptions(){
        cc_ctrl_ShippingAndHandling cc_ctrl_ShippingAndHandling = new cc_ctrl_ShippingAndHandling();
        // Build data
        cc_ctrl_ShippingAndHandling.countryCode = 'US';
        cc_ctrl_ShippingAndHandling.stateCode = 'IL';
        cc_ctrl_ShippingAndHandling.zipCode = '61614';
        cc_ctrl_ShippingAndHandling.cartId = '100';
        // Build data 
        cc_ctrl_ShippingAndHandling.getShippingOptions();
        cc_bean_ShippingOptions fedExShippingOptionsBean = cc_ctrl_ShippingAndHandling.fedExShipOptions;
        cc_bean_ShippingOptions upsExShippingOptionsBean = cc_ctrl_ShippingAndHandling.upsShipOptions;
        if (fedExShippingOptionsBean != null && fedExShippingOptionsBean.status) {
            System.assertEquals(true, fedExShippingOptionsBean.status);
            System.assertEquals(cc_cnst_FedExXMLTag.SHIPPINGPROVIDER, fedExShippingOptionsBean.shippingProvider);          
            //System.debug('-----shippingProvider = ' + fedExShippingOptionsBean.shippingProvider);
            List<cc_bean_ShippingServicesAndCostDetails> fedExShippingServicesAndCostList = fedExShippingOptionsBean.shippingServicesAndCostDetails;
                for (cc_bean_ShippingServicesAndCostDetails fedExShippingServicesAndCost : fedExShippingServicesAndCostList) {
                    //System.debug('-----shipService = ' + fedExShippingServicesAndCost.shipService);
                    //System.debug('-----currencyCode = ' + fedExShippingServicesAndCost.currencyCode);
                    //System.debug('-----shipCost = ' + fedExShippingServicesAndCost.shipCost);                   
                }
        }   
        if (upsExShippingOptionsBean != null && upsExShippingOptionsBean.status) {
            System.assertEquals(true, upsExShippingOptionsBean.status);         
            System.assertEquals(cc_cnst_UPSXMLTag.SHIPPINGPROVIDER, upsExShippingOptionsBean.shippingProvider);            
            //System.debug('-----shippingProvider = ' + upsExShippingOptionsBean.shippingProvider);
            List<cc_bean_ShippingServicesAndCostDetails> upsShippingServicesAndCostList = upsExShippingOptionsBean.shippingServicesAndCostDetails;
                for (cc_bean_ShippingServicesAndCostDetails upsShippingServicesAndCost : upsShippingServicesAndCostList) {
                    //System.debug('-----shipService = ' + upsShippingServicesAndCost.shipService);
                    //System.debug('-----currencyCode = ' + upsShippingServicesAndCost.currencyCode);
                    //System.debug('-----shipCost = ' + upsShippingServicesAndCost.shipCost);                 
                }
        } 
    }
}