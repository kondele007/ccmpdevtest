public with sharing class cc_kap_utils_Cart {

	/**
	 * Determines if cart contains shippable items,
	 * e.g. at least one product has spec "HSKEnabled" = "1"
	 * @param cartID
	 */
	public static boolean cartContainsShippableItems(String currentCartId){
		boolean bReturn = false;
		/*
		cc_api_Cart cartAPI = new cc_api_Cart();
		List<E_CartItem__c> cartItems = cartAPI.getCartItems(currentCartId);
		Map<String,String> cartSpecs = buildCartSpecs(cartItems, false);
		bReturn = cartHasSpec(cartSpecs, cc_kap_utils_AppConstants.SPEC_SHIPPABLE, '1');
		*/
		return bReturn;
	}
	
	/**
	 * Calculates the shipping charge for this order based on the specs in the cart
	 * lines and the shipping address.  This will drive the charge and shipping method.
	 * @param cart Cart to determine shipping charges for.
	 * @return map containing method and charge.
	 */
	public static Decimal calculateLineBasedShipping(String currentCartId, String shipCountry, Decimal totalAmount) {
		cc_api_Cart cartAPI = new cc_api_Cart();
		List<E_CartItem__c> cartItems = cartAPI.getCartItems(currentCartId);
		cc_kap_api_rules_CartRules cartRulesAPI = new cc_kap_api_rules_CartRules(cartItems);
		return calculateLineBasedShipping(cartRulesAPI, shipCountry, totalAmount);
	}
	
	/**
	 * Calculates the shipping charge for this order based on the specs in the cart
	 * lines and the shipping address.  This will drive the charge and shipping method.
	 * @param cart Cart to determine shipping charges for.
	 * @return map containing method and charge.
	 */
	public static Decimal calculateLineBasedShipping(cc_kap_api_rules_CartRules cartRulesAPI, String shipCountry, Decimal totalAmount) {
		Decimal totalShipping = 0.0;
		cartRulesAPI.buildCartSpecs();
		for (E_CartItem__c line: cartRulesAPI.cartLines) {
			line.Shipping_Method__c = cc_kap_utils_AppConstants.SHIP_STANDARD;
			line.Shipping_Charge__c = 0.00;
			String sku = line.Product__r.SKU__c;
			boolean isShippable = cartRulesAPI.lineHasSpec(sku, cc_kap_utils_AppConstants.SPEC_SHIPPABLE, '1');
			if (!isShippable)
				line.Shipping_Method__c = cc_kap_utils_AppConstants.SHIP_NONE;
			else if (cartRulesAPI.lineHasSpec(sku, cc_kap_utils_AppConstants.SPEC_SHIPPABLE, '1') &&  line.AmountOwed__c > 0 && !cartRulesAPI.lineHasSpec(sku, cc_kap_utils_AppConstants.SPEC_FREE_SHIP, '1')) {
				if ((shipCountry == cc_kap_utils_AppConstants.COUNTRY_CANADA) || (shipCountry == cc_kap_utils_AppConstants.COUNTRY_CANADA_ABBREV)){
					//Canadian shipping fee
					line.Shipping_Charge__c = Kaplan_Shipping_Fees__c.getValues('Canada').Fee_Amount__c;
				}
				else if (shipCountry != cc_kap_utils_AppConstants.COUNTRY_USA && shipCountry != cc_kap_utils_AppConstants.COUNTRY_USA_ABBREV){
					//All other non US shipping
					line.Shipping_Charge__c = Kaplan_Shipping_Fees__c.getValues('Non-US or Canada').Fee_Amount__c;
				}
				else if (cartRulesAPI.lineHasSpec(sku, cc_kap_utils_AppConstants.SPEC_DELIVERY_TYPE, '2') || cartRulesAPI.lineHasSpec(sku, cc_kap_utils_AppConstants.SPEC_DELIVERY_TYPE, '11')) {
					DateTime startDate = line.Product__r.ClassStartDate__c;
					if (line.Flex_Date__c != null)
						startDate = DateTime.newInstance(line.Flex_Date__c, Time.newInstance(0,0,0,0));
					if (startDate != null && System.today().daysBetween(Date.newInstance(startDate.year(), startDate.month(), startDate.day())) <= cc_kap_utils_AppConstants.SHIP_DAYS_FOR_EXPEDITED) {
						//Expedited shipping
						line.Shipping_Charge__c = Kaplan_Shipping_Fees__c.getValues('Expedited US').Fee_Amount__c;
						line.Shipping_Method__c = cc_kap_utils_AppConstants.SHIP_EXPEDITED;
					}
					else if (cartRulesAPI.lineHasSpec(sku, cc_kap_utils_AppConstants.SPEC_PROGRAM_CODE, cc_kap_utils_AppConstants.PROG_CODE_BAR_REVIEW)){
						//Bar review
						line.Shipping_Charge__c = Kaplan_Shipping_Fees__c.getValues('Bar Review').Fee_Amount__c;
					}
					else{
						//Standard shipping
						line.Shipping_Charge__c = Kaplan_Shipping_Fees__c.getValues('Standard US').Fee_Amount__c;
					}
				}
				else if (cartRulesAPI.lineHasSpec(sku, cc_kap_utils_AppConstants.SPEC_PROGRAM_CODE, cc_kap_utils_AppConstants.PROG_CODE_BAR_REVIEW)){
					//Bar review
					line.Shipping_Charge__c = Kaplan_Shipping_Fees__c.getValues('Bar Review').Fee_Amount__c;
				}
				else{
					//Standard shipping
					line.Shipping_Charge__c = Kaplan_Shipping_Fees__c.getValues('Standard US').Fee_Amount__c;
				}
			}
			totalShipping += line.Shipping_Charge__c;
		}
		return totalShipping;
	}
	
	/**
	 * Constructs a list of full product objects - these contain product data, specs and localized info.
	 * Will optionally also add the parent products to the list as well.
	 * @param cartItems cart items
	 * @param includeParents if true will add the parent products to the list
	 * @return list of full products
	 */
	public static List<E_Product__c> buildFullProductsFromCart(List<E_CartItem__c> cartItems, boolean includeParents) {
		List<String> lineSkus = new List<String>();
		for (E_CartItem__c line: cartItems) {
			lineSkus.add(line.Product__r.SKU__c);
			if (includeParents && line.Product__r.ParentProduct__c != null)
				lineSkus.add(line.Product__r.ParentProduct__r.SKU__c);
			for(E_CartItem__c childLine : line.Cart_Items__r) {
				lineSkus.add(childLine.Product__r.SKU__c);
				if (includeParents && childLine.Product__r.ParentProduct__c != null)
					lineSkus.add(childLine.Product__r.ParentProduct__r.SKU__c);
			}
		}
		cc_dao_Product dao = new cc_dao_Product();
		List<E_Product__c> products = dao.readProduct(lineSkus);
		return products;
	}
	
	/**
	 * Calculates the total amounts for the cart.  The overall total is just a sum of the line amounts based
	 * on OOTB aggregation rules.  The upfront amount is dependent on user provided data. For any lines 
	 * that have billing installments, the upfront amount for that line is the per installment amount, otherwise
	 * it is the line total.  Also, determines the max number of installments for the given cart lines.
	 * @param cartItems items in the cart
	 * @return map containing upfront amount, total amount and max installments
	 */
	public static Map<String, Decimal> calculateCartTotals(List<E_CartItem__c> cartItems) {
		Decimal totalAmount = 0.0;
		Decimal upfrontAmount = 0.0;
		Decimal maxInstallments = 0.0;
		Map<String, Decimal> amounts = new Map<String, Decimal>();
		for (E_CartItem__c cartItem: cartItems) {
			cc_hlpr_CompositeProductHelperBase utils = cc_hlpr_CompositeProductHelperFactory.getCompositeProductHelper(cartItem.Product__r.ProductType__c);
        	Decimal lineTotal = utils.calAggregatedPrice(cartItem);
        	totalAmount += lineTotal;
        	if (cartItem.Billing_Installments__c == null || cartItem.Billing_Installments__c <= 1)
        		upfrontAmount += lineTotal;
        	else {
        		Decimal installVal = (lineTotal/cartItem.Billing_Installments__c).setScale(2).round(System.RoundingMode.DOWN);
        		lineTotal = lineTotal - (installVal * (cartItem.Billing_Installments__c - 1));
        		upfrontAmount += lineTotal;
        		if (maxInstallments < cartItem.Billing_Installments__c)
        			maxInstallments = cartItem.Billing_Installments__c;
        	}
        	cartItem.AmountOwed__c = lineTotal;
        	cartItem.DiscountAmount__c = cartItem.AbsoluteDiscount__c;
		}
		amounts.put(cc_kap_utils_AppConstants.TOTALS_UPFRONT, upfrontAmount);
		amounts.put(cc_kap_utils_AppConstants.TOTALS_GRAND, totalAmount);
		amounts.put(cc_kap_utils_AppConstants.TOTALS_INSTALLS, maxInstallments);
		return amounts;
	} 
    public static Map<String, Decimal> calculateCartTotals(E_Cart__c cart) {
        Map<String, Decimal> amounts = new Map<String, Decimal>();
        cc_api_Cart cartAPI = new cc_api_Cart();
        Decimal cartSubTotal = cartAPI.getCartTotal(cart.Id);
        //System.debug(LoggingLevel.INFO,'@@cart.Id='+ cart.Id);
        //System.debug(LoggingLevel.INFO,'@@cart.EncryptedId__c='+ cart.EncryptedId__c);
        //System.debug(LoggingLevel.INFO,'@@cartSubTotal='+ cartSubTotal);
        //cc_bean_MockContactAddress shippingAddress = new cc_bean_MockContactAddress(cart.ShipTo__r);
        //List<E_CartItem__c> cartItems = cc_dao_Cart.getDisplayCartItems(cart.EncryptedId__c);
        //cc_kap_api_rules_CartRules cartRulesAPI = new cc_kap_api_rules_CartRules(cartItems);
        //Double shippingAmount = cart.ShipAmount__c;
        //if (shippingAmount == null) {
        //  if (cartRulesAPI != null)
        //      shippingAmount = cc_kap_utils_Cart.calculateLineBasedShipping(cartRulesAPI, shippingAddress.country, cartSubTotal);
        //}
        //System.debug(LoggingLevel.INFO,'@@shippingAmount='+ shippingAmount);
        //System.debug(LoggingLevel.INFO,'@@cart.Pay_in_Installments__c='+ cart.Pay_in_Installments__c);
        if(cart.Pay_in_Installments__c != null && cart.Pay_in_Installments__c)
        {
            amounts.put(cc_kap_utils_AppConstants.TOTALS_UPFRONT, cart.due_today__c);
            amounts.put(cc_kap_utils_AppConstants.TOTALS_GRAND, cartSubTotal);
            amounts.put(cc_kap_utils_AppConstants.TOTALS_INSTALLS, cc_kap_utils_AppConstants.TOTAL_INSTALLMENTS);
        }
        else
        {
            amounts.put(cc_kap_utils_AppConstants.TOTALS_UPFRONT, cartSubTotal);
            amounts.put(cc_kap_utils_AppConstants.TOTALS_GRAND, cartSubTotal);
            amounts.put(cc_kap_utils_AppConstants.TOTALS_INSTALLS,1.0);
        }
        //System.debug(LoggingLevel.INFO,'@@amounts='+ amounts);
        return amounts;
    }
	/**
	 * Retrieves the earliest start date for the items in the cart.
	 * @return earliest date or null if no applicable dates.
	 */
	public static DateTime getEarliestClassStartDate(List<E_CartItem__c> cartLines) {
		DateTime earliestDate = null;
		for (E_CartItem__c line: cartLines) {
			DateTime startDate = line.Product__r.ClassStartDate__c;
			if (line.Flex_Date__c != null)
				startDate = DateTime.newInstance(line.Flex_Date__c, Time.newInstance(0,0,0,0));
			if (earliestDate == null || (startDate != null && startDate < earliestDate))
				earliestDate = startDate;
		}
		return earliestDate;
	}
	
	/**
	 * Calculates the line totals and shipping amounts and saves those to the cart.
	 * Will return the totals for the shipping and cart in the map.
	 * @param currentCartId represents the current cart
	 * @param country shipping country
	 * @param updateShipping whether or not to process shipping
	 * @return map of total amounts
	 */
	public static Map<String, Decimal> updateCartTotalsAndShipping(String currentCartId, String country, boolean updateShipping) {
		cc_api_Cart cartAPI = new cc_api_Cart();
		List<E_CartItem__c> cartItems = cartAPI.getCartItems(currentCartId);
		return updateCartTotalsAndShipping(cartItems, country, updateShipping);
	}
	
	/**
	 * Calculates the line totals and shipping amounts and saves those to the cart.
	 * Will return the totals for the shipping and cart in the map.
	 * @param cartItems items from the current cart
	 * @param country shipping country
	 * @param updateShipping whether or not to process shipping
	 * @return map of total amounts
	 */
	public static Map<String, Decimal> updateCartTotalsAndShipping(List<E_CartItem__c> cartItems, String country, boolean updateShipping) {
		Map<String, Decimal> totals = calculateCartTotals(cartItems);
		if (updateShipping) {
			cc_kap_api_rules_CartRules cartRulesAPI = new cc_kap_api_rules_CartRules(cartItems);
			Decimal totalShipping = calculateLineBasedShipping(cartRulesAPI, country, totals.get(cc_kap_utils_AppConstants.TOTALS_GRAND));
			totals.put(cc_kap_utils_AppConstants.TOTALS_SHIPPING, totalShipping);
		}
		upsert cartItems;
		return totals;
	}
	
	/**
	 * Determines if the current cart contains the passed in product.  Will only return true if
	 * the product is a normal product (not bundle, etc) and the cart contains it.
	 */
	public static boolean cartContainsProduct(String cartId, String productId, String productType) {
		if ((productType != 'Assembly') && (productType != 'Bundle') && (productType != 'Aggregated') && (productType != 'Kit'))
			return cc_dao_Cart.countOfProduct(cartId, productId) > 0;
		return false;
	}
	
	/**
	 * Determines whether or not the passed in cart id represents a cart that contains
	 * only free event products. A product is a free event if the event type is not null and
	 * the price is 0.
	 */
	public static boolean isFreeEventCart(String cartId) {
		List<E_CartItem__c> items = cc_dao_Cart.getEvents(cartId);
		return isFreeEventCart(items);
	}
	
	/**
	 * Determines whether or not the passed in cart id represents a cart that contains
	 * only free event products. A product is a free event if the event type is not null and
	 * the price is 0.
	 */
	public static boolean isFreeEventCart(List<E_CartItem__c> items) {
		if (items.size() == 0)
			return false;
		for (E_CartItem__c item: items) {
			if ((item.Product__r.EventType__c == null && item.Product__r.ParentProduct__r.EventType__c == null) || item.Price__c > 0.00)
				return false;
		}
		return true;
	}
	
	/*
	 * Constructs the page reference used for redirecting the punchin request to SSO.
	 * @param currCartId cart id
	 * @param currProdId products being added
	 * @param nonOrderableSkus products that could not be added
	 * @return PageReference
	 */
	public static PageReference setupSSORedirect(String currCartId, String url, String ipAddressLocationKey) {
		PageReference redirectTo = new PageReference(url);
		Map<String, String> params = redirectTo.getParameters();
        params.put('PartnerSpId', 'https://saml.salesforce.com');
        params.put('TargetResource', Page.SSOPunchin.getUrl() + '?cartID=' + currCartId + '&' + cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY + '=' + ipAddressLocationKey);
        redirectTo.setRedirect(true);
        return redirectTo;
	}
	
}