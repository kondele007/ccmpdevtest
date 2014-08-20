public with sharing class cc_kap_admin_OrderResubmit {
	public static PageReference submitToGetReal(){
		String orderId = ApexPages.currentPage().getParameters().get('orderId');
		if(orderId != null && orderId.length() > 0)
			cc_kap_impl_services.callKaplanStudentPlaceOrderGetRealOnly(orderId);
		return null;
	}
	
	public static PageReference submitToRTCAP(){
		String orderId = ApexPages.currentPage().getParameters().get('orderId');
		if(orderId != null && orderId.length() > 0)
			cc_kap_impl_services.callKaplanStudentPlaceOrderRTCAPOnly(orderId);
		return null;
	}
}