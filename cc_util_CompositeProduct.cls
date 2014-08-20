//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public class cc_util_CompositeProduct {
	
	/*
		This function retrieves all current product's grand-child aggregates, and format them in a list of SelectOptions
	*/
	/* CC SaaS Mod - Schema Change - removed E_ModelValue__c
	public static List<NamedSelectOptionList> getAssemblyModelOptions(Id productId)
	{
		
		Map<String, E_Product__c> sku2ProductMap = new Map<String, E_Product__c>();
		List<NamedSelectOptionList> ret = new List<NamedSelectOptionList>();
		Map<String, List<SelectOption>> optionMap = new Map<String, List<SelectOption>>();
		List<SelectOption> aggregates = new List<SelectOption>();
		List<Id> aggreagtedChildProducts = new List<Id>();
		
		List<E_ModelOption__c> modelOptions = [Select e.Id, e.Advice__c, (Select Id, Product__c, Product__r.SKU__c, ValueText__c From E_ModelValues__r) From E_ModelOption__c e
			where e.Model__c in (Select Model__c From E_Product__c where id = :productId)];
		for(E_ModelOption__c option : modelOptions)
		{
			if(!optionMap.containsKey(option.Id))
			{
				optionMap.put(option.Id, new List<SelectOption>());
			}
			List<SelectOption> options = optionMap.get(option.Id);
			for(E_ModelValue__c value : option.E_ModelValues__r)
			{
				options.add(new SelectOption(value.product__c, value.ValueText__c ));
			}
			ret.add(new NamedSelectOptionList(option.Advice__c, options, productId));
		}
		return ret;
	}
	*/
	
	/*
		This function retrieves all cuurent aggregated product's aggregates, and format them in a list of SelectOptions
	*/
	public static List<NamedSelectOptionList> getTopLevelAggregateProducts(Id productId)
	{
		List<NamedSelectOptionList> ret = new List<NamedSelectOptionList>();
		List<SelectOption> aggregates = new List<SelectOption>();
		List<E_CompositeProduct__c> bps = [Select e.Quantity__c, e.Optional__c, e.Name, e.Id, e.Component__r.UnitOfMeasure__c, e.Composite__r.UnitOfMeasure__c, e.Component__r.ProductType__c,
				e.Component__c, e.Component__r.sku__c, e.Component__r.name, e.Component__r.ShortDesc__c, e.Category__c, e.Category__r.name, e.Composite__c, e.Composite__r.sku__c , 
				e.Composite__r.name From E_CompositeProduct__c e where e.Composite__c = :productId and e.Optional__c = false and e.Composite__r.ProductType__c = 'Aggregated'];
		for(E_CompositeProduct__c bp : bps)
		{
			aggregates.add(new SelectOption(bp.Component__c, bp.Component__r.name ));
		}
		if(aggregates.size() != 0)
		{
			ret.add(new NamedSelectOptionList(productId, aggregates, productId ));
		}
		return ret;
	}
	
	public static String getAggregatedProdustState(Id pId)
	{
		String ret = 'None';
		List<E_Product__c> pl = [select id, productType__c from E_Product__c where id = :pId and ProductType__c = 'Aggregated'];
		if(pl.size() > 0)
		{
			ret = 'Top';
		}
		else
		{
			List<E_CompositeProduct__c> cps = [select c.Component__c from E_CompositeProduct__c c where c.Composite__c = :pid and c.Component__r.ProductType__c = 'Aggregated'];
			if(cps.size() > 0)
			{
				ret = 'Child'; 
			}
		}
		return ret;
		
	}
	/*
		This function retrieves all current product's grand-child aggregates, and format them in a list of SelectOptions
	*/
	public static List<NamedSelectOptionList> getChildAggregatesSelectOption(Id productId)
	{
		Map<String, E_Product__c> sku2ProductMap = new Map<String, E_Product__c>();
		List<NamedSelectOptionList> ret = new List<NamedSelectOptionList>();
		Map<String, List<SelectOption>> optionMap = new Map<String, List<SelectOption>>();
		List<SelectOption> aggregates = new List<SelectOption>();
		List<Id> aggreagtedChildProducts = new List<Id>();
		for(E_CompositeProduct__c acp : [select c.Component__c from E_CompositeProduct__c c where c.Composite__c = :productId])
		{
			aggreagtedChildProducts.add(acp.Component__c);
		}
		List<E_CompositeProduct__c> bps = [Select e.Quantity__c, e.Optional__c, e.Name, e.Id, e.Component__r.UnitOfMeasure__c, e.Composite__r.UnitOfMeasure__c, e.Component__r.ProductType__c,
				e.Component__c, e.Component__r.sku__c, e.Component__r.name, e.Component__r.ShortDesc__c, e.Category__c, e.Category__r.name, e.Composite__c, e.Composite__r.sku__c , 
				e.Composite__r.name From E_CompositeProduct__c e where e.Composite__c in :aggreagtedChildProducts 
				and e.Optional__c = false and e.Composite__r.ProductType__c = 'Aggregated'];
		for(E_CompositeProduct__c bp : bps)
		{
			if(!optionMap.containsKey(bp.Composite__r.sku__c))
			{
				optionMap.put(bp.Composite__r.sku__c, new List<SelectOption>());
				sku2ProductMap.put(bp.Composite__r.sku__c,  bp.Composite__r);
			}
			List<SelectOption> options = optionMap.get(bp.Composite__r.sku__c);
			options.add(new SelectOption(bp.Component__c, bp.Component__r.name ));
			
		}
		for(String key : optionMap.keySet())
		{
			ret.add(new NamedSelectOptionList(sku2ProductMap.get(key).Name, optionMap.get(key), sku2ProductMap.get(key).id));
		}
		return ret;
	}
	
	/*
		This function retrieves all current product's grand-child aggregates.
	*/
	public static List<E_Product__c> getTopAggregates(Id productId)
	{
		List<E_Product__c> childProducts = new List<E_Product__c> ();
		
		List<E_CompositeProduct__c> bps = [Select e.Quantity__c, e.Optional__c, e.Name, e.Id, e.Component__r.UnitOfMeasure__c, e.Composite__r.UnitOfMeasure__c, e.Component__r.ProductType__c,
				e.Component__c, e.Component__r.sku__c, e.Component__r.name, e.Component__r.ShortDesc__c, e.Category__c, e.Category__r.name, e.Composite__c, e.Composite__r.sku__c , 
				e.Composite__r.name From E_CompositeProduct__c e where e.Composite__c = :productId 
				and e.Optional__c = false and e.Composite__r.ProductType__c = 'Aggregated'];
		for(E_CompositeProduct__c bp : bps)
		{
			
			childProducts.add(bp.Component__r);
		}
		return childProducts;
	}
	
	/*
		This function retrieves all current product's grand-child aggregates.
	*/
	public static List<E_Product__c> getChildAggregates(Id productId)
	{
		List<E_Product__c> childProducts = new List<E_Product__c> ();
		List<Id> aggreagtedChildProducts = new List<Id>();
		for(E_CompositeProduct__c acp : [select c.Component__c from E_CompositeProduct__c c where c.Composite__c = :productId])
		{
			aggreagtedChildProducts.add(acp.Component__c);
		}
		List<E_CompositeProduct__c> bps = [Select e.Quantity__c, e.Optional__c, e.Name, e.Id, e.Component__r.UnitOfMeasure__c, e.Composite__r.UnitOfMeasure__c, e.Component__r.ProductType__c,
				e.Component__c, e.Component__r.sku__c, e.Component__r.name, e.Component__r.ShortDesc__c, e.Category__c, e.Category__r.name, e.Composite__c, e.Composite__r.sku__c , 
				e.Composite__r.name, Component__r.productStatus__c From E_CompositeProduct__c e where e.Composite__c in :aggreagtedChildProducts 
				and e.Optional__c = false and e.Composite__r.ProductType__c = 'Aggregated'];
		for(E_CompositeProduct__c bp : bps)   
		{
			
			childProducts.add(bp.Component__r);
		}
		return childProducts;
	}
	
	public static String getListViewDataAsJSONString(List<E_Product__c> productList, Id accountId)
	{
		cc_hlpr_JSONObject parentObj = new cc_hlpr_JSONObject();
		for(cc_bean_ProductListViewData data : cc_util_CompositeProduct.getListViewData(productList, accountId))
		{
			cc_hlpr_JSONObject viewData = new cc_hlpr_JSONObject();
			viewData.putOpt('sku', new cc_hlpr_JSONObject.value(data.product.sku__c));
			
			viewData.putOpt('price', new cc_hlpr_JSONObject.value(data.priceBean.price));
			if(data.mediaWrapper != null)
			{
				viewData.putOpt('uri', new cc_hlpr_JSONObject.value(data.mediaWrapper.uri));
				viewData.putOpt('sourceType', new cc_hlpr_JSONObject.value(data.mediaWrapper.sourceType));
			}
			parentObj.putOpt(data.product.id, new cc_hlpr_JSONObject.value(viewData));
		}
		return parentObj.valueToString();
	}
	public static List<cc_bean_ProductListViewData> getListViewData(List<E_Product__c> productList, Id accountId)
	{
		List<cc_bean_ProductListViewData> localproductListViewData = new List<cc_bean_ProductListViewData>();
		
		List<String> skuList = new List<String>();
		List<String> productIdList = new List<String>();
		Map<Id, E_Product__c> productMap = new Map<Id,E_Product__c>();
		
		for(E_Product__c p : productList) 
		{
			skuList.add(p.sku__c);
			productIdList.add(p.id);
			productMap.put(p.id, p);
			
		}
		Map<String, cc_bean_PriceInfo> priceLineMap = cc_ctrl_PricingEngine.getPriceMap(skuList,
		                                                  accountId,
		                                                  Date.today(),
		                                                  cc_ctrl_PricingEngine.getCurrencyCode(),
		                                                  cc_ctrl_PricingEngine.getCustomerType());
		                                                  
		cc_dao_ProductMedia pmDAO = new cc_dao_ProductMedia();
		Map<Id, cc_bean_MediaWrapper> idSearchMap = pmDAO.getProductSearchMedia(productIdList);
		Map<Id, String> idSearchMap2 = pmDAO.getProductAltMessages(productIdList);

		for(E_Product__c pd : productList ) {
			cc_bean_ProductListViewData data = new cc_bean_ProductListViewData();
			data.mockProduct = new cc_bean_MockProduct(pd);
			data.product = pd;
			if(priceLineMap != null && priceLineMap.containsKey(pd.SKU__c)) {
			    data.priceBean = priceLineMap.get(pd.SKU__c);
			    System.debug('sns data.priceListItem = ' + data.priceBean);
			}
			else
			{
				//skip this product
                continue;
			}
			
			data.Alt_Message = idSearchMap2.get(pd.Id);

			System.debug('@@@@@@@@@@idSearchMaplength   :	' + idSearchMap.size());
			System.debug('@@@@@@@@@@idSearchMaplength2   :	 ' + idSearchMap2.size());
 
			System.debug('@@@@@@@@@@Alt message  :	' + data.Alt_Message);
			if(idSearchMap.get(pd.Id) != null) {
			    data.mediaWrapper = idSearchMap.get(pd.Id);
			} 
			
			localproductListViewData.add(data);
		}
		
		
		return localproductListViewData;                                                  
	}
	
	
	private static void buildChild(cc_bean_ProductComponent parentP, Map<Id, List<E_Product__c>> parentMap, Map<Id, Id> p2c, integer level)
	{
		System.debug('buildChild-> 1->' + parentP.component.id);
		System.debug('buildChild-> 2->' + parentMap.get(parentP.component.id));
		
		if((parentP.component.id != null) && (parentMap.get(parentP.component.id) != null))
		{
			for(E_Product__c p : parentMap.get(parentP.component.id))
			{
				System.debug('buildChild->' + p.Name);
				cc_bean_ProductComposite child = new cc_bean_ProductComposite(p);
				child.level = level;
				parentP.addChild(child);
				buildChild(child, parentMap, p2c, level + 1);
			}
		}
	}
	
	/*
	private static void buildChild(cc_bean_ProductComponent parentP, Map<Id, List<E_Product__c>> parentMap, Map<Id, Id> p2c, integer level)
	{
		System.debug('buildChild-> 1->' + parentP.component.id);
		System.debug('buildChild-> 2->' + p2c.get(parentP.component.id));
		System.debug('buildChild-> 3->' + parentMap.get(p2c.get(parentP.component.id)));
		if((parentP.component.id != null) && (p2c.get(parentP.component.id) != null) && (parentMap.get(p2c.get(parentP.component.id)) != null))
		{
			for(E_Product__c p : parentMap.get(p2c.get(parentP.component.id)))
			{
				System.debug('buildChild->' + p.Name);
				cc_bean_ProductComposite child = new cc_bean_ProductComposite(p);
				child.level = level;
				parentP.addChild(child);
				buildChild(child, parentMap, p2c, level + 1);
			}
		}
	}
	*/
	
	private static void displayTree(cc_bean_ProductComponent parentP)
	{
		for(cc_bean_ProductComponent c : parentP.getChildren())
		{
			System.debug('Display Tree-> level = ' + c.level + ' product name = ' + c.component.name);
			displayTree(c);
		}
	}
	
	private static List<cc_util_CompositeProduct.NamedSelectOptionList> retrieveAggregatedProduct(cc_bean_ProductComponent parentP, List<cc_util_CompositeProduct.NamedSelectOptionList> options)
	{
		if(options == null)
		{
			options = new List<NamedSelectOptionList>();
		}
		if(parentP.component.ProductType__c == 'Aggregated')
		{
			List<NamedSelectOptionList> ret = new List<NamedSelectOptionList>();
			List<SelectOption> aggregates = new List<SelectOption>();
			for(cc_bean_ProductComponent c : parentP.getChildren())
			{
				aggregates.add(new SelectOption(c.component.id, c.component.name ));
			}
			if(aggregates.size() != 0)
			{
				ret.add(new cc_util_CompositeProduct.NamedSelectOptionList(parentP.component.Name, aggregates, parentP.component.id ));
			}
			
			return ret;
		}
		else
		{
			for(cc_bean_ProductComponent c : parentP.getChildren())
			{
				
				options.addAll(retrieveAggregatedProduct(c, options));
				
			}
			return options;
		}
	}
	//==================================================
    // INNER CLASS
    //==================================================
	public class NamedSelectOptionList {
		//==================================================
    	// CONSTRUCTOR
    	//==================================================
		public NamedSelectOptionList(String name, List<SelectOption> options, Id parentId)
		{
			this.name = name;
			this.optionList = options;
			this.parentId = parentId;
		}
		//==================================================
    	// INSTANCE PROPERTIES
    	//==================================================
		public Id parentId { get; set; }
		public String name { get; set; }
		public List<SelectOption> optionList { get; set; }	
		public String selectedOption { get; set; }
	}
}