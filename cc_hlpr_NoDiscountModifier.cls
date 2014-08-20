//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_hlpr_NoDiscountModifier extends cc_hlpr_PricingModifierBase {
	//==================================================
    // DERIVED METHODS
    //==================================================
	public override Double applyModifier(integer qty, Double listPrice, ID ruleID) {
		return qty * listprice;
	}
}