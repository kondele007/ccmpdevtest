public with sharing class cc_ctrl_GoogleAnalytics {
	public cc_ctrl_CloudCraze cloudCrazeController { get; set; }
	public list<string> getGAAttributeNames() {
		list<string> ret = new list<string>();
		map<string, list<string>> gaMap = cloudCrazeController.getGoogleAnalyticsAttributes();
		for(string n : gaMap.keyset()) {
			ret.add(addQuoteToName(n, '\''));
		}
		return ret;
	}
	public map<string, string> getGAAttributeMap() {
		map<string, list<string>> gaMap = cloudCrazeController.getGoogleAnalyticsAttributes();
		map<string, string> gaRet = new map<string, string>();
		for(string n : gaMap.keyset()) {
			gaRet.put(addQuoteToName(n, '\''), array2string(gaMap.get(n)));
		}
		return gaRet;
	}
	private string addQuoteToName(string name, string quoteString) {
		return quoteString + name + quoteString;
	}
	private string array2string(list<string> aList) {
		string attributes = '';
		for(string a : aList) {
			attributes += addQuoteToName(a, '\'') + ',';
		}
		integer index = attributes.lastIndexOf(',');
		if(index != -1 && index == attributes.length() -1 ) {
			attributes = attributes.substring(0, index);
		}
		return attributes;
	}
	
	@isTest static void myUnitTest() {
	 	cc_test_TestDataSetup.loadData();

		System.runAs(cc_test_TestDataSetup.testUser) {
			cc_ctrl_ProductDetail productDetailController = new cc_ctrl_ProductDetail();
			cc_ctrl_GoogleAnalytics ga = new cc_ctrl_GoogleAnalytics();
			PageReference productDetails = System.Page.ProductDetails;
			Test.setCurrentPage(productDetails);
			ga.cloudCrazeController = productDetailController.getProductDetailController();
			system.assert(ga.getGAAttributeNames().size() > 0);
			system.assert(ga.getGAAttributeMap().size() > 0);
			
			
		}
	 }
	
}