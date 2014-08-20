//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
/**
 * This class holds the details for the tax calculation.
 * 
 */
public with sharing class cc_bean_TaxCalculation {
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public String zipCode {get; set;}
	public Double subTotal {get; set;}
	public String lineKey {get; set;}
	public Double totalWithTax {get; set;}
	
	// MB added to get classes to compile
	// TODO jlowenthal - we should deprecate below fields.
	// more often than not you have more complex tax logic than a cart total you use a tax jurisdiction code (zip code) rather than state code.
	public Double cartTotal {get; set;}
	public String countryCode {get; set;}
	public String stateCode {get; set;}
}