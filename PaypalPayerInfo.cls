//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class PaypalPayerInfo {
	//==================================================
    // CONSTANTS
    //==================================================
    public static final String PAYER_STATUS_VERIFIED    = 'verified';
    public static final String PAYER_STATUS_UNVERIFIED  = 'unverified';
    //==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public String salutation        {get;set;}
    public String firstName         {get;set;}
    public String middleName        {get;set;}
    public String lastName          {get;set;}
    public String suffix            {get;set;}
    
    public String email             {get;set;}
    public String payerId           {get;set;}
    public String payerStatus       {get;set;}   //Either 'verified' or 'unverified'
    public String countryCode       {get;set;}
    public String businessName      {get;set;}
    //==================================================
    // HELPER METHODS
    //==================================================
    public String getPaypalRequestString(){
        List<String> strList= new List<String>();
        
        if(al.StringUtils.isNotEmpty(this.salutation)){
            strList.add('SALUTATION='+ Encodingutil.urlEncode( this.salutation,'UTF-8'));
        }
        if(al.StringUtils.isNotEmpty(this.firstName)){
            strList.add('FIRSTNAME='+Encodingutil.urlEncode(this.firstName,'UTF-8'));
        }
        if(al.StringUtils.isNotEmpty(this.middleName)){
            strList.add('MIDDLENAME='+Encodingutil.urlEncode(this.middleName,'UTF-8'));
        }
        if(al.StringUtils.isNotEmpty(this.lastName)){
            strList.add('LASTNAME='+Encodingutil.urlEncode(this.lastName,'UTF-8'));
        }
        if(al.StringUtils.isNotEmpty(this.suffix)){
            strList.add('SUFFIX='+Encodingutil.urlEncode(this.suffix,'UTF-8'));
        }
        if(al.StringUtils.isNotEmpty(this.email)){
            strList.add('EMAIL='+Encodingutil.urlEncode(this.email,'UTF-8'));
        }
        if(al.StringUtils.isNotEmpty(this.payerId)){
            strList.add('PAYERID='+ Encodingutil.urlEncode(this.payerId,'UTF-8'));
        }
        if(PAYER_STATUS_VERIFIED.equalsIgnoreCase(this.payerStatus) ||
           PAYER_STATUS_UNVERIFIED.equalsIgnoreCase(this.payerStatus)){
            strList.add('PAYERSTATUS='+Encodingutil.urlEncode(this.payerStatus,'UTF-8'));
        }
        if(al.StringUtils.isNotEmpty(this.countryCode)){
            strList.add('COUNTRYCODE='+Encodingutil.urlEncode(this.countryCode,'UTF-8'));
        }
        if(al.StringUtils.isNotEmpty(this.businessName)){
            strList.add('BUSINESS='+Encodingutil.urlEncode(this.businessName,'UTF-8'));
        }
        return al.StringUtils.joinStrings(strList, '&');
    }
}