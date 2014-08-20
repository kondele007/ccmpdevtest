//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_ctrl_promotion_va  extends cc_ctrl_CloudCraze_va {
	public static map<String, map<String, list<cc_bean_promotion>>> allPromoMap {get;set;}
	public String currentCartID { get; set; }
	public cc_ctrl_promotion_va getPromotionController() { return this; }
	public map<String, cc_bean_promotion> promoTypeMap { get; set; }
	public map<String, list<cc_bean_promotion>> promoTypeMapList { get; set; }
	public map<String, String> viewState2PageLocationMap = new map<String, String> {
		cc_cnst_CloudCraze.VS_CartView=>cc_cnst_CloudCraze.PL_ShoppingCart, 
		cc_cnst_CloudCraze.VS_DetailView=>cc_cnst_CloudCraze.PL_ProductDetail,
		cc_cnst_CloudCraze.VS_OrderReview=>cc_cnst_CloudCraze.PL_OrderReview,
		cc_cnst_CloudCraze.VS_OrderComplete=>cc_cnst_CloudCraze.PL_OrderConfirmation,
		cc_cnst_CloudCraze.VS_ListView=>cc_cnst_CloudCraze.PL_ProductListPage,
		cc_cnst_CloudCraze.VS_LandingPage=>cc_cnst_CloudCraze.PL_LandingPage,
		/*KAPLAN: Treat payment page like cart for purposes of promos*/
		cc_cnst_CloudCraze.VS_OrderPaymentReview=>cc_cnst_CloudCraze.PL_ShoppingCart
		//cc_cnst_CloudCraze.VS_InfoView=>null,
		//cc_cnst_CloudCraze.VS_PaymentView=>null,
		//cc_cnst_CloudCraze.VS_SearchResultsView=>null,
		//cc_cnst_CloudCraze.VS_PromotionView=>null,
		//cc_cnst_CloudCraze.VS_QuickOrder=>null,
		//cc_cnst_CloudCraze.VS_ConfigListView=>null,
		//cc_cnst_CloudCraze.VS_ShipRequestView=>null,
		//cc_cnst_CloudCraze.VS_ShipOptionsView=>null,
		//cc_cnst_CloudCraze.VS_MyAccount_Dashboard=>null,
		//cc_cnst_CloudCraze.VS_MyAccount_AccountInfo=>null,
		//cc_cnst_CloudCraze.VS_MyAccount_ViewOrder=>null,
		//cc_cnst_CloudCraze.VS_MyAccount_ViewCart=>null,
		//cc_cnst_CloudCraze.VS_MyAccount_ViewOrderSummary=>null,
		//cc_cnst_CloudCraze.VS_MyAccount_ViewCartSummary=>null
    };
	public String promotionViewState { get; set; }
	public cc_ctrl_promotion_va() {
		super();
		promoTypeMap = new map<String, cc_bean_promotion>();
		promotionViewState=Apexpages.currentPage().getParameters().get('viewState'); 
		currentCartID = ApexPages.currentPage().getParameters().get('cartID');
		System.debug(LoggingLevel.INFO, 'ryl-->promotionViewState =' + promotionViewState);
		promoTypeMap = getPromotionBeanMap(promotionViewState);
		promoTypeMapList = getPromotionBeanMapList(promotionViewState);
		loadAllPromo();
		system.debug(LoggingLevel.INFO, 'sns-->promoTypeMapList = ' + promoTypeMapList);
	}
	
	public cc_ctrl_promotion_va(ApexPages.StandardController c) { this(); }
	public cc_ctrl_promotion_va(cc_ctrl_HomePage ctrl) { this(); }
	public cc_ctrl_promotion_va(cc_ctrl_CloudCraze_va ctrl) { this(); }
	
	private String viewState2PageLocation(String viewState) {
		System.debug('ryl-->viewState2PageLocation viewState =' + viewState);
		if(viewState == null) {
			viewState = cc_cnst_CloudCraze.VS_LandingPage;
		}
		String pageLocation = viewState2PageLocationMap.get(viewState);
		System.debug('ryl-->viewState2PageLocation pageLocation =' + pageLocation);
		if(pageLocation == null) {
			pageLocation = cc_cnst_CloudCraze.PL_AllPages;
		}
		return pageLocation;
	}
	
	public map<String, cc_bean_promotion> getPromotionBeanMap(String viewState) {
		cc_api_promotion promo = new cc_api_promotion();
		return promo.getPromotionBeanMap(viewState2PageLocation(viewState));
	}
	public map<String, list<cc_bean_promotion>> getPromotionBeanMapList(String viewState) {
		cc_api_promotion promo = new cc_api_promotion();
		return promo.getPromotionBeanMapList(viewState2PageLocation(viewState));
	}

	//IL - Promotion / Splash
	private void loadAllPromo() {
		cc_api_promotion apiPromo = new cc_api_promotion();
		allPromoMap=apiPromo.getAllPromotionBeanMapList();
	}	
	public list<cc_bean_promotion> getPromoList(String pageLocation, String locationType) {
		System.debug('--- cc_ctrl_promotion_va.getPromoList: pageLocation=' + pageLocation + ', locationType=' + locationType);
		list<cc_bean_promotion> result = new list<cc_bean_promotion>();
		System.debug('--- cc_ctrl_promotion_va.getPromoList: allPromoMap=' + allPromoMap);
		if(allPromoMap!=null && allPromoMap.size()>0) {
			cc_api_promotion apiPromo = new cc_api_promotion();
			result=apiPromo.getPromoBeanList(allPromoMap, pageLocation, locationType);
		}
		return result;
	}
	//IL - Promotion / Splash
}