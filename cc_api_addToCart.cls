//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without
//  modification is PROHIBITED.
//
//
public with sharing class cc_api_addToCart {
	public E_StorefrontSettings__c storefront { get; set; }
    public map<string, string> addToCartParam { get; set; }
    public cc_ctrl_CloudCraze cloudCrazeController { get; set; } 
    public map<string, double> skuQtyMap { get; set; }
    public integer skuCount { get; set; }
    public Id currentCartID{ get; set; }
    public String currentEncryptedCartID{ get; set; }
    public String currentProductId { get; set; }
    public String IPAddressLocation { get; set; }
    public String categorySelected { get; set; }
    public integer qtyAvailable { get; set; }
   
    public String viewState { get; set; }
    public Boolean bulkItemInvoked { get; set; }
    public integer quantity { get; set; }
    public cc_api_addToCart(E_StorefrontSettings__c sf) {
        SkuQtyMap = new map<string, double>();
        SkuCount = 0;
        bulkItemInvoked = false;
        qtyAvailable=0;
        cloudCrazeController = null;
        addToCartParam = new map<string, string>();
        storefront = sf;
    }
    public cc_api_addToCart(cc_ctrl_CloudCraze c) {
        this(c.storefront);
        cloudCrazeController = c;
       
    }
    
    public AddToCartResult addToCart() {
        
        AddToCartResult ret = AddToCartResult.Success;
        Integer qty = 1;
        
        try{
            addToCartBulkItems();
        } catch (AddToCartException e) {
            ret = AddToCartResult.Failed;
        } catch (Exception e) {
            ret = AddToCartResult.Failed;
        }

        //Corning: max out to available inventory
        boolean maxedOut = false;
        if(storefront.InventoryCheckFlag__c){
          if(quantity > qtyAvailable) {
            quantity = qtyAvailable;
            maxedOut = true;
          }
        }

        cc_api_Cart cc_api_Cart = new cc_api_Cart();
        if (al.StringUtils.isNotBlank(categorySelected)) {
            cc_api_Cart.categoryId = categorySelected;
        }

        // System.debug('--------------CurrentProductID in addToCart is' + currentProductID);
        currentEncryptedCartID = cc_api_Cart.addToCart(currentProductID, currentCartID, quantity, storefront.Name);
     
        //maxedOut = maxedOut || cc_api_Cart.maxedOut;
        if(false)
        {
            ret = AddToCartResult.MaxedOut;
        }
        return ret;
    }
    
    /*
     * Adds products from skuTextValues to the shopping cart.  Used in
     * Quick Order Box.
     *
     * @return page reference to the shopping cart
     *
     */
    public void addToCartBulkItems() {
        List<String> skuList = new List<String>();
        Map<String,String> notOrderableProductMap = new Map<String,String>();
        Boolean exceptionFlag = false;
        Map<String,String> productMap = new Map<String,String>();
        Set<String> invalidSKUList = new Set<String>();
        Set<String> notOrderableProductList = new Set<String>();
        List<E_Product__c> productList = new List<E_Product__c>();
        
        skuList.addAll(skuQtyMap.keyset());
        // put added product skus/names into a map
        productList = cc_dao_Product.readProductForStore(skuList, cc_util_Locale.getUserLanguage(), storefront.Name);
        for(E_Product__c product : productList) {
            productMap.put(product.SKU__c, product.Name);
            if(product.ProductStatus__c == cc_cnst_PickListConstants.PRODUCTSTATUS_NOTORDERABLE) {
            	notOrderableProductMap.put(product.SKU__c, product.Name);
            }
        }
        
        map<string, Double> skuQtyNeedsAddedMap = new map<string, Double>();
        for(string key : skuQtyMap.keyset()) {
            String sku = key;
            double qty = skuQtyMap.get(key);
            try {
                
                // sku is invalid
                if(!productMap.containsKey(sku)) {
                    exceptionFlag = true;
                    if(invalidSKUList != null && invalidSKUList.size() > 0 && invalidSKUList.contains(sku)) {
                        continue;
                    } else {
                        invalidSKUList.add(sku);
                    }

                // sku is valid but product is not orderable
                } else if(notOrderableProductMap.containsKey(sku)) {
                    if(notOrderableProductList != null && notOrderableProductList.size() > 0 && notOrderableProductList.contains(sku)) {
                        continue;
                    } else {
                        notOrderableProductList.add(sku);
                    }
                // sku is valid and product is added to the cart
                } else {
                    
                    skuQtyNeedsAddedMap.put(sku, skuQtyMap.get(sku));
                }
            } catch(Exception e) {
                exceptionFlag = true;
                if(invalidSKUList != null && invalidSKUList.size() > 0 && invalidSKUList.contains(sku)) {
                     continue;
                } else {
                      invalidSKUList.add(sku);
                }
                continue;
            }
        }
        try {
            cc_api_Cart cc_api_Cart = new cc_api_Cart();
            currentEncryptedCartID = cc_api_Cart.addSkuQtyMapToCart(skuQtyNeedsAddedMap, true, storefront.Name, currentCartID);
        } catch (Exception e) {
             
        }
        Integer skuTextCount = 0;
        Integer notOrderableCnt = 0;
        
        for(String sku : invalidSKUList) {
            skuTextCount++;
            addToCartParam.put('sku'+skuTextCount, sku);
        }

        addToCartParam.put('skuTextCount', String.valueOf(skuTextCount));

        for(String sku : notOrderableProductList) {
            notOrderableCnt++;
            addToCartParam.put('notOrdsku' + notOrderableCnt, sku);
        }

        addToCartParam.put('notOrdskuCount', String.valueOf(notOrderableCnt));
        if(exceptionFlag) {
            throw new AddToCartException('Invalid SKU' + invalidSKUList);
        }
        bulkItemInvoked = true;
    }
    public class AddToCartException extends Exception {
        
    }
    public enum AddToCartResult {Success, Failed, MaxedOut}
}