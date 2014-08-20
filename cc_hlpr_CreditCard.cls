//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_hlpr_CreditCard {
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
	public String ccType 		    {get;set;}
	public String ccNumber 		    {get;set;}
	public String ccExpirationMonth {get;set;}
	public String ccExpirationYear  {get;set;}
	//public String ccCVV2		    {get;set;}
	public String startMonth	    {get;set;}
	public String startYear	    	{get;set;}
	public String issueNumber	    {get;set;}
	public String nameOnCard		{get;set;}
	public String billingStreet		{get;set;}
	public String billingCity		{get;set;}
	public String billingState		{get;set;}
	public String billingZip		{get;set;}
	
	
	//==================================================
    // CONSTRUCTOR
    //==================================================
	public cc_hlpr_CreditCard(){
		this.ccType				= '';
		this.ccNumber 			= '';
		this.ccExpirationMonth	= '';
		this.ccExpirationYear	= '';
		//this.ccCVV2				= '';
		this.startMonth			= '';
		this.startYear			= '';
		this.issueNumber		= '';
		this.nameOnCard			= '';
		this.billingZip			= '';
		this.billingCity		= '';
		this.billingState		= '';
		
	}
	
	//==================================================
    // HELPER METHODS
    //==================================================
	public String getCCNumberLast4Digit(){
		if(this.ccNumber!=null &&  this.ccNumber.length()>4){
			return al.StringUtils.substring(this.ccNumber, this.ccNumber.length()-4);
		} else {
			return this.ccNumber;
		} 
	}
	
	public String getPaypalRequestString(){
		List<String> strList= new List<String>();
		if('Visa'.equalsIgnoreCase(this.ccType) ||
		   'MasterCard'.equalsIgnoreCase(this.ccType) ||
		   'Discover'.equalsIgnoreCase(this.ccType) ||
		   'Amex'.equalsIgnoreCase(this.ccType) ||
		   'Maestro'.equalsIgnoreCase(this.ccType) ||
		   'Solo'.equalsIgnoreCase(this.ccType)){
			strList.add('CREDITCARDTYPE='+Encodingutil.urlEncode(this.ccType,'UTF-8'));   	
		} 
		if(al.StringUtils.isNotEmpty(this.ccNumber)){
			strList.add('ACCT='+this.ccNumber);
		}
		if(al.StringUtils.isNotEmpty(this.ccExpirationMonth) && 
		   al.StringUtils.isNotEmpty(this.ccExpirationMonth)){
			strList.add('EXPDATE='+ Encodingutil.urlEncode(this.ccExpirationMonth+this.ccExpirationYear,'UTF-8'));
		}
		//if(al.StringUtils.isNotEmpty(this.ccCVV2)){
		//	strList.add('CVV2='+ Encodingutil.urlEncode(this.ccCVV2,'UTF-8'));
		//}
		if('Maestro'.equalsIgnoreCase(this.ccType) ||
		   'Solo'.equalsIgnoreCase(this.ccType)){
			if(al.StringUtils.isNotEmpty(this.startMonth) && 
		   	   al.StringUtils.isNotEmpty(this.startYear)){
				strList.add('STARTDATE='+Encodingutil.urlEncode(this.startMonth+this.startYear,'UTF-8'));   	
			}
			if(al.StringUtils.isNotEmpty(this.issueNumber)){
				strList.add('ISSUENUMBER='+Encodingutil.urlEncode(this.issueNumber,'UTF-8'));
			}
		}
		return al.StringUtils.joinStrings(strList, '&');
	}
}