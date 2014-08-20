//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_ctrl_AuthorizeHOP {
	public static final String defaultUrl = 'https://test.authorize.net/gateway/transact.dll';
	public String url { get { return defaultUrl; } set; }
	public String getLoginID() {return '5Djr26DA'; }
	public String getTransactionKey() {return '5am4F743AUnf74E7'; }
	public String amount {get; set {amount=value; generateFormData(); }}
	public String description {get; set;} 
	public String invoice { get;  set; }
	public String sequence {get; set;} 
	public String timeStamp {get; set;} 
	public String fingerprint {get; set;}
	public String testMode {get; set;}
	public String PAYMENT_FORM {get; set;}
	public String label { get; set; }
	public String returnUrl { get; set; }
	public cc_ctrl_AuthorizeHOP() 
	{
		PAYMENT_FORM='PAYMENT_FORM';
		testMode = 'false';
		label='Submit to Authorized.net';
		amount = '19.99';
		description = 'Sample Transaction';

        /*
		returnUrl = 'https://c.na7.visual.force.com/apex/AuthorizedReceipt';
		String p = ApexPages.currentPage().getHeaders().get('Referer');
		String[] p2 = p.split('://');
		String[] p3 =p2[1].split('/');
		//returnUrl = p2[0] + '://' + p3[0] + '/apex/AuthorizedReceipt';
		*/

		returnUrl = 'https://cloudcraze-demo-developer-edition.na7.force.com/apex/AuthorizedReturnPage';
		//returnUrl = 'https://c.na7.visual.force.com/apex/AuthorizedReceipt';
		
	}
	public void generateFormData()
	{
		//pre-condition: amount can't be null
		Datetime myDate = Datetime.now();
		invoice = myDate.format('yyyyMMddHHmmss');
		timeStamp = String.valueOf(System.currentTimeMillis()/1000);
		sequence = String.valueOf(Crypto.getRandomInteger());
		String inputstring = getLoginID() + '^' + sequence + '^' + timeStamp + '^' + amount + '^';
		
		cc_hlpr_CryptoExtension hmacMD5 = new cc_hlpr_CryptoExtension();
		fingerprint = hmacMD5.generateMD5FingerPrint(inputstring,getTransactionKey());
		//Crypto.generateMac('HmacSHA1', Blob.valueOf(data), Blob.valueOf(getPublicKey()))
		
	}
	
}