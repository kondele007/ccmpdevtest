//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public class cc_hlpr_KitProduct extends cc_hlpr_CompositeProductHelperBase {
	//==================================================
    // DERIVED METHODS
    //==================================================  
	public override Decimal calAggregatedPrice(E_CartItem__c item)
	{ 
		//use aggregated extended price
		Decimal ret = 0.0;
		for(E_CartItem__c minor : item.Cart_Items__r)
		{
			ret += minor.SubAmount__c;
		}
		return ret; 
	}
	
	public override void addComponentProductsToCart(E_CartItem__c majorItem, ID accountID, Date targetDate, 
			String currencyCode, String customerType, Boolean fillPrice, Map<String, String> selectedAggregate)
	{
		Id pId = majorItem.Product__c;
		List<E_CompositeProduct__c> bps = [Select e.Quantity__c, e.Optional__c, e.Name, e.Id, e.Component__r.UnitOfMeasure__c, e.Composite__r.UnitOfMeasure__c, e.Component__r.ProductType__c,
				e.Component__c, e.Component__r.sku__c, e.Component__r.name, e.Component__r.ShortDesc__c, e.Category__c, e.Category__r.name, e.Composite__c, e.Composite__r.sku__c , 
				e.Composite__r.name From E_CompositeProduct__c e where e.Composite__c = :pId and e.Optional__c = false];
		List<E_CartItem__c> cartItemList = new List<E_CartItem__c>();
		Map<String,cc_bean_PriceInfo> pricingMap = new Map<String,cc_bean_PriceInfo>();
		Map<Id, String> id2skuMap = new Map<Id, String>();
		if( fillPrice)
		{
			List<String> productSKUList = new List<String>();
			List<Id> aggregates = new List<Id>();
			
			for(E_CompositeProduct__c bp : bps)
			{
				if(bp.Component__r.ProductType__c == 'Aggregated')
				{
					//switch it to selected aggregate
					aggregates.add(selectedAggregate.get(bp.Component__r.Id));
				}
				else
				{
					productSKUList.add(bp.Component__r.SKU__c);
				}
			}
			
			for(E_Product__c p : [select id, sku__c from E_Product__c where id in :aggregates])
			{
				productSKUList.add(p.sku__c);
				id2skuMap.put(p.id, p.sku__c);
			}
			
			pricingMap = cc_ctrl_PricingEngine.getPriceMap(productSKUList, accountID, targetDate, currencyCode, customerType);
		}
		
		decimal majorTotal = 0.0;
		for(E_CompositeProduct__c bp : bps)
		{
			E_CartItem__c ci = new E_CartItem__c();
			ci.StoreId__c = majorItem.StoreID__c;
            ci.Cart__c=majorItem.Cart__c;
            ci.Quantity__c = bp.Quantity__c; 
            ci.price__c = 0.0;
            ci.Product__c = bp.Component__c;
            String sku = bp.Component__r.SKU__c;
            if(bp.Component__r.ProductType__c == 'Aggregated')
            {
            	ci.Product__c = selectedAggregate.get(bp.Component__r.Id);
            	sku = id2skuMap.get(ci.Product__c);
            }
            if(pricingMap.containsKey(sku))
            {
            	cc_bean_PriceInfo pInfo = pricingMap.get(sku);
            	ci.price__c = pInfo.price;
            }
            ci.SubAmount__c =  ci.price__c * ci.Quantity__c;
            ci.SubAmount__c = ci.SubAmount__c.setScale(2, System.RoundingMode.UP);
            ci.cartItemType__c='Minor';
            
            ci.Category__c = bp.category__c;
                           
            ci.RequestDate__c = Date.today();
            
            ci.UnitOfMeasure__c = bp.Component__r.UnitOfMeasure__c;
            ci.ParentCartItem__c=majorItem.Id;
            cartItemList.add(ci);
            majorTotal += ci.SubAmount__c;
		}
		
		majorItem.price__c = majorTotal;
		majorItem.SubAmount__c = majorItem.price__c * majorItem.Quantity__c;
		insert cartItemList;
		update majorItem;
	}
}