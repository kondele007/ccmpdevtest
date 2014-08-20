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
private class cc_bean_test_ProductComponent {
	
	class ProdComp extends cc_bean_ProductComponent {
		ProdComp(E_Product__c p) { super(p); }
	}
	
	
	static testMethod void myUnitTest() {
		List<E_Product__c> productList = cc_test_PrepTestData.insertProduct(2);
		cc_bean_ProductComponent bean = new ProdComp(productList[0]);
		System.assertEquals(1, bean.quantity);
		System.assertEquals(productList[0].name, bean.component.name);
		System.assert(bean.getChildren() == null);
		
		cc_bean_ProductComponent bean2 = new ProdComp(productList[1]);
		bean.addChild(bean2);
		
		cc_bean_ProductComponent bean3 = new cc_bean_ProductComposite(productList[1]);
		bean3.addChild(bean2);
		bean3.getChildren();
		
	}
}