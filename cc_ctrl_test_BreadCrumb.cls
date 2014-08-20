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
private class cc_ctrl_test_BreadCrumb {
	
	private static List<E_Category__c> insertData(){
		List<E_Category__c> listCategory=new List<E_Category__c>();
        
        E_Category__c rootCategory=new E_Category__c();
        rootCategory.Name='Root';
        rootCategory.Sequence__c=0;
        rootCategory.CategoryID__c='123';
        insert rootCategory;
   
        E_Category__c fooCategory=new E_Category__c();
        fooCategory.Name='Foo';
        fooCategory.Sequence__c=100;
        fooCategory.ShortDesc__c='Foo Category';
        fooCategory.ParentCategory__c=rootCategory.Id;
        fooCategory.CategoryID__c='789';
        insert fooCategory;
        
         E_Category__c barCategory=new E_Category__c();
        barCategory.Name='Bar';
        barCategory.Sequence__c=100;
        barCategory.ShortDesc__c='Bar Category';
        barCategory.CategoryID__c='567';
        barCategory.ParentCategory__c=rootCategory.Id;
        insert barCategory;
        
        E_Category__c xyzCategory=new E_Category__c();
        xyzCategory.Name='Palm';
        xyzCategory.Sequence__c=200;
        xyzCategory.ShortDesc__c='Palm Category';
        xyzCategory.CategoryID__c='612';
        xyzCategory.ParentCategory__c=fooCategory.Id;
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
             cat.ParentCategory__c=barCategory.Id;
             cat.ShortDesc__c='abc_category'+i;
             cat.Sequence__c=100;
             cat.CategoryID__c='abc'+i;
             listCategory.add(cat);
        }
        
        return listCategory;
		
	}

    static testMethod void myUnitTest() {
        cc_test_PrepTestData.loadCustomSettings();
        Test.startTest();

        List<E_Category__c> insertList=insertData();
        insert insertList;

        List<E_BreadCrumb__c> breadCrumbListItr= [select BreadCrumb__c from E_BreadCrumb__c where CategoryID__c =:insertList[0].Id];
        
        if(breadCrumbListItr!=null && breadCrumbListItr.size()>0){
        	System.assertEquals(breadCrumbListItr[0].BreadCrumb__c, 'Start>Foo>Palm>xyz1');
        }
        
        List<E_Product__c> productList=cc_test_PrepTestData.insertProduct(3);
        
        cc_test_PrepTestData.insertProductCategory(insertList[0], productList[0]);
        cc_test_PrepTestData.insertProductCategory(insertList[11], productList[1]);
        // cc_test_PrepTestData.insertProductCategory(xyzCategory, productList[1]);
        //cc_test_PrepTestData.insertProductCategory(rootCategory, productList[2]);
        
        PageReference pg = System.Page.HomePage;
        Apexpages.currentPage().getParameters().put('navigationStr','CatalogSearchInc');
        Apexpages.currentPage().getParameters().put('sku',productList[0].SKU__c);
        Apexpages.currentPage().getParameters().put('viewState','DetailView');
        Apexpages.currentPage().getParameters().put('categoryID',insertList[0].Id);
       
        cc_ctrl_HomePage homePageCtrl = new cc_ctrl_HomePage();
        
        cc_ctrl_BreadCrumb breadCrumbExtension = new cc_ctrl_BreadCrumb();
        breadCrumbExtension.delegate = homePageCtrl;
        breadCrumbExtension.breadCrumbURL();
        
        Apexpages.currentPage().getParameters().put('viewState','ListView');
        Apexpages.currentPage().getParameters().put('navigationStr','');
        Apexpages.currentPage().getParameters().put('operation','quickSearch');
        breadCrumbExtension = new cc_ctrl_BreadCrumb();
        breadCrumbExtension.delegate = homePageCtrl;
        breadCrumbExtension.breadCrumbURL();
        
        Apexpages.currentPage().getParameters().put('viewState','DetailView'); 
        Apexpages.currentPage().getParameters().put('navigationStr','');
        Apexpages.currentPage().getParameters().put('operation','ListProduct');        
        breadCrumbExtension = new cc_ctrl_BreadCrumb();
        breadCrumbExtension.delegate = homePageCtrl;
        breadCrumbExtension.breadCrumbURL();
        
        Apexpages.currentPage().getParameters().put('navigationStr','');
        Apexpages.currentPage().getParameters().put('sku',productList[1].SKU__c);
        Apexpages.currentPage().getParameters().put('categoryID',insertList[11].Id);
        Apexpages.currentPage().getParameters().put('viewState','ListView');
        Apexpages.currentPage().getParameters().put('navigationStr','');
        Apexpages.currentPage().getParameters().put('operation','quickSearch');
        breadCrumbExtension = new cc_ctrl_BreadCrumb();
        breadCrumbExtension.delegate = homePageCtrl;
        breadCrumbExtension.breadCrumbURL();
        
        Test.stopTest();
    }
    
    static testMethod void testQuickSearch() {
    	cc_test_PrepTestData.loadCustomSettings();
        cc_ctrl_HomePage homePageCtrl = new cc_ctrl_HomePage();
    	cc_ctrl_BreadCrumb breadCrumb = new cc_ctrl_BreadCrumb();
    	breadCrumb.delegate = homePageCtrl;
    	PageReference pg = breadCrumb.quickSearch();
    	//system.debug('pg:'+pg);
    	System.assert( pg.getUrl() != null);
    }
    
    static testMethod void testGetBreadCrumbs() {
    	cc_test_PrepTestData.loadCustomSettings();
    	List<E_Product__c> productList=cc_test_PrepTestData.insertProduct(3);
    	
        cc_ctrl_HomePage homePageCtrl = new cc_ctrl_HomePage();
        homePageCtrl.viewState='HomePage';
    	cc_ctrl_BreadCrumb breadCrumb = new cc_ctrl_BreadCrumb();
    	breadCrumb.delegate = homePageCtrl;
    	breadCrumb.sku = productList[0].SKU__c;
    	breadCrumb.getBreadCrumbs();
    }
    
    
}