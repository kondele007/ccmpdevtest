//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_hlpr_GenericPricingModifier extends cc_hlpr_PricingModifierBase {
	//==================================================
    // DERIVED METHODS
    //==================================================
	public override Double applyModifier(integer qty, Double listPrice, ID ruleID) {
        System.debug('--- cc_hlpr_GenericPricingModifier.applyModifier: qty=' + qty + ', listPrice=' + listPrice + ', ruleID=' + ruleID);
		Double ret = listprice;
		E_PriceModifier__c pm = null;
		List<E_PriceModifier__c> pml = getpricingModifiers(ruleID); 
		for(E_PriceModifier__c e : pml )
		{
			pm = e;
			break;
		}
		if(pm != null)
		{
			Double modifier = pm.Amount__c;
			String valueType = pm.DiscountType__c;
            System.debug('--- cc_hlpr_GenericPricingModifier.applyModifier: modifier=' + modifier + ', valueType=' + valueType);
			return qty * cc_util_CloudCraze.getModifiedPrice(listPrice, valueType, modifier); 
		}
		else
		{
			return qty * listPrice;
		}
	}
}