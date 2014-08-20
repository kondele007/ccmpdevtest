//
//
//	Created by CloudCraze, LLC.
//	Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//	Redistribution and use in source or binary forms, with or without 
//	modification is PROHIBITED.
//
//
public with sharing class cc_hlpr_CyberSourceHOP {
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
	public String transactionType { get; set; }
	public String amount { get; set; }
	public String currencyString { get; set; }
	public String timeString { get; set; }
	public String publicDigest;
	public String publicSubscriptionDigest;
	//==================================================
    // CONSTRUCTOR
    //==================================================
	public cc_hlpr_CyberSourceHOP()
	{		
		//TODO jll remove hard coding
		//transactionType = 'authorization';
		transactionType = 'subscription';
		currencyString='usd';
		timeString = String.valueOf(System.currentTimeMillis());
	}
	
	//==================================================
    // HELPER METHODS
    //==================================================
	public String ipAddressLocationKey {
		get {return cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY;} set; }
		
	//todo jll pull from storefront
	public String getMerchantID() {
		return 'cloudcrazedev';
	}

	//todo jll pull from cert
	public String getSharedSecret() {
		return 'MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDJfpelduCvHP0HSfwhAiEH5Djzvtc118oMPv7tpaAMzzfXyIg1eIKQQO16pkJtkWwuqTUCiCJqywmgbfDMbSyALDKo7SQFCXdZ64u+84Dre/30tgXDlpTrUY+uYxYkd55ETLfjd80FbPGFdnkes/ZZS3sE/8W818ajV26cZ2JcFQIDAQAB';
	}

	//todo jll pull from storefront
	public String getSerialNumber() {
		return '2977081942350176056165';
	}
	
	//todo jll refactor this method to combine with getPublicDigest
	public String getPublicSubscriptionDigest()
	{
		createSubscriptionSignature();
		return publicSubscriptionDigest;
	}
	public String getPublicDigest()
	{
		createSignature();
		return publicDigest;
	}

	//todo jll refactor to combine with createSignature to do all fields at once
	public void createSubscriptionSignature()
	{
		try
		{			
			//TODO jll remove hard coding, pull from storefront
			String amtString = amount; //this is because this is on demand subscription
			String subsStartDate = '20100320'; //no start date
			String subsNumPayments = '0'; //on demand, so no set number of payments
			String subsFrequency = 'on-demand';
			String subsAutoRenew = 'false';
		
			String customValues = amtString + subsStartDate + subsFrequency + subsNumPayments + subsAutoRenew;
			publicSubscriptionDigest = EncodingUtil.base64Encode(Crypto.generateMac('HmacSHA1', Blob.valueOf(customValues), Blob.valueOf(getSharedSecret())));
			publicSubscriptionDigest = publicSubscriptionDigest.replaceAll('\n', '');
		}
		catch(Exception e)
		{
			System.debug('----JLL CYBERSOURCE-------An exception ocurred while creating signature: ' + e.getMessage());
		}
	}
		
	public void createSignature()
	{
		try
		{
			if (currencyString == null) {
				currencyString = 'usd';
			}
		
			String customValues = getMerchantID() + '0' + currencyString + timeString;
			publicDigest = EncodingUtil.base64Encode(Crypto.generateMac('HmacSHA1', Blob.valueOf(customValues), Blob.valueOf(getSharedSecret())));
			publicDigest = publicDigest.replaceAll('\n', '');
		}
		catch(Exception e)
		{
			System.debug('----JLL CYBERSOURCE-------An exception ocurred while creating signature: ' + e.getMessage());
		}
	}
}