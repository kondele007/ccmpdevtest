//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_ctrl_QuickOrder {
	public cc_ctrl_CloudCraze cloudCrazeController { get; set; }
	public final Integer kMaxSkuTextValues = 12; 
    //==================================================
    // INSTANCE VARIABLES
    //==================================================  
    /* change following private variable and public getter/setter to attribute
    private List<skuText> skuTextValues;

    public List<skuText> getSkuTextValues() {
        if (skuTextValues == null) {
            skuTextValues = new List<skuText>();
            Integer skuCount = 0;
            for (skuCount = 1; skuCount <= kMaxSkuTextValues; skuCount++) {
                skuTextValues.add(new skuText(skuCount));
            }
        }
        return skuTextValues;
    }

    public void setSkuTextValues(List<skuText> skuTextValuesList) { skuTextValues = skuTextValuesList; }
    */
    public List<skuText> skuTextValues {
    	get {
    		if (skuTextValues == null) {
	            skuTextValues = new List<skuText>();
	            Integer skuCount = 0;
	            for (skuCount = 1; skuCount <= kMaxSkuTextValues; skuCount++) {
	                skuTextValues.add(new skuText(skuCount));
	            }
	        }
	        return skuTextValues;
    	}
    	set;
    }

    
    //==================================================
    // INNER CLASS
    //==================================================    
    public with sharing class skuText {
        //==================================================
        // INSTANCE PROPERTIES
        //==================================================
        public String value { get; set; }
        public String selectedQty { get; set; } 
        public Integer sNo { get; set; }

        //==================================================
        // CONSTRUCTOR
        //==================================================
        public skuText() {
            sNo = 0;
            value = '';
            selectedQty = '1';
        }
        public skuText(Integer sNumber) {
            sNo = sNumber;
            value = '';
            selectedQty='1';
        }
    }

    //==================================================
    // CONSTRUCTOR
    //==================================================
    public cc_ctrl_QuickOrder() { }
    public cc_ctrl_QuickOrder(cc_ctrl_HomePage tree) { }

    //==================================================
    // SERVICE METHODS
    //==================================================    
    /*
     * Adds a a list of products from skuTextValues and adds them to the cart.
     * Used in the Quick Order box.
     *
     * @return returns a page reference to the Shopping Cart.
     */
    public PageReference addToCartBulkItems() {
  
		map<string, integer> skuQtyMap = new map<string, integer>();
        Integer skuTextCount = 0;
        integer qty = 0;
        string sku=null;
        for (skuText skuTextInstance : skuTextValues) {
            if (skuTextInstance.value.length() > 0) {
                skuTextCount++;
                
                sku = skuTextInstance.value;
                if (skuTextInstance.selectedQty == null || skuTextInstance.selectedQty == '') {
                	qty = 1;
                    
                } else {
                	qty = integer.valueOf(skuTextInstance.selectedQty );
                }
                if(!skuQtyMap.containskey(sku))  {
                	skuQtyMap.put(sku, 0);
                }
                integer skuqty = skuQtyMap.get(sku);
                skuqty += qty;
                skuQtyMap.put(sku, skuqty);
            }
        }
		E_Cart__c cart = null;
		if(cloudCrazeController.ccCartId == null) {
			cc_api_Cart cartApi = new cc_api_Cart();
			cart = cartApi.getActiveCartOwnedBy(userInfo.getUserId());
			
			if(cart == null) {
				cart = cartAPi.createEmptyCart();
			} 
		} else {
			cart = cc_dao_cart.retrieveCartHeader(cloudCrazeController.ccCartId);
		}
		PageReference nextPage = null;
		if(cart != null) {
			
			cc_api_addToCart add2CartApi = new cc_api_addToCart(cloudCrazeController.storefront);
			add2CartApi.currentCartId = cart.id;
			add2CartApi.skuQtyMap = skuQtyMap;
			add2CartApi.addToCartBulkItems();
			
			if(cloudCrazeController.storefront.RedirectToCartPage__c) {
				nextPage = System.Page.Cart; 
				nextPage.getParameters().put('cartID', add2CartApi.currentEncryptedCartID);
		        nextPage.getParameters().put('viewState','CartView');
		        nextPage.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, Apexpages.currentPage().getParameters().get(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY));
				nextPage.setRedirect(true);
	
				return nextPage;
			} else {
				cloudCrazeController.ccCartId = add2CartApi.currentEncryptedCartID;
			}   
		} else {
			ApexPages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,'Unknown cart with encrypted id: ' +cloudCrazeController.ccCartId));
		}  
		 
		return  nextPage;
    }

    
}