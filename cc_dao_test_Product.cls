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
private class cc_dao_test_Product {

    static testMethod void myUnitTest() { 
    	cc_test_TestDataSetup.LoadData();
        System.runas(cc_test_TestDataSetup.testUser) {
        //cc_test_PrepTestData.insertCode('ProductStatus', 'Not Orderable Item', '250'/*cc_cnst_CloudCraze.PRODUCT_NOTORDERABLE_STATUS_CODE*/);
        //E_Product__c p = createTestingProductInMemory(al.RandomStringUtils.randomUUID());
        E_Product__c p = createTestingProductInMemory(cc_util_RandomString.randomUUID());
        cc_dao_Product dao = new cc_dao_Product();
        E_Product__c updatedProduct = dao.saveProduct(p);
        System.assertEquals(0, cc_dao_Product.getProductTabs(updatedProduct.id).size());
        List<E_Product__c> pl = dao.readProduct(updatedProduct.SKU__c);
        System.assertEquals(1, pl.size());
        System.assertEquals(pl[0].SKU__c, p.SKU__c);
        List<E_Product__c> pl2 = dao.readProductWithID(updatedProduct.id);
        System.assertEquals(1, pl2.size());
        System.assertEquals(pl2[0].SKU__c, p.SKU__c);
        dao.deleteProduct(updatedProduct.id);
        pl2 = dao.readProductWithID(updatedProduct.id,'en_US');
        System.assertEquals(0, pl2.size());
        }
    }
    
    static testMethod void myUnitTest2() { 
    	cc_test_TestDataSetup.LoadData();
        System.runas(cc_test_TestDataSetup.testUser) {
    	E_Product__c product1 = new E_Product__c(SKU__C='testSKU1',  Name='test product 1', ShortDesc__c='Short Desc 1', LongDesc__c='Long Desc1', ProductStatus__c='Released');
        insert product1;
        
        E_ProductItemI18N__c   l_product1 = new E_ProductItemI18N__c  (Name='localized test product 1', ShortDesc__c='Localized Short Desc 1', LongDesc__c='Localized Long Desc1', locale__c='zh_TW');
        l_product1.Product__c = product1.Id;
        insert l_product1;
        E_Product__c product2 = new E_Product__c(SKU__C='testSKU2',  Name='test product 2', ShortDesc__c='Short Desc 2', LongDesc__c='Long Desc2', ProductStatus__c='Released');
        insert product2;
        
         E_ProductItemI18N__c   l_product2 = new E_ProductItemI18N__c  (Name='localized test product 2', ShortDesc__c='Localized Short Desc 2', LongDesc__c='Localized Long Desc 2', locale__c='zh_TW');
        l_product2.Product__c = product2.Id;
        insert l_product2;
        
       cc_dao_Product dao = new cc_dao_Product();
       List<E_Product__c> pl = dao.readProduct('testSKU1', 'zh_TW');
       for(E_Product__c p : pl )
       {
       		//System.debug('-----------------------name ------------------>' + p.Name);
       }
       
       List<E_Product__c> pl2 = dao.readProduct('testSKU1', 'en_US');
       for(E_Product__c p : pl2 )
       {
       		//System.debug('-----------------------name ------------------>' + p.Name);
       }
       
       List<E_Product__c> pl3 = dao.readProduct('testSKU1', 'fr_FR');
       for(E_Product__c p : pl3 )
       {
       		//System.debug('-----------------------name ------------------>' + p.Name);
       }
       
       System.assertEquals(pl.size(), 1);
        }
    }
    
    static testMethod void addCategoryTest()
    {
    	cc_test_TestDataSetup.LoadData();
        System.runas(cc_test_TestDataSetup.testUser) {
        E_Category__c root = createTestingParentCategory();
        E_Category__c testObj1 =  createTestingCategoryInMemory(root.Id);
        cc_dao_Product dao = new cc_dao_Product();
        dao.addCategory(testObj1);
        
        try
        {
            E_Category__c testObj2 =  createTestingCategoryInMemory(root.Id);
            dao.addCategory(testObj2);
            System.assert(false);
        }
        catch(cc_excn_DuplicatedCategoryException e)
        {
            System.assert(true);
        }
        }
    }
    
    static testMethod void addProductTest()
    {
    	cc_test_TestDataSetup.LoadData();
        System.runas(cc_test_TestDataSetup.testUser) {
        E_Category__c root = createTestingParentCategory();
        E_Category__c testObj1 =  createTestingCategoryInMemory(root.id);
        insert testObj1;
       // cc_test_PrepTestData.insertCode('ProductStatus', 'Not Orderable Item', '250');
        //E_Product__c product = createTestingProductInMemory(al.RandomStringUtils.randomUUID());
         E_Product__c product = createTestingProductInMemory(cc_util_RandomString.randomUUID());
        cc_dao_Product dao = new cc_dao_Product();
        dao.addProductCategory(testObj1.Id, product);
        List<E_ProductCategory__c> cs = [Select e.Id from E_ProductCategory__c e  where e.Product__c = : product.Id and e.IsDeleted = false ];
        System.assertEquals(1, cs.size());
        /**try
        {
            //test the same sku
            E_Product__c testObj2 =  createTestingProductInMemory('Test Sku1');
            dao.addProductCategory(testObj1.Id, testObj2);
            //System.assert(false);
        }
        catch(cc_excn_DuplicatedProductCatException e)
        {
            //System.debug(e.getMessage());
            System.assert(true);
        }**/
        }
    }
    
