public with sharing class cc_svc_ShippingAndHandlingGeneric implements cc_svc_IShippingAndHandling {
	public cc_bean_ShippingOptionsRequest shippingOptionsRequest {get; set;}
    private String storeID {get;set;}
    private E_StorefrontSettings__c storefront {get;set;}
	public cc_svc_ShippingAndHandlingGeneric(E_StorefrontSettings__c storefront) {
        this.storefront = storefront;
    }
    
	public cc_bean_ShippingOptions getShippingAndHandlingRates(cc_bean_ShippingOptionsRequest shippingRequest) { 
		//System.debug('getShippingAndHandlingRates-->');
		cc_bean_ShippingOptions shippingOptions = new cc_bean_ShippingOptions(cc_cnst_UPSXMLTag.SHIPPINGPROVIDER, true);
		
		List<cc_bean_ShippingServicesAndCostDetails> shippingServicesAndCostList = new List<cc_bean_ShippingServicesAndCostDetails>();
		
   		shippingServicesAndCostList.add(new cc_bean_ShippingServicesAndCostDetails('Ground (4 to 6 days) $7.99', 'USD', '7.99', '0.00'));
   		shippingServicesAndCostList.add(new cc_bean_ShippingServicesAndCostDetails('Priority (3 to 5 days) $12.99', 'USD', '12.99', '0.00'));
   		shippingServicesAndCostList.add(new cc_bean_ShippingServicesAndCostDetails('Express (Overnight) $21.99', 'USD', '21.99', '0.00'));
   		shippingOptions.shippingServicesAndCostDetails = shippingServicesAndCostList;
   		//System.debug('getShippingAndHandlingRates-->' + shippingOptions);
		return shippingOptions;
	}
}