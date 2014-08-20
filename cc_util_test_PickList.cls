/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */ 
@isTest
private class cc_util_test_PickList {

    static testMethod void getPicklistValuesTest() {
    	cc_test_TestDataSetup.loadData();
	    	System.runas(cc_test_TestDataSetup.testUser) {
	    	System.assert(true);
	    	/* CC SaaS Mod - Schema Change - removed E_GuidedSellingProfile__c
	        List<SelectOption> picklist = cc_util_Picklist.addNonOption(cc_util_Picklist.getPicklistValues(E_GuidedSellingProfile__c.BusinessType__c.getDescribe()));
	        
	        system.debug('----cc_util_test_PickList picklist ----'+picklist);
	        
	        system.assert(picklist != null);
	        */
	        
	        List<SelectOption> picklist = cc_util_Picklist.getUserSalutations();
	        system.debug('----cc_util_test_PickList getUserSalutations ----'+picklist);
	        system.assert(picklist != null);
	        
	        picklist = cc_util_Picklist.getUserIndustries();
	        system.debug('----cc_util_test_PickList getUserIndustries ----'+picklist);
	        system.assert(picklist != null);
	        
	        picklist = cc_util_Picklist.getCompanyTypes();
	        system.debug('----cc_util_test_PickList getCompanyTypes ----'+picklist);
	        system.assert(picklist != null);
	        
	        picklist = cc_util_Picklist.getUserContactTypes();
	        system.debug('----cc_util_test_PickList getUserContactTypes ----'+picklist);
	        system.assert(picklist != null);
	        
	        picklist = cc_util_Picklist.getLanguageOptionsList(cc_util_CloudCraze.getDefaultStorefrontSettings());
	        system.debug('----cc_util_test_PickList getUserContactTypes ----'+picklist);
	        system.assert(picklist != null); 
	        
	        picklist = cc_util_Picklist.getCountryOptionsList();
	        system.debug('----cc_util_test_PickList getUserContactTypes ----'+picklist);
	        system.assert(picklist != null); 
	        
	        for(SelectOption option : picklist) {
		        List<SelectOption> states = cc_util_Picklist.getStateOptionsList(option.getValue());
		        system.debug('----cc_util_test_PickList getUserContactTypes ----'+states);
		        system.assert(states != null);
	        }
	        
	        picklist = cc_util_Picklist.getAllStateOptionsList();
	        system.debug('----cc_util_test_PickList getUserContactTypes ----'+picklist);
	        system.assert(picklist != null); 
	        
	        picklist = cc_util_Picklist.getStateOptionsWithCountryCode();
	        system.debug('----cc_util_test_PickList getUserContactTypes ----'+picklist);
	        system.assert(picklist != null); 
	        
	        picklist = cc_util_Picklist.getCurrencyOptions(Schema.sObjectType.User.fields.getMap(), cc_util_CloudCraze.getDefaultStorefrontSettings());
	        system.debug('----cc_util_test_PickList getUserContactTypes ----'+picklist);
	        system.assert(picklist != null);
	        
	        
    	}
    }
}