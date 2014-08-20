/**
// * @Description: Kaplan URL Rewriter for site friendly urls
// * @Author: 1.0
// * @File: cc_kap_site_UrlRewriter
// * ==========================================================
// * 2012/08/13 1.1 IL -  Custom Kaplan rewriting for checkout and add to cart
// **/
global with sharing class cc_kap_site_UrlRewriter implements Site.Urlrewriter {
	global static final String KAP_CHECKOUT = 'shoppingcart';
	global static final String KAP_CHECKOUT_ADD_SKU = 'classids=';
	global static final List<String> allowedPages = new List<String> {'Cart', 'cclogout', 'shoppingcart', 'CheckoutNew', 'CCSiteRegister', 'logout', 'CCSiteLogin', 'HOPIFrame', 'OrderView', 'SSOpunchin', 'CyberSourceReceipt', 'CCException', 'ChangePassword'};
	
	/*
	 * Handles mapping of friendly URLs to internal ones.  Currently supported mappings are 
	 * for Catalog, allows /Category/ to reference a category, and for product /ProductDetails/.  
	 * Additional Kaplan customization adding mapping of checkout to cart, adding a product
	 * if one is passed in.
	 */
	global PageReference mapRequestUrl(PageReference siteUrl) {
		String url = siteUrl.getUrl();
		if (url.contains(KAP_CHECKOUT)) {
    		if (!url.contains(KAP_CHECKOUT_ADD_SKU))
    			return Page.KapPunchIn;
    		else {
    			String sku = url.substring(url.indexOf(KAP_CHECKOUT_ADD_SKU) + KAP_CHECKOUT_ADD_SKU.length(), url.length());
    			return new PageReference(Page.KapPunchIn.getUrl() + '?punchInProductId=' + sku);
    		}
    	}
    	else {
    		boolean found = false;
    		for (String allowedPage: allowedPages) {
    			if (al.StringUtils.containsIgnoreCase(url, allowedPage)) {
    				found = true;
    				break;
    			}
    		}
    		//TODO JLL or Anand - redirect to Kaplan marketting page, not unauth.
    		if (found)
    			return null;
    		else
    			return new PageReference('http://www.kaptest.com');
    	}
    	
	}
	
	/*
	 * Handles rewriting of internal urls to friendly ones.  Currently, not implemented.
	 */
	global List<PageReference> generateUrlFor(List<PageReference> CCUrls) {
		return CCUrls;
	}
	
}