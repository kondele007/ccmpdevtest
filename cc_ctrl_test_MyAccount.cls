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
private without sharing class cc_ctrl_test_MyAccount {
	 static testMethod void testGetterAndSetterMethods(){
        //cc_test_PrepTestData.loadCustomSettings();
        cc_test_TestDataSetup.LoadData();
		
		/*
		Account acc = new Account(name='CloudCrazeTestAccount', E_AccountGroup__r= new E_AccountGroup__c(ACCOUNTGROUPID__C='1'), OwnerId=userInfo.getUserId());
		insert acc;
		*/
		RecordType rt = [Select r.Name, r.Id From RecordType r where r.Name = 'Person Account' limit 1];
		
		Account tAccount = new Account(LastName='CloudCrazeTestAccount', RecordTypeID = rt.Id, E_AccountGroup__r= new E_AccountGroup__c(ACCOUNTGROUPID__C='1'), OwnerId=userInfo.getUserId());
		tAccount.PreventAddrBookSave__c = true;
		insert tAccount;

        //Account tAccount = new Account(id = u.Contact.Account.id);
        //tAccount.PreventAddrBookSave__c = true;
        //update tAccount;
        System.runas(cc_test_TestDataSetup.testUser) {
	        Test.startTest();
	
	        cc_ctrl_MyAccount myAccount = new cc_ctrl_MyAccount();
	        PageReference pr = System.page.MyAccount;
	        Test.setCurrentPageReference(pr);
	        
	        System.assert(myAccount.currentUser.id == userInfo.getUserId());
	        /*
	        System.assertEquals('viewDashboard', myAccount.SUMMARY_VIEW);
	        System.assertEquals('viewAccountInfo', myAccount.ACCOUNT_INFO_VIEW);
	        System.assertEquals('viewChangePassword', myAccount.CHANGE_PASSWORD_VIEW);
	        System.assertEquals('editAccountInfo', myAccount.ACCOUNT_INFO_EDIT_VIEW);
	        System.assertEquals('viewAddressBook', myAccount.ADDRESS_BOOK_VIEW);
	        System.assertEquals('viewOrders', myAccount.ORDERS_VIEW);
	        System.assertEquals('viewCarts', myAccount.CARTS_VIEW);
	        System.assertEquals('wishlists', myAccount.WISHLIST_VIEW);
	        System.assertEquals('OrderSummary', myAccount.ORDER_SUMMARY);
	        System.assertEquals('CartSummary', myAccount.CART_SUMMARY);
	        */
	        System.assertEquals(0, myAccount.errorMessages.size());
	        System.assertEquals(0, myAccount.successMessages.size());
			System.assert(myAccount.getMyAccountController() != null);
			//System.assertEquals(false, myAccount.canManageAddressBook);
	    	
	    	//test account info
	    	/*
	    	cc_bean_MockContactAddress mockShipTo = new cc_bean_MockContactAddress();
			mockShipTo.address1 = 'DummyAddr1';
			mockShipTo.city = 'DummyCity';
			mockShipTo.stateCode = 'CA';
			mockShipTo.state = 'CA';
			mockShipTo.postalCode = '90210';
			cc_bean_MockContactAddress mockBillTo = new cc_bean_MockContactAddress();
			mockBillTo.address1 = 'DummyBillAddr1';
			mockBillTo.city = 'DummyBillCity';
			mockBillTo.stateCode = 'CA';
			mockBillTo.state = 'CA';
			mockBillTo.postalCode = '90210';
		    myAccount.mockBillTo = mockBillTo;
		    myAccount.mockShipTo = mockShipTo;
		    */
		   
    		System.assert(myAccount.showCartList() == null);
    		System.assert(myAccount.showOrderList() == null);
	    	System.assertEquals(myAccount.ORDERS_VIEW, myAccount.viewState);
    		System.assert(myAccount.showAccountInfoView() == null);
    		System.assert(myAccount.showAccountInfoEditView() == null);
    		System.assert(myAccount.showChangePasswordView() == null);
    		System.assert(myAccount.showAddressBookView() == null);
    		System.assert(myAccount.showMyWishList() == null);
    		
	        Test.stopTest();
        }
    }


    
}