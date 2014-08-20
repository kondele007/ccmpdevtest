//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public virtual with sharing class cc_hlpr_SteppedPricingModifier extends cc_hlpr_PricingModifierBase
{
	//==================================================
    // DERIVED METHODS
    //==================================================
	public override Double applyModifier(integer qty, Double listPrice, ID ruleID)
	{
		Double sum = 0.0;
		Double temp = listprice;
		Double modifier = 0;
		String valueType = null;
		List<E_PriceModifier__c> pml = getpricingModifiers(ruleID); 
		for(Integer i =0; i < pml.size(); i++)
		{
			E_PriceModifier__c pm = pml.get(i);
			
			Double min =  pm.Quantity__c;
			Double max = cc_cnst_CloudCraze.MaxQty; 
			
			//add the listprice times least bound defined for stepped pricing.
			if(i==0)
			{
				Double stepQty = Math.min(qty, min-1);
				sum+=listPrice*stepQty;
				if(stepQty == qty)
				{
					break;
				}
			}
			
			if(i < pml.size()-1)
			{
				max = pml.get(i+1).Quantity__c;
			}
			modifier = pm.Amount__c;
			valueType = pm.DiscountType__c; 
			temp = cc_util_CloudCraze.getModifiedPrice(listPrice, valueType, modifier);
			if((qty == min) || (qty > min && qty < max))
			{
				sum += temp * (qty-min+1);
				break;
			}
			else 
			{
				sum += temp * (max-min);
			}
				
		}
		return sum; 
	}

    public override cc_bean_PriceInfo applyModifierToBean(cc_bean_PriceInfo pib, ID ruleID)
    {
    	System.debug('--- cc_hlpr_SteppedPricingModifier.applyModifierToBean: inputs: pib=' + pib + ', ruleID=' + ruleID);

        Double qty = pib.quantity;
        Double listPrice = pib.price;
        Double sum = 0.0;
        Double modifiedPrice = listprice;
        Double modifier = 0;
        String valueType = null;
        pib.subAmount = 0.0;
        
        List<E_PriceModifier__c> pml = getpricingModifiers(ruleID);

        for(Integer i = 0; i < pml.size(); i++)
        {
            E_PriceModifier__c pm = pml.get(i);
            
            Double stepSum = 0.0;
            Double stepQty = 0.0;
            Double min = pm.Quantity__c;
            Double max = cc_cnst_CloudCraze.MaxQty;
            Boolean breakTime = false;
            
            System.debug('--- cc_hlpr_SteppedPricingModifier.applyModifierToBean: i=' + i + ', stepSum=' + stepSum + ', stepQty=' + stepQty + ', min=' + min + ', max=' + max);
            //add the listprice times least bound defined for stepped pricing.
            if(i == 0)
            {
            	stepQty = Math.min(qty, min - 1); // returns the lower of the two
                stepSum = listPrice * stepQty;
	            pib.priceArray.add(listPrice);
	            pib.subAmountArray.add(stepSum);
	            pib.quantityArray.add(min - 1);
                pib.subAmount += stepSum;
                
                if(stepQty == qty)
                {
                	break;
                }
            }
            
            if(i < pml.size() - 1)
            {
                max = pml.get(i+1).Quantity__c;
            }

            modifier = pm.Amount__c;
            valueType = pm.DiscountType__c; 
            modifiedPrice = cc_util_CloudCraze.getModifiedPrice(listPrice, valueType, modifier);
            
            if((qty == min) || (qty > min && qty < max))
            {
            	stepQty = qty - min + 1;
            	breakTime = true;
            }
            else
            {
                stepQty = max - min;
            }
            
            stepSum = modifiedPrice * stepQty;
            System.debug('--- cc_hlpr_SteppedPricingModifier.applyModifierToBean: modifiedPrice=' + modifiedPrice + ', stepQty=' + stepQty + ', stepSum=' + stepSum);
            pib.priceArray.add(modifiedPrice);
            pib.subAmountArray.add(stepSum);
            pib.quantityArray.add(stepQty);
            pib.subAmount += stepSum;

            System.debug('--- cc_hlpr_SteppedPricingModifier.applyModifierToBean: pib=' + pib);

            if(breakTime) {
            	break;
            }
        }
        
        return pib;
    }
}