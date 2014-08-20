/**
// * Created by CloudCraze, LLC.
// * Copyright 2010-12 CloudCraze, LLC. All rights reserved
// * @Description: Extension to handle customized related item retrieval.
// * @Author: 1.0
// * @File: cc_kap_extn_RelatedItems
// * =======================================================================================
// * 2012/08/30 1.1 IL -	Refactored
**/
public with sharing class cc_ctrl_Cart extends cc_ctrl_CloudCraze {
	public String currentCartID { get; set; }
	public Integer continueHistoryCount { get; set;}
	private String currentCartOwnerID { get; set; }
	public String anonymousCartID {get; set; }
	
	public Boolean exceptionFlag {get;set;}
	public String exceptionMessage {get;set;}
	public Boolean notOrdProdExist{get;set;}
	public String notOrdProdMessage {get;set;}
	public List<String> userMessages {get; private set; }
	
	public boolean cartHasCouponLineItem {get;set;}
	public String couponCode {get;set;}
	public String couponMessage {get;set;}
	
	public boolean initProcessing = true;
	
	public Double qty { get; set ; }
	public Decimal couponDiscountAmount{get; set;}
	
	
	public Boolean validInventory {
			get {
				return true;
			} private set;}

	public String removeAnonymousCartCookie { get; set; }
	public List<E_CartItem__c> cartItemList {get; set; }
	public String landingPage { get; set; }
	
	public List<cc_bean_ProductListViewData> relatedProducts {get;set;}
	public List<cc_bean_CartItem> cartListViewData {get; private set;}
	public String couponId {get;set;}
	public List<Id> cartProductIdList {
		get {
			cartProductIdList = new List<Id>();
			if(cartItemList!=null){
				for(E_CartItem__c item : cartItemList) {
					cartProductIdList.add(item.Product__c);
				}
			}
			return cartProductIdList;
		}
		private set;
	}

	/** Kaplan Phase 1 Begin */
	public List<Id> cartParentProductIdList {
		get {
			cartParentProductIdList = new List<Id>();
			if(cartItemList!=null){
				for(E_CartItem__c item : cartItemList) {
					cartParentProductIdList.add(item.Product__r.ParentProduct__c);
				}
			}
			return cartParentProductIdList;
		}
		private set;
	}
	public String cartCurrency { get; set; }
	public String cartCustomerType { get; set; }
	public boolean containsShippableItems {get; private set; }
	/** Kaplan Phase 1 End */

	public String currentWishListID {get; set; }
	public String removeCartItemId { get; set; }
	public String zipCode {get;set;}
	public String stateCode {get;set;}
	public String countryCode {get;set;}
	public String cartName {get; set;}
	public String cartComments {get; set;}
	public String cartOwnerEmail {get; set;}
	public String message {get;set;}
	public Boolean showUpsell {
		get{
			if(showUpsell == null){
				showUpsell = false;
			}
			return showUpsell;
		}
		set;
	}


	public List<SelectOption> couponList {
		get {
			if(couponList == null){
				couponList = new List<SelectOption>();
			}
			return couponList;
		}
		set;}
	public String selectedCoupon {get;set;}

	public String cartSubTotalDisplay {
		get {
			String cTotal = '0.00';
			cc_api_Cart api = new cc_api_Cart();
			Decimal total = api.getCartTotal(currentCartID);
			if(total > 0)
			{
				return String.valueOf(total);
			}
			else
			{
				return cTotal;
			}
		}
	}
	
	public Decimal cartSubTotal {
		get {
			Decimal cTotal = 0.00;
			cc_api_Cart api = new cc_api_Cart();
			Decimal total = api.getCartTotal(currentCartID);
			if(total > 0)
			{
				return (total);
			}
			else
			{
				return cTotal;
			}
		}
	}

 	public String cartTotal {
		get {
			String cTotal = '0.00';
			cc_api_Cart api = new cc_api_Cart();
			Decimal total = api.getCartTotal(currentCartID);
			if(total > 0)
			{
				total = total.setScale(2, System.RoundingMode.UP);
				return String.valueOf(total);
			}
			else
			{
				return cTotal;
			}
		}
	}

 	public String cartTotalBeforeCoupons {
		get {
			String cTotal = '0.00';
			cc_api_Cart api = new cc_api_Cart();
			Decimal total = api.getCartTotal(currentCartID);
			if(total > 0)
			{
				total = total.setScale(2, System.RoundingMode.UP);
				return String.valueOf(total + couponDiscountAmount);
			}
			else
			{
				return cTotal + couponDiscountAmount;
			}
		}
	}

	public String couponName {get;set;}
	public E_Coupon__c coupon {get;set;}
	public String requiredSKU {get;set;}
	public Boolean applyToAll {get;set;}
	
	private cc_kap_api_rules_CartRules displayRulesApi {get; set;}
	public String programCode{get; set;}
	public String kbsProgramCodes{get; set;}
	
	//JLL 3/25/2014 IBFee reintroduction
	public E_Cart__c cart {get;set;}
	public String successCouponMessage { get; set; }

	public cc_kap_IBFee_Util IBFeeUtil {
		get{
			if(IBFeeUtil == null)
				IBFeeUtil = new cc_kap_IBFee_Util();
			return IBFeeUtil;
		}
		set;
	}
	
	public cc_bean_Cart cartBean {get;set;}
	public String cartSBUCode {get;set;}
	public String uiKey {get;set;}

	public String IBFeeSKU{get; set;}

	public Decimal dueToday{
		get {
			if(uiKey.equals(cc_kap_utils_AppConstants.PAGE_UI_KEY_CART)){
				return dueTodayPrice;
			}else{
				return dueTodayPrice + cartShipAmount;
			}
		}
		set;
	}
	
	public Double cartShipAmount {
		get {
				if(cartBean.shipToAddress != null && cartBean.shipToAddress.country != null)
				{
					if (displayRulesApi != null)
						cartBean.shipAmount = cc_kap_utils_Cart.calculateLineBasedShipping(displayRulesApi, cartBean.shipToAddress.country, cartSubAmount);
					else
						cartBean.shipAmount = cc_kap_utils_Cart.calculateLineBasedShipping(cartBean.encryptedId, cartBean.shipToAddress.country, cartSubAmount);
				}
			return Decimal.valueOf(cartBean.shipAmount != null ? cartBean.shipAmount : 0.0).setScale(2);
		}
		set;
	}

	public Double cartSubAmount {
		get {
			Double sub = cartAPI.getCartTotal(cartBean.sfid);
			if(sub != null) {
				cartSubAmount = Decimal.valueOf(sub).setScale(2);
			}
			return cartSubAmount;
		}
		set;
	}
	
	public cc_api_Cart cartAPI{
		get{
			if(cartAPI == null)
				cartAPI = new cc_api_Cart();
			return cartAPI;
		}
		set;
	}

	public Boolean installmentsAvailable {get;set;}
	public Decimal totalInstallmentPrice {get;set;}
	public Decimal dueTodayPrice {get;set;}
	public Decimal discounts {get;set;}

	//==================================================
	// CONSTRUCTOR
	//==================================================
	public cc_ctrl_Cart() {
		super();
		couponDiscountAmount = 0;
		this.continueHistoryCount = 1;
		initParam();
		Cookie cartIdCookie = new Cookie('currentCartId',currentCartID,null,-1,false);
		ApexPages.currentPage().setCookies(new Cookie[]{cartIdCookie});
		cartItemList = getCartItems();
		//IB Fee fix
		if(al.StringUtils.isBlank(cartCurrency))
			cartCurrency = cartBean.currencyCode;
		if(al.StringUtils.isBlank(cartCurrency))
			cartCurrency = 'USD';
        if(IBFeeUtil != null && al.StringUtils.isBlank(IBFeeSKU)){
            if(cartSBUCode!=null){//Validation added - jcruz June30
				IBFeeSKU = IBFeeUtil.getMatchingIBFeeSKU(cartSBUCode,cartCurrency);
            }
        }
		processInstallmentsForHeaderLevel();
		cc_kap_utils_AppUtils.setCookie('ABPath', 'A');
	}

	public cc_ctrl_Cart(cc_ctrl_ProductDetail c) { this(); }
	public cc_ctrl_Cart(cc_ctrl_Header c) { this(); }
	//==================================================
	// INSTANCE VARIABLES
	//==================================================
	public Boolean displayShippingEstimateMessage = false;
	private List<SelectOption> stateList = null;
	//==================================================
	// HELPER METHODS
	//==================================================
	public cc_ctrl_Cart getCartController() { return this; }
	public String getCurrencyCode(){
		return cc_ctrl_PricingEngine.getCurrencyCode();
	}

	public List<SelectOption> getStateList(){
		return cc_util_Picklist.getAllStateOptionsList();
	}
	public List<SelectOption> getCountryList(){
		return cc_util_Picklist.getCountryOptionsList();
	}

	public List<cc_bean_CartItem> buildCartListViewData2(List<E_CartItem__c> pdl) {
		if (al.ArrayUtils.isEmpty(cartListViewData)) {
			cartHasCouponLineItem = false; // reset
			cartListViewData = new List<cc_bean_CartItem>();

			// Get list of product SKUs and list of ProductIDs
			List<String> skuList = new List<String>();
			Set<String> skuSet = new Set<String>();
			List<Id> productIdList = new List<Id>();

			Set<Id> productIdSet = new Set<Id>();
			Map<Id, E_Product__c> productMap = new Map<Id,E_Product__c>();
			Map<String,Double> skuMap = new Map<String,Double>();
			
			/** Kaplan Phase 1 Begin */
			displayRulesApi = new cc_kap_api_rules_CartRules(pdl);
			displayRulesApi.constructLineData();
			containsShippableItems = displayRulesApi.cartHasSpec(cc_kap_utils_AppConstants.SPEC_SHIPPABLE, '1');
			Set<String> programCodes = displayRulesApi.getSpecValues(cc_kap_utils_AppConstants.SPEC_PROGRAM_CODE);
			List<String> codes = new List<String>();
			if (programCodes != null) {
				codes.addAll(programCodes);
				programCode = codes.get(0);
			}
			/** Kaplan Phase 1 End */

			couponDiscountAmount = 0;
			for(E_CartItem__c pd : pdl){
				skuMap.put(pd.Product__r.SKU__c, pd.Quantity__c);
				skuSet.add(pd.Product__r.sku__c);
				productIdSet.add(pd.Product__r.Id);
				productMap.put(pd.Product__r.id, pd.Product__r);
				for(E_CartItem__c pi : pd.Cart_Items__r) {
					skuMap.put(pi.Product__r.SKU__c, pi.Quantity__c);
					skuSet.add(pi.Product__r.sku__c);
					productIdSet.add(pi.Product__r.Id);
					productMap.put(pi.Product__r.id, pi.Product__r);
					if(pi.AbsoluteDiscount__c != null)
						couponDiscountAmount += pi.AbsoluteDiscount__c;
				}
				if(pd.AbsoluteDiscount__c != null)
					couponDiscountAmount += pd.AbsoluteDiscount__c;
			}
			skuList.addAll(skuSet);
			productIdList.addAll(productIdSet);
			Map<String, cc_bean_PriceInfo> priceLineMap=new Map<String,cc_bean_PriceInfo>();
			cc_dao_ProductMedia productMedia=new cc_dao_ProductMedia();
			Map<Id,cc_bean_MediaWrapper> imageMap=productMedia.getProductThumbnailMedia(productIdList);

			Map<String,String> translatedMap = getTranslatedProductNames(skuList);
			cc_dao_ProductMedia pmDAO=new cc_dao_ProductMedia();
			Map<Id,cc_bean_MediaWrapper> thumbnailMap = pmDAO.getProductThumbnailMedia(productIdList);
			boolean evenLine = false;
			for(E_CartItem__c pd : pdl) {
				cc_bean_CartItem currentMajorItem = (assemblyListViewData(
				pd, productIdList,
				priceLineMap,translatedMap, thumbnailMap, evenLine)
				);
				if(pd.Cart_Items__r != null) {
					cc_bean_CartItem cartViewData = null;
					boolean evenSubLine = false;
					for (E_CartItem__c pi : pd.Cart_Items__r) {
						currentMajorItem.minorLines.add(assemblyListViewData(
							pi, productIdList, priceLineMap,translatedMap,
							thumbnailMap, evenSubLine)
						);
						evenSubLine = !evenSubLine;
					}
				}
				/** Kaplan Phase 1 Begin */
				currentMajorItem.dataRulesBean = displayRulesApi.getDisplayRuleBean(pd.Product__r.SKU__c);
				if (currentMajorItem.dataRulesBean != null && currentMajorItem.dataRulesBean.availableInstallments != null) {
					currentMajorItem.totalDiscount = currentMajorItem.dataRulesBean.availableInstallments.get(0).totalDiscount*currentMajorItem.quantity;
					currentMajorItem.totalListPrice = currentMajorItem.dataRulesBean.availableInstallments.get(0).listPrice*currentMajorItem.quantity; 
				}
				if( currentMajorItem.dataRulesBean != null && !al.StringUtils.isEmpty(currentMajorItem.dataRulesBean.sbuCode) )
				{
					cartBean.sbuCode = currentMajorItem.dataRulesBean.sbuCode;
					cartSBUCode = currentMajorItem.dataRulesBean.sbuCode;
				}

				/** Kaplan Phase 1 End */
				

				/************* CASE # 1732 - Begin ************/

				List<E_CartItem__c> cartItem = new List<E_CartItem__c>();
				cartItem.add(pd);
				cc_kap_api_rules_CartRules cartRulesAPI = new cc_kap_api_rules_CartRules(cartItem);
				Set<String> kbsProgramCodeSet = displayRulesApi.getSpecValues(cc_kap_utils_AppConstants.SPEC_KBS_PROGRAM_CODE);
				List<String> kbsProgramCodeList = new List<String>(); 
				if(kbsProgramCodeSet != null){
					kbsProgramCodeList.addAll(kbsProgramCodeSet);
					currentMajorItem.kbsProgramCode = kbsProgramCodeList.get(0);
					
					// Case # 00001814 ----- Begin ----- cw -----  
                    kbsProgramCodes = '';                           
                    kbsProgramCodes = kbsProgramCodeList.get(0);

                    if(kbsProgramCodeList.size() > 1){
                        for(integer i = 1; i <= kbsProgramCodeList.size() - 1; i++){
                            kbsProgramCodes = kbsProgramCodes + ',' + kbsProgramCodeList.get(i);
                        }
                    }         
                    kbsProgramCodes.trim();
                    // Case # 00001814 ----- End ----- cw ----- 
				}				

				/************* CASE # 1732 - End ************/

				cartListViewData.add(currentMajorItem);


				evenLine = !evenLine;
			}
			Integer noOfQueries = Limits.getQueries();
		}

		return cartListViewData;
	}

	private cc_bean_CartItem assemblyListViewData(
		E_CartItem__c thisCartItem, List<Id> productIdList,
		Map<String, cc_bean_PriceInfo> priceLineMap,
		Map<String,String> translatedMap,
		Map<Id,cc_bean_MediaWrapper> thumbnailMap,
		boolean evenLine) 
		{
			cc_bean_CartItem data = new cc_bean_CartItem();
			data.cartItemType = thisCartItem.cartItemType__c;
			if (thisCartItem.ParentCartItem__r != null) {
				data.parentProductType = thisCartItem.ParentCartItem__r.Product__r.ProductType__c;
		}
		data.product = thisCartItem.product__r;
		data.mockProduct = new cc_bean_MockProduct(thisCartItem.product__r);
		data.quantity = thisCartItem.Quantity__c.IntValue();
		data.SubAmount = thisCartItem.SubAmount__c.setScale(2, System.RoundingMode.UP);
		data.displaySubAmount = String.valueOf(data.SubAmount);
		data.price = thisCartItem.Price__c;
		data.absoluteDiscount = thisCartItem.AbsoluteDiscount__c;
		data.percentDiscount = thisCartItem.PercentDiscount__c;
		if (thisCartItem.cartItemType__c == 'Major') {
			if (thisCartItem.Cart_Item_Pricing_Tiers__r != null
				&& thisCartItem.Cart_Item_Pricing_Tiers__r.size() > 1
			) {
				for (E_CartItemPricingTier__c tier
					: thisCartItem.Cart_Item_Pricing_Tiers__r
				) {
					if (tier.Quantity__c != null) {
						data.pricingTiers.add(
							new cc_bean_CartItem.PricingTier(
								tier.Quantity__c.intValue(), tier.Price__c
							)
						);
					}
				}
			}
		} else if (thisCartItem.cartItemType__c == 'Coupon') {
			cartHasCouponLineItem = true;
		}
		data.appliedCoupon = thisCartItem.Coupon__c;
		data.itemID = thisCartItem.Id;
		data.translatedProductName = translatedMap.get(thisCartItem.Product__r.SKU__c);
		if (thumbnailMap.get(thisCartItem.product__r.Id) != null) {
			data.mediaWrapper = new cc_bean_MediaWrapper();
			data.mediaWrapper.uri = thumbnailMap.get(
				thisCartItem.product__r.Id
			).uri;
			data.mediaWrapper.sourceType = thumbnailMap.get(
				thisCartItem.product__r.Id
			).sourceType;
		}
		List<Id> singleIDList = new List<Id>();
		singleIDList.add(thisCartItem.product__r.Id);
		data.evenLineNumber = evenLine;
		/** Kaplan Phase 1 Begin */
		data.dataRulesBean = displayRulesApi.getDisplayRuleBean(thisCartItem.Product__r.SKU__c);
		if (data.dataRulesBean != null && data.dataRulesBean.availableInstallments != null) {
			data.totalDiscount = data.dataRulesBean.availableInstallments.get(0).totalDiscount*data.quantity;
			data.totalListPrice = data.dataRulesBean.availableInstallments.get(0).listPrice*data.quantity;
		}
		/** Kaplan Phase 1 End */
		return data;
	}

	private Map<String,String> getTranslatedProductNames(List<String> skus){
		Map<String,String> ans = new Map<String,String>();
	
		List<E_Product__c> products =
			[Select Sku__c,(Select Name From Product_Item_I18Ns__r) From E_Product__c Where Sku__c=:skus];
	
		String translatedName = null;
		for(E_Product__c product : products){
			translatedName = null;
			for(E_ProductItemI18N__c item : product.Product_Item_I18Ns__r){
			translatedName = item.Name;
			}
			ans.put(product.Sku__c,translatedName);
		}
		return ans;
	}

	public E_Cart__c getCurrentCart(){
		return (new cc_api_Cart()).retrieveCart(this.currentCartID);
	}

	//==================================================
	// SERVICE METHODS
	//==================================================
	public PageReference removeItemFromCartPage() {
		removeItemFromCart();
		return null;
	}


	public void initParam() {
		String skuCountStr=ApexPages.currentPage().getParameters().get('skuTextCount');
		String cartContainsProduct = ApexPages.currentPage().getParameters().get('cartContainsProduct');
		exceptionMessage=' Invalid SKU(s)';
		exceptionFlag=false;
		notOrdProdExist=false;
		if(skuCountStr != null && skuCountStr!= '0'){
			exceptionFlag=true;
			Integer skuCount=Integer.valueOf(skuCountStr);
			Integer skuIndex=0;
			for(skuIndex=0;skuIndex<skuCount;skuIndex++){
				Integer queryParamIndex=skuIndex+1;
				String sku=Apexpages.currentPage().getParameters().get('sku'+queryParamIndex);
				exceptionMessage+=' ' + sku;
			}
			//exceptionMessage+=' not added to cart.';
			exceptionMessage='Hmm…we can\'t find this class online. Either it\'s not in our system or no longer available. To check, call 1-800-KAP-TEST, and one of our enrollment counselors will be happy to help.';
		}
		//END : CHECK FOR BULK ITEM ERROR SKUS
		else if(cartContainsProduct != null && 'true'.equals(cartContainsProduct)){
			exceptionMessage='You\'ve already added that item to your cart.';
			exceptionFlag = true;
		}
		//START: CHECK FOR NOT ORDERABLE ITEMS
		String notOrdskuCount=ApexPages.currentPage().getParameters().get('notOrdskuCount');
		notOrdProdMessage='';

		if(notOrdskuCount != null && notOrdskuCount!= '0'){
			notOrdProdMessage=' Invalid SKU(s)';
			notOrdProdExist=true;
			Integer notOrdskuCnt=Integer.valueOf(notOrdskuCount);
			Integer skuIndex=0;
			for(skuIndex=0;skuIndex<notOrdskuCnt;skuIndex++){
				Integer queryParamIndex=skuIndex+1;
				String sku=Apexpages.currentPage().getParameters().get('notOrdsku'+queryParamIndex);
				notOrdProdMessage+=' ' + sku;
			}
			notOrdProdMessage+=' not added to cart.';
		}
		//END : CHECK FOR NOT ORDERABLE ITEMS
		/** Kaplan Phase 1 Begin */
		String miscError = ApexPages.currentPage().getParameters().get('miscError');
		if (!al.StringUtils.isBlank(miscError)) {
				if (!al.StringUtils.isBlank(notOrdProdMessage))
					notOrdProdMessage += '\r\n';
				notOrdProdMessage += miscError;
				notOrdProdExist = true;
		}

		/** Kaplan Phase 1 End */
		currentCartID=ApexPages.currentPage().getParameters().get('cartID');
		String tempID=ApexPages.currentPage().getParameters().get('productID');
		if(tempID == null){
			currentProductID=null;
		}
		else if(!(tempID.equals('') || tempID.equals('null'))){
			currentProductID=tempID;
		}
		qty=1;
		E_Cart__c currentCart = getCurrentCart();
		//JLL 3/25/2014 IBFee reintroduction
		this.cart = currentCart;
		this.cartBean = new cc_bean_Cart(cart);
		
		if(al.StringUtils.isNotBlank(currentCartID) && !currentCartID.equalsIgnoreCase('NULL')) {
			cartItemList = getCartItems();
		}
		updateCouponInfo();

		this.currentCartOwnerID = currentCart == null ? null: currentCart.Owner.ID;
		if(currentCart != null){
			if(cc_util_CloudCraze.isGuest() && currentCart.OwnerID != cc_api_User.getCurrentUser.Id)
			{
				cartItemList = null;
			}
			cartName = currentCart.Name__c;
			cartComments = currentCart.Note__c;
			cartOwnerEmail = currentCart.Owner.Email;
			/** Kaplan Phase 1 Begin */
			cartCurrency = currentCart.CurrencyISOCode__c;
			cartCustomerType = currentCart.CustomerTypeCode__c;
			/** Kaplan Phase 1 End */
		}
		String continueHistoryCountStr=ApexPages.currentPage().getParameters().get('continueHistoryCount'); 
		if(continueHistoryCountStr != null){
			continueHistoryCount = Integer.valueOf(continueHistoryCountStr);
		}
	}

	public void getWishListForCurrentUser(){
		if (al.StringUtils.isEmpty(this.currentWishListID)) {
			List<E_Cart__c> wishListLists = [Select
											e.Pay_in_Installments__c,
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
			if(wishListLists == null || wishListLists.size()==0){
				this.currentWishListID = '';
			}else{
				this.currentWishListID	= wishListLists[0].id;
			}
			Integer noOfQueries = Limits.getQueries();
		}
	}

	public List<cc_bean_MiniCartViewItem> getMiniCartItems() {
		List<cc_bean_MiniCartViewItem> viewList = new List<cc_bean_MiniCartViewItem>();

		cc_api_Cart api = new cc_api_Cart();
		List<E_CartItem__c> items = api.getCartItems(currentCartID, 3);

		if(items != null && items.size() > 0) {
			List<Id> productIdList = new List<Id>();

			for(E_CartItem__c item : items) {
				productIdList.add(item.Product__c);
			}

		cc_dao_ProductMedia pmDAO=new cc_dao_ProductMedia();
		Map<Id,cc_bean_MediaWrapper> thumbnailMap = pmDAO.getProductThumbnailMedia(productIdList);

			for(E_CartItem__c item : items) {
				cc_bean_MiniCartViewItem viewItem = new cc_bean_MiniCartViewItem();
				viewItem.item = item;
				viewList.add(viewItem);
			}
		}
		Integer noOfQueries = Limits.getQueries();
		return viewList;
	}

	public	List<E_CartItem__c> getCartItems() {
		if(currentCartID == null)
			return null;
		this.validInventory = true;
		cc_api_Cart api = new cc_api_Cart();
		cartItemList = cc_dao_cart.getDisplayCartItems(currentCartID);
		if(cartItemList != null	&& cartItemList.size()> 0){
			this.cartListViewData = buildCartListViewData2(cartItemList);
			List<cc_bean_CartItem> cartListViewDatatemp = new List<cc_bean_CartItem>();
			List<cc_bean_CartItem> cartListViewDatasorted = new List<cc_bean_CartItem>();
			cc_bean_CartItem cartItemTemp;
			if(this.cartListViewData != null){
				cartListViewDatatemp = 	this.cartListViewData;
				for(cc_bean_CartItem cartItem: cartListViewDatatemp){
					if(cartItem.dataRulesBean == null || !cartItem.dataRulesBean.IBFee){
						cartListViewDatasorted.add (cartItem);
					}else{
						cartItemTemp = cartItem;
					}
				}
				if(cartItemTemp != null){
					cartListViewDatasorted.add(cartItemTemp);
				}
				this.cartListViewData.clear();
				this.cartListViewData.addall(cartListViewDatasorted);
			}	
		}

		Integer noOfQueries = Limits.getQueries();
		return cartItemList;
	}



	public Integer getCartItemCount()
		{
			cc_api_Cart api = new cc_api_Cart();
			Integer cicount = api.getCartItemCount(currentCartID);
			return cicount;
		}


	public PageReference addToMyCart()
	{
		return null;
	}

	public PageReference addToCart() {
		cc_api_Cart cc_api_Cart = new cc_api_Cart();
		this.currentCartID = cc_api_Cart.addToCart(currentProductID, currentCartID, qty, null);

		if(showUpsell){
			showUpsell = false;
			relatedProducts = null;

		}else {
			List<cc_bean_ProductListViewData> productList = cc_api_Cart.getRelatedProducts(currentProductID);

			if(productList != null && productList.size() > 0){
				relatedProducts = productList;
				showUpsell = true;
			}
		}


		PageReference page = System.Page.Cart;
		page.getParameters().put('cartID', currentCartID);
		page.getParameters().put('productID', currentProductID);
		page.getParameters().put('viewState','CartView');
		page.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, ipAddressLocation);
		page.setRedirect(true);

		return page;
	}

	public PageReference updateCart(){
		if (initProcessing) {
			initProcessing = false;
			return null;
		} 
		
		if(cartItemList == null || cartItemList.size() < 1){
			if(cc_util_CloudCraze.isGuest() && currentCartOwnerID != cc_api_User.getCurrentUser.Id)
				currentCartID = (new cc_api_Cart()).createEmptyCart().ID;
			cartItemList = getCartItems();
		}
		Map<String, String> maxOutMap = new Map<String, String>();
		if(cartItemList != null && cartItemList.size() > 0){

			Map<String, Double> quantityMap = new Map<String, Double>();
			for(cc_bean_CartItem wishListItem: cartListViewData){
				if(storefront.InventoryCheckFlag__c && wishListItem.productInventory != null && wishListItem.productInventory < wishListItem.quantity)
				{
					wishListItem.quantity = wishListItem.productInventory.intValue();
					maxOutMap.put(wishListItem.product.ID, 'true');
				}
				quantityMap.put(wishListItem.product.ID, wishListItem.quantity);
			}
			for(E_CartItem__c thisCartItem : cartItemList){
				thisCartItem.AbsoluteDiscount__c = null;
				thisCartItem.PercentDiscount__c = null;
				Double qty = quantityMap.get(thisCartItem.Product__c);
					if(qty != 0){
						thisCartItem.Quantity__c = qty;
					}
			}

		}
		cc_api_Cart cc_api_Cart = new cc_api_Cart();
		cc_api_Cart.updateCart(cartItemList, cartCurrency, cartCustomerType);

		cartListViewData = null;
		cartItemList = getCartItems();
		if(cartListViewData != null){
			for(cc_bean_CartItem wishListItem: cartListViewData){
				if(maxOutMap.get(wishListItem.product.ID) != null)
					wishListItem.displayMaxOutMessage = true;
			}
		}
		couponName = null;
		couponId = null;
		updateCouponInfo();
		programCode = '';
		return null;
	}

	public PageReference editCart() {
		PageReference page = System.Page.Cart; //new PageReference('/apex/Cart');
		page.getParameters().put('cartID', currentCartID);
		page.getParameters().put('productID', currentProductID);
		page.getParameters().put('viewState','CartView');
		page.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, ipAddressLocation);
		page.setRedirect(true);
		return page;
	}
	
	public PageReference mergeCart() {
		cc_api_Cart api = new cc_api_Cart();
		if(('true'.equals(ApexPages.currentPage().getParameters().get('doLogin'))) && (ApexPages.currentPage().getParameters().get('anonymousCartID') != null))
		{
			removeAnonymousCartCookie = 'false';
			if(anonymousCartID != null)
			{
				//need to merge anonymous cart with user's last modified open cart
				E_Cart__c cart = cc_api_Cart.getLastModifiedValidCart(UserInfo.getuserId());
				String targetID = null;
				if(cart != null)
				{
					targetID = cart.Id;
				}

				currentCartID = api.mergeCart(anonymousCartID, targetID);
			}
			else
			{
				E_Cart__c cart = cc_api_Cart.getLastModifiedValidCart(UserInfo.getuserId());
				if(cart != null)
				{
					currentCartID = cart.Id;
				}
				else
				{
					currentCartID = null;
				}
			}
			removeAnonymousCartCookie = 'true';
		}

	return null;
	}


	public void updateCouponInfo(){
		String relation='';
		couponName = null;
		couponId = null;
		this.coupon = null;
		requiredSKU = null;
		applyToAll = false;
				if(al.StringUtils.isNotEmpty(currentCartID)){
					cc_api_Cart cc_api_Cart = new cc_api_Cart();

					E_Cart__c cart = cc_api_Cart.retrieveCart(currentCartID);


			if(cart != null){
				List<E_CartCoupon__c> cartCoupons = cc_api_Cart.getCartCoupons(cart.ID);
				if(cartCoupons != null){
					if(cartCoupons.size()>0){
						couponCode = cartCoupons.get(0).Coupon__r.CouponCode__c;
						this.coupon = cc_api_Cart.getCoupon(couponCode);
					}
				}
			}
			// If it's sku-related, add the sku
			// Else if it's an absolute, non-sku related, set sku to NONE
			// Else set sku to all
			if(this.coupon!=null){
				couponName = coupon.Rule__r.Name__c;
				couponId = coupon.Id;
				couponCode = coupon.CouponCode__c;
				relation = coupon.Rule__r.Relation__c;
				if(cc_cnst_PickListConstants.RULERELATION_SKU.equalsIgnoreCase(coupon.Rule__r.Relation__c)){
					List<E_RuleTargetSKU__c> ruleTargetSKU = [select e.Product__c,e.RuleTargetSKUID__c
															from E_RuleTargetSKU__c e
															where e.Rule__c = :coupon.Rule__c LIMIT 1];
					if(ruleTargetSKU != null && ruleTargetSKU.size() > 0){
						requiredSKU = ruleTargetSKU.get(0).Product__c;
						applyToAll = false;
					}
				} else if (cc_cnst_PickListConstants.RULERELATION_SPEC.equalsIgnoreCase(coupon.Rule__r.Relation__c)){
					applyToAll = false;
				}else if(coupon.DiscountType__c == 'Absolute'){
					requiredSKU = couponCode;
					applyToAll = true;
				}else {
					applyToAll = true;
				}
			}
		}
	}


	public void selectCoupon(){
		couponCode = selectedCoupon;
		addCoupon();
	}

	public PageReference addCoupon(){
		String viewState = 'CartView';
		Boolean useNewCoupon = false;
		cc_api_Cart cc_api_Cart = new cc_api_Cart();
		E_Cart__c cart = cc_api_Cart.retrieveCart(currentCartID);
		couponMessage = null;
		couponList.clear();

		if(selectedCoupon != null){
			// Assign the selected coupon
			useNewCoupon = true;
		}

		if(cartItemList == null || cartItemList.size() < 1){
		cartItemList = getCartItems();
		}

		if(cartItemList != null && cartItemList.size() > 0){
			Map<String, Double> quantityMap = new Map<String, Double>();
			for(cc_bean_CartItem wishListItem: cartListViewData){
				quantityMap.put(wishListItem.product.ID, wishListItem.quantity);
			}
			for(E_CartItem__c thisCartItem : cartItemList){
				Double qty = quantityMap.get(thisCartItem.Product__c);
					thisCartItem.Quantity__c = qty;
			}

		}

		//System.debug(LoggingLevel.INFO, 'JLLLLLL - ' + couponCode);
		//System.debug(LoggingLevel.INFO, 'JLLLLLL - ' + cartItemList);
		//System.debug(LoggingLevel.INFO, 'JLLLLLL - ' + useNewCoupon);
		couponMessage = cc_api_Cart.addCoupon(cart, couponCode, cartItemList,useNewCoupon);
		//System.debug(LoggingLevel.INFO, 'JLLLLLL - ' + couponMessage);
		// initialize attributes
		selectedCoupon = null;
		couponList.clear();

		E_Coupon__c coupon = cc_api_Cart.getCoupon(couponCode);
		if('SelectCoupon'.equals(couponMessage)){
			// Warn the user and ask which coupon to use
			List<E_CartCoupon__c> cartCoupons = cc_api_Cart.getCartCoupons(cart.ID);
			couponMessage = 'Only one coupon per cart may be used.';

			// Issue# 104 - changed name to code
			//couponList.add(new SelectOption(cartCoupons[0].Coupon__r.CouponCode__c, cartCoupons[0].Coupon__r.Rule__r.Name__c));
			//couponList.add(new SelectOption(coupon.CouponCode__c,coupon.Rule__r.Name__c));
			couponList.add(new SelectOption(cartCoupons[0].Coupon__r.CouponCode__c, cartCoupons[0].Coupon__r.CouponCode__c));
			couponList.add(new SelectOption(coupon.CouponCode__c, coupon.CouponCode__c));
		}else {
			if('Success'.equals(couponMessage)){
				//couponMessage set in component
				couponMessage = '';
			}else if('CouponAlreadyAdded'.equals(couponMessage)){
				couponMessage = 'The coupon entered is already in your cart.';
			}else if ('InvalidCoupon'.equals(couponMessage)){
				couponMessage = 'We\'re sorry! This code is invalid or has expired.';

			}else if ('MinAmountNotMet'.equals(couponMessage)){
				couponMessage = 'Your cart total is not high enough for this coupon.';
			}else if ('MissingRequiredSKU'.equals(couponMessage)){
				couponMessage = 'The product required for this coupon is not in your cart.';
			}else if ('MinQuantityNotMet'.equals(couponMessage)){
				couponMessage = 'Your cart quantity is not high enough for this coupon.';
			}

			// Get the updated list
			cartListViewData = null;
			cartItemList = getCartItems();
			couponName = null;
			couponId = null;
			updateCouponInfo();
			processInstallmentsForHeaderLevel();
		}
		return null;
	}

	public void removeItemFromCart() {
		String removeItemId = ApexPages.currentPage().getParameters().get('removeItemId');
		if(removeItemId != null) {
			removeItemFromCart(removeItemId);
		} else {
			String removeProductId = ApexPages.currentPage().getParameters().get('removeProductId');
			if(removeProductId != null) {
				removeProductFromCart(removeProductId);
			}
		}
	}

	public PageReference removeCrossSellCartItem() {
		E_CartItem__c ci = new E_CartItem__c(Id = removeCartItemId);
		delete ci;
		//IB Fee fix
		if(al.StringUtils.isBlank(cartCurrency))
			cartCurrency = cartBean.currencyCode;
		if(al.StringUtils.isBlank(cartCurrency))
			cartCurrency = 'USD';
		if(IBFeeUtil != null && al.StringUtils.isBlank(IBFeeSKU))
			IBFeeSKU = IBFeeUtil.getMatchingIBFeeSKU(cartSBUCode,cartCurrency);
		return null;
	}

	public PageReference removeCartItem() {
		this.continueHistoryCount++;
		if (cartItemList == null || cartItemList.size() < 1) {
			cartItemList = getCartItems();
		}
		Integer remainingItemsCount = 0;
		boolean isCoupon = false;
		Id couponCartId = null;
		if (cartItemList != null && cartItemList.size() > 0) {
			Map<String, Double> quantityMap = new Map<String, Double>();
			for (E_CartItem__c thisCartItem : cartItemList) {
				if (thisCartItem.id == removeCartItemId) {
					thisCartItem.Quantity__c = 0;
					if ('Coupon' == thisCartItem.cartItemType__c) {
						isCoupon = true;
						couponCartId = thisCartItem.Cart__c;
					}
				}
				else if ('Coupon' != thisCartItem.cartItemType__c)
					remainingItemsCount++;
			}
		}
		cc_api_Cart cc_api_Cart = new cc_api_Cart();
		if (isCoupon){
			cc_api_Cart.removeCoupon(couponCartId, cartItemList, true);
		}
		else{
			if(cart.Pay_in_Installments__c)
				removeIBFee();
			cc_api_Cart.updateCart(cartItemList, cartCurrency, cartCustomerType);
		}
		
		if (remainingItemsCount == 0) {
			E_Cart__c currentCart = getCurrentCart();
			currentCart.CurrencyISOCode__c = null;
			currentCart.CustomerTypeCode__c = null;
			update currentCart;
		}

		// Get the updated list
		cartListViewData = null;
		cartItemList = getCartItems();
		couponName = null;
		couponId = null;
		updateCouponInfo();
		/** Kaplan Phase 1 Begin */
		PageReference page = System.Page.Cart;
		page.getParameters().put('cartID', currentCartID);
		page.getParameters().put('productID', currentProductID);
		page.getParameters().put('viewState','CartView');
		page.getParameters().put('store', storeID);
		page.getParameters().put('continueHistoryCount', String.valueOf(continueHistoryCount));
		page.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, ipAddressLocation);
		page.setRedirect(true);
		return page;
		//return null;
		/** Kaplan Phase 1 End */
	}


	public void removeItemFromCart(Id itemId) {
		cc_api_Cart capi = new cc_api_Cart();
		capi.deleteItemFromCart(currentCartId, itemId);
	}

	public void removeProductFromCart(Id productId) {
		cc_api_Cart capi = new cc_api_Cart();
		capi.deleteProductFromCart(currentCartId, productId);
	}

	/** Kaplan Phase 1 Begin */
	public PageReference updateCartCheckout() {
		exceptionMessage = '';
		exceptionFlag = false;
		E_Cart__c currentCart = getCurrentCart();
		Map <String, String> lineIDMap = new Map <String, String>() ;		
		for(cc_bean_CartItem pc : cartListViewData){
			List<cc_kap_rules_bean_CartDataInstallPrice> installPriceLstBean = pc.dataRulesBean.availableInstallments;
				if(installPriceLstBean != null && installPriceLstBean.size()>1)
				{
					for(cc_kap_rules_bean_CartDataInstallPrice installment: installPriceLstBean){
						if(installment.installments == 3 && currentCart.Pay_in_Installments__c){
							lineIDMap.put(pc.dataRulesBean.line.Product__r.SKU__c, 'true');
						}
					}
				}
		}
// TO: Prod Fix
//		if (cartItemList == null || cartItemList.size() < 1)
			cartItemList = getCartItems();
		if (cartItemList != null && cartItemList.size() > 0) {
			for (E_CartItem__c line : cartItemList) {
				line.AbsoluteDiscount__c = null;
				line.PercentDiscount__c = null;
				if (lineIDMap.get(line.Product__r.SKU__c) != null)
					line.Billing_Installments__c = 3;
				String flexDateStr = ApexPages.currentPage().getParameters().get('datePicker' + line.Product__r.SKU__c);
				if (flexDateStr != null) {
					if (flexDateStr == '') {
						userMessages = new List<String>();
						userMessages.add(System.Label.Kap_Start_Date_Required + ' ' + line.Product__r.Name + '.	');
						exceptionFlag = true;
					}
					else
						try{
							line.Flex_Date__c = Date.parse(flexDateStr);
						}catch(Exception e){
							userMessages = new List<String>();
							userMessages.add('Invalid date entered for ' + line.Product__r.Name + '.	');
							exceptionFlag = true;
						}
				}
			}
		}
		cc_api_Cart cc_api_Cart = new cc_api_Cart();
		cc_api_Cart.updateCart(cartItemList, cartCurrency, cartCustomerType);
		cc_ctrl_MiniCart ctrlMiniCart = new cc_ctrl_MiniCart();
		if(ctrlMiniCart.cart.due_today__c != null){
			if(ctrlMiniCart.cart.due_today__c != ctrlMiniCart.dueTodayPrice){
				ctrlMiniCart.cart.due_today__c = ctrlMiniCart.dueTodayPrice;
				ctrlMiniCart.cart.second_payment__c = ctrlMiniCart.totalInstallmentPrice;
				ctrlMiniCart.cart.third_payment__c = ctrlMiniCart.totalInstallmentPrice;
				update ctrlMiniCart.cart; 
			}
		}

		
		
		if (exceptionFlag) {
			cartListViewData = null;
			cartItemList = getCartItems();
			return null;
		}
		else if (storefront.Use_SSO_For_Auth__c) {
			PageReference redirectTo = cc_kap_utils_Cart.setupSSORedirect(currentCartID, storefront.PingFederate_URL__c, ipAddressLocationKey);
			return redirectTo;
		}
		else {
			if (UserInfo.getUserType() != 'Guest') {
				PageReference redirectTo = Page.CheckOutNew;
				Map<String, String> params = redirectTo.getParameters();
				params.put('cartID', currentCartID);
				params.put(ipAddressLocationKey, ipAddressLocation);
				params.put('viewState', 'InfoView');
				redirectTo.setRedirect(true);
				return redirectTo;
			}
			else if (Site.isLoginEnabled()) {
				PageReference redirectTo = Page.CCSiteLogin;
				Map<String, String> params = redirectTo.getParameters();
				params.put('cartID', currentCartID);
				params.put(ipAddressLocationKey, ipAddressLocation);
				String startURL = Page.CheckOutNew.getUrl() + '?productId=' + '&viewState=InfoView&store=' + storeID + '&' +	ipAddressLocationKey + '=' + ipAddressLocation + '&cartID=' + currentCartID + '&anonymousCartID=';
				params.put('startURL', startURL);
				redirectTo.setRedirect(true);
				return redirectTo;
			}
			return null;
		}
	}
	/** Kaplan Phase 1 End */

	//JLL IBFee reintroduction 3/25/2014

	public void processInstallmentsForHeaderLevel()
	{
		installmentsAvailable = false;
		if(cartListViewData != null)
		{
			totalInstallmentPrice = 0.0;
			dueTodayPrice = 0.0;
			discounts = 0.0;
			Decimal firstInstallmentPrice = 0.0;
			for(cc_bean_CartItem pc : cartListViewData){
                //Initialize variables properly - jcruz June30
				List<cc_kap_rules_bean_CartDataInstallPrice> installPriceLstBean = new List<cc_kap_rules_bean_CartDataInstallPrice>();
				if(pc.dataRulesBean!=null && pc.dataRulesBean.availableInstallments!=null){
					installPriceLstBean = pc.dataRulesBean.availableInstallments;
				}
                if(pc.totalListPrice==null){
                    pc.totalListPrice = 5000;
                }
                if(pc.totalDiscount==null){
                    pc.totalDiscount = 0;
                }
                if(pc.SubAmount==null){
                    pc.SubAmount = 5000;
                }
                if(pc.cartItemType==null){
                    pc.cartItemType = '';
                }
                if(pc.absoluteDiscount==null){
                    pc.absoluteDiscount = 0;
                }
                //End of Initialization
				if(installPriceLstBean != null && installPriceLstBean.size()>1)
				{
					installmentsAvailable = true;
					for(cc_kap_rules_bean_CartDataInstallPrice installment: installPriceLstBean){
						if(installment.installments == 3){
							totalInstallmentPrice = totalInstallmentPrice + installment.offeredPrice.round(System.RoundingMode.DOWN);
							firstInstallmentPrice = firstInstallmentPrice + installment.offeredPrice.round(System.RoundingMode.DOWN) + Math.mod((installment.discountedPrice).intValue(),3) + (installment.discountedPrice - installment.discountedPrice.round(System.RoundingMode.DOWN));
						}
						else if(installment.installments == 1 && installment.couponDiscount != null){
							discounts = discounts + installment.couponDiscount;
						}
					}		
				}
				else if(pc.cartItemType != 'Coupon')
				{
					if(pc.absoluteDiscount != null)
						dueTodayPrice = dueTodayPrice + (pc.totalListPrice - pc.absoluteDiscount);
					else
						dueTodayPrice = dueTodayPrice + pc.totalListPrice;	
					discounts = discounts + pc.totalDiscount;
				}
				else if(pc.cartItemType == 'Coupon')
				{
					discounts = pc.SubAmount;
				}
			}
			dueTodayPrice = dueTodayPrice + firstInstallmentPrice;
		}
	}
	
	public PageReference addIBFee(){
		if(cart.Pay_in_Installments__c == null || !cart.Pay_in_Installments__c){
			//System.debug(LoggingLevel.INFO, 'HERE 7');
			if(!al.StringUtils.isBlank(IBFeeSKU)){
				//System.debug(LoggingLevel.INFO, 'HERE 8');
				cartAPI.addToCart(IBFeeSKU, ccCartId, 1, cc_util_CloudCraze.isGuest()?true:false, cartCurrency, cart.CustomerTypeCode__c, true, storeID);
			}
			cart.Pay_in_Installments__c = true;
			cartBean.payInInstallments = true;
			cart.due_today__c = dueTodayPrice;
			cart.second_payment__c = totalInstallmentPrice;
			cart.third_payment__c = totalInstallmentPrice;
			update cart;
			cc_kap_utils_Cart.calculateCartTotals(displayRulesApi.cartLines);
			update displayRulesApi.cartLines;
			cartListViewData = null;
			cartItemList = getCartItems();
			processInstallmentsForHeaderLevel();
		}
		return null;
	}
	
	public PageReference removeIBFee(){
		if(cart.Pay_in_Installments__c != null && cart.Pay_in_Installments__c){
			cart.Pay_in_Installments__c = false;
			cartBean.payInInstallments = false;
			cart.due_today__c = null;
			cart.second_payment__c = null;
			cart.third_payment__c = null;
			if (cartItemList != null && cartItemList.size() > 0) {
				for (E_CartItem__c thisCartItem : cartItemList) {
					if(thisCartItem.Product__r != null){
						if(IBFeeSKU != null && IBFeeSKU.equals(thisCartItem.Product__r.SKU__c)){
							thisCartItem.Quantity__c = 0;
						}else{
							thisCartItem.Billing_Installments__c = 1;
							thisCartItem.AmountOwed__c = thisCartItem.SubAmount__c;
						}
					}
				}
				update cartItemList;
				update cart;
				cartAPI.updateCart(cartItemList, cartCurrency, cart.CustomerTypeCode__c);
			}

			cartListViewData = null;
			cartItemList = getCartItems();
			processInstallmentsForHeaderLevel();
		}
		return null;
	}
	
	public PageReference refreshCart()
	{		
		PageReference page = System.Page.Cart;
		page.getParameters().put('cartID', ccCartId);
		page.getParameters().put('productID', currentProductID);
		page.getParameters().put('viewState','CartView');
		page.getParameters().put('store', storeID);
		page.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, ipAddressLocation);
		Page.getParameters().put('couponMessage',couponMessage);
		Page.getParameters().put('successCouponMessage',successCouponMessage);
		page.setRedirect(true);
		return page;
	} 

	public Boolean showDiscounts{
		get {
			if(discounts == null || discounts.intValue() == 0)
				return false;	
			return true;	
		}
		set;
	}
	
	public String PayInFull{
		
		get{
			if(cart.Pay_in_Installments__c){
				System.debug(LoggingLevel.INFO, 'HERE 1');
				return '';
			}
			else{
				System.debug(LoggingLevel.INFO, 'HERE 2');
				return 'checked';
			}
		}
	} 
	
	public String PayInInstallments{
		
		get{
			if(cart.Pay_in_Installments__c)
				return 'checked';
			else
				return '';
		}
	}

}