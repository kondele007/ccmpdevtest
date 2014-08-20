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
 * This class provides the implementation for the tax calculation.
 * 
 */
public with sharing class cc_api_TaxCalculation implements cc_hlpr_ITaxCalculation { 
	//==================================================
    // DERIVED METHODS
    //==================================================
	/**
     * This method is used to calculate the tax amount.
     */ 
	// TODO jlowenthal - we should deprecate this method - instead always use a list bean
	// Also this method is misnamed - it gets the tax rate * subtotal, the DAO gets the rate
	public Decimal getTaxRate(cc_bean_TaxCalculation cc_bean_TaxCalculation){
		Decimal taxAmount = 0;
		Double cartTotal = cc_bean_TaxCalculation.cartTotal;
		if(cartTotal > 0 && al.StringUtils.isNotBlank(cc_bean_TaxCalculation.stateCode) && al.StringUtils.isNotBlank(cc_bean_TaxCalculation.countryCode)){
			cc_dao_TaxCalculation cc_dao_TaxCalculation = new cc_dao_TaxCalculation(); 
			Decimal taxRate = cc_dao_TaxCalculation.getTaxRate(cc_bean_TaxCalculation);
			if (taxRate > 0) {
				taxRate *= cartTotal;
				taxAmount = taxRate.divide(100, 2);
			}
		}
		//System.debug('-----taxAmount in cc_api_TaxCalculation.getTaxRate = ' + taxAmount);		
		return taxAmount; 
	}
	
	// TODO jlowenthal - this method is misnamed but for now is consistent with above original name
	// should really be something like getSubTotalsWithTax()
	public List<Decimal> getTaxRates(cc_bean_TaxCalculationList cc_bean_TaxCalculationList){
		List<Decimal> taxAmounts = new List<Decimal>();
		cc_dao_TaxCalculation cc_dao_TaxCalculation = new cc_dao_TaxCalculation(); 
		Map<String, Decimal> taxRates = cc_dao_TaxCalculation.getTaxRates(cc_bean_TaxCalculationList);
		//System.debug('I JUST CALLED DAO.getTaxRates. My map is: ' + taxRates);
		for(cc_bean_TaxCalculation tcb : cc_bean_TaxCalculationList.taxCalcBeans)
		{
			//System.debug('TaxRates: ' + taxRates);
			//System.debug(''+tcb.subTotal);
			Decimal priceWithTax = (taxRates.get(tcb.lineKey) * tcb.subTotal).divide(100, 2);
			taxAmounts.add(priceWithTax);
		}
		return taxAmounts; 
	}
}