//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public class cc_bean_promotion {
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public String sku { get; set; }
    public String name { get; set; }
    public String couponCode { get; set; }
    public String longDescription { get; set; }
    public String shortDecription { get; set; }
    public String pageLocation { get; set;}
    public String locationType { get; set; }
    public integer sequence { get; set; }
    public Id uri { get; set; }
    public String imageUri { get; set; }
    public String imageSource { get; set; }
    public String imageStaticResource { get; set; }
    public boolean isProductRelated { get; set; }
    public String script {get;set;}
    public Boolean splashRotate {get;set;}
    public cc_bean_promotion(E_Promo__c promoObj) {
    	this.name = promoObj.Name;
    	if(promoObj.Coupon__r != null) {
    		this.couponCode = promoObj.Coupon__r.couponCode__c;
    	}
    	this.longDescription = promoObj.LongDesc__c;
    	this.shortDecription = promoObj.ShortDesc__c;
    	this.pageLocation = promoObj.PageLocation__c;
    	this.locationType = promoObj.LocationType__c;
    	this.sequence = promoObj.Sequence__c.intValue();
    	this.imageUri = promoObj.ImageURI__c;
    	if(promoObj.ImageSource__c == 'Attachment' && promoObj.Attachments != null && promoObj.Attachments.size() > 0) {
    		this.imageUri = promoObj.Attachments[0].id;
    		this.uri = promoObj.Attachments[0].id;
    	}
    	
    	this.imageSource = promoObj.ImageSource__c;
    	this.imageStaticResource = promoObj.StaticResource__c;
    	this.isProductRelated = boolean.valueOf(promoObj.ProductRelated__c);	
    	this.sku = promoObj.product__r.sku__c;
    	this.script=bindScriptValue(promoObj.Script__c,promoObj);
    }
    //return a promotion map --> map<pageLocation, map<locationType, promoBean>>
    public static map<String, map<String, cc_bean_promotion>> toPromotionBeanMap(List<E_Promo__c> promos) {
    	
    	map<String, map<String, cc_bean_promotion>> promotionMap = new map<String, map<String, cc_bean_promotion>>();
    	for(E_Promo__c promo : promos) {
    		if(!promotionMap.containsKey(promo.pageLocation__c)) {
    			promotionMap.put(promo.pageLocation__c, new map<String, cc_bean_promotion>());
    		}
    		if(!promotionMap.get(promo.pageLocation__c).containsKey(promo.locationType__c)) {
    			promotionMap.get(promo.pageLocation__c).put(promo.locationType__c, new cc_bean_promotion(promo));
    		}
    	}
    	return promotionMap;
    }
    
     public static map<String, map<String, list<cc_bean_promotion>>> toPromotionBeanMapList(List<E_Promo__c> promos) {
    	Decimal max = cc_cnst_CloudCraze.MAX_PROMOTION_PER_WIDGET;
    	map<String, map<String, list<cc_bean_promotion>>> promotionMap = new map<String, map<String, list<cc_bean_promotion>>>();
    	for(E_Promo__c promo : promos) {
    		if(!promotionMap.containsKey(promo.pageLocation__c)) {
    			promotionMap.put(promo.pageLocation__c, new map<String, list<cc_bean_promotion>>());
    		}
    		if(!promotionMap.get(promo.pageLocation__c).containsKey(promo.locationType__c)) {
    			promotionMap.get(promo.pageLocation__c).put(promo.locationType__c, new list<cc_bean_promotion>());
    		}
    		if(promotionMap.get(promo.pageLocation__c).get(promo.locationType__c).size() <= max)
    		{
    			promotionMap.get(promo.pageLocation__c).get(promo.locationType__c).add(new cc_bean_promotion(promo));
    		}
    	}
    	return promotionMap;
    }
    
    private static String bindScriptValue(String iscript, E_Promo__c promoObj) {
    	if(iscript!=null && iscript.contains('SCRIPT_IMAGE_URI') && promoObj!=null 
    	&& promoObj.ImageURI__c!=null && promoObj.ImageURI__c.length()>0) {
    		Boolean boverride=false;
    		if(promoObj.ImageSource__c!=null 
    		&& ('Splash Override Static Resource'.equalsIgnoreCase(promoObj.ImageSource__c) || 'Override Static Resource'.equalsIgnoreCase(promoObj.ImageSource__c))) {
    			boverride=true;
    		}
    		
    		iscript=iscript.replaceAll('SCRIPT_IMAGE_URI',cc_util_UserInterface.getccStaticResourceURL(boverride, promoObj.ImageURI__c) );
    	}
    	if(iscript!=null && iscript.contains('SCRIPT_NAME')) {
    		iscript=iscript.replaceAll('SCRIPT_NAME',promoObj.Name);
    	}
    	return iscript;
    }
}