//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
@isTest
private class cc_bean_test_PaymentDetails {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        cc_bean_PaymentDetails pd       = new cc_bean_PaymentDetails();
        pd.amount                   = Decimal.valueOf('10.9');
        pd.buttonSource             = '123';
        pd.currencyCode             = 'USD';
        pd.customField              = 'custom field';
        pd.description              = 'desc';
        pd.handlingAmount           = Decimal.valueOf('1.99');
        pd.insuranceAmount          = Decimal.valueOf('1.99');
        pd.insuranceOptionsOffered  = true;
        pd.invoiceNumber            = '111';
        pd.itemAmount               = Decimal.valueOf('9.99');
        pd.notifyUrl                = 'www.salesforce.com';
        pd.shippingAmount           = Decimal.valueOf('5.99');
        pd.shippingDiscount         = Decimal.valueOf('1.00');
        pd.taxAmount                = Decimal.valueOf('2.99');
        System.assertEquals('INVNUM=111&SHIPPINGDISCOUNT=1.00&NOTIFYURL=www.salesforce.com'+
                            '&CUSTOM=custom+field&ITEMAMT=9.99&INSURANCEOPTIONOFFERED=true'+
                            '&DESC=desc&HANDLINGAMT=1.99&TAXAMT=2.99&CURRENCYCODE=USD&AMT=10.90'+
                            '&BUTTONSOURCE=123&SHIPPINGAMT=5.99&INSURANCEAMT=1.99', pd.getPaypalRequestString());
    }
}