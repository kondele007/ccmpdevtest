//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
@isTest
private class cc_ctrl_test_SiteLogin {

    private static void prepTestData() {
        cc_test_PrepTestData.loadCustomSettings();
        cc_test_PrepTestData.loadInitData();
    }

    public static testMethod void testCCSiteLoginController1() {
        cc_test_PrepTestData.loadCustomSettings();
        Test.startTest();
        
        // Instantiate a new controller with all parameters in the page
        cc_ctrl_SiteLogin controller = new cc_ctrl_SiteLogin ();
        controller.username = 'test@salesforce.com';
        controller.password = '123456';
        System.assertNotEquals(null, controller.login());
        
        Test.stopTest();
    }


    public static testMethod void testCCSiteLoginController2() {
        cc_ctrl_test_SiteLogin.prepTestData();
        Test.startTest();

        cc_api_Cart api = new cc_api_Cart();
        String customerType = 'Commercial';
        E_Cart__c cart = api.createEmptyCart('USD', 'Commercial');
        List<E_Product__c> productList = cc_test_PrepTestData.insertProduct(2);
        for(E_Product__c prod:productList){
            api.addToCart(prod.Id, cart.Id, 1,false, 'USD',
                          'Commercial', cc_util_CloudCraze.application.Default_Storefront__c);
        }

        PageReference pageRef = new PageReference('/apex/HomePage');
        pageRef.getParameters().put('viewState','checkout');
        pageRef.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY,'US');
        pageRef.getParameters().put('CartID',cart.EncryptedID__c);
        Test.setCurrentPage(pageRef);
        cc_ctrl_SiteLogin controller2 = new cc_ctrl_SiteLogin ();

        controller2.username = 'test@force.com';
        controller2.password = 'abcd123';
        System.assertNotEquals(null, controller2.login());

        //User usr = cc_test_PrepTestData.insertPortalUser('TestLoginUser1');
        //controller2.username = usr.Username;
        controller2.username = UserInfo.getUserName();
        controller2.wasCartAnonymous = true;
        controller2.handleLoggedInUser();

