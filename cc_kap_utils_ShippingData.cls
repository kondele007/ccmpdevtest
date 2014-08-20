/**
// * @Description: Utility class to use when passing shipping related data to various classes.
// * @Author: 1.0
// * @File: cc_kap_utils_ShippingData
// * =======================================================================================
// * 2012/09/05 1.1 IL -  Created
**/
public with sharing class cc_kap_utils_ShippingData {
	public String shipMethod { get; set; }
	public Decimal shipCharge { get; set; }
	
	public cc_kap_utils_ShippingData() {
		shipMethod = cc_kap_utils_AppConstants.SHIP_STANDARD;
		shipCharge = 0.0;
	}
}