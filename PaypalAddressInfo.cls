//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class PaypalAddressInfo {
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public Boolean isShipping   {get;set;}
    public String name          {get;set;} // Required only if the address is a shpiing address
    public String street        {get;set;}
    public String street2       {get;set;} // Optional
    public String city          {get;set;}
    public String state         {get;set;}
    public String countryCode   {get;set;}
    public String zip           {get;set;}
    public String phoneNumber   {get;set;} // Optional
    
    //==================================================
    // CONSTRUCTOR
    //==================================================
    public PaypalAddressInfo(Boolean isShipping){
        this.isShipping=isShipping;
    }
	
	//==================================================
    // SERVICE METHODS
    //==================================================
    public String getPaypalRequestString(){
        List<String> strList= new List<String>();
        
        if(this.isShipping && al.StringUtils.isNotEmpty(this.name)){
            strList.add('SHIPTONAME=' + Encodingutil.urlEncode(this.name,'UTF-8'));
        }
        if(al.StringUtils.isNotEmpty(this.street)){
            strList.add((this.isShipping?'SHIPTOSTREET=':'STREET=') + Encodingutil.urlEncode(this.street,'UTF-8'));
        }
        if(al.StringUtils.isNotEmpty(this.street2)){
            strList.add((this.isShipping?'SHIPTOSTREET2=':'STREET2=')+ Encodingutil.urlEncode(this.street2,'UTF-8'));
        }
        if(al.StringUtils.isNotEmpty(this.city)){
            strList.add((this.isShipping?'SHIPTOCITY=':'CITY=')+Encodingutil.urlEncode(this.city,'UTF-8'));
        }
        if(al.StringUtils.isNotEmpty(this.state)){
            strList.add((this.isShipping?'SHIPTOSTATE=':'STATE=')+Encodingutil.urlEncode(this.state,'UTF-8'));
        }
        if(al.StringUtils.isNotEmpty(this.countryCode)){
            strList.add((this.isShipping?'SHIPTOCOUNTRY=':'COUNTRYCODE=')+Encodingutil.urlEncode(this.countryCode,'UTF-8'));
        }
        if(al.StringUtils.isNotEmpty(this.zip)){
            strList.add((this.isShipping?'SHIPTOZIP=':'ZIP=')+Encodingutil.urlEncode(this.zip,'UTF-8'));
        }
        if(al.StringUtils.isNotEmpty(this.phoneNumber)){
            strList.add((this.isShipping?'SHIPTOPHONENUM=':'PHONENUM=')+Encodingutil.urlEncode(this.phoneNumber,'UTF-8'));
        }
        return al.StringUtils.joinStrings(strList, '&');
    }
}