public with sharing class cc_kapmp_outboundOrder  implements ccrz.cc_if_OutboundOrder {
	
	public ccrz.cc_svc_IOutboundOrder serviceObj;
    public ccrz.cc_dao_IOutboundOrder daoObj;
    public Map<String, Object> storeSettings;
        
    public void setDaoObject(ccrz.cc_if_dao obj) {
        daoObj = (ccrz.cc_dao_IOutboundOrder) obj;
    }
    
    public void setServiceObject(ccrz.cc_if_service obj) {
        serviceObj = (ccrz.cc_svc_IOutboundOrder) obj;
    }
    
    public void setStorefrontSettings(Map<String, Object> storeSettings) {
        this.storeSettings = storeSettings;
    }
	
		public Map<String, String> sendOrder(String orderId, String storeName, boolean skipEligibility)
		{
			System.debug(logginglevel.info, 'sendOrder order id =' + orderID);
			//SOQL example Below. Add the fields you need to the SOQL.
			List<ccrz__E_Order__c> orders = [Select Name from ccrz__E_Order__c where ID = : orderID];
			for(ccrz__E_Order__c ccorder: orders)
			{	
				//ccorder.sendOrderEmail__c = true;
				//upsert ccorder;
			}
			// CALL YOUR SERVICE METHODS HERE.
			return null;
		}
		
		public Map<String, String> sendOrder(Map<String, Object> dataMap, String storeName, boolean skipEligibility)
		{
			return null;
		}
	

}