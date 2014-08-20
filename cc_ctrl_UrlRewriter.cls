global with sharing class cc_ctrl_UrlRewriter implements Site.Urlrewriter {

	global static final String PRODUCT_DETAILS_PAGE = '/ProductDetails/';
	global static final String CATEGORY_PAGE = '/Category/';
	
	global PageReference mapRequestUrl(PageReference siteUrl) {
		String url = siteUrl.getUrl();
		System.debug('--- cc_ctrl_UrlRewriter.mapRequestUrl: url=' + url);

    	if(url.contains(cc_ctrl_UrlRewriter.PRODUCT_DETAILS_PAGE)){
	    	String sku = url.substring(url.indexOf(cc_ctrl_UrlRewriter.PRODUCT_DETAILS_PAGE) + cc_ctrl_UrlRewriter.PRODUCT_DETAILS_PAGE.length(), url.length());
   			System.debug('--- cc_ctrl_UrlRewriter.mapRequestUrl: sku=' + sku);
	    	List<E_Product__c> products = [Select SKU__c from E_Product__c where SKU__c = :sku limit 1];
	    	if(products.size() > 0) {
		    	E_Product__c product = products[0];
	    		System.debug('--- cc_ctrl_UrlRewriter.mapRequestUrl: product=' + product);
		        return new PageReference('ProductDetails?sku=' + sku);
	    	} else {
	    		// TODO: send user to page not found page if sku not valid?
	    	}
    	} else if (url.contains(cc_ctrl_UrlRewriter.CATEGORY_PAGE)) {
    		String categoryID = url.substring(url.indexOf(cc_ctrl_UrlRewriter.CATEGORY_PAGE) + cc_ctrl_UrlRewriter.CATEGORY_PAGE.length(), url.length());
   			System.debug('--- cc_ctrl_UrlRewriter.mapRequestUrl: categoryID=' + categoryID);
    		List<E_Category__c> categories = [Select ID from E_Category__c where CategoryID__c = :categoryID limit 1];
    		if(categories.size() > 0) {
    			E_Category__c cat = categories[0];
	    		System.debug('--- cc_ctrl_UrlRewriter.mapRequestUrl: cat=' + cat);
	    		return new PageReference('/Products?categoryId=' + cat.Id);
	    	} else {
	    		// TODO: send user to page not found page if category not valid?
	    	}
    	}
	    return null;
	}

	global List<PageReference> generateUrlFor(List<PageReference> CCUrls) {
		return CCUrls;
	}
}