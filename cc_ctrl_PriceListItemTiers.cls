//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_ctrl_PriceListItemTiers {
	//==================================================
    // INNWE CLASS
    //==================================================
    public class TierStruct {
    	//==================================================
    	// INSTANCE PROPERTIES
    	//==================================================
        public String low {get;set;}
        public String valueType {get;set;} 
        public double amount {get;set;}
        //==================================================
    	// CONSTRUCTOR
    	//==================================================
        public TierStruct() {
            low=null;
            valueType = '';
            amount=0.0;
        }
    }
	//==================================================
    	// INSTANCE PROPERTIES
    	//==================================================
    public ApexPages.StandardController controller {get;set;}
    public List<TierStruct> tierValues {get; set;}
    public Integer tierCount { get { return 10; } set; }
    public E_RuleTargetPLI__c pliRule {get;set;}
    public E_Rule__c rule {get;set;}
    
    public Boolean showRemoveButton {
        get {
            if(rule == null) {
                showRemoveButton = false;
            } else {
                showRemoveButton = true;
            }
            return showRemoveButton;
        }
        set;
    }

    public String tierType {
        get {
            if(tierType == null) {
                tierType = 'Tiered';
            }
            return tierType;
        }
        set;
    }
    
    //==================================================
    // CONSTRUCTOR
    //==================================================
    public cc_ctrl_PriceListItemTiers(ApexPages.StandardController sc) {
        controller = sc;
        initTierValues();
    }
    
    //==================================================
    // HELPER METHODS
    //==================================================
    public void initTierValues() {
        tierValues = new List<TierStruct>();

        List<E_RuleTargetPLI__c> pliRules = [select E_Rule__c from E_RuleTargetPLI__c where E_PriceListItem__c = :controller.getId()];
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'pliRules: ' + pliRules));
        if(pliRules != null && pliRules.size() > 0) {
            pliRule = pliRules[0];
            rule = [select Name, RuleType__c from E_Rule__c where Id = :pliRule.E_Rule__c][0];
            tierType = rule.RuleType__c;
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'rule id=' + pliRule.E_Rule__c + ', rule=' + rule));
        }
        
        if(rule != null) {
            List<E_RulePricingModifier__c> rpms = [select PriceModifier__r.Amount__c, PriceModifier__r.Quantity__c, PriceModifier__r.DiscountType__c from E_RulePricingModifier__c where Rule__c = :rule.Id];
            for(E_RulePricingModifier__c rpm : rpms) {
                TierStruct tier = new TierStruct();
                Decimal qty = rpm.PriceModifier__r.Quantity__c;
                if(qty != null) {
                    tier.low = qty.setScale(0).format();
                } else {
                    tier.low = null;
                }
                tier.valueType=rpm.PriceModifier__r.DiscountType__c;
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'for qty ' + tier.low + ' valueType=' + valueType));
                tier.amount=rpm.PriceModifier__r.Amount__c;
                tierValues.add(tier);
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'added tier: ' + tier));
            }
        }
        
        for(integer i = tierValues.size(); i < tierCount; i++) {
            tierValues.add(new TierStruct());
        }
    }
    
    private void insertTiers(E_PriceListItem__c item) {
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'inserting tiers'));

        // create the pricing rule
        rule = new E_Rule__c(
                Relation__c='Pricelist Item',
                Name__c='PLI-' + item.Name + '-tiered-pricing-rule',
                RuleType__c=tierType,
                CurrencyISOCode__c=item.Pricelist__r.CurrencyISOCode__c,
                CustomerTypeCode__c=item.Pricelist__r.CustomerTypeCode__c,
                RuleSource__c='Pricing',
                Enabled__c=true);
        insert rule;
        
        // create a price modifier record for each tier
        List<E_PriceModifier__c> pms = new List<E_PriceModifier__c>();
        for(TierStruct tier:tierValues) {
            if(tier.low == null || tier.low.trim().length()==0) {
                break;
            }
            
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'Tier: low=' + tier.low + ', valueType=' + tier.valueType + ', amount=' + tier.amount));

            E_PriceModifier__c modifier = new E_PriceModifier__c(DiscountType__c=tier.valueType, 
                Amount__c=tier.amount, Quantity__c=double.valueOf(tier.low));
            pms.add(modifier);
        }
        insert pms;

        // tie the pricing modifiers to the rule
        List<E_RulePricingModifier__c> rpms = new List<E_RulePricingModifier__c>();
        for(E_PriceModifier__c pm : pms) {
            rpms.add(new E_RulePricingModifier__c(Rule__c=rule.Id, PriceModifier__c=pm.Id));
        }
        insert(rpms);
        
        // tie the rule to the pricelist item
        pliRule = new E_RuleTargetPLI__c(E_Rule__c=rule.Id, E_PriceListItem__c=item.Id);
        insert pliRule;
    }
    
    private void updateTiers(E_PriceListItem__c item, E_Rule__c rule) {
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'updating tiers'));
        removeTieredPricing();
        insertTiers(item);
    }
    
    private void removeTieredPricing() {
        List<E_RuleTargetPLI__c> pliRules = [select E_Rule__c from E_RuleTargetPLI__c where E_PriceListItem__c = :controller.getId()];
        List<Id> ruleIds = new List<Id>();
        for(E_RuleTargetPLI__c pliRule : pliRules) {
            ruleIds.add(pliRule.E_Rule__c);
        }
        List<E_Rule__c> rules = [select Id from E_Rule__c where Id in :ruleIds];
        
        List<E_RulePricingModifier__c> rpms = [select PriceModifier__c from E_RulePricingModifier__c where Rule__c in :ruleIds];
        List<Id> modifierIds = new List<Id>();
        for(E_RulePricingModifier__c rpm : rpms) {
            modifierIds.add(rpm.PriceModifier__c);
        }
        List<E_PriceModifier__c> modifiers = [select Id from E_PriceModifier__c where Id in :modifierIds];
        
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'Removing modiers: ' + modifiers));
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'Removing rules: ' + rules));
        delete modifiers;
        delete rules;
        
        pliRule = null;
        rule = null;
        
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, 'Tiered pricing has been removed for this item'));
    }
	
	//==================================================
    // SERVICE METHODS
    //==================================================
    public void saveTiers() {
        ApexPages.getMessages().clear();
        
        E_PriceListItem__c item = [select Name, Pricelist__r.CurrencyISOCode__c, Pricelist__r.CustomerTypeCode__c from E_PriceListItem__c where Id = :controller.getId()][0];
        
        if(rule != null) {
            updateTiers(item, rule);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, tierType + ' pricing has been updated for this item'));
        } else {
            insertTiers(item);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, tierType + ' pricing has been added for this item'));
        }
    }
        
    public void removeTiers() {
        String tierTypeString = tierType;
        removeTieredPricing();
        initTierValues();
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, tierTypeString + ' pricing has been removed for this item'));
    }

    
}