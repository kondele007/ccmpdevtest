@isTest
private class cc_api_dl_productDataLoaderBaseTest {

	static testMethod void unitTest() {
		cc_api_dl_productDataLoaderBase priceLists = new cc_api_dl_priceLists();
		String staticResourceUrl = priceLists.getStaticResourceUrl();
		System.assertNotEquals(staticResourceUrl, null);
		//System.debug('staticResourceUrl='+staticResourceUrl);
	}

}