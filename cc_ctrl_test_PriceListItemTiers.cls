@isTest
private class cc_ctrl_test_PriceListItemTiers {

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
		System.debug('-----TokenTest.setupData-userObj----- = ' + userObj);
		testUser = userObj;
    }
    
    static testMethod void myUnitTest() {
    	setupUserData();
		system.runAs(testUser){  
    	
	    	E_PriceListItem__c testItem = new E_PriceListItem__c();
	    	ApexPages.StandardController sc = new ApexPages.StandardController(testItem);
	    	cc_ctrl_PriceListItemTiers testClass = new cc_ctrl_PriceListItemTiers(sc);
	    	boolean buttonVal = testClass.showRemoveButton;
	        system.assertEquals(buttonVal, false);
	        string tierValue = testClass.tierType;
	        system.assertEquals(tierValue,'Tiered');
	        
	    	E_PriceList__c testList = new E_PriceList__c(pricelistid__c='mytestpricelistid');
	    	testList.Name = 'Test Price List';
	    	insert testList;
	    	testItem.Price__c = 2000;
	    	testItem.StartDate__c = datetime.now().date();
	    	testItem.Pricelist__c = testList.id;
	    	insert testItem;
	    	E_RuleTargetPLI__c testRulePLI = new E_RuleTargetPLI__c();
	    	E_Rule__c testRule = new E_Rule__c();
	    	testRule.Enabled__c = true;
	    	testRule.Name__c = 'Test Rule';
	    	testRule.RuleType__c = 'General';
	    	insert testRule;
	    	testRulePLI.E_Rule__c = testRule.id;
	    	testRulePLI.E_PriceListItem__c = testItem.id;
	    	insert testRulePLI;
	    	E_RulePricingModifier__c rpm = new E_RulePricingModifier__c();
	    	
	    	sc = new ApexPages.StandardController(testItem);
	    	testClass = new cc_ctrl_PriceListItemTiers(sc);
	    	
	        buttonVal = testClass.showRemoveButton;
	        system.assertEquals(buttonVal, true);
	        tierValue = testClass.tierType;
	        system.assertEquals(tierValue,'General');
	        
	        testClass.initTierValues();
	        testClass.saveTiers();
	        testClass.removeTiers();
    	}
    }
}