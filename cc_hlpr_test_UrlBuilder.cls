/* ============================================================
 * Unit test for cc_hlpr_UrlBuilder
 *
 * ============================================================
 */
@IsTest
private class cc_hlpr_test_UrlBuilder {
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
		System.debug('-----cc_hlpr_test_UrlBuilder.setupData-userObj----- = ' + userObj);
		testUser = userObj;
    }

	private static testMethod void testUrlBuilder() {
	    setupUserData();
     	System.runAs(testUser){		
			cc_hlpr_UrlBuilder cc_hlpr_UrlBuilder = new cc_hlpr_UrlBuilder('http://www.google.com', false);
			cc_hlpr_UrlBuilder = cc_hlpr_UrlBuilder.append('searchString', 'FidoTracker');
			List<String> values = new List<String>{'1'};
			cc_hlpr_UrlBuilder.appendall('results', values);
			String url = cc_hlpr_UrlBuilder.toMyString();
			System.assertEquals(url, 'http://www.google.com?searchString=FidoTracker&results=1');
     	}
	}

}