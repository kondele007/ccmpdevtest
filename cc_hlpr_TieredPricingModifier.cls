//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public virtual with sharing class cc_hlpr_TieredPricingModifier extends cc_hlpr_PricingModifierBase { 
	//==================================================
    // DERIVED METHODS
    //==================================================
	public override Double applyModifier(integer qty, Double listPrice, ID ruleID) {
		Double ret = listprice;
		Double modifier = 0;
		String valueType = null;
		List<E_PriceModifier__c> pml = getpricingModifiers(ruleID); 
		for(Integer i =0; i < pml.size(); i++)
		{
			E_PriceModifier__c pm = pml.get(i);
			Double min = pm.Quantity__c;
			Double max = cc_cnst_CloudCraze.MaxQty; 
			if(i < pml.size()-1)
			{
				max = pml.get(i+1).Quantity__c;
			}
			if((qty == min) || (qty > min && qty < max))
			{
				modifier = pm.Amount__c;
				valueType = pm.DiscountType__c;
				break;
			}	
		}
		return qty * cc_util_CloudCraze.getModifiedPrice(listPrice, valueType, modifier);
		
	}
}