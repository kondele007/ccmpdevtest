public with sharing class cc_hlpr_CouponTrigger {
	private static boolean updateFromInsert = false;
	public static boolean hasAlreadyBeenInserted() {
        return updateFromInsert;
    }

    // By setting the variable to true, it maintains this  
    
    // new value throughout the duration of the request  
    
    // (or testMethod)  
    
    public static void setAlreadyBeenInsert(boolean flag) {
        updateFromInsert = flag;
    }
    
	//public map<string, E_Rule__c> cc2Rule { get; set; }
	public list<E_Coupon__c> updatedCoupons { get; set; }
	//public map<string, list<E_PriceModifier__c> > cc2PM  {get; set; }
	public list<E_PriceModifier__c> pricingModifiers {get; set; }
	//public map<string, E_Coupon__c> cc2Coupon { get; set; }
	public list<E_RulePricingModifier__c> rulePricingModifiers {get; set; }
	public list<E_RuleSourceSpec__c> ruleSrcSpecs { get; set; }
	public list<E_RuleSourceSKU__c> ruleSrcSkus { get; set; }
	public list<E_RuleTargetSpec__c> ruleTargetSpecs { get; set; }
	public list<E_RuleTargetSKU__c> ruleTargetSkus { get; set; }
	public list<E_RuleSourceSpec__c> deleteRuleSrcSpecs { get; set; }
	public list<E_RuleSourceSKU__c> deleteRuleSrcSkus { get; set; }
	public list<E_RuleTargetSpec__c> deleteRuleTargetSpecs { get; set; }
	public list<E_RuleTargetSKU__c> deleteRuleTargetSkus { get; set; }
	
	public list<E_Rule__c> rules { get; set; }
	public cc_hlpr_CouponTrigger() {
		//cc2Rule = new map<string, E_Rule__c>();
		//cc2PM = new map<string, list<E_PriceModifier__c> >();
		//cc2Coupon = new map<string, E_Coupon__c>();
		rulePricingModifiers = new list<E_RulePricingModifier__c>();
		pricingModifiers = new list<E_PriceModifier__c>();
		rules = new list<E_Rule__c>();
		updatedCoupons = new list<E_Coupon__c>();
		ruleSrcSpecs = new list<E_RuleSourceSpec__c>();
		ruleSrcSkus = new list<E_RuleSourceSKU__c>();
		ruleTargetSpecs = new list<E_RuleTargetSpec__c>();
		ruleTargetSkus = new list<E_RuleTargetSKU__c>();
		deleteRuleSrcSpecs = new list<E_RuleSourceSpec__c>();
		deleteRuleSrcSkus = new list<E_RuleSourceSKU__c>();
		deleteRuleTargetSpecs = new list<E_RuleTargetSpec__c>();
		deleteRuleTargetSkus = new list<E_RuleTargetSKU__c>();
	}
	
	public void createCoupons(list<E_Coupon__c> newCoupons) {
		list<E_Coupon__c> generalCoupons = new list<E_Coupon__c>();
		list<E_Coupon__c> cartTotalCoupons = new list<E_Coupon__c>();
		list<E_Coupon__c> shippingCoupons = new list<E_Coupon__c>();
		for(e_coupon__c c : newCoupons) {
			if('CartTotal'.equals(c.RuleType__c))
	        {
	            cartTotalCoupons.add(c);
	        }
	        else if('General'.equals(c.RuleType__c))
	        {
	            generalCoupons.add(c);
	        }
	        else if('Shipping'.equals(c.RuleType__c)){
	            shippingCoupons.add(c);
	        }
	        
		}
		createCartTotalCoupon(cartTotalCoupons);
	    createGeneralCoupon(generalCoupons);
	    createShippingCoupon(shippingCoupons);
		insert rules;
    	insert pricingModifiers;
    	insert rulePricingModifiers;
    	insert ruleSrcSpecs;
		insert ruleSrcSkus;
		insert ruleTargetSpecs;
		insert ruleTargetSkus;
    	update updatedCoupons;
	}
	public void createCartTotalCoupon(list<E_Coupon__c> newCoupons) {
		
		for(E_Coupon__c coupon : newCoupons) {
			E_Rule__c rule = new E_Rule__c(Name__c=coupon.CouponName__c, RuleId__c = coupon.id,
				RuleType__c= coupon.RuleType__c, RuleSource__c = 'Coupon', Enabled__c=true, 
				StartDate__c= coupon.StartDate__c, EndDate__c=coupon.EndDate__c, RuleMinQty__c=coupon.minQty__c,RuleMinAmt__c=coupon.cartTotalAmount__c);
			rules.add(rule);
			String pmfId = coupon.id +String.valueOf(Crypto.getRandomInteger());
			E_PriceModifier__c modifier = new E_PriceModifier__c(DiscountType__c=coupon.CouponType__c, PriceModifierID__c= pmfId,
				Amount__c=coupon.discountAmount__c, Quantity__c=coupon.minQty__c, CartTotalAmount__c=coupon.cartTotalAmount__c);
			pricingModifiers.add(modifier);
			
			E_RulePricingModifier__c rpm = new E_RulePricingModifier__c(Rule__r=new E_Rule__c(RuleId__c=coupon.id), PriceModifier__r=new E_PriceModifier__c(PriceModifierID__c= pmfId));
			
			rulePricingModifiers.add(rpm);
			updatedCoupons.add(new E_Coupon__c( id = coupon.id, rule__r = new E_Rule__c(RuleId__c = coupon.id)));
		}
	}
	
	public void createShippingCoupon(list<E_Coupon__c> newCoupons) {
		createGeneralCoupon(newCoupons);
	}
	
	public void createGeneralCoupon(list<E_Coupon__c> newCoupons) {
		for(E_Coupon__c coupon : newCoupons) {
			E_Rule__c rule = new E_Rule__c(Relation__c=coupon.TargetRelation__c,  Name__c=coupon.CouponName__c, RuleId__c = coupon.id,
	                RuleType__c=coupon.RuleType__c, SourceRelation__c=coupon.SourceRelation__c,
	                RuleSource__c = 'Coupon', Enabled__c=true, StartDate__c= coupon.StartDate__c, EndDate__c=coupon.EndDate__c, RuleMinQty__c=coupon.minQty__c,RuleMinAmt__c=coupon.cartTotalAmount__c);
			
			rules.add(rule);
			String pmfId = coupon.id +String.valueOf(Crypto.getRandomInteger());
			E_PriceModifier__c modifier = new E_PriceModifier__c(DiscountType__c=coupon.CouponType__c, PriceModifierID__c= pmfId,
				Amount__c=coupon.discountAmount__c, Quantity__c=coupon.minQty__c, CartTotalAmount__c=coupon.cartTotalAmount__c);
			pricingModifiers.add(modifier);
			
			E_RulePricingModifier__c rpm = new E_RulePricingModifier__c(Rule__r=new E_Rule__c(RuleId__c=coupon.id), PriceModifier__r=new E_PriceModifier__c(PriceModifierID__c= pmfId));
			
			rulePricingModifiers.add(rpm);
			updatedCoupons.add(new E_Coupon__c( id = coupon.id, rule__r = new E_Rule__c(RuleId__c = coupon.id)));
			if(cc_cnst_PickListConstants.RULERELATION_SKU.equalsIgnoreCase(coupon.SourceRelation__c)) {
	        	ruleSrcSkus.add(new E_RuleSourceSKU__c(rule__r = new E_Rule__c(RuleId__c=coupon.id),  Product__c=coupon.SourceProduct__c, MinQty__c=coupon.SourceMinQty__c));
	        } else if(cc_cnst_PickListConstants.RULERELATION_SPEC.equalsIgnoreCase(coupon.SourceRelation__c)) {
	        	ruleSrcSpecs.add(new E_RuleSourceSpec__c(rule__r = new E_Rule__c(RuleId__c=coupon.id), Spec__c = coupon.SourceSpec__c, SpecValue__c=coupon.SourceSpecValue__c, MinQty__c = coupon.SourceSpecMiniQty__c));
	        }
	        if(cc_cnst_PickListConstants.RULERELATION_SKU.equalsIgnoreCase(coupon.TargetRelation__c)) {
	        	ruleTargetSkus.add(new E_RuleTargetSKU__c(rule__r = new E_Rule__c(RuleId__c=coupon.id),  Product__c=coupon.TargetProduct__c, Quantity__c=coupon.TargetQty__c));
	        } else if(cc_cnst_PickListConstants.RULERELATION_SPEC.equalsIgnoreCase(coupon.TargetRelation__c)) {
	        	ruleTargetSpecs.add(new E_RuleTargetSpec__c(rule__r = new E_Rule__c(RuleId__c=coupon.id), Spec__c = coupon.TargetSpec__c, SpecValue__c=coupon.TargetSpecValue__c, Quantity__c = coupon.TargetSpecQty__c));
	        }
		}
	}
    
    private void updateCartTotalCoupon(list<E_coupon__c> coupons, map<Id, E_Coupon__c> oldMap) {
    	map<Id, E_Coupon__c> rule2Coupon = new map<Id, E_Coupon__c>();
    	list<id> ruleIds = new list<Id>();
		for(E_Coupon__c c:coupons){
			if(oldMap.get(c.Id).rule__c != null) {
				ruleIds.add(c.Rule__c);
				rule2Coupon.put(c.Rule__c, c);
			}
		}
		list<E_Rule__c> ccRules = [Select e.StartDate__c, e.SourceRelation__c, e.RuleType__c, e.RuleSource__c, e.RuleMinQty__c, e.RuleMinAmt__c, e.EndDate__c, e.Enabled__c From E_Rule__c e where id in :ruleIds];
		for(E_Rule__c r : ccRules) {
			E_Coupon__c c = rule2Coupon.get(r.id);
			r.Name__c = c.couponName__c;
			r.RuleType__c = c.RuleType__c;
			r.StartDate__c = c.StartDate__c;
			r.EndDate__c = c.EndDate__c;
			r.RuleMinQty__c = c.MinQty__c;
			r.RuleMinAmt__c=c.cartTotalAmount__c;
			
			
		}
		//add to update rule list
		rules.addAll(ccRules);
		
		list<E_RulePricingModifier__c> rpms = [Select e.StartDate__c, e.PriceModifier__r.Id, e.PriceModifier__r.Quantity__c, e.PriceModifier__r.DiscountType__c, e.PriceModifier__r.CartTotalAmount__c, e.PriceModifier__r.Amount__c, e.PriceModifier__c, e.Name, e.Id, e.EndDate__c, e.rule__c From E_RulePricingModifier__c e where e.rule__c in :ruleIds];
		list<E_PriceModifier__c> pms = new list<E_PriceModifier__c>();
		for(E_RulePricingModifier__c rpm : rpms) {
			E_Coupon__c c = rule2Coupon.get(rpm.rule__c);
			rpm.StartDate__c = c.StartDate__c;
			rpm.EndDate__c = c.EndDate__c;
			E_PriceModifier__c pm = rpm.PriceModifier__r;
			pm.DiscountType__c = c.CouponType__c;
			pms.add(pm);
			pm.Quantity__c = c.minQty__c;
			pm.Amount__c = c.discountAmount__c;
			pm.CartTotalAmount__c = c.cartTotalAmount__c;
		}
		pricingModifiers.addAll(pms);
		rulePricingModifiers.addAll(rpms);
		deleteRuleSrcSpecs.addAll([Select e.Id From E_RuleSourceSpec__c e where rule__c = :ruleIds]); 
		deleteRuleSrcSkus.addAll([Select e.Id From E_RuleSourceSKU__c e where rule__c = :ruleIds]);
		deleteRuleTargetSpecs.addAll([Select e.Id From E_RuleTargetSpec__c e where rule__c = :ruleIds]);
		deleteRuleTargetSkus.addAll([Select e.Id From E_RuleTargetSKU__c e where rule__c = :ruleIds]);
    }
    private void updateGeneralCoupon(list<E_coupon__c> coupons, map<Id, E_Coupon__c> oldMap) {
    	map<Id, E_Coupon__c> rule2Coupon = new map<Id, E_Coupon__c>();
    	list<id> ruleIds = new list<Id>();
		for(E_Coupon__c c:coupons){
			if(oldMap.get(c.Id).rule__c != null) {
				ruleIds.add(c.Rule__c);
				rule2Coupon.put(c.Rule__c, c);
			}
		}
		list<E_Rule__c> ccRules = [Select e.StartDate__c, e.SourceRelation__c, e.RuleType__c, e.RuleSource__c, e.RuleMinQty__c, e.RuleMinAmt__c, e.EndDate__c, e.Enabled__c From E_Rule__c e where id in :ruleIds];
		for(E_Rule__c r : ccRules) {
			E_Coupon__c c = rule2Coupon.get(r.id);
			r.Name__c = c.couponName__c;
			r.RuleType__c = c.RuleType__c;
			r.StartDate__c = c.StartDate__c;
			r.EndDate__c = c.EndDate__c;
			r.RuleMinQty__c = c.MinQty__c;
			r.RuleMinAmt__c=c.cartTotalAmount__c;
			r.Relation__c = c.TargetRelation__c;
			r.SourceRelation__c = c.SourceRelation__c;
		}
		//add to update rule list
		rules.addAll(ccRules);
		
		list<E_RulePricingModifier__c> rpms = [Select e.StartDate__c, e.PriceModifier__r.Id, e.PriceModifier__r.Quantity__c, e.PriceModifier__r.DiscountType__c, e.PriceModifier__r.CartTotalAmount__c, e.PriceModifier__r.Amount__c, e.PriceModifier__c, e.Name, e.Id, e.EndDate__c, e.rule__c From E_RulePricingModifier__c e where e.rule__c in :ruleIds];
		list<E_PriceModifier__c> pms = new list<E_PriceModifier__c>();
		for(E_RulePricingModifier__c rpm : rpms) {
			E_Coupon__c c = rule2Coupon.get(rpm.rule__c);
			rpm.StartDate__c = c.StartDate__c;
			rpm.EndDate__c = c.EndDate__c;
			E_PriceModifier__c pm = rpm.PriceModifier__r;
			pm.DiscountType__c = c.CouponType__c;
			pms.add(pm);
			pm.Quantity__c = c.minQty__c;
			pm.Amount__c = c.discountAmount__c;
			pm.CartTotalAmount__c = c.cartTotalAmount__c;
		}
		pricingModifiers.addAll(pms);
		rulePricingModifiers.addAll(rpms);
		
		deleteRuleSrcSpecs.addAll([Select e.Id From E_RuleSourceSpec__c e where rule__c in :ruleIds]); 
		deleteRuleSrcSkus.addAll([Select e.Id From E_RuleSourceSKU__c e where rule__c in :ruleIds]);
		deleteRuleTargetSpecs.addAll([Select e.Id From E_RuleTargetSpec__c e where rule__c in :ruleIds]);
		deleteRuleTargetSkus.addAll([Select e.Id From E_RuleTargetSKU__c e where rule__c in :ruleIds]);
		
		for(E_Coupon__c coupon : coupons) {
			if(cc_cnst_PickListConstants.RULERELATION_SKU.equalsIgnoreCase(coupon.SourceRelation__c)) {
	        	ruleSrcSkus.add(new E_RuleSourceSKU__c(rule__r = new E_Rule__c(RuleId__c=coupon.id),  Product__c=coupon.SourceProduct__c, MinQty__c=coupon.SourceMinQty__c));
	        } else if(cc_cnst_PickListConstants.RULERELATION_SPEC.equalsIgnoreCase(coupon.SourceRelation__c)) {
	        	ruleSrcSpecs.add(new E_RuleSourceSpec__c(rule__r = new E_Rule__c(RuleId__c=coupon.id), Spec__c = coupon.SourceSpec__c, SpecValue__c=coupon.SourceSpecValue__c, MinQty__c = coupon.SourceSpecMiniQty__c));
	        }
	        if(cc_cnst_PickListConstants.RULERELATION_SKU.equalsIgnoreCase(coupon.TargetRelation__c)) {
	        	ruleTargetSkus.add(new E_RuleTargetSKU__c(rule__r = new E_Rule__c(RuleId__c=coupon.id),  Product__c=coupon.TargetProduct__c, Quantity__c=coupon.TargetQty__c));
	        } else if(cc_cnst_PickListConstants.RULERELATION_SPEC.equalsIgnoreCase(coupon.TargetRelation__c)) {
	        	ruleTargetSpecs.add(new E_RuleTargetSpec__c(rule__r = new E_Rule__c(RuleId__c=coupon.id), Spec__c = coupon.TargetSpec__c, SpecValue__c=coupon.TargetSpecValue__c, Quantity__c = coupon.TargetSpecQty__c));
	        }
		}
		/*
		list<E_RuleSourceSKU__c> sourceSkus = [Select e.Id, e.Product__c, e.MinQty__c, e.rule__c From E_RuleSourceSKU__c e where rule__c = :ruleIds]; 
		for(E_RuleSourceSKU__c rss : sourceSkus) {
			E_Coupon__c c = rule2Coupon.get(rss.rule__c);
			rss.Product__c = c.SourceProduct__c;
			rss.MinQty__c = c.SourceMinQty__c;
		}
		ruleSrcSkus.addAll(sourceSkus);
		
		list<E_RuleSourceSpec__c> sourceSpecs = [Select e.Spec__c, e.SpecValue__c, e.MinQty__c, e.Id From E_RuleSourceSpec__c e where rule__c in :ruleIds];
		for(E_RuleSourceSpec__c rss : sourceSpecs) {
			E_Coupon__c c = rule2Coupon.get(rss.id);
			rss.Spec__c = c.SourceSpec__c;
			rss.SpecValue__c = c.SourceSpecValue__c;
			rss.MinQty__c = c.SourceMinQty__c;
		}
		ruleSrcSpecs.addAll(sourceSpecs);
		
		list<E_RuleTargetSKU__c> targetSkus = [Select e.Rule__c, e.RuleTargetSKUId__c, e.Quantity__c, e.Product__c, e.Name, e.Id From E_RuleTargetSKU__c e where rule__c in :ruleIds];
		for(E_RuleTargetSKU__c rss : targetSkus) {
			E_Coupon__c c = rule2Coupon.get(rss.Rule__c);
			rss.Product__c=c.TargetProduct__c;
			rss.Quantity__c=c.TargetQty__c;
		}
		ruleTargetSkus.addAll(targetSkus);
		
		list<E_RuleTargetSpec__c> targetSpecs = [Select e.Spec__c, e.SpecValue__c, e.MinQty__c, e.Id From E_RuleTargetSpec__c e where rule__c in :ruleIds];
		for(E_RuleTargetSpec__c rss : targetSpecs) {
			E_Coupon__c c = rule2Coupon.get(rss.id);
			rss.Spec__c = c.TargetSpec__c;
			rss.SpecValue__c = c.TargetSpecValue__c;
			rss.Quantity__c = c.TargetSpecQty__c;
		}
		ruleTargetSpecs.addAll(targetSpecs);
		*/
    }
    private void updateShippingCoupon(list<E_coupon__c> coupons, map<Id, E_Coupon__c> oldMap) {
    	updateGeneralCoupon(coupons, oldMap);
    }
    public void updateCoupon(list<E_coupon__c> coupons, map<Id, E_Coupon__c> oldMap) {
    	user u = [Select u.UserType, u.Contact.Account.IsCustomerPortal From User u where u.id = :userinfo.getUserId()]; 
    	if(u.Contact.Account.IsCustomerPortal) {
    		return;
    	}
    	list<E_Coupon__c> generalCoupons = new list<E_Coupon__c>();
		list<E_Coupon__c> cartTotalCoupons = new list<E_Coupon__c>();
		list<E_Coupon__c> shippingCoupons = new list<E_Coupon__c>();
		for(e_coupon__c c : coupons) {
			
			if('CartTotal'.equals(c.RuleType__c))
	        {
	            cartTotalCoupons.add(c);
	        }
	        else if('General'.equals(c.RuleType__c))
	        {
	            generalCoupons.add(c);
	        }
	        else if('Shipping'.equals(c.RuleType__c)){
	            shippingCoupons.add(c);
	        }
	        
		}
		
		updateCartTotalCoupon(cartTotalCoupons, oldMap);
	    updateGeneralCoupon(generalCoupons, oldMap);
	    updateShippingCoupon(shippingCoupons, oldMap);
	    
	    update rules;
    	update pricingModifiers;
    	update rulePricingModifiers;
    	
    	delete deleteruleSrcSpecs;
		delete deleteruleSrcSkus;
		delete deleteruleTargetSpecs;
		delete deleteruleTargetSkus;
		
    	insert ruleSrcSpecs;
		insert ruleSrcSkus;
		insert ruleTargetSpecs;
		insert ruleTargetSkus;
	}
	
	public void beforeUpdateCoupon(list<E_coupon__c> coupons, map<Id, E_Coupon__c> oldMap) {
    	list<E_Coupon__c> generalCoupons = new list<E_Coupon__c>();
		list<E_Coupon__c> cartTotalCoupons = new list<E_Coupon__c>();
		list<E_Coupon__c> shippingCoupons = new list<E_Coupon__c>();
		for(e_coupon__c c : coupons) {
			if('CartTotal'.equals(c.RuleType__c))
	        {
	            cartTotalCoupons.add(c);
	        }
	        else if('General'.equals(c.RuleType__c))
	        {
	            if(c.TargetRelation__c == cc_cnst_PickListConstants.RULERELATION_SPEC) {
	            	c.TargetProduct__c=null;
	            	c.TargetQty__c=0;
	            } else if(c.TargetRelation__c == cc_cnst_PickListConstants.RULERELATION_SKU) {
	            	c.TargetSpec__c = null;
	            	c.TargetSpecQty__c=0;
	            	c.TargetSpecValue__c=null;
	            } 
	            if(c.SourceRelation__c == cc_cnst_PickListConstants.RULERELATION_SPEC) {
	            	c.SourceProduct__c=null;
	            	c.SourceMinQty__c=0;
	            } else if(c.SourceRelation__c == cc_cnst_PickListConstants.RULERELATION_SKU) {
	            	c.SourceSpec__c = null;
	            	c.SourceSpecMiniQty__c=0;
	            	c.SourceSpecValue__c=null;
	            } else {
	            	c.SourceProduct__c=null;
	            	c.SourceMinQty__c=0;
	            	c.SourceSpec__c = null;
	            	c.SourceSpecMiniQty__c=0;
	            	c.SourceSpecValue__c=null;
	            }
	        }
	        else if('Shipping'.equals(c.RuleType__c)){
	            shippingCoupons.add(c);
	        }
	        
		}
		
		
	}
	
	public void removeCoupon(list<E_Coupon__c> coupons) {
	   	for (E_Coupon__c c : coupons) {
            if(c.TotalUsed__c >1) {
                c.addError('This coupon cannot be deleted because it has been used on one or more orders. You can disable the coupon to keep it from being used any more.');
                continue;
            }
            
            // check if other coupons use this rule
            Integer couponsUsingRule = [select count() from E_Coupon__c e where e.Rule__c = :c.Rule__c and e.isDeleted=false];
            if(couponsUsingRule == 1) {

                // this is the only coupon using the E_Rule, so delete:
                //     E_PriceModifier
                //     E_RulePricingModifier (child of E_PriceModifer and E_Rule, so will be deleted by deleting those)
                //     E_RuleTargetSKU
                //     E_RuleTargetSpec
                //     E_Rule
                
                List<E_RulePricingModifier__c> rpms = [select e.id, e.PriceModifier__r.Id from E_RulePricingModifier__c e where e.Rule__c=:c.Rule__c and e.isDeleted=false];
    
                List<E_PriceModifier__c> pms = new List<E_PriceModifier__c>();
                for(E_RulePricingModifier__c rpm : rpms) {
                    pms.add(rpm.PriceModifier__r);
                }
                if(pms.size() > 0) {
                    delete pms;
                }
    
                List<E_RuleTargetSKU__c> targetSkus = [select e.Id from E_RuleTargetSKU__c e where e.isDeleted = false and e.Rule__c=:c.Rule__c];
                if(targetSkus != null && targetSkus.size() > 0) {
                    delete targetSkus;
                }
    
                List<E_RuleTargetSpec__c> targetSpecs = [select e.Id from E_RuleTargetSpec__c e where e.isDeleted = false and e.Rule__c=:c.Rule__c];
                if(targetSpecs != null && targetSpecs.size() > 0) {
                    delete targetSpecs;
                }

                List<E_Rule__c> rules = [select e.Id from E_Rule__c e where e.isDeleted = false and e.Id=:c.Rule__c];
                if(rules != null && rules.size() > 0) {
                    delete rules;
                }
                
                List<E_CartItem__c> cartItemsWithCoupon = [select Id, Cart__c, Coupon__c, AllowsDiscounts__c from E_CartItem__c where Coupon__c = :c.Id and IsDeleted = false];
                if(cartItemsWithCoupon != null && cartItemsWithCoupon.size() > 0) {
                    for(E_CartItem__c item : cartItemsWithCoupon) {
                        item.Coupon__c = null;
                    }
                    update cartItemsWithCoupon;
                }
            }
	   }
	}
}