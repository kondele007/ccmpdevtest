//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_bean_PaymentDetails {
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public Decimal amount                   {get;set;}
    public String  currencyCode             {get;set;}
    public Decimal itemAmount               {get;set;}
    public Decimal shippingAmount           {get;set;}
    public Decimal insuranceAmount          {get;set;}
    public Decimal shippingDiscount         {get;set;}
    public Boolean insuranceOptionsOffered  {get;set;}
    public Decimal handlingAmount           {get;set;}
    public Decimal taxAmount                {get;set;}
    public String  description              {get;set;}
    public String  customField              {get;set;}
    public String  invoiceNumber            {get;set;}
    public String  buttonSource             {get;set;}
    public String  notifyUrl                {get;set;}
    //==================================================
    // HELPER METHODS
    //==================================================
    public String getPaypalRequestString(){
        List<String> strList= new List<String>();
        if(this.amount!=null){
            strList.add('AMT=' +  Encodingutil.urlEncode(String.valueOf(this.amount.setScale(2)),'UTF-8'));
        }
        if(al.StringUtils.isNotEmpty(this.currencyCode)){
            strList.add('CURRENCYCODE=' + Encodingutil.urlEncode(String.valueOf(this.currencyCode),'UTF-8'));
        }
        if(this.itemAmount!=null){
            strList.add('ITEMAMT=' + Encodingutil.urlEncode(String.valueOf(this.itemAmount.setScale(2)),'UTF-8'));
        }
        if(this.shippingAmount!=null){
            strList.add('SHIPPINGAMT=' + Encodingutil.urlEncode(String.valueOf(this.shippingAmount.setScale(2)),'UTF-8') );
        }
        if(this.insuranceAmount!=null){
            strList.add('INSURANCEAMT=' +  Encodingutil.urlEncode(String.valueOf(this.insuranceAmount.setScale(2)),'UTF-8'));
        }
        if(this.shippingDiscount!=null){
            strList.add('SHIPPINGDISCOUNT=' + Encodingutil.urlEncode(String.valueOf(this.shippingDiscount.setScale(2)),'UTF-8') );
        }
        if(this.insuranceOptionsOffered!=null){
            strList.add('INSURANCEOPTIONOFFERED=' + Encodingutil.urlEncode(String.valueOf(this.insuranceOptionsOffered),'UTF-8') );
        }
        if(this.handlingAmount!=null){
            strList.add('HANDLINGAMT=' + Encodingutil.urlEncode(String.valueOf(this.handlingAmount.setScale(2)),'UTF-8'));
        }
        if(this.taxAmount!=null){
            strList.add('TAXAMT=' + Encodingutil.urlEncode(String.valueOf(this.taxAmount.setScale(2)),'UTF-8'));
        }   
        if(al.StringUtils.isNotEmpty(this.description)){
            strList.add('DESC=' + Encodingutil.urlEncode(this.description,'UTF-8'));
        }
        if(al.StringUtils.isNotEmpty(this.customField)){
            strList.add('CUSTOM=' + Encodingutil.urlEncode(this.customField,'UTF-8'));
        }
        if(al.StringUtils.isNotEmpty(this.invoiceNumber)){
            strList.add('INVNUM=' + Encodingutil.urlEncode(this.invoiceNumber,'UTF-8'));
        }
        if(al.StringUtils.isNotEmpty(this.buttonSource)){
            strList.add('BUTTONSOURCE=' + Encodingutil.urlEncode(this.buttonSource,'UTF-8'));
        }
        if(al.StringUtils.isNotEmpty(this.notifyUrl)){
            strList.add('NOTIFYURL=' + Encodingutil.urlEncode(this.notifyUrl,'UTF-8') );
        }
        
        return al.StringUtils.joinStrings(strList, '&');
    }
    
}