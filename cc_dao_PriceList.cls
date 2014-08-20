//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_dao_PriceList {
	//Performs a deepClone including all child price list items
	public E_PriceList__c clone(ID sourcePriceListId, boolean cloneLineItems)
	{
		//get source price list
		E_PriceList__c sourcePriceList = [Select e.Id, e.PricelistId__c, e.SupplierKey__c, e.StartDate__c, e.Name, e.EndDate__c, e.Desc__c, e.CustomerTypeCode__c, e.CurrencyISOCode__c From E_PriceList__c e where e.id = :sourcePriceListId];
		return clone(sourcePriceList, true);
	}
	public E_PriceList__c clone(E_PriceList__c sourcePriceList, boolean cloneLineItems)
	{
		E_PriceList__c destPriceList = sourcePriceList.clone(false, false);
		destPriceList.PricelistId__c = destPriceList.PricelistId__c + '_copy';
		//System.debug('--- clone from:' + sourcePriceList + ' to ' + destPriceList + ' ---');
		insert destPriceList;
		
		E_AccountGroup__c ag = new E_AccountGroup__c(AccountGroupID__c='1');
		E_AccountGroupPriceList__c agp = new E_AccountGroupPriceList__c(AccountGroup__r=ag, PriceList__c=destPriceList.id);
		insert agp;
		if(cloneLineItems)
		{
			//this is the master price list id
			ID destPriceListId = destPriceList.Id;
			double rate = 1.0;
			if(userinfo.isMultiCurrencyOrganization())
			{
				String query = 'Select c.ConversionRate From CurrencyType c where c.ISOCode =  :sourcePriceList.CurrencyISOCode__c limit 1';
				sObject ct = Database.query(query);
				
				try
				{
					rate = Double.valueOf(ct.get('ConversionRate')); 
				}
				catch(Exception e)
				{
					rate = 1.0;
				}
			}
			for(List<E_PriceListItem__c> sourcePriceListItemArray : [Select e.StartDate__c, e.Product__c, e.Price__c, e.Name, e.MinQty__c, e.MaxQty__c, e.EndDate__c, Pricelist__c From E_PriceListItem__c e where e.IsDeleted = false and e.PriceList__c = :sourcePriceList.id] )
			{
				//List<E_PriceListItem__c> destPriceListItemArray = sourcePriceListItemArray.deepClone();
				List<E_PriceListItem__c> destPriceListItemArray = new List<E_PriceListItem__c>();
				for(E_PriceListItem__c sourcePriceListItem : sourcePriceListItemArray)
				{
					E_PriceListItem__c destPriceListItem = new E_PriceListItem__c(Pricelist__c = destPriceListId);
					destPriceListItem.StartDate__c = sourcePriceListItem.StartDate__c;
					destPriceListItem.EndDate__c = sourcePriceListItem.EndDate__c;
					if(sourcePriceListItem.Price__c != null)
					{
						destPriceListItem.Price__c = sourcePriceListItem.Price__c * rate;
					}
					destPriceListItem.Product__c = sourcePriceListItem.Product__c;
					destPriceListItem.MinQty__c = sourcePriceListItem.MinQty__c;
					destPriceListItem.MaxQty__c = sourcePriceListItem.MaxQty__c;
					//destPriceListItem.Pricelist__c = destPriceListId;
					destPriceListItemArray.add(destPriceListItem);
					if(userinfo.isMultiCurrencyOrganization())
			        {
			       		sObject uObj = destPriceListItem;
			        	uObj.put('CurrencyIsoCode', sourcePriceList.CurrencyISOCode__c);
			        }
					
				}
				insert destPriceListItemArray;
			}
			
			
		}
		
		return destPriceList;
	}

    public static void removeTieredPricingForLineItem(Id priceListItemId) {
        List<E_RuleTargetPLI__c> pliRules = [select E_Rule__c from E_RuleTargetPLI__c where E_PriceListItem__c = :priceListItemId];
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
        
        delete modifiers;
        delete rules;
    }
}