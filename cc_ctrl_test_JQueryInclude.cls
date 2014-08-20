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
private class cc_ctrl_test_JQueryInclude {

    static testMethod void myUnitTest() {
        cc_test_PrepTestData.loadCustomSettings();
        Test.startTest();
        
        E_Category__c rootCategory=new E_Category__c();
        rootCategory.Name='Root';
        rootCategory.Sequence__c=0;
        rootCategory.CategoryID__c='12345';
        insert rootCategory;
   
        E_Category__c bioTechCategory=new E_Category__c();
        bioTechCategory.Name='Biotech';
        bioTechCategory.Sequence__c=100;
        bioTechCategory.ShortDesc__c='Biotech Category';
        bioTechCategory.ParentCategory__c=rootCategory.Id;
        bioTechCategory.CategoryID__c='456';
        insert bioTechCategory;
        List<E_Product__c> productList=cc_test_PrepTestData.insertProduct(1);
        
        System.assert(productList.size() == 1);
        
        cc_test_PrepTestData.insertProductCategory(bioTechCategory, productList[0]);
        ApexPages.StandardController controller = new ApexPages.StandardController(bioTechCategory);
        
        Apexpages.currentPage().getParameters().put('sku',productList[0].SKU__c);
        Apexpages.currentPage().getParameters().put('viewState','DetailView'); 
        Apexpages.currentPage().getParameters().put('navigationStr','');
        Apexpages.currentPage().getParameters().put('operation','ListProduct');     
        cc_ctrl_BreadCrumb breadCrumbExtension = new cc_ctrl_BreadCrumb(controller);
        cc_ctrl_JQueryInclude includeController=new cc_ctrl_JQueryInclude();
        
        cc_util_CloudCraze.productCategory='';
        includeController=new cc_ctrl_JQueryInclude();
        
        // TODO: Add meaningful assertion
        System.assert(true);
        
        Test.stopTest();
    }
}