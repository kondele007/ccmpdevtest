public with sharing class ktp_cc_kap_utils_AppUtils {
/*
	 * Attempts to retrieve the session  cookie corresponding to the passed in name.. 
	 * If this exists, then will return that otherwise, returns null.
	 * @param cookie name
	 * @return cookie value
	 */
	public static String retrieveCookie(String name) {
		Map<String, Cookie> currCookies = ApexPages.currentPage().getCookies();
		if (currCookies != null && currCookies.containsKey(name)) {
			return currCookies.get(name).getValue();
		}
		return null;
	}
	
	/*
	 * Sets the cookie in the session
	 * @param cookie name
	 * @param cookie value
	 */
	public static void setCookie(String name, String value) {
		Cookie newCookie = new Cookie(name, value, null, -1, false);
		ApexPages.currentPage().setCookies(new Cookie[]{newCookie});
	}
	
	/**
	 * Retrieves the payment settings for the passed in region. 
	 * @param region merchant processor location in the event of multiples based on country
	 * @return settingss
	 */
	public static E_CCKapPaymentSettings__c getPaymentSettings(String region) {
		if (region != null)
			return E_CCKapPaymentSettings__c.getValues(region);
		return null;
	}
		
     /**
	 * Retrieves the product bean corresponding to the passed in productid.  The id could be a 
	 * sku or an id, so query accordingly.  If this is an aggregated product, then pull the corresponding
	 * id.
	 * @param productId
	 * @param aggregatedProds
	 * @return E_Product__c
	 */
	public static ccrz__E_Product__c retrieveProduct(String productId, Map<String, String> aggregatedProds) {
		System.debug(LoggingLevel.INFO,'+++++++++++++produc' + productId + '=========' + aggregatedProds);
		ktp_cc_dao_Product productDao = new ktp_cc_dao_Product();
		if (aggregatedProds != null && aggregatedProds.containsKey(productId))
			productId = aggregatedProds.get(productId);
		List<ccrz__E_Product__c> products;
		if (productId instanceof Id)
			products =  productDao.readProductWithID(productId);
		else
			products =  productDao.readProduct(productId);
		if (products != null && products.size() > 0)
			return products.get(0);
		return null;
	}
	
	/**
	 * Retrieves the currency corresponding to the product country.
	 */
	public static String getCurrencyISOCodeForProdCountry(String country) {
		if (country == 'United States' || country == 'US')
			return 'USD';
		else if (country == 'Puerto Rico')
			return 'USD';
		else if (country == 'Canada')
			return 'CAD';
		return 'USD';
	}
	
	/**
	 * Gets the credit card name from the custom settings corresponding to the passed
	 * in code. Returns null if no match is found.
	 * @param code processor code
	 * @return String credit card display name
	 */
	public static String getCreditCardNameByCode(String code) {
		List<E_KaplanCreditCardTypes__c> cardTypes = E_KaplanCreditCardTypes__c.getAll().values();
		for (E_KaplanCreditCardTypes__c cardType: cardTypes) {
			if (cardType.CS_Code__c == code)
				return cardType.Name;
		}
		return null;
	}
	
	/**
	 * Gets the credit card get real name from the custom settings corresponding to the passed
	 * in card display name. Returns null if no match is found.
	 * @param name display name
	 * @return String credit card get real name
	 */
	public static String getCreditCardGetRealNameByName(String name) {
		E_KaplanCreditCardTypes__c cardType = E_KaplanCreditCardTypes__c.getValues(name);
		if (cardType != null)
			return cardType.GetReal_Name__c;
		return null;
	}
	
	/**
	 * Gets the item type from the custom settings corresponding to the passed
	 * in delivery type name. Returns null if no match is found.
	 * @param name display name
	 * @return String credit card get real name
	 */
	public static String getDeliveryTypeItemType(String deliveryTypeDesc) {
		E_KaplanDeliveryTypes__c deliveryType = E_KaplanDeliveryTypes__c.getValues(deliveryTypeDesc);
		if (deliveryType != null)
			return deliveryType.Item_Type__c;
			String Defaultdeliverytype='product_item';
		return Defaultdeliverytype;
	}
}