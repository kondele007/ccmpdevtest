/* ============================================================
 * Unit test for cc_hlpr_ShippingAndHandlingSvcFactory
 *
 * ============================================================
 */
@IsTest 
private class cc_hlpr_test_ShippingHandlingSvcFactory {
	static User testUser;
   private static void setupUserData(){
    	Profile profile = [Select Id From Profile Where name = 'System Administrator' Limit 1];
        
        String randomUserName = String.valueOf(System.now().getTime()) + '@fido.com';
        
        User userObj = new User(alias = 'flotv', email='fido@fido.com',
        emailencodingkey='UTF-8', lastname='TestUser1', languagelocalekey='en_US',
        localesidkey='en_US', profileid = profile.Id,
        timezonesidkey='America/Los_Angeles', username=randomUserName, isActive=true);
        insert userObj;

        System.assert(userObj.Id != null);    	 
		System.debug('-----cc_hlpr_test_ShippingHandlingSvcFactory.setupData-userObj----- = ' + userObj);
		testUser = userObj;
    } 
    
   	
  	private static testmethod void testShippingAndHandlingServicesFactory(){   	
		setupUserData();
		cc_hlpr_InitLoadCustomSettings.loadCloudCrazeApplicationSettings();
	    cc_hlpr_InitLoadCustomSettings.loadCloudCrazeStorefrontSettings();
     	System.runAs(testUser){   
     		E_StorefrontSettings__c storefront = E_StorefrontSettings__c.getInstance();
     		cc_svc_IShippingAndHandling service = cc_hlpr_ShippingAndHandlingSvcFactory.getShippingAndHandlingService(storefront);
     		storefront.UseUPSShipping__c=true;
			 service = cc_hlpr_ShippingAndHandlingSvcFactory.getShippingAndHandlingService(storefront);		
			storefront.UseUPSShipping__c=false;
			storefront.UseFexExShipping__c=true;
			 service = cc_hlpr_ShippingAndHandlingSvcFactory.getShippingAndHandlingService(storefront);
			System.assert(service != null);				
     	}
	}
}