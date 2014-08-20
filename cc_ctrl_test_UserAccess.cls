/* ============================================================
 * Unit test for cc_ctrl_UserAccess
 *
 * ============================================================
 */
@IsTest
private class cc_ctrl_test_UserAccess {

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
		System.debug('-----cc_ctrl_UserAccess.setupData-userObj----- = ' + userObj);
		testUser = userObj;
    }

   private static void setupMiscData(){
    	setupUserData();
   }
   
   	private static List<E_Category__c> insertData(){
		List<E_Category__c> listCategory=new List<E_Category__c>();
        
        E_Category__c rootCategory=new E_Category__c();
        rootCategory.Name='Root';
        rootCategory.Sequence__c=0;
        rootCategory.CategoryID__c='123';
        insert rootCategory;
   
        E_Category__c bioTechCategory=new E_Category__c();
        bioTechCategory.Name='Biotech';
        bioTechCategory.Sequence__c=100;
        bioTechCategory.ShortDesc__c='Biotech Category';
        bioTechCategory.ParentCategory__c=rootCategory.Id;
        bioTechCategory.CategoryID__c='789';
        insert bioTechCategory;
        
         E_Category__c envCategory=new E_Category__c();
        envCategory.Name='Env';
        envCategory.Sequence__c=100;
        envCategory.ShortDesc__c='Env Category';
        envCategory.CategoryID__c='567';
        envCategory.ParentCategory__c=rootCategory.Id;
        insert envCategory;
        
        E_Category__c xyzCategory=new E_Category__c();
        xyzCategory.Name='Palm';
        xyzCategory.Sequence__c=200;
        xyzCategory.ShortDesc__c='Palm Category';
        xyzCategory.CategoryID__c='612';
        xyzCategory.ParentCategory__c=bioTechCategory.Id;
        insert xyzCategory;
        
        Integer i;
        for(i=1;i<=10;i++){
             E_Category__c cat = new E_Category__c();
             cat.Name = 'xyz'+i;         
             cat.ParentCategory__c=xyzCategory.Id;
             cat.ShortDesc__c='xyz_category'+i;
             cat.Sequence__c=100;
             cat.CategoryID__c='avc'+i;
             listCategory.add(cat);
        }
        
         for(i=1;i<=10;i++){
             E_Category__c cat = new E_Category__c();
             cat.Name = 'xyz'+i;         
             cat.ParentCategory__c=envCategory.Id;
             cat.ShortDesc__c='abc_category'+i;
             cat.Sequence__c=100;
             cat.CategoryID__c='abc'+i;
             listCategory.add(cat);
        }
        
        return listCategory;
		
	}
   
   private static testmethod void testStartHere(){
	setupUserData();
	setupMiscData();
	System.runAs(testUser){
        List<E_Category__c> insertList=insertData();
        insert insertList;		
		ApexPages.StandardController controller = new ApexPages.StandardController(insertList[0]);
		
		cc_ctrl_UserAccess ucontroller = new cc_ctrl_UserAccess(controller);
		boolean access = ucontroller.getCanAccess();
		System.assertEquals(access, true);				
	}
}

}