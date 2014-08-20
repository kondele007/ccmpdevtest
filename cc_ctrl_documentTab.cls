//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_ctrl_documentTab {
	public cc_ctrl_ProductDetail pdpController { get; set; }
	public List<String> documentType {
		get {
			return new List<String>{'Datasheets', 'Safety Documents', 'Owner\'s Manuals', 'Assembly Guides', 'Sales Brochures'};
		} set;
	}
	public List<cc_bean_MediaWrapper> getDatasheets() {
		return pdpController.productMediaMap.get('Datasheets');
	}
	public List<cc_bean_MediaWrapper> getSafetyDocuments() {
		return pdpController.productMediaMap.get('Safety Documents');
	}
	public List<cc_bean_MediaWrapper> getOwnersManuals() {
		return pdpController.productMediaMap.get('Owner\'s Manuals');
	}
	public List<cc_bean_MediaWrapper> getAssemblyGuides() {
		return pdpController.productMediaMap.get('Assembly Guides');
	}
	public List<cc_bean_MediaWrapper> getSalesBrochures() {
		return pdpController.productMediaMap.get('Sales Brochures');
	}
	
	static testMethod void myUnitTest() {
		cc_test_TestDataSetup.loadData();
		System.RunAs(cc_test_TestDataSetup.testUser) {
			cc_ctrl_ProductDetail pdp = new cc_ctrl_ProductDetail();
			cc_ctrl_documentTab tab = new cc_ctrl_documentTab();
			tab.pdpController = pdp;
			System.assert(tab.documentType.size() > 0);

			tab.getDatasheets();
			tab.getSafetyDocuments();
			tab.getOwnersManuals();
			tab.getAssemblyGuides();
			tab.getSalesBrochures();
		}
	}
}