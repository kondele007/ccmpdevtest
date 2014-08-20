//
//
//  Created by CloudCraze, LLC.
//  Copyright 2011 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//

/*
 * Interface for handling inventory/product availability.
 */
public with sharing class cc_api_Inventory {

	/*
	 * Based on a list of products, returns a map representing available quantity of those products
	 * This should be one of the top level entry methods to the API, and impl should be refactored out
	 */
	public static Map<Id,Decimal> getAvailabilityQty(List<Id> products)
	{
        Map<Id, Decimal> retList = new Map<Id, Decimal>();
        retlist = cc_api_Inventory.getAvailabilityQtyImpl(products);
		return retList;
	}
	
	/*
	 * This method should be used to deliver more complex availabilty messages, allowing UI code to remain clean
	 * e.g. At corning we had links in the middle of messages that could not be put into labels.
	 */
	public static Map<Id,String> getAvailabilityQtyStr(List<Id> products)
	{
        Map<Id, String> retList = new Map<Id, String>(); 
		List<E_ProductInventoryItem__c> invItemList = [Select e.ProductItem__c,e.QtyAvailable__c from E_ProductInventoryItem__c e where e.ProductItem__c = :products];

        for(Id p : products)
        {
			retList.put(p,'');
        }
		return retList;
	}
	
	/*
	 * Entry method for handling reductions in quantity from order purchase
	 * There should be another method for reverse process, i.e. processReturn
	 * TODO: Should be able to handle a list of products and amounts
	 * TODO: Break out the regular vs. class into two impls as with get methods
	 */
	public static void processPurchase(Id product, Decimal amt)
	{
		List<E_Product__c> prodList = [Select p.Id, p.InventoryType__c from E_Product__c p where p.Id = :product limit 1];
		List<Id> regularProducts = new List<Id>();
		
        for(E_Product__c prodItem : prodList)
        {
        	
        	regularProducts.add(prodItem.Id);
        	
        }
        
        for(Id pId : regularProducts) //TODO remove this loop when list handling is impl, right now size is always 1 so it doesnt matter
        {
			E_ProductInventoryItem__c invItem = [Select e.ProductItem__c,e.QtyAvailable__c from E_ProductInventoryItem__c e where e.ProductItem__c= :pId limit 1];
			if(invItem != null)
			{
				Decimal currentQty = invItem.QtyAvailable__c;
				if(currentQty - amt >= 0)
				{
					currentQty -= amt;
					invItem.QtyAvailable__c = currentQty;
					update invItem;
				}
				else
				{
					//throw some exception
				}
			}
        }
        
	}
	
	//BELOW METHODS SHOULD BE PROTECTED AND/OR EXTRACTED TO IMPL CLASS?
	
	/*
	 * This method is specific to corning. It distinguishes off the shelf products
	 * from training classes because inventory is handled differently.
	 */
	public static Map<Id,Decimal> getAvailabilityQtyImpl(List<Id> products)
	{
        Map<Id, Decimal> retList = new Map<Id, Decimal>(); 
        List<E_Product__c> prodList = [select InventoryType__c, (select QtyAvailable__c from Product_Inventory_Items__r) from E_Product__c where Id = :products];
        //System.debug('--- cc_api_Inventory.getAvailabilityQtyImpl: prodList=' + prodList);

        for(E_Product__c prodItem : prodList)
        {
        	Double qtyAvailable = null;
        	if(prodItem.Product_Inventory_Items__r != null && prodItem.Product_Inventory_Items__r.size() > 0)
        	{
                qtyAvailable = prodItem.Product_Inventory_Items__r[0].QtyAvailable__c;
        	}
        	
        	if(qtyAvailable == null)
        	{
        		qtyAvailable = 0;
        	}

            retList.put(prodItem.Id, qtyAvailable);
        }

		return retList;
	}
	
}