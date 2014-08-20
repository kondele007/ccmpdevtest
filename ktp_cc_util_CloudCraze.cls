public with sharing class ktp_cc_util_CloudCraze {
	 public static E_StorefrontSettings__c storeFrontSettings = null;
	  public static E_ApplicationSettings__c application {
        get {
            application = E_ApplicationSettings__c.getValues(ktp_cc_cnst_CloudCraze.DEFAULT_APPLICATION_NAME);
            System.debug('JLL DEBUG UNIT TESTS ====== ' + application);
            return application;
        }
        set;
    }
	 
	 public static E_StorefrontSettings__c getDefaultStorefrontSettings() {
	        System.debug('JLL UNIT TESTS============' + ktp_cc_util_CloudCraze.application);
	        return ktp_cc_util_CloudCraze.getStorefrontSettings(ktp_cc_util_CloudCraze.application.Default_Storefront__c);
	    }
	
	    public static E_StorefrontSettings__c getStorefrontSettings(String store) {
	        E_StorefrontSettings__c sf = null;
	        
	        if(store != null) {
	            store = store.replaceAll('/', '');
	            System.debug('--- cc_util_CloudCraze.getStorefrontSettings: getting settings for store=' + store);
	    
	            sf = E_StorefrontSettings__c.getValues(store);
	        }
	
	        if(sf == null) {
	            System.debug('--- cc_util_CloudCraze.getStorefrontSettings: getting default storefront=' + ktp_cc_util_CloudCraze.application.Default_Storefront__c);
	            sf = E_StorefrontSettings__c.getValues(ktp_cc_util_CloudCraze.application.Default_Storefront__c);
	        }
	        storeFrontSettings = sf;
	        //System.debug('--- cc_util_CloudCraze.getStorefrontSettings: returning sf=' + sf);
	        return sf;
	    }
	    
	      public static Boolean isGuest()
    {
        return ktp_cc_cnst_CloudCraze.USER_TYPE_GUEST.equals(UserInfo.getUserType());
    }
}