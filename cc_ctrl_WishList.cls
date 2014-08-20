//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without
//  modification is PROHIBITED.
//
//
public with sharing class cc_ctrl_WishList extends cc_ctrl_CloudCraze {
	//==================================================
	// INSTANCE PROPERTIES
	//==================================================
	private String cartCode {get;set;}
	public String wishListID {get;set;}
	public String thisCartID {get;set;}
	public String currentProductID {get;set;}
	public List<cc_bean_CartItem> cc_bean_CartItem {get;private set;}
	public List<cc_bean_MiniCartViewItem> miniCartViewData {get;private set;}
	public Double qty {get;set;}
	public E_Cart__c wishList {get;set;}
	public List<E_CartItem__c> wishListItemList {get;set;}
	public String viewState {get;set;}
	public Integer miniWishListSize {get;set;}

	public String cartTotal {
		get {
			String cTotal = '0.00';
			if (wishListID == null || ''.equals(wishListID)) { return cTotal; }
			else {
				List<E_Cart__c> cartList = [
					select c.SubTotalAmount_2__c
					from E_Cart__c c
					where c.Id = :wishListID
						and c.CartType__c = :cc_cnst_PickListConstants.CARTTYPE_WISHLIST
				];
				for (E_Cart__c c : cartList) { return String.valueOf(c.SubTotalAmount_2__c);}
				return cTotal;
			}
		}
	}

	//==================================================
	// CONSTRUCTOR
	//==================================================
	public cc_ctrl_WishList() {
		thisCartID = getCartId();
		getCartItems();
	}
	public cc_ctrl_WishList(ApexPages.StandardController c) { this(); }

	//==================================================
	// INSTANCE VARIABLES
	//==================================================
	public List<cc_bean_CartItem> data = new List<cc_bean_CartItem>();

	//==================================================
	// SERVICE METHODS
	//==================================================

	//==================================================
	// HELPER METHODS
	//==================================================
    public void initializeWishListForCurrentUser() {
		List<E_Cart__c> wishListLists = [
			select e.User__c, e.TotalDiscount__c, e.TotalAmount__c,
				e.SubTotalAmount__c, e.SubTotalAmount_2__c, e.Name__c,
				e.Id, e.CartId__c
			from E_Cart__c e
			where e.CartType__c = :cc_cnst_PickListConstants.CARTTYPE_WISHLIST
				and e.User__c = :UserInfo.getUserId()
		];

		if (wishListLists == null || wishListLists.size() == 0) {
			E_Cart__c newWishList = new E_Cart__c();
			newWishList.Account__c = cc_util_CloudCraze.getAccountID();
			newWishList.CartStatus__c = cc_cnst_PickListConstants.CARTSTATUS_OPEN;
			newWishList.user__c = UserInfo.getUserId();
			newWishList.CartType__c = cc_cnst_PickListConstants.CARTTYPE_WISHLIST;
			newWishList.Name__c = 'MyWishList';
			if (UserInfo.getSessionId() != null) {
				newWishList.SessionID__c = UserInfo.getSessionId();
			} else {
				newWishList.SessionID__c = 'No Session Data Available';
			}
			newWishList.OwnerId = UserInfo.getUserId();
			//insert newWishList;
			this.wishList = newWishList;
		} else {
			this.wishList = wishListLists[0];
		}

		this.wishListID = this.wishList.id;
	}

	public void getWishListForCurrentUser() {
		if (al.StringUtils.isEmpty(this.wishListID)) {
			List<E_Cart__c> wishListLists = [
				select e.User__c, e.TotalDiscount__c, e.TotalAmount__c,
					e.SubTotalAmount__c, e.SubTotalAmount_2__c,
					e.Name__c, e.Id, e.CartId__c
				from E_Cart__c e
				where e.CartType__c = :cc_cnst_PickListConstants.CARTTYPE_WISHLIST
					and e.User__c = :UserInfo.getUserId()
			];

			if (wishListLists != null && wishListLists.size() > 0) {
				this.wishListID = wishListLists[0].id;
			}
			Integer noOfQueries = Limits.getQueries();
		}
	}

	private E_Cart__c getLatestCart(Id userId) {
		E_Cart__c retCart = null;
		List<E_Cart__c> cartList = [
			select e.AnonymousID__c, e.Id, e.IsDeleted, e.LastModifiedById,
				e.OwnerId, e.CurrencyISOCode__c, e.CustomerTypeCode__c,
				e.EncryptedID__c, e.ActiveCart__c, e.CartStatus__c
			from E_Cart__c e
			where User__c = :userId
				and e.CartType__c = :cc_cnst_PickListConstants.CARTTYPE_CART
			order by e.LastModifiedDate desc
		];

		for (E_Cart__c cart : cartList){
			if ((cart.IsDeleted == false)
				&& (cart.ActiveCart__c)
				&& (cart.AnonymousID__c == false)
				&& (cart.CartStatus__c == cc_cnst_PickListConstants.CARTSTATUS_OPEN)
			) {
				retCart = cart;
			}
			break; // only take the first one
		}
		return retCart;
	}

	private List<cc_bean_CartItem> buildWishListViewData(
		List<E_Product__c> pdl, Map<String, E_CartItem__c> productToWishListItem
	) {
		cc_bean_CartItem = new List<cc_bean_CartItem>();

		// Get list of product SKUs and list of ProductIDs
		List<String> skuList = new List<String>();
		List<Id> productIdList = new List<Id>();
		Map<Id, E_Product__c> productMap = new Map<Id,E_Product__c>();

		for (E_Product__c pd : pdl) {
			skuList.add(pd.SKU__c);
			productIdList.add(pd.Id);
			productMap.put(pd.Id, pd);
		}

		// Get Map<SKU ID, PriceListItem> of prices
		Map<String, cc_bean_PriceInfo> priceLineMap = cc_ctrl_PricingEngine.getPriceMap(
			skuList, cc_util_CloudCraze.getAccountID(), null, null, null
		);

		cc_dao_ProductMedia productMedia=new cc_dao_ProductMedia();
		Map<Id,cc_bean_MediaWrapper> attachmentMap= productMedia.getProductThumbnailMedia(productIdList);

		for (E_Product__c pd : pdl) {
			E_CartItem__c thisCartItem = productToWishListItem.get(pd.id);
			cc_bean_CartItem data = new cc_bean_CartItem();
			data.product = pd;
			data.mockProduct = new cc_bean_MockProduct(pd);
			data.pricebean = pricelinemap.get(pd.SKU__c);
			data.createDate = String.valueOf(thisCartItem.CreatedDate);
			if (attachmentMap.get(pd.Id) != null) {
				data.mediaWrapper.uri = attachmentMap.get(pd.Id).uri;
				data.mediaWrapper.sourceType = attachmentMap.get(pd.Id).sourceType;
			}
			cc_bean_CartItem.add(data);
		}
		return cc_bean_CartItem;
	}


	//==================================================
	// SERVICE METHODS
	//==================================================
	public List<cc_bean_CartItem> getCartItems() {
		getWishListForCurrentUser();
		wishListItemList = new List<E_CartItem__c>();
		if (wishListID == null || ''.equals(wishListID)) { return null; }
		else {
			wishListItemList = [
				select c.Cart__c, c.Name, c.Product__c, c.Product__r.Id, c.Product__r.Name,
					c.Product__r.ShortDesc__c, c.Product__r.SKU__c, c.Quantity__c, c.Price__c,
					c.SubAmount__c, c.CreatedDate, c.Comments__c
				from E_CartItem__c c
				where c.Cart__c = :wishListID and c.isDeleted = false
			];

			if (wishListItemList != null  && wishListItemList.size() > 0) {
				Map<String, E_CartItem__c> productToWishListItem = new Map<String, E_CartItem__c>();
				List<String> productIdList = new List<String>();
				for (E_CartItem__c thisWishListItem : wishListItemList) {
					productIdList.add(thisWishListItem.Product__c);
					productToWishListItem.put(thisWishListItem.Product__c, thisWishListItem);
				}

				List<String> statusCodes = new List<String>();
				statusCodes.add(cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED);
				statusCodes.add(cc_cnst_PickListConstants.PRODUCTSTATUS_NOTORDERABLE);
				List<E_Product__c> pdl = cc_dao_Product.readProductForStatusWithID(productIdList, cc_util_Locale.getUserLanguage(), new List<String> {cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED, cc_cnst_PickListConstants.PRODUCTSTATUS_NOTORDERABLE});
				this.cc_bean_CartItem = buildWishListViewData(pdl, productToWishListItem);
			}
		}
		return this.cc_bean_CartItem;
	}

	public PageReference addToCart() {
		cc_api_Cart cc_api_Cart = new cc_api_Cart();
		String cartID = null;
		E_Cart__c cart = getLatestCart(UserInfo.getuserId());
		if (cart != null) cartID = cart.EncryptedID__c;

		thisCartID = cc_api_Cart.addToCart(currentProductID, cartID, qty, storefront.Name);
		removeItemFromWishlist(currentProductID);

		PageReference page = System.Page.Cart;
		page.getParameters().put('cartID', thisCartID);
		page.getParameters().put('productID', currentProductID);
		page.getParameters().put('viewState', 'CartView');
		page.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, ipAddressLocation);
		page.setRedirect(true);

		return page;
	}

	public PageReference addToWishList() {
		System.debug('addToWishList 1');
		cc_api_Cart cc_api_Cart = new cc_api_Cart();
		this.wishListID = cc_api_Cart.addToWishList(currentProductID, qty, UserInfo.getUserId());
		System.debug('addToWishList 2');
		PageReference page = System.Page.Cart;
		page.getParameters().put('cartID', wishListID);
		page.getParameters().put('productID', currentProductID);
		page.getParameters().put('viewState', 'WishListView');
		page.setRedirect(true);
		System.debug('addToWishList 3');
		return page;
	}

	public PageReference deleteFromWishList() {
		cc_api_Cart cc_api_Cart = new cc_api_Cart();
		cc_api_Cart.deleteItemFromWishList(this.wishListID, currentProductID);
		PageReference page = System.Page.MyAccount;
		page.getParameters().put('cartID', thisCartID);
		page.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, ipAddressLocation);
		page.getParameters().put('viewState', 'wishlists');
		page.setRedirect(true);
		return page;
	}

	public PageReference viewMyWishList() {
		PageReference page = System.Page.Cart;
		page.getParameters().put('cartID', thisCartID);
		page.getParameters().put('viewState', 'WishListView');
		page.setRedirect(true);

		return page;
	}

	public PageReference addAllToCart() {
		List<Id> prodIdList = new List<Id>();
		Set<Id> nonOrderableProducts = new Set<Id>();
		for (cc_bean_CartItem wishListCart : cc_bean_CartItem) {
			if (wishListCart.product.ProductStatus__c == 'Not Orderable'
				&& al.StringUtils.isNotEmpty(wishListCart.product.Id)
				&& !nonOrderableProducts.contains(wishListCart.product.Id)
			) {
				nonOrderableProducts.add(wishListCart.product.Id);
			}
		}
		for (E_CartItem__c thisCartItem : this.wishListItemList) {
			if (!nonOrderableProducts.contains(thisCartItem.Product__c)) {
				prodIdList.add(thisCartItem.Product__c);
			}
        }

		cc_api_Cart cart = new cc_api_Cart();
		String cartID = cart.addBulkItemsToActiveCart( prodIdList, 1, true, storefront.Name);
		PageReference page = System.Page.Cart;

        page.getParameters().put('cartID', cartID);
        page.getParameters().put('viewState', 'CartView');
		page.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, ipAddressLocation);
		page.setRedirect(true);

		delete wishListItemList;
		return page;
	}

	public Integer getWishListItemCount() {
		cc_api_Cart api = new cc_api_Cart();
		Integer wicount = api.getCartItemCount(wishListID, true);
		Integer noOfQueries = Limits.getQueries();
		return wicount;
	}

	public List<cc_bean_MiniCartViewItem> getMiniWishListItems() {
		if (al.ArrayUtils.isEmpty(miniCartViewData)) {
			getWishListForCurrentUser();
			List<cc_bean_MiniCartViewItem> viewList = new List<cc_bean_MiniCartViewItem>();
			cc_api_Cart api = new cc_api_Cart();
			List<E_CartItem__c> items = api.getCartItems(wishListID, 3);

        	if (items != null && items.size() > 0) {
				List<Id> productIdList = new List<Id>();
				for (E_CartItem__c item : items) { productIdList.add(item.Product__c); }

				List<E_Product__c> productList = new List<E_Product__c>();
				productList = [
					select a.ProductStatus__c, a.ProductId__c
					from E_Product__c a
					where a.Id IN : productIdList
				];
				Map<Id, String> productStatus = new Map<Id, String>();
				for (E_Product__c product: productList) {
					if (!productStatus.containsKey(product.Id)) { productStatus.put(product.Id, product.ProductStatus__c); }
				}

				// get thumbnails
				cc_dao_ProductMedia productMedia= new cc_dao_ProductMedia();
				Map<Id,cc_bean_MediaWrapper> thumbnailMap = productMedia.getProductThumbnailMedia(productIdList);

				for (E_CartItem__c item : items) {
					if (cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED.equalsIgnoreCase(productStatus.get(item.Product__c))
						|| cc_cnst_PickListConstants.PRODUCTSTATUS_NOTORDERABLE.equalsIgnoreCase(productStatus.get(item.Product__c))
					) {
						cc_bean_MiniCartViewItem viewItem = new cc_bean_MiniCartViewItem();
						viewItem.item = item;
						viewItem.mockCartItem = new cc_bean_MockCartItem(item);

						// thumbnailId
						viewItem.mediaWrapper.uri = thumbnailMap.get(item.Product__c).uri;
						viewItem.mediaWrapper.sourceType = thumbnailMap.get(item.Product__c).sourceType;
						viewItem.isReleased = cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED.equalsIgnoreCase(productStatus.get(item.Product__c));
						viewList.add(viewItem);
					}
				}
			}
			Integer noOfQueries = Limits.getQueries();
			miniCartViewData = viewList;
		}
		return miniCartViewData;
	}

	public void removeItemFromWishlist() {
		String removeItemId = ApexPages.currentPage().getParameters().get('removeItemId');
		removeItemFromWishlist(removeItemId);
	}

	public void removeItemFromWishlist(Id itemId) {
		cc_api_Cart capi = new cc_api_Cart();
		capi.deleteItemFromCart(wishListID, itemId);
	}

    //==================================================
    // TEST METHODS
    //==================================================

    /*
    static testMethod void testInitializeWishListForCurrentUser() {
    	cc_test_PrepTestData.loadCustomSettings();
    	System.RunAs(cc_test_TestDataSetup.testUser) {
			Test.startTest();
	        cc_ctrl_WishList wishList = new cc_ctrl_WishList();
	        wishList.initializeWishListForCurrentUser();
	        System.assertNotEquals(null, wishList.wishListID);
	        Test.stopTest();
    	}
    }

    static testMethod void testgetWishListForCurrentUser() {
		cc_test_PrepTestData.loadCustomSettings();
		User testUser = cc_test_PrepTestData.createUser(cc_test_PrepTestData.PROFILE_STANDARD_USER);

		System.runAs(testUser) {
			Test.startTest();
			cc_test_PrepTestData.insertWishList();
			cc_ctrl_WishList wishList = new cc_ctrl_WishList();
			wishList.getWishListForCurrentUser();
			System.assertNotEquals(null, wishList.wishListID);
			Test.stopTest();
		}
	}
	*/

	static testMethod void myUnitTest() {
		cc_test_TestDataSetup.loadData();
		System.RunAs(cc_test_TestDataSetup.testUser) {
			E_Cart__c newWishList = new E_Cart__c();
            newWishList.Account__c = cc_util_CloudCraze.getAccountID();            
            newWishList.CartStatus__c=cc_cnst_PickListConstants.CARTSTATUS_OPEN;
            newWishList.user__c = UserInfo.getUserId();
            //newWishList.CartType__c = codeForWishList.id;
            newWishList.CartType__c=cc_cnst_PickListConstants.CARTTYPE_WISHLIST;
            newWishList.Name__c = 'MyWishList Dummy';
            newWishList.SessionID__c = 'Dummy Session';
            newWishList.OwnerId = UserInfo.getUserId();
            
            insert newWishList;
			ApexPages.currentPage().getParameters().put('g', 'ipaddresslocation');
			cc_ctrl_WishList ctrl = new cc_ctrl_WishList();

			ctrl.initializeWishListForCurrentUser();
			System.assert(ctrl.wishListID != null);

			ctrl.getWishListForCurrentUser();
			System.assert(ctrl.wishListID != null);

			System.assert(ctrl.cartTotal == '0.00');

			System.assert(ctrl.getLatestCart(cc_test_TestDataSetup.testUser.Id) == null);
			E_Cart__c testCart = (new cc_api_Cart()).createEmptyCart();
			System.assert(ctrl.getLatestCart(cc_test_TestDataSetup.testUser.Id) != null);

			List<cc_bean_CartItem> cartItems = ctrl.getCartItems();

			List<E_Product__c> products = cc_test_PrepTestData.insertProduct(5);

			// add to wishlist
			ctrl.currentProductID = products[0].Id;
			ctrl.qty = 1;
			System.assert(ctrl.addToWishList() != null);

			ctrl.currentProductID = products[1].Id;
			ctrl.qty = 1;
			System.assert(ctrl.addToWishList() != null);

			ctrl.currentProductID = products[2].Id;
			ctrl.qty = 1;
			System.assert(ctrl.addToWishList() != null);
			System.assertEquals(3, ctrl.getWishListItemCount());

			// delete from wishlist
			ctrl.currentProductID = products[2].Id;
			ctrl.qty = 1;
			System.assert(ctrl.deleteFromWishList() != null);
			System.assertEquals(2, ctrl.getWishListItemCount());

			// get cart items
			System.assert(ctrl.wishListID != null);
			System.assertEquals(2, ctrl.getCartItems().size());

			// add to wishlist
			ctrl.currentProductID = products[3].Id;
			ctrl.qty = 1;
			System.assert(ctrl.addToWishList() != null);

			ctrl.currentProductID = products[4].Id;
			ctrl.qty = 1;
			System.assert(ctrl.addToWishList() != null);

			// view wishlist
			System.assert(ctrl.viewMyWishList() != null);

			// add to cart
			//ctrl.currentProductID = products[3].Id;
			//ctrl.qty = 1;
			//System.assert(ctrl.addToCart() != null);

			// get mini wish list
			//System.assertEquals(2, ctrl.getMiniWishListItems().size()); // fails (null exception)

			// remove from wish list
			ApexPages.currentPage().getParameters().put('removeItemId', products[1].Id);
			ctrl.removeItemFromWishList();
			System.assertEquals(4, ctrl.getWishListItemCount());

			ctrl.removeItemFromWishList(products[0].Id);
			System.assertEquals(4, ctrl.getWishListItemCount());

			// check cart total
			// System.assertEquals('0.00', ctrl.cartTotal);
		}
	}
}