//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_cnst_UPSXMLTag { 
	//==================================================
    // CONSTANTS
    //==================================================
	public static final String ACCESSREQUEST = 'AccessRequest';
	public static final String ACCESSLICENSENUMBER = 'AccessLicenseNumber';
	public static final String USERID = 'UserId';
	public static final String PASSWORD = 'Password';

	public static final String RATINGSERVICESELECTIONREQUEST = 'RatingServiceSelectionRequest';
	
	public static final String REQUEST = 'Request';
	public static final String REQUESTACTION = 'RequestAction';
	public static final String REQUESTOPTION = 'RequestOption';
	
	public static final String SHIPMENT = 'Shipment';
	public static final String SHIPPER = 'Shipper';	
	public static final String SHIPTO = 'ShipTo';
	public static final String SHIPFROM = 'ShipFrom';	
	
	public static final String ADDRESS = 'Address';
	public static final String POSTALCODE = 'PostalCode';
	public static final String COUNTRYCODE = 'CountryCode';	
	
	public static final String PACKAGETAG = 'Package';	
	public static final String PACKAGETYPE = 'PackagingType';	
	public static final String CODE = 'Code';
	public static final String PACKAGEWEIGHT = 'PackageWeight';
	public static final String UNITOFMEASUREMENT = 'UnitOfMeasurement';			
	public static final String WEIGHT = 'Weight';	

	public static final String ENCODINGTYPE = 'UTF-8';
	public static final String XMLVERSION = '1.0';
	
	public static final String LANGATTRIBUTE = 'xml:lang';
	public static final String LANGATTRIBUTEVALUE = 'en-US';
	
	public static final String REQUESTACTIONVALUE = 'Rate';
	public static final String REQUESTOPTIONVALUE = 'Shop';	
	
	public static final String PACKAGETYPECODEVALUE = '00';

	public static final String WEIGHTUOMVALUE = 'LBS';
	public static final String ADDTHANDLING = 'AdditionalHandling';
	
	public static final String RESPONSE = 'Response';
	public static final String RESPONSESTATUSCODE = 'ResponseStatusCode';
	public static final String RESPONSESTATUSDESCRIPTION = 'ResponseStatusDescription';	

	public static final String RATEDSHIPMENT = 'RatedShipment';	
	public static final String SERVICE = 'Service';	

	public static final String TOTALCHARGES = 'TotalCharges';	
	public static final String CURRENCYCODE = 'CurrencyCode';	
	public static final String MONETARYVALUE = 'MonetaryValue';
	
	public static final String SERVICECODE_01 = 'Next Day Air';	
	public static final String SERVICECODE_02 = '2nd Day Air';
	public static final String SERVICECODE_03 = 'Ground';		
	public static final String SERVICECODE_12 = '3 Day Select';	
	public static final String SERVICECODE_13 = 'Next Day Air Saver';
	public static final String SERVICECODE_14 = 'Next Day Air Early AM';	
	public static final String SERVICECODE_59 = '2nd Day Air AM';	

	public static final String SERVICECODE_07 = 'Worldwide Express';
	public static final String SERVICECODE_08 = 'Worldwide Expedited';
	public static final String SERVICECODE_11 = 'Standard';
	public static final String SERVICECODE_54 = 'Worldwide Express Plus';
	public static final String SERVICECODE_65 = 'Saver';				
	
	public static final String SHIPPINGPROVIDER = 'UPS';
	static testMethod void myUnitTest() {
	 	system.assert(cc_cnst_UPSXMLTag.SHIPPINGPROVIDER == 'UPS');
	 }	
}