public class ktp_GR_OrderDO {
	ccrz__e_order__c orderObject = null;
	List<ccrz__e_orderItem__c> orderItemList = new List<ccrz__e_orderItem__c>();
	List<ccrz__e_cartitem__c> cartItemList = new List<ccrz__e_cartitem__c>();	
	String orderId {get:set;}
	
	public ktp_GR_OrderDO(String orderId) {
       this.orderId = orderId;
	}
	
	private void initOrder() {
		// query for all sobjects required by getreal
	    List<sobject> orderList = [select id from ccrz__e_order__c where id = :orderId];
	    orderObject = orderList.get(0);
	    orderItemList = [select id from ccrz__e_orderitem__c where orderId__c = :orderId];	    
	}
	
	public List<KapGetRealCCOrderItemVO> getOrderItems() {
		return null;
	}
	
	public List<KapGetRealPaymentVO> getPayments() {
		return null;
	}
	
	public KapGetRealCloudCrazeOrderVO transformData() {		
		KapGetRealCloudCrazeOrderVO orderVO = new KapGetRealCloudCrazeOrderVO();
		return orderVO;
	}
}