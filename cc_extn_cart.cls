public with sharing class cc_extn_cart extends cc_ExtensionBase {
	public cc_extn_cart getCartInfo() { return this; }
	public static final String name = 'Cart';
	public override string getName() {
		return name;
	} 
	public cc_extn_cart getCartExtension() { return this; }
	public String removeAnonymousCartCookie { get; set; }
	public String anonymousCartID {get; set; }
	private List<cc_bean_CartItem> l_cartListViewData = new List<cc_bean_CartItem>();
	public List<cc_bean_CartItem> getCartListViewData() {
		if(l_cartListViewData == null || l_cartListViewData.size() == 0) { // need to reset this when cart change
			if(parentController.CCCartId != null) {
				List<E_CartItem__c> cartItemList = cc_dao_cart.getDisplayCartItems(parentController.CCCartId);
				if(cartItemList != null  && cartItemList.size()> 0){
                      l_cartListViewData = buildCartListViewData2(cartItemList);
	            }   
	                
			}
		}
		return l_cartListViewData;
	}
	public Boolean cartHasCouponLineItem {get;set;}
	//private String ccCartId = null;
	public String couponId {get;set;} //??
	public Boolean applyToAll {get;set;} //??
	public String couponName {get;set;} //??
	public Boolean taxExemptFlag{get;set;} //tax
    public boolean optInSelected {get; set;} //tax
    public boolean optIn2Selected {get; set;}  //tax
    public Double tax {get;set;} //tax
    //public E_Cart__c cart {get;set;} 
    public String poNumber { get; set; }
    public Boolean accountIsTaxExempt{get;set;}
    public cc_bean_MockContactAddress tBillingAddress{get; set;}   
	public cc_bean_MockContactAddress tShippingAddress{get; set;}   
	public String selectedPaymentType {get; set; }
	public cc_ctrl_hlpr_ShippingOption tSelectedShippingOptionObj {get; set; }
    
	
	public override void notify(Object subject, String notificationType, Object notificationValue) {
		if(notificationType.equalsIgnoreCase(cc_cnst_CloudCraze.NT_BillingAddress)) {
			tBillingAddress = (cc_bean_MockContactAddress) notificationValue;
			System.debug('ryl debug-> tBillingAddress=' + tBillingAddress);
			
		} else if(notificationType.equalsIgnoreCase(cc_cnst_CloudCraze.NT_ShippingAddress)) {
			tShippingAddress = (cc_bean_MockContactAddress) notificationValue;
			System.debug('ryl debug-> tShippingAddress=' + tShippingAddress);
			
		} else if(notificationType.equalsIgnoreCase(cc_cnst_CloudCraze.NT_PONumber)) {
			poNumber = (String) notificationValue;
			System.debug('ryl debug-> poNumber=' + poNumber);
			
		} else if(notificationType.equalsIgnoreCase(cc_cnst_CloudCraze.NT_SelectedPaymentType)) {
			selectedPaymentType = (String) notificationValue;
			System.debug('ryl debug-> selectedPaymentType=' + selectedPaymentType);
			
		} else if(notificationType.equalsIgnoreCase(cc_cnst_CloudCraze.NT_SelectedShippingOptionObj)) {
			tSelectedShippingOptionObj = (cc_ctrl_hlpr_ShippingOption) notificationValue;
			
		}
	}
	
	public cc_extn_cart() {
		//ccCartId = getCartId();
	}
	
	
	public cc_extn_cart(cc_ctrl_CloudCraze c) {
		super(c);
		//ccCartId = c.ccCartId;
		Account cartAccount = [Select TaxExemptAccount__c, Name from Account where Id =: cc_util_CloudCraze.getAccountId()];
        this.accountIsTaxExempt = false;
        if(cartAccount != null){
          this.accountIsTaxExempt = Boolean.valueOf(cartAccount.TaxExemptAccount__c);
          System.debug('------jllHERE2----------: ' + this.accountIsTaxExempt + ' | ' + cartAccount.Name);
        }
        this.taxExemptFlag = this.accountIsTaxExempt;
        this.optInSelected = false;
        this.validInventory = false;
	}
	
	public Integer getCCCartItemCount()
    {
        cc_api_Cart api = new cc_api_Cart();
        Integer cicount = api.getCartItemCount(parentController.CCCartId);
              
        return cicount;
    } 
    public String getCCCartTotal() {
        String cTotal = '0.00';
        cc_api_Cart api = new cc_api_Cart();
        Decimal total = api.getCartTotal(parentController.CCCartId);            
        if(total > 0)
        {
            return String.valueOf(total);
        }
        else
        {
            return cTotal; 
        }
    }   
    
    public String totalAmount {
        get {
        	String cartId = null;
        	cc_ctrl_Checkout checkout = (cc_ctrl_Checkout) parentController;
        	if(checkout.cart != null)
        	{
        		cartId = checkout.cart.id;
        	}
        	
        	cc_api_Cart api = new cc_api_Cart();
            Double totalAmount = 0.00;
            System.debug('rryyll tSelectedShippingOptionObj --->' + tSelectedShippingOptionObj);
            System.debug('rryyll taxAmount --->' + taxAmount);
            totalAmount=+ (tSelectedShippingOptionObj == null ? 0.0 : tSelectedShippingOptionObj.price) + Double.valueOf(taxAmount) +api.getCartTotal(cartId);
            return String.valueOf(Decimal.valueOf(totalAmount).setScale(2));
        }
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
                
                parentController.CCCartId = api.mergeCart(anonymousCartID, targetID);
            }
            else
            {
                E_Cart__c cart = cc_api_Cart.getLastModifiedValidCart(UserInfo.getuserId());
                if(cart != null)
                {
                    parentController.CCCartId = cart.Id;
                }
                else
                {
                    parentController.CCCartId = null;
                }
            }
            removeAnonymousCartCookie = 'true';
        }
        
       return null;    
    }
	
	public PageReference editCart() {
		String productId = null;
		List<Object> qResult = parentController.queryChildren(cc_ExtensionBase.Query_ProductIdId);
		if(qResult != null) {
			for(Object o : qResult) {
				productId = (String) o;
				break;
				
			}
		}
        //System.debug(' >>> Inside EditCart viewState = ' + viewState);
        //System.debug(' >>> Inside EditCart currentCartID = ' + currentCartID);
        PageReference page = System.Page.Cart;
        page.getParameters().put('cartID', parentController.CCCartId);
        page.getParameters().put('productID', productId);
        page.getParameters().put('viewState',parentController.viewState);
        page.getParameters().put('store', parentController.store);
        page.getParameters().put(parentController.ipAddressLocationKey, parentController.ipAddressLocation);
        page.setRedirect(true);
        return page;        
    }
    
    public List<cc_bean_CartItem> buildCartListViewData2(List<E_CartItem__c> pdl) {
    	List<cc_bean_CartItem> cartListViewData = new List<cc_bean_CartItem>();
        if (al.ArrayUtils.isEmpty(cartListViewData)) {
            cartHasCouponLineItem = false; // reset
            // Get list of product SKUs and list of ProductIDs
            List<String> skuList = new List<String>();
            Set<String> skuSet = new Set<String>();
            List<Id> productIdList = new List<Id>();
          
            Set<Id> productIdSet = new Set<Id>();
            Map<Id, E_Product__c> productMap = new Map<Id,E_Product__c>();
            Map<String,Double> skuMap = new Map<String,Double>();
            
            for(E_CartItem__c pd : pdl){
            	system.debug('----pd.Product__r.SKU__c----' + pd.Product__r.SKU__c);
            	system.debug('---pd---' + pd);
            	system.debug('---pd.Product__r----' + pd.Product__r);
            	//if(pd.Product__r.SKU__c!=null){
                	skuMap.put(pd.Product__r.SKU__c, pd.Quantity__c);
            	//}
                skuSet.add(pd.Product__r.sku__c);
                productIdSet.add(pd.Product__r.Id);
                productMap.put(pd.Product__r.id, pd.Product__r);
                for(E_CartItem__c pi : pd.Cart_Items__r) {
                	system.debug('----pi.Product__r.SKU__c----' + pi.Product__r.SKU__c);
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
            system.debug('----skuMap.keyset()-----' + skuMap.keySet());  
             //Map<String, cc_bean_PriceInfo> priceLineMap = cc_ctrl_PricingEngine.getPriceMap(skuMap, cc_util_CloudCraze.getAccountID(), null, null, null);            
              Map<String, cc_bean_PriceInfo> priceLineMap=new Map<String,cc_bean_PriceInfo>();
            system.debug('----priceLineMap-------' + priceLineMap);
            
            // Map<Id,Id> thumbnailMap = cc_dao_ProductMedia.getAttachmentsForProductList(productIdList, cc_cnst_CloudCraze.ATTACHMENTS_THUMBNAIL_IMAGE_SOQL_PATTERN);
          
            cc_dao_ProductMedia productMedia=new cc_dao_ProductMedia();
            Map<Id,cc_bean_MediaWrapper> imageMap=productMedia.getProductThumbnailMedia(productIdList);
		   
            Map<String,String> translatedMap = getTranslatedProductNames(skuList);
            cc_dao_ProductMedia pmDAO=new cc_dao_ProductMedia();
			Map<Id,cc_bean_MediaWrapper> thumbnailMap = pmDAO.getProductThumbnailMedia(productIdList);
            system.debug('pdl in cart extension = ' + pdl);
            for(E_CartItem__c pd : pdl) {
            	l_cartListViewData.add(assemblyListViewData(
            	   pd, productIdList,
            	   priceLineMap,translatedMap, thumbnailMap)
                );
            	if(pd.Cart_Items__r != null) {
            		cc_bean_CartItem cartViewData = null;
	            	for (E_CartItem__c pi : pd.Cart_Items__r) {
	            		l_cartListViewData.add(assemblyListViewData(
                            pi, productIdList, priceLineMap,translatedMap,
                            thumbnailMap)
                        );
	            	}
            	}
            }
            Integer noOfQueries = Limits.getQueries();
            //system.debug('----Limits.getQueries()-cc_ctrl_Cart.buildCartListViewData---- : ' + noOfQueries);                  
            }
        //system.debug('cartListView Data'+cartListViewData);
                
        return l_cartListViewData;
    }
    
    private cc_bean_CartItem assemblyListViewData(
        E_CartItem__c thisCartItem, List<Id> productIdList,
        Map<String, cc_bean_PriceInfo> priceLineMap,
        Map<String,String> translatedMap,
        Map<Id,cc_bean_MediaWrapper> thumbnailMap
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
        system.debug('sns-->data.SubAmount = ' + data.SubAmount);
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
        if (parentController.storefront.InventoryCheckFlag__c
            && thisCartItem.cartItemType__c != 'Coupon'
        ) {
	        Map<Id, Decimal> qtyMap = cc_api_Inventory.getAvailabilityQty(singleIdList);
	        if (qtyMap.get(thisCartItem.product__r.Id) != null) {
				data.productInventory = qtyMap.get(thisCartItem.product__r.Id);
				if (data.productInventory < data.quantity) {
					this.validInventory = false;
				}
	        }
        }
        */
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
    
    public String taxAmount {
        get {
        	cc_ctrl_checkout checkout = (cc_ctrl_checkout)parentController;
        	
            if(this.taxAmount == null)
            {
	            Decimal taxDecimal = 0.00;
	            //if(cc_api_User.getCurrentUser.Tax_Exempt__c != true && !this.taxExemptFlag)
	            if(!accountIsTaxExempt)
	            {
	                if (checkout.cart != null) {
	                
	                cc_ctrl_TaxCalculation cc_ctrl_TaxCalculation = new cc_ctrl_TaxCalculation();
	                cc_bean_TaxCalculation taxCalcBean = new cc_bean_TaxCalculation();
		            cc_bean_TaxCalculationList cc_bean_TaxCalculationList = new cc_bean_TaxCalculationList();
	
	                // first do aggregate total for non-training classes
	                List<AggregateResult> taxabletotal = [SELECT SUM(SubAmount__c)Tax_Total FROM E_CartItem__c where Product__r.Taxable__c = true AND Product__r.InventoryType__c != 'CLASS' AND Cart__c = :checkout.cart.Id];
	                for(AggregateResult t: taxabletotal)
	                {
	                    Decimal nonClassSubTotal = (Double)t.get('Tax_Total');
	                    if (nonClassSubTotal == null)
	                    	nonClassSubTotal = 0.0;
	                    taxCalcBean.subTotal = nonClassSubtotal;
	                    if(tShippingAddress != null) {
	                    	taxCalcBean.zipCode = tShippingAddress.PostalCode;
	                    } else {
	                    	throw new cc_excn_ShippingAddressIsNullException();
	                    }
	                    taxCalcBean.lineKey = '-1'; //temp val to represent "all non training lines"
	                    break;   
	                }
	                cc_bean_TaxCalculationList.addTaxCalculationBean(taxCalcBean);          
		            
		            // now tax for training classes
		            // todo jll - combine with above query - no need to do 2 queries, this is just cause of merge with OOTB logic
		            // just need condition in below loop that sets zip either based on product or shipping address
		            List<E_CartItem__c> trainingClasses = [SELECT SubAmount__c, Product__r.TaxRateId__c FROM E_CartItem__c where Product__r.Taxable__c = true AND Product__r.InventoryType__c = 'CLASS'  AND Cart__c = :checkout.cart.Id];
		            for(E_CartItem__c t: trainingClasses)
		            {
		             	taxCalcBean = new cc_bean_TaxCalculation();
		               	taxCalcBean.subTotal = t.SubAmount__c;
					    String zipCode = t.Product__r.TaxRateId__c;
		               	taxCalcBean.zipCode = zipCode;
		               	taxCalcBean.lineKey = t.Id;
		               	cc_bean_TaxCalculationList.addTaxCalculationBean(taxCalcBean);
		            }
		            List<Decimal> taxAmounts = cc_ctrl_TaxCalculation.getTaxAmounts(cc_bean_TaxCalculationList);
	                for(Decimal d : taxAmounts)
		            {
		               	taxDecimal += d;
		            }
		            
		            this.tax = taxDecimal;
		            this.taxAmount = String.valueOf(taxDecimal.setScale(2));
		                           
	                } else {
	                    throw new cc_excn_CartException('Exception in tax amount. Cart is Null!');
	                }
	            }
            }
            return this.taxAmount;
        }
    set;
    }
    
    
    public Boolean validInventory {
		get {
			System.debug('ryl-> l_cartListViewData =>' + l_cartListViewData);
			if (l_cartListViewData != null) {
			  for (cc_bean_CartItem wishListItem : l_cartListViewData) {
			    this.validInventory &= (!wishListItem.getInventoryLow() && !wishListItem.getExpired());	
              }
			}
			return this.validInventory;
		} private set;}
		
	public String orderID {get; set; }
	public String orderNumber {get;set;}	
	public PageReference placeOrder(){
		cc_ctrl_checkout checkout = (cc_ctrl_checkout) parentController;
	 	PageReference pageRef=null;
    	System.debug('ah in placeorder');
        System.debug('-----jll tax exempt: ' + taxExemptFlag);
        cc_api_Cart api = new cc_api_Cart();
        this.orderID = api.placeOrder(parentController.CCCartId);
        
        if(this.orderID!=null){ 
            E_Order__c order = [Select e.Name,e.TotalSurcharge__c, e.TotalShipDiscount__c, e.EncryptedId__c,
                                       e.TotalDiscount__c, e.TotalAmount__c, e.TaxAmount__c, 
                                       e.SubTotalAmount__c, e.SubTotalAmount2__c, e.ShipTo__c, e.BillTo__c
                                From E_Order__c e 
                                where Id=:this.orderId];
            
            if(this.selectedPaymentType=='CC'){
                
            } else if(this.selectedPaymentType=='PO'){
                order.PONumber__c = this.poNumber;
            }
            order.TaxAmount__c  = Double.valueOf(this.taxAmount);
            order.TaxExemptFlag__c = this.taxExemptFlag;
            if(!this.accountIsTaxExempt && this.taxExemptFlag)
            	order.VerifyExemptionFlag__c = true;
           	System.debug('ah in placeorder before getselectedshipop'); 
           	
             
          //  System.debug('ah whats null? price provider discship' + opt.price + ' ' + opt.providerId + ' ' + opt.discountedShipCost); 
            if(tSelectedShippingOptionObj!=null){
               order.ShipAmount__c = tSelectedShippingOptionObj.price;
                order.TotalShipDiscount__c = tSelectedShippingOptionObj.discountedShipCost;
            }
             
            //order.TotalAmount__c = Double.valueOf(this.totalAmount);
            order.SubTotalAmount__c = checkout.cart.SubTotalAmount_2__c;
            // String shipStateCode = this.shipState.subString(4);
            
            //String shipStateCode = this.shipState;
            //String billStateCode = this.billState.subString(4);
            //String billStateCode = this.billState;
            
            
            if(tSelectedShippingOptionObj != null){
                order.shipEstimateGiven__c = true;
                order.ShippingMethod__c    = tSelectedShippingOptionObj.serviceName;
                
            }            
            if(order.VerifyExemptionFlag__c){
            	order.OrderStatus__c = cc_cnst_PickListConstants.ORDERSTATUS_ONHOLD;
            } else {
            	order.OrderStatus__c=cc_cnst_PickListConstants.ORDERSTATUS_INPROCESS;
            }
            
            update order;
            
            this.orderNumber = order.Name;
			//If needed, send email to tax admin
			//TODO jlowenthal refactor, separate method
            if(order.VerifyExemptionFlag__c){
            	String recipient = parentController.storefront.TaxExemptEmail__c;
            	List<String> recipients = new List<String>();
            	recipients.add(recipient);
				//cc_util_Email.sendTextEmail(recipients, 'Order ' + this.orderNumber + ' requires tax exemption verification.','Order ' + this.orderNumber + ' requires tax exemption verification.');
                sendTaxExemptEmail(order.Id,recipients);
            }
            //this.sendOrderConfirmationEmail(order); // look at using workflow for this
            parentController.removeCurrentCart();
            //System.currentPageReference().getParameters().clear();
            parentController.viewState  = 'OrderComplete';
            
            pageRef = System.Page.OrderView;
            pageRef.getParameters().clear();
            pageref.setRedirect(true);
            pageRef.getParameters().put('o', order.EncryptedId__c);
            pageRef.getParameters().put('cartID', parentController.CCCartId);
            pageRef.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, parentController.ipAddressLocation);
            //pageRef.getParameters().put('store', storeID);                  
        }
         
        return pageref  ;
    }
     private void sendTaxExemptEmail(Id orderId, List<String> recipients){
      /* Get the BOM templates Id */
      List<EmailTemplate> templateId = [SELECT Id FROM EmailTemplate WHERE Name='TaxExemptionEmail' LIMIT 1];
      if(templateId != null && templateId.size()==1){
        /* Send email through Apex */
        cc_hlpr_Email em = new cc_hlpr_Email();
        em.sendEmailUsingTemplate(templateId.get(0).Id, this.orderId, recipients);
      }
    }
}