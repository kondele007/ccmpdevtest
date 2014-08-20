//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_api_PricingRuleFactory {
	Map<String, cc_hlpr_PricingModifierBase> factories = new Map<String, cc_hlpr_PricingModifierBase>
	{	/*cc_cnst_CloudCraze.RuleTypeGeneral => new cc_hlpr_GenericPricingModifier(), 
		cc_cnst_CloudCraze.RuleTypeTiered => new cc_hlpr_TieredPricingModifier(),
		cc_cnst_CloudCraze.RuleTypeStepped => new cc_hlpr_SteppedPricingModifier(),
		cc_cnst_CloudCraze.RuleTypeSteppedHistorical => new cc_hlpr_HistorySteppedpricingModifier(),
		cc_cnst_CloudCraze.RuleTypeTieredHistorical => new cc_hlpr_HistoryTieredPricingModifier(),
		cc_cnst_CloudCraze.RuleTypeCombination => new cc_hlpr_CombinationPricingModifier(),
		cc_cnst_CloudCraze.RuleTypeCartTotal => new cc_hlpr_CartTotalPricingModifier()*/
		cc_cnst_PickListConstants.RULETYPE_GENERAL=> new cc_hlpr_GenericPricingModifier(), 
		cc_cnst_PickListConstants.RULETYPE_TIERED => new cc_hlpr_TieredPricingModifier(),
		cc_cnst_PickListConstants.RULETYPE_STEPPED => new cc_hlpr_SteppedPricingModifier(),
		cc_cnst_PickListConstants.RULETYPE_STEPPEDHISTORY => new cc_hlpr_HistorySteppedpricingModifier(),
		cc_cnst_PickListConstants.RULETYPE_TIEREDHISTORY => new cc_hlpr_HistoryTieredPricingModifier(),
		cc_cnst_PickListConstants.RULETYPE_COMBINATION => new cc_hlpr_CombinationPricingModifier(),
		cc_cnst_PickListConstants.RULETYPE_CARTTOTAL => new cc_hlpr_CartTotalPricingModifier()
	};
	public static cc_api_PricingRuleFactory factory;
	/**
 	 * This method loads the Tax calculation implementation class. 
 	 */ 
	public static cc_api_PricingRuleFactory getFactory(){
		if(factory == null){
			factory = new cc_api_PricingRuleFactory();
		}  
		return factory; 
	}
	public cc_hlpr_PricingModifierBase getModifier(String ruleType)
	{
		if(factories.containsKey(ruleType))
		{
			return factories.get(ruleType);
		}
		else
		{
			return new cc_hlpr_NoDiscountModifier();
		}
	}
}