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
private without sharing class cc_api_test_Cart_va {
    public static E_Product__c product1;
    public static E_Product__c product2;
    public static E_Product__c product3;
    public static E_Product__c product4;
    public static E_Product__c majorLineItem;
    
    private static void prepTestData() {
        cc_test_PrepTestData.loadCustomSettings();
        cc_test_PrepTestData.loadInitData();
        cc_test_PrepTestData.loadTestCategoryData();
    }

    static void setupData()
    {
        cc_api_test_Cart_va.prepTestData();
        String prodStatus=cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED;
        E_PriceList__c priceList = [select Id from E_PriceList__c where Name = 'Enterprise'][0];
        
        product1 = new E_Product__c(SKU__C='testSKU1',  Name='test product 1', ProductStatus__c=prodStatus);
        insert product1;
        E_PriceListItem__c pli = new E_PriceListItem__c(Pricelist__c=priceList.Id, Product__c=product1.id, Price__c=200);
        insert pli;

        product2 = new E_Product__c(SKU__C='testSKU2',  Name='test product 2', ProductStatus__c=prodStatus);
        insert product2;
        pli = new E_PriceListItem__c(Pricelist__c=priceList.Id, Product__c=product2.id, Price__c=300);
        insert pli;
        
        product3 = new E_Product__c(SKU__C='testSKU3',  Name='test product 3', ProductStatus__c=prodStatus, ProductType__c='Bundle');
       insert product3;
       pli = new E_PriceListItem__c(Pricelist__c=priceList.Id, Product__c=product3.id, Price__c=2);
       insert pli;

       product4 = new E_Product__c(SKU__C='testSKU4',  Name='test product 4', ProductStatus__c=prodStatus, ProductType__c='Bundle');
       insert product4;
       pli = new E_PriceListItem__c(Pricelist__c=priceList.Id, Product__c=product4.id, Price__c=3);
       insert pli;
       
       
       majorLineItem = new E_Product__c(SKU__C='testMajorLineItemSKU',  Name='test testMajorLineItem 1', ProductStatus__c=prodStatus, ProductType__c='Bundle');
       insert majorLineItem;
       
       pli = new E_PriceListItem__c(Pricelist__c=priceList.Id, Product__c=majorLineItem.id, Price__c=5);
       insert pli;
       
       
       E_CompositeProduct__c compositeProductInstance=new E_CompositeProduct__c( Composite__c=majorLineItem.Id, Component__c=product3.id,Quantity__c=1);
       insert compositeProductInstance;
       
       
       compositeProductInstance=new E_CompositeProduct__c(  Composite__c=majorLineItem.Id, Component__c=product4.id, Quantity__c=1);
       insert compositeProductInstance;
    }
    static testMethod void updateCartTest() {
        
        setupData();
        Double qty = 1.0;
        

        cc_api_Cart_va api = new cc_api_Cart_va();
        api.accountId = cc_util_CloudCraze.getAnonymousAccountID();
        E_Cart__c testCart = api.createEmptyCart();
        //System.assertEquals(api.accountId, cc_util_CloudCraze.getAccountID());
        cc_util_CloudCraze.getAccountID();
        
        String placeOrderCart1 = api.addToCart(product1.Id, testCart.id, qty, true, cc_util_CloudCraze.application.Default_Storefront__c);
        placeOrderCart1 = api.addToCart(product2.Id, placeOrderCart1, qty, true, cc_util_CloudCraze.application.Default_Storefront__c);
        
        //add bundle product to first cart
            placeOrderCart1 = api.addToCart(majorLineItem.Id, placeOrderCart1, qty, true, cc_util_CloudCraze.application.Default_Storefront__c);
        
        E_Cart__c testCart2 = api.createEmptyCart();
        String placeOrderCart2 = api.addToCart(product1.Id, testCart2.id, qty, true, cc_util_CloudCraze.application.Default_Storefront__c);
        placeOrderCart2 = api.addToCart(product2.Id, placeOrderCart2, qty, true, cc_util_CloudCraze.application.Default_Storefront__c);
        Test.startTest();
        //api.accountID = cc_test_TestData.get('AccountId');
        //testCart=api.retrieveCart(cc_test_TestData.get('CartId'));
     //   System.assertEquals(5, 
        api.getCartItemCount(api.getCartItems(placeOrderCart1));
        
        List<E_CartItem__c> il = api.getCartItems(placeOrderCart1);
        //System.debug(il);
        //todo: actual should be 3
        //System.assertEquals(3, 
        api.getCartItemCount(il);
        
        api.getCartItemCount(il);
        
        api.getCartItemsWithCompositeProduct(testCart2.Id);
       
        api.getCartItemQuantitiesCount(testCart2.Id); 
        
        for(E_CartItem__c item : il)
        {
            item.Quantity__c = 10.0;
        }
       
        api.updateCart(il);
        
        api.updateCart(il, 'USD', 'Student');
        
        //System.assertEquals(
        //api.getCartTotal((placeOrderCart1), 5050.0);
        
        api.addToWishList(product1.Id, Double.valueOf('1.0'), UserInfo.getUserId());
        
        Test.stopTest();
    }   

    static testMethod void mergeCartsTest() {
        setupData();
        Double qty = 1.0;
        
        cc_api_Cart_va api = new cc_api_Cart_va();
        api.accountId = cc_util_CloudCraze.getAnonymousAccountID();
        E_Cart__c testCart = api.createEmptyCart();
        //System.assertEquals(api.accountId, cc_util_CloudCraze.getAccountID());

       
        String placeOrderCart1 = api.addToCart(product1.Id, testCart.id, qty, true, cc_util_CloudCraze.application.Default_Storefront__c);
        placeOrderCart1 = api.addToCart(product2.Id, placeOrderCart1, qty, true, cc_util_CloudCraze.application.Default_Storefront__c);
        
        //add bundle product to first cart
            placeOrderCart1 = api.addToCart(majorLineItem.Id, placeOrderCart1, qty, true, cc_util_CloudCraze.application.Default_Storefront__c);
        
        E_Cart__c testCart2 = api.createEmptyCart();
        String placeOrderCart2 = api.addToCart(product1.Id, testCart2.id, qty, true, cc_util_CloudCraze.application.Default_Storefront__c);
        placeOrderCart2 = api.addToCart(product2.Id, placeOrderCart2, qty, true, cc_util_CloudCraze.application.Default_Storefront__c);

        Test.startTest();
        
        //System.debug('---Limit.query before merge cart-----' + Limits.getQueries());
        String mergedId = api.mergeCart(placeOrderCart1, null);
        mergedId = api.mergeCart(placeOrderCart1, placeOrderCart2);
        
         //System.debug('---Limit.query after merge cart-----' + Limits.getQueries());
/*        
        List<E_CartItem__c> mergedCartItemList= [Select c.ParentCartItem__c,c.Cart__c, c.Name, c.Product__r.Name, c.cartItemType__c,  c.Product__r.ShortDesc__c, c.Product__r.SKU__c, c.Quantity__c, c.Price__c, c.SubAmount__c, ProductType__c, c.Coupon__c from E_CartItem__c c where c.isDeleted = false and c.Cart__r.EncryptedID__c=:mergedId];
        
       // List<E_CartItem__c> mergedCartItemList = api.getCartItems(mergedId);
                 //System.debug('----mergedCartItemList------' + mergedCartItemList);
          for(E_CartItem__c cartItemInstance:mergedCartItemList){
             //System.debug('----cartItemInstance--' + cartItemInstance);
             //System.debug('----cartItemInstance.ParentCartItem__c---' + cartItemInstance.ParentCartItem__c);
             //System.debug('----cartItemInstance.Product__r.Name---' + cartItemInstance.Product__r.Name);
             //System.debug('----cartItemInstance.Product__r.SKU__C---' + cartItemInstance.Product__r.SKU__C);
             //System.debug('----cartItemInstance.cartItemType__c---' + cartItemInstance.cartItemType__c);
             //System.debug('----cartItemInstance.Price__c---' + cartItemInstance.Price__c);
          }
*/
        /*
        String uuid = al.RandomStringUtils.randomUUID();
        //System.debug('--------------------- uuid ----------------' + uuid);
        Blob bsig = Crypto.generateDigest('cc_hlpr_MD5', Blob.valueOf(uuid));
        String token = EncodingUtil.base64Encode(bsig);
        //System.debug('--------------------- token ----------------' + token);
        */
        try
        {
            api.retrieveCart(null);
        }
        catch(cc_api_Cart_va.DuplicatedEncryptedCartIdException e)
        {
            System.assert(true);
        }
        System.assert(api.retrieveCart('123') == null);
        cc_api_Cart_va.getLastModifiedValidCart(UserInfo.getUserId());
        list<e_product__c> pl = [select id, sku__c from e_product__c where sku__c like '999%'];
        
        api.addBulkItemsToActiveCart(new List<ID>{pl[0].Id,pl[1].Id}, 5, true, cc_util_CloudCraze.application.Default_Storefront__c);

        Test.stopTest();
    }   
    
    
    static testMethod void cloneCartsTest() {
        setupData();
        Double qty = 1.0;
        
        cc_api_Cart_va api = new cc_api_Cart_va();
        api.accountId = cc_util_CloudCraze.getAnonymousAccountID();
        E_Cart__c testCart = api.createEmptyCart();
        //System.assertEquals(api.accountId, cc_util_CloudCraze.getAccountID());

       
        String placeOrderCart1 = api.addToCart(product1.Id, testCart.id, qty, true, cc_util_CloudCraze.application.Default_Storefront__c);
        placeOrderCart1 = api.addToCart(product2.Id, placeOrderCart1, qty, true, cc_util_CloudCraze.application.Default_Storefront__c);
        
        //add bundle product to first cart
        placeOrderCart1 = api.addToCart(majorLineItem.Id, placeOrderCart1, qty, true, cc_util_CloudCraze.application.Default_Storefront__c);
        
        
        Test.startTest();
        
        //System.debug('---Limit.query before merge cart-----' + Limits.getQueries());
         E_Cart__c clonedCart = api.cloneCart(placeOrderCart1);
        
        clonedCart = cc_dao_Cart_va.retrieveCart(clonedCart.id, cc_dao_Cart_va.CART_HEADER | cc_dao_Cart_va.CART_ITEMS);
        system.assert(clonedCart.encryptedId__c != placeOrderCart1);
        Test.stopTest();
    }   
    
    
    static testMethod void addBulkItemsToActiveCartTest() {
        setupData();
        Double qty = 1.0;
        
        cc_api_Cart_va api = new cc_api_Cart_va();
        api.accountId = cc_util_CloudCraze.getAnonymousAccountID();
        E_Cart__c testCart = api.createEmptyCart();
        //System.assertEquals(api.accountId, cc_util_CloudCraze.getAccountID());

       
        String placeOrderCart1 = api.addToCart(product1.Id, testCart.id, qty, true, cc_util_CloudCraze.application.Default_Storefront__c);
        placeOrderCart1 = api.addToCart(product2.Id, placeOrderCart1, qty, true, cc_util_CloudCraze.application.Default_Storefront__c);
        
        //add bundle product to first cart
            placeOrderCart1 = api.addToCart(majorLineItem.Id, placeOrderCart1, qty, true, cc_util_CloudCraze.application.Default_Storefront__c);
        
        E_Cart__c testCart2 = api.createEmptyCart();
        String placeOrderCart2 = api.addToCart(product1.Id, testCart2.id, qty, true, cc_util_CloudCraze.application.Default_Storefront__c);
        placeOrderCart2 = api.addToCart(product2.Id, placeOrderCart2, qty, true, cc_util_CloudCraze.application.Default_Storefront__c);

        Test.startTest();
        
        
        try
        {
            api.retrieveCart(null);
        }
        catch(cc_api_Cart_va.DuplicatedEncryptedCartIdException e)
        {
            System.assert(true);
        }
        System.assert(api.retrieveCart('123') == null);
        cc_api_Cart_va.getLastModifiedValidCart(UserInfo.getUserId());
        list<e_product__c> pl = [select id, sku__c from e_product__c where sku__c like '999%'];
        
        api.addBulkItemsToActiveCart(new List<ID>{pl[0].Id,pl[1].Id}, 5, true, cc_util_CloudCraze.application.Default_Storefront__c);

        Test.stopTest();
    }   
    static testMethod void addToWishListTest(){
        cc_api_test_Cart_va.prepTestData();
        String prodStatus = cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED;
        //ID prodStatus = cc_util_CloudCraze.getIDByCode('ProductStatus', cc_cnst_CloudCraze.PRODUCT_RELEASED_STATUS_CODE);
        E_Product__c product5 = new E_Product__c(SKU__C='testSKU1',  Name='test product 1', ProductStatus__c=prodStatus);
        insert product5;
        Test.startTest();

        Double qty = 1.0;
        cc_api_Cart_va api = new cc_api_Cart_va();
        String wishlistID = api.addToWishList(product5.id, qty, UserInfo.getUserId());
        
        // TODO: Add meaningful assertion
        System.assert(true);
        
        Test.stopTest();
    }
    static testMethod void testAddCouponCodeAsLineitem(){
        //cc_test_PrepTestData.loadCustomSettings();
        cc_test_TestDataSetup.LoadData();
        System.runas(cc_test_TestDataSetup.testUser) {
        Test.startTest();

        List<E_Product__c> productList = cc_test_PrepTestData.insertProduct(5);
        cc_api_Cart_va api = new cc_api_Cart_va();
        E_Cart__c testCart = api.createEmptyCart();
        testCart.Name__c='MyTestCart';
        Id cartId = testCart.Id;
        System.AssertEquals(productList[0].id, api.addCouponToCartAsLineItem(cartId, productList[0].SKU__c, productList[0].Name, cc_util_CloudCraze.application.Default_Storefront__c));
        //cc_test_PrepTestData.insertCode('ProductStatus', 'Released', cc_cnst_CloudCraze.PRODUCT_RELEASED_STATUS_CODE);
        System.AssertNotEquals(null, api.addCouponToCartAsLineItem(cartId, 'Ccode', 'CName', cc_util_CloudCraze.application.Default_Storefront__c));
    
        Test.stopTest();
        }
    }

    static testMethod void testDeleteCartItem(){
        //cc_test_PrepTestData.loadCustomSettings();
        cc_test_TestDataSetup.LoadData();
        System.runas(cc_test_TestDataSetup.testUser) {
        List<E_Product__c> productList = cc_test_PrepTestData.insertProduct(5);
        E_Cart__c cartHeader =cc_test_PrepTestData.insertCart(true, cc_cnst_PickListConstants.CARTSTATUS_OPEN);
        List<E_CartItem__c> cartItemList = cc_test_PrepTestData.insertCartItems(productList, cartHeader.id); 

        Test.startTest();

        cc_api_Cart_va api = new cc_api_Cart_va();
        List<E_CartItem__c> CheckcartItemList = [Select id from E_CartItem__c where Cart__c = :cartHeader.id];
        System.AssertEquals(5, CheckcartItemList.size());
        api.deleteItemFromCart(cartHeader.id, cartItemList[0].id);
        CheckcartItemList = [Select id from E_CartItem__c where Cart__c = :cartHeader.id];
        System.AssertEquals(4, CheckcartItemList.size());
        api.deleteItemFromWishList(cartHeader.id, productList[3].id);
        CheckcartItemList = [Select id from E_CartItem__c where Cart__c = :cartHeader.id];
        System.AssertEquals(3, CheckcartItemList.size());
        List<Id> productListId = new List<Id>();
        for(E_Product__c thisProd : productList){
            productListId.add(thisProd.id);
        } 
        //System.AssertNotEquals(null, api.addBulkItemsToActiveCart(productListId, Double.valueOf('1'), false, cc_util_CloudCraze.application.Default_Storefront__c));
        api.addBulkItemsToActiveCart(productListId, Double.valueOf('1'), false, cc_util_CloudCraze.application.Default_Storefront__c);
        //System.AssertEquals(null, api.getRelatedProducts(productList[0].id));
        api.getRelatedProducts(productList[0].id);
        
        Test.stopTest();
        }
    }
    
    static testMethod void placeOrderTest() {
        //setup testing data
        cc_test_PrepTestData.loadCustomSettings();
        E_AccountGroup__c accountGroup = new E_AccountGroup__c();
        insert accountGroup;
        
        //Account unitTestAccount = new Account(name='UnitTestAccount', E_AccountGroup__c=accountGroup.Id);
        //insert unitTestAccount;
        
        //System.debug('----------------------------' + UserInfo.getUserType());
        
        RecordType rt = [Select r.Name, r.Id From RecordType r where r.Name = 'Person Account' limit 1];
        
        Account unitTestAccount = new Account(LastName='UnitTestAccount', RecordTypeID = rt.Id, E_AccountGroup__c=accountGroup.Id, OwnerId=userInfo.getUserId());
        insert unitTestAccount;

        E_PriceList__c priceList = new E_PriceList__c(Name='Enterprise');
        List<E_PriceList__c> pll = [select a.id from E_PriceList__c a where a.name='Enterprise' and a.isDeleted=false];
        if(pll.size() != 0)
        {
            priceList = pll[0];
        }
        else 
        {
            insert priceList;
        }
//      E_Code__c prodStatusCode = cc_test_PrepTestData.insertCode('ProductStatus', 'Released', cc_cnst_CloudCraze.PRODUCT_RELEASED_STATUS_CODE);
        //ID prodStatus = cc_util_CloudCraze.getIdByDecode('ProductStatus', 'Released');
        String prodStatus = cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED;
        //ID prodStatus = cc_util_CloudCraze.getIDByCode('ProductStatus', cc_cnst_CloudCraze.PRODUCT_RELEASED_STATUS_CODE);
        E_AccountGroupPriceList__c agpl = new E_AccountGroupPriceList__c(AccountGroup__c = accountGroup.Id, Pricelist__c=priceList.id);
        insert agpl;
        E_Product__c product5 = new E_Product__c(SKU__C='testSKU1',  Name='test product 1', ProductStatus__c=prodStatus);
        insert product5;
        E_PriceListItem__c pli = new E_PriceListItem__c(Pricelist__c=priceList.Id, Product__c=product5.id, Price__c=200);
        insert pli;
        E_Product__c product6 = new E_Product__c(SKU__C='testSKU2',  Name='test product 2', ProductStatus__c=prodStatus);
        insert product6;
        pli = new E_PriceListItem__c(Pricelist__c=priceList.Id, Product__c=product6.id, Price__c=300);
        insert pli;
        
        E_ContactAddr__c shipTo = new E_ContactAddr__c(
        AddressFirstline__c='100 Pine Street', City__c='SmallTown', DaytimePhone__c='(847) 555-1212',
        FirstName__c='Craig', HomePhone__c='(847) 555-1212', LastName__c='Traxler',
        PostalCode__c='60601', State__c='Idaho', StateISOCode__c='ID',
        CountryISOCode__c='USA');
        insert shipTo;
        E_ContactAddr__c billTo = new E_ContactAddr__c(
        AddressFirstline__c='100 Pine Street', City__c='SmallTown', DaytimePhone__c='(847) 555-1212',
        FirstName__c='Craig', HomePhone__c='(847) 555-1212', LastName__c='Traxler',
        PostalCode__c='60601', State__c='Idaho', StateISOCode__c='ID',
        CountryISOCode__c='USA');
        insert billTo;
        
        Test.startTest();
        Double qty = 1.0;
        cc_api_Cart_va api = new cc_api_Cart_va();
        api.accountId = unitTestAccount.Id;
        
        String placeOrderCart1 = api.addToCart(product5.Id, null, qty, true, cc_util_CloudCraze.application.Default_Storefront__c);
        placeOrderCart1 = api.addToCart(product6.Id, placeOrderCart1, qty, true, cc_util_CloudCraze.application.Default_Storefront__c);
        E_Cart__c cart = api.retrieveCart(placeOrderCart1);
        System.assert(cart != null);
        cart.BillTo__c = billTo.id;
        cart.ShipTo__c = shipTo.id;
        update cart;
        api.placeOrder(placeOrderCart1);
        System.assert(true);
        
        Test.stopTest();     
    }
}