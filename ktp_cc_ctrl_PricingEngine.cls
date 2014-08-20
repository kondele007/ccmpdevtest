public with sharing class ktp_cc_ctrl_PricingEngine {
	 public static map<String, Decimal> getBasePrice(List<String> prodIds) {
			System.debug('--- cc_ctrl_PricingEngine.getBasePrice: prodIds=' + prodIds);
			map<String, Decimal> priceMap = new map<String, Decimal>();
			String basePriceList = ktp_cc_cnst_CloudCraze.BASE_PRICE_LIST_NAME;
			System.debug('--- cc_ctrl_PricingEngine.getBasePrice: basePriceList=' + basePriceList);
			
			for(ccrz__E_PriceListItem__c pli : [Select e.ccrz__Product__r.ccrz__sku__c, e.ccrz__Pricelist__c, e.ccrz__Price__c From ccrz__E_PriceListItem__c e 
				where e.ccrz__Product__r.ccrz__sku__c in :prodIds and e.ccrz__Pricelist__r.name= :basePriceList and e.ccrz__StartDate__c <= TODAY and e.ccrz__EndDate__c > TODAY]) {
				
				System.debug('--- cc_ctrl_PricingEngine.getBasePrice: adding pli=' + pli + ', pli.product__r=' + pli.ccrz__product__r);
				priceMap.put(pli.ccrz__product__r.ccrz__sku__c, pli.ccrz__Price__c);
			}
			System.debug('--- cc_ctrl_PricingEngine.getBasePrice: returning priceMap=' + priceMap);
			return priceMap; 
	    }
	
		public static map<String, Decimal> getBasePrice(List<String> prodIds, String currencyCode, String customerType) {
			Map<String, Decimal> priceMap = new Map<String, Decimal>();
			String basePriceList = ktp_cc_cnst_CloudCraze.BASE_PRICE_LIST_NAME;
			List<ccrz__E_PriceListItem__c> pricelines = [Select e.ccrz__Product__r.ccrz__sku__c, e.ccrz__Pricelist__c, e.ccrz__Price__c From ccrz__E_PriceListItem__c e  where e.ccrz__Product__r.ccrz__sku__c in :prodIds and e.ccrz__Pricelist__r.name= :basePriceList and e.ccrz__Pricelist__r.ccrz__CurrencyISOCode__c= :currencyCode and e.ccrz__StartDate__c <= TODAY and e.ccrz__EndDate__c > TODAY];
			for (ccrz__E_PriceListItem__c pli : pricelines)
				priceMap.put(pli.ccrz__product__r.ccrz__sku__c, pli.ccrz__Price__c);
			return priceMap; 
	    }
}