    static E_Product__c createTestingProductInMemory(String sku)
    {
        /*List<E_Code__c> statusCodes = [Select e.Code__c,
                                               e.id
                                        From E_Code__c e
                                        Where e.CodeType__c = 'ProductStatus'
                                        And e.Code__c = :cc_cnst_CloudCraze.PRODUCT_NOTORDERABLE_STATUS_CODE
                                        limit 1
                                    ];
        E_Code__c statusCode = null;
        if(statusCodes != null && statusCodes.size() > 0){
            statusCode = statusCodes[0];
        }*/
        E_Product__c p = new E_Product__c();
        p.SKU__c = sku;
        p.LongDesc__c = 'This is long description for testinf product';
        p.ShortDesc__c = 'This is short description for testing product';
        p.QuantityPerUnit__c = 1.0;
        p.UnitOfMeasure__c=cc_cnst_PickListConstants.UNITOFMEASURE_EACH;        
///        if(statusCode != null){
          p.ProductStatus__c = cc_cnst_PickListConstants.PRODUCTSTATUS_NOTORDERABLE;
       // }
        return p;
    }
    static E_Category__c createTestingParentCategory()
    {
        E_Category__c root = new E_Category__c(Name='TesRoot', CategoryID__c='1111111', ShortDesc__c='Testing Root Object');
        insert root;
        return root;
    }
    static E_Category__c createTestingCategoryInMemory(String parentId)
    {
        E_Category__c testCategory = new E_Category__c(Name='MyTestingCategory', CategoryID__c='2222222',ParentCategory__c = parentId, ShortDesc__c='My Testing Category');
        
        return testCategory;
    }
    
    //
    static testMethod void testReadProductForStore(){
    	cc_test_TestDataSetup.LoadData();
    	System.assert([Select c.Id From E_ApplicationSettings__c c where name='CloudCraze'].size() != 0);
        System.runas(cc_test_TestDataSetup.testUser) {
    	E_Category__c root = new E_Category__c(Name='TesRoot', CategoryID__c='1111111', ShortDesc__c='Testing Root Object');
        insert root;
        
    	E_Product__c p = new E_Product__c();
        p.SKU__c = 'TESTSKU';
        p.LongDesc__c = 'This is long description for testinf product';
        p.ShortDesc__c = 'This is short description for testing product';
        p.QuantityPerUnit__c = 1.0;
        p.UnitOfMeasure__c=cc_cnst_PickListConstants.UNITOFMEASURE_EACH;        
        p.ProductStatus__c = cc_cnst_PickListConstants.PRODUCTSTATUS_NOTORDERABLE;
       
       insert p;
       
       E_ProductItemI18N__c proI8N = new E_ProductItemI18N__c(Name='testName',ShortDesc__c='test ShortDesc__c',LongDesc__c='test LongDesc__c',
				Product__c = p.Id);
        
        insert proI8N;
       E_Category__c categoryParent = new E_Category__c(Name='Test Parent Category',
                                                         CategoryID__c='3789',
                                                         LongDesc__c ='desc');
                                                         
       insert categoryParent;
       E_ProductCategory__c  productCategory1 = new E_ProductCategory__c(Product__c=p.Id, Category__c=categoryParent.Id); 
        
        insert productCategory1;
        List<String> skuId = new List<String>();
        skuId.add(p.SKU__c);
        
        List<E_Product__c> proList = cc_dao_Product.readProductForStore(skuId, '', '');
        
        List<E_Product__c> proListStatus = cc_dao_Product.readProductForStatus(skuId, '', '');
        
        cc_dao_Product pDao = new cc_dao_Product();
        List<E_Category__c> cat = pDao.readCategory(productCategory1.Id,'');
        
        String rootStr = pDao.getRootCategoryName();
        List<E_Category__c> chldCt = cc_dao_Product.getChildCategories('','');
        List<String> statuscodeList = new List<String>();
        statuscodeList.add(cc_cnst_PickListConstants.PRODUCTSTATUS_NOTORDERABLE);
        statuscodeList.add(cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED);
        List<E_Product__c> proListStatusType = cc_dao_Product.readProductForStatusAndTypeWithID(skuId,'',statuscodeList,'');
        
        List<E_Product__c> proListStatus1 = cc_dao_Product.readProductForStatus(skuId, '',statuscodeList);
        
        List<E_Product__c> proListStatusType2 = cc_dao_Product.readProductForStatusWithID(skuId,'',statuscodeList);
        
        List<E_Product__c> pl2 = pDao.readProductWithID(p.id);
        pl2 = pDao.readProductWithID(p.id,'en_US');
        
        E_Category__c categ = pDao.getRootCategory();
        //readProductForStatusAndType
        
        List<E_Product__c> proListStatusType3 = cc_dao_Product.readProductForStatusAndType(skuId,'',statuscodeList,'');
        }
    }
}