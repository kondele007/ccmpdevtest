//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public class cc_api_promotion {
	//==================================================
    // CONSTRUCTOR  
    //==================================================
    public cc_api_promotion() {
    	
    }
    
    public map<String, cc_bean_promotion> getPromotionBeanMap(String pageLocation) {
    	map<String, cc_bean_promotion> retMap = new map<String, cc_bean_promotion>();
    	List<E_Promo__c> promos = cc_dao_promotion.getPromotionForPageLocation(pageLocation);
    	map<String, map<String, cc_bean_promotion>> beanMap = cc_bean_promotion.toPromotionBeanMap(promos);
    	if(beanMap != null) {
    		retMap = beanMap.get(pageLocation);
    	} 
    	return retMap;
    }
    
    public map<String, list<cc_bean_promotion>> getPromotionBeanMapList(String pageLocation) {
    	map<String, list<cc_bean_promotion>> retMap = new map<String, list<cc_bean_promotion>>();
    	List<E_Promo__c> promos = cc_dao_promotion.getPromotionForPageLocation(pageLocation);
    	//system.debug('sns - promos = ' + promos);
    	map<String, map<String, list<cc_bean_promotion>>> beanMap = cc_bean_promotion.toPromotionBeanMapList(promos);
    	if(beanMap != null) {
    		retMap = beanMap.get(pageLocation);
    	} 
    	return retMap;
    }
	//IL - Splash Promotion
    public map<String, map<String, list<cc_bean_promotion>>> getAllPromotionBeanMapList() {
    	return cc_bean_promotion.toPromotionBeanMapList(cc_dao_promotion.getAllPromotion());
    }

	public list<cc_bean_promotion> getPromoBeanList(map<String, map<String, list<cc_bean_promotion>>> promoMap
	                                              , String pageLocation
	                                              , String locationType) {
		list<cc_bean_promotion> result = new list<cc_bean_promotion>();
		if(promoMap!=null && promoMap.size()>0) {
			if(pageLocation!=null && pageLocation.length()>0 && promoMap.containsKey(pageLocation)) {
				map<String, list<cc_bean_promotion>> locpromoMap = promoMap.get(pageLocation);
				if(locpromoMap!=null && locpromoMap.size()>0
				&& locationType!=null && locationType.length()>0
				&& locpromoMap.containsKey(locationType)) {
					result=locpromoMap.get(locationType);
				}
			}
		}                                            	
		return result;
	}
	//IL - Splash Promotion
}