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
private class cc_ctrl_test_Footer {

    static testMethod void myUnitTest() {
        cc_test_TestDataSetup.loadData();
		cc_api_dl_accountGroups ag = new cc_api_dl_accountGroups();
		ag.loadData();
		
		/*
		Account acc = new Account(name='CloudCrazeTestAccount', E_AccountGroup__r= new E_AccountGroup__c(ACCOUNTGROUPID__C='1'), OwnerId=userInfo.getUserId());
		insert acc;
		*/
		RecordType rt = [Select r.Name, r.Id From RecordType r where r.Name = 'Person Account' limit 1];
		
		Account acc = new Account(LastName='CloudCrazeTestAccount', RecordTypeID = rt.Id, E_AccountGroup__r= new E_AccountGroup__c(ACCOUNTGROUPID__C='1'), OwnerId=userInfo.getUserId());
		insert acc;
	    	System.RunAs(cc_test_TestDataSetup.testUser){
	    	E_StorefrontSettings__c setting = new E_StorefrontSettings__c(
	    	  name='ab',
	    	  Site_Secure_Domain__c='www.salesforce.com'
	    	);
	    	insert setting;
	    	cc_ctrl_footer nullStore = new cc_ctrl_footer();
	    	ApexPages.currentPage().getParameters().put('store','ab');
	    	cc_ctrl_footer controller = new cc_ctrl_footer();
	    	System.assertEquals('ab',controller.storeID);
	    	System.assertEquals('https://www.salesforce.com/ab/',controller.storeSSLUrl);
	    	cc_ctrl_footer catController = new cc_ctrl_footer(new cc_ctrl_HomePage());
	    	cc_ctrl_footer stanController = new cc_ctrl_footer(new ApexPages.Standardcontroller(acc));
    	}
    }
}