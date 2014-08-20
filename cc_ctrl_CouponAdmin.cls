//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_ctrl_CouponAdmin {
	//==================================================
    // CONSTANTS
    //==================================================
   public static integer CouponCodeLen=20;
     //==================================================
    // INSTANCE VARIABLES
    //==================================================
    private ApexPages.StandardController controller;
   
    //==================================================
    // INSTANCE PROPERTIES
    //==================================================
   
    public String retURL {get; set;}
    
    public List<String> messages {get; set;}
    
    //==================================================
    // CONSTRUCTOR
    //==================================================
    public cc_ctrl_CouponAdmin(ApexPages.StandardController c){
        this.controller=c;
        
        retURL = ApexPages.currentPage().getParameters().get('retURL'); 
        messages = new List<String>();
        
        E_Coupon__c coupon = (E_Coupon__c) controller.getRecord();
        if(coupon.StartDate__c == null) {
        	coupon.StartDate__c = Date.Today();
        }
        if(coupon.EndDate__c == null) {
        	coupon.EndDate__c = Date.Today().addDays(60);
        } 
    }  
    
    public PageReference CheckClone() {
    	E_Coupon__c coupon = (E_Coupon__c) controller.getRecord();
    	string lRetVal = ApexPages.currentPage().getParameters().get('retURL');
    	string lClone = ApexPages.currentPage().getParameters().get('clone');
    	if(lClone == '1') {
    	 	E_Coupon__c newCoupon = coupon.clone(false, true);
    	 	System.debug('cloned coupon-->' +  newCoupon);
    	 	newCoupon.couponCode__c = 'coupon-' +String.valueOf(Crypto.getRandomInteger());
    	 	if(newCoupon.couponCode__c.length() > CouponCodeLen) {
    	 		newCoupon.couponCode__c = newCoupon.couponCode__c.subString(0, CouponCodeLen-1);
    	 	}
    	 	newCoupon.couponName__c = newCoupon.couponName__c+'-copy';
    	 	newCoupon.TotalUsed__c = 0;
			insert newCoupon;
    	 	PageReference home = new PageReference('/' + newCoupon.id+'/e');
    	 	home.getParameters().put('retURL', lRetVal);
            home.setRedirect(true);
            return home;
    	}
    	else {
    		return null;
    	}
    	 
    }
    //==================================================
    // SERVICE METHODS
    //==================================================
     public PageReference saveCoupon(){
     	
        messages.clear();
        E_Coupon__c coupon = (E_Coupon__c) controller.getRecord();
        
       
        coupon.DiscountType__c=coupon.CouponType__c;
        //System.debug('--- cc_ctrl_Coupon.createCoupon: coupon.DiscountType__c=' + coupon.DiscountType__c);
		
		if(coupon.RuleType__c == null || 'null'.equals(coupon.RuleType__c))
        {
            messages.add(Label.coupon_msg_admin_missing_ruletype);
        }
        
        if(coupon.DiscountType__c == null || 'null'.equals(coupon.DiscountType__c))
        {
            messages.add(Label.coupon_msg_admin_missing_discounttype);
        }
        
        if('CartTotal'.equals(coupon.RuleType__c)) {
        	if(coupon.CartTotalAmount__c == null) {
        		messages.add(Label.coupon_msg_admin_missing_cart_total_amount);
        	}
        	//reset general coupon related attributes
        	coupon.TargetRelation__c = null;
        	coupon.SourceRelation__c = null;
        	coupon.TargetProduct__c  = null;
        	coupon.SourceProduct__c = null;
        	coupon.TargetSpec__c = null;
        	coupon.SourceSpec__c = null;
        	coupon.TargetQty__c = null;
        	coupon.TargetSpecValue__c =null;
        	coupon.TargetSpecQty__c = null;
        	coupon.SourceMinQty__c = null;
        	coupon.SourceSpecValue__c = null;
        	coupon.SourceSpecMiniQty__c = null;
        	
        } else if ('General'.equals(coupon.RuleType__c) || 'Shipping'.equals(coupon.RuleType__c)) {
        	coupon.CartTotalAmount__c=null;
        	if(coupon.SourceRelation__c != null && !'null'.equals(coupon.SourceRelation__c)) {
        		if(cc_cnst_PickListConstants.RULERELATION_SKU.equals(coupon.SourceRelation__c)) {
        			if(coupon.SourceProduct__c == null) {
        				messages.add(Label.coupon_msg_admin_missing_source_product);
        			}
        			if(coupon.SourceMinQty__c == null) {
        				messages.add(Label.coupon_msg_admin_missing_source_min_qty);
        			}
        		} else if(cc_cnst_PickListConstants.RULERELATION_SPEC.equals(coupon.SourceRelation__c)) {
        			if(coupon.SourceSpec__c == null) {
        				messages.add(Label.coupon_msg_admin_missing_source_spec);
        			}
        			if(coupon.SourceSpecValue__c == null) {
        				messages.add(Label.coupon_msg_admin_missing_source_spec_value);
        			}
        			if(coupon.SourceSpecMiniQty__c == null) {
        				messages.add(Label.coupon_msg_admin_missing_source_spec_min_qty);
        			}
        		}
   
        	}
        	if(coupon.TargetRelation__c == null || 'null'.equals(coupon.TargetRelation__c)) {
        		messages.add(Label.coupon_msg_admin_missing_target_relation_type);
        	} else {
        		if(cc_cnst_PickListConstants.RULERELATION_SKU.equals(coupon.TargetRelation__c)) {
        			if(coupon.TargetProduct__c == null) {
        				messages.add(Label.coupon_msg_admin_missing_target_product);
        			}
        			if(coupon.TargetQty__c == null) {
        				messages.add(Label.coupon_msg_admin_missing_target_min_qty);
        			}
        		} else if(cc_cnst_PickListConstants.RULERELATION_SPEC.equals(coupon.TargetRelation__c)) {
        			if(coupon.TargetSpec__c == null) {
        				messages.add(Label.coupon_msg_admin_missing_target_spec);
        			}
        			if(coupon.TargetSpecValue__c == null) {
        				messages.add(Label.coupon_msg_admin_missing_target_spec_value);
        			}
        			if(coupon.TargetSpecQty__c == null) {
        				messages.add(Label.coupon_msg_admin_missing_target_spec_min_qty);
        			}
        		}
        		
        	}
        	
        }
        if(messages.size() > 0)
        {
            //System.debug('createCoupon error messages:' + messages);
            return null;
        }
        coupon.TotalUsed__c=0.0;
        
		if(coupon.id == null) {
			insert coupon;
		} else {
			update coupon;
		}
		PageReference page = null;
		
        if(retURL != null)
        {
            page = new PageReference(retURL);
        }
        
        //System.debug('--- cc_ctrl_Coupon.createCoupon: returning coupon=' + coupon);
        return page;
     }
     
}