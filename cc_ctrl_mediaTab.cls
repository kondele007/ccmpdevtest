//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_ctrl_mediaTab {
	public cc_ctrl_ProductDetail pdpController { get; set; }
	public List<cc_bean_MediaWrapper> getMediaWrapper() {
		if(pdpController.productMediaMap.get('Media') != null)
		{
			return pdpController.productMediaMap.get('Media');
		} else {
			return new List<cc_bean_MediaWrapper>();
		}
	}
	
	static testMethod void myUnitTest() {
		cc_test_TestDataSetup.loadData();
		System.assert([Select c.Id From E_ApplicationSettings__c c where name='CloudCraze'].size() != 0);
		System.RunAs(cc_test_TestDataSetup.testUser) {
			cc_ctrl_ProductDetail pdp = new cc_ctrl_ProductDetail();
			cc_ctrl_mediaTab tab = new cc_ctrl_mediaTab();
			tab.pdpController = pdp;
			
			tab.getMediaWrapper();
		}
	}
}