//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public abstract with sharing class cc_hlpr_PricingModifierBase {
	//==================================================
    // INTERFACE METHODS
    //==================================================
	public abstract Double applyModifier(integer qty, Double listPrice, ID ruleID);

    /**
     *  Overridden for stepped pricing
     */
    public virtual cc_bean_PriceInfo applyModifierToBean(cc_bean_PriceInfo pib, ID ruleID) {
    	return pib;
    }

	protected List<E_PriceModifier__c> getpricingModifiers(ID ruleID)
	{
		List<E_PriceModifier__c> retModifiers = new List<E_PriceModifier__c>();
		
		List<E_RulePricingModifier__c> pml = [Select e.PriceModifier__c, e.Rule__c, e.PriceModifier__r.Amount__c, e.PriceModifier__r.CartTotalAmount__c, e.PriceModifier__r.Name, e.PriceModifier__r.Quantity__c, e.PriceModifier__r.DiscountType__c from E_RulePricingModifier__c e where e.Rule__c = :ruleID order by e.PriceModifier__r.Quantity__c ];
		for(E_RulePricingModifier__c e : pml)
		{
			retModifiers.add(e.PriceModifier__r);
		}
		return retModifiers;
	}
}