//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
// 
@isTest
private without sharing class cc_ctrl_test_Cart_va {
 
    private static void prepTestData() {
        cc_test_PrepTestData.loadAllCustomSettings();
        cc_test_PrepTestData.loadInitData();
    }

    static testMethod void wishListTest() {
        cc_ctrl_test_Cart_va.prepTestData();
        User u = cc_api_User.getCurrentUser;
        Test.startTest();
        
        E_Cart__c wishListCart = insertWishList(u);
        List<E_Product__c> prods = insertProduct(1);
        insertItemIntoWishList(wishListCart.id, prods[0].id);
        
        // prod = insertProduct('2');
        // insertItemIntoWishList(wishListCart.id, prods[1].id);
        // prod = insertProduct('3');
        // insertItemIntoWishList(wishListCart.id, prods[2].id);
        cc_ctrl_Cart_va cartExt = new cc_ctrl_Cart_va();
        /* START MATT: comment out shipping in cart
        System.assertEquals(false, cartExt.getdisplayShippingEstimateMessage());
        END MATT: comment out shipping in cart */
        System.assertEquals(true, cartExt.getStateList().size()>0);
        //System.debug('Google Analytics : ' + cartExt.googleAnalyticsAcountIdAndPropIndex);
        //System.debug('BreadCrumbSeparator : ' + cartExt.breadCrumbSeperator);
        //System.debug('cartProductIdList : ' + cartExt.cartProductIdList);

        //System.assertEquals(241, cartExt.getCountryList().size());
        cartExt.getCountryList();
        
        /* START MATT: comment out shipping in cart
        System.assertEquals(0, cartExt.getShipmentOptionsViewList().size());
        System.assertEquals('Not Available',cartExt.getShipmentEstimate());
        
        List<cc_bean_ShippingOptions> fedexList = new List<cc_bean_ShippingOptions>();
        cc_bean_ShippingOptions bean1 = new cc_bean_ShippingOptions();
        bean1.status = true;
        bean1.shippingProvider = 'FEDEX';
        
        List<cc_bean_ShippingServicesAndCostDetails> detailList1 = new List<cc_bean_ShippingServicesAndCostDetails>();
        cc_bean_ShippingServicesAndCostDetails cdb1 = new cc_bean_ShippingServicesAndCostDetails();
        cdb1.shipService = 'FEDEX_GROUND';
        cdb1.currencyCode = 'USD';
        cdb1.shipCost  = '5.99';
        detailList1.add(cdb1);
        bean1.shippingServicesAndCostDetails = detailList1;
        
        //fedexList.add(bean1);
        
        List<cc_bean_ShippingOptions> upsList = new List<cc_bean_ShippingOptions>();
        cc_bean_ShippingOptions bean2 = new cc_bean_ShippingOptions();
        bean2.status = true;
        bean2.shippingProvider = 'UPS';
        List<cc_bean_ShippingServicesAndCostDetails> detailList2 = new List<cc_bean_ShippingServicesAndCostDetails>();
        cc_bean_ShippingServicesAndCostDetails cdb2 = new cc_bean_ShippingServicesAndCostDetails();
        cdb2.shipService = 'UPS_GROUND';
        cdb2.currencyCode = 'USD';
        cdb2.shipCost  = '5.99';
        detailList2.add(cdb2);
        bean2.shippingServicesAndCostDetails = detailList2;
        //upsList.add(bean2);
        cartExt.fedExShipOptions = bean1;
        cartExt.upsShipOptions   = bean2;
        System.assertEquals('5.99',cartExt.getShipmentEstimate());
        System.assertEquals(2, cartExt.getShipmentOptionsViewList().size());
        END MATT: comment out shipping in cart */

        Test.stopTest();
    }
    
    static testMethod void cartTest1() {
        cc_ctrl_test_Cart_va.prepTestData();
        User u = cc_api_User.getCurrentUser;
        Test.startTest();

        cc_api_Cart_va api = new cc_api_Cart_va();        
        E_Cart__c cart = api.createEmptyCart('USD', 'Commercial');
        List<E_Product__c> productList = insertProduct(5);
        for(E_Product__c prod:productList){
            api.addToCart(prod.Id, cart.Id, 1,false, 'USD', 
                          'Commercial', cc_util_CloudCraze.application.Default_Storefront__c);
        }
        cc_ctrl_Cart_va cartExt = new cc_ctrl_Cart_va();
        //jll
        try{
            cartExt.updateCart();
            cartExt.addToCart();
            cartExt.removeCartItem();
            cartExt.updateCartCheckout();
        }catch(Exception e){
            System.debug(e);
        }
        cartExt.currentCartID = cart.EncryptedID__c;
        
        /* START MATT: comment out shipping in cart
        System.assertEquals(null,cartExt.findShippingOptions());
        cartExt.getShipmentOptionsViewList();
        System.assertEquals(0,cartExt.getShipOptionsList().size());
        END MATT: comment out shipping in cart */
        
        System.assertEquals(false,cartExt.showUpsell);
        System.assertEquals(0,cartExt.couponList.size());
        
        /* START MATT: comment out shipping in cart
        cartExt.getShippingEstimation();
        END MATT: comment out shipping in cart */
        try{
            cartExt.updateCartCheckout();
        }catch(Exception e){
            System.debug(e);
        }
        Test.stopTest();
    }
    
    static testMethod void cartTest2() {
        cc_ctrl_test_Cart_va.prepTestData();
        User u = cc_api_User.getCurrentUser;
        Test.startTest();

        cc_api_Cart_va api = new cc_api_Cart_va();        
        E_Cart__c cart = api.createEmptyCart('USD', 'Commercial');
        List<E_Product__c> productList = insertProduct(1);
        for(E_Product__c prod:productList){
            api.addToCart(prod.Id, cart.EncryptedID__c, 1,false, 'USD', 
                          'Commercial', cc_util_CloudCraze.application.Default_Storefront__c);
        }
        
        
        E_Cart__c cart2 = api.createEmptyCart('USD', 'Commercial');
        
        
        //PageReference pageRef = new PageReference('/apex/Cart');
        PageReference pageRef = System.Page.Cart; //new PageReference('/apex/Cart');
        pageRef.getParameters().put('cartID',cart.EncryptedID__c);
        pageRef.getParameters().put('storeID',cc_util_CloudCraze.application.Default_Storefront__c);
        pageRef.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY,'US');
        pageRef.getParameters().put('productID',productList[0].Id );
        Test.setCurrentPage(pageRef);
        cc_ctrl_Cart_va cartExt = new cc_ctrl_Cart_va();
        
        
        cartExt.currentCartID = cart.EncryptedID__c;
        /* START MATT: comment out shipping in cart
        System.assertEquals(null,cartExt.findShippingOptions());
        END MATT: comment out shipping in cart */
        cartExt.updateCart();
        
        pageRef = System.Page.Cart; //new PageReference('/apex/Cart');
        
        pageRef.getParameters().put('cartID',cart.EncryptedID__c);
        pageRef.getParameters().put('storeID',cc_util_CloudCraze.application.Default_Storefront__c);
        pageRef.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY,'US');
        pageRef.getParameters().put('skuTextCount','1');
        pageRef.getParameters().put('sku1',productList[0].SKU__c);
        pageRef.getParameters().put('qty1','2');
        pageRef.getParameters().put('productID',productList[0].Id );
        pageRef.getParameters().put('doLogin','true');
        pageRef.getParameters().put('anonymousCartID', cart2.Id);
        Test.setCurrentPage(pageRef);
        
        //cartExt.addToCartBulkItems();
        /* START MATT: comment out shipping in cart
        cartExt.getShipmentOptionsViewList();
        System.assertEquals(0,cartExt.getShipOptionsList().size());
        END MATT: comment out shipping in cart */
        System.assertEquals(false,cartExt.showUpsell);
        System.assertEquals(0,cartExt.couponList.size());
        cartExt.getMiniCartItems();
        //System.assertEquals(0,cartExt.getCartItems().size());
        cartExt.getCartItems();
        //System.assertEquals(0,cartExt.getCartItemCount());
        cartExt.getCartItemCount();
        //System.assertEquals('0.00',cartExt.cartTotal);
        System.assertNotEquals(null,cartExt.addToCart());
        System.assertNotEquals(null,cartExt.editCart());
        
        cartExt.mergeCart();
        
        Test.stopTest();
    }
    
    static testMethod void cartTest3() {
        cc_ctrl_test_Cart_va.prepTestData();
        User u = cc_api_User.getCurrentUser;
        Test.startTest();

        cc_api_Cart_va api = new cc_api_Cart_va();        
        E_Cart__c cart =  api.createCart('TempCart', true, 'USD', 'Commercial');// api.createEmptyCart(usd.Id, commercial.Id);
        List<E_Product__c> productList = insertProduct(1);
        for(E_Product__c prod:productList){
            api.addToCart(prod.Id, cart.Id, 1,false, 'USD', 
                          'Commercial', cc_util_CloudCraze.application.Default_Storefront__c);
        }
        
        api.addToCart(productList[0].Id, cart.Id, 1, true, 'USD', 'Commercial', true, cc_util_CloudCraze.application.Default_Storefront__c);
        
        PageReference pageRef = System.Page.Cart; //new PageReference('/apex/Cart');
        pageRef.getParameters().put('cartID',cart.EncryptedID__c);
        pageRef.getParameters().put('storeID',cc_util_CloudCraze.application.Default_Storefront__c);
        pageRef.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY,'US');
        pageRef.getParameters().put('skuTextCount','1');
        pageRef.getParameters().put('sku1',productList[0].SKU__c);
        pageRef.getParameters().put('qty1','2');
        pageRef.getParameters().put('productID',productList[0].Id );
        pageRef.getParameters().put('doLogin','true');
        pageRef.getParameters().put('anonymousCartID',cart.Id);
        pageRef.getParameters().put('removeItemId','123456');
         
        Test.setCurrentPage(pageRef);
        cc_ctrl_Cart_va cartExt = new cc_ctrl_Cart_va();
        try{
            
            cartExt.removeItemFromCart();
        } catch(Exception exp){
            
        }
        
        //System.assertEquals(null,cartExt.mergeCart());
        cartExt.mergeCart();
        System.assertEquals(0,cartExt.couponList.size());
        cartExt.selectCoupon();
        cartExt.addCoupon();

        Test.stopTest();
    }
    
    
    
    static testMethod void cartTest4() {
        cc_ctrl_test_Cart_va.prepTestData();
        User u = cc_api_User.getCurrentUser;
        Test.startTest();

        cc_api_Cart_va api = new cc_api_Cart_va();        
        E_Cart__c cart =  api.createCart('TempCart', true, 'USD', 'Commercial');
        List<E_Product__c> productList = insertProduct(2);
        Map<String, E_CartItem__c> productToCartListItem = new Map<String, E_CartItem__c>();
        List<E_CartItem__c> cartItems = new List<E_CartItem__c>();
        for(E_Product__c prod:productList){
            api.addToCart(prod.Id, cart.Id, 1,false, 'USD', 
                          'Commercial', cc_util_CloudCraze.application.Default_Storefront__c);
            E_CartItem__c cartItem = new E_CartItem__c();
            //Select e.SubAmount__c, e.StoreId__c, e.Quantity__c, e.Product__c, e.Price__c, e.Name, e.CartItemID__c, e.CartId__c From E_CartItem__c e
            
            cartItem.StoreId__c = cc_util_CloudCraze.application.Default_Storefront__c;
            cartItem.Quantity__c = 1.0;
            cartItem.Product__c = prod.Id;
            cartItem.SubAmount__c = 50.99;
            cartItem.Price__c   = 50.99;
            cartItem.Cart__c = cart.Id;
            cartItems.add(cartItem);
        }           
        insert cartItems;
        for(E_CartItem__c cartItem:cartItems){
            productToCartListItem.put(cartItem.Product__c,cartItem);
        }
        
        PageReference pageRef = System.Page.Cart; //new PageReference('/apex/Cart');
        pageRef.getParameters().put('cartID',cart.EncryptedID__c);
        pageRef.getParameters().put('storeID',cc_util_CloudCraze.application.Default_Storefront__c);
        pageRef.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY,'US');
        pageRef.getParameters().put('skuTextCount','1');
        pageRef.getParameters().put('sku1',productList[0].SKU__c);
        pageRef.getParameters().put('qty1','2');
        pageRef.getParameters().put('productID',productList[0].Id );
        pageRef.getParameters().put('doLogin','true');
        pageRef.getParameters().put('anonymousCartID',cart.Id);
        pageRef.getParameters().put('removeItemId','123456');
         
        Test.setCurrentPage(pageRef);
        cc_ctrl_Cart_va cartExt = new cc_ctrl_Cart_va();
        cartExt.buildCartListViewData2(cartItems);
        //System.assertEquals(2,cartExt.getCartItems().size());
        cartExt.getCartItems();
        //System.assertEquals(2,cartExt.getCartItemCount());
        cartExt.getCartItemCount();
        //System.assertEquals('101.98',cartExt.cartTotal);
        cartExt.getCartItems();
        cartExt.getCartItemCount();
        System.assertNotEquals(null,cartExt.cartProductIdList);
        System.assertNotEquals(null,cartExt.addToCart());
        System.assertNotEquals(null,cartExt.editCart());
        System.assertNotEquals(null,cartExt.getMiniCartItems());
        cartExt = cartExt.getCartController();
        System.assertNotEquals(null,cartExt.ipAddressLocationKey);
        System.assertNotEquals(null,cartExt.getCountryList());
             
        Test.stopTest();
    }
    
    
    private static E_Cart__c insertWishList(User usr){
       
          /**cc_test_PrepTestData.insertCode('CartType' ,'WishList', '30');**/
           E_Cart__c newWishList = new E_Cart__c();
            newWishList.Account__c = cc_util_CloudCraze.getAccountID();            
            newWishList.CartStatus__c=cc_cnst_PickListConstants.CARTSTATUS_OPEN;
            newWishList.user__c = UserInfo.getUserId();
            //newWishList.CartType__c = codeForWishList.id;
            newWishList.CartType__c=cc_cnst_PickListConstants.CARTTYPE_WISHLIST;
            newWishList.Name__c = 'MyWishList Dummy';
            newWishList.SessionID__c = 'Dummy Session';
            newWishList.OwnerId = usr.Id;
            
            insert newWishList;
        return newWishList;
    }
    
    private Static List<E_Product__c> insertProduct(Integer count){
        List<E_Product__c> productList = new List<E_Product__c>();
        Integer i = 0;
        while(i < count){
            E_Product__c prod = new E_Product__c();
           prod.SKU__c = cc_util_RandomString.randomUUID();
            prod.Name = 'ProductName'+String.valueOf(i);
            prod.LeadTime__c = 1;
            prod.QuantityPerUnit__c = 1;
            prod.StartDate__c = System.today();
            prod.EndDate__c = System.today();
            prod.ShippingWeight__c = 0;
            productList.add(prod);
            i++;
        }
        insert productList;
        return productList;
    }
    
    private static E_CartItem__c insertItemIntoWishList(String wishListID, String prodID){
        
        E_CartItem__c cartItem = new E_CartItem__c();
        cartItem.Product__c = prodID;
        cartItem.Quantity__c = 1;
        cartItem.Price__c = 25;
        cartItem.Cart__c = wishListID;
        insert cartItem;
        return cartItem;
        
    }
 
    static testMethod void updateCouponInfoTest(){
        cc_test_TestDataSetup.loadData();
        System.RunAs(cc_test_TestDataSetup.testUser){
        // null test
        cc_ctrl_Cart_va ce = new cc_ctrl_Cart_va();
        ce.currentCartID = null;
        ce.updateCouponInfo();
        System.assertEquals(ce.couponName, null);
        System.assertEquals(ce.requiredSKU, null);
        }
        //TODO:FIX THIS TEST
        //System.assertEquals(ce.applyToAll,null);


        // create a cart with a product
        
        // add a coupon
        
        // ensure the coupon info is correct
        
        
    }
    
    /*static testMethod void testValidInventoryNullInventory(){
      cc_ctrl_test_Cart_va.prepTestData();
      Test.startTest();
      E_Cart__c cart =  (new cc_api_Cart()).createCart('TempCart', true, 'USD', 'Commercial');
      insertProductsAndInventorycart(cart,1,null,1);
      ApexPages.currentPage().getParameters().put('cartID',cart.EncryptedID__c);
      cc_ctrl_Cart_va c = new cc_ctrl_Cart_va();
      Test.stopTest();
      System.assert(c.validInventory);
    }
    
    static testMethod void testValidInventoryLargeInventory(){
      cc_ctrl_test_Cart_va.prepTestData();
      Test.startTest();
      E_Cart__c cart =  (new cc_api_Cart()).createCart('TempCart', true, 'USD', 'Commercial');
      insertProductsAndInventorycart(cart,1,100,2);
      ApexPages.currentPage().getParameters().put('cartID',cart.EncryptedID__c);
      cc_ctrl_Cart_va c = new cc_ctrl_Cart_va();
      Test.stopTest();
      System.assert(c.validInventory);
    }
    
    static testMethod void testValidInventoryInvalidSmallInventory(){
      cc_ctrl_test_Cart_va.prepTestData();
      Test.startTest();
      E_Cart__c cart =  (new cc_api_Cart()).createCart('TempCart', true, 'USD', 'Commercial');
      insertProductsAndInventorycart(cart,1,0,5);
      ApexPages.currentPage().getParameters().put('cartID',cart.EncryptedID__c);
      cc_ctrl_Cart_va c = new cc_ctrl_Cart_va();
      Test.stopTest();
      System.assert(!c.validInventory);
    }
    
    static testMethod void testValidInventoryInvalidStartDate(){
      cc_ctrl_test_Cart_va.prepTestData();
      Test.startTest();
      E_Cart__c cart =  (new cc_api_Cart()).createCart('TempCart', true, 'USD', 'Commercial');
      List<E_Product__c> products = insertProductsAndInventorycart(cart,1,null,5);
      E_Product__c temp = products.get(0);
      temp.StartDate__c = System.today()+10;
      update temp;
      ApexPages.currentPage().getParameters().put('cartID',cart.EncryptedID__c);
      cc_ctrl_Cart_va c = new cc_ctrl_Cart_va();
      Test.stopTest();
      System.assert(!c.validInventory);
    }
    
    static testMethod void testValidInventoryInvalidEndDate(){
      cc_ctrl_test_Cart_va.prepTestData();
      Test.startTest();
      E_Cart__c cart =  (new cc_api_Cart()).createCart('TempCart', true, 'USD', 'Commercial');
      List<E_Product__c> products = insertProductsAndInventoryCart(cart,1,null,5);
      E_Product__c temp = products.get(0);
      temp.EndDate__c = System.today()-10;
      update temp;
      ApexPages.currentPage().getParameters().put('cartID',cart.EncryptedID__c);
      cc_ctrl_Cart_va c = new cc_ctrl_Cart_va();
      Test.stopTest();
      System.assert(!c.validInventory);
    }
    
    static List<E_Product__c> insertProductsAndInventoryCart(E_Cart__c cart, Integer prodCount, Decimal availQty, Integer qtySelected){
      List<E_Product__c> products = insertProductsAndInventory(prodCount, availQty);
      cc_api_Cart api = new cc_api_Cart();
      for(E_Product__c product : products){
        api.addToCart(product.Id, cart.Id, qtySelected,false, 'USD','Commercial', cc_util_CloudCraze.application.Default_Storefront__c);    
      } 
      return products;
    }
    
    static List<E_Product__c> insertProductsAndInventory(Integer prodCount, Decimal qty){
      List<E_Product__c> products = insertProduct(prodCount);
      List<Id> productIds = new List<Id>();
      for(E_Product__c product : products){
        productIds.add(product.Id);         
      }
      insertQty(productIds,qty);
      return products;
    }
    
    static void insertQty(List<Id> productIds,Decimal qty){
      List<E_ProductInventoryItem__c> invItems = new List<E_ProductInventoryItem__c>();
      for(Id pid : productIds){
        invItems.add(new E_ProductInventoryItem__c(
          ProductItem__c = pid,
          QtyAvailable__c = qty
        )); 
      }
      insert invItems;
    }*/
}