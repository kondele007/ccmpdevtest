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
private class cc_trigger_test_BreadCrumbTrigger {

    private static List<E_Category__c> insertData(){
                List<E_Category__c> listCategory=new List<E_Category__c>();

        E_Category__c rootCategory=new E_Category__c();
        rootCategory.Name='Root';
        rootCategory.Sequence__c=0;
        rootCategory.CategoryID__c='123';
        insert rootCategory;

        E_Category__c bioTechCategory=new E_Category__c();
        bioTechCategory.Name='Biotech';
        bioTechCategory.Sequence__c=100;
        bioTechCategory.ShortDesc__c='Biotech Category';
        bioTechCategory.ParentCategory__c=rootCategory.Id;
        bioTechCategory.CategoryID__c='789';
        insert bioTechCategory;

         E_Category__c envCategory=new E_Category__c();
        envCategory.Name='Env';
        envCategory.Sequence__c=100;
        envCategory.ShortDesc__c='Env Category';
        envCategory.CategoryID__c='567';
        envCategory.ParentCategory__c=rootCategory.Id;
        insert envCategory;

        E_Category__c xyzCategory=new E_Category__c();
        xyzCategory.Name='Palm';
        xyzCategory.Sequence__c=200;
        xyzCategory.ShortDesc__c='Palm Category';
        xyzCategory.CategoryID__c='612';
        xyzCategory.ParentCategory__c=bioTechCategory.Id;
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
             cat.ParentCategory__c=envCategory.Id;
             cat.ShortDesc__c='abc_category'+i;
             cat.Sequence__c=100;
             cat.CategoryID__c='abc'+i;
             listCategory.add(cat);
        }

        return listCategory;

        }

    static testMethod void insertCategory() {
        // Start the test, this changes governor limit context to
        // that of trigger rather than test.
                test.startTest();

        List<E_Category__c> insertList=insertData();
        System.assert(insertList.size() > 0);

        insert insertList;

         // Stop the test, this changes limit context back to test from trigger.
         test.stopTest();
    }

    static testMethod void testUpdateCategory(){

        // Start the test, this changes governor limit context to
        // that of trigger rather than test.
           test.startTest();

        List<E_Category__c> insertList=insertData();
        insert insertList;


        E_Category__c rootCategory=[Select e.ParentCategory__c, e.Id
                                    from E_Category__c e
                                    where e.ParentCategory__c = null
                                    limit 1];

        E_Category__c ericcsonCategory=new E_Category__c();

        ericcsonCategory.Name='Ericsson';
        ericcsonCategory.Sequence__c=100;
        ericcsonCategory.CategoryID__c='098';
        ericcsonCategory.ShortDesc__c='Ericsson Category';
        ericcsonCategory.ParentCategory__c=rootCategory.Id;
        insert ericcsonCategory;

        List<E_Category__c> updateCategoryList=new List<E_Category__c>();
                
        for(E_Category__c updateCategory:[select e.ParentCategory__c, e.Id
                                          from E_Category__c e
                                          where e.ParentCategory__r.Name = 'Palm']) {
            updateCategory.ParentCategory__r=ericcsonCategory;
            updateCategoryList.add(updateCategory);
        }
                
        update updateCategoryList;
        
        List<E_Category__c> ericssonCategory = [select c.Name
                                                from E_Category__c c
                                                where c.Name =: 'Ericsson'];
        System.assert(ericssonCategory.size() > 0);
        
        // Stop the test, this changes limit context back to test from trigger.
        test.stopTest();
    }

    
    static testMethod void testInsertCategory() {
        // TODO: Implement test method
        System.assert(true);
    }
    

}