        Test.stopTest();
    }

    public static testMethod void testCCSiteLoginController3() {
        cc_ctrl_test_SiteLogin.prepTestData();
        Test.startTest();

        // Instantiate a new controller with all parameters in the page
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
        controller.usercontactTypeRole = 'ContactRole';


        controller.userIndustry = 'User Industry';
        controller.shipStreet1 = 'Ship Street';

        controller.shipCity = 'Ship City';
        controller.shipState = 'US--IL';
        controller.shipCountry = 'US';
        controller.shipPostalCode = '12345';

        controller.billStreet1 = 'Bill Street 1';
        controller.billStreet2 = 'Bill Street 2';
        controller.billCity = 'Bill City';
        controller.billState = 'US--IL';
        controller.billCountry = 'US';
        controller.billPostalCode ='12345';
        //System.assert(controller.registerUser() != null);
        controller.registerUser();

        System.assertEquals(null,  Site.login('test@force.com', 'abcd123', null));

        PageReference pageRef = new PageReference('/apex/HomePage');
        pageRef.getParameters().put('viewState','wishlists');
        pageRef.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY,'US');
        //pageRef.getParameters().put('store',cc_util_CloudCraze.application.Default_Storefront__c);
        pageRef.getParameters().put('CartID','');
        Test.setCurrentPage(pageRef);
        cc_ctrl_SiteLogin controller2 = new cc_ctrl_SiteLogin ();

        controller2.username = 'test@force.com';
        controller2.password = 'abcd123';

        //controller2.ipAddressLocation = 'US';
        //controller2.currentCartID = '';
       // controller2.
        //controller2.viewState = 'wishlists';
        System.assertNotEquals(null, controller2.login());
        controller2.username = UserInfo.getUserName();
        controller2.handleLoggedInUser();

        Test.stopTest();
    }


    public static testMethod void testCCSiteLoginController4() {
        cc_ctrl_test_SiteLogin.prepTestData();
        Test.startTest();

        // Instantiate a new controller with all parameters in the page
        cc_ctrl_SiteRegister controller = new cc_ctrl_SiteRegister();
        controller.username = 'test@force.com';
        controller.communityNickname = 'test';
        controller.password = 'abcd123';
        controller.confirmPassword = 'abcd123';
        controller.firstName = 'Dummy F Name';
        controller.lastName = 'Dummy L Name';
        controller.userSalutation = 'Mr.';
        controller.position_title = 'Position Title';
        controller.department = 'None';
        controller.companyName ='Company name';
        controller.usercontactTypeRole = 'ContactRole';
        controller.userIndustry = 'User Industry';
        controller.shipStreet1 = 'Ship Street';
        controller.shipCity = 'Ship City';
        controller.shipState = 'US--IL';
        controller.shipCountry = 'US';
        controller.shipPostalCode = '12345';
        controller.billStreet1 = 'Bill Street 1';
        controller.billStreet2 = 'Bill Street 2';
        controller.billCity = 'Bill City';
        controller.billState = 'US--IL';
        controller.billCountry = 'US';
        controller.billPostalCode ='12345';
        //System.assert(controller.registerUser() != null);
        controller.registerUser();

        System.assertEquals(null,  Site.login('test@force.com', 'abcd123', null));

        PageReference pageRef = new PageReference('/apex/HomePage');
        Test.setCurrentPage(pageRef);
        cc_ctrl_SiteLogin controller2 = new cc_ctrl_SiteLogin ();
        controller2.username = 'test@force.com';
        controller2.password = 'abcd123';

        System.assertNotEquals(null, controller2.login());
        controller2.username = UserInfo.getUserName();
        controller2.handleLoggedInUser();

        Test.stopTest();
    }

    public static testMethod void testSiteRegister() {
        cc_test_PrepTestData.loadCustomSettings();
        Test.startTest();

        // Instantiate a new controller with all parameters in the page
        cc_ctrl_SiteLogin controller = new cc_ctrl_SiteLogin();
        System.assertNotEquals(null, controller.siteRegister());
        
        Test.stopTest();
    }

    public static testMethod void testCCSiteLoginControllerByCart() {
        cc_ctrl_test_SiteLogin.prepTestData();
        Test.startTest();

        cc_api_Cart api = new cc_api_Cart();
        String customerType = 'Commercial';
        E_Cart__c cart = api.createEmptyCart('USD', 'Commercial');
        List<E_Product__c> productList = cc_test_PrepTestData.insertProduct(2);
        for(E_Product__c prod:productList){
            api.addToCart(prod.Id, cart.Id, 1,false, 'USD',
                          'Commercial', cc_util_CloudCraze.application.Default_Storefront__c);
        }

        cc_ctrl_Cart cartExt = new cc_ctrl_Cart();
        cartExt.currentCartID = cart.EncryptedID__c;
        PageReference pageRef = new PageReference('/apex/HomePage');
        pageRef.getParameters().put('message','message_pwd');
        Test.setCurrentPage(pageRef);

        cc_ctrl_SiteLogin controller = new cc_ctrl_SiteLogin ();
        System.assertEquals(cc_cnst_CloudCraze.PASSWORD_SENT, controller.messageString);
        System.assertEquals('success-msg',controller.messageCss);
        controller.login();

        PageReference pageRef2 = new PageReference('/apex/HomePage');
        pageRef2.getParameters().put('message','message_login');
        Test.setCurrentPage(pageRef2);
        controller = new cc_ctrl_SiteLogin ();
        controller.login();

        Test.stopTest();
    }

    public static testMethod void testCCSiteLoginControllerEmpty() {
        cc_test_PrepTestData.loadCustomSettings();
        Test.startTest();

        PageReference pageRef = new PageReference('/apex/HomePage');
        pageRef.getParameters().put('message','message_pwd');
        Test.setCurrentPage(pageRef);

        cc_ctrl_SiteLogin controller = new cc_ctrl_SiteLogin();
        System.assertEquals(cc_cnst_CloudCraze.PASSWORD_SENT, controller.messageString);
        System.assertEquals('success-msg',controller.messageCss);

        PageReference pageRef2 = new PageReference('/apex/HomePage');
        pageRef.getParameters().put('message','message_login');
        Test.setCurrentPage(pageRef);

        cc_ctrl_SiteLogin controller2 = new cc_ctrl_SiteLogin();
        System.assertEquals(cc_cnst_CloudCraze.INVALID_USERNAME_PWD,controller2.messageString);
        
        Test.stopTest();
    }

}