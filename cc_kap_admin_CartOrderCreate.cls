public with sharing class cc_kap_admin_CartOrderCreate {


public static PageReference createOrderFromCart(){
		String cartId = ApexPages.currentPage().getParameters().get('cartId');
		System.debug(LoggingLevel.INFO, 'AH CART ID ' + cartId);
		cc_api_Cart cartAPI = new cc_api_Cart();
		if(cartId != null && cartId.length() > 0)
			Id orderID = cartAPI.placeOrder(cartId);
		return null;
	}


}