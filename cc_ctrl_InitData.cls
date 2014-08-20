//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_ctrl_InitData {
	//==================================================
    // SERVICE METHODS
    //==================================================
	public PageReference loadCustomSettings() {
        cc_hlpr_InitLoadCustomSettings.loadCloudCrazeApplicationSettings();
        cc_hlpr_InitLoadCustomSettings.loadCloudCrazeStorefrontSettings();
        cc_hlpr_InitLoadCustomSettings.loadCountryCodes();
        cc_hlpr_InitLoadCustomSettings.loadCurrencyCodes();
        cc_hlpr_InitLoadCustomSettings.loadLanguageCodes();
        cc_hlpr_InitLoadCustomSettings.loadPageConfigurations();
        cc_hlpr_InitLoadCustomSettings.loadStateCodes();
		return null;
	}
	
	public PageReference resetAccountPriceList() {
		cc_hlpr_InitDataSet.initialize();
		return null;
	}
	
	public PageReference loadInitialDataSet() {	
		cc_hlpr_InitDataSet.loadAccountGroup();
		cc_hlpr_InitDataSet.loadAccount();
		cc_hlpr_InitDataSet.loadPriceList();
		cc_hlpr_InitDataSet.loadAccountGroupPriceList();
		return null;
	}
	
	public PageReference resetProductCategories() {
		cc_hlpr_InitLoadCategories.initialize();
		return null;
	}
	
	public PageReference loadCloudCrazeData() {
		cc_hlpr_InitLoadCategories.loadCategories();
		//cc_hlpr_InitLoadCategories.loadParentCategories();//TODO
		cc_hlpr_InitLoadCategories.loadProducts();
		cc_hlpr_InitLoadCategories.loadProductCategories();
		cc_hlpr_InitLoadCategories.loadPriceListItems();
		cc_hlpr_InitLoadCategories.loadSpecs();
		// Added by Kunaal
		cc_hlpr_InitLoadCategories.loadCompositeProducts();
		cc_hlpr_InitLoadCategories.loadFeaturedProducts();
		cc_hlpr_InitLoadCategories.loadRelatedProducts();
		//cc_hlpr_InitLoadCategories.loadRules();
		//cc_hlpr_InitLoadCategories.loadRuleSource();
		//cc_hlpr_InitLoadCategories.loadRuleTarget();
		cc_hlpr_InitLoadCategories.loadCoupons();
		//cc_hlpr_InitLoadCategories.loadPricingModifier();
		//cc_hlpr_InitLoadCategories.loadRulePricingModifier();
		cc_hlpr_InitLoadCategories.loadProductSpec();
		cc_hlpr_InitLoadCategories.loadPromotions();
		cc_hlpr_InitLoadCategories.loadProductMedia();
		return null;
	}
	
	
}