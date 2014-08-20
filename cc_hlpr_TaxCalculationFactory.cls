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
 * This class loads the implementation class for Tax calculation. 
 */ 
public with sharing class cc_hlpr_TaxCalculationFactory {
	//==================================================
    // STATIC VARIABLES
    //==================================================
	public static cc_hlpr_ITaxCalculation taxService;
	/**
 	 * This method loads the Tax calculation implementation class. 
 	 */ 
 	//==================================================
    // STATIC SERVICE METHOD
    //==================================================
	public static cc_hlpr_ITaxCalculation getTaxCalculator(){
		if(taxService == null){
			taxService = new cc_api_TaxCalculation();
			//System.debug('-----In if condition of cc_hlpr_TaxCalculationFactory -> returned cc_api_TaxCalculation');
		}  
		return taxService; 
	}
}