//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without
//  modification is PROHIBITED.
//
//
public with sharing class cc_ctrl_ProductListDisplayWidget extends cc_ctrl_CloudCraze {
	public cc_ctrl_CloudCraze outerController { get; set; }
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
	public List<Id> productIdList { get; 
		set {
			productIdList=value;
			Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO,'Set productIdList size = ' + string.valueOf(productIdList.size())));
		} }
	
	public cc_ctrl_ProductListDisplayWidget() {
		
	}
	//==================================================
    // SERVICE METHODS
    //==================================================
	public List<cc_bean_ProductListViewData> getDisplayList()
	{
		if(productIdList == null)
		{
			Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO,'productIdList is null'));
			return new List<cc_bean_ProductListViewData>();
		}
		cc_dao_Product dao = new cc_dao_Product();
		List<E_Product__c> pl = dao.readProductWithID(productIdList, cc_util_Locale.getUserLanguage());
		return getListViewData(pl, cc_util_CloudCraze.getAccountID());
	}
	
	 
	//==================================================
    // STATIC HELPER METHODS
    //==================================================
	public static List<cc_bean_ProductListViewData> getListViewData(List<E_Product__c> productList, Id accountId)
	{
		Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO,'inside cc_ctrl_ProductListDisplayWidget.getListViewData '));
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
		Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO,'inside skulist size= ' + string.valueOf(skuList.size())));
		Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO,'inside productIdList size= ' + string.valueOf(productIdList.size())));
		Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO,'inside productMap size= ' + string.valueOf(productMap.size())));
		Map<String, cc_bean_PriceInfo> priceLineMap = cc_ctrl_PricingEngine.getPriceMap(skuList,
		                                                  accountId,
		                                                  Date.today(),
		                                                  cc_ctrl_PricingEngine.getCurrencyCode(),
		                                                  cc_ctrl_PricingEngine.getCustomerType());
		Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO,'inside priceLineMap size= ' + string.valueOf(priceLineMap.size())));                                                  
		cc_dao_ProductMedia pmDAO = new cc_dao_ProductMedia();
		Map<Id, cc_bean_MediaWrapper> idSearchMap = pmDAO.getProductSearchMedia(productIdList);
		//Map<Id, String> idSearchMap2 = pmDAO.getProductAltMessages(productIdList);

		for(E_Product__c pd : productList ) {
			cc_bean_ProductListViewData data = new cc_bean_ProductListViewData();
			data.product = pd;
			data.mockProduct = new cc_bean_MockProduct(pd);
			if(priceLineMap != null && priceLineMap.containsKey(pd.SKU__c)) {
			    data.priceBean = priceLineMap.get(pd.SKU__c);
			    System.debug('sns data.priceListItem = ' + data.priceBean);
			}
			else
			{
				//skip this product
				Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO,'skip this product -> ' + pd.name));
                continue;
			}
			
			//data.Alt_Message = idSearchMap2.get(pd.Id);

			System.debug('@@@@@@@@@@idSearchMaplength   :	' + idSearchMap.size());
			//System.debug('@@@@@@@@@@idSearchMaplength2   :	 ' + idSearchMap2.size());
 
			
			if(idSearchMap.get(pd.Id) != null) {
			    data.mediaWrapper = idSearchMap.get(pd.Id);
			    //System.debug('@@@@@@@@@@Alt message  :	' + data.Alt_Message);
			} 
			
			localproductListViewData.add(data);
		}
		
		Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO,'localproductListViewData size -> ' + localproductListViewData.size()));
		return localproductListViewData;                                                  
	}
}