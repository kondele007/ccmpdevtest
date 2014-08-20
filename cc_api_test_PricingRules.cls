//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
@isTest
private class cc_api_test_PricingRules {
    static testMethod void unitTest()
    {
        //cc_test_PrepTestData.cleanCodeObject();
        //Select e.isSKURelated__c, e.SystemModstamp, e.StartDate__c, eRuleType__c, e.RuleMinQty__c, e.RuleMinAmt__c, e.RuleID__c, e.OwnerId, e.Name__c, e.Name, e.LastModifiedDate, e.LastModifiedById, e.LastActivityDate, e.IsDeleted, e.Id, e.EndDate__c, e.Enabled__c, e.CustomerTypeCode__c, e.CurrencyISOCode__c, e.CreatedDate, e.CreatedById From E_Rule__c e
        cc_test_TestDataSetup.LoadData();
        System.runas(cc_test_TestDataSetup.testUser) {
        cc_api_PricingRuleFactory factory = cc_api_PricingRuleFactory.getFactory();
        cc_hlpr_PricingModifierBase noRuleModifier = factory.getModifier(null);
        System.assert(noRuleModifier instanceof cc_hlpr_NoDiscountModifier);
        System.assertEquals(100, noRuleModifier.applyModifier(10, 10, null)) ;
        //setup testing rule types and value types
       /* try
        {
            
            insert new E_Code__c(CodeType__c='RuleType', Code__c='70', Decode__c='7', CodeID__c='RuleType_70');
            
        }
        catch(Exception e)
        {
            //System.debug('----------------------------------- Exception ------- = ' + e);
        
        }*/
        
       
        
        //Test generic rule
        //E_Rule__c genericRule = new E_Rule__c(isSKURelated__c=true, Name__c='Generic', RuleType__c=cc_cnst_PickListConstants.RULETYPE_GENERAL, RuleSource__c = 'Pricing' );
        E_Rule__c genericRule = new E_Rule__c(Relation__c=cc_cnst_PickListConstants.RULERELATION_SKU, Name__c='Generic', RuleType__c=cc_cnst_PickListConstants.RULETYPE_GENERAL, RuleSource__c = 'Pricing' );
        insert genericRule;
        //System.debug('------------------------------------------------rule source -- ' + genericRule.RuleSource__c);
        cc_hlpr_PricingModifierBase generalModifier = factory.getModifier(genericRule.RuleType__c);
        System.assert(generalModifier instanceof cc_hlpr_GenericPricingModifier);
        E_PriceModifier__c modifier1 = new E_PriceModifier__c(DiscountType__c=cc_cnst_CloudCraze.DISCOUNTTYPE_PERCENTAGE, Amount__c=10);
        insert modifier1;
        E_RulePricingModifier__c rpm1 = new E_RulePricingModifier__c(Rule__c=genericRule.Id, PriceModifier__c=modifier1.Id);
        insert rpm1;
        System.assertEquals(900, generalModifier.applyModifier(10, 100, genericRule.Id)) ;
        System.assertEquals(1000, generalModifier.applyModifier(10, 100, null)) ;
        
        //Test tiered rule
        //E_Rule__c tieredRule = new E_Rule__c(isSKURelated__c=true, Name__c='Tiered', RuleType__c=cc_cnst_PickListConstants.RULETYPE_TIERED, RuleSource__c = 'Pricing' );
        E_Rule__c tieredRule = new E_Rule__c(Relation__c=cc_cnst_PickListConstants.RULERELATION_SKU, Name__c='Tiered', RuleType__c=cc_cnst_PickListConstants.RULETYPE_TIERED, RuleSource__c = 'Pricing' );
        insert tieredRule;
        cc_hlpr_PricingModifierBase tieredModifier = factory.getModifier(tieredRule.RuleType__c);
        System.assert(tieredModifier instanceof cc_hlpr_TieredPricingModifier);
        List<E_PriceModifier__c> tiereds = new List<E_PriceModifier__c>();
        tiereds.add(new E_PriceModifier__c(DiscountType__c=cc_cnst_CloudCraze.DISCOUNTTYPE_PERCENTAGE, Amount__c=0, Quantity__c=1));
        tiereds.add(new E_PriceModifier__c(DiscountType__c=cc_cnst_CloudCraze.DISCOUNTTYPE_PERCENTAGE, Amount__c=5, Quantity__c=11));
        tiereds.add(new E_PriceModifier__c(DiscountType__c=cc_cnst_CloudCraze.DISCOUNTTYPE_PERCENTAGE, Amount__c=15, Quantity__c=21));
        tiereds.add(new E_PriceModifier__c(DiscountType__c=cc_cnst_CloudCraze.DISCOUNTTYPE_PERCENTAGE, Amount__c=20, Quantity__c=31));
        insert tiereds;
        for(E_PriceModifier__c t : tiereds)
        {
            insert new E_RulePricingModifier__c(Rule__c=tieredRule.Id, PriceModifier__c=t.Id);
        }
        System.assertEquals(100.0*5, tieredModifier.applyModifier(5, 100, tieredRule.id));
        System.assertEquals(100.0*(1-0.05)*15, tieredModifier.applyModifier(15, 100, tieredRule.id));
        System.assertEquals(100.0*(1-0.15)*25, tieredModifier.applyModifier(25, 100, tieredRule.id));
        System.assertEquals(100.0*(1-0.20)*35, tieredModifier.applyModifier(35, 100, tieredRule.id));
        System.assertEquals(100.0*(1-0.20)*45, tieredModifier.applyModifier(45, 100, tieredRule.id));
        
        //Test stepped rule
        //E_Rule__c steppedRule = new E_Rule__c(isSKURelated__c=true, Name__c='Stepped', RuleType__c=cc_cnst_PickListConstants.RULETYPE_STEPPED, RuleSource__c = 'Pricing' );
        E_Rule__c steppedRule = new E_Rule__c(Relation__c=cc_cnst_PickListConstants.RULERELATION_SKU, Name__c='Stepped', RuleType__c=cc_cnst_PickListConstants.RULETYPE_STEPPED, RuleSource__c = 'Pricing' );
        insert steppedRule;
        cc_hlpr_PricingModifierBase steppedModifier = factory.getModifier(steppedRule.RuleType__c);
        System.assert(steppedModifier instanceof cc_hlpr_SteppedPricingModifier);
        List<E_PriceModifier__c> steppeds = new List<E_PriceModifier__c>();
        steppeds.add(new E_PriceModifier__c(DiscountType__c=cc_cnst_CloudCraze.DISCOUNTTYPE_PERCENTAGE, Amount__c=0, Quantity__c=1));
        steppeds.add(new E_PriceModifier__c(DiscountType__c=cc_cnst_CloudCraze.DISCOUNTTYPE_PERCENTAGE, Amount__c=5, Quantity__c=11));
        steppeds.add(new E_PriceModifier__c(DiscountType__c=cc_cnst_CloudCraze.DISCOUNTTYPE_PERCENTAGE, Amount__c=15, Quantity__c=21));
        steppeds.add(new E_PriceModifier__c(DiscountType__c=cc_cnst_CloudCraze.DISCOUNTTYPE_PERCENTAGE, Amount__c=20, Quantity__c=31));
        insert steppeds;
        for(E_PriceModifier__c s : steppeds)
        {
            insert new E_RulePricingModifier__c(Rule__c=steppedRule.Id, PriceModifier__c=s.Id);
        }
        
        cc_bean_PriceInfo steppedPriceBean = new cc_bean_PriceInfo();
        steppedPriceBean.quantity = 1;
        steppedPriceBean.price = 100;
        steppedPriceBean = steppedModifier.applyModifierToBean(steppedPriceBean, steppedRule.id);
        System.assertEquals(100.0, steppedPriceBean.subAmount);
        
        steppedPriceBean = new cc_bean_PriceInfo();
        steppedPriceBean.quantity = 5;
        steppedPriceBean.price = 100;
        steppedPriceBean = steppedModifier.applyModifierToBean(steppedPriceBean, steppedRule.id);
        System.assertEquals(100.0*5, steppedPriceBean.subAmount);

        steppedPriceBean = new cc_bean_PriceInfo();
        steppedPriceBean.quantity = 15;
        steppedPriceBean.price = 100;
        steppedPriceBean = steppedModifier.applyModifierToBean(steppedPriceBean, steppedRule.id);
        System.assertEquals(100.0*((1-0.00)*10 + (1-0.05)*5), steppedPriceBean.subAmount);
        
        steppedPriceBean = new cc_bean_PriceInfo();
        steppedPriceBean.quantity = 25;
        steppedPriceBean.price = 100;
        steppedPriceBean = steppedModifier.applyModifierToBean(steppedPriceBean, steppedRule.id);
        System.assertEquals(100.0*((1-0.00)*10 + (1-0.05)*10 + (1-0.15)*5), steppedPriceBean.subAmount);

        steppedPriceBean = new cc_bean_PriceInfo();
        steppedPriceBean.quantity = 35;
        steppedPriceBean.price = 100;
        steppedPriceBean = steppedModifier.applyModifierToBean(steppedPriceBean, steppedRule.id);
        System.assertEquals(100.0*((1-0.00)*10 + (1-0.05)*10 + (1-0.15)*10 + (1-0.20)*5), steppedPriceBean.subAmount);

        steppedPriceBean = new cc_bean_PriceInfo();
        steppedPriceBean.quantity = 45;
        steppedPriceBean.price = 100;
        steppedPriceBean = steppedModifier.applyModifierToBean(steppedPriceBean, steppedRule.id);
        System.assertEquals(100.0*((1-0.00)*10 + (1-0.05)*10 + (1-0.15)*10 + (1-0.20)*15), steppedPriceBean.subAmount);

        System.assertEquals(100.0*5, steppedModifier.applyModifier(5, 100, steppedRule.id));
        System.assertEquals(100.0*((1-0.00)*10 + (1-0.05)*5), steppedModifier.applyModifier(15, 100, steppedRule.id));
        System.assertEquals(100.0*((1-0.00)*10 + (1-0.05)*10 + (1-0.15)*5),  steppedModifier.applyModifier(25, 100, steppedRule.id));
        System.assertEquals(100.0*((1-0.00)*10 + (1-0.05)*10 + (1-0.15)*10 + (1-0.20)*5), steppedModifier.applyModifier(35, 100, steppedRule.id));
        System.assertEquals(100.0*((1-0.00)*10 + (1-0.05)*10 + (1-0.15)*10 + (1-0.20)*15), steppedModifier.applyModifier(45, 100, steppedRule.id));
        
        //Test tiered historical rule
        //E_Rule__c tieredHistoryRule = new E_Rule__c(isSKURelated__c=true, Name__c='TieredHistory', RuleType__c=cc_cnst_PickListConstants.RULETYPE_TIEREDHISTORY, RuleSource__c = 'Pricing' );
        E_Rule__c tieredHistoryRule = new E_Rule__c(Relation__c=cc_cnst_PickListConstants.RULERELATION_SKU, Name__c='TieredHistory', RuleType__c=cc_cnst_PickListConstants.RULETYPE_TIEREDHISTORY, RuleSource__c = 'Pricing' );
        insert tieredHistoryRule;
        cc_hlpr_PricingModifierBase tieredHistoryModifier = factory.getModifier(tieredHistoryRule.RuleType__c);
        System.assert(tieredHistoryModifier instanceof cc_hlpr_HistoryTieredPricingModifier);
        List<E_PriceModifier__c> tieredHistorys = new List<E_PriceModifier__c>();
        tieredHistorys.add(new E_PriceModifier__c(DiscountType__c=cc_cnst_CloudCraze.DISCOUNTTYPE_PERCENTAGE, Amount__c=0, Quantity__c=1));
        tieredHistorys.add(new E_PriceModifier__c(DiscountType__c=cc_cnst_CloudCraze.DISCOUNTTYPE_PERCENTAGE, Amount__c=5, Quantity__c=11));
        tieredHistorys.add(new E_PriceModifier__c(DiscountType__c=cc_cnst_CloudCraze.DISCOUNTTYPE_PERCENTAGE, Amount__c=15, Quantity__c=21));
        tieredHistorys.add(new E_PriceModifier__c(DiscountType__c=cc_cnst_CloudCraze.DISCOUNTTYPE_PERCENTAGE, Amount__c=20, Quantity__c=31));
        insert tieredHistorys;
        for(E_PriceModifier__c t : tieredHistorys)
        {
            insert new E_RulePricingModifier__c(Rule__c=tieredHistoryRule.Id, PriceModifier__c=t.Id);
        }
        cc_hlpr_HistoryTieredPricingModifier tieredAccumulatedModifier = (cc_hlpr_HistoryTieredPricingModifier)tieredHistoryModifier;
        System.assertEquals(100.0*(1-0.05)*5, tieredAccumulatedModifier.applyModifier(10, 5, 100, tieredHistoryRule.id));
        System.assertEquals(100.0*(1-0.15)*15, tieredAccumulatedModifier.applyModifier(10, 15, 100, tieredHistoryRule.id));
        System.assertEquals(100.0*(1-0.20)*25, tieredAccumulatedModifier.applyModifier(10, 25, 100, tieredHistoryRule.id));
        System.assertEquals(100.0*(1-0.20)*35, tieredAccumulatedModifier.applyModifier(10, 35, 100, tieredHistoryRule.id));
        System.assertEquals(100.0*(1-0.20)*45, tieredAccumulatedModifier.applyModifier(10, 45, 100, tieredHistoryRule.id));
        
        
        //Test stepped historical rule
        //E_Rule__c steppedHistoryRule = new E_Rule__c(isSKURelated__c=true, Name__c='SteppedHistory', RuleType__c=cc_cnst_PickListConstants.RULETYPE_STEPPEDHISTORY, RuleSource__c = 'Pricing' );
        E_Rule__c steppedHistoryRule = new E_Rule__c(Relation__c=cc_cnst_PickListConstants.RULERELATION_SKU, Name__c='SteppedHistory', RuleType__c=cc_cnst_PickListConstants.RULETYPE_STEPPEDHISTORY, RuleSource__c = 'Pricing' );
        insert steppedHistoryRule;
        cc_hlpr_PricingModifierBase steppedHistoryModifier = factory.getModifier(steppedHistoryRule.RuleType__c);
        System.assert(steppedHistoryModifier instanceof cc_hlpr_HistorySteppedpricingModifier);
        List<E_PriceModifier__c> steppedHistorys = new List<E_PriceModifier__c>();
        steppedHistorys.add(new E_PriceModifier__c(DiscountType__c=cc_cnst_CloudCraze.DISCOUNTTYPE_PERCENTAGE, Amount__c=0, Quantity__c=1));
        steppedHistorys.add(new E_PriceModifier__c(DiscountType__c=cc_cnst_CloudCraze.DISCOUNTTYPE_PERCENTAGE, Amount__c=5, Quantity__c=11));
        steppedHistorys.add(new E_PriceModifier__c(DiscountType__c=cc_cnst_CloudCraze.DISCOUNTTYPE_PERCENTAGE, Amount__c=15, Quantity__c=21));
        steppedHistorys.add(new E_PriceModifier__c(DiscountType__c=cc_cnst_CloudCraze.DISCOUNTTYPE_PERCENTAGE, Amount__c=20, Quantity__c=31));
        insert steppedHistorys;
        for(E_PriceModifier__c s : steppedHistorys)
        {
            insert new E_RulePricingModifier__c(Rule__c=steppedHistoryRule.Id, PriceModifier__c=s.Id);
        } 
        cc_hlpr_HistorySteppedpricingModifier steppedAccumulatedModifier = (cc_hlpr_HistorySteppedpricingModifier)steppedHistoryModifier;
        System.assertEquals(100.0*5, steppedAccumulatedModifier.applyModifier(0, 5, 100, steppedHistoryRule.id));
        System.assertEquals(100.0*((1-0.00)*10 + (1-0.05)*5), steppedAccumulatedModifier.applyModifier(0, 15, 100, steppedHistoryRule.id));
        System.assertEquals(100.0*((1-0.00)*10 + (1-0.05)*10 + (1-0.15)*5),  steppedAccumulatedModifier.applyModifier(0, 25, 100, steppedHistoryRule.id));
        System.assertEquals(100.0*((1-0.00)*10 + (1-0.05)*10 + (1-0.15)*10 + (1-0.20)*5), steppedAccumulatedModifier.applyModifier(0, 35, 100, steppedHistoryRule.id));
        System.assertEquals(100.0*((1-0.00)*10 + (1-0.05)*10 + (1-0.15)*10 + (1-0.20)*15), steppedAccumulatedModifier.applyModifier(0, 45, 100, steppedHistoryRule.id));
        
        
        
        //E_Rule__c combinationRule = new E_Rule__c(isSKURelated__c=true, Name__c='Combination', RuleType__c=cc_cnst_PickListConstants.RULETYPE_COMBINATION, RuleSource__c = 'Pricing' );
        E_Rule__c combinationRule = new E_Rule__c(Relation__c=cc_cnst_PickListConstants.RULERELATION_SKU, Name__c='Combination', RuleType__c=cc_cnst_PickListConstants.RULETYPE_COMBINATION, RuleSource__c = 'Pricing' );
        insert combinationRule;
        cc_hlpr_PricingModifierBase combinationModifier = factory.getModifier(combinationRule.RuleType__c);
        System.assert(combinationModifier instanceof cc_hlpr_CombinationPricingModifier);
        E_PriceModifier__c comboModifier = new E_PriceModifier__c(DiscountType__c=cc_cnst_CloudCraze.DISCOUNTTYPE_PERCENTAGE, Amount__c=10);
        insert comboModifier;
        insert new E_RulePricingModifier__c(Rule__c=combinationRule.Id, PriceModifier__c=comboModifier.Id);
        
        System.assertEquals(100.0*(1-0.1)*10 ,combinationModifier.applyModifier(10, 100, combinationRule.Id));
        System.assertEquals(100.0*10 ,combinationModifier.applyModifier(10, 100, null));
        
        //E_Rule__c cartTotalRule = new E_Rule__c(isSKURelated__c=false, Name__c='CartTotal', RuleType__c=cc_cnst_PickListConstants.RULETYPE_CARTTOTAL, RuleSource__c = 'Pricing' );
        E_Rule__c cartTotalRule = new E_Rule__c(Relation__c=cc_cnst_PickListConstants.RULERELATION_SKU, Name__c='CartTotal', RuleType__c=cc_cnst_PickListConstants.RULETYPE_CARTTOTAL, RuleSource__c = 'Pricing' );
        insert cartTotalRule;
        cc_hlpr_PricingModifierBase cartTotalModifier = factory.getModifier(cartTotalRule.RuleType__c);
        System.assert(cartTotalModifier instanceof cc_hlpr_CartTotalPricingModifier);
        
        
        E_PriceModifier__c cartTotal = new E_PriceModifier__c(DiscountType__c=cc_cnst_CloudCraze.DISCOUNTTYPE_PERCENTAGE, Amount__c=10);
        insert cartTotal;
        insert new E_RulePricingModifier__c(Rule__c=cartTotalRule.Id, PriceModifier__c=cartTotal.Id);
        System.assertEquals(100.0*(1-0.1)*10 ,cartTotalModifier.applyModifier(10, 100, cartTotalRule.Id));
        System.assertEquals(100.0*10 ,cartTotalModifier.applyModifier(10, 100, null));
        }
    }
    
}