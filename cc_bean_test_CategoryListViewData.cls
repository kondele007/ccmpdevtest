@isTest
private class cc_bean_test_CategoryListViewData {
	static User testUser;
	static Account testAccount;
	
   private static void setupUserData(){
        //System.debug('ACCOUNT ID : ' + cc_util_CloudCraze.getAccountID());
        //System.assertEquals('0018000000Sk7oB', cc_util_CloudCraze.getAccountID());
        //User existingAdminUser = [SELECT id, profileId, userRoleId FROM User WHERE UserRoleId <> null AND Profile_Name__c='System Administrator' LIMIT 1];
        //System.assert(existingAdminUser != null, 'This test depends on an existing system admin user to run');

        //String portalProfileName = E_ApplicationSettings__c.getValues('CloudCraze').Portal_Profile_Name__c;
        //System.assert(portalProfileName !=null , 'This test depends on populating Portal Profile Name on CloudCraze Application setting. Please populate');

		//String profileId='';
		//for(Profile p:[Select p.name, p.id From Profile p where p.Name=:portalProfileName]) {
		//	profileId=p.Id;
		//	break;
		//}
    	Profile profile = [Select Id From Profile Where name = 'System Administrator' Limit 1];
		        
        String randomUserName = String.valueOf(System.now().getTime()) + '@fido.com';
        
        User userObj = new User(alias = 'flotv', email='fido@fido.com',
        emailencodingkey='UTF-8', lastname='TestUser1', languagelocalekey='en_US',
        localesidkey='en_US', profileid = profile.Id,
        timezonesidkey='America/Los_Angeles', username=randomUserName, isActive=true);
       
        
        userObj.Email = 'test@te.com';
        userObj.Phone = '5555555555';        
		cc_api_dl_accountGroups ag = new cc_api_dl_accountGroups();
		ag.loadData();

		RecordType rt = [Select r.Name, r.Id From RecordType r where r.Name = 'Person Account' limit 1];
		
		Account acc = new Account(LastName='Test Account',RecordTypeID = rt.Id, E_AccountGroup__r= new E_AccountGroup__c(ACCOUNTGROUPID__C='1'), OwnerId=userInfo.getUserId());
		insert acc;
		
		testAccount = acc; 
		
        insert userObj; 

        System.assert(userObj.Id != null);    	 
		//System.debug('-----QC_PersonAccountDAOTest.setupData-userObj----- = ' + userObj);
		testUser = userObj;
    } 	
    
    private static testMethod void getPersonAccountReferenceTest() {
    	setupUserData();
		System.runAs(testUser)
		{
			cc_bean_CategoryListViewData data = new cc_bean_CategoryListViewData();
			data.category = new E_Category__c();
			data.Alt_Message = '';
			//data.attachmentId = new Id();
			System.assertNotEquals(null, data);	
		}
	}

}