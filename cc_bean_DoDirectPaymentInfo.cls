//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_bean_DoDirectPaymentInfo {
	//==================================================
    // CONSTANTS
    //==================================================
    public static final String PAYMENT_ACTION_AUTH = 'Authorization';
    public static final String PAYMENT_ACTION_SALE = 'Sale';
     //==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public String  paymentAction                    {get;set;} // Optional default value is 'Sale'
    public String  ipAddress                        {get;set;}
    public Boolean returnDetails                    {get;set;} // Optional
    public cc_hlpr_CreditCard cc_hlpr_CreditCard                 {get;set;}
    public cc_bean_PaymentDetails payment                {get;set;}
    public PaypalAddressInfo billingAddress      {get;set;}
    public PaypalAddressInfo shippingAddress     {get;set;}
    public PaypalPayerInfo   payerInfo           {get;set;}
    
    //==================================================
    // HELPER METHODS
    //==================================================
    public static String getMethod(){
        return 'DoDirectPayment';
    }
   
    public String getPaypalRequestString(){
        List<String> strList= new List<String>();
        //strList.add('METHOD='+this.getMethod());
        
        //strList.add('CURRENCYCODE=USD');
        if(al.StringUtils.isNotEmpty(this.ipAddress)){
            strList.add('IPADDRESS='+  Encodingutil.urlEncode( this.ipAddress,'UTF-8'));    
        }
        
        strList.add('PAYMENTACTION=' + Encodingutil.urlEncode( PAYMENT_ACTION_AUTH,'UTF-8'));
        //strList.add('&AMT=' + Encodingutil.urlEncode(String.valueOf(this.payment.amount),'UTF-8') );
        //return //'IPADDRESS=' +  Encodingutil.urlEncode('255.255.255.255','UTF-8') +
        //'CURRENCYCODE=USD' +
        //'&IPADDRESS=127.0.0.1'+
        //'&AMT=' + Encodingutil.urlEncode(/*String.valueOf(this.payment.amount) '287.52'*/ '10.00','UTF-8') +
        //'&PAYMENTACTION=' + Encodingutil.urlEncode( PAYMENT_ACTION_AUTH,'UTF-8') +
        
        //'&' + this.cc_hlpr_CreditCard.getPaypalRequestString() + 
        //'&CREDITCARDTYPE=' + Encodingutil.urlEncode(this.cc_hlpr_CreditCard.ccType,'UTF-8')+
        //'&EXPDATE=' + Encodingutil.urlEncode(this.cc_hlpr_CreditCard.ccExpirationMonth+this.cc_hlpr_CreditCard.ccExpirationYear,'UTF-8')+
        //'&ACCT=' + Encodingutil.urlEncode(this.cc_hlpr_CreditCard.ccNumber,'UTF-8')+
        //'&CVV2=' + Encodingutil.urlEncode(this.cc_hlpr_CreditCard.ccCVV2,'UTF-8')+
        //'&FIRSTNAME=' + Encodingutil.urlEncode(this.payerInfo.firstName,'UTF-8')+
        //'&LASTNAME=' + Encodingutil.urlEncode(this.payerInfo.lastName,'UTF-8')+
        //'&EMAIL=' + Encodingutil.urlEncode(this.payerInfo.email,'UTF-8') +
        //'&' + this.payerInfo.getPaypalRequestString() +
        //'&' + this.billingAddress.getPaypalRequestString()+
        //'&' + this.shippingAddress.getPaypalRequestString();
        //'&STREET=' + Encodingutil.urlEncode(this.billingAddress.street,'UTF-8')+
        //'&STREET2=' + Encodingutil.urlEncode(this.billingAddress.street2,'UTF-8')+
        //'&CITY=' + Encodingutil.urlEncode(this.billingAddress.city,'UTF-8')+
        //'&STATE=' + Encodingutil.urlEncode(this.billingAddress.state,'UTF-8')+              
        //'&ZIP=' + Encodingutil.urlEncode(this.billingAddress.zip,'UTF-8')+
        //'&COUNTRYCODE=' + Encodingutil.urlEncode(this.billingAddress.countryCode,'UTF-8');
        
//'&ACCT=' +ddpi.cc_hlpr_CreditCard.ccNumber/*4120095467147069*/ +
//'&EXPDATE='+ ddpi.cc_hlpr_CreditCard.ccExpirationMonth+ddpi.cc_hlpr_CreditCard.ccExpirationYear /*022011*/+
//'&FIRSTNAME='+ ddpi.payerInfo.firstName+ 
//'&LASTNAME=' + ddpi.payerInfo.lastName+ 
//'&CVV2='+ ddpi.cc_hlpr_CreditCard.ccCVV2 + //123
//'&STREET=' +Encodingutil.urlEncode(ddpi.billingAddress.street,'UTF-8')+ //1+Main+St'+
//'&CITY=' +Encodingutil.urlEncode(ddpi.billingAddress.city,'UTF-8')+ //'San+Jose'+
//'&STATE='+Encodingutil.urlEncode(ddpi.billingAddress.state,'UTF-8')+
//'&ZIP='+Encodingutil.urlEncode(ddpi.billingAddress.zip,'UTF-8')+
//'&COUNTRYCODE=US'+
//'&CURRENCYCODE=USD';
        
        
    //  '&ITEMAMT=272.32&TAXAMT=15.20&L_NUMBER0=ItemOne&L_NAME0=First+Item+Taxable'+
//'&L_QTY0=2&L_AMT0=19.95&L_TAXAMT0=1.60&L_NUMBER1=ItemTwo&L_NAME1=Second+Item+Taxable'+
//'&L_QTY1=1&L_AMT1=149.95&L_TAXAMT1=12.00&L_NUMBER2=ItemThree&L_NAME2=Third+Item+No+Tax'+
//'&L_QTY2=3&L_AMT2=27.49&L_TAXAMT2=0.00';
        
        //'&SHIPTONAME=' + Encodingutil.urlEncode('TEST NAME','UTF-8')+
        //'&SHIPTOSTREET=' + Encodingutil.urlEncode(this.shippingAddress.street,'UTF-8')+
        //'&SHIPTOSTREET2=' + Encodingutil.urlEncode(this.shippingAddress.street2,'UTF-8')+
        //'&SHIPTOCITY=' + Encodingutil.urlEncode(this.shippingAddress.city,'UTF-8')+
        //'&SHIPTOSTATE=' + Encodingutil.urlEncode(this.shippingAddress.state,'UTF-8')+
        //'&SHIPTOZIP=' + Encodingutil.urlEncode(this.shippingAddress.zip,'UTF-8') +
        //'&SHIPTOCOUNTRY=' + Encodingutil.urlEncode(this.shippingAddress.countryCode,'UTF-8'); 
        
        //strList.add('COUNTRYCODE=' + Encodingutil.urlEncode(this.billlingAddress.countryCode,'UTF-8'));
        //if(this.returnDetails!=null){
        //  strList.add('RETURNFMFDETAILS=' + Encodingutil.urlEncode((this.returnDetails?'1':'0'),'UTF-8'));
        //}
        //if(al.StringUtils.isNotEmpty(this.ipAddress)){
        //  strList.add('IPADDRESS=' + Encodingutil.urlEncode(this.ipAddress,'UTF-8'));
        //}
        
        if(this.cc_hlpr_CreditCard!=null){
            strList.add(this.cc_hlpr_CreditCard.getPaypalRequestString());
        }
        
        //if(this.payment!=null){
        //  strList.add(this.payment.getPaypalRequestString());
        //}
        
        if(this.billingAddress!=null){
            strList.add(this.billingAddress.getPaypalRequestString());
        }
        
        if(this.shippingAddress!=null){
            strList.add(this.shippingAddress.getPaypalRequestString());
        }
        if(this.payerInfo!=null){
            strList.add(this.payerInfo.getPaypalRequestString());
        } 
        if(this.payment!=null){
            strList.add(this.payment.getPaypalRequestString());
        }
        
        return al.StringUtils.joinStrings(strList, '&');
    }
}