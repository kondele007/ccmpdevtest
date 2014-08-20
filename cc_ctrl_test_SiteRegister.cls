@isTest
private class cc_ctrl_test_SiteRegister {
 
    private static void prepTestData() {
        cc_test_PrepTestData.loadCustomSettings();
        cc_test_PrepTestData.loadInitData();
    }

	static testMethod void testRegistrationWithExceptions() {
	   	User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
	   	System.runAs (thisUser) {
	   	    cc_ctrl_test_SiteRegister.prepTestData();
	   	}
   	    Test.startTest();
   	    
        cc_ctrl_SiteRegister controller = new cc_ctrl_SiteRegister();
        controller.initTestData();
	    controller.registerUser();
	    controller.createUser();
	     Test.stopTest();   
        
   
    }
   static testMethod void testRegistration() {
   	User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
   	System.runAs (thisUser) {
   	    cc_ctrl_test_SiteRegister.prepTestData();
   	}
   	
   	//User guest = [SELECT Id FROM User WHERE UserType = 'Guest' limit 1];
   	//System.runAs (guest) {
   	    Test.startTest();
   	    
        cc_ctrl_SiteRegister controller = new cc_ctrl_SiteRegister();
        controller.username = 'test@force.com';
        //controller.email = 'test@force.com';
        controller.communityNickname = 'test';
        
        
        controller.password = 'abcd123';
        controller.confirmPassword = 'abcd123';
         
	    controller.firstName = 'Dummy F Name';
	    controller.lastName = 'Dummy L Name';
	    
	    controller.userSalutation = 'Mr.';
	    controller.position_title = 'Position Title';
	    controller.department = 'None';
	    controller.companyName ='Company name';
	    controller.companyType = 'ISP';
	    controller.usercontactTypeRole = 'ContactRole';
	    
	    
	    controller.userIndustry = 'User Industry';
	    controller.shipStreet1 = 'Ship Street';
	    
	    controller.shipCity = 'Ship City';
	    controller.shipState = 'IL';
	    controller.shipCountry = 'US';
	    controller.shipPostalCode = '12345';
	   
	    controller.billStreet1 = 'Bill Street 1';
	    controller.billStreet2 = 'Bill Street 2';
	    controller.billCity = 'Bill City';
	    controller.billState = 'IL';
	    controller.billCountry = 'US';
	    controller.billPostalCode ='12345';
	    
	    controller.currencyCode = 'CAD';
	    controller.language = 'en-US';
	    controller.registerUser();
	     Test.stopTest();   
        //System.assert(controller.registerUser() != null);  
        controller.determineStartUrl();
        controller.username = UserInfo.getUserName();
        controller.cartProcessing();
        
       
   	//}     
    }
    
    static testMethod void testCreatePersonAccount() {
    	cc_test_PrepTestData.loadCustomSettings();
    	cc_test_PrepTestData.loadInitData();
    	User testPortalUser = cc_test_PrepTestData.insertPortalUser('test1');
	   	System.runAs (testPortalUser) {
	   		
	   	
			E_ContactAddr__c shipTo = new E_ContactAddr__c(
		    	AddressFirstline__c='100 Pine Street', City__c='SmallTown', DaytimePhone__c='(847) 555-1212',
		        FirstName__c='Craig', HomePhone__c='(847) 555-1212', LastName__c='Traxler',
		        PostalCode__c='60601', State__c='Idaho', StateISOCode__c='ID',
		        CountryISOCode__c='USA');
		    insert shipTo;
		    E_ContactAddr__c billTo = new E_ContactAddr__c(
		        AddressFirstline__c='100 Pine Street', City__c='SmallTown', DaytimePhone__c='(847) 555-1212',
		        FirstName__c='Craig', HomePhone__c='(847) 555-1212', LastName__c='Traxler',
		        PostalCode__c='60601', State__c='Idaho', StateISOCode__c='ID',
		        CountryISOCode__c='USA');
		    insert billTo; 
		    String shippingAddress = JSON.serialize(shipTo);
		    String billingAddress = JSON.serialize(billTo);
		    Id userId = userInfo.getUserId();
		        
		   	//User guest = [SELECT Id FROM User WHERE UserType = 'Guest' limit 1];
		   	//System.runAs (guest) {
		   	   
		   	    
		     cc_ctrl_SiteRegister.createPersonAccount(userId, shippingAddress, billingAddress, 'company name', 'PortalAccount', cc_util_CloudCraze.getDefaultStorefrontSettings().eCommerceType__c, userId);
		   	  
	   	}
	   	
    }
    
    // Test method to bring this class's test coverage over the required 75%
    static testMethod void testGetItems() {
        cc_ctrl_test_SiteRegister.prepTestData();
        Test.startTest();

        cc_ctrl_SiteRegister controller = new cc_ctrl_SiteRegister();
        List<SelectOption> items = controller.getItems();
        for(SelectOption option : items) {
            //System.debug('--- testGetItems: Id='+option.getValue() + ', Name='+option.getLabel() + ' ---');
        }
        System.assert(controller.getItems().size() != 0);    
        
        Test.stopTest();
    }

    static testMethod void testOptionsMethods() {
        cc_test_TestDataSetup.loadData();
    	System.RunAs(cc_test_TestDataSetup.testUser){
    	E_StorefrontSettings__c settings = cc_util_CloudCraze.getDefaultStorefrontSettings();
    	settings.Customer_Portal_Account_Name__c ='CloudCrazeTestAccount';
    	update settings;
        Test.startTest();

        cc_ctrl_SiteRegister controller = new cc_ctrl_SiteRegister();
        System.assertNotEquals(null, controller.getStateOptionsUS());
        System.assertNotEquals(null, controller.getSalutation());
        System.assertNotEquals(null, controller.getIndustry());
        System.assertNotEquals(null, controller.getContactTypeRole());

        List<SelectOption> items = controller.getItems();
        //for(SelectOption option : items) {
            //System.debug('--- testGetItems: Id='+option.getValue() + ', Name='+option.getLabel() + ' ---');
        //}
        System.assertNotEquals(0, controller.getItems().size());
        
        Test.stopTest();
    	}
    }
   
}