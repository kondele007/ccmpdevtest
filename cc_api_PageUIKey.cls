public with sharing class cc_api_PageUIKey {
	public static string removeNamespace(string pageName) {
		string retname = pageName;
		string namespace = cc_util_cloudcraze.localNamespace;
		integer index = retname.indexOf(namespace);
		if(index != -1) {
			retname = retname.substring(index+namespace.length());
		}
		return retname;
	}
    //==================================================
    // STATIC HELPER METHODS
    //==================================================
    public static String getUIKeyForPage(String pageName) {
    	String pageUIKey = null;

    	if(pageName != null) {
    		PageUIKey__c keySetting = PageUIKey__c.getInstance(cc_api_PageUIKey.removeNamespace(pageName.toLowerCase()));
    		if(keySetting != null) {
	    		pageUIKey = keySetting.Value__c;
    		}
    	}

		if(pageUIKey != null) {
			pageUIKey = pageUIKey.toLowerCase();
		}

		System.debug(Logginglevel.INFO, '--- cc_api_PageUIKey.getUIKeyForPage: pageName=' + pageName + ', returning pageUIKey=' + pageUIKey);
		return pageUIKey;
    }

    //==================================================
    // TEST METHODS
    //==================================================
    static testMethod void testGetPageUIKeys() {
    	cc_hlpr_InitLoadCustomSettings.loadTestPageUIKeys();
    	System.assertEquals('homepage', cc_api_PageUIKey.getUIKeyForPage('HomePage'));
    	System.assertEquals('error', cc_api_PageUIKey.getUIKeyForPage('CCException'));
    	System.assertEquals(null, cc_api_PageUIKey.getUIKeyForPage(null));
    	System.assertEquals(null, cc_api_PageUIKey.getUIKeyForPage(''));
    	System.assertEquals(null, cc_api_PageUIKey.getUIKeyForPage('doesntexist'));
    	string pageName =  cc_util_cloudcraze.localNamespace + 'HomePage';
    	System.assertEquals('homepage',cc_api_PageUIKey.removeNamespace(pageName).toLowerCase());
    	System.assertEquals('homepage', cc_api_PageUIKey.getUIKeyForPage(pageName));
    	PageReference pf = System.page.HomePage;
    	Test.setCurrentPage(pf);
    	
    	System.assertEquals('homepage', cc_api_PageUIKey.getUIKeyForPage(cc_util_CloudCraze.getCurrentPageName()));
    } 
}