//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_hlpr_HistorySteppedpricingModifier extends cc_hlpr_SteppedPricingModifier {
	//==================================================
    // SERVICE METHODS
    //==================================================
	public Double applyModifier(integer accumulatedQty, integer qty, Double listPrice, Id ruleId)
	{ 
		Double unitPrice = super.applyModifier(accumulatedQty+qty, listPrice, ruleId) / (accumulatedQty+qty);
		return unitPrice * qty;
	}
}