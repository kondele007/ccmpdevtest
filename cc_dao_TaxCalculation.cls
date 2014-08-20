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
 * This class is used to get the tax rate.
 */ 
public with sharing class cc_dao_TaxCalculation {
	//==================================================
    // SERVICE METHODS
    //==================================================
    /**
     * This method is used to get the tax rate.
     * 
     */    
    // TODO jlowenthal - this method should be deprecated in favor of always using a list
    public Decimal getTaxRate(cc_bean_TaxCalculation cc_bean_TaxCalculation) {
        Decimal taxRate = 0;
        List<E_TaxRate__c> taxRates = new List<E_TaxRate__c>();        
        taxRates = [Select a.TaxRate__c 
                    from E_TaxRate__c a 
                    where CountryCode__c =:cc_bean_TaxCalculation.countryCode 
                    and StateCode__c =:cc_bean_TaxCalculation.stateCode
                   ];
           for(E_TaxRate__c taxRateObject: taxRates){
                taxRate = taxRateObject.TaxRate__c;
           }
        return taxRate;
    }

    public Map<String, Decimal> getTaxRates(cc_bean_TaxCalculationList cc_bean_TaxCalculationList) {
        //return object - maps line ID to tax rate for that line
        Map<String, Decimal> taxRates = new Map<String, Decimal>();
        //map of zip code to rate
        Map<String, Decimal> zipCodeToRateMap = new Map<String, Decimal>();
		List<String> zipCodes = cc_bean_TaxCalculationList.getListOfZipCodes();
		System.debug('ZipCodes' + zipCodes);
		for(String zipCodeStr : zipCodes)
		{
			//TODO -- check if first letter is alpha, not num, and if so replace entire string with that letter
			//example -- if zipCodeStr = 'H1H', then zipCode = 'H' for query purpose
		}
        List<E_TaxRate__c> taxRateObjs = new List<E_TaxRate__c>();
        System.debug('tax cal zip codes: ' + zipCodes);
        taxRateObjs = [Select a.TaxRate__c, a.TaxRateId__c 
                       from E_TaxRate__c a 
                       where TaxRateId__c =: zipCodes
                   	  ];
		//Map zip codes to rates
		for(E_TaxRate__c taxRateObject: taxRateObjs){
			zipCodeToRateMap.put(taxRateObject.TaxRateId__c, taxRateObject.TaxRate__c);
		}
		
		//Now map lines to rates -- put zero if no tax was found for that zip code
		for(cc_bean_TaxCalculation tcBean : cc_bean_TaxCalculationList.taxCalcBeans)
		{
			if(zipCodetoRateMap.get(tcBean.zipCode) != null)
			{
				taxRates.put(tcBean.lineKey, zipCodeToRateMap.get(tcBean.zipCode));
			}
			else
			{
				taxRates.put(tcBean.lineKey, 0.0);
			}
		}
        return taxRates;
    }
}