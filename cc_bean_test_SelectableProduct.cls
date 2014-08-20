/* ============================================================
 * Unit test for cc_bean_test_SelectableProduct
 *
 * ============================================================
 */
@IsTest
private class cc_bean_test_SelectableProduct { 
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
		//System.debug('-----cc_bean_test_SelectableProduct.setupData-userObj----- = ' + userObj);
		testUser = userObj;
    } 
    
 	private static testmethod void testSelectableProduct(){  
		setupUserData();
     	System.runAs(testUser){
			cc_bean_SelectableProduct product = new cc_bean_SelectableProduct();
			cc_bean_ProductListViewData data = new cc_bean_ProductListViewData();
			data.name =  'test';
			product.productListViewData = data; 
		 	product.selected = true;
		 	
			System.assertEquals(product.productListViewData, data);
			System.assertEquals(product.selected, true); 	
     	}
 	}

}