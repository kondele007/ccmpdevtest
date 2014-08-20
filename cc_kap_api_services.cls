/*
* public API class for integrating with Kaplan's business systems.
*/
public with sharing class cc_kap_api_services {
	
	public static Boolean sendCustomerInfoToKaplan(String userId){
		/*
		Boolean bSuccess = true;
		try{
			cc_kap_impl_services.callKaplanStudentUpdateProfile(userId);
		}
		catch(Exception e){
			System.debug('---------Kaplan Integration Failed---------:' + e);
			bSuccess = false;
		}
		//TODO jll - for testing purposes always return true so OOTB flow doesn't break but can still be wired in
		//return bSuccess;
		*/
		return true;
	}

	@future(callout=true)
	public static void sendOrderToKaplan(Id orderId){
		Boolean bSuccess = true;
		try{
			cc_kap_impl_services.callKaplanStudentPlaceOrder(orderId);
		}
		catch(Exception e){
			System.debug('---------Kaplan Integration Failed---------:' + e);
			System.debug('---------Kaplan Integration Failed---------:' + e.getStackTraceString());
			bSuccess = false;
		}
		//TODO jll - for testing purposes always return true so OOTB flow doesn't break but can still be wired in
		//return bSuccess;
		//return true;
	}	
}