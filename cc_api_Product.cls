public with sharing class cc_api_Product {
	
	public static List<cc_bean_ProductTab> getProductTabBeans(List<E_ProductTab__c> tabs) {
		List<cc_bean_ProductTab> beans = new List<cc_bean_ProductTab>();

		if(tabs != null) {
			for(E_ProductTab__c tab : tabs) {
				beans.add(new cc_bean_ProductTab(tab));
			}
		}
		
		return beans;
	}
	
	public static String getShortURL(String sku, String storeID) {
		String shortURL = null;
		if(sku != null && storeID != null) {
			E_ProductStorefront__c psf = cc_dao_Product.getProductStorefront(sku, storeID);
			if(psf != null) {
				shortURL = psf.ShortURL__c;
			}
		}
		return shortURL;
	}

}