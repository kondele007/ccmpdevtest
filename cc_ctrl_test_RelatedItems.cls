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
private class cc_ctrl_test_RelatedItems {

	private static void prepTestData() {
        cc_test_PrepTestData.loadCustomSettings();
        cc_test_PrepTestData.loadInitData();
        cc_test_PrepTestData.loadTestCategoryData();
	}
	
    static testMethod void testRelatedItems() {
        cc_ctrl_test_RelatedItems.prepTestData();
        List<E_Product__c> products = cc_test_PrepTestData.getAllTestProducts();
        List<E_RelatedProduct__c> competitveRel = cc_test_PrepTestData.insertRelatedProduct(products[0].Id, products[1].Id, cc_cnst_PickListConstants.RELATEDPRODUCT_COMPETITIVE);
        List<E_RelatedProduct__c> relatedRel = cc_test_PrepTestData.insertRelatedProduct(products[0].Id, products[1].Id, cc_cnst_PickListConstants.RELATEDPRODUCT_RELATED);
        List<E_RelatedProduct__c> requiredRel = cc_test_PrepTestData.insertRelatedProduct(products[0].Id, products[1].Id, cc_cnst_PickListConstants.RELATEDPRODUCE_REQUIREDITEM);
        List<E_RelatedProduct__c> crossRel = cc_test_PrepTestData.insertRelatedProduct(products[0].Id, products[1].Id, cc_cnst_PickListConstants.RELATEDPRODUCT_CROSSSELL);
        List<E_RelatedProduct__c> upsellRel = cc_test_PrepTestData.insertRelatedProduct(products[0].Id, products[1].Id, cc_cnst_PickListConstants.RELATEDPRODUCT_UPSELL);
        
        E_PriceList__c priceList = [select a.id from E_PriceList__c a where a.name='Enterprise'][0];   
        
        E_AccountGroup__c accountGroup = [select Id from E_AccountGroup__c where Name = 'Anonymous'][0];
        
        //Account accountInstance=new Account(Id=cc_util_CloudCraze.getAccountID(),E_AccountGroup__c=accountGroup.Id);
        //update accountInstance;
		RecordType rt = [Select r.Name, r.Id From RecordType r where r.Name = 'Person Account' limit 1];
		
		Account accountInstance = new Account(LastName='CloudCrazeTestAccount', RecordTypeID = rt.Id, E_AccountGroup__c=accountGroup.Id, OwnerId=userInfo.getUserId());
		insert accountInstance;
        
        E_AccountGroupPriceList__c agpl = new E_AccountGroupPriceList__c(AccountGroup__c = accountGroup.Id, Pricelist__c=priceList.id, Sequence__c=1);
        insert agpl;
        
         E_PriceListItem__c pli = new E_PriceListItem__c(Pricelist__c=priceList.Id, Product__c=products[0].Id, Price__c=200);
        insert pli;
        
        pli = new E_PriceListItem__c(Pricelist__c=priceList.Id, Product__c=products[1].Id, Price__c=210);
        insert pli;
        
        Test.startTest();
        
        cc_ctrl_RelatedItems controller = new cc_ctrl_RelatedItems();
        List<cc_bean_ProductListViewData> related = controller.getRelatedItems();
        System.assertEquals(0, related.size());
        related = controller.getCrossSellItemsForList();
        System.assertEquals(0, related.size());

        controller.productId = products[0].Id;
        controller.productIdList = new List<Id> {products[0].id};

        related = controller.getRelatedItems();
        System.assertEquals(1, related.size());
        related = controller.getCompetitiveItems();
        System.assertEquals(1, related.size());
        related = controller.getCrossSellItems();
        System.assertEquals(1, related.size());
        related = controller.getCrossSellItemsForList();
        System.assertEquals(1, related.size());
        related = controller.getRequiredItems();
        System.assertEquals(1, related.size());
        related = controller.getUpSellItems();
        System.assertEquals(1, related.size());
        
        System.assertNotEquals(null, controller.storeID);
        System.assertNotEquals(null, controller.ipAddressLocationKey);
        String ga = controller.googleAnalyticsAcountIdAndPropIndex;
        
        Test.stopTest();
    }
}