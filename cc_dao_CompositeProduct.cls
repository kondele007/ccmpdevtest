//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_dao_CompositeProduct {
	public static cc_bean_ProductListViewData getCompositeProduct(List<E_CompositeProduct__c> bps)
	{
		E_Product__c pd = null;
		if(bps.size() > 0)
		{
			pd = bps[0].Composite__r;
		}
		else
		{
			return null;
		}
		
		List<Id> productIdList = new List<Id> {pd.id};
		 
		cc_dao_ProductMedia pmDAO = new cc_dao_ProductMedia();
		Map<Id, cc_bean_MediaWrapper> idSearchMap = pmDAO.getProductSearchMedia(productIdList);
		cc_bean_ProductListViewData data = new cc_bean_ProductListViewData();
		data.product = pd;

		if(idSearchMap.get(pd.Id) != null) {
		    data.mediaWrapper = idSearchMap.get(pd.Id);
		}	
		return data;
	}
	
	/*
	 * gets cc_bean_ProductListViewData based on a product Id.  if the product id
	 * is for a bundle product, this returns cc_bean_ProductListViewData for the
	 * child products.
	 */
    public static List<cc_bean_ProductListViewData> getChildProducts(Id productId) {
        List<E_CompositeProduct__c> compositeProducts = [select bp.Component__c,
                                                          bp.Component__r.id,
                                                          bp.Component__r.SKU__c,
                                                          bp.Component__r.Name,
                                                          bp.Component__r.ProductType__c,
                                                          bp.Optional__c,
                                                          bp.Quantity__c,
                                                          bp.Category__c,
                                                          bp.Category__r.Name
                                      from E_CompositeProduct__c bp
                                      where bp.Composite__r.id = :productId];
        if (compositeProducts.size() != 0) {
        	List<cc_bean_ProductListViewData> childProducts = getChildProducts(compositeProducts);     
        	for (cc_bean_ProductListViewData cp : childProducts) {
        		System.debug('sns childProduct----->' + cp.product.Name);
        	}                                
            return getChildProducts(compositeProducts);
        } else {
        	return new List<cc_bean_ProductListViewData>();
        }
    }
	
	public static List<cc_bean_ProductListViewData> getChildProducts(List<E_CompositeProduct__c> bps)
	{
		List<cc_bean_ProductListViewData> result = new List<cc_bean_ProductListViewData>();
		List<Id> productIdList = new List<Id> ();
		List<String> skuList = new List<String>();
		Map<String,Double> skuMap = new Map<String,Double>();
		 
		Map<Id, E_Product__c> productMap = new Map<Id,E_Product__c>();
		for(E_CompositeProduct__c bp : bps)
		{
			//E_CartItem__c thisCartItem = productToCartListItem.get(bp.Component__r.Id);
            //is it safe to assume the quantity in the bundle product will be sku's quantity
            skuMap.put(bp.Component__r.SKU__c, bp.Quantity__c);
			productIdList.add(bp.Component__r.id);
			skuList.add(bp.Component__r.SKU__c);
		    productMap.put(bp.Component__r.Id, bp.Component__r);
		}
		
		/*Map<String, E_PriceListItem__c> priceLineMap = cc_ctrl_PricingEngine.getLowestPriceLineMap(skuList,
		                                                  cc_util_CloudCraze.getAccountID(),
		                                                  Date.today(),
		                                                  cc_ctrl_PricingEngine.getCurrencyCode(),
		                                                  cc_ctrl_PricingEngine.getCustomerType());*/
		                                                  
		   Map<String, cc_bean_PriceInfo> priceLineMap = cc_ctrl_PricingEngine.getPriceMap(skuMap, cc_util_CloudCraze.getAccountID(), null, null, null);            
            
		                                                  
		 
		for(E_CompositeProduct__c bp : bps ) {
			cc_bean_ProductListViewData data = new cc_bean_ProductListViewData();
			data.product = bp.Component__r;
			if(priceLineMap != null && priceLineMap.containsKey(bp.Component__r.SKU__c)) {
			    //data.priceListItem = priceLineMap.get(bp.Component__r.SKU__c);
			    data.priceBean = priceLineMap.get(bp.Component__r.SKU__c);
			    if(data.priceBean!=null){
			    	data.priceListItem=data.priceBean.priceListItem;
			    }
			    data.optional = bp.Optional__c;
			    data.qty = bp.Quantity__c.intValue();
			    data.category = bp.Category__r.name;
			    data.categoryId = bp.Category__c;
			    bp.ExtendedPrice__c = data.priceListItem.price__c * data.qty;
			    data.compositeProductObj = bp; 
			    result.add(data);
			}
			else
			{
				//skip this product
                continue;
			}
			
		}
		return result;
	}
	
	public static List<cc_bean_ProductListViewData> getCompositeOptionalProducts(String bundleId)
	{
		List<cc_bean_ProductListViewData> localproductListViewData = new List<cc_bean_ProductListViewData>();
		List<E_CompositeProduct__c> bps = [Select e.Quantity__c, e.Optional__c, e.Name, e.Id, e.Component__r.UnitOfMeasure__c, e.Composite__r.UnitOfMeasure__c, e.Component__r.ProductType__c,
				e.Component__c, e.Component__r.sku__c, e.Component__r.name, e.Component__r.ShortDesc__c, e.Category__c, e.Category__r.name, e.Composite__c, e.Composite__r.sku__c , 
				e.Composite__r.name From E_CompositeProduct__c e where e.Composite__c = :bundleId and e.Optional__c = true];
		List<String> skuList = new List<String>();
		List<String> productIdList = new List<String>();
		Map<Id, E_Product__c> productMap = new Map<Id,E_Product__c>();
		List<E_Product__c> productList = new List<E_Product__c>();
		for(E_CompositeProduct__c bp : bps) 
		{
			skuList.add(bp.Component__r.sku__c);
			productIdList.add(bp.Component__c);
			productMap.put(bp.Component__c, bp.Component__r);
			productList.add(bp.Component__r);
		}
		Map<String, E_PriceListItem__c> priceLineMap = cc_ctrl_PricingEngine.getLowestPriceLineMap(skuList,
		                                                  cc_util_CloudCraze.getAccountID(),
		                                                  Date.today(),
		                                                  cc_ctrl_PricingEngine.getCurrencyCode(),
		                                                  cc_ctrl_PricingEngine.getCustomerType());
		                                                  
		cc_dao_ProductMedia pmDAO = new cc_dao_ProductMedia();
		Map<Id, cc_bean_MediaWrapper> idSearchMap = pmDAO.getProductSearchMedia(productIdList);
		Map<Id, String> idSearchMap2 = pmDAO.getProductAltMessages(productIdList);
		for(E_CompositeProduct__c bp : bps) {
			E_Product__c pd = bp.Component__r;
			cc_bean_ProductListViewData data = new cc_bean_ProductListViewData();
			data.product = pd;
			data.qty = bp.Quantity__c.intValue();
			if(priceLineMap != null && priceLineMap.containsKey(pd.SKU__c)) {
			    data.priceListItem = priceLineMap.get(pd.SKU__c);
			    System.debug('sns data.priceListItem = ' + data.priceListItem);
			}
			else
			{
				//skip this product
                continue;
			}
			//		  productPricemap.put(pd.Id, data.priceListItem.Price__c);

			/* String idSearchMapString = idSearchMap.get(pd.Id);
			   List<String> splitted = idSearchMapString.split(':',2);*/
			
			data.Alt_Message = idSearchMap2.get(pd.Id);

			System.debug('@@@@@@@@@@idSearchMaplength   :	' + idSearchMap.size());
			System.debug('@@@@@@@@@@idSearchMaplength2   :	 ' + idSearchMap2.size());
 
			System.debug('@@@@@@@@@@Alt message  :	' + data.Alt_Message);

			/*Id attId;
			  if(splitted.get(0).length() >= 15)
			  {
			  attId = splitted.get(0);
			  }

			  if(splitted.get(1).length() > 0)
			  {
			  data.Alt_Message = splitted.get(1);
			  }
			*/
			if(idSearchMap.get(pd.Id) != null) {
			    data.mediaWrapper = idSearchMap.get(pd.Id);
			} 
			
			localproductListViewData.add(data);
		}
		
		
		return localproductListViewData;                                                  
	}
	
	public static List<cc_bean_ProductListViewData> getCompositeNonOptionalProducts(String bundleId)
	{
		List<cc_bean_ProductListViewData> localproductListViewData = new List<cc_bean_ProductListViewData>();
		List<E_CompositeProduct__c> bps = [Select e.Quantity__c, e.Optional__c, e.Name, e.Id, e.Component__r.UnitOfMeasure__c, e.Composite__r.UnitOfMeasure__c, e.Component__r.ProductType__c,
				e.Component__c, e.Component__r.sku__c, e.Component__r.name, e.Component__r.ShortDesc__c, e.Category__c, e.Category__r.name, e.Composite__c, e.Composite__r.sku__c , 
				e.Composite__r.name From E_CompositeProduct__c e where e.Composite__c = :bundleId and e.Optional__c = false];
		for(E_CompositeProduct__c bp : bps)
		{
			cc_bean_ProductListViewData data = new cc_bean_ProductListViewData();
			data.qty = bp.Quantity__c.intValue();
			data.product = bp.Component__r;
			data.category = bp.Category__r.name;
			localproductListViewData.add(data);
		}
		return localproductListViewData;                                                  
	}
	
	public static List<cc_bean_ProductListViewData> getCompositeProducts(String categoryName, String productType)
	{
		List<E_ProductCategory__c> pcs= [Select e.Product__c, e.Product__r.sku__c, e.Product__r.name From E_ProductCategory__c e where e.Category__r.name= :categoryName and e.Product__r.ProductType__c= :productType and e.Product__r.productstatus__c = 'Released'];
		List<String> pIds = new List<String>();
		List<String> skuList = new List<String>();
		List<E_Product__c> productList = new List<E_Product__c>();
		for(E_ProductCategory__c pc : pcs)
		{
			pIds.add(pc.Product__c);
			skuList.add(pc.Product__r.sku__c);
			productList.add(pc.Product__r);
		}
		Map<String, Integer> mapLines = new Map<String, Integer>();
		List<E_CompositeProduct__c> bps = [Select e.Quantity__c, e.Optional__c, e.Name, e.Id, e.Component__r.UnitOfMeasure__c, e.Composite__r.UnitOfMeasure__c,e.Component__c, e.Category__c, e.Category__r.name, e.Composite__c, e.Composite__r.sku__c , e.Composite__r.name, e.Component__r.ProductType__c From E_CompositeProduct__c e where e.Composite__c in :pIds];
		List<cc_bean_ProductListViewData> result = new List<cc_bean_ProductListViewData>();
		
		
		Map<Id, E_Product__c> productMap = new Map<Id,E_Product__c>();
		for(E_CompositeProduct__c bp : bps)
		{
			
		    productMap.put(bp.Composite__r.Id, bp.Composite__r);
		    if(bp.category__r.name == 'Handsets')
		    {
		    	Integer lines = 0;
		    	if(!mapLines.containsKey(bp.Composite__c))
		    	{
		    		mapLines.put(bp.Composite__c, lines);
		    	}
		    	lines = mapLines.get(bp.Composite__c);
		    	lines += bp.Quantity__c.intValue();
		    	mapLines.put(bp.Composite__c, lines);
		    }
		}
		
		Map<String, E_PriceListItem__c> priceLineMap = cc_ctrl_PricingEngine.getLowestPriceLineMap(skuList,
		                                                  cc_util_CloudCraze.getAccountID(),
		                                                  Date.today(),
		                                                  cc_ctrl_PricingEngine.getCurrencyCode(),
		                                                  cc_ctrl_PricingEngine.getCustomerType());
		
		for(E_Product__c bp : productList ) {
			cc_bean_ProductListViewData data = new cc_bean_ProductListViewData();
			data.product = bp;
			if(priceLineMap != null && priceLineMap.containsKey(bp.SKU__c)) {
			    data.priceListItem = priceLineMap.get(bp.SKU__c);
			    
			    data.lines = mapLines.get(bp.id);
			    data.voiceMail = 'Yes' ;
			    data.expandable = 'No';
			    result.add(data);
			}
			else
			{
				//skip this product
                continue;
			}
			
		}
		return result;
	}

}