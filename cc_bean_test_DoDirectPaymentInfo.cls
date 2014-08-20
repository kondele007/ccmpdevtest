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
private class  cc_bean_test_DoDirectPaymentInfo {

   static testMethod void myUnitTest() {
        cc_bean_DoDirectPaymentInfo ddpi = cc_test_TestData.createDirectPaymentInfo();
        
        //System.debug(ddpi.getPaypalRequestString());
        
        /*'&CVV2=123'*/
        System.assertEquals('ZIP=10210&CITY=New+York&STATE=NY&STREET2=Apt+312&COUNTRYCODE=US&STREET=123+5th+St' +
                            '&PHONENUM=1234567890&ACCT=1234567890&STARTDATE=012008&CREDITCARDTYPE=Maestro&ISSUENUMBER=123' +
                            '&EXPDATE=012010&INVNUM=111&SHIPPINGDISCOUNT=1.00&NOTIFYURL=www.salesforce.com&CUSTOM=custom+field' +
                            '&ITEMAMT=9.99&INSURANCEOPTIONOFFERED=true&DESC=desc&HANDLINGAMT=1.99&TAXAMT=2.99&CURRENCYCODE=USD' +
                            '&BUTTONSOURCE=123&SHIPPINGAMT=5.99&INSURANCEAMT=1.99&AMT=10.99&SHIPTOSTREET=123+5th+St' +
                            '&SHIPTOSTREET2=Apt+312&SHIPTOCOUNTRY=US&SHIPTOSTATE=NY&SHIPTOCITY=New+York&SHIPTOZIP=10210' +
                            '&SHIPTONAME=name&SHIPTOPHONENUM=1234567890&SUFFIX=Sr.&SALUTATION=Mr.&COUNTRYCODE=US' +
                            '&BUSINESS=bname&EMAIL=email%40test.com&FIRSTNAME=fname&MIDDLENAME=mname&LASTNAME=lname' +
                            '&PAYERID=112&PAYERSTATUS=verified&IPADDRESS=127.0.0.1&PAYMENTACTION=Authorization'
                            ,ddpi.getPaypalRequestString());
        
        System.assertEquals('DoDirectPayment',cc_bean_DoDirectPaymentInfo.getMethod());
   }
}