//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_hlpr_InitLoadCategories {

	public static void initialize() {
		// TODO: reinstate initilize for it to work on the cc init data tab
		/*
		delete [Select Id From E_ProductMedia__c LIMIT 2000];
		delete [Select Id From E_Promo__c LIMIT 2000];
		delete [Select Id From E_ProductSpec__c LIMIT 2000];
		delete [Select Id From E_RulePricingModifier__c LIMIT 2000];
		delete [Select Id From E_PriceModifier__c LIMIT 2000];
		delete [Select Id From E_Coupon__c LIMIT 2000];
		delete [Select Id From E_RuleSourceSKU__c LIMIT 2000];
        delete [Select Id From E_RuleTargetSKU__c LIMIT 2000];
        delete [Select Id From E_Rule__c LIMIT 2000];
		delete [Select Id From E_CompositeProduct__c LIMIT 2000];
        delete [Select Id From E_FeaturedProduct__c LIMIT 2000];
        delete [Select Id From E_RelatedProduct__c LIMIT 2000];
		delete [Select Id From E_ProductCategory__c LIMIT 2000];
		delete [Select Id From E_PriceListItem__c LIMIT 2000];
		delete [Select Id From E_Category__c LIMIT 2000];
		delete [Select Id From E_Product__c LIMIT 2000];
        delete [Select Id From E_Spec__c LIMIT 2000];
		*/
	}
	
    public static void loadTestCategories() {
    	loadCategories();
    }

	public static void loadCategories() {
		cc_api_dl_Categories categories = new cc_api_dl_Categories();
		categories.loadData();
	}
	
	public static void loadTestProducts() {
		loadProducts();
	}

    public static void loadProducts() {
        cc_api_dl_products products = new cc_api_dl_products();
		products.loadData();
    }
	
	public static void loadTestProductCategories() {
		loadProductCategories();
	}

    public static void loadProductCategories() {
        cc_api_dl_productCategories productCategories = new cc_api_dl_productCategories(); 
		productCategories.loadData();
    }
    
    public static void loadTestPriceLists() {
    	loadPriceLists();
    }
    
    public static void loadPriceLists() {
        cc_api_dl_priceLists priceLists = new cc_api_dl_priceLists();
		priceLists.loadData();
    }

	public static void loadTestPriceListItems() {
		loadPriceListItems();
	}

    public static void loadPriceListItems() {
        cc_api_dl_priceListLines priceListLines = new cc_api_dl_priceListLines();
		priceListLines.loadData();
    }

	public static void loadTestSpecs() {
		loadSpecs();
	}

    public static void loadSpecs() {
        cc_api_dl_spec specs = new cc_api_dl_spec();
    	specs.loadData();
    }

    public static void loadProductSpecs() {
        cc_api_dl_productSpec prodSpec = new cc_api_dl_productSpec();
    	prodSpec.loadData();
    }

    public static void loadCompositeProducts() {
    	cc_api_dl_compositeProducts compositeProducts = new cc_api_dl_compositeProducts();
    	compositeProducts.loadData();
    }
    
    public static void loadFeaturedProducts() {
    	cc_api_dl_featuredProducts featuredProducts = new cc_api_dl_featuredProducts();
    	featuredProducts.loadData();
    }
    
    public static void loadRelatedProducts() {
    	cc_api_dl_relatedProducts relatedProducts = new cc_api_dl_relatedProducts();
    	relatedProducts.loadData();
    }
    
    public static void loadRules() {
    	cc_api_dl_rules rules = new cc_api_dl_rules();
    	rules.loadData();
    }
    
    public static void loadRuleSource() {
    	cc_api_dl_ruleSource ruleSource = new cc_api_dl_ruleSource();
    	ruleSource.loadData();
    }
    
    public static void loadRuleTarget() {
    	cc_api_dl_ruleTarget ruleTarget = new cc_api_dl_ruleTarget();
    	ruleTarget.loadData();
    }
    
    public static void loadCoupons() {
    	cc_api_dl_coupons coupons = new cc_api_dl_coupons();
    	coupons.loadData();
    }
    
    public static void loadPricingModifier() {
    	cc_api_dl_priceModifier pricingModifier = new cc_api_dl_priceModifier();
    	pricingModifier.loadData();
    }
    
    public static void loadRulePricingModifier() {
    	cc_api_dl_rulePricingModifier rulePricingModifier = new cc_api_dl_rulePricingModifier();
    	rulePricingModifier.loadData();
    }
    
    public static void loadProductSpec() {
    	cc_api_dl_productSpec prodSpec = new cc_api_dl_productSpec();
    	prodSpec.loadData();
    }
    
    public static void loadPromotions() {
    	cc_api_dl_promotions promotions = new cc_api_dl_promotions();
    	promotions.loadData();
    }
    
    public static void loadProductMedia() {
    	cc_api_dl_productMedia prodMedia = new cc_api_dl_productMedia();
    	prodMedia.loadData();
    }
    
    static testMethod void myUnitTest() {
    	cc_hlpr_InitLoadCategories.initialize();
    	cc_hlpr_InitLoadCategories.loadTestCategories();
    	cc_hlpr_InitLoadCategories.loadTestProducts();
    	cc_hlpr_InitLoadCategories.loadTestProductCategories();
    	cc_hlpr_InitLoadCategories.loadTestPriceLists();
    	cc_hlpr_InitLoadCategories.loadTestPriceListItems();
    	cc_hlpr_InitLoadCategories.loadTestSpecs();
    	cc_hlpr_InitLoadCategories.loadProductSpecs();
    	cc_hlpr_InitLoadCategories.loadCompositeProducts();
    	cc_hlpr_InitLoadCategories.loadFeaturedProducts();
    	cc_hlpr_InitLoadCategories.loadRelatedProducts();
    	cc_hlpr_InitLoadCategories.loadRules();
    	cc_hlpr_InitLoadCategories.loadRuleSource();
    	cc_hlpr_InitLoadCategories.loadRuleTarget();
    	cc_hlpr_InitLoadCategories.loadCoupons();
    	cc_hlpr_InitLoadCategories.loadPricingModifier();
    	cc_hlpr_InitLoadCategories.loadRulePricingModifier();
    	cc_hlpr_InitLoadCategories.loadProductSpec();
    	cc_hlpr_InitLoadCategories.loadPromotions();
    	cc_hlpr_InitLoadCategories.loadProductMedia();
    	system.assert([Select c.Id From E_Category__c c where c.CATEGORYID__C in ('0', '99999', '99998', '88888', '88887') ].size() != 0);
    }
}