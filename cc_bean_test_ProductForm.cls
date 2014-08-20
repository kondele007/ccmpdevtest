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
private class cc_bean_test_ProductForm {

    static testMethod void testProductForm() {
        E_Product__c product1 = new E_Product__c(SKU__C='testSKU1',  Name='test product 1', ShippingWeight__c=1);
        insert product1;
        
        cc_bean_ProductForm form = new cc_bean_ProductForm();
        form.product = new cc_bean_Product(product1);
        form.imageIds = new List<cc_bean_EProductImageID>();
        form.pictures = new List<Id>();

        //Account a = new Account(Name='Test');
        //insert a;
		cc_api_dl_accountGroups ag = new cc_api_dl_accountGroups();
		ag.loadData();
		
		/*
		Account acc = new Account(name='CloudCrazeTestAccount', E_AccountGroup__r= new E_AccountGroup__c(ACCOUNTGROUPID__C='1'), OwnerId=userInfo.getUserId());
		insert acc;
		*/
		RecordType rt = [Select r.Name, r.Id From RecordType r where r.Name = 'Person Account' limit 1];
		
		Account a = new Account(LastName='Test', RecordTypeID = rt.Id, E_AccountGroup__r= new E_AccountGroup__c(ACCOUNTGROUPID__C='1'), OwnerId=userInfo.getUserId());
		insert a;
		
		/*
		Contact c = new Contact(FirstName='joe', LastName='Smith', accountId=acc.id);
		insert c;
		*/
		Contact c = [select id from Contact where AccountId =: a.Id];

        form.groupId=a.Id;
        
        System.assert(form.product != null);
        System.assert(form.imageIds != null);
        System.assert(form.pictures != null);
        System.assert(form.groupId == a.Id);
    }
}