/**
// * @Description: API to handle procesing of data to be used when enforcing cart related data entry rules.
// * @Author: 1.0
// * @File: cc_kap_api_rules_CartRules
// * =======================================================================================
// * 2012/08/20 1.1 IL -  Created
**/
public with sharing class cc_kap_api_rules_CartRules_va {
	public List<E_CartItem__c> cartLines { get; private set; }
	private List<String> lineSkus;
	List<String> messages { get; private set; }
	Map<String, cc_kap_rules_bean_CartDataRulesBean_va> displayRuleData { get; private set; }
	Map<String, E_CartItem__c> cartLineSkuMap { get; private set; }
	private Set<String> scheduleDeliveryTypes;
	private Map<String, List<E_ProductSpecIndex__c>> transientSpecMap;
	private List<E_Product__c> cartProducts;
	private Map<String,String> cartSpecs;
	private Map<String, Set<String>> specValues;
	public List<String> installmentMessages { get; private set; }
	private String currencyCode;
		
	/**
	 * Takes in the list of cart line items to use in the processing.
	 */
	public cc_kap_api_rules_CartRules_va(List<E_CartItem__c> cartLines) {
		this.cartLines = cartLines;
		this.lineSkus = new List<String>();
		this.displayRuleData = new Map<String, cc_kap_rules_bean_CartDataRulesBean_va>();
		this.cartLineSkuMap = new Map<String, E_CartItem__c>();
		this.installmentMessages = new List<String>();
		scheduleDeliveryTypes = new Set<String>();
		scheduleDeliveryTypes.add('2');
		scheduleDeliveryTypes.add('11');
	}
	
	/**
	 * Takes in the list of cart line items to use in the processing.
	 */
	public cc_kap_api_rules_CartRules_va(List<E_CartItem__c> cartLines, String currencyCode) {
		this(cartLines);
		this.currencyCode = currencyCode;
	}
	
	/**
	 * Retreives the display rule bean corresponding to the passed in sku
	 * @param sku line ksu to evaluate
	 * @return rule bean
	 */
	public cc_kap_rules_bean_CartDataRulesBean_va getDisplayRuleBean(String sku) {
		return displayRuleData.get(sku);
	}
	
	/**
	 * Constructs the line data for the line items.  This includes setting up display rule
	 * beans for each line, and applying all of the cart line values and spec values for the
	 * bean.  Stores the results in a map to be used later for evaluation or retrieval.
	 */
	public void constructLineData() {
		List<E_Product__c> products = retrieveLineData();
		Map<String, Decimal> basePriceMap = cc_ctrl_PricingEngine.getBasePrice(lineSkus);
		Map<String, String> deliveryTypes = getDeliveryTypeData();
		//Map<String,String> cartSpecs = cc_kap_utils_Cart.buildCartSpecs(cartLines, false);
		for (E_Product__c product: products) {
			String sku = product.SKU__c;
			cc_kap_rules_bean_CartDataRulesBean_va bean = new cc_kap_rules_bean_CartDataRulesBean_va(cartLineSkuMap.get(sku));
			Decimal price = basePriceMap.get(sku);
			if (price == null)
				price = basePriceMap.get(product.ParentProduct__r.SKU__c);
			bean.addAvailableInstallment(price, 1, currencyCode);
			bean.sku = sku;
			/**
			* This block is purely for debugging, to check that the realtime specs are correct
			* In most cases, the realtime specs should match the offline specs
			* LEAVE THIS HERE FOR NOW IN CASE THIS STILL HAS ISSUES TO BE DEBUGGED
			*/
			/*
			System.debug('Offline specs = ');
			for (E_ProductSpecIndex__c spec: product.Product_Spec_Indicies__r)
				System.debug(spec.Spec__r.DisplayName__c + '=' + spec.SpecValue__c);
			System.debug('Realtime specs = ');
			for (E_ProductSpecIndex__c spec: transientSpecMap.get(String.valueOf(product.Id)))
				System.debug(spec.Spec__r.DisplayName__c + '=' + spec.SpecValue__c);
			*/
			/**
			* End debugging code
			*/
			//for (E_ProductSpecIndex__c spec: product.Product_Spec_Indicies__r) {
			System.debug('================s=' + product);
			System.debug('================s=' + transientSpecMap);
			if(product != null && product.ProductType__c != 'Coupon' && transientSpecMap != null && transientSpecMap.size() > 0){
			for (E_ProductSpecIndex__c spec: transientSpecMap.get(String.valueOf(product.Id))){ 
				bean.fullSpecs += spec.Spec__r.DisplayName__c + '=' + spec.SpecValue__c +   '|'; 
				if (spec.Spec__r.Name == cc_kap_utils_AppConstants.SPEC_DELIVERY_TYPE) {
					bean.setProductDeliveryType(spec.SpecValue__c, deliveryTypes.get(spec.SpecValue__c));
					bean.showSchedulingLink = scheduleDeliveryTypes.contains(spec.SpecValue__c);
				}
				else if (spec.Spec__r.Name == cc_kap_utils_AppConstants.SPEC_BILL_INSTALLMENTS) {
					String[] vals = al.StringUtils.split(spec.SpecValue__c, ' , ' );
					for (String val: vals) {
						Integer installments = Integer.valueOf(al.StringUtils.trim(val));
						if (installments > 1) {
							String installMsg = bean.addAvailableInstallment(price, installments, currencyCode);
							if (installMsg != null)
								installmentMessages.add(installMsg);
						}
					}
				}
				else if (spec.Spec__r.Name == cc_kap_utils_AppConstants.SPEC_FLEX_TYPE)
					bean.flexStartType = spec.SpecValue__c;
				else if (spec.Spec__r.Name == cc_kap_utils_AppConstants.SPEC_FLEX_START_DURATION)
					bean.flexStartRange = Integer.valueOf(spec.SpecValue__c);
				else if (spec.Spec__r.Name == cc_kap_utils_AppConstants.SPEC_PROGRAM_CODE)
					bean.programCode = spec.SpecValue__c;
				else if (spec.Spec__r.Name == cc_kap_utils_AppConstants.SPEC_SBU)
					bean.sbuCode = spec.SpecValue__c;
			}
			}
			displayRuleData.put(sku, bean);
		}
	}
	
	/**
	 * Builds a map of delivery type to description.
	 */
	private Map<String, String> getDeliveryTypeData() {
		List<E_KaplanDeliveryTypes__c> deliveryTypes = cc_kap_utils_CustomSettings.getDeliveryTypes(cc_util_Locale.getUserLanguage());
		Map<String, String> typeMap = new Map<String, String>();
		for (E_KaplanDeliveryTypes__c deliveryType: deliveryTypes)
			typeMap.put(String.valueOf(Integer.valueOf(deliveryType.Delivery_Type__c)), deliveryType.Name);
		return typeMap;
	}
	
	/**
	 * Retrieves the product data corresponding to the skus in the cart line items.
	 * @return list of products with specs
	 */
	private List<E_Product__c> retrieveLineData() {
		if (lineSkus.size() == 0 ||  cartProducts == null) {
			List<String> skus = new List<String>();
			for (E_CartItem__c line: cartLines) {
				skus.add(line.Product__r.SKU__c);
				lineSkus.add(line.Product__r.SKU__c);
				if (line.Product__r.ParentProduct__c != null)
					lineSkus.add(line.Product__r.ParentProduct__r.SKU__c);
				cartLineSkuMap.put(line.Product__r.SKU__c, line);
				for(E_CartItem__c childLine : line.Cart_Items__r) {
					skus.add(childLine.Product__r.SKU__c);
					lineSkus.add(childLine.Product__r.SKU__c);
					if (childLine.Product__r.ParentProduct__c != null)
						lineSkus.add(childLine.Product__r.ParentProduct__r.SKU__c);
					cartLineSkuMap.put(childLine.Product__r.SKU__c, childLine);
				}
			}
			cc_dao_Product dao = new cc_dao_Product();
			List<E_Product__c> products = dao.readProduct(skus);
			cartProducts = products;
			transientSpecMap = cc_hlpr_LoadProductSpecRealTime.getRealTimeProductSpecIndices(products);
		}
		return cartProducts;
	}
	
	/**
	 * Constructs a map representing the specs associated to the products in the
	 * passed in cart items.  The map contains two types of keys:
	 * 1) <spec name>.<spec value>=count  this is the count of the spec and it's value in the cart
	 * 2) <sku>.<spec name>=<spec value>  this is the sku and spec values
	 * @param cartItems list of cart lines
	 * @return map following the defined structure
	 */
	public Map<String,String> buildCartSpecs() {
		if (this.cartProducts == null)
			retrieveLineData();
		return buildCartSpecs(this.cartProducts);
	}
	
	/**
	 * Constructs a map representing the specs associated to the products in the
	 * passed in cart items.  The map contains two types of keys:
	 * 1) Spec:<spec name>=Set of <spec values>  this is the list of the spec vslues for a given spec in the cart
	 * 2) <sku>.<spec name>=<spec value>  this is the sku and spec values
	 * @param cartItems list of cart lines
	 * @return map following the defined structure
	 */
	public Map<String,String> buildCartSpecs(List<E_Product__c> cartProducts) {
		Map<String,String> cartSpecs = new Map<String,String>();
		specValues = new Map<String, Set<String>>();
		for (E_Product__c cartProduct : cartProducts) {
			String sku = cartProduct.SKU__c;
			if (cartProduct.Country__c != null) {
				addSpecValue(cc_kap_utils_AppConstants.SPEC_REGION, cartProduct.Country__c);
				cartSpecs.put(sku + '.' + cc_kap_utils_AppConstants.SPEC_REGION, cartProduct.Country__c);
			}
			//for (E_ProductSpecIndex__c spec : cartProduct.Product_Spec_Indicies__r) {
			if(transientSpecMap == null)
			{
				transientSpecMap = cc_hlpr_LoadProductSpecRealTime.getRealTimeProductSpecIndices(cartProducts);
			}
			if(transientSpecMap != null && cartProduct != null && cartProduct.ProductType__c != 'Coupon' && transientSpecMap.size() > 0){
				for (E_ProductSpecIndex__c spec : transientSpecMap.get(cartProduct.Id)) {
					String name = spec.Spec__r.Name;
					String value = spec.SpecValue__c;
					addSpecValue(name, value);
					cartSpecs.put(sku + '.' + name, value);
				}
			}
		}
		this.cartSpecs = cartSpecs;
		return cartSpecs;
	}
	
	/**
	 * Adds a spec value to the specvalues map.
	 */
	private void addSpecValue(String name, String value) {
		Set<String> vals = specValues.get('Spec:' + name);
		if (vals == null)
			vals = new Set<String>();
		if (!vals.contains(value))
			vals.add(value);
		specValues.put('Spec:' + name, vals);
	}
	
	/**
	 * Determines if the cart contains the passed in spec and value combination.
	 * @param cartItems items within the cart
	 * @param name name of the spec requested
	 * @param value value for the spec requested
	 * @return boolean
	 */
	public boolean cartHasSpec(String name, String value) {
		if (cartSpecs == null)
			buildCartSpecs();
		Set<String> vals = specValues.get('Spec:' + name);
		return (vals != null && vals.contains(value));
	}
	
	/**
	 * Determines if the cart contains the passed in spec and value combination.
	 * @param cartItems items within the cart
	 * @param name name of the spec requested
	 * @param value value for the spec requested
	 * @return boolean
	 */
	public boolean lineHasSpec(String sku, String name, String value) {
		if (cartSpecs == null)
			buildCartSpecs();
		String specValue = cartSpecs.get(sku + '.' + name);
		return (specValue != null && specValue == value);
	}
	
	/**
	 * Determines if the cart contains the passed in spec and value combination.
	 * @param cartItems items within the cart
	 * @param name name of the spec requested
	 * @param value value for the spec requested
	 * @return boolean
	 */
	public boolean allLinesHaveSpec(String name, String value) {
		if (cartSpecs == null)
			buildCartSpecs();
		for (E_CartItem__c line: cartLines) {
			if (cartSpecs.get(line.Product__r.SKU__c + '.' + name) != value)
				return false;
		}
		return true;
	}
	
	/**
	 * Determines if the cart only has the passed in values for the given spec.
	 * @param name name of the spec
	 * @param eligibleValues values that are allowed to be present
	 * @return boolean 
	 */
	public boolean containsOnly(String name, Set<String> eligibleValues) {
		Set<String> vals = specValues.get('Spec:' + name);
		for (String val: vals) {
			if (!eligibleValues.contains(val))
				return false;
		}
		return true;
	}
	
	/*
	 * Retrieves the values from the cart corresponding to the passed in spec.
	 * @return set of values
	 */
	public Set<String> getSpecValues(String name) {
		if (cartSpecs == null || specValues == null)
			buildCartSpecs();
		return specValues.get('Spec:' + name);
	}
	
	
}