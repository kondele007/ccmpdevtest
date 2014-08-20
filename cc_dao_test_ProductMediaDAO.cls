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
private class cc_dao_test_ProductMediaDAO {

     static testMethod void cc_dao_test_ProductMediaDAO() {
     	cc_test_TestDataSetup.LoadData();
        System.runas(cc_test_TestDataSetup.testUser) {
        E_Product__c p = createTestingObjectInMemory();
        insert p;
        E_ProductMedia__c pm = new E_ProductMedia__c();
        pm.Product__c = p.Id;
        //pm.RecordType.Name='Image';
        pm.URI__c = p.SKU__c;
        //pm.MediaType__c = cc_util_CloudCraze.getIDByCode('MediaType', '20');
        pm.MediaType__c=cc_cnst_PickListConstants.MEDIATYPE_ALTERNATETHUMBNAILS;
        pm.ProductMediaSource__c = 'URI';
        
        cc_dao_ProductMedia dao = new cc_dao_ProductMedia();
        List<E_ProductMedia__c> pml = new List<E_ProductMedia__c>{pm};
        pml = dao.saveProductMedia(pml);
        for(E_ProductMedia__c pmi : pml)
        {
            
            List<E_ProductMedia__c> pml2 = dao.readProduct(pmi.Product__c);
            for(E_ProductMedia__c pmi2 : pml2)
            {
                System.assertEquals(cc_cnst_PickListConstants.MEDIATYPE_ALTERNATETHUMBNAILS, pmi2.MediaType__c);
            }
        }
        
        Map<String, List<cc_bean_MediaWrapper>> daoMap = dao.getProductMediaByType(p.Id);
        System.assertNotEquals(null, daoMap);
        
        List<String> pIdList = new List<String>();
        pIdList.add(p.Id);
        
        Map<Id, cc_bean_MediaWrapper> mw1 =dao.getProductMedia(pIdList,cc_cnst_PickListConstants.MEDIATYPE_ALTERNATETHUMBNAILS);
        System.assertNotEquals(null, mw1);
        
        Map<Id, cc_bean_MediaWrapper> mw2 =dao.getProductSearchMedia(pIdList,'en_US');
        System.assertNotEquals(null, mw2);
        
        //getProductImage
        Map<Id, cc_bean_MediaWrapper> mw3 =dao.getProductImage(pIdList,'en_US');
        System.assertNotEquals(null, mw3);
        //getProductAltMessages
        
        Map<Id, String> mw4 = dao.getProductAltMessages(pIdList);
        System.assertNotEquals(null, mw4);
        
        //getProductThumbnailMedia
         Map<Id, cc_bean_MediaWrapper> mw5 = dao.getProductThumbnailMedia(pIdList);
        System.assertNotEquals(null, mw5);
        
         Map<Id, cc_bean_MediaWrapper> mw6 = dao.getProductThumbnailMedia(pIdList,'en_US');
        System.assertNotEquals(null, mw6);
        
         Map<Id,Id> att = cc_dao_ProductMedia.getAttachmentsForProductList(pIdList,'Test',true,'en_US');
           System.assertNotEquals(null, att);
           
           Map<Id,Id> att1 = cc_dao_ProductMedia.getAttachmentsForProductList(pIdList,'',true);
           System.assertNotEquals(null, att1);
           
           Map<Id,Id> att2 = cc_dao_ProductMedia.getAttachmentsForProductList(pIdList,'');
           System.assertNotEquals(null, att2);
           
        for(E_ProductMedia__c pmi : pml)
        {
            dao.deleteProductMedia(pmi.Product__c);
            List<E_ProductMedia__c> pml3 = dao.readProduct(pmi.Product__c);
            System.assert(pml3.size() == 0);
        }
        }
    }
    
   
    
    static E_Product__c createTestingObjectInMemory()
    {
        E_Product__c p = new E_Product__c();
        p.SKU__c = 'Test SKU';
        p.LongDesc__c = 'This is long description for testinf product';
        p.ShortDesc__c = 'This is short description for testing product';
        p.QuantityPerUnit__c = 1.0;
        //p.UOMCode__c = cc_util_CloudCraze.getIDByCode('UnitOfMeasure', 'EA');
        p.UnitOfMeasure__c=cc_cnst_PickListConstants.UNITOFMEASURE_EACH;
        return p;
    }
    

}