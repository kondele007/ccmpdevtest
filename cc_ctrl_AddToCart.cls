//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without
//  modification is PROHIBITED.
//
//
public with sharing class cc_ctrl_AddToCart extends cc_ctrl_CloudCraze {
	public cc_ctrl_AddToCart getAddToCartController() { return this; }
    //==================================================
    // INSTANCE PROPERTIES
    //==================================================
	public String currentCartID{ get; set; }
	//==================================================
    // CONSTRUCTOR
    //==================================================
	public cc_ctrl_AddToCart() {
		super();
		vSkuQtyMap = new map<string, integer>();
		vSkuCount = 0;
	}
	public cc_ctrl_AddToCart(Object o) {
		this();
	}
	//==================================================
    // INSTANCE VARIABLES
    //==================================================
	public Boolean exceptionFlag = false;
	// The Invalid SKU's are a set to avoid duplicates.
    public Set<String> invalidSKUList = new Set<String>();
    public Set<String> notOrderableProductList = new Set<String>();
    public Boolean bulkItemInvoked = false;
    public List<String> skuList = new List<String>();
    public Map<String,String> productMap = new Map<String,String>();
    public Map<String,String> notOrderableProductMap = new Map<String,String>();

    //==================================================
    // SERVICE METHODS
    //==================================================

    public String vCurrentCartID { get;
    	set {
    		vCurrentCartID=EncodingUtil.urlDecode(value, 'UTF-8');
    	}
    }
    public String vCurrentProductID { get;
    	set {
    		vCurrentProductID=EncodingUtil.urlDecode(value, 'UTF-8');
    	}
    }
    public String vQty { get;
    	set {
    		vQty=EncodingUtil.urlDecode(value, 'UTF-8');
    	}
    }
    public String vIPAddressLocation { get;
    	set {
    		vIPAddressLocation=EncodingUtil.urlDecode(value, 'UTF-8');
    	}
    }
    public String vCategorySelected { get;
    	set {
    		vCategorySelected=EncodingUtil.urlDecode(value, 'UTF-8');
    	}
    }
    public String vQtyAvailable { get;
    	set {
    		vQtyAvailable=EncodingUtil.urlDecode(value, 'UTF-8');
    	}
    }
    public String vOperation { get;
    	set {
    		vOperation=EncodingUtil.urlDecode(value, 'UTF-8');
    	}
    }
    public String vSearchText { get;
    	set {
    		vSearchText=EncodingUtil.urlDecode(value, 'UTF-8');
    	}
    }
    public String vViewState { get;
    	set {
    		vViewState=EncodingUtil.urlDecode(value, 'UTF-8');
    	}
    }
    public integer vSkuCount { get; set; }
    public map<string, integer> vSkuQtyMap { get; set; }
    public PageReference addToCart() {
        
        Integer qty = 1;
        Integer skuTextCount = 0;
        Integer notOrderableCnt = 0;

        /*
         * Check if any bulk items need to be added to cart.
         */

        addToCartBulkItems();

        if(vQty == null) {
        	// if (strQty.trim().length() == 0) {
            qty = 1;
        	// }
        } else {
	        try {
	        	qty = Double.valueOf(vQty).intValue();
	        } catch(exception e) {
	        	qty = 1;
	        }
        }
         //System.debug('--------------qty in addToCart is' + qty);

        //Corning: max out to available inventory
        boolean maxedOut = false;
        if(storefront.InventoryCheckFlag__c){
          if(vQtyAvailable != null && vQtyAvailable.length() > 0 && qty > Double.valueOf(vQtyAvailable)){
            qty = Double.valueOf(vQtyAvailable).intValue();
            maxedOut = true;
          }
        }

        cc_api_Cart cc_api_Cart = new cc_api_Cart();
        if (al.StringUtils.isNotBlank(vCategorySelected)) {
            cc_api_Cart.categoryId = vCategorySelected;
        }

        // System.debug('--------------CurrentProductID in addToCart is' + currentProductID);
        vcurrentCartID = cc_api_Cart.addToCart(vcurrentProductID, vcurrentCartID, qty, storefront.Name);
        currentCartID = vcurrentCartID;
        // System.debug('After Adding to Cart before calling Cart');

        PageReference page;
        maxedOut = false;// maxedOut || cc_api_Cart.maxedOut;
        if(maxedOut)
        {
        	//page = new PageReference('/apex/Cart');
        	page = System.page.Cart;
        	page.getParameters().put('viewState','CartView');
      		page.getParameters().put('displayMaxOutMessage', vcurrentProductID);
        }
        else if(vCategorySelected != null || vsearchText != null)
        {
        	//page = new PageReference('/apex/Products');
        	page = System.Page.Products;
        	page.getParameters().put('categoryId',vCategorySelected);
        	page.getParameters().put('operation',voperation);
        	page.getParameters().put('searchText',vsearchText);
        }
        else if(vcurrentProductID != null)
        {
        	//page = new PageReference('/apex/ProductDetails');
        	page = System.Page.ProductDetails;
        }
        if(page == null)
        {
        	//page = new PageReference('/apex/HomePage');
        	page = System.Page.HomePage;
        }
        // PageReference page = System.Page.Cart;
        page.getParameters().put('cartID', CurrentCartID);
        page.getParameters().put('viewState', vviewState);

        page.getParameters().put('productID', vcurrentProductID);
        page.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, vipAddressLocation);
        for(String sku : invalidSKUList) {
            skuTextCount++;
            page.getParameters().put('sku'+skuTextCount, sku);
        }

        page.getParameters().put('skuTextCount', String.valueOf(skuTextCount));

        for(String sku : notOrderableProductList) {
            notOrderableCnt++;
            page.getParameters().put('notOrdsku' + notOrderableCnt, sku);
        }

        page.getParameters().put('notOrdskuCount', String.valueOf(notOrderableCnt));
        page.setRedirect(true);

        return page;
    }

    /*
     * Adds products from skuTextValues to the shopping cart.  Used in
     * Quick Order Box.
     *
     * @return page reference to the shopping cart
     *
     */
    public void addToCartBulkItems() {
        //currentCartID = ApexPages.currentPage().getParameters().get('cartID');
        //String skuCountStr = Apexpages.currentPage().getParameters().get('skuTextCount');
        //add all eys from vSkuQtyMap to skuList
		skuList.addAll(vSkuQtyMap.keyset());
		List<E_Product__c> productList = new List<E_Product__c>();
		// put added product skus/names into a map
        productList = cc_dao_Product.readProductForStore(skuList, cc_util_Locale.getUserLanguage(), storefront.Name);
        for(E_Product__c product : productList) {
            productMap.put(product.SKU__c, product.Name);
        }
        //System.debug('product map skus: ' + productMap); // empty

        // put not-orderable products into a map
        //?? can we just iterate through productList to filter out desired products?
        productList = cc_dao_Product.readProductForStatus(skuList, cc_util_Locale.getUserLanguage(), cc_cnst_PickListConstants.PRODUCTSTATUS_NOTORDERABLE);

        for(E_Product__c product : productList) {
            notOrderableProductMap.put(product.SKU__c, product.Name);
        }

        for(string key : vSkuQtyMap.keyset()) {
        	String sku = key;
            integer qty = vSkuQtyMap.get(key);
            try {
            	cc_api_Cart cc_api_Cart = new cc_api_Cart();

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
                    exceptionFlag = true;

                // sku is valid and product is added to the cart
                } else {
                    vcurrentCartID = cc_api_Cart.addToCart(sku, vcurrentCartID, Double.valueOf(qty), storefront.Name);
                    currentCartID = vcurrentCartID;
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

        if(exceptionFlag) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid SKU' + invalidSKUList);
            ApexPages.addMessage(myMsg);
        }
        bulkItemInvoked = true;
    }

    // TASK ID 7 VS START
    public string wishlistCartId { get; set; }
    public string wishlistProductId { get; set; }
    public string wishListQty { get; set; }
    public string wishlistIPAddressLocation { get; set; }
    public string wishlistCategorySelected { get; set; }

    public PageReference addToWishList() {


        Integer qty = 1;

        if(!al.StringUtils.isEmpty(wishListQty) && al.StringUtils.isNumeric(wishListQty)) {
            qty = Integer.valueOf(wishListQty);
        }

        cc_api_Cart cc_api_Cart = new cc_api_Cart();
        if (al.StringUtils.isNotEmpty(wishlistCategorySelected)) {
            cc_api_Cart.categoryId = wishlistCategorySelected;
        }
        String userId = UserInfo.getUserId();
        //System.debug('--------------CurrentProductID in addToCart is' + currentProductID);
        if(!cc_util_CloudCraze.isGuest()) {
            cc_api_Cart.addToWishList(wishlistCartId, qty, userId);
        }

        //PageReference page = new PageReference('/apex/MyAccount');
        PageReference page = System.Page.MyAccount;
        page.getParameters().put('cartID', wishlistCartId);
        page.getParameters().put('productID', wishlistProductId);
        page.getParameters().put('viewState','wishlists');
        page.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, wishlistIPAddressLocation);
        page.setRedirect(true);
        return page;
    }
    // TASK ID 7 VS END
}