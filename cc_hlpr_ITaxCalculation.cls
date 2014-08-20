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
 * This interface provides tax calculation service.
 */
public interface cc_hlpr_ITaxCalculation {
    /**
     * This method is used to get the tax rate.
     */
    Decimal getTaxRate (cc_bean_TaxCalculation cc_bean_TaxCalculation);
    List<Decimal> getTaxRates(cc_bean_TaxCalculationList cc_bean_TaxCalculationList);
}