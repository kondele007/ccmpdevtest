//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_cnst_FedExXMLTag { 
	//==================================================
     // CONSTANTS
     //==================================================
	public static final String URIPREFIX = 'ns';
	public static final String NAMESPACEURI = 'http://fedex.com/ws/rate/v9';	
	public static final String SCHEMALOCATION = 'http://fedex.com/ws/rate/v9 RateService_v9.xsd';
	public static final String SCHEMAINSTANCE = 'http://www.w3.org/2001/XMLSchema-instance';	

	public static final String RATEREQUEST = 'RateRequest';

	public static final String WEBAUTHENTICATIONDETAIL = 'WebAuthenticationDetail';
	public static final String USERCREDENTIAL = 'UserCredential';
	public static final String KEY = 'Key';
	public static final String PASSWORD = 'Password';	

	public static final String CLIENTDETAIL = 'ClientDetail';
	public static final String ACCOUNTNUMBER = 'AccountNumber';
	public static final String METERNUMBER = 'MeterNumber'; 
	
	public static final String VERSION = 'Version';
	public static final String SERVICEID = 'ServiceId';
	public static final String MAJOR = 'Major';
	public static final String INTERMEDIATE = 'Intermediate';
	public static final String MINOR = 'Minor';
	
	public static final String REQUESTEDSHIPMENT = 'RequestedShipment';
	
	public static final String SHIPPER = 'Shipper';	
	public static final String RECIPIENT = 'Recipient';
	
	public static final String ADDRESS = 'Address';
	public static final String POSTALCODE = 'PostalCode';
	public static final String COUNTRYCODE = 'CountryCode';	
	
	public static final String PACKAGETYPE = 'PackagingType';	

	public static final String TOTALWEIGHT = 'TotalWeight';
	public static final String UNITS = 'Units';			
	public static final String VALUE = 'Value';	

	public static final String PACKAGINGTYPEVALUE = 'YOUR_PACKAGING';
	
	public static final String PACKAGECOUNT = 'PackageCount';
	public static final String PACKAGEDETAIL = 'PackageDetail';
	public static final String PACKAGEDETAILVALUE = 'INDIVIDUAL_PACKAGES';	

	public static final String REQUESTEDPACKAGELINEITEMS = 'RequestedPackageLineItems';

	public static final String GROUPPACKAGECOUNT = 'GroupPackageCount';
	public static final String SEQUENCENUMBER = 'SequenceNumber';	
	
	public static final String WEIGHT = 'Weight';	
	
	public static final String WEIGHTUOMVALUE = 'LB';	
	
	public static final String ENCODINGTYPE = 'UTF-8';
	public static final String XMLVERSION = '1.0';

	public static final String SERVICEIDVALUE = 'crs';
	public static final String MAJORVALUE = '9';
	public static final String INTERMEDIATEVALUE = '0';
	public static final String MINORVALUE = '0';

	public static final String HIGHESTSEVERITY = 'HighestSeverity';
	public static final String RATEREPLYDETAILS = 'RateReplyDetails';	
	public static final String SERVICETYPE = 'ServiceType';	
	public static final String RATEDSHIPMENTDETAILS = 'RatedShipmentDetails';	
	public static final String SHIPMENTRATEDETAIL = 'ShipmentRateDetail';	
	public static final String TOTALNETCHARGE = 'TotalNetCharge';	
	public static final String AMOUNTCURRENCY = 'Currency';
	public static final String AMOUNT = 'Amount';

	public static final String FEDEX_GROUND = 'FEDEX_GROUND';		
	public static final String FEDEX_OVERNIGHT = 'PRIORITY_OVERNIGHT,STANDARD_OVERNIGHT';

	public static final String SHIPPINGPROVIDER = 'FedEx';	
	 static testMethod void myUnitTest() {
	 	system.assert(cc_cnst_FedExXMLTag.URIPREFIX == 'ns');
	 }
}