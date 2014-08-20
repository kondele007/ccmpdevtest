public with sharing class cc_kap_ctrl_SSOCookieData extends cc_ctrl_Cloudcraze {
	public String cartShippingMethods { get; set; }
	public boolean cartShippingFlag  { get; set; }
	public boolean cartShowBillingFlag { get; set; }
	public String programCode { get; set; }
	public Integer cartItemCount { get; set; }
	
	public cc_kap_ctrl_SSOCookieData() {
		cartShippingFlag = Boolean.valueOf(ApexPages.currentPage().getParameters().get('cartShippingFlag'));
		cartItemCount = Integer.valueOf(ApexPages.currentPage().getParameters().get('cartItemCount'));
		programCode = ApexPages.currentPage().getParameters().get('programCode');
		cartShowBillingFlag = Boolean.valueOf(ApexPages.currentPage().getParameters().get('cartShowBillingFlag'));
	}
	
	
}