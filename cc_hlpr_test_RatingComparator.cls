/* ============================================================
 * Unit test for cc_hlpr_test_RatingComparator
 *
 * ============================================================
 */
@IsTest
private class cc_hlpr_test_RatingComparator {
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
		System.debug('-----cc_hlpr_test_RatingComparator.setupData-userObj----- = ' + userObj);
		testUser = userObj;
    } 
    
	private static testmethod void testRatingComparator()
	{
		setupUserData();
     	System.runAs(testUser){
		cc_hlpr_RatingComparator comparator = new cc_hlpr_RatingComparator();
		cc_bean_ProductListViewData object1 =  new cc_bean_ProductListViewData();
		cc_bean_ProductListViewData object2 =  new cc_bean_ProductListViewData();
		object1.averageReview = 10.00;
		object2.averageReview = 0.00;				
		System.assertEquals(comparator.compare(object1, object2), 1);

		object1.averageReview = 0.00;
		object2.averageReview = 10.00;				
		System.assertEquals(comparator.compare(object1, object2), -1);
     	}		
	}

}