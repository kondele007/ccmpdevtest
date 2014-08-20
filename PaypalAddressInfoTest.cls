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
private class PaypalAddressInfoTest {

    static testMethod void myUnitTest() {
        PaypalAddressInfo pai = new PaypalAddressInfo(false);
        pai.city    =   'New York';
        pai.countryCode =   'US';
        pai.name        = 'name';
        pai.state       = 'NY';
        pai.street      = '123 5th St';
        pai.street2     = 'Apt 312';
        pai.zip         = '10210';
        pai.phoneNumber = '1234567890';

        //System.debug(pai.getPaypalRequestString());
        System.assertEquals('ZIP=10210&CITY=New+York&STATE=NY&STREET2=Apt+312&COUNTRYCODE=US&STREET=123+5th+St&PHONENUM=1234567890'
                            ,pai.getPaypalRequestString());

        pai = new PaypalAddressInfo(true);
        pai.city        = 'New York';
        pai.countryCode = 'US';
        pai.name        = 'name';
        pai.state       = 'NY';
        pai.street      = '123 5th St';
        pai.street2     = 'Apt 312';
        pai.zip         = '10210';
        pai.phoneNumber = '1234567890';

        //System.debug(pai.getPaypalRequestString());
        System.assertEquals('SHIPTOSTREET=123+5th+St&SHIPTOSTREET2=Apt+312&SHIPTOCOUNTRY=US&SHIPTOSTATE=NY&SHIPTOCITY=New+York&SHIPTOZIP=10210&SHIPTONAME=name&SHIPTOPHONENUM=1234567890'
                            ,pai.getPaypalRequestString());
    }
}