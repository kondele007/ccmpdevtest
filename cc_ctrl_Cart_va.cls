/**
// * Created by CloudCraze, LLC.
// * Copyright 2010-12 CloudCraze, LLC. All rights reserved
// * @Description: Extension to handle customized related item retrieval.
// * @Author: 1.0
// * @File: cc_kap_extn_RelatedItems
// * =======================================================================================
// * 2012/08/30 1.1 IL -  Refactored
**/
public with sharing class cc_ctrl_Cart_va extends cc_ctrl_CloudCraze {
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
	
	
	public Boolean validInventory {
			get {
				if (cartListViewData != null) {
				  for (cc_bean_CartItem wishListItem : cartListViewData) {
				    this.validInventory &= (!wishListItem.getInventoryLow() && !wishListItem.getExpired());
	              }
				}
				return this.validInventory;
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
    /* START MATT: comment out shipping in cart
    public cc_bean_ShippingOptions fedExShipOptions {get;set;}
    public cc_bean_ShippingOptions upsShipOptions {get;set;}
    END MATT: comment out shipping in cart */
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
            	// total = total.setScale(2, System.RoundingMode.UP);
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
	        	// total = total.setScale(2, System.RoundingMode.UP);
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
	public String couponName {get;set;}
    public E_Coupon__c coupon {get;set;}
    public String requiredSKU {get;set;}
    public Boolean applyToAll {get;set;}
    
    private cc_kap_api_rules_CartRules displayRulesApi {get; set;}
    public String programCode{get; set;}
    public String kbsProgramCodes{get; set;}
    public String productNames{get; set;}

	//==================================================
    // CONSTRUCTOR
    //==================================================
	public cc_ctrl_Cart_va() {
		super();
		this.continueHistoryCount = 1;
	    initParam();
		Cookie cartIdCookie = new Cookie('currentCartId',currentCartID,null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{cartIdCookie});
        cc_kap_utils_AppUtils.setCookie('ABPath', 'B');
	}

	public cc_ctrl_Cart_va(cc_ctrl_ProductDetail c) { this(); }
	public cc_ctrl_Cart_va(cc_ctrl_Header c) { this(); }
	//==================================================
    // INSTANCE VARIABLES
    //==================================================
	public Boolean displayShippingEstimateMessage = false;
	private List<SelectOption> stateList = null;
	/* START MATT: comment out shipping in cart
	private static final cc_hlpr_ShippingOptionComparator SHIPPING_OPTION_SORTER = new cc_hlpr_ShippingOptionComparator();
    private List<cc_ctrl_CheckoutYourInformation.ShippingOption> shipOptionsList =
            new List<cc_ctrl_CheckoutYourInformation.ShippingOption>();
	END MATT: comment out shipping in cart */
	//==================================================
    // HELPER METHODS
    //==================================================
	public cc_ctrl_Cart_va getCartController() { return this; }
	public String getCurrencyCode(){
	    return cc_ctrl_PricingEngine.getCurrencyCode();
	}
	/* START MATT: comment out shipping in cart
	public Boolean getdisplayShippingEstimateMessage(){
	    return this.displayShippingEstimateMessage;
	}
	END MATT: comment out shipping in cart */
	public List<SelectOption> getStateList(){
		/*
	    stateList= new List<SelectOption>();
	    stateList.add(new SelectOption('','Please Select One'));
	    List<StateCode__c> stateCodeList=cc_util_CustomSettings.getStateCodes();
	    for(StateCode__c stateCode:stateCodeList){
	    	stateList.add(new SelectOption(stateCode.Name,stateCode.State__c));
	    }
	    return  stateList;
	    */
	    return cc_util_Picklist.getAllStateOptionsList();
	}
	public List<SelectOption> getCountryList(){/*
	     List<SelectOption> countryList= new List<SelectOption>();
	     countryList.add(new SelectOption('','Please Select One'));
	     List<CountryCode__c> countryCodeList=cc_util_CustomSettings.getCountryCodes();
	     for(CountryCode__c countryCode:countryCodeList){
	        countryList.add(new SelectOption(countryCode.Name,countryCode.Country__c));
	     }
	     return countryList;
	     */
	     return cc_util_Picklist.getCountryOptionsList();
	}
	/* START MATT: comment out shipping in cart
    public List<cc_ctrl_CheckoutYourInformation.ShippingOption> getShipOptionsList(){
        return this.shipOptionsList;
    }
	END MATT: comment out shipping in cart */
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

            for(E_CartItem__c pd : pdl){
            	//System.debug('----pd.Product__r.SKU__c----' + pd.Product__r.SKU__c);
            	//System.debug('---pd---' + pd);
            	//System.debug('---pd.Product__r----' + pd.Product__r);
            	//if(pd.Product__r.SKU__c!=null){
                	skuMap.put(pd.Product__r.SKU__c, pd.Quantity__c);
            	//}
                skuSet.add(pd.Product__r.sku__c);
                productIdSet.add(pd.Product__r.Id);
                productMap.put(pd.Product__r.id, pd.Product__r);
                for(E_CartItem__c pi : pd.Cart_Items__r) {
                	//System.debug('----pi.Product__r.SKU__c----' + pi.Product__r.SKU__c);
                	skuMap.put(pi.Product__r.SKU__c, pi.Quantity__c);
                	skuSet.add(pi.Product__r.sku__c);
                	productIdSet.add(pi.Product__r.Id);
                	productMap.put(pi.Product__r.id, pi.Product__r);
                }
            }
            skuList.addAll(skuSet);
            productIdList.addAll(productIdSet);
            // Get Map<SKU ID, PriceListItem> of prices
            //Map<String, E_PriceListItem__c> priceLineMap = cc_ctrl_PricingEngine.getLowestPriceLineMap(skuList, cc_util_CloudCraze.getAccountID(), null, null, null);
            //System.debug('----skuMap.keyset()-----' + skuMap.keySet());
            //Map<String, cc_bean_PriceInfo> priceLineMap = cc_ctrl_PricingEngine.getPriceMap(skuMap, cc_util_CloudCraze.getAccountID(), null, null, null);
            Map<String, cc_bean_PriceInfo> priceLineMap=new Map<String,cc_bean_PriceInfo>();
            //System.debug('----priceLineMap-------' + priceLineMap);

            // Map<Id,Id> thumbnailMap = cc_dao_ProductMedia.getAttachmentsForProductList(productIdList, cc_cnst_CloudCraze.ATTACHMENTS_THUMBNAIL_IMAGE_SOQL_PATTERN);

            cc_dao_ProductMedia productMedia=new cc_dao_ProductMedia();
            Map<Id,cc_bean_MediaWrapper> imageMap=productMedia.getProductThumbnailMedia(productIdList);

            Map<String,String> translatedMap = getTranslatedProductNames(skuList);
            cc_dao_ProductMedia pmDAO=new cc_dao_ProductMedia();
			Map<Id,cc_bean_MediaWrapper> thumbnailMap = pmDAO.getProductThumbnailMedia(productIdList);
            //system.debug('pdl in cart extension'+pdl);
            //jll keeping track of even vs. odd lines, also redoing how minor lines are done
            boolean evenLine = false;

            // Case # 00001814 ----- Begin ----- cw ----- 
            productNames = pdl.get(0).Product__r.Name;

            for(integer i = 1; i < pdl.size(); i++){
                productNames = productNames + ', ' + pdl.get(i).Product__r.Name;
            }
            // Case # 00001814 ----- End ----- cw ----- 

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
            //system.debug('----Limits.getQueries()-cc_ctrl_Cart.buildCartListViewData---- : ' + noOfQueries);
            }
        //system.debug('cartListView Data'+cartListViewData);

        return cartListViewData;
    }

    private cc_bean_CartItem assemblyListViewData(
        E_CartItem__c thisCartItem, List<Id> productIdList,
        Map<String, cc_bean_PriceInfo> priceLineMap,
        Map<String,String> translatedMap,
        Map<Id,cc_bean_MediaWrapper> thumbnailMap,
        boolean evenLine
    ) {
        cc_bean_CartItem data = new cc_bean_CartItem();
        data.cartItemType = thisCartItem.cartItemType__c;
        if (thisCartItem.ParentCartItem__r != null) {
        	data.parentProductType = thisCartItem.ParentCartItem__r.Product__r.ProductType__c;
        }
        data.product = thisCartItem.product__r;
        data.mockProduct = new cc_bean_MockProduct(thisCartItem.product__r);
        /*
        if (data.product != null) {
            data.priceBean = priceLineMap.get(thisCartItem.product__r.SKU__c);
            data.priceListItem = data.priceBean.priceListItem;
        }
        */
        data.quantity = thisCartItem.Quantity__c.IntValue();
        data.SubAmount = thisCartItem.SubAmount__c.setScale(
            2, System.RoundingMode.UP
        );
        //System.debug('sns-->data.SubAmount = ' + data.SubAmount);
        /*
        data.displaySubAmount = cc_ctrl_PricingEngine.getCurrencyCode()
            + ' ' + String.valueOf(data.SubAmount);
        */
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
        //data.priceFormatter.Currency__c = thisCartItem.Price__c;
        //data.subAmountFormatter.Currency__c = data.SubAmount;
        data.translatedProductName = translatedMap.get(thisCartItem.Product__r.SKU__c);
        //Id attId = thumbnailMap.get(pd.Id);
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
        /* valid inventory is always taken from property validInventory, so this is obsolete
        if (storefront.InventoryCheckFlag__c
            && thisCartItem.cartItemType__c != 'Coupon'
        ) {
	        Map<Id, Decimal> qtyMap = cc_api_Inventory.getAvailabilityQty(singleIdList);
	        if (qtyMap.get(thisCartItem.product__r.Id) != null) {
				data.productInventory = qtyMap.get(thisCartItem.product__r.Id);
				if (data.productInventory < data.quantity) {
					this.validInventory = false;
				}
	        }
        } else if( storefront.InventoryCheckFlag__c == false) {
        	// added by ryl for loreal
        	data.productInventory = 1;
        	this.validInventory = true;
        }
        */
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

    // private static final String PAGE_REFERENCE_FULL_URL = '/apexShippingEstimates';
    /* START MATT: comment out shipping in cart
    public String getShipmentEstimate(){
        List<String> shippingCost = new List<String>();
        if(fedExShipOptions!=null && fedExShipOptions.shippingServicesAndCostDetails!=null){
            for(cc_bean_ShippingServicesAndCostDetails cost : fedExShipOptions.shippingServicesAndCostDetails){
                shippingCost.add(cost.shipCost);
            }
        }

        if(upsShipOptions!=null && upsShipOptions.shippingServicesAndCostDetails!=null){
            for(cc_bean_ShippingServicesAndCostDetails cost : upsShipOptions.shippingServicesAndCostDetails){
                shippingCost.add(cost.shipCost);
            }
        }

        if(shippingCost.size()>0){
            return shippingCost[0];
        } else {
            return 'Not Available';
        }
    }

    public List<ShipmentOptionsView> getShipmentOptionsViewList(){
        List<ShipmentOptionsView> options = new List<ShipmentOptionsView>();
         if(fedExShipOptions!=null && fedExShipOptions.shippingServicesAndCostDetails!=null){
            for(cc_bean_ShippingServicesAndCostDetails cost : fedExShipOptions.shippingServicesAndCostDetails){
                options.add(new ShipmentOptionsView('Fedex',cost.shipService,cost.shipCost,cost.currencyCode));
            }
        }

        if(upsShipOptions!=null && upsShipOptions.shippingServicesAndCostDetails!=null){
            for(cc_bean_ShippingServicesAndCostDetails cost : upsShipOptions.shippingServicesAndCostDetails){
                options.add(new ShipmentOptionsView('UPS',cost.shipService,cost.shipCost,cost.currencyCode));
            }
        }
        return options;
    }


       public PageReference findShippingOptions() {
         displayShippingEstimateMessage = false;
         cc_api_Cart cApi = new cc_api_Cart();
         E_Cart__c cart = cApi.retrieveCart(this.currentCartID);
        cc_bean_ShippingOptionsRequest shipOptionsRequest = new cc_bean_ShippingOptionsRequest();
        Long startTime = datetime.now().getTime();

            this.shipOptionsList.clear();
            if (al.StringUtils.isBlank(countryCode) || al.StringUtils.isBlank(stateCode) ||
            al.StringUtils.isBlank(zipCode) || al.StringUtils.isBlank(cart.Id)){
                this.message+=' getShippingOptions -> invalid input ';
            }

            shipOptionsRequest.cartId = cart.Id;
            shipOptionsRequest.recepientZipCode = zipCode;
            shipOptionsRequest.recepientStateCode = stateCode;
            shipOptionsRequest.recepientCountryCode = countryCode;

            cc_api_ShippingAndHandling cc_api_ShippingAndHandling = new cc_api_ShippingAndHandling();
            List<cc_bean_ShippingOptions> beans = cc_api_ShippingAndHandling.getShippingOptionsForCart(shipOptionsRequest);
            //system.debug('-----cc_ctrl_Cart.findShippingOptions-beans : ' + beans);
            if(beans!=null){
                for(cc_bean_ShippingOptions bean:beans){
                    //system.debug('-----cc_ctrl_Cart.findShippingOptions-bean : ' + bean);
                    if(bean.shippingServicesAndCostDetails!=null){
                    for(cc_bean_ShippingServicesAndCostDetails detail: bean.shippingServicesAndCostDetails){
                        //system.debug('-----cc_ctrl_Cart.findShippingOptions-detail : ' + detail);
                        String provider = '';
                        if (bean.shippingProvider.equals(cc_cnst_FedExXMLTag.SHIPPINGPROVIDER)) {
                            provider = 'Fedex';
                        } else if (bean.shippingProvider.equals(cc_cnst_UPSXMLTag.SHIPPINGPROVIDER)) {
                            provider = 'UPS';
                        }
                        if(detail.shipCost!=null){
                            this.shipOptionsList.add(new cc_ctrl_CheckoutYourInformation.ShippingOption(provider, bean.shipVendorId, detail.shipService, Decimal.valueOf(detail.shipCost)));
                        }
                    }
                    }

            }
        }
        if(this.shipOptionsList.size()>1){
             al.ArrayUtils.qsort(this.shipOptionsList,SHIPPING_OPTION_SORTER);
        }
        if (this.shipOptionsList.size()==0){
            displayShippingEstimateMessage = true;
        }
        Long endTime = datetime.now().getTime();
        Long totalTime = endTime - startTime;
        //system.debug('-----Time in cc_ctrl_Cart.findShippingOptions() ----- = ' + totalTime + ' ms');
        return null;
    }
    END MATT: comment out shipping in cart */

	public void initParam() {
	    String skuCountStr=ApexPages.currentPage().getParameters().get('skuTextCount');
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
	        exceptionMessage+=' not added to cart.';
	    }
	    //END : CHECK FOR BULK ITEM ERROR SKUS

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
	    //if(!bulkItemInvoked){
	       currentCartID=ApexPages.currentPage().getParameters().get('cartID');
	    //}
	    //System.debug('roy---- initParam - setting currentCartID = tttt');
	    //System.debug('---- initParam - setting currentCartID = ' + currentCartID + ' -----');
	    String tempID=ApexPages.currentPage().getParameters().get('productID');
	    if(tempID == null){
	        currentProductID=null;
	    }
	    else if(!(tempID.equals('') || tempID.equals('null'))){
	        //system.debug('--------Entering not null condition----------');
	        currentProductID=tempID;
	    }
	    qty=1;
	    //getWishListForCurrentUser();

		 if(al.StringUtils.isNotBlank(currentCartID) && !currentCartID.equalsIgnoreCase('NULL')) {
		    cartItemList = getCartItems();
		    //(new cc_api_Cart()).updateCart(cartItemList);
		 }
		 updateCouponInfo();

		 E_Cart__c currentCart = getCurrentCart();
		 //System.debug('JLL HERE --- ' + currentCart);
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
        //system.debug('-----Enter cc_ctrl_Cart.getWishListForCurrentUser()-----');
        if (al.StringUtils.isEmpty(this.currentWishListID)) {
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
            if(wishListLists == null || wishListLists.size()==0){
                this.currentWishListID = '';
            }else{
                this.currentWishListID  = wishListLists[0].id;
            }
            Integer noOfQueries = Limits.getQueries();
            //system.debug('----Limits.getQueries()-cc_ctrl_Cart.getWishListForCurrentUser---- : ' + noOfQueries);
        }
        //system.debug('-----cc_ctrl_Cart.getWishListForCurrentUser()-this.currentWishListID----- : ' + this.currentWishListID);
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

	        // get thumbnails
	       // Map<Id,Id> thumbnailMap = cc_dao_ProductMedia.getAttachmentsForProductList(productIdList, cc_cnst_CloudCraze.ATTACHMENTS_THUMBNAIL_IMAGE_SOQL_PATTERN);
	       cc_dao_ProductMedia pmDAO=new cc_dao_ProductMedia();
	       Map<Id,cc_bean_MediaWrapper> thumbnailMap = pmDAO.getProductThumbnailMedia(productIdList);

	        for(E_CartItem__c item : items) {
	            cc_bean_MiniCartViewItem viewItem = new cc_bean_MiniCartViewItem();
	            viewItem.item = item;
	            //System.debug('----item.Product__c----' + item.Product__c);
	            //System.debug('----viewItem.cc_bean_MediaWrapper-----' + viewItem.mediaWrapper);
	            //System.debug('----thumbnailMap.get(item.Product__c)-----' + thumbnailMap.get(item.Product__c));

	            //viewItem.thumbnailId = thumbnailMap.get(item.Product__c);
	           // viewItem.cc_bean_MediaWrapper.uri = thumbnailMap.get(item.Product__c).uri;
	          //  viewItem.cc_bean_MediaWrapper.sourceType = thumbnailMap.get(item.Product__c).sourceType;
	            viewList.add(viewItem);
	//          ////System.debug('--- getMiniCartItems - added viewItem: item=' + viewItem.item.Product__r.Sku__c + ', thumbnailId=' + viewItem.thumbnailId);
	        }
	    }
	    Integer noOfQueries = Limits.getQueries();
	    //system.debug('----Limits.getQueries()-cc_ctrl_Cart.getMiniCartItems---- : ' + noOfQueries);
	    return viewList;
	}

	public  List<E_CartItem__c> getCartItems() {
				if(currentCartID == null)
					return null;
				//reset inventory status. buildCartListViewData will set it back to false if needed
				//System.debug('----IN GETCARTITEMS------');
				this.validInventory = true;
	            cc_api_Cart api = new cc_api_Cart();
	            //System.debug('currentCartID####'+currentCartID);


	            //List<E_CartItem__c> cartItemList = api.getCartItems(currentCartID);
	            cartItemList = cc_dao_cart_va.getDisplayCartItems(currentCartID);

	            //System.debug('cartItemList####'+cartItemList);

	            if(cartItemList != null  && cartItemList.size()> 0){
	                      //System.debug('-----cartItemList----' + cartItemList);
	                      this.cartListViewData = buildCartListViewData2(cartItemList);
	                }

	            //System.debug('cartListViewData####'+this.cartListViewData);

	            Integer noOfQueries = Limits.getQueries();
	            //system.debug('----Limits.getQueries()-cc_ctrl_Cart.getCartItems---- : ' + noOfQueries);
	            return cartItemList;
	        }



	 public Integer getCartItemCount()
	    {
	        //system.debug('-----Enter getCartItemCount() - currentCartID : ' + currentCartID);
	        //Integer dmlLimit = Limits.getDMLStatements();
	        //Integer dmlLimitAvailable = Limits.getLimitDMLStatements();
	        //system.debug('-----DML Limit : ' + dmlLimit);
	        //system.debug('-----DML Limit Available : ' + dmlLimitAvailable);
	        cc_api_Cart api = new cc_api_Cart();
	        Integer cicount = api.getCartItemCount(currentCartID);
	        //system.debug('-----cart item count : ' + cicount);
	        //Integer noOfQueries = Limits.getQueries();
	        //system.debug('----Limits.getQueries()-cc_ctrl_Cart.getCartItemCount---- : ' + noOfQueries);
	        return cicount;
	    }



	public PageReference addToMyCart()
	{
		//System.debug('royyyyy----------------------------------------------addToMyCart');
		return null;
	}
	public PageReference addToCart() {
        //System.debug('----------------------------------------------addToCart');
        cc_api_Cart cc_api_Cart = new cc_api_Cart();
        //System.debug('--------------CurrentProductID in addToCart is' + currentProductID);
        this.currentCartID = cc_api_Cart.addToCart(currentProductID, currentCartID, qty, null);


        // If this is a product addition from the upsell page, don't show the upsell again
        if(showUpsell){
            showUpsell = false;
            relatedProducts = null;

        }else {
            // Get related products (upsell items)
            List<cc_bean_ProductListViewData> productList = cc_api_Cart.getRelatedProducts(currentProductID);

            // Set a flag to display the upsell page
            if(productList != null && productList.size() > 0){
                relatedProducts = productList;
                showUpsell = true;
            }
        }


        PageReference page = System.Page.Cart_va; //new PageReference('/apex/Cart');
        page.getParameters().put('cartID', currentCartID);
        page.getParameters().put('productID', currentProductID);
        page.getParameters().put('viewState','CartView');
       // page.getParameters().put('store', storeID);
        page.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, ipAddressLocation);
        page.setRedirect(true);

        return page;
    }

	public PageReference updateCart(){
		if (initProcessing) {
			System.debug('ah initProcessing=true');
			initProcessing = false;
			return null;
		} 
		
		System.debug('--- entering update cart ---');
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
                ////System.debug('---------wishListItem,quantity: ' +  wishListItem.product.ID + ',' +  wishListItem.product.Name + ',' + wishListItem.quantity);
            }
            for(E_CartItem__c thisCartItem : cartItemList){
            	thisCartItem.AbsoluteDiscount__c = null;
            	thisCartItem.PercentDiscount__c = null;
                Double qty = quantityMap.get(thisCartItem.Product__c);
                ////system.debug('Quantity'+qty);
                //if(qty != null && qty != '')
                	if(qty != 0){
                    	thisCartItem.Quantity__c = qty;
                	}
            }

        }
        //system.debug('----------------------------------------------addToCart');
        cc_api_Cart cc_api_Cart = new cc_api_Cart();
        //system.debug('--------------CurrentProductID in updateCart is' + currentProductID);
        System.debug('ah cartItemList in updateCart ' + cartItemList);
        cc_api_Cart.updateCart(cartItemList, cartCurrency, cartCustomerType);

        // Get the updated list
        //commented out by roy for dreamforce demo 2011
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

        //System.debug('cc_ctrl_Cart: updating current cart');

        //Update the E_Cart__c object itself - Used for updating the Carts name per Corning requirement
        //IL - Fixed for CSRF issue
        //IL - Comment out. This is specific to Corning and not part of Base
        //E_Cart__c cart = getCurrentCart();
        //if(cart != null){
        //  cart.Name__c = this.cartName;
        //  cart.Note__c = this.cartComments;
        //  try{
        //	update cart;
        //  }catch(System.DMLException e){
        //  }
        //}
        //IL End
        
        /* 4/25/2013 JLL -- commenting this out to fix cookie issue with program code */
        programCode = '';
        return null;
	}

	public PageReference editCart() {
        //system.debug(' >>> Inside EditCart in cc_ctrl_Cart viewState = ' + viewState);
        //system.debug(' >>> Inside EditCart currentCartID = ' + currentCartID);
        // START LICOR
        PageReference page = System.Page.Cart_va; //new PageReference('/apex/Cart');
        // END LICOR
        page.getParameters().put('cartID', currentCartID);
        page.getParameters().put('productID', currentProductID);
        page.getParameters().put('viewState','CartView');
       // page.getParameters().put('store', storeID);
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
        //system.debug('-----------------------currentCartID: ##' + currentCartID + '##');
        couponName = null;
        couponId = null;
        this.coupon = null;
        requiredSKU = null;
        applyToAll = false;
                if(al.StringUtils.isNotEmpty(currentCartID)){
                    //system.debug('--------updateCouponInfo - currentCartID: \'' + currentCartID + '\'');
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
//                      requiredSKU = ruleTargetSKU.get(0).RuleTargetSKUID__c;
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
        Integer noOfQueries = Limits.getQueries();
        //System.debug('----Limits.getQueries()-CartExtensions.updateCouponInfo---- : ' + noOfQueries);
        //System.debug('-------------- updateCouponInfo relation: ' + relation);
        //System.debug('-------------- updateCouponInfo requiredSKU: ' + requiredSKU);
        //System.debug('-------------- updateCouponInfo couponName: ' + couponName);
        //System.debug('-------------- updateCouponInfo applyToAll: ' + applyToAll);
        //System.debug('-------------- updateCouponInfo coupon: ' + coupon);
    }


    public void selectCoupon(){
        couponCode = selectedCoupon;
        addCoupon();
    }

    public void addCoupon(){
        //system.debug('----------------------------------------------addToCart');
        String viewState = 'CartView';
        Boolean useNewCoupon = false;
        cc_api_Cart cc_api_Cart = new cc_api_Cart();
        E_Cart__c cart = cc_api_Cart.retrieveCart(currentCartID);
        couponMessage = null;
        couponList.clear();

        //system.debug('----------------------------------------------cc_api_Cart.addToCart');
        if(selectedCoupon != null){
            // Assign the selected coupon
            useNewCoupon = true;
        }

        if(cartItemList == null || cartItemList.size() < 1){
           cartItemList = getCartItems();
        }

        if(cartItemList != null && cartItemList.size() > 0){
            //System.debug('---------Updating cartItemList');
            Map<String, Double> quantityMap = new Map<String, Double>();
            for(cc_bean_CartItem wishListItem: cartListViewData){
                quantityMap.put(wishListItem.product.ID, wishListItem.quantity);
                //System.debug('---------wishListItem,quantity: ' +  wishListItem.product.ID + ',' +  wishListItem.product.Name + ',' + wishListItem.quantity);
            }
            for(E_CartItem__c thisCartItem : cartItemList){
//                String qty = ApexPages.currentPage().getParameters().get('qtyhdn['+thisCartItem.productId__r.SKU__c+']');
                Double qty = quantityMap.get(thisCartItem.Product__c);
                //System.Debug('Quantity'+qty);
                //if(qty != null && qty != '')
                    thisCartItem.Quantity__c = qty;
                    //System.debug('Updating quantity: ' + qty);
            }

        }

        couponMessage = cc_api_Cart.addCoupon(cart, couponCode, cartItemList,useNewCoupon);
        //system.debug('-----------------couponMessage: ' + couponMessage);

        // initialize attributes
        selectedCoupon = null;
        couponList.clear();

        E_Coupon__c coupon = cc_api_Cart.getCoupon(couponCode);
        if('SelectCoupon'.equals(couponMessage)){
            // Warn the user and ask which coupon to use
            List<E_CartCoupon__c> cartCoupons = cc_api_Cart.getCartCoupons(cart.ID);
            couponMessage = 'Only one coupon per cart may be used.';
            couponList.add(new SelectOption(cartCoupons[0].Coupon__r.CouponCode__c, cartCoupons[0].Coupon__r.Rule__r.Name__c));
            couponList.add(new SelectOption(coupon.CouponCode__c,coupon.Rule__r.Name__c));
        }else {
            if('Success'.equals(couponMessage)){
                couponMessage = 'The coupon has been added to your cart.';
            }else if('CouponAlreadyAdded'.equals(couponMessage)){
                couponMessage = 'The coupon entered is already in your cart.';
            }else if ('InvalidCoupon'.equals(couponMessage)){
                couponMessage = 'The coupon is not valid';

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
        //system.debug('-----------coupon name: ' + couponName);
        }
    }

    /* START MATT: comment out shipping in cart
    public String getShippingEstimation(){

            String addressId = '';

            cc_api_Cart api = new cc_api_Cart();
            E_Cart__c cart =  api.retrieveCart(this.currentCartId);
            //return api.getCartItems(currentCartID);
            if(cart==null){
                return 'Not Available!';
            }

            if(cart.ShipTo__c!=null){
                addressId = cart.ShipTo__c;
            } else if(cart.BillTo__c!=null){
                addressId= cart.ShipTo__c;
            }

            if(!al.StringUtils.isEmpty(addressId)){
                E_ContactAddr__c contAddr = null;

                List<E_ContactAddr__c> contList = [Select e.State__c, e.StateISOCode__c,
                                                          e.PostalCode__c, e.Id,
                                                          e.CountryISOCode__c, e.City__c,
                                                          e.AddressThirdline__c, e.AddressSecondline__c,
                                                          e.AddressFirstline__c
                                                   From E_ContactAddr__c e
                                                   Where e.Id = :addressId];
                if(contList.size()>0){
                    contAddr = contList[0];
                }
                if(contAddr!=null){
                    cc_bean_ShippingOptionsRequest shipOptionsRequest = new cc_bean_ShippingOptionsRequest();
                    if (//al.StringUtils.isNotBlank(contAddr.AddressFirstline__c +contAddr.AddressSecondline__c +contAddr.Address13__c ) &&
                        al.StringUtils.isNotBlank(contAddr.StateISOCode__c) &&
                        al.StringUtils.isNotBlank(contAddr.PostalCode__c) &&
                        al.StringUtils.isNotBlank(contAddr.City__c) &&
                        al.StringUtils.isNotBlank(contAddr.CountryISOCode__c)) {

                        shipOptionsRequest.recepientZipCode = contAddr.PostalCode__c;
                        shipOptionsRequest.recepientStateCode = contAddr.StateISOCode__c;
                        shipOptionsRequest.recepientCountryCode = contAddr.CountryISOCode__c;
                        shipOptionsRequest.cartId = this.currentCartID;

                        cc_api_ShippingAndHandling cc_api_ShippingAndHandling = new cc_api_ShippingAndHandling();
                        List<cc_bean_ShippingOptions> shipOptionsList = cc_api_ShippingAndHandling.getShippingOptionsForCart(shipOptionsRequest);
                        cc_bean_ShippingOptions fedExShipOptions = null;
                        cc_bean_ShippingOptions upsShipOptions = null;
                        //system.debug('-----cc_ctrl_Cart.findShippingOptions-getShippingEstimation : ' + shipOptionsList);
                        for (cc_bean_ShippingOptions cc_bean_ShippingOptions : shipOptionsList) {
                            //system.debug('-----cc_ctrl_Cart.findShippingOptions-getShippingEstimation : ' + cc_bean_ShippingOptions);
                            if (cc_bean_ShippingOptions.shippingProvider.equals(cc_cnst_FedExXMLTag.SHIPPINGPROVIDER)) {
                                fedExShipOptions = cc_bean_ShippingOptions;
                            } else if (cc_bean_ShippingOptions.shippingProvider.equals(cc_cnst_UPSXMLTag.SHIPPINGPROVIDER)) {
                                upsShipOptions = cc_bean_ShippingOptions;
                            }
                        }

                        List<String> shippingCost = new List<String>();
                        if(fedExShipOptions!=null && fedExShipOptions.shippingServicesAndCostDetails!=null){
                            for(cc_bean_ShippingServicesAndCostDetails cost : fedExShipOptions.shippingServicesAndCostDetails){
                                shippingCost.add(cost.shipCost);
                            }
                        }

                        if(upsShipOptions!=null && upsShipOptions.shippingServicesAndCostDetails!=null){
                            for(cc_bean_ShippingServicesAndCostDetails cost : upsShipOptions.shippingServicesAndCostDetails){
                                shippingCost.add(cost.shipCost);
                            }
                        }


                        if(shippingCost.size()>0){
                            return shippingCost[0];
                        }
                    }
                }

            }

            return 'Not Available!';

    }
	END MATT: comment out shipping in cart */

    public void removeItemFromCart() {
        String removeItemId = ApexPages.currentPage().getParameters().get('removeItemId');
        //system.debug('--- removeItemId= ' + removeItemId + ' ---');
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
        if (isCoupon)
        	cc_api_Cart.removeCoupon(couponCartId, cartItemList, true);
        else
            cc_api_Cart.updateCart(cartItemList, cartCurrency, cartCustomerType);
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
        PageReference page = System.Page.Cart_va;
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
        //system.debug('--- removing item ' + itemId + ' from cart ' + currentCartId + ' ---');
        cc_api_Cart capi = new cc_api_Cart();
        capi.deleteItemFromCart(currentCartId, itemId);
    }

    public void removeProductFromCart(Id productId) {
        //system.debug('--- removing product ' + productId + ' from cart ' + currentCartId + ' ---');
        cc_api_Cart capi = new cc_api_Cart();
        capi.deleteProductFromCart(currentCartId, productId);
    }

	/** Kaplan Phase 1 Begin */
	public PageReference updateCartCheckout() {
		exceptionMessage = '';
		exceptionFlag = false;
		if (cartItemList == null || cartItemList.size() < 1)
	        cartItemList = getCartItems();
        if (cartItemList != null && cartItemList.size() > 0) {
            for (E_CartItem__c line : cartItemList) {
            	line.AbsoluteDiscount__c = null;
            	line.PercentDiscount__c = null;
            	String installment = ApexPages.currentPage().getParameters().get('billingOpt' + line.Product__r.SKU__c);
            	if (installment != null)
            		line.Billing_Installments__c = Integer.valueOf(installment);
            	String flexDateStr = ApexPages.currentPage().getParameters().get('datePicker' + line.Product__r.SKU__c);
            	if (flexDateStr != null) {
            		if (flexDateStr == '') {
            			//exceptionMessage += System.Label.Kap_Start_Date_Required + ' ' + line.Product__r.Name + '.  ';
            			if (userMessages == null)
            				userMessages = new List<String>();
            			userMessages.add(System.Label.Kap_Start_Date_Required + ' ' + line.Product__r.Name + '.  ');
	    				exceptionFlag = true;
            		}
            		else
            			line.Flex_Date__c = Date.parse(flexDateStr);
            	}
            }
        }
        cc_api_Cart cc_api_Cart = new cc_api_Cart();
        cc_api_Cart.updateCart(cartItemList, cartCurrency, cartCustomerType);
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
        		String startURL = Page.CheckOutNew.getUrl() + '?productId=' + '&viewState=InfoView&store=' + storeID + '&' +  ipAddressLocationKey + '=' + ipAddressLocation + '&cartID=' + currentCartID + '&anonymousCartID=';
        		params.put('startURL', startURL);
        		redirectTo.setRedirect(true);
        		return redirectTo;
        		//{!$Page.CCSiteLogin}?cartID={!that.currentCartID}&{!that.ipAddressLocationKey}={!that.ipAddressLocation}&startURL={!$Page.CheckOutNew}?productID={!that.currentProductID}%26viewState=InfoView%26store={!that.storeID}%26{!that.ipAddressLocationKey}={!that.ipAddressLocation}%26cartID={!that.currentCartID}%26anonymousCartID='" 
        	}
        	return null;
		}
	}
	/** Kaplan Phase 1 End */

  //==================================================
    // INNER CLASS
    //==================================================
    public with sharing class ShipmentOptionsView{
    	//==================================================
	    // INSTANCE PROPERTIES
	    //==================================================
        public String provider    {get;set;}
        public String description {get;set;}
        public String cost        {get;set;}
        public String currencyCode{get;set;}
        //==================================================
	    // CONSTRUCTOR
	    //==================================================
        public ShipmentOptionsView(String prov, String descr, String c, String curr){
            this.provider       = prov;
            this.description    = descr;
            this.cost           = c;
            this.currencyCode   = curr;
        }
    }
}