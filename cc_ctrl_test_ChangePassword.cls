@isTest
private class cc_ctrl_test_ChangePassword {

	private static void prepTestData() {
        cc_test_PrepTestData.loadCustomSettings();
        cc_test_PrepTestData.loadInitData();
	}

    public static testMethod void testCCChangePasswordController() {
    	cc_ctrl_test_ChangePassword.prepTestData();
    	Test.startTest();

        // Instantiate a new controller with all parameters in the page
        PageReference pageRefTemp = System.Page.CCChangePassword;
        pageRefTemp.getParameters().put('cartID','123456789');
        //pageRefTemp.getParameters().put('store',cc_util_CloudCraze.application.Default_Storefront__c);
        pageRefTemp.getParameters().put('retURL','/apex/CCChangePassword');
       // pageRefTemp.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY,'US');
        Test.setCurrentPage(pageRefTemp);
        cc_ctrl_ChangePassword controller = new cc_ctrl_ChangePassword();
        controller.oldPassword = '123456';
        controller.newPassword = 'qwerty1'; 
        controller.verifyNewPassword = 'qwerty1';
        PageReference pageRef = controller.changePassword();          
        //System.debug(pageRef);
        System.assertEquals(pageRef!=null,true);
        
        //System.debug('Prefix : ' + Site.getPrefix());
        //System.debug('CurrentSiteUrl : ' + Site.getCurrentSiteUrl());
        //System.debug('Error Message : ' + Site.getErrorMessage());
        String accountId = cc_util_CloudCraze.getAccountIdByName('PortalAccount');
        
        Test.stopTest();
    }
     
     
    public static testMethod void testCCChangePasswordController2() {
        cc_ctrl_test_ChangePassword.prepTestData();
        Test.startTest();

        // Instantiate a new controller with all parameters in the page
        cc_ctrl_MyAccount myAccount = new cc_ctrl_MyAccount();
        cc_ctrl_ChangePassword controller = new cc_ctrl_ChangePassword(myAccount);
        controller.myAccountController = myAccount;
        controller.changePasswordForMyAccount();
        
        // TODO: Add meaningful assertion
        System.assert(true);
        
        Test.stopTest();
    } 
}