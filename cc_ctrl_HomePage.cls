//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
// 
public with sharing class cc_ctrl_HomePage extends cc_ctrl_ProductCatalog {
    
    //==================================================
    // CONSTANTS
    //==================================================
    public static final String List_VIEW = 'ListView';
    public static final String SEARCHRESULTS_VIEW = 'SearchResultsView';
    public static final String DETAIL_VIEW = 'DetailView';
    public static final String CART_VIEW = 'CartView';
    public static final String PROMOTION_VIEW = 'PromotionView';
    public static final String LANDING_PAGE = 'LandingPage';
    public static final String QUICKORDER_VIEW = 'QuickOrder';
    //==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public String currentCategory { get; set; }//TASK ID 1 START Change ProductID to Sku
    public String currentSearchText { get; set; }
    public String currentSku { get; set; }
    public String currentOperation { get; set; }            
    public Boolean detailView { get; set; }
    public String currentCartID 
    { 
    	get {
    		if(currentCartID == null)
    		{
    			currentCartID=Apexpages.currentPage().getParameters().get('cartID');
    			//System.debug('roy---------> current cartid=' + currentCartID);
    			
    		}
    		return currentCartID;
    	} set; }
    public String currentWishListID {get; set; } // TASK ID 7
    public Double qty { get; set ; }
    public ID userID { get {return UserInfo.getUserID(); } set; }
    private String cartCode{get; set; } // TASK ID 7
    public String pageURL {get;set;}
    public ID profileID { 
        get {
            return Userinfo.getProfileId();
        } set; }
        
    public E_Product__c [] products {get; set;}
    public Boolean hideTopMenu { get; set; }

    public cc_bean_ProductForm cc_bean_ProductForm {get;set;}
    
    public List<E_CartItem__c> cartItems {
        get {
            cc_api_Cart api = new cc_api_Cart();
            return api.getCartItems(currentCartID);
        }
    }  
    

    
	//==================================================
    // CONSTRUCTOR
    //==================================================
    public cc_ctrl_HomePage() {
    	super();

        currentCategory = Apexpages.currentPage().getParameters().get('categoryID');
        currentCartID = Apexpages.currentPage().getParameters().get('cartID');
        currentSearchText = Apexpages.currentPage().getParameters().get('searchText');
        currentSku = Apexpages.currentPage().getParameters().get('sku');
        currentOperation = Apexpages.currentPage().getParameters().get('operation');        
        String returnUrl = Apexpages.currentPage().getParameters().get('retURL');

        viewState = LANDING_PAGE;
        getWishListForCurrentUser();
        
        String hidemenu = Apexpages.currentPage().getParameters().get('hidemenu');
        if(hidemenu == 'y') {
            hideTopMenu = true;
        } else {
            hideTopMenu = false;
        }
    }
   
    
	//==================================================
    // HELPER METHODS
    //==================================================
    public cc_ctrl_HomePage getHomePageController() { return this; }
    
   
    // TASK ID 7 START
     public void getWishListForCurrentUser(){
        
        List<E_Cart__c> wishListLists = [Select 
                                            e.User__c, 
                                            e.TotalDiscount__c, 
                                            e.TotalAmount__c, 
                                            e.SubTotalAmount__c, 
                                            e.SubTotalAmount_2__c, 
                                            e.Name__c, 
                                            e.Id, 
                                            e.CartType__c, 
                                            e.CartStatus__c, 
                                            e.CartID__c 
                                          From E_Cart__c e
                                          where e.CartType__c = :cc_cnst_PickListConstants.CARTTYPE_WISHLIST
                                          and e.User__c = :UserInfo.getUserId()
                                         ];
                                         //System.debug(wishListLists);
         if(wishListLists == null || wishListLists.size()==0){
            this.currentWishListID = '';
         }else{
            this.currentWishListID  = wishListLists[0].id;
         }
     }
     // TASK ID 7 END

    //==================================================
    // SERVICE METHODS
    //==================================================
/*
    public PageReference listProduct() {
            return null;
    }
*/	
    public PageReference addToCart() {
        //System.debug('----------------------------------------------addToCart');
        cc_api_Cart cc_api_Cart = new cc_api_Cart();
        qty=1;
        //System.debug('---------CartID in addToCart()is ' + currentCartID);
        //System.debug('---------ProductID in addToCart()is ' + this.currentProductID);
        this.currentCartID = cc_api_Cart.addToCart(this.currentProductID, currentCartID, qty, storeID);
        PageReference page = System.Page.Cart; // PageReference('/apex/PromotionPage');
        page.setRedirect(true);
        page.getParameters().put('cartID', currentCartID);
        page.getParameters().put('productID', currentProductID);
        return page;    
      }
    
   
}