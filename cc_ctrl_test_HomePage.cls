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
private with sharing class  cc_ctrl_test_HomePage {

    static testMethod void testCategoryTree1() {
        //cc_test_PrepTestData.loadCustomSettings();
        cc_test_TestDataSetup.LoadData();
        System.runas(cc_test_TestDataSetup.testUser) {
        Test.startTest();

        cc_api_Cart api = new cc_api_Cart();  
        //E_Code__c usd = cc_test_PrepTestData.insertCode('CurrencyCode Dummy', 'US. Dollars', '10');
       // E_Code__c commercial = cc_test_PrepTestData.insertCode('CustomerType Dummy', 'Commercial', 'Commercial');
        E_Category__c category= createCategory();   
        List<E_Product__c> productList = insertProduct(2);
        E_ProductCategory__c  productCategory1 = new E_ProductCategory__c(Product__c=productList[0].Id, Category__c=category.Id); 
        E_ProductCategory__c  productCategory2 = new E_ProductCategory__c(Product__c=productList[1].Id, Category__c=category.Id);
        insert new List<E_ProductCategory__c> {productCategory1,productCategory2};      
        E_Cart__c cart = api.createEmptyCart('USD', 'Commercial');
        
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
        
        
        PageReference pageRef = System.Page.Cart;
        //pageRef.getParameters().put('viewState','');
        pageRef.getParameters().put('categoryID',category.Id);
        pageRef.getParameters().put('cartID',cart.EncryptedID__c);
        //pageRef.getParameters().put('store',cc_util_CloudCraze.application.Default_Storefront__c);
        pageRef.getParameters().put('hidemenu','y');
        pageRef.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY,'US');
        pageRef.getParameters().put('retURL','/apex/Cart');
        Test.setCurrentPage(pageRef);
        
        cc_ctrl_HomePage catTree = new cc_ctrl_HomePage(); 
        //catTree.showQuickOrder();
        //System.assertEquals(cc_ctrl_HomePage.QUICKORDER_VIEW, catTree.viewState);
        //System.assertEquals(null, catTree.listProduct());
        //catTree.getCategoryTree();
        
        catTree.currentProductID = productList[0].Id;
        //catTree.productDetail();
        
        Test.stopTest();
        }
    }
    
    static testMethod void testCategoryTree2() {
        //cc_test_PrepTestData.loadCustomSettings();
        cc_test_TestDataSetup.LoadData();
        System.runas(cc_test_TestDataSetup.testUser) {
        Test.startTest();

        cc_api_Cart api = new cc_api_Cart();  
        E_Cart__c cart = api.createEmptyCart('USD', 'Commercial');
        List<E_Product__c> productList = insertProduct(2);
        PageReference pageRef = System.Page.Cart;
        pageRef.getParameters().put('viewState','');
        pageRef.getParameters().put('cartID',cart.EncryptedID__c);
        pageRef.getParameters().put('retURL','/apex/Cart');
        Test.setCurrentPage(pageRef);
        
        System.debug('-0--------------' + productList);
        cc_ctrl_HomePage catTree = new cc_ctrl_HomePage(); 
        System.assertEquals('0.00', catTree.getCCCartTotal());
        List<E_CartItem__c> cartItems = new List<E_CartItem__c>();
        for(E_Product__c prod:productList){
            api.addToCart(prod.Id, cart.Id, 1,false, 'USD', 
                          'Commercial', cc_util_CloudCraze.application.Default_Storefront__c);
            E_CartItem__c cartItem = new E_CartItem__c();
            cartItem.StoreId__c = cc_util_CloudCraze.application.Default_Storefront__c;
            cartItem.Quantity__c = 1.0;
            cartItem.Product__c = prod.Id;
            cartItem.SubAmount__c = 50.99;
            cartItem.Price__c   = 50.99;
            cartItem.Cart__c = cart.Id;
            cartItems.add(cartItem);
        }           
        insert cartItems;
        
        System.assertEquals(4,catTree.cartItems.size());
        System.assertEquals('101.98', catTree.getCCCartTotal());
        //System.assertEquals(4,catTree.getCCCartItemCount());
	try{
		catTree.getCCCartItemCount();
	}catch(Exception e){
	}

        E_RecentItem__c recent = new E_RecentItem__c();
        recent.Name = 'test';
        recent.Product__c = catTree.currentProductID;
        recent.User__c = UserInfo.getUserId();
        insert recent;

        //Integer recentSize = catTree.recentItems.size();
        
        PageReference pageRef2 = System.Page.Cart;
        pageRef2.getParameters().put('cartID',cart.EncryptedID__c);
        pageRef2.getParameters().put('productID',productList[0].Id);
        Test.setCurrentPage(pageRef2);
        //System.assertNotEquals(null,catTree.addToCart());
	try{
		catTree.addToCart();
	}catch(Exception e){
	}
       
        catTree.currentProductID = productList[0].Id;
        Test.stopTest();
        }
    } 
     
    static testMethod void testCategoryTree3() {
        //cc_test_PrepTestData.loadCustomSettings();
        cc_test_TestDataSetup.LoadData();
        System.assert([Select c.Id From E_ApplicationSettings__c c where name='CloudCraze'].size() != 0);
        System.runas(cc_test_TestDataSetup.testUser) {
        List<E_Product__c> productList = insertProduct(1);
        Test.startTest();

        cc_ctrl_HomePage catTree = new cc_ctrl_HomePage(); 
        PageReference pageRef = System.Page.Cart;
        pageRef.getParameters().put('ReviewSubject','Test Subject');
        pageRef.getParameters().put('Review','Test Review');
        pageRef.getParameters().put('rating','4');
        pageRef.getParameters().put('productId',productList[0].Id);
        Test.setCurrentPage(pageRef);
        //catTree.saveReview();
        catTree.getWishListForCurrentUser();
        
        //System.assertEquals(4, catTree.getAverageRating());
        
        Test.stopTest();
        }
    }
    
    static E_Category__c createCategory(){
        E_Category__c categoryParent = new E_Category__c(Name='Test Parent Category',
                                                         CategoryID__c='3789',
                                                         LongDesc__c ='desc');

        insert categoryParent;

        E_Category__c categoryChild = new E_Category__c(Name='Test Child Category', 
                                                        ParentCategory__c=categoryParent.Id,
                                                        CategoryID__c='789',
                                                        LongDesc__c ='desc');
        insert categoryChild;
        return categoryChild;
    }

    private Static List<E_Product__c> insertProduct(Integer count){
        List<E_Product__c> productList = new List<E_Product__c>();
        Integer i = 0;
        while(i < count){
            E_Product__c prod = new E_Product__c();
            prod.SKU__c = cc_util_RandomString.randomUUID();
            prod.Name = 'ProductName'+String.valueOf(i);
			prod.ProductStatus__c = 'Not Orderable';
            prod.LeadTime__c = 1;
            prod.QuantityPerUnit__c = 1;
            prod.StartDate__c = System.today();
            prod.EndDate__c = System.today();
			prod.ShippingWeight__c=1;
            productList.add(prod);
            i++;
        }
        insert productList;
        return productList;
    } 
}