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
private class cc_hlpr_test_CreditCard {

    static testMethod void myUnitTest() {
        cc_hlpr_CreditCard cc= new cc_hlpr_CreditCard();
        cc.ccType='Maestro';
        //cc.ccCVV2='123';
        cc.ccExpirationMonth='01';
        cc.ccExpirationYear     ='2010';
        cc.issueNumber          = '123';
        cc.ccNumber             = '1234567890';
        cc.startMonth           = '01';
        cc.startYear            = '2008';
        System.assertEquals('ACCT=1234567890&STARTDATE=012008&CREDITCARDTYPE=Maestro&ISSUENUMBER=123&EXPDATE=012010'
                            ,cc.getPaypalRequestString());
    }
}