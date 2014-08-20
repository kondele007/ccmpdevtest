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
private class PaypalPayerInfoTest {

    static testMethod void myUnitTest() {
        PaypalPayerInfo ppi = new PaypalPayerInfo();
        ppi.firstName          = 'fname';
        ppi.middleName         = 'mname';
        ppi.lastName           = 'lname';
        ppi.businessName       = 'bname';
        ppi.countryCode        = 'US';
        ppi.email              = 'email@test.com';
        ppi.payerId            = '112';
        ppi.payerStatus        = PaypalPayerInfo.PAYER_STATUS_VERIFIED;
        ppi.salutation         = 'Mr.';
        ppi.suffix             = 'Sr.';
        //System.debug(ppi.getPaypalRequestString());
        System.assertEquals('SUFFIX=Sr.&SALUTATION=Mr.&COUNTRYCODE=US&BUSINESS=bname' + 
                            '&EMAIL=email%40test.com&FIRSTNAME=fname&MIDDLENAME=mname' +
                            '&LASTNAME=lname&PAYERID=112&PAYERSTATUS=verified', ppi.getPaypalRequestString());
        
    }
}