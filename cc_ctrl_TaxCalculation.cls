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
 * This controller class calls the business layer to calculate the tax amount.
 * 
 */
public with sharing class cc_ctrl_TaxCalculation {
	//==================================================
    // CONSTANTS
    //==================================================
	public static final String LINE_KEY_SHIPPING = '-1';
	public static final String LINE_KEY_CART_TOTAL = '-2';
	//==================================================
    // SERVICE METHODS
    //==================================================
    /**
     * This method is used to get the tax amount.
     */ 
    // TODO jlowenthal - deprecate this method - should always just do list calculation
    public Decimal getTaxAmount(cc_bean_TaxCalculation cc_bean_TaxCalculation) {
        Decimal taxAmount = 0;
        try {
            cc_hlpr_ITaxCalculation taxCal = cc_hlpr_TaxCalculationFactory.getTaxCalculator();
            taxAmount = taxCal.getTaxRate(cc_bean_TaxCalculation);          
        } catch (System.Exception e) {
            //System.debug('ERROR: '+ e);
        }
        return taxAmount;
    }
    
    public List<Decimal> getTaxAmounts(cc_bean_TaxCalculationList cc_bean_TaxCalculationList) {
        List<Decimal> taxAmounts = new List<Decimal>();
        try {
            cc_hlpr_ITaxCalculation taxCal = cc_hlpr_TaxCalculationFactory.getTaxCalculator();
            taxAmounts = taxCal.getTaxRates(cc_bean_TaxCalculationList);          
        } catch (System.Exception e) {
            //System.debug('ERROR: '+ e);
        }
        return taxAmounts;
    }
}