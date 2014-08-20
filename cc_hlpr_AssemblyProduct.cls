//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without
//  modification is PROHIBITED.
//
//
public class cc_hlpr_AssemblyProduct extends cc_hlpr_CompositeProductHelperBase {
    //==================================================
    // INSTANCE PROPERTIES
    //==================================================
	public List<cc_util_CompositeProduct.NamedSelectOptionList> assemblyModelOptionValues { get; set; }
	//==================================================
    // CONSTRUCTOR
    //==================================================
	public cc_hlpr_AssemblyProduct()
	{
		super();
		assemblyModelOptionValues = new List<cc_util_CompositeProduct.NamedSelectOptionList>();
		
	}
	 
	//==================================================
    // DERIVED METHODS
    //==================================================
	public override Decimal calAggregatedPrice(E_CartItem__c item)
	{
		Decimal ret = 0.0;
		for(E_CartItem__c minor : item.Cart_Items__r)
		{
			ret += minor.price__c * minor.quantity__c;
		}
		return ret;
	}
	
	public override void addComponentProductsToCart(E_CartItem__c majorItem, ID accountID, Date targetDate, String currencyCode, String customerType, Boolean fillPrice, Map<String, String> selectedAggregate)
	{
		System.debug('roy lou Cart-->' + majorItem.Cart__c);
		Map<String, cc_bean_ProductListViewData> productId2ListViewDataMap = new Map<String, cc_bean_ProductListViewData>();
		for(cc_bean_ProductListViewData lvd : listViewData)
		{
			productId2ListViewDataMap.put(lvd.product.Id, lvd);
		}
		
		List<E_CartItem__c> cartItemList = new List<E_CartItem__c>();
		decimal majorTotal = 0.0;
		for(cc_util_CompositeProduct.NamedSelectOptionList ol : assemblyModelOptionValues)
		{
			if(ol.selectedOption != null)
			{
				System.debug('roy lou Cart-->' + majorItem.Cart__c);
				cc_bean_ProductListViewData d = productId2ListViewDataMap.get(ol.selectedOption);
				System.debug('roy lou 123 --->' + d);
				E_CartItem__c ci = new E_CartItem__c();
				ci.StoreId__c = majorItem.StoreID__c;
	            ci.Cart__c=majorItem.Cart__c;
	            ci.Quantity__c = d.qty; 
	            if(ci.Quantity__c == null)
	            {
	            	ci.Quantity__c = 1;
	            }
	            System.debug('roy lou 123 ---> !!!');
	            ci.price__c = d.priceBean.price;
	            System.debug('roy lou  123---> ???');
	            ci.Product__c = d.product.id;
	            String sku = d.product.sku__c;
	            
	            ci.SubAmount__c =  ci.price__c * ci.Quantity__c;
	            ci.SubAmount__c = ci.SubAmount__c.setScale(2, System.RoundingMode.UP);
	            ci.cartItemType__c='Minor';
	            
	            ci.Category__c = d.categoryId;
	                           
	            ci.RequestDate__c = Date.today();
	            
	            //ci.UnitOfMeasure__c = d.product.UnitOfMeasure__c;
	            ci.ParentCartItem__c=majorItem.Id;
	            cartItemList.add(ci);
	            majorTotal += ci.SubAmount__c;
			}
		}
		majorItem.price__c = majorTotal;
		majorItem.SubAmount__c = majorItem.price__c * majorItem.Quantity__c;
		insert cartItemList;
		update majorItem;
	}
/* CC SaaS Mod - Schema Change - removed E_ModelValue__c
	//==================================================
    // HELPER METHODS
    //==================================================
	public void getAssemblyModelData(Id productId, Id accountId)
	{
		Map<String, List<SelectOption>> optionMap = new Map<String, List<SelectOption>>();
		List<E_Product__c> productList = new List<E_Product__c>();
		
		List<E_ModelOption__c> modelOptions = [Select e.Id, e.Advice__c, (Select Id, Product__c, Product__r.SKU__c, Product__r.name, Product__r.UnitOfMeasure__c, 
					Product__r.ProductStatus__c, Product__r.ProductType__c, Product__r.ShortDesc__c, ValueText__c From E_ModelValues__r) From E_ModelOption__c e
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
				productList.add(value.product__r);
				
			}
			assemblyModelOptionValues.add(new cc_util_CompositeProduct.NamedSelectOptionList(option.Advice__c, options, productId));
		}
		
		listViewData = cc_util_CompositeProduct.getListViewData(productList, accountId);
		
	}
	*/
	
}