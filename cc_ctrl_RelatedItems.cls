//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_ctrl_RelatedItems extends cc_ctrl_CloudCraze {
    //==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public String productId {get;set;}
    public List<Id> productIdList {get;set;}
    public List<cc_bean_ProductListViewData> relatedProductListViewData {get; private set;} 
    public List<cc_bean_ProductListViewData> upSellProductListViewData {get; private set;}  
    public List<cc_bean_ProductListViewData> crossSellProductListViewData {get; private set;}
    public List<cc_bean_ProductListViewData> crossSellProductListViewDataForList {get; private set;}

    //==================================================
    // CONSTRUCTOR
    //==================================================
    public cc_ctrl_RelatedItems() {}
    
    //==================================================
    // HELPER METHODS
    //==================================================
    public List<cc_bean_ProductListViewData> getRelatedItems() {
        if (al.ArrayUtils.isEmpty(relatedProductListViewData)) {
            //System.debug('--- getRelatedItems relatedProductListViewData is empty');
            relatedProductListViewData = getRelatedProductViewItems(productId, cc_cnst_PickListConstants.RELATEDPRODUCT_RELATED); 
        }
        return relatedProductListViewData;
    }
    
    public List<Id> getRelatedItemIds() {
        List<E_Product__c> productList = cc_util_CloudCraze.getRelatedProducts(productId,cc_cnst_PickListConstants.RELATEDPRODUCT_RELATED);
    	List<Id> crossSellIds = new List<Id> ();
    	for(E_Product__c p :productList)
    	{
    		crossSellIds.add(p.id);
    	}
    	return crossSellIds;
    }
    
    public List<cc_bean_ProductListViewData> getCompetitiveItems() {
        return getRelatedProductViewItems(productId, cc_cnst_PickListConstants.RELATEDPRODUCT_COMPETITIVE);
    }

    public List<cc_bean_ProductListViewData> getCrossSellItems() {
        if(al.ArrayUtils.isEmpty(crossSellProductListViewData)) {
        	//System.debug('--- getCrossSellItems crossSellProductListViewData is empty');
            crossSellProductListViewData = getRelatedProductViewItems(productId, cc_cnst_PickListConstants.RELATEDPRODUCT_CROSSSELL);
        }
        return crossSellProductListViewData;
    }

	public List<Id> getCrossSellItemIds() {
    	List<E_Product__c> productList = cc_util_CloudCraze.getRelatedProducts(productId,cc_cnst_PickListConstants.RELATEDPRODUCT_CROSSSELL);
    	List<Id> crossSellIds = new List<Id> ();
    	for(E_Product__c p :productList)
    	{
    		crossSellIds.add(p.id);
    	}
    	return crossSellIds;
    }
    public List<cc_bean_ProductListViewData> getCrossSellItemsForList() {
        if(al.ArrayUtils.isEmpty(crossSellProductListViewDataForList)) {
            //System.debug('--- getCrossSellItemsForList crossSellProductListViewDataForList is empty');
            populateCrossSellProductsForList(cc_cnst_PickListConstants.RELATEDPRODUCT_CROSSSELL);
        }
        return crossSellProductListViewDataForList;
    }
    
    public List<Id> getCrossSellItemIdsForLst() {
    	List<E_RelatedProduct__c> crossSells = cc_dao_Product.getRelatedProducts(productIdList,cc_cnst_PickListConstants.RELATEDPRODUCT_CROSSSELL);
    	List<Id> crossSellIds = new List<Id> ();
    	for(E_RelatedProduct__c p :crossSells)
    	{
    		crossSellIds.add(p.RelatedProduct__c);
    	}
    	return crossSellIds;
    }

    public List<cc_bean_ProductListViewData> getUpSellItems() {
        if (al.ArrayUtils.isEmpty(upSellProductListViewData)) {
            //System.debug('--- getUpSellItems upSellProductListViewData is empty');
            upSellProductListViewData = getRelatedProductViewItems(productId, cc_cnst_PickListConstants.RELATEDPRODUCT_UPSELL); 
        }       
        return upSellProductListViewData;
    }

	public List<Id> getUpsellItemIds() {
    	List<E_Product__c> productList = cc_util_CloudCraze.getRelatedProducts(productId,cc_cnst_PickListConstants.RELATEDPRODUCT_UPSELL);
    	List<Id> upsellIds = new List<Id> ();
    	for(E_Product__c p :productList)
    	{
    		upsellIds.add(p.id);
    	}
    	return upsellIds;
    }
	
    public List<cc_bean_ProductListViewData> getRequiredItems() {
        return getRelatedProductViewItems(productId, cc_cnst_PickListConstants.RELATEDPRODUCE_REQUIREDITEM);
    }
	
	//==================================================
    // HELPER METHODS
    //==================================================
    public List<cc_bean_ProductListViewData> getRelatedProductViewItems(Id productId, String relation) {
        Integer noOfQueries = Limits.getQueries();
        //System.debug('----Limits.getQueries()1-cc_ctrl_RelatedItems.getRelatedProductViewItems---- : ' + noOfQueries);
        List<cc_bean_ProductListViewData> viewList = new List<cc_bean_ProductListViewData>();
        
       // List<E_Product__c> productList = cc_util_CloudCraze.getRelatedProducts(productId, cc_util_CloudCraze.getIDByCode('RelatedProduct', relation));
       List<E_Product__c> productList = cc_util_CloudCraze.getRelatedProducts(productId,relation);
        
        if(productList == null || productList.size() < 1) {
            return viewList;
        }
        noOfQueries = Limits.getQueries();
        //System.debug('----Limits.getQueries()2-cc_ctrl_RelatedItems.getRelatedProductViewItems---- : ' + noOfQueries);        
        List<Id> productIdList = new List<Id>();
        List<String> productSkuList = new List<String>();
        for(E_Product__c p : productList) {
            if(p!=null){
              productIdList.add(p.Id);
              productSkuList.add(p.Sku__c);
            }
        }
        
        // Get prices
        Map<String, cc_bean_PriceInfo> priceLineMap = cc_ctrl_PricingEngine.getPriceMap(productSkuList, cc_util_CloudCraze.getAccountID(), null, null, null);            
        noOfQueries = Limits.getQueries();
        //System.debug('----Limits.getQueries()3-cc_ctrl_RelatedItems.getRelatedProductViewItems---- : ' + noOfQueries);        
        // get thumbnails
       /* Map<Id,Id> thumbnailMap = new Map<Id,Id>();
        if(cc_cnst_PickListConstants.RELATEDPRODUCT_UPSELL.equalsIgnoreCase(relation)) {
            thumbnailMap = cc_dao_ProductMedia.getAttachmentsForProductList(productIdList, cc_cnst_CloudCraze.ATTACHMENTS_STANDARD_IMAGE_SOQL_PATTERN, true);
        } else {
            thumbnailMap = cc_dao_ProductMedia.getAttachmentsForProductList(productIdList, cc_cnst_CloudCraze.ATTACHMENTS_THUMBNAIL_IMAGE_SOQL_PATTERN);
        }*/
        
        cc_dao_ProductMedia pmDAO = new cc_dao_ProductMedia();
        Map<Id,cc_bean_MediaWrapper> thumbnailMap = pmDAO.getProductThumbnailMedia(productIdList);
               
        for(E_Product__c p : productList) {
            if(p!=null){
                if(cc_cnst_PickListConstants.PRODUCTSTATUS_NOTORDERABLE.equalsIgnoreCase(p.ProductStatus__c)
                    || cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED.equalsIgnoreCase(p.ProductStatus__c))
                {
                    cc_bean_ProductListViewData viewItem = new cc_bean_ProductListViewData();
                    viewItem.product = p;
                    if(cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED.equalsIgnoreCase(p.ProductStatus__c)) {
                        viewItem.priceBean = priceLineMap.get(p.Sku__c);
                        viewItem.priceListItem = viewItem.priceBean.priceListItem;
                        //System.debug('--- adding price to view item: ' + viewItem.product.SKU__c + ' price: ' + viewItem.priceListItem.Price__c + ' ---');
                    }
                    if(thumbnailMap.get(p.Id) != null)
                    {
                    	viewItem.mediaWrapper.uri = thumbnailMap.get(p.Id).uri;
                    	viewItem.mediaWrapper.sourceType = thumbnailMap.get(p.Id).sourceType;
                    }
                    viewList.add(viewItem);
                    //System.debug('--- added ' + relation + ' viewItem: item=' + viewItem.product.Sku__c + ', attachmentID=' + viewItem.attachmentID + ', status=' + p.ProductStatus__c);
                }
            }
        }
        noOfQueries = Limits.getQueries();
        //System.debug('----Limits.getQueries()4-cc_ctrl_RelatedItems.getRelatedProductViewItems---- : ' + noOfQueries);        
        return viewList;
    }

    public void populateCrossSellProductsForList(String relation) {
        crossSellProductListViewDataForList = new List<cc_bean_ProductListViewData>();
        
        if(productIdList == null) {
            return;
        }
        
        System.debug('--- productIdList = [' + productIdList + '] ---');
        
        List<E_RelatedProduct__c> crossSells = cc_dao_Product.getRelatedProducts(productIdList, relation);
        
        System.debug('--- crossSells count = ' + crossSells.size() + ' ---');
        
        productIdList = new List<Id>();
        List<String> productSkuList = new List<String>();
        for(E_RelatedProduct__c rp : crossSells) {
            productIdList.add(rp.RelatedProduct__c);
            productSkuList.add(rp.RelatedProduct__r.Sku__c);
        }
        
        Map<String, cc_bean_PriceInfo> priceLineMap = cc_ctrl_PricingEngine.getPriceMap(productSkuList, cc_util_CloudCraze.getAccountID(), null, null, null);
        System.debug('cc_ctrl_RelatedItems.populateCrossSellProductsForList: priceLineMap=' + priceLineMap);
        
       // Map<Id,Id> thumbnailMap = cc_dao_ProductMedia.getAttachmentsForProductList(productIdList, cc_cnst_CloudCraze.ATTACHMENTS_STANDARD_IMAGE_SOQL_PATTERN, true);
       
        cc_dao_ProductMedia pmDAO = new cc_dao_ProductMedia();
        Map<Id,cc_bean_MediaWrapper> thumbnailMap = pmDAO.getProductThumbnailMedia(productIdList);

        for(E_RelatedProduct__c rp : crossSells) {
            cc_bean_ProductListViewData vd = new cc_bean_ProductListViewData();
            E_Product__c product = new E_Product__c();
            System.debug('cc_ctrl_RelatedItems.populateCrossSellProductsForList: rp=' + rp);
            System.debug('cc_ctrl_RelatedItems.populateCrossSellProductsForList: rp.RelatedProduct__r=' + rp.RelatedProduct__r);
            product.Sku__c = rp.RelatedProduct__r.Sku__c;
            product.Name = rp.RelatedProduct__r.Name;
            vd.product = product;
            if(cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED.equalsIgnoreCase(rp.RelatedProduct__r.ProductStatus__c)) {
                 vd.priceBean = priceLineMap.get(rp.RelatedProduct__r.Sku__c);
                 System.debug('cc_ctrl_RelatedItems.populateCrossSellProductsForList: vd.priceBean=' + vd.priceBean);
                 vd.priceListItem = vd.priceBean.priceListItem;
            }
            if(thumbnailMap.containsKey(rp.RelatedProduct__c)) {
	            vd.mediaWrapper.uri = thumbnailMap.get(rp.RelatedProduct__c).uri;
	            vd.mediaWrapper.sourceType = thumbnailMap.get(rp.RelatedProduct__c).sourceType;
            }
            
            crossSellProductListViewDataForList.add(vd);
        }
    }
}