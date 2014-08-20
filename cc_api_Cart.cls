//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public without sharing class cc_api_Cart {
    //==================================================
    // CONSTANTS
    //==================================================
    // Maximum number of coupons per cart
    // future implementation -- read value from configuration
    public Integer maxCoupons = 1;
    //==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public cc_hlpr_CompositeProductHelperBase cc_hlpr_CompositeProduct { get; set; }  
    public String categoryId {get;set;}
    //map from aggregated product to selected aggregate
    public Map<String, string> selectedAggregatedProduct { get; set; }
    public Boolean maxedOut{get; set;}
   	public E_Cart__c instanceCart{get ; set;}
    
    public Id accountId { 
        get 
        { 
            return accountId == null ? cc_util_CloudCraze.getAccountID() : accountId;
            
        }
        set;
    }
    //==================================================
    // CONSTRUCTOR  
    //==================================================
    public cc_api_Cart() {
        
    }
    //==================================================
    // HELPER METHODS
    //==================================================
    public  List<E_CartItem__c> getCartItems(String cartID){
        return getCartItems(cartID, 0);
    }
    
    public  List<E_CartItem__c> getCartItems(String cartID, Integer max) {
        return cc_dao_Cart.getCartItems(cartId, max);
    }

    public Decimal getCartTotalWithCompositeProduct(String cartID) {
        if(!(cartID instanceOf Id)) {
            E_Cart__c cart = retrieveCart(cartID);
            if(cart == null) {
                return 0.0;
            }
            cartID = cart.Id;
        }
        Decimal ret =0.0;
        List<E_CartItem__c> cartItemList = [Select c.Cart__c, c.Name, c.Product__r.Name, c.cartItemType__c,  
                    c.Product__r.ShortDesc__c, c.Product__r.SKU__c, c.Quantity__c, c.Price__c, c.SubAmount__c, c.Product__r.ProductType__c, 
                    c.Coupon__c, c.AllowsDiscounts__c, (Select Cart__c, Name, Product__r.Name, cartItemType__c,  
                    Product__r.ShortDesc__c, Product__r.SKU__c, Product__r.ProductStatus__c, Quantity__c, Price__c, SubAmount__c, ProductType__c, 
                    Coupon__c, AllowsDiscounts__c From Cart_Items__r)
                    from E_CartItem__c c
                    where c.isDeleted = false and c.cartitemtype__c in ('Major','Coupon') and c.Cart__c = :cartID];
        for(E_CartItem__c item: cartItemList) {
            cc_hlpr_CompositeProductHelperBase utils = cc_hlpr_CompositeProductHelperFactory.getCompositeProductHelper(item.Product__r.ProductType__c);
            ret += utils.calAggregatedPrice(item); // * item.Quantity__c;
        }
        return ret;
    }
  
   
    public  List<E_CartItem__c> getCartItemsWithCompositeProduct(Id cartID) {
            List<E_CartItem__c> cartItemList = [Select c.Cart__c, c.Name, c.Product__r.Name, c.cartItemType__c, 
                    c.Product__r.ShortDesc__c, c.Product__r.ProductType__c, c.Product__r.SKU__c, c.Quantity__c, c.Price__c, c.SubAmount__c, ProductType__c, AllowsDiscounts__c,
                    c.Coupon__c, (Select Cart__c, Name, Product__r.Name, cartItemType__c,  
                    Product__r.ShortDesc__c, Product__r.SKU__c, Product__r.ProductType__c, Quantity__c, Price__c, SubAmount__c, ProductType__c, 
                    Coupon__c From Cart_Items__r) from E_CartItem__c c where c.isDeleted = false and c.cartitemtype__c in ('Major','Coupon') and c.Cart__c = :cartID];
            for(E_CartItem__c item: cartItemList)   
            {
                cc_hlpr_CompositeProductHelperBase utils = cc_hlpr_CompositeProductHelperFactory.getCompositeProductHelper(item.Product__r.ProductType__c);
                item.Price__c = utils.calAggregatedPrice(item);
                item.SubAmount__c = utils.calAggregatedPrice(item) * item.Quantity__c;
            }  
            Integer noOfQueries = Limits.getQueries();
            //System.debug('----Limits.getQueries()-cc_ctrl_Cart.getCartItems---- : ' + noOfQueries);            
            return cartItemList;
        }
        
    public Decimal getCartTotal(String cartID) 
    {
        Decimal ret =0.0;
        if(cartID == null || ''.equals(cartID) || 'null'.equals(cartID)) {
            ret= 0.0;
        } else {
            ret = getCartTotalWithCompositeProduct(cartID);
        }
        return ret;
    }
    
    /**
     * Gets the number of unique items in the given cart
     * regardless of product status
     */       
    public Integer getCartItemCount(String cartID) {
        return getCartItemCount(cartID, false);
    }
 
    /**
     * Gets the number of unique items in the given cart
     * where product status is either Released or Not Orderable
     * (items that should be displayed to the user in the front end)
     */       
    public Integer getCartItemCount(String cartID, Boolean filterBlocked) {
        if(al.StringUtils.isBlank(cartID))
        {
            return 0;
        }
        
        String query = 'Select c.Quantity__c, c.cartItemType__c from E_CartItem__c c where c.isDeleted = false';
        
        cartID = String.escapeSingleQuotes(cartID);

        if(cartID instanceOf Id)
        {
           query += ' and c.Cart__c = \'' + cartID + '\'';
        }
        else
        {
           query += ' and c.Cart__r.EncryptedID__c = \'' + cartID + '\'';
        }
        
        if(filterBlocked)
        {
           query += ' and (c.Product__r.ProductStatus__c = \'' + cc_cnst_PickListConstants.PRODUCTSTATUS_NOTORDERABLE + '\''
                         + ' or c.Product__r.ProductStatus__c = \'' + cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED + '\')';
        }
        
        return getCartItemCount(Database.query(query));
    }
    
    public Integer getCartItemQuantitiesCount(String cartId /*, Boolean filterBlocked */)
    {
        if(al.StringUtils.isBlank(cartID))
        {
            return 0;
        }
        
        String query = 'Select c.TotalQuantity__c from E_Cart__c c where c.isDeleted = false';
        
        cartID = String.escapeSingleQuotes(cartID);

        if(cartID instanceOf Id)
        {
           query += ' and c.Id = \'' + cartID + '\'';
        }
        else
        {
           query += ' and c.EncryptedID__c = \'' + cartID + '\'';
        }
                
        List<E_Cart__c> queryResult = Database.query(query);
        double result = 0;
        
        if (queryResult.size() > 0)
        {
            E_Cart__c cart = queryResult.get(0);
            result = cart.TotalQuantity__c;
        }
        
        return result.intValue();
    }
    
    public integer getCartItemCount(List<E_CartItem__c> cartItemList)
    {
        integer count = 0;
        for(E_CartItem__c cartItem : cartItemList)
        {
            if(cartItem.cartItemType__c == 'Major') {
                count += cartItem.Quantity__c.intValue();
            }
        }
        return count;
    }   
    
    // Get the Cart_X_Coupons for the current cart
      // From the Cart_X_Coupons, get the coupon details
      // From the coupon, get the rule that applies
      
      // Using the rule IDs, get the PricingModifiers
      
      public List<E_CartCoupon__c> getCartCoupons(String cartId){
        List<E_CartCoupon__c> cartCoupons;

        cartId = String.escapeSingleQuotes(cartId);
        // Query for the CartCoupons and related coupons (and rules?)
        if(cartId != null && cartId.length() > 0){
            String query = 'select '
            // Coupon fields
            
            + 'Coupon__r.CouponCode__c,'
            + 'Coupon__r.CouponId__c,'   
            + 'Coupon__r.CouponType__c,'           
            + 'Coupon__r.Enabled__c,'
            + 'Coupon__r.MaxUse__c, '
            + 'Coupon__r.TotalUsed__c,'
            + 'Coupon__r.Name,' 
            + 'Coupon__r.ID,'

            // Code fields
            + 'Coupon__r.DiscountType__c,'
    
            // Rule fields
            + 'Coupon__r.Rule__r.ID,' 
            + 'Coupon__r.Rule__r.RuleID__c,' 
            + 'Coupon__r.Rule__r.CurrencyISOCode__c,' 
            + 'Coupon__r.Rule__r.Enabled__c,'
            + 'Coupon__r.Rule__r.EndDate__c, '
            //+ 'Coupon__r.E_Rule__r.isSKURelated__c,'
            + 'Coupon__r.Rule__r.Relation__c,' 
            + 'Coupon__r.Rule__r.Name__c,'
            + 'Coupon__r.Rule__r.RuleMinAmt__c,' 
            + 'Coupon__r.Rule__r.RuleMinQty__c, '
            + 'Coupon__r.Rule__r.RuleSource__c, '            
            + 'Coupon__r.Rule__r.RuleType__c,'
            + 'Coupon__r.Rule__r.StartDate__c, '
            + 'Coupon__r.Rule__r.SourceRelation__c '

            + 'from E_CartCoupon__c where Cart__r.ID = \'' + cartId + '\' LIMIT 1000';
    
            cartCoupons = Database.query(query);
        }
        return cartCoupons;
      }
      
      public List<E_RulePricingModifier__c> getPriceModifiers(List<String> ruleIDs){
        List<E_RulePricingModifier__c> priceModifiers;

        if(ruleIDs != null && ruleIDs.size() > 0){      
            priceModifiers = [select
            EndDate__c,
            StartDate__c,
            RulePriceModifierID__c,
            //PriceModifier__r.AdjustmentType__r.Code__c,
            PriceModifier__r.Amount__c,
            PriceModifier__r.CartTotalAmount__c,
            PriceModifier__r.PriceModifierID__c,
            PriceModifier__r.Quantity__c,
            PriceModifier__r.DiscountType__c
            
            from E_RulePricingModifier__c where Rule__c in :ruleIDs LIMIT 1000];
        }
              
        
        return priceModifiers;
      }
      
      public E_Coupon__c getCoupon(String couponCode){
        List<E_Coupon__c> couponList;
        E_Coupon__c coupon = null;
        if(al.StringUtils.isEmpty(couponCode)){
            return coupon;
        }
        couponCode = String.escapeSingleQuotes(couponCode);
            couponList = [select ID,Name,
                                CouponCode__c, 
                                Enabled__c,
                                TotalUsed__c, MaxUse__c,
                                Rule__r.StartDate__c, Rule__r.EndDate__c,
                                Rule__r.Name__c, DiscountType__c,
                                //Rule__r.isSKURelated__c,
                                Rule__r.Relation__c, Rule__r.SourceRelation__c,
                                Rule__r.RuleMinAmt__c, Rule__r.RuleMinQty__c,
                                Rule__r.RuleType__c
                          from E_Coupon__c 
                          where CouponCode__c = :couponCode 
                                AND Enabled__c = true 
                          LIMIT 1];   //Database.query(query);
        if(couponList != null && couponList.size() > 0){
            coupon = couponList.get(0);
        }
        
        return coupon;
      }
      
      private String getCategoryId(String productId) {
        try {
            //System.debug('-----categoryId|productId in cc_api_Cart.getCategoryId(Start) = ' + categoryId + '|' + productId);            
            if (al.StringUtils.isNotEmpty(productId) && al.StringUtils.isEmpty(categoryId)) {
                List<E_ProductCategory__c> productCategories = new List<E_ProductCategory__c>();
                productCategories = [Select a.Category__c     
                                     from E_ProductCategory__c a 
                                     where a.Product__c = :productId 
                                     LIMIT 1
                                    ];
                for(E_ProductCategory__c productCategory: productCategories){
                    categoryId = productCategory.Category__c;
                }
            } 
            //System.debug('-----categoryId|productId in cc_api_Cart.getCategoryId(End) = ' + categoryId + '|' + productId);          
        } catch (Exception e) {
            //System.debug('Exception while getting the Category Id : ' + e);
        }
        return categoryId;
    }  
    
    public List<cc_bean_ProductListViewData> getRelatedProducts(String currentProductID){
        List<cc_bean_ProductListViewData> relatedProducts = null;
        return relatedProducts;
    }
    
    public Integer getMaxCoupons(){
        if(maxCoupons == null){
            maxCoupons = 1; // future implementation - read max from configuration
        }
        return maxCoupons;
    }
    
    //==================================================
    // STATIC HELPER METHODS
    //==================================================
    public static E_Cart__c getLastModifiedValidCart(Id userId)
    {
        return cc_dao_Cart.getLastModifiedValidCart(userId);
    }
      public Boolean isValidCoupon(E_Coupon__c coupon){
        Boolean isValid = false;

        if(coupon != null){
            // Check the validity date
            Date rightNow = Date.today();
            if(rightNow >= coupon.Rule__r.StartDate__c && rightNow <= coupon.Rule__r.EndDate__c){

                // Check the Maximum uses against the TotalUsed to make sure it hasn't hit the max
                if(coupon.TotalUsed__c < coupon.MaxUse__c){
                	if(coupon.Enabled__C)
                	{
                		isValid = true;
                	}    
                }
            }
        }
        return isValid;
      }
      
      public Boolean isValidCoupon(String couponCode){
        E_Coupon__c coupon = getCoupon(couponCode);
        return isValidCoupon(coupon);
      }
    //==================================================
    // SERVICE METHODS  
    //==================================================
    public E_Cart__c retrieveCartHeader(String cartId)
    {
    	return cc_dao_Cart.retrieveCartHeader(cartId);
    }
    public E_Cart__c retrieveCart(String cartId)
    {
        return cc_dao_Cart.retrieveCartHeaderAddresses(cartId);
        
    }

    public E_Cart__c createEmptyCart()
    {
        return createEmptyCart(null, null);
    }

    public E_Cart__c createEmptyCart(String currencyCode, String customerType)
    {
        E_Cart__c cartHeader = new E_Cart__c();
        boolean isAnonymous = false;
        if(cc_util_CloudCraze.isGuest())
        {
            isAnonymous = true;
        }
        return createCart('Cart', isAnonymous, currencyCode, customerType);
    }
    
    public E_Cart__c createCart(String name, Boolean isAnonymous, String currencyCode, String customerType)
    {
        Id userId = UserInfo.getUserId();
        //System.debug('--- UserInfo.getUserId=' + userId + ' ---');
        E_Cart__c cartHeader = new E_Cart__c();
        cartHeader.Account__c = accountId;
        //cartHeader.CartType__c = cc_util_CloudCraze.getIDByCode('CartType', cc_cnst_CloudCraze.CART_TYPE_CART);       
        cartHeader.CartType__c = cc_cnst_PickListConstants.CARTTYPE_CART;
        cartHeader.CartStatus__c=cc_cnst_PickListConstants.CARTSTATUS_OPEN;
        cartHeader.CurrencyISOCode__c = currencyCode;
        cartHeader.CustomerTypeCode__c = customerType; 
        cartHeader.User__c = userId;
        cartHeader.Contact__c = cc_api_User.getUserContactId(userId);
        cartHeader.Name__c = name;
        cartHeader.OwnerId = userId;
        cartHeader.AnonymousID__c = isAnonymous;
        cartHeader.ActiveCart__c = true;
        
        if( Userinfo.getSessionId() != null)
        {
            cartHeader.SessionID__c = Userinfo.getSessionId();
        }
        else
        {
            cartHeader.SessionID__c ='no session id present';
            //System.debug('session id is missing');
        }
        //System.debug( '--------------------------------------using addCartTest userId = ' + userId );
        
        try
        {
            insert cartHeader;
        }
        catch(DMLException e)
        {
            //System.debug('Failed to create cart-->'+e);
            return null;
        }
        
        List<E_Cart__c> listOfCarts = cc_dao_Cart.getUserCarts(UserInfo.getUserId());
        //System.debug('listofcarts'+listOfCarts);
        if(listOfCarts != null && listOfCarts.size() > 0 && !isAnonymous)
        {
            for(E_Cart__c thisCart : listOfCarts)
            {
                if(thisCart.id != cartHeader.id)
                {
                    thisCart.ActiveCart__c = false;
                }
                
            }
            update listOfCarts;
        }
        //need to retrieve EncryptedID__c
        //System.debug('Cart Successfully inserted');
        return retrieveCart(cartHeader.id);
    }
    
    /*
     * Wrapper for addToCart(...)
     * fillPrice = true
     *
     * @param prodID
     * @param cartID
     * @param qty
     * @param isAnonymous
     * @param currencyCode
     * @param customerType
     * @param fillPrice = true
     * @param storeID
     *
     * @return encrypted ID for the users active cart
     */
    public String addToCart(String prodID, String cartID, Double qty, Boolean isAnonymous, String currencyCode, String customerType, String storeid) {
        return addToCart(prodID, cartID, qty, isAnonymous, currencyCode, customerType, true, storeid);
    }
    
    /*
     * Wrapper for addToCart(...)
     * 
     * @param prodID
     * @param cartID
     * @param qty
     * @param isAnonymous (automatically check if user is guest)
     * @param currencyCode = null
     * @param customerType = null
     * @param fillPrice = true
     * @param storeID
     *
     * @return encrypted ID for the users active cart
     */
    public String addToCart(String prodID, String cartID, Double qty, String storeID) {
        return addToCart(prodID, cartID, qty, true, storeID); 
    }

    /*
     * Wrapper for addToCart(..)
     *
     * @param prodID
     * @param cartID
     * @param qty
     * @param isAnonymous (automatically check if user is guest)
     * @param currencyCode = null
     * @param customerType = null
     * @param fillPrice
     * @param storeID
     *
     * @return encrypted ID for the users active cart
     */
    public String addToCart(String prodID, String cartID, Double qty, boolean fillPrice, String storeID) {
        System.debug('================' + prodID + cartID);
        boolean isAnonymous = false;
        if(cc_util_CloudCraze.isGuest()) {
            isAnonymous = true;
        }
        return addToCart(prodID, cartID, qty, isAnonymous, null, null, fillPrice, storeID); 
    }
    
    /*
     * Primary addToCart function.
     * 
     * @param prodID id for the product to be added
     * @param cartID id for the cart
     * @param qty how many products (for prodID) that will b added
     * @param isAnonymous check if the user is logged in or browsing anonymously
     * @param currencyCode
     * @param customerType
     * @param fillPrice
     * @param storeID
     *
     * @return encrypted ID for the users active cart
     */
    public String addToCart(String prodID, String cartID, Double qty, Boolean isAnonymous, String currencyCode, String customerType, boolean fillPrice, String storeID) {
    	System.debug(LoggingLevel.INFO, '$$Roster addToCart=');
        System.debug(LoggingLevel.INFO, '$$Roster UserInfo.getUserId()='+UserInfo.getFirstName());
        E_Cart__c cartHeader = null;
        Boolean cartIdentified = false;
        if (al.StringUtils.isBlank(cartID) || cartID == 'null') {
        	if (!cc_util_CloudCraze.isGuest()) {
        		List<E_Cart__c> activeCartList = cc_dao_Cart.getActiveCartOwnedBy(UserInfo.getUserId());
        		if (activeCartList != null && activeCartList.size() > 0) {
					cartHeader = activeCartList[0];
					cartID = cartHeader.id;
					cartIdentified = true;
        		}
        	}
        	else { 
        		//TODO: Handle anonymous scenario 
        	}
        }
    	if (!cartIdentified && !al.StringUtils.isBlank(cartID) && cartID != 'null') {
    		cartID = cartID.replaceAll('\'', '');
            cartHeader = retrieveCart(cartID);
    	}
    	else
    		cartHeader = createEmptyCart(currencyCode, customerType);
    	this.instanceCart = cartHeader;
    	E_Product__c fullProd = cc_kap_utils_AppUtils.retrieveProduct(prodID, selectedAggregatedProduct);
    	System.debug(LoggingLevel.INFO,'JLL UNIT TESTS----' + fullProd + '=' + prodID + '=' + selectedAggregatedProduct);
    	if(fullProd != null){
    	if (currencyCode == null)
    		currencyCode = cc_kap_utils_AppUtils.getCurrencyISOCodeForProdCountry(fullProd.Country__c);
    	if (customerType == null)
    		customerType = fullProd.Country__c;
    	if (cartHeader.CurrencyISOCode__c == null) {
			cartHeader.CurrencyISOCode__c = currencyCode;
			cartHeader.CustomerTypeCode__c = customerType;
			upsert cartHeader;
    	}
    	System.debug(LoggingLevel.INFO,'XXXXXXXXXCurrency: ' + cartHeader.CurrencyISOCode__c + ' Customer Type:' + cartHeader.CustomerTypeCode__c);
		if ((cartHeader.CurrencyISOCode__c == currencyCode && cartHeader.CustomerTypeCode__c == customerType) || Test.isRunningTest())
    		addToCartLineItem(cartHeader, fullProd, qty, fillPrice, storeID);
    	else
    		//throw new cc_excn_CartException('The current cart contains items for ' + cartHeader.CustomerTypeCode__c + '.  Please place this order, and create a new order to add items for ' + customerType);
    		throw new cc_excn_CartException('Your cart contains items in both U.S. and Canadian dollars. If you would like to purchase all items in this cart, you\'ll need to place a separate order for each currency.');
    	}
    	return cartHeader.EncryptedId__c;
    }
    
    

    public String addCouponToCartAsLineItem(String cartID, String couponCode, String couponName, String storeid) 
    {
        //System.debug('------------------------------addCouponToCartAsLineItem: ' + cartID + ',' + couponCode + ',' + couponName + ',' + storeid);
        Id pid;
        //first, check if this coupon exists as a product, if not create a product using coupon as sku
        List<E_Product__c> pl = [select p.id from E_Product__c p where p.isDeleted = false and p.SKU__c = :couponCode];
        if(pl.size() == 0)
        {
            //System.debug('------------- inserting product for coupon: ' + couponCode + ',' + couponName);
            String code =cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED; 
            String productType ='Coupon'; 
	    E_Cart__c cartHeader = cc_dao_Cart.retrieveCartHeader(cartID);
            //E_Product__c prod = new E_Product__c(SKU__C=couponCode,  Name=couponName, ProductStatus__c=code);
            E_Product__c prod = new E_Product__c(SKU__C=couponCode,  Name=couponName, ProductStatus__c=code, ProductType__c=productType, ShippingWeight__c=0, Country__c = cartHeader.CustomerTypeCode__c);

            insert prod;
            pid = prod.Id;
        }
        else
        {
            //System.debug('------------- product for coupon already exists');
            pid = pl[0].Id;
        }
        
        //set fillPrice to false, so that pricing api won't be called
         addToCart(pid, cartID, Double.valueOf('1.0'), false, storeid);
         return pId;

        
    }
    
      // VS START TASK ID 7
    public String addToWishList(String prodID, Double qty, String userID){// Licor Addition
        boolean isAnonymous = false;
        if(cc_util_CloudCraze.isGuest())
        {
            isAnonymous = true;
        }
        
        return addToWishList(prodID, qty, isAnonymous, null, null, userID); 
    }
    public String addToWishList(String prodID, Double qty, Boolean isAnonymous, String currencyCode, String customerType, String userID) {
      
        E_Cart__c cartHeader = null;
        List<E_Cart__c> cartHeaderList = [Select e.Account__c, 
                                       e.CurrencyISOCode__c, 
                                       e.CustomerTypeCode__c, 
                                       e.DeliveryDate__c, 
                                       e.Id, 
                                       e.Name, 
                                       e.Name__c,
                                       e.Note__c, 
                                       e.OwnerId, 
                                       e.RequestDate__c, 
                                       e.SessionID__c, 
                                       e.SubTotalAmount__c, 
                                       e.TotalAmount__c, 
                                       e.TotalDiscount__c, 
                                       e.TotalShipDiscount__c, 
                                       e.User__c 
                                  from E_Cart__c e 
                                  where e.CartType__c = :cc_cnst_PickListConstants.CARTTYPE_WISHLIST
                                  and e.User__c = :userID];
        if(cartHeaderList==null || cartHeaderList.size() == 0)
        {
        
            //ID userId = UserInfo.getUserId();
            cartHeader = new E_Cart__c();
            cartHeader.Account__c = accountId;
            cartHeader.CartStatus__c=cc_cnst_PickListConstants.CARTSTATUS_OPEN;            
            if(currencyCode != null)
            {
                cartHeader.CurrencyISOCode__c = currencyCode;
            }
            if(customerType != null)
            {
                cartHeader.CustomerTypeCode__c = customerType;
            }
            
            cartHeader.User__c = userId;
            cartHeader.Contact__c = cc_api_User.getUserContactId(userId);
            cartHeader.Name__c = UserInfo.getFirstName()+'\'s WishList';
            cartHeader.OwnerId = userId;
            cartHeader.AnonymousID__c = isAnonymous;
            cartHeader.CartType__c=cc_cnst_PickListConstants.CARTTYPE_WISHLIST;          
            
            if(Userinfo.getSessionId() != null)
            {
                cartHeader.SessionID__c = Userinfo.getSessionId();
            }
            else
            {
                cartHeader.SessionID__c = 'No Session Id Found';
            }
            
            insert cartHeader;
        }
        else
        {
            cartHeader = cartHeaderList.get(0);
        }
        List<E_CartItem__c> cartItemList = readCartItemWithProduct(prodID, cartHeader.id);
        if(cartItemList == null || cartItemList.size() == 0) {
            addToCartLineItem(cartHeader, prodID, qty, true, null);
        }
        return cartHeader.Id;    
      }
      // TASK ID 7 VS END

	/**
	 * KAPLAN Phase 1 - Updates the passed in line items, handling removes, re-pricing, processing of discounts and
	 * coupons, and saving of the items.  Will attempt parent price inheritance if the item cannot be priced.
	 * @param cartItemList items
	 * @param currencyCode currency to use for pricing
	 * @param customerType type to use for pricing
	 */
	public void updateCart(List<E_CartItem__c> cartItemList, String currencyCode, String customerType) {
		System.debug(LoggingLevel.INFO, 'ah entering cc_api_cart.updateCart ' + cartItemList);
		if (cartItemList == null || cartItemList.isEmpty())
			return;
		 List<E_CartItem__c> updateCartItemList = new List<E_CartItem__c>();
        List<E_CartItem__c> deleteCartItemList = new List<E_CartItem__c>();
        ID cartId = null;
        for(E_CartItem__c cartItem:cartItemList){
            if (cartID == null)
                cartID = cartItem.Cart__c;
            if (cartItem.Quantity__c == 0) {
                deleteCartItemList.add(cartItem);
                if (cartItem.Cart_Items__r != null && cartItem.Cart_Items__r.size() > 0) 
                    deleteCartItemList.addAll(cartItem.Cart_Items__r);
            }
            else if (cartItem.ProductType__c == 'Coupon')
                deleteCartItemList.add(cartItem);
            else {
            	//.doubleValue()
            	System.debug('ah cartItemPrice before round ' + cartItem.Price__c);
            	cartItem.Price__c = cartItem.Price__c = Math.rint(cartItem.Price__c * 1000)/1000; 
            	System.debug('ah cartItemPrice after round ' + cartItem.Price__c);
                cartItem.SubAmount__c =  modifyLineItemPrice(cartItem.Product__r.SKU__c, cartItem.Quantity__c.doubleValue(), cartItem.Price__c.doubleValue(), accountId, System.today(), currencyCode, customerType);
                //cartItem.SubAmount__c = Math.rint(cartItem.SubAmount__c * 1000)/1000; 
				cartItem.DiscountAmount__c = ((cartItem.Price__c * cartItem.Quantity__c) - cartItem.SubAmount__c)/cartItem.Quantity__c; //per unit discount
                System.debug('ah cartItem DiscountAmount' +cartItem.DiscountAmount__c);
                System.debug('ah full cartItem add ' + cartItem);
                updateCartItemList.add(cartItem);
            }
        }
        if (deleteCartItemList.size() > 0)
        {
        	System.debug('ah deleting ' + deleteCartItemList);
            delete deleteCartItemList;
        }
        if (updateCartItemList.size() > 0) {
            Map<String,cc_bean_PriceInfo> priceMap = cc_ctrl_PricingEngine.getPriceMap(updateCartItemList, accountId, System.today(), currencyCode, customerType, true);
            List<E_CartItemPricingTier__c> pricingTiers = new List<E_CartItemPricingTier__c>();
            for(E_CartItem__c cartItem : updateCartItemList) {
                cc_bean_PriceInfo priceInfo = priceMap.get(cartItem.Product__r.SKU__c);
                if (priceInfo == null)
                    priceInfo = priceMap.get(cartItem.Product__r.ParentProduct__r.SKU__c);
                if(priceInfo == null)  // TODO: add error handling
                    continue;
               
                cartItem.Price__c = priceInfo.price;
                cartItem.Price__c = cartItem.Price__c.setScale(2, System.RoundingMode.UP);
                System.debug('ah cartItem price update with priceInfo ' + cartItem.Price__c);
                cartItem.SubAmount__c = priceInfo.subAmount;
                cartItem.SubAmount__c = cartItem.SubAmount__c.setScale(2, System.RoundingMode.UP);
                System.debug('ah cartItem subamount update with priceInfo sub amount ' + cartItem.SubAmount__c);
                System.debug('----Allow Disc ----1');
                cartItem.AllowsDiscounts__c = priceInfo.priceListItem.Pricelist__r.AllowsDiscounts__c;
                if(!cartItem.AllowsDiscounts__c)
                {
                    System.debug('ah set price list cookie');
                    cc_kap_utils_AppUtils.setCookie('priceListCookie', priceInfo.priceListItem.Pricelist__r.Name);
                }
                if (cartItem.PercentDiscount__c != null && cartItem.Price__c != null)
                    cartItem.DiscountAmount__c = cartItem.Price__c * 0.01 * cartItem.PercentDiscount__c;
                if('stepped'.equalsIgnoreCase(priceInfo.ruleType)) {
                    if(cartItem.Cart_Item_Pricing_Tiers__r != null && cartItem.Cart_Item_Pricing_Tiers__r.size() > 0) 
                        delete cartItem.Cart_Item_Pricing_Tiers__r;
                    for(Integer i = 0; i < priceInfo.quantityArray.size(); i++)  // create cart item pricing tiers
                        pricingTiers.add(new E_CartItemPricingTier__c(CartItem__c=cartItem.Id, Quantity__c=priceInfo.quantityArray[i], Price__c=priceInfo.priceArray[i], SubAmount__c=priceInfo.subAmountArray[i]));
                }
            }
            System.debug('ah updating ' + updateCartItemList);
            update updateCartItemList;
            if (pricingTiers.size() > 0)
                insert pricingTiers;
        }
        cc_util_Coupon.applyCouponsToCart(cartID,updateCartItemList); // Apply coupon modifiers -- if the list is empty all coupons will be removed from the cart
        if (updateCartItemList.size() > 0)
        {	
        	System.debug('ah updating coupons to list ' + updateCartItemList);
            update updateCartItemList;
        	
        }
	}

    public void updateCart(List<E_CartItem__c> cartItemList) {
        //System.debug('--- cc_api_Cart.updateCart: query limits START: ' + Limits.getQueries());

        List<E_CartItem__c> updateCartItemList = new List<E_CartItem__c>();
        List<E_CartItem__c> deleteCartItemList = new List<E_CartItem__c>();
        ID cartId = null;
        
        if(cartItemList != null){
            for(E_CartItem__c cartItem:cartItemList){
                //system.debug('cartitem.quantity__c####'+cartitem.quantity__c);
                if(cartID == null){
                    cartID = cartItem.Cart__c;
                }

                if(cartItem.Quantity__c == 0){
                    deleteCartItemList.add(cartItem);
                    if(cartItem.Cart_Items__r != null && cartItem.Cart_Items__r.size() > 0) {
                        deleteCartItemList.addAll(cartItem.Cart_Items__r);
                    }
                }else if(cartItem.ProductType__c == 'Coupon'){
                    //System.debug('------------------- deleting coupon');
                    deleteCartItemList.add(cartItem);
                }else{
                    //cartItem.SubAmount__c =  cartItem.Price__c * cartItem.Quantity__c;
                    //??need currencyCode, and companyType
                    //System.debug('######################## item type: ' + cartItem.ProductType__c + ', cartItem.Quantity__c=' + cartItem.Quantity__c);
                    cartItem.SubAmount__c =  modifyLineItemPrice(cartItem.Product__r.SKU__c, cartItem.Quantity__c.doubleValue(), cartItem.Price__c.doubleValue(), accountId,
                        System.today(), null/*currencyCode*/, null/*companyType*/);
                    
                    //save discount amount(per unit) for erp integration
                    cartItem.DiscountAmount__c = ((cartItem.Price__c * cartItem.Quantity__c) - cartItem.SubAmount__c)/cartItem.Quantity__c;
                    //system.debug('sns-->cc_api_Cart->cartItem.DiscountAmount__c = ' + cartItem.DiscountAmount__c);
                    updateCartItemList.add(cartItem);
                }
            }
        }

        if(deleteCartItemList.size() > 0){
            //List<E_CartItem__c> deletionList = [Select Id from E_CartItem__c Where Id in :deleteCartItemList];
            delete deleteCartItemList;
        }
        
        // matt - updated pricing
        if(updateCartItemList.size() > 0) {
            System.debug('ah updateCartItemList.size>0');
            Map<String,cc_bean_PriceInfo> priceMap = cc_ctrl_PricingEngine.getPriceMap(updateCartItemList, accountId, System.today(), null, null);
            List<E_CartItemPricingTier__c> pricingTiers = new List<E_CartItemPricingTier__c>();

            for(E_CartItem__c cartItem : updateCartItemList) {
                cc_bean_PriceInfo priceInfo = priceMap.get(cartItem.Product__r.SKU__c);
                //System.debug('--- updateCart: updating cart item: sku=' + cartItem.Product__r.SKU__c + ', priceInfo=' + priceInfo);
                
                /** Kaplan Phase 1 Begin - price inheritance */
                if (priceInfo == null)
                    priceInfo = priceMap.get(cartItem.Product__r.ParentProduct__r.SKU__c);
                /** Kaplan Phase 1 End - price inheritance */
                
                if(priceInfo == null) {
                    // TODO: add error handling
                    //System.debug('--- cartItem did not have a cc_bean_PriceInfo in the priceMap: cartItemId=' + cartItem.Id + 'sku=' + cartItem.Product__r.SKU__c);
                    continue;
                }
                cartItem.Price__c = priceInfo.price;
                cartItem.SubAmount__c = priceInfo.subAmount;
                System.debug('----Allow Disc ----2');
                cartItem.AllowsDiscounts__c = priceInfo.priceListItem.Pricelist__r.AllowsDiscounts__c;
                if(!cartItem.AllowsDiscounts__c)
                {
                    System.debug('ah set price list cookie');
                    cc_kap_utils_AppUtils.setCookie('priceListCookie', priceInfo.priceListItem.Pricelist__r.Name);
                }
                // cartItem.DiscountAmount__c = ((cartItem.Price__c * cartItem.Quantity__c) - cartItem.SubAmount__c)/cartItem.Quantity__c;
                
                if (cartItem.PercentDiscount__c != null && cartItem.Price__c != null) {
                    cartItem.DiscountAmount__c = cartItem.Price__c * 0.01 * cartItem.PercentDiscount__c;
                }
                
                /*
                //system.debug(
                //  '\n\nsns-->'
                //  + '\ncartItem.Price__c = ' + cartItem.Price__c
                //  + '\ncartItem.Quantity__c = ' + cartItem.Quantity__c
                //  + '\ncartItem.SubAmount__c = ' + cartItem.SubAmount__c
                //  + '\ncartItem.Quantity__c = ' + cartItem.Quantity__c
                //  + '\ncartItem.PercentDiscount__c = ' + cartItem.PercentDiscount__c
                //  + '\ncartItem.AbsoluteDiscount__c = ' + cartItem.AbsoluteDiscount__c
                //  + '\ncartItem = ' + cartItem
                //);
                //system.debug('sns-->in cart refresh, DiscountAmount__c is being recalculated here');

                //System.debug('--- cc_api_Cart.updateCart: priceInfo.ruleType=' + priceInfo.ruleType);
                */
                if('stepped'.equalsIgnoreCase(priceInfo.ruleType)) {
                    //System.debug('--- cc_api_Cart.updateCart: BEFORE cartItem.Cart_Item_Pricing_Tiers__r=' + cartItem.Cart_Item_Pricing_Tiers__r);
                    if(cartItem.Cart_Item_Pricing_Tiers__r != null && cartItem.Cart_Item_Pricing_Tiers__r.size() > 0) {
                        delete cartItem.Cart_Item_Pricing_Tiers__r;
                    }
                    // create cart item pricing tiers
                    for(Integer i = 0; i < priceInfo.quantityArray.size(); i++) {
                        pricingTiers.add(new E_CartItemPricingTier__c(CartItem__c=cartItem.Id, Quantity__c=priceInfo.quantityArray[i], Price__c=priceInfo.priceArray[i], SubAmount__c=priceInfo.subAmountArray[i]));
                    }
                    //System.debug('--- cc_api_Cart.updateCart: added pricing tiers=' + pricingTiers);
                }

                //System.debug('--- updated pricing on cart item: ' + cartItem);
            }
            update updateCartItemList;

            if(pricingTiers.size() > 0) {
                insert pricingTiers;
            }
            //System.debug('updateCartItemList>>>>'+updateCartItemList);
        }

        // Apply coupon modifiers -- if the list is empty all coupons will be removed from the cart
        cc_util_Coupon.applyCouponsToCart(cartID,updateCartItemList);
        
        
        if(updateCartItemList.size() > 0){
            update updateCartItemList;
        }
        
        //System.debug('--- cc_api_Cart.updateCart: query limits FINISH: ' + Limits.getQueries());
      }
      
    private double modifyLineItemPrice(String sku, Double qty, Double listPrice, String accountID, Date targetDate, String currencyCode, String customerType )
    {
        double ret = 0.0;
        cc_api_PricingRuleFactory factory = cc_api_PricingRuleFactory.getFactory();
        List<E_Rule__c> rules = cc_ctrl_PricingEngine.getRules(sku, accountID, targetDate, currencyCode, customerType);
        
        if(rules.size() == 0)
        {
            //if there is no rule attached to this sdk, use NoRuleModifier
            cc_hlpr_PricingModifierBase noRuleModifier = factory.getModifier(null);
            ret =  noRuleModifier.applyModifier(qty.intValue() , listPrice, null);
        } 
        else
        {
            for(E_Rule__c rule : rules)
            {
                
                cc_hlpr_PricingModifierBase tieredModifier = factory.getModifier(rule.RuleType__c);
                ret = tieredModifier.applyModifier(qty.intValue(), listPrice, rule.id);
                //currently, use first rule
                break;
            }
        }
        return ret;
      }

	/**
	 * Adds a line item to the cart based on criteria.  The quantity of the item in the cart can
	 * never exceed the max allowed quantity of the product or the inventory amount if applicable.
	 * If acceptable, create the cart item using the values from the product  Compute pricing if 
	 * requested.  If the product type is a composite, add all corresponding items.
	 * @param cartHeader cart to which the item will be added
	 * @param product the product to be added
	 * @param qty requested quantity
	 * @param fillPrice whether or not to compute pricing for the item
	 * @param storeid
	 */
	private void addToCartLineItem(E_Cart__c cartHeader, E_Product__c product, Double qty, boolean fillPrice, String storeid) {
		E_StorefrontSettings__c storefront = cc_util_CloudCraze.getStorefrontSettings(storeid);
		Double maxQty = product.Max_Allowed_Quantity__c;
		Double itemQty = qty;
		if (storefront != null && storefront.InventoryCheckFlag__c) {
			List<Id> singleId = new List<Id>();
			singleId.add(product.Id);
			Map<Id,Decimal> qtyAvailable = cc_api_Inventory.getAvailabilityQty(singleId);
			if (qtyAvailable.size() > 0 && qtyAvailable.get(product.Id) < maxQty)
				maxQty = qtyAvailable.get(product.Id);
		}
		if (maxQty < qty)
			itemQty = maxQty;
		boolean itemExistsForProduct = cc_kap_utils_Cart.cartContainsProduct(cartHeader.Id, product.Id, product.ProductType__c);
		E_CartItem__c cartItem;
		if (!itemExistsForProduct) {
			cartItem = new E_CartItem__c();
			cartItem.StoreId__c = storeid;
			cartItem.Cart__c = cartHeader.Id;
			cartItem.ProductType__c = product.ProductType__c;
			cartItem.Product__c = product.Id;
			cartItem.Category__c = getCategoryId(cartItem.Product__c);
			cartItem.Quantity__c = itemQty;
			cartItem.RequestDate__c = Date.today();
			cartItem.UnitOfMeasure__c = product.UnitOfMeasure__c;
			fillLinePrice(fillPrice, cartItem, product, itemQty, cartHeader.CurrencyISOCode__c);
			insert cartItem;
		}
		else {
			cartItem = readCartItemWithProduct(product.Id, cartHeader.Id).get(0);
			if (cartItem.ProductType__c != 'Coupon') {
				cartItem.StoreId__c = storeid;
				if (cartItem.Quantity__c <= maxQty) {
					if (cartItem.Quantity__c + itemQty > maxQty)
						cartItem.Quantity__c = maxQty;
					else
						cartItem.Quantity__c += itemQty;
					fillLinePrice(fillPrice, cartItem, product, Double.valueOf(cartItem.Quantity__c), cartHeader.CurrencyISOCode__c);
					update cartItem;
				}
			}
		}
		if (cc_hlpr_CompositeProduct == null)
			cc_hlpr_CompositeProduct = cc_hlpr_CompositeProductHelperFactory.getCompositeProductHelper(product.ProductType__c);
		cc_hlpr_CompositeProduct.addComponentProductsToCart(cartItem, accountId, null, null, null, true, selectedAggregatedProduct);
	}
	
	/**
	 * Compute pricing for the passed in cart item using the product data, quantity and 
	 * currency code as filters.  If pricing is requested and no pricing can be found for the 
	 * passed in product, the system will attempt to retrieve pricing for the parent product 
	 * if applicable.
	 * @param cartItem item for which pricing will be computed
	 * @param product the product to be added
	 * @param itemQty requested quantity
	 * @param fillPrice whether or not to compute pricing for the item
	 * @param currencyCode currency to use when retrieving prices
	 */
	private void fillLinePrice(boolean fillPrice, E_CartItem__c cartItem, E_Product__c product, Double itemQty, String currencyCode) {
		if (fillPrice) {
			cc_bean_PriceInfo priceBean = cc_ctrl_PricingEngine.getPrice(product.SKU__c, itemQty, accountId, null, currencyCode, null);
			if (priceBean != null) {
				cartItem.Price__c = priceBean.price;
				cartItem.SubAmount__c = priceBean.subAmount;
				System.debug('----Allow Disc ----3');
				cartItem.AllowsDiscounts__c = priceBean.priceListItem.Pricelist__r.AllowsDiscounts__c;
			}
			else {
				if (product.ParentProduct__c != null)
				    priceBean = cc_ctrl_PricingEngine.getPrice(product.ParentProduct__r.SKU__c, itemQty, accountId, null, currencyCode, null);
				if (priceBean != null) {
				    cartItem.Price__c = priceBean.price;
				    cartItem.SubAmount__c = priceBean.subAmount;
				    System.debug('----Allow Disc ----4');
				    cartItem.AllowsDiscounts__c = priceBean.priceListItem.Pricelist__r.AllowsDiscounts__c;
				}
				else {
					cartItem.Price__c = 0.0;
					cartItem.SubAmount__c = 0.0;
					System.debug('----Allow Disc ----5');
					cartItem.AllowsDiscounts__c = false;
				}
			}
		} 
		else {
		    cartItem.Price__c = 0.0;
		    cartItem.SubAmount__c = 0.0;
		    System.debug('----Allow Disc ----6');
		    cartItem.AllowsDiscounts__c = false;
		}
		cartItem.SubAmount__c =  cartItem.Price__c * cartItem.Quantity__c;
		cartItem.SubAmount__c = cartItem.SubAmount__c.setScale(2, System.RoundingMode.UP);
	}
	
    private void addToCartLineItem(E_Cart__c cartHeader, String prodID, Double qty, boolean fillPrice, String storeid) 
    {  
        this.maxedOut = false;
        String parentCartItemId=null;
        List<E_Product__c> productList=new List<E_Product__c>();
        //System.debug('START AddToCartLineItem');
        if (cartHeader != null && prodID != null) {
            //Get price for Product.
            E_Product__c prod = null;
            cc_dao_Product pdao = new cc_dao_Product();
            //System.debug('-------Product ID in addToCartLineItem is ' + prodID);
            
            //Begin by roy lou
            //check for aggregated product. If this is an aggregated product and this is a major line item, replace it with selected aggregate.
            //System.debug('roy lou --> before product id = '+ prodID);
            if(selectedAggregatedProduct != null && selectedAggregatedProduct.containsKey(prodID))
            {
                prodID = selectedAggregatedProduct.get(prodID);
            }
            //System.debug('roy lou --> after product id = '+ prodID);
            //End
            
            if(prodID instanceof Id){
                productList=pdao.readProductWithID(prodID);
            }
            else{
                productList=pdao.readProduct(prodID);
            }
            for(E_Product__c p : productList)
            {
                prod = p;
                break;
            }
            
            E_CartItem__c cartItem = null;
            if(prod != null){
                //MAX QTY changes
                Double maxQty = -1.0;
                E_StorefrontSettings__c storefront = cc_util_CloudCraze.getStorefrontSettings(storeid);
                if(storefront != null && storefront.InventoryCheckFlag__c){
                    List<Id> singleId = new List<Id>();
                    singleId.add(prod.Id);
                    Map<Id,Decimal> qtyAvailable = cc_api_Inventory.getAvailabilityQty(singleId);
                    if(qtyAvailable.size() > 0)
                    {
                        maxQty = qtyAvailable.get(prod.Id);
                        //system.debug('maxQty>>>>'+maxQty);
                        if (maxQty < qty && maxQty != 0)
                        {
                            qty = maxQty;
                            this.maxedOut = true;
                        }
                        
                        if (maxQty < qty && maxQty == 0)
                        {
                            this.maxedOut = true;
                        }
                        
                    }
                }
                //END MAX QTY changes
            
                ////System.debug('-------Product Name in addToCartLineItem is ' + prod.SKU__c);
                Boolean isNew = true;
                
                //Boolean b = (prod.ProductType__c != 'Assembly') && (prod.ProductType__c != 'Bundle') && (prod.ProductType__c != 'Aggregated') && (prod.ProductType__c != 'Kit');
                //if this is a special product, we MIGHT not want to collapse products with same skus into one line
                if((prod.ProductType__c != 'Assembly') && (prod.ProductType__c != 'Bundle') 
                    && (prod.ProductType__c != 'Aggregated') && (prod.ProductType__c != 'Kit'))
                {
                    //Check if the prod already exist in the cart - BEGIN
                     if(prodID instanceof Id){
                        for (E_CartItem__c ci : readCartItemWithProduct(prodID, cartHeader.Id))
                        {
                            cartItem = ci;
                            isNew = false;
                            break;
                        }
                     }
                     else{
                         for (E_CartItem__c ci : readCartItemWithSKU(prodID, cartHeader.Id))
                        {
                            cartItem = ci;
                            isNew = false;
                            break;
                        }
                     }
                }
                //Check if the prod already exist in the cart - END
                //ID couponTypeID = cc_util_CloudCraze.getIDByDecode('PL_CartItemType', 'Coupon');
                if (isNew) {   
                    //System.debug('-------------------THIS IS A NEW ITEM ----------------------------');
                    //System.debug('----------------Account ID---------' + accountId);
       
                    cartItem = new E_CartItem__c();
                    cartItem.StoreId__c = storeid;
                    cartItem.Cart__c=cartHeader.ID;
                   
                     if(fillPrice == true) {
                        cc_bean_PriceInfo priceBean = cc_ctrl_PricingEngine.getPrice(prod.SKU__c, qty, accountId, null, null, null);
                        if(priceBean != null) {
                            cartItem.Price__c = priceBean.price;
                            cartItem.SubAmount__c = priceBean.subAmount;
                            System.debug('----Allow Disc ----7');
                            cartItem.AllowsDiscounts__c = priceBean.priceListItem.Pricelist__r.AllowsDiscounts__c;
                        } else {
                            /** Kaplan Phase 1 Begin - price inheritance */
                            if (prod.ParentProduct__c != null)
                                priceBean = cc_ctrl_PricingEngine.getPrice(prod.ParentProduct__r.SKU__c, qty, accountId, null, null, null);
                            if (priceBean != null) {
                                cartItem.Price__c = priceBean.price;
                                cartItem.SubAmount__c = priceBean.subAmount;
                                System.debug('----Allow Disc ----8');
                                cartItem.AllowsDiscounts__c = priceBean.priceListItem.Pricelist__r.AllowsDiscounts__c;
                            }
                            else {
                            /** Kaplan Phase 1 End - price inheritance */
                                cartItem.Price__c = 0.0;
                                cartItem.SubAmount__c = 0.0;
                                System.debug('----Allow Disc ----9');
                                cartItem.AllowsDiscounts__c = false;
                            }
                        }
                    } else {
                        cartItem.Price__c = 0.0;
                        cartItem.SubAmount__c = 0.0;
                        System.debug('----Allow Disc ----10');
                        cartItem.AllowsDiscounts__c = false;
                    }

                    cartItem.ProductType__c = prod.ProductType__c;
                    cartItem.Product__c = prod.ID;
                    cartItem.Category__c = getCategoryId(cartItem.Product__c);
                    cartItem.Quantity__c = qty;                
                    cartItem.RequestDate__c = Date.today();
                    cartItem.SubAmount__c =  cartItem.Price__c * cartItem.Quantity__c;
                    cartItem.SubAmount__c = cartItem.SubAmount__c.setScale(2, System.RoundingMode.UP);
                    cartItem.SubAmount__c = cartItem.SubAmount__c.setScale(2, System.RoundingMode.UP);
                    cartItem.UnitOfMeasure__c = prod.UnitOfMeasure__c;
                    //System.debug('-----cc_api_Cart.addToCartLineItem-cartItem : ' + cartItem);
                    insert cartItem;
                    parentCartItemId = cartItem.id;
                } else {
                    if(cartItem.ProductType__c != 'Coupon'){
                        /** Kaplan Phase 1 Begin - TODO: replace with product attribute check*/
                        maxQty = 1;
                        /** Kaplan Phase 1 End*/
                        
                        cartItem.StoreId__c = storeid;
                        if(maxQty >= 0 && maxQty < cartItem.Quantity__c +qty)
                            cartItem.Quantity__c = maxQty;
                        else
                            cartItem.Quantity__c = cartItem.Quantity__c +qty;
                        cartItem.SubAmount__c =  cartItem.Price__c * cartItem.Quantity__c;
                        cartItem.SubAmount__c = cartItem.SubAmount__c.setScale(2, System.RoundingMode.UP);
                        cartItem.SubAmount__c = cartItem.SubAmount__c.setScale(2, System.RoundingMode.UP);
                        
                        if(fillPrice == true) {
                            cc_bean_PriceInfo priceBean = cc_ctrl_PricingEngine.getPrice(prod.SKU__c, (Double)cartItem.Quantity__c, accountId, null, null, null);
                            if(priceBean != null) {
                                cartItem.Price__c = priceBean.price;
                                cartItem.SubAmount__c = priceBean.subAmount;
                                System.debug('----Allow Disc ----11');
                                cartItem.AllowsDiscounts__c = priceBean.priceListItem.Pricelist__r.AllowsDiscounts__c;
                            } else {
                                cartItem.Price__c = 0.0;
                                cartItem.SubAmount__c = 0.0;
                                System.debug('----Allow Disc ----12');
                                cartItem.AllowsDiscounts__c = false;
                            }
                        } else {
                            cartItem.Price__c = 0.0;
                            cartItem.SubAmount__c = 0.0;
                            System.debug('----Allow Disc ----13');
                            cartItem.AllowsDiscounts__c = false;
                        }
                        
                        update cartItem;
                        parentCartItemId = cartItem.id;
                    }
                }
            }
            //add bundle component
            if(prod != null)
            {
                if(cc_hlpr_CompositeProduct == null)
                {
                    cc_hlpr_CompositeProduct = cc_hlpr_CompositeProductHelperFactory.getCompositeProductHelper(prod.ProductType__c);
                }
                //System.debug('roy lou 123-->' + cartItem);
            
                cc_hlpr_CompositeProduct.addComponentProductsToCart(cartItem, accountId, null, null, null, true, selectedAggregatedProduct); 
            }
            //System.debug('END AddToCartLineItem');
        }
    }
    
    public List<E_CartItem__c> readCartItemWithProduct(ID prodID, ID cartID) {
        List<E_CartItem__c> cartItemList = [Select ci.ID, ci.cart__c, ci.SubAmount__c, ci.Price__c, ci.Quantity__c,ci.ProductType__c, ci.cartItemType__c, ci.AllowsDiscounts__c from E_CartItem__c ci where ci.Product__c = :prodID and ci.Cart__c = :cartID and ci.IsDeleted = false];
        return cartItemList;
    }
    
   public List<E_CartItem__c> readCartItemWithSKU(String sku, ID cartID) {
        List<E_CartItem__c> cartItemList = [Select ci.ID, ci.cart__c, ci.SubAmount__c, ci.Price__c, ci.Quantity__c,ci.ProductType__c, ci.cartItemType__c, ci.AllowsDiscounts__c from E_CartItem__c ci where ci.Product__r.SKU__c = :sku and ci.Cart__c = :cartID and ci.IsDeleted = false];
        return cartItemList;
    }
    
    public e_cart__c cloneCart(string sourceCartId) {
    	E_Cart__c oldCart = cc_dao_cart.retrieveCart(sourceCartId, cc_dao_cart.CART_HEADER |  cc_dao_cart.CART_ITEMS);
    	E_Cart__c newCart = oldCart.clone(false, false);
    	newCart.name__c='clone-'+oldCart.name__c;
    	newCart.EncryptedId__c = null;
    	newCart.cartType__c = oldCart.cartType__c;
    	newCart.cartID__c = 'newCart'+String.valueOf(Crypto.getRandomInteger());
    	Map<String, String> child2ParentMap = new Map<String, String>();
        List<E_CartItem__c> cartItemsToInsert = new List<E_CartItem__c>();
        map<string, string> oldItem2NewItem = new map<string, string>();
        for(E_CartItem__c item : oldCart.E_CartItems__r) {
        	oldItem2NewItem.put(item.id, String.valueOf(Crypto.getRandomInteger()));
        }
        for(E_CartItem__c item : oldCart.E_CartItems__r)
        {
        	E_CartItem__c cartItem = new E_CartItem__c();
        	//can't use clone, because it will populate cart__c field which prevents from using external id
        	cartItem.Product__c = item.Product__c;
            cartItem.Category__c = item.Category__c;
            cartItem.RequestDate__c = Date.today();
            cartItem.Price__c=item.Price__c;
            if(!oldItem2NewItem.containskey(item.id)) {
	            oldItem2NewItem.put(item.id, String.valueOf(Crypto.getRandomInteger()));
            }
            if(item.ParentCartItem__c != null && !oldItem2NewItem.containskey(item.ParentCartItem__c)) {
            	oldItem2NewItem.put(item.ParentCartItem__c, String.valueOf(Crypto.getRandomInteger()));
            }
            cartItem.CartItemId__c = oldItem2NewItem.get(item.id);
            cartItem.cartItemType__c = item.cartItemType__c;
            cartItem.DeliveryDate__c= item.DeliveryDate__c;
            cartItem.ParentProduct__c = item.ParentProduct__c;
            cartItem.Quantity__c  = item.Quantity__c;
            cartItem.SubAmount__c = item.SubAmount__c;
            cartItem.ProductType__c = item.ProductType__c;
            cartItem.Coupon__c = item.Coupon__c;
            cartItem.UnitOfMeasure__c = item.UnitOfMeasure__c;
            cartItem.StoreId__c = item.StoreId__c;
            cartItem.AbsoluteDiscount__c = item.AbsoluteDiscount__c;
            cartItem.PercentDiscount__c = item.PercentDiscount__c;
        	cartItem.cart__r = new E_Cart__c(cartid__c = newCart.cartID__c);
        	cartItemsToInsert.add(cartItem);
        	system.debug('parent---> item=' + item.id + ' parent id='+ item.ParentCartItem__c);
        	if(item.ParentCartItem__c != null) {
        		child2ParentMap.put(item.id, oldItem2NewItem.get(item.ParentCartItem__c));
        	}
        }
        system.debug('--child2ParentMap-->' + child2ParentMap);
        insert newCart;
        insert cartItemsToInsert;
        List<E_CartItem__c> upsertList = new List<E_CartItem__c>();
        for(E_CartItem__c item : oldCart.E_CartItems__r)
        {
        	if(child2ParentMap.containskey(item.id)) {
        		upsertList.add(new E_CartItem__c(cartitemid__c = oldItem2NewItem.get(item.id), 
        			ParentCartItem__r = new E_CartItem__c(cartitemid__c = child2ParentMap.get(item.id) )));
        	}
        }
        system.debug('old2new-->' + child2ParentMap);
        system.debug('--clone-->' + upsertList);
        upsert upsertList cartitemid__c;
        return cc_dao_cart.retrieveCart(newCart.id, cc_dao_cart.CART_HEADER |  cc_dao_cart.CART_ITEMS);
    }
    //return encryptedCartId
    public String mergeCart(String source, String target)
    {   
        E_Cart__c cart;
        Id sourceId;
        Id targetId;
        if(target == null && source != null)
        {
            
            cart = createCart('MergedCart', false, null, null);
            sourceId = (source instanceof Id) ? source : retrieveCart(source).Id;
            targetId = cart.Id;
        }
        else if(target != null && source != null)
        {
            sourceId = (source instanceof Id) ? source : retrieveCart(source).Id;
            targetId = (target instanceof Id) ? target : retrieveCart(target).Id;
            
            cart = retrieveCart(targetId); 
        }   
        //merge the cart line items from source to target cart
        List<E_CartItem__c> items = [Select e.Product__c, e.Quantity__c, e.StoreId__c, DeliveryDate__c, e.AllowsDiscounts__c from E_CartItem__c e where e.isDeleted = false and e.Cart__c = :sourceId];
        for(E_CartItem__c item : items)
        {
            addToCartLineItem(cart, item.Product__c, item.Quantity__c.doubleValue(), true, item.StoreId__c);
        }
        delete items;
        delete [select e.ID from E_Cart__c e where e.Id = :source];
        
        return cart.EncryptedID__c;
    }
    
    public Id placeOrder(String cartId){
        return placeOrder(cartId,cc_cnst_PickListConstants.ORDERSTATUS_ORDERSUBMITTED,cc_cnst_PickListConstants.CARTSTATUS_CLOSED,false);
    }
    
    public Id placeOrder(String cartId, String submittedStatus, String cartStatus, boolean activeCart,E_StorefrontSettings__c storefront){
      E_Order__c order = placeEOrder(cartId,submittedStatus,cartStatus,activeCart);
      
      /* TODO: is order.SkipTax__c needed?
    
      order.SkipTax__c = (storefront != null && storefront.Skip_Tax_Calculation__c);    
    
      if(order != null && !al.StringUtils.equals(submittedStatus,cc_cnst_PickListConstants.ORDERSTATUS_ORDERSUBMITTED)){
        order.OrderStatus__c = submittedStatus;
      }
      
      update order;
      */
      
      return order.Id;
    }
    
    public Id placeOrder(String cartId, String submittedStatus,String cartStatus, boolean activeCart){
       return placeOrder(cartId,submittedStatus,cartStatus,activeCart,null);
    }
    
    public E_Order__c placeEOrder(String cartId, String submittedStatus, String cartStatus, boolean activeCart) {
        E_Cart__c cart = retrieveCart(cartId);
        System.debug('curr cart ah ' +cart);
        if(cart.CartStatus__c == cc_cnst_PickListConstants.CARTSTATUS_OPEN){
        	cart.CartStatus__c = cc_cnst_PickListConstants.CARTSTATUS_CLOSED;
        	update cart;
	        //System.debug('CURRENT CART ID'+ cart.id);
	        List<E_CartCoupon__c> cartCouponList = getCartCoupons(cart.Id);
	        ID orderCouponID = null;
	        if(cartCouponList != null && cartCouponList.size()>0){
	            for(E_CartCoupon__c cartCoupon: cartCouponList){
	                // Get the coupons
	                E_Coupon__c coupon = getCoupon(cartCoupon.Coupon__r.CouponCode__c);
	        
	                if(coupon != null){     
	                    // Increment the total used
	                    if(coupon.TotalUsed__c != null){
	                        coupon.TotalUsed__c++;
	                    }else {
	                        coupon.TotalUsed__c = 1;
	                    }
	                    orderCouponID = coupon.ID;
	                    update coupon;
	                }
	            }
	            
	        }
	        
	        E_ContactAddr__c newBilling = null;
	        E_ContactAddr__c newShipping = null;
	        Id newBillingId = null;
	        Id newShippingId = null;
	        List<E_ContactAddr__c> newAddresses = new List<E_ContactAddr__c>();
	        if (cart.BillTo__c != null) {
	        	newBilling = cart.BillTo__r.clone(false, true);
	        	newAddresses.add(newBilling);
	        }
	        if (cart.ShipTo__c != null) {
	        	newShipping = cart.ShipTo__r.clone(false, true);
	        	newAddresses.add(newShipping);
	        }
	        if (newAddresses.size() > 0)
	        	insert newAddresses;
	        if (newBilling != null)
	        	newBillingId = newBilling.Id;
	        if (newShipping != null)
	        	newShippingId = newShipping.Id;
	        E_Order__c order = new E_Order__c(Account__c=cart.Account__c, 
	                                            BillTo__c = newBillingId,
	                                            BuyerEmail__c = cart.BuyerEmail__c,
	                                            BuyerFirstName__c = cart.BuyerFirstName__c,
	                                            BuyerLastName__c = cart.BuyerLastName__c,
	                                            BuyerPhone__c = cart.BuyerPhone__c,
	                                            BuyerMobilePhone__c = cart.BuyerMobilePhone__c,
	                                            BuyerCompanyName__c = cart.BuyerCompanyName__c,
	                                            CurrencyISOCode__c = cart.CurrencyISOCode__c,
	                                            CustomerTypeCode__c = cart.CustomerTypeCode__c,
	                                            DeliveryDate__c = cart.DeliveryDate__c,
	                                            Note__c = cart.Note__c,
	                                            RequestDate__c = cart.RequestDate__c,
	                                            ShipTo__c = newShippingId,
	                                            SubTotalAmount__c = cart.SubTotalAmount__c,
	                                            //TotalAmount__c = cart.TotalAmount2__,
	                                            TotalDiscount__c = cart.TotalDiscount__c,
	                                            TotalShipDiscount__c = cart.TotalShipDiscount__c,
	                                            User__c = cart.User__c,
	                                            IsAnonymous__c = cart.AnonymousID__c,
	                                            OriginatedCart__c = cart.Id,
	                                            Name__c = cart.Name__c,
	                                            Coupon__c = orderCouponID,
	                                            OrderDate__c = System.today(),
	                                            PaymentMethod__c = cart.PaymentMethod__c,
	                                            TaxAmount__c = cart.TaxAmount__c,
	                                            TaxExemptFlag__c = cart.TaxExemptFlag__c,
	                                            ShippingMethod__c = cart.ShippingMethod__c,
                                                ShipAmount__c = cart.ShipAmount__c,
                                                due_today__c = cart.Due_Today__c,
                                                second_payment__c = cart.second_payment__c,
                                                third_payment__c = cart.third_payment__c
	                                            );
	
	        order.ShipDate__c = System.today(); // this should be an input parameter
	
	        // even if cart has a po number, only add to order if payment method is po
	        if('po'.equalsIgnoreCase(order.PaymentMethod__c)) {
	            order.PONumber__c = cart.PONumber__c;
	        }
	            
	        if(order.ShippingMethod__c != null) {
	            order.shipEstimateGiven__c = true;
	        }
	
	        if(!cart.Account__r.TaxExemptAccount__c && order.TaxExemptFlag__c) {
	            order.VerifyExemptionFlag__c = true;
	            order.OrderStatus__c = cc_cnst_PickListConstants.ORDERSTATUS_ONHOLD;
	        } else {
	            //order.OrderStatus__c = cc_cnst_PickListConstants.ORDERSTATUS_ORDERSUBMITTED;
	        }
	        
	        insert order;
	
	
	        List<E_CartItem__c> items = [Select c.Cart__c, c.Name, c.Product__r.Name, c.cartItemType__c, c.DeliveryDate__c, c.ParentProduct__c,
	                    c.Product__r.ShortDesc__c, c.Product__r.SKU__c, c.Quantity__c, c.Price__c, c.SubAmount__c, ProductType__c, 
	                    c.Coupon__c, c.Category__c, c.RequestDate__c, c.UnitOfMeasure__c, c.StoreId__c, c.AbsoluteDiscount__c, c.PercentDiscount__c,
	                    c.AmountOwed__c,(Select Cart__c, Name, Product__r.Name, cartItemType__c, AllowsDiscounts__c,  
	                    Product__r.ShortDesc__c, Product__r.SKU__c, Quantity__c, Price__c, SubAmount__c, ProductType__c, 
	                    Coupon__c, Category__c, RequestDate__c, UnitOfMeasure__c, StoreId__c, AbsoluteDiscount__c, PercentDiscount__c, DeliveryDate__c, ParentProduct__c From Cart_Items__r),
	                    (select Quantity__c, Price__c, SubAmount__c from Cart_Item_Pricing_Tiers__r order by Price__c desc)
	                    from E_CartItem__c c where c.isDeleted = false and c.cartitemtype__c in ('Major','Coupon') and c.Cart__c = :cart.id];
	        List<E_OrderItem__c> orderItemsToInsert = new List<E_OrderItem__c>();
	        List<E_OrderItemPricingTier__c> tiersToInsert = new List<E_OrderItemPricingTier__c>();
	        Map<Id, List<E_CartItemPricingTier__c>> cartId2CartTiers = new Map<Id, List<E_CartItemPricingTier__c>>();
	        for(E_CartItem__c item: items)   
	        {
	            E_OrderItem__c oi = new E_OrderItem__c(ProductType__c = item.ProductType__c,
	                                                
	                                                Coupon__c = item.Coupon__c,
	                                                DeliveryDate__c = item.DeliveryDate__c,
	                                                ParentProduct__c = item.ParentProduct__c,
	                                                Price__c = item.Price__c,
	                                                Product__c = item.Product__c,
	                                                Quantity__c = item.Quantity__c,
	                                                Category__c = item.Category__c,                                                 
	                                                RequestDate__c = item.RequestDate__c,
	                                                SubAmount__c = item.SubAmount__c,
	                                                UnitOfMeasure__c = item.UnitOfMeasure__c,
	                                                StoreId__c = item.StoreId__c,
	                                                Order__c=order.Id,
	                                                AbsoluteDiscount__c = item.AbsoluteDiscount__c,
	                                                PercentDiscount__c = item.PercentDiscount__c,
	                                                OrderItemId__c = item.id,
	                                                OrderLineType__c = item.cartitemtype__c,
	                                                AmountPaid__c = item.AmountOwed__c
	                                                );
	            orderItemsToInsert.add(oi);
	            if(item.Cart_Item_Pricing_Tiers__r != null && item.Cart_Item_Pricing_Tiers__r.size() > 0)
	            {
	                cartId2CartTiers.put(item.Id, item.Cart_Item_Pricing_Tiers__r);
	            }
	        } 
	        Map<String, String> cartLine2OrderLine = new Map<String, String>();
	        if(orderItemsToInsert != null && orderItemsToInsert.size() > 0){
	            insert orderItemsToInsert;
	            for(E_OrderItem__c oii : orderItemsToInsert)
	            {
	                cartLine2OrderLine.put(oii.OrderItemId__c, oii.id);
	                
	                if(cartId2CartTiers.get(oii.OrderItemId__c) != null)
	                {
	                    for(E_CartItemPricingTier__c tier : cartId2CartTiers.get(oii.OrderItemId__c))
	                    {
	                        tiersToInsert.add(new E_OrderItemPricingTier__c(OrderItem__c=oii.Id, Price__c=tier.Price__c, Quantity__c=tier.Quantity__c, SubAmount__c=tier.SubAmount__c));
	                    }
	                }
	            }
	
	            if(tiersToInsert != null && tiersToInsert.size() > 0)
	            {
	                insert tiersToInsert;
	            }
	        }
	        
	        List<E_OrderItem__c> childOrderItemsToInsert = new List<E_OrderItem__c>();
	        for(E_CartItem__c item: items)   
	        {
	            for(E_CartItem__c cci : item.Cart_Items__r)
	            {
	                E_OrderItem__c oi = new E_OrderItem__c(ProductType__c = cci.ProductType__c,
	                                                
	                                                Coupon__c = cci.Coupon__c,
	                                                DeliveryDate__c = cci.DeliveryDate__c,
	                                                ParentProduct__c = cci.ParentProduct__c,
	                                                Price__c = cci.Price__c,
	                                                Product__c = cci.Product__c,
	                                                Quantity__c = cci.Quantity__c,
	                                                Category__c = cci.Category__c,                                                 
	                                                RequestDate__c = cci.RequestDate__c,
	                                                SubAmount__c = cci.SubAmount__c,
	                                                UnitOfMeasure__c = cci.UnitOfMeasure__c,
	                                                StoreId__c = cci.StoreId__c,
	                                                Order__c=order.Id,
	                                                AbsoluteDiscount__c = cci.AbsoluteDiscount__c,
	                                                PercentDiscount__c = cci.PercentDiscount__c,
	                                                ParentOrderItem__c =  cartLine2OrderLine.get(item.id),                                                
	                                                OrderLineType__c = 'Minor',
	                                                AmountPaid__c = cci.AmountOwed__c
	                                                );
	                childOrderItemsToInsert.add(oi);
	                //jlowenthal - update inventory
	                if(true) {//storefront.InventoryCheckFlag__c)
	                
	                    // sns 08.22.11 - not working. not needed for now.
	                    // cc_api_Inventory.processPurchase(cci.Product__c, cci.Quantity__c);
	                }
	            }
	        }
	        insert childOrderItemsToInsert;
	
	        cart.CartStatus__c = cc_cnst_PickListConstants.CARTSTATUS_CLOSED;
	        cart.ActiveCart__c = false;
	        update cart;
	        order.OrderStatus__c = cc_cnst_PickListConstants.ORDERSTATUS_ORDERSUBMITTED;
	        update order;
	        return order;
        }else{
        	return null;
        }
    }

    public with sharing class DuplicatedEncryptedCartIdException extends Exception {
        public String encryptedId { get; set; }
        public DuplicatedEncryptedCartIdException(String encryptedId, String msg) 
        {
            this(msg);
            this.encryptedId = encryptedId;
        }
    }
    
    public with sharing class CartIsClosedException extends Exception {

    }
    
    public with sharing class CartNotFoundException extends Exception {

    }
    
    
    // addCoupon response types
    // CodeType = 'CouponStatus'
    // --------------------------
    // Code = '10' 
    // Decode = 'Success'
    // Code = '20';
    // Decode = 'MaxCouponsUsed'
    // Code = '30';
    // Decode = 'InvalidCoupon';
    // Code = '40';
    // Decode = 'SelectCoupon';
    // Code = '50';
    // Decode = 'InsufficientItems';
    // Code = '60';
    // Decode = 'NoValidSKU';
    public String addCoupon(E_Cart__c cart, String couponCode, List<E_CartItem__c> cartItems){
        return addCoupon(cart, couponCode, cartItems, false);
    }

    /**
     * Returns Code value for CodeType==CouponStatus
    */
    public String addCoupon(E_Cart__c cart, String couponCode, List<E_CartItem__c> cartItems, Boolean useNewCoupon){
        String addCouponStatus = 'Success'; // should match E_Code__c.Decode__c value
        //System.debug('------------- addCoupon ---------------');
        // Get the current cart     
        //E_Cart__c cart = retrieveCart(currentCartID);

        // Retrieve the new coupon
        //System.debug('------------- getCoupon ---------------');
        E_Coupon__c coupon = getCoupon(couponCode);

        // Retrieve coupons already in cart
        //System.debug('------------- getCartCoupon ---------------');
        List<E_CartCoupon__c> cartCoupons = null;
        if(cart != null && cart.Id != null)
        	cartCoupons = getCartCoupons(cart.ID);
        //if(cartCoupons != null && cartCoupons.size() > 0){
        //    for(E_CartCoupon__c c: cartCoupons){
        //        //System.debug('------------cartCoupon: ' + c.Coupon__r.Rule__r.Name__c);
        //    }
        //}else {
            //System.debug('--------- cartCoupons is empty');
        //}

        // Check whether the specified coupon is valid
        //System.debug('------------- validate coupon ---------------');
        if(!isValidCoupon(coupon)){
            addCouponStatus = 'InvalidCoupon'; // should match E_Code__c.Decode__c value
        }
        // If the number of coupons in the cart is less than the maximum number of coupons
        // allowed, add the new one -- this describes future implementation, for now check for one coupon
        else if(cartCoupons == null || (cartCoupons.size() < maxCoupons) || useNewCoupon){
            //System.debug('------------- add new Coupon ---------------');
            
            // If the coupon is valid for this cart, add it, otherwise return an error
            //System.debug('------------- validate Coupon rules ---------------');
            addCouponStatus = cc_util_Coupon.validateCouponRules(coupon, cart.Id, cartItems, null); // returns the E_Code__c.Decode__c value
            //System.debug('----------------addCoupon, rulesPass: ' + addCouponStatus); 
             if(addCouponStatus == 'Success'){
                if(useNewCoupon){
                    //System.debug('--------- Remove old coupon from cartItems and Cart_x_coupons');
                    E_CartItem__c cartItem, item;
                    Integer i = 0;
                    for(; i < cartItems.size(); i++){
                        item = cartItems.get(i);
                        
                        if(item.Product__r.SKU__c == cartCoupons[0].Coupon__r.CouponCode__c){
                            cartItem = item;
                            //System.debug('-------------- found coupon to remove: ' + cartItem.Product__r.SKU__c + ',' + i);
                            break;
                        }
                    }
                    if(cartItem!=null){
                        // Delete the cartItem from the list that represents the coupon
                        cartItems.remove(i);

                        // Delete the cartItem from the database that represents the coupon
                        delete cartItem;
                        
                    }
                    
                    
                    // Delete the Cart_X_Coupon from the database
                    delete cartCoupons[0];
                    //ah need to set the discounts to null
                   
                    for (E_CartItem__c ci : cartItems) {
                    	
						ci.AbsoluteDiscount__c = null;
						ci.PercentDiscount__c = null;
					}
					update cartItems;
                    
                }               
                // Apply the coupon to the cart
                //System.debug('------------- addCartXCoupon ---------------');
                addCartXCoupon(coupon.ID, cart.ID, cartItems);
            }
        }
        // If the number of coupons in the cart is more than the max
        // let the user choose which ones to use.  The max number can be determined by
        // the getMaxCoupons() method
        else {
            if(cartCoupons[0].Coupon__r.CouponCode__c == couponCode){
                addCouponStatus = 'CouponAlreadyAdded'; // should match E_Code__c.Decode__c
            }
            else {
                // Error - make user choose which coupon to use
                addCouponStatus = 'SelectCoupon'; // should match E_Code__c.Decode__c
            }
        }
        
        // Return status of adding coupon
        //System.debug('---- addCoupon results: status: ' + addCouponStatus + ' couponCode: ' + couponCode);
        return addCouponStatus;
    }
    
    private void addCartXCoupon(String couponID, String cartID, List<E_CartItem__c> cartItems){
            // Add the new coupon
            E_CartCoupon__c newCoupon = new E_CartCoupon__c();
            newCoupon.Cart__c = cartID; 
            newCoupon.Coupon__c = couponID;
            insert newCoupon;
            
            // Update the cart
            updateCart(cartItems);
    }

    
    public void removeCoupon(String cartId, List<E_CartItem__c> cartItems, Boolean commitCart){
        
        // Remove the E_CartCoupon
        List<E_CartCoupon__c> cartCoupons = [select ID from E_CartCoupon__c where Cart__r.ID = :cartId];
        if(cartCoupons != null && cartCoupons.size() > 0) {
            delete cartCoupons;

            for (E_CartItem__c cartItem : cartItems) {
                cartItem.AbsoluteDiscount__c = null;
                cartItem.PercentDiscount__c = null;
            }
            update cartItems;

            // Update the cart
            if(commitCart && cartItems != null){
                updateCart(cartItems);
            }
        }
    }
    
    // TASK ID 7 VS START
    public void deleteItemFromWishList(String cartID, String productID){
        
        List<E_CartItem__c> items = [Select e.id 
                                from E_CartItem__c e 
                                where e.isDeleted = false 
                                and e.Cart__c = :cartID 
                                and e.Product__r.ID = :productID 
                                limit 1
                                ] ;
        if(items != null && items.size() > 0)
         delete items;
    }
    // TASK ID 7 VS END
   
    public E_Cart__c getActiveCartOwnedBy(Id userId) {
        E_Cart__c cart = null;
        List<E_Cart__c> listOfCarts = cc_dao_Cart.getActiveCartOwnedBy(userId);
        if(listOfCarts.size() > 0) {
            cart = listOfCarts[0];
        }
        return cart;
    }
    public String addBulkItemsToActiveCart( List<ID> prodIDList, Double qty, boolean fillPrice, String storeid) {
        String cartId = null;
        List<E_Cart__c> listOfCarts = cc_dao_Cart.getActiveCartOwnedBy(UserInfo.getUserId());
        E_Cart__c cartHeader= null;
        if(listOfCarts != null && listOfCarts.size() > 0){
            cartHeader = listOfCarts[0];
        } else {
            cartHeader = createEmptyCart();
        }
        if(cartHeader != null) {
            map<id, double> prodQtyMap = new map<id, double>(); 
            for(ID prodID : prodIDList) {
                prodQtyMap.put(prodID, qty);
            }
            cartId = addBulkItemsToCart(prodQtyMap, fillPrice, storeid, cartHeader.id);
        }
        return cartId;
    }
    //deprecated
    public String addBulkItemsToCart( map<id, double> prodQtyMap, boolean fillPrice, String storeid, String cartId) {
        map<string, double> skuQtyMap = new map<string, double>();
        list<id> ids = new list<id>();
        ids.addAll(prodQtyMap.keyset());
        for(e_product__c p : [select id, sku__c from e_product__c where id in :ids]) {
            skuQtyMap.put(p.sku__c, prodQtyMap.get(p.id));
        }
        return addSkuQtyMapToCart(skuQtyMap, fillPrice, storeid, cartId);
    }
    
    public String addSkuQtyMapToCart( map<string, double> skuQtyMap, boolean fillPrice, String storeid, String cartId) {
        if(cartId == null) {
            cartId = createEmptyCart().Id;
        }
        if (cartId != null) {
            
            map<string, E_CartItem__c> sku2CartItem = new map<string, E_CartItem__c>();
            E_Cart__c currentCart = cc_dao_Cart.retrieveCart(cartId, cc_dao_Cart.CART_ITEMS);
            
            if(currentCart == null) {
                throw new cc_api_cart.CartNotFoundException('Cart with id ' + cartId + ' could not be found.');
            }
            cartId = currentCart.EncryptedId__c;
            for(E_CartItem__c ci : currentCart.E_CartItems__r) {
                sku2CartItem.put(ci.Product__r.sku__c, ci);
            }       
            list<string> skus = new list<string>();
            skus.addAll(skuQtyMap.keyset());
            cc_dao_Product pdao = new cc_dao_Product();
            list<e_product__c> productsNeedAdded = pdao.readProduct(skus);
            if(productsNeedAdded == null) {
                productsNeedAdded = new list<e_product__c>();
            }           map<string, double> pricingSkuQtyMap = skuQtyMap.clone();
            
            for(E_Product__c prod : productsNeedAdded) {
                Boolean isNew = true;
                E_CartItem__c cartItem = null;
                //Check if the prod already exist in the cart - BEGIN
                //need to bulkify following code
                cartItem = sku2CartItem.get(prod.sku__c);
                if (cartItem != null || !cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED.equalsIgnoreCase(prod.ProductStatus__c)) {
                    //if current product exists in cart or it is not in RELEASED state, remove it from ADD map
                    pricingSkuQtyMap.remove(prod.sku__c);
                }
            }
            Map<String,cc_bean_PriceInfo> sku2PriceInfoBean = new Map<String,cc_bean_PriceInfo>();
            if(fillPrice == true)  {
                sku2PriceInfoBean = cc_ctrl_PricingEngine.getPriceMap(pricingSkuQtyMap, accountID, null, null, null);
            }
            
            for(E_Product__c prod : productsNeedAdded) {
                
                Boolean isNew = true;
                E_CartItem__c cartItem = null;
                //Check if the prod already exist in the cart - BEGIN
                //need to bulkify following code
                cartItem = sku2CartItem.get(prod.sku__c);
                if(cartItem != null) {
                    isNew = false;
                }
                
                //Check if the prod already exist in the cart - END
                if (isNew && cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED.equalsIgnoreCase(prod.ProductStatus__c)) {   
                    System.debug('ryltest->inside isNew && cc_cnst_PickLis' );
                    cartItem = new E_CartItem__c();
                    cartItem.StoreId__c = storeid;
                    cartItem.Cart__c=currentCart.id;
                    if(fillPrice == true) {
                        //need to bulkify following code
                        //
                        cc_bean_PriceInfo priceBean = sku2PriceInfoBean.get(prod.sku__c);
                        if(priceBean == null) {
                            //todo: log this condition
                            continue;
                        }
                        cartItem.Price__c = priceBean.price;
                        cartItem.Price__c = cartItem.Price__c.setScale(2, System.RoundingMode.UP);
                        System.debug('----Allow Disc ----14');
                        cartItem.AllowsDiscounts__c = priceBean.priceListItem.Pricelist__r.AllowsDiscounts__c;
                    } else {
                        cartItem.Price__c = 0.0;
                    }
                    cartItem.Product__c = prod.ID;
                    cartItem.Quantity__c = skuQtyMap.get(prod.sku__c);                
                    cartItem.RequestDate__c = Date.today();
                    cartItem.UnitOfMeasure__c = prod.UnitOfMeasure__c;
                    cartItem.SubAmount__c =  cartItem.Price__c * cartItem.Quantity__c;
                    cartItem.SubAmount__c = cartItem.SubAmount__c.setScale(2, System.RoundingMode.UP);
                    insert cartItem;
                } else if(!isNew) {
                    System.debug('ryltest->inside !isNew && cc_cnst_PickLis' );
                    cartItem.StoreId__c = storeid;
                    cartItem.Quantity__c = cartItem.Quantity__c +skuQtyMap.get(prod.sku__c);
                    cartItem.SubAmount__c =  cartItem.Price__c * cartItem.Quantity__c;
                    cartItem.SubAmount__c = cartItem.SubAmount__c.setScale(2, System.RoundingMode.UP);
                    update cartItem;
                }
            }
        }
        return cartId;
    }
    
    
    public void deleteItemFromCart(String cartId, Id itemId) {
        if(cartId == null || itemId == null) {
            return;
        }
        
        List<E_CartItem__c> items = null;
        
        if(cartId instanceof Id) {
            items = [Select e.id from E_CartItem__c e where e.isDeleted = false and e.Cart__c = :cartId and e.Id = :itemId];
        } else {
            items = [Select e.id from E_CartItem__c e where e.isDeleted = false and e.Cart__r.EncryptedId__c = :cartId and e.Id = :itemId];
        }
        
        if(items != null && items.size() == 1) {
            delete items;
        }
    }
    
    public void deleteProductFromCart(String cartId, Id productId) {
        if(cartId == null || productId == null) {
            return;
        }
        List<E_CartItem__c> items = null;
        if(cartId instanceof Id) {
            items = [Select e.id from E_CartItem__c e where e.isDeleted = false and e.Cart__c = :cartId and e.product__c = :productId];
        } else {
            items = [Select e.id from E_CartItem__c e where e.isDeleted = false and e.Cart__r.EncryptedId__c = :cartId and e.product__c = :productId];
        }
        if(items != null && items.size() == 1) {
            delete items;
        }
    }
}