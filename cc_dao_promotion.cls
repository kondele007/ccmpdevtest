//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public class cc_dao_promotion {
	public static List<E_Promo__c> getPromotionForPageLocation(String pageLocation) {
		return [Select e.SplashRotate__c, e.Script__c, e.StartDate__c, e.ImageSource__c, e.ProductRelated__c, Product__r.sku__c, e.ShortDesc__c, e.StaticResource__c,
			e.Sequence__c, e.PageLocation__c, e.Name, e.LongDesc__c, e.LocationType__c, e.ImageURI__c, e.EndDate__c, 
			e.Enabled__c, e.Coupon__r.TargetProduct__r.sku__c, e.Coupon__r.RuleName__c, e.Coupon__r.DiscountType__c, 
			e.Coupon__r.CouponType__c, e.Coupon__r.CouponCode__c, e.Coupon__c, (SELECT Id, Name, ParentId FROM Attachments) From E_Promo__c e where e.StartDate__c <= TODAY and e.EndDate__c > TODAY 
			and e.Enabled__c = true and e.pageLocation__c = :pageLocation order by e.Sequence__c];
	}

	public static List<E_Promo__c> getAllPromotion() {
		return [Select e.SplashRotate__c, e.Script__c, e.StartDate__c, e.ImageSource__c, e.ProductRelated__c, Product__r.sku__c, e.ShortDesc__c, e.StaticResource__c,
			e.Sequence__c, e.PageLocation__c, e.Name, e.LongDesc__c, e.LocationType__c, e.ImageURI__c, e.EndDate__c, 
			e.Enabled__c, e.Coupon__r.TargetProduct__r.sku__c, e.Coupon__r.RuleName__c, e.Coupon__r.DiscountType__c, 
			e.Coupon__r.CouponType__c, e.Coupon__r.CouponCode__c, e.Coupon__c, (SELECT Id, Name, ParentId FROM Attachments) From E_Promo__c e where e.StartDate__c <= TODAY and e.EndDate__c > TODAY 
			and e.Enabled__c = true order by e.Sequence__c];
	}
	
	static testMethod void myUnitTest() {
		List<E_Promo__c> promolist = cc_dao_promotion.getAllPromotion();
		delete [select id from E_Promo__c where pageLocation__c = ''];
		System.assert(cc_dao_promotion.getPromotionForPageLocation('').size() == 0);
	}
}