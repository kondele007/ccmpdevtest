//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without
//  modification is PROHIBITED.
//
//
public class cc_util_Coupon_va {
	//==================================================
    // STATIC SERVICE METHODS
    //==================================================
    /**
     * verifies coupon is applicable for the current cart
     *
     * coupon: the E_Coupon__c to validate
     * cartId: the Id of the current cart
     * cartProducts: the product Id and quantity of the items in the cart
     */
    public static String validateCouponRules(E_Coupon__c coupon, Id cartId, List<E_CartItem__c> cartItems, Double cartTotal) {
		
        System.debug('--- validateCouponRules: coupon=' + coupon);
        System.debug('--- validateCouponRules: coupon.Rule__r=' + coupon.Rule__r);

        cc_api_Cart capi = new cc_api_Cart();
		
        // check cart total
        //check dates + enabled flag ah
        if(!capi.isValidCoupon(coupon))
        {
        	System.debug('ah coupon is not valid 2/1/2013 00001413');
        	return 'The coupon is not valid';
        }
        if(coupon.Rule__r.RuleMinAmt__c != null) {
            if(cartTotal == null) {
                cartTotal = capi.getCartTotal(cartId);
            }
            if(cartTotal < coupon.Rule__r.RuleMinAmt__c) {
                System.debug('--- validateCouponRules: returning result=MinAmountNotMet');
                return Label.coupon_msg_min_amount;
            }
        }

        Map<Id,E_CartItem__c> cartProductMap = cc_util_Cart.getCartProductMap(cartItems);
        System.debug('--- validateCouponRules: cartProductMap=' + cartProductMap);

        if(coupon.Rule__r.RuleMinQty__c != null) {
            Double cartTotalQty = 0.0;
            for(String cartProductKey : cartProductMap.keySet()) {
                cartTotalQty += cartProductMap.get(cartProductKey).Quantity__c;
            }
            if(cartTotalQty < coupon.Rule__r.RuleMinQty__c) {
                System.debug('--- validateCouponRules: returning result=MinQuantityNotMet');
                return Label.coupon_msg_min_quantity;
            }
        }

        String result = 'Success';
        Boolean passedSourceTest = true;
        Boolean passedTargetTest = true;
        Double sourceMinQty = 0.0;
        List<E_CartItem__c> sourceMatches = new List<E_CartItem__c>();
        List<E_CartItem__c> targetMatches = new List<E_CartItem__c>();

        // check for source products
        if(cc_cnst_PickListConstants.RULERELATION_SKU.equalsIgnoreCase(coupon.Rule__r.SourceRelation__c)) {
            System.debug('--- validateCouponRules: validating source products exist');
            passedSourceTest = false;

            List<E_RuleSourceSKU__c> sources = [select Product__c, MinQty__c from E_RuleSourceSKU__c where Rule__c = :coupon.Rule__c LIMIT 1];
            if(sources.size() == 1) {
                E_RuleSourceSKU__c source = sources[0];
                //setting source min qty
                sourceMinQty=source.MinQty__c;
                System.debug('--- verifying source sku is in cart: product=' + source.Product__c + ', MinQty=' + source.MinQty__c);
                E_CartItem__c sourceItem = cartProductMap.get(source.Product__c);
                if(sourceItem != null && sourceItem.Quantity__c != null && sourceItem.Quantity__c >= source.MinQty__c) {
                    sourceMatches.add(sourceItem);
                    passedSourceTest = true;
                }
                System.debug('ah passedsourcetest' + passedSourceTest); 
            }
        } else if(cc_cnst_PickListConstants.RULERELATION_SPEC.equalsIgnoreCase(coupon.Rule__r.SourceRelation__c)) {
            System.debug('--- validateCouponRules: validating source spec exists');
            passedSourceTest = false;

            Set<String> productSet = new Set<String>();
            for(E_CartItem__c item: cartItems) {
                productSet.add(String.valueOf(item.Product__c));
            }

            List<E_RuleSourceSpec__c> ruleSourceSPECList = [select Spec__c, SpecValue__c, MinQty__c
                                                              from E_RuleSourceSpec__c
                                                            where Rule__c = :coupon.Rule__c];

            if(ruleSourceSPECList.size() > 0) {
                E_RuleSourceSpec__c ruleSourceSpec = ruleSourceSPECList[0];
                sourceMinQty = ruleSourceSpec.MinQty__c;
				/*Kaplan - use realtime specs instead of SOQL*/
				List<E_ProductSpecIndex__c> allProductSpecs = cc_hlpr_LoadProductSpecRealTime.getRealTimeProductSpecIndicesList(new List<String>(productSet));
				List<E_ProductSpecIndex__c> productSpecs = new List<E_ProductSpecIndex__c>();
				for(E_ProductSpecIndex__c currSpecInd : allProductSpecs){
					if(currSpecInd.Spec__c == ruleSourceSpec.Spec__c && currSpecInd.SpecValue__c.contains(ruleSourceSpec.SpecValue__c))
						productSpecs.add(currSpecInd);
				}
                /*
                List<E_ProductSpecIndex__c> productSpecs = [select Product__c
                                                             from E_ProductSpecIndex__c
                                                             where Product__c in :productSet
                                                               and Spec__c = :ruleSourceSpec.Spec__c
                                                               and SpecValue__c = :ruleSourceSpec.SpecValue__c];
                */
                /*END Kaplan real time spec fix */
				System.debug('ruleSourceSPECList[0] TESTING!!!' + ruleSourceSPECList[0]);
				///System.debug('TESTINGAGAIN' + productSpecs);
                Double matchingQty = 0.0;
                for(E_ProductSpecIndex__c productSpec : productSpecs) {
                    E_CartItem__c item = cartProductMap.get(productSpec.Product__c);
                    sourceMatches.add(item);
                    if(!passedSourceTest) {
                        matchingQty += item.Quantity__c;
                        System.debug('!passedSourceTest');
                        System.debug('--- validateCouponRules: sourceMinQty=' + sourceMinQty + ', matchingQty=' + matchingQty);
                        System.debug('MatchingQTY!!!' + matchingQty +      'sourceMinQty' + sourceMinQty); 
                        if(matchingQty >= sourceMinQty) {
                            passedSourceTest = true;
                           
                        }
                         
                    }
                }
                passedSourceTest = true;
                System.debug('PASSED??' + passedSourceTest);
                
            }
        }

        if(passedSourceTest) {

            // check for target products
            if(cc_cnst_PickListConstants.RULERELATION_SKU.equalsIgnoreCase(coupon.Rule__r.Relation__c)) {
                System.debug('--- validateCouponRules: validating target products exist');
                passedTargetTest = false;

                List<E_RuleTargetSKU__c> ruleTargetSKUs = [select Product__c, Quantity__c from E_RuleTargetSKU__c where Rule__c = :coupon.Rule__c LIMIT 1];
                if(ruleTargetSKUs.size() == 1) {
                    E_RuleTargetSKU__c ruleTargetSKU = ruleTargetSKUs[0];
                    System.debug('--- verifying target sku is in cart: product=' + ruleTargetSKU.Product__c + ', Quantity=' + ruleTargetSKU.Quantity__c);
                    E_CartItem__c targetItem = cartProductMap.get(ruleTargetSKU.Product__c);
                    if(targetItem != null && targetItem.AllowsDiscounts__c) {
                        targetMatches.add(targetItem);
                        passedTargetTest = cc_util_Coupon_va.validateMatches(sourceMatches, targetMatches, sourceMinQty);
                    }
                    System.debug('ah passedTargetTest ' + passedTargetTest);
                }
            } else if(cc_cnst_PickListConstants.RULERELATION_SPEC.equalsIgnoreCase(coupon.Rule__r.Relation__c)) {
                System.debug('--- validateCouponRules: validating target spec exists');
                passedTargetTest = false;
				
                Set<String>  productSet = new Set<String>();
                for(E_CartItem__c item: cartItems) {
                    productSet.add(String.valueOf(item.Product__c));
                }
				
                List<E_RuleTargetSpec__c> ruleTargetSPECList = [select Spec__c, SpecValue__c
                                                                  from E_RuleTargetSpec__c
                                                                 where Rule__c = :coupon.Rule__c];

                if(ruleTargetSPECList.size() > 0) {
                    E_RuleTargetSpec__c ruleTargetSpec = ruleTargetSPECList[0];
					/*Kaplan - use realtime specs instead of SOQL*/
					List<E_ProductSpecIndex__c> allProductSpecs = cc_hlpr_LoadProductSpecRealTime.getRealTimeProductSpecIndicesList(new List<String>(productSet));
					List<E_ProductSpecIndex__c> targetProductSpecs = new List<E_ProductSpecIndex__c>();
					for(E_ProductSpecIndex__c currSpecInd : allProductSpecs){
						System.debug('JLL HERE ' + currSpecInd.SpecValue__c + ' is in ' + ruleTargetSpec.SpecValue__c);
						if(currSpecInd.Spec__c == ruleTargetSpec.Spec__c && currSpecInd.SpecValue__c.contains(ruleTargetSpec.SpecValue__c))
							targetProductSpecs.add(currSpecInd);
					}
	                /*
                    List<E_ProductSpecIndex__c> targetProductSpecs = [select Product__c
                                                                        from E_ProductSpecIndex__c
                                                                       where Product__c in :productSet
                                                                         and Spec__c = :ruleTargetSpec.Spec__c
                                                                         and SpecValue__c = :ruleTargetSpec.SpecValue__c];
					*/
					/*END Kaplan real time spec fix */
                    if(targetProductSpecs.size() > 0) {
                        for(E_ProductSpecIndex__c targetProductSpec : targetProductSpecs) {
                            E_CartItem__c targetItem = cartProductMap.get(targetProductSpec.Product__c);
                            if(targetItem != null && targetItem.AllowsDiscounts__c) {
                                targetMatches.add(targetItem);
                            }
                        }
                        
                    }
                    //if there is no matched target spec, return false -- roy.lou 09/27/2012
                    if(targetMatches != null && !targetMatches.isEmpty()) {
                    	passedTargetTest = cc_util_Coupon_va.validateMatches(sourceMatches, targetMatches, sourceMinQty);
                       	System.debug('passedTargetTest ' + passedTargetTest);
                        System.debug('sourceMatches, targetMatches, sourceMinQty' + sourceMatches + ', ' + targetMatches +', ' + sourceMinQty);
                    }
                }
            }
        } else {
            result = Label.coupon_msg_missing_source;
        }

        if(!passedTargetTest) {
            result = Label.coupon_msg_missing_target;
        }
         for(E_CartItem__c item: cartItems) 
         {         	         	
            if(!item.AllowsDiscounts__c)
            {
            	List<E_CartItem__c> cartItemList = new List<E_CartItem__c>();
            	
         		cartItemList.add(item);
         		
         		cc_bean_PriceInfo priceInfo = cc_ctrl_PricingEngine.getPriceMap(cartItemList, capi.accountID, System.today(), capi.retrieveCart(item.Cart__c).CurrencyISOCode__c, capi.retrieveCart(item.Cart__c).CustomerTypeCode__c).get(item.Product__r.SKU__c);
         		
            	result=System.Label.CouponFailMessage1 + ' '+ priceInfo.priceListItem.Pricelist__r.Name +' '+ System.Label.CouponFailMessage2;
            	     
            }
         }
		
        System.debug('--- validateCouponRules: returning result=' + result);
        return result;
    }

    /**
     * Gets the coupons for the cart and updates the line items and totals for the cart
     */
    public static void applyCouponsToCart(String cartId, List<E_CartItem__c> cartItems) {
        System.debug('--- applyCouponsToCart: cartId=' + cartId);
        
        if(cartId == null || cartId.length() < 1) {
            return;
        }

        cc_api_Cart capi = new cc_api_Cart();
        E_Cart__c cart = capi.retrieveCart(cartId);
        if(cart == null) {
        	System.debug('--- applyCouponsToCart: cart is null for cartId ' + cartId);
        	return;
        }

        List<E_CartCoupon__c> cartCoupons = capi.getCartCoupons(cartId);

        if(cartItems == null || cartItems.size() < 1) {
            // Delete the coupons since the cart is empty
            if(cartCoupons != null && cartCoupons.size() > 0){
                System.debug('--- applyCouponsToCart: deleting cart coupons since cart is empty');
                delete cartCoupons;
            }
            return;
        }

        Double modifiedPrice;
        cc_api_PricingRuleFactory factory = new cc_api_PricingRuleFactory();
        Map<Id,Integer> cartProducts = new Map<Id,Integer>();
        Integer totalSourceQuantity=0;

        Double cartTotal = capi.getCartTotal(cartId);
        System.debug('--- applyCouponsToCart: cartTotal=' + cartTotal + ', cart subtotalAmount2=' + cart.SubTotalAmount_2__c + ', cart totalDiscount=' + cart.TotalDiscount__c);

        // For each coupon
        for(E_CartCoupon__c cartCoupon : cartCoupons) {
            E_Coupon__c coupon = cartCoupon.Coupon__r;
            // Make sure it's valid
            String rulesPass = cc_util_Coupon_va.validateCouponRules(coupon, cart.Id, cartItems, cartTotal);
			System.debug('ah rulesPas ' + rulesPass + '/' + coupon.CouponType__c); 
            if(rulesPass != 'Success') {
            	
                // find the cartItem for the coupon and delete it
                if(coupon.CouponType__c == 'Absolute' || coupon.CouponType__c == 'Percentage') {
                    E_CartItem__c cartItem, item, cartItemCoupRef;
                    Integer i = 0;
                    System.debug('JLL About to enter for loop' + cartItems);
                    System.debug('JLL cartitems size ' + cartItems.size());
                    for(; i < cartItems.size(); i++) {
                    	System.debug('ah loop # ' + i);
                        item = cartItems.get(i);
                        System.debug('---JLL Line/Coupon info: --- ' + item.Product__r.SKU__c + '/' + item.Coupon__c + '/' + item.Coupon__r.CouponCode__c + '/' + coupon.CouponCode__c + '/' + coupon.Id);
                        if(item.Product__r.SKU__c == coupon.CouponCode__c) {
                            cartItem = item;
                            System.debug('--- applyCouponsToCart: found coupon to remove: ' + cartItem.Product__r.SKU__c + ',' + i);
                            //break;
                        }
                        else if(item.Coupon__r.CouponCode__c == coupon.CouponCode__c){
                        	System.debug('---JLL Found Coupon Ref--- ');
                        	cartItemCoupRef = item;
                        	System.debug('ah cartItemCoupRef' + cartItemCoupRef);
                        	//break;
                        }
                        System.debug('ah coupon.CouponCode__c' + coupon.CouponCode__c);
                    
                    if(cartItem!=null){
                        // Delete the cartItem from the list that represents the coupon
                        cartItems.remove(i);
                        cc_kap_utils_AppUtils.setCookie('removedCouponCookie', 'true');
                        // Delete the cartItem from the database that represents the coupon
                        delete cartItem;
                    }
                    else if(cartItemCoupRef != null){
						cartItemCoupRef.Coupon__c = null;
						cartItemCoupRef.DiscountAmount__c = null; 
						cartItemCoupRef.PercentDiscount__c = null; 
						cartItemCoupRef.AbsoluteDiscount__c = null; 
						System.debug('---JLL Removing Coupon Ref--- ');
						cc_kap_utils_AppUtils.setCookie('removedCouponCookie', 'true');
						update cartItemCoupRef;
                    }
                    }
                }
                // Delete the coupon
                delete cartCoupon;

                continue;
            }

            // clear out existing coupon id's on items
            for(E_CartItem__c eci : cartItems) {
                eci.Coupon__c = null;
            }
            //update cartItems;

            System.debug('--- applyCouponsToCart: getting modifier for coupon rule type=' + coupon.Rule__r.RuleType__c);
            cc_hlpr_PricingModifierBase modifier = factory.getModifier(coupon.Rule__r.RuleType__c);

            Map<Id,E_CartItem__c> cartProductMap = cc_util_Cart.getCartProductMap(cartItems);
            List<E_CartItem__c> sourceMatches = new List<E_CartItem__c>();
            List<E_CartItem__c> targetMatches = new List<E_CartItem__c>();
            Double sourceMinQty = 0.0;
            Double targetQty = 0.0;

            // check for source products
            if(cc_cnst_PickListConstants.RULERELATION_SKU.equalsIgnoreCase(coupon.Rule__r.SourceRelation__c)) {
                System.debug('--- applyCouponsToCart: getting cart items matching source SKU');

                List<E_RuleSourceSKU__c> sources = [select Product__c, MinQty__c from E_RuleSourceSKU__c where Rule__c = :coupon.Rule__c LIMIT 1];
               	System.debug('ah sources.size = ' + sources.size());
                if(sources.size() == 1) {
                    E_RuleSourceSKU__c source = sources[0];
                    E_CartItem__c srcCartItem=cartProductMap.get(source.Product__c);
                        if(srcCartItem!=null){
                        	sourceMatches.add(srcCartItem);
                        	totalSourceQuantity+=srcCartItem.quantity__c.intValue();
                        }
                    
                    sourceMinQty = source.MinQty__c;
                }
            } else if(cc_cnst_PickListConstants.RULERELATION_SPEC.equalsIgnoreCase(coupon.Rule__r.SourceRelation__c)) {
                System.debug('--- applyCouponsToCart: getting cart items matching source Spec');

                Set<String> productSet = new Set<String>();
                for(E_CartItem__c item: cartItems) {
                    productSet.add(String.valueOf(item.Product__c));
                }

                List<E_RuleSourceSpec__c> ruleSourceSPECList = [select Spec__c, SpecValue__c, MinQty__c
                                                                  from E_RuleSourceSpec__c
                                                                 where Rule__c = :coupon.Rule__c];

                if(ruleSourceSPECList.size() > 0) {
                    E_RuleSourceSpec__c ruleSourceSpec = ruleSourceSPECList[0];
                    sourceMinQty = ruleSourceSpec.MinQty__c;
					/*Kaplan - use realtime specs instead of SOQL*/
					List<E_ProductSpecIndex__c> allProductSpecs = cc_hlpr_LoadProductSpecRealTime.getRealTimeProductSpecIndicesList(new List<String>(productSet));
					List<E_ProductSpecIndex__c> productSpecs = new List<E_ProductSpecIndex__c>();
					for(E_ProductSpecIndex__c currSpecInd : allProductSpecs){
						if(currSpecInd.Spec__c == ruleSourceSpec.Spec__c && currSpecInd.SpecValue__c.contains(ruleSourceSpec.SpecValue__c))
							productSpecs.add(currSpecInd);
					}
					/*
                    for(E_ProductSpecIndex__c productSpec : [select    Product__c
                                                                  from E_ProductSpecIndex__c
                                                                 where Product__c in :productSet
                                                                   and Spec__c = :ruleSourceSpec.Spec__c
                                                                   and SpecValue__c = :ruleSourceSpec.SpecValue__c]) {
                    */
                    for(E_ProductSpecIndex__c productSpec : productSpecs){
                    /*END Kaplan real time spec fix */
                        E_CartItem__c srcCartItem=cartProductMap.get(productSpec.Product__c);
                        if(srcCartItem!=null){
                        	sourceMatches.add(srcCartItem);
                        	totalSourceQuantity+=srcCartItem.quantity__c.intValue();
                        }
                       
                        
                    }
                }
            }

            // check for target products
            if(cc_cnst_PickListConstants.RULERELATION_SKU.equalsIgnoreCase(coupon.Rule__r.Relation__c)) {
                System.debug('--- applyCouponsToCart: getting cart items matching target SKU');

                List<E_RuleTargetSKU__c> ruleTargetSKUs = [select Product__c, Quantity__c from E_RuleTargetSKU__c where Rule__c = :coupon.Rule__c LIMIT 1];
                System.debug('ah ruleTargetSkus.size() =  ' + ruleTargetSKUs.size()); 
                if(ruleTargetSKUs.size() == 1) {
                    E_RuleTargetSKU__c ruleTargetSKU = ruleTargetSKUs[0];
                    targetQty = ruleTargetSKU.Quantity__c;

                    E_CartItem__c targetItem = cartProductMap.get(ruleTargetSKU.Product__c);
                    if(targetItem != null) {
                        targetMatches.add(targetItem);
                    }
                }
            } else if(cc_cnst_PickListConstants.RULERELATION_SPEC.equalsIgnoreCase(coupon.Rule__r.Relation__c)) {
                System.debug('--- applyCouponsToCart: getting cart items matching target spec');

                Set<String> productSet = new Set<String>();
                for(E_CartItem__c item: cartItems) {
                    productSet.add(String.valueOf(item.Product__c));
                }

                List<E_RuleTargetSpec__c> ruleTargetSPECList = [select Spec__c, SpecValue__c, Quantity__c
                                                                  from E_RuleTargetSpec__c
                                                                 where Rule__c = :coupon.Rule__c];

                if(ruleTargetSPECList.size() > 0) {
                    E_RuleTargetSpec__c ruleTargetSpec = ruleTargetSPECList[0];
                    targetQty = ruleTargetSpec.Quantity__c;

					/*Kaplan - use realtime specs instead of SOQL*/
					List<E_ProductSpecIndex__c> allProductSpecs = cc_hlpr_LoadProductSpecRealTime.getRealTimeProductSpecIndicesList(new List<String>(productSet));
					List<E_ProductSpecIndex__c> targetProductSpecs = new List<E_ProductSpecIndex__c>();
					for(E_ProductSpecIndex__c currSpecInd : allProductSpecs){
						if(currSpecInd.Spec__c == ruleTargetSpec.Spec__c && currSpecInd.SpecValue__c.contains(ruleTargetSpec.SpecValue__c))
							targetProductSpecs.add(currSpecInd);
					}
	                /*
                    List<E_ProductSpecIndex__c> targetProductSpecs = [select Product__c
                                                                        from E_ProductSpecIndex__c
                                                                       where Product__c in :productSet
                                                                         and Spec__c = :ruleTargetSpec.Spec__c
                                                                         and SpecValue__c = :ruleTargetSpec.SpecValue__c];
					*/
					/*END Kaplan real time spec fix */
                    if(targetProductSpecs.size() > 0) {
                        for(E_ProductSpecIndex__c targetProductSpec : targetProductSpecs) {
                            E_CartItem__c targetItem = cartProductMap.get(targetProductSpec.Product__c);
                            if(targetItem != null) {
                                targetMatches.add(targetItem);
                            }
                        }
                    }
                }
            }

            List<E_CartItem__c> applicableTargetProducts = null;
            System.debug('ah source and target matches.size ' + sourceMatches.size() + ' ' + targetMatches.size());
            if(sourceMatches.size() > 0 || targetMatches.size() > 0) {
            	// apply coupon to individual line items

                /*
            	Integer fractionValue=0;
            	if(sourceMinQty>0){
            		fractionValue=Math.floor(totalSourceQuantity/sourceMinQty.intValue()).intValue();
            	}
            	integer sourceItemQty=  fractionValue * sourceMinQty.intValue();
            	integer targetItemQty =  fractionValue *  targetQty.intValue();
            	System.debug('----sourceItemQty----' + sourceItemQty);
            	System.debug('----targetItemQty----' + targetItemQty);
            	*/

                applicableTargetProducts = cc_util_Coupon_va.getApplicableTargetsVer2(sourceMatches, targetMatches, sourceMinQty.intValue(), targetQty.intValue());
                System.debug('----applicableTargetProducts-----' + applicableTargetProducts);
				
                Boolean updateCart = false;
                for(E_CartItem__c targetItem: applicableTargetProducts) {
                    E_CartItem__c item = cartProductMap.get(targetItem.product__c);

                    System.debug('--- applyCouponsToCart: ProductID_r.SKU__c=' + item.product__r.SKU__c + ', item.Quantity__c=' + item.Quantity__c + ', targetItem.Quantity__c=' + targetItem.Quantity__c);
                    updateCart = true;
                    item.Coupon__c = null;
                    // Add the percent or absolute discounts to the cart item
                    if(coupon.Rule__r.RuleType__c == 'Shipping') {
                        // This is a place-holder.  At this point only free
                        // ground shipping is implemented during the shipping
                        // price calculation.  This section can be enhanced for
                        // more complex shipping discounts later.
                    } else {
                        // apply discount to target quantity
                        modifiedPrice = modifier.applyModifier(targetItem.Quantity__c.intValue(), (Double)item.Price__c, coupon.Rule__r.ID);
                        System.debug('--- applyCouponsToCart: modifiedPrice from applyModifier=' + modifiedPrice);

                        if(modifiedPrice < 0.0) {
                            modifiedPrice = 0.0;
                            System.debug('--- applyCouponsToCart: adjusted modifiedPrice=' + modifiedPrice);
                        }

                        // add any additional qty at regular price to the modified price
                        Double remainingQty = item.Quantity__c - targetItem.Quantity__c;
                        System.debug('--- applyCouponsToCart: adjusted modifiedPrice=' + modifiedPrice + ', remainingQty=' + remainingQty);
                        if(remainingQty > 0) {
                            modifiedPrice += item.Price__c * remainingQty;
                        }

                        item.SubAmount__c = modifiedPrice;
                        System.debug('--- applyCouponsToCart: set item SubAmount__c=' + item.SubAmount__c);

                        item.AbsoluteDiscount__c = (item.Quantity__c * item.Price__c) - item.SubAmount__c;
                        System.debug('--- applyCouponsToCart: set item AbsoluteDiscount__c=' + item.AbsoluteDiscount__c);

                        item.PercentDiscount__c = (item.AbsoluteDiscount__c/(item.Quantity__c * item.Price__c))*100.00;
                        if(item.PercentDiscount__c > 100) {
                            item.PercentDiscount__c = 100.0;
                        }
                        System.debug('--- applyCouponsToCart: set item PercentDiscount__c=' + item.PercentDiscount__c);

                        item.Coupon__c = coupon.Id;
                        System.debug('--- applyCouponsToCart: updated item=' + item);
                    }
                }

                if(updateCart){
                    update cartItems;
                }

            } else {
            	// apply coupon to cart total as a separate line item
                System.debug('--------rule type: ' + coupon.Rule__r.RuleType__c + ', couponType=' + coupon.CouponType__c + ', coupon discountType=' + coupon.DiscountType__c);

                // Subtract from the cart subtotal
                if(coupon.DiscountType__c == 'Absolute'){
                    if(coupon.Rule__r.RuleType__c == 'Shipping'){
                        // This is a place-holder.  At this point only free
                        // ground shipping is implemented during the shipping
                        // price calculation.  This section can be enhanced for
                        // more complex shipping discounts later.
                    }
                    else {

                        //modifiedPrice = modifier.applyModifier(1, (Double)cart.SubTotalAmount_2__c, coupon.Rule__r.ID);
                        modifiedPrice = modifier.applyModifier(1, (Double)cart.SubTotalAmount_2__c, coupon.Rule__r.ID);
                        System.debug('-------------- modifiedPrice, st2, st: ' + modifiedPrice + ',' + cart.SubTotalAmount_2__c + ',' + cart.TotalDiscount__c);

                        // Add a CartItem for the coupon
                        capi.addCouponToCartAsLineItem(cart.ID, coupon.CouponCode__c, coupon.Rule__r.Name__c, 'coupon');
                        System.debug('-------------- added line item: ' + cart.ID + ',' + coupon.CouponCode__c + ',' + coupon.Rule__r.Name__c);

                        System.debug('-------------- ' + coupon.CouponCode__c + ',' + cart.Id);
                        List<E_CartItem__c> cartItemsDebug = [select e.ID,e.Price__c,e.SubAmount__c,e.Product__r.SKU__c, e.DeliveryDate__c, e.AllowsDiscounts__c from E_CartItem__c e where e.Cart__c = :cart.Id];
                        for(E_CartItem__c ci: cartItemsDebug){
                            System.debug('-------------- ci: ' + ci.Price__c + ',' + ci.SubAmount__c + ',' + ci.Product__r.SKU__c);

                        }

                        E_CartItem__c couponCartItem = [select e.ID,e.Price__c,e.SubAmount__c,e.Product__r.SKU__c, e.AllowsDiscounts__c from E_CartItem__c e where e.Product__r.SKU__c = :coupon.CouponCode__c and e.Cart__c = :cart.Id LIMIT 1];
                        couponCartItem.Price__c = (cart.SubTotalAmount_2__c-modifiedPrice) * (-1);
                        couponCartItem.SubAmount__c = (cart.SubTotalAmount_2__c-modifiedPrice) * (-1);
                        couponCartItem.DiscountAmount__c = cart.SubTotalAmount_2__c-modifiedPrice;
                        system.debug('sns-->couponCartItem.DiscountAmount__c = ' + couponCartItem.DiscountAmount__c);
                        couponCartItem.Quantity__c = 1;
                        couponCartItem.Coupon__c = coupon.Id;
                        couponCartItem.CartItemType__c = cc_cnst_PickListConstants.CARTITEM_COUPON;
                        System.debug('------------ price,subamount, ' + couponCartItem.Price__c + ',' + couponCartItem.SubAmount__c);
                        upsert couponCartItem;


                        Double totalDiscount = couponCartItem.Price__c*(-1);
                        Double remainingDiscount = totalDiscount;
                        System.debug('-----------------total discount: ' + totalDiscount);
                        E_CartItem__c lastItem;
                        for(E_CartItem__c item: cartItems){
                            lastItem = item;
                            // Absolute amount off order total

                            // Calculate and enter absolute amount off each item
                            // Calculate and enter percent off each item
                            System.debug('------------------ absolute, not SKU related---------');

                            //item.Coupon__c = coupon.Id;
                            item.AbsoluteDiscount__c = ((item.Quantity__c * item.Price__c)/cartTotal) * totalDiscount;
                            item.PercentDiscount__c = (item.AbsoluteDiscount__c/(item.Quantity__c * item.Price__c))*100;
                            System.debug('------------------ abs. discount: ' + item.AbsoluteDiscount__c);
                            System.debug('------------------ percent disct: ' + item.PercentDiscount__c);
                            remainingDiscount -= item.AbsoluteDiscount__c;
                        }
                        lastItem.AbsoluteDiscount__c += remainingDiscount;
                        lastItem.PercentDiscount__c = (lastItem.AbsoluteDiscount__c/(lastItem.Quantity__c * lastItem.Price__c))*100;
                        System.debug('------------------ abs. discount: ' + lastItem.AbsoluteDiscount__c);
                        System.debug('------------------ percent disct: ' + lastItem.PercentDiscount__c);
                    }
                }
                // Subtract from each item
                else { // coupon type == 'Discount', not SKU related
                    if(coupon.Rule__r.RuleType__c == 'Shipping'){
                        // This is a place-holder.  At this point only free
                        // ground shipping is implemented during the shipping
                        // price calculation.  This section can be enhanced for
                        // more complex shipping discounts later.
                    }
                    else {
                        System.debug('--- adding modified price to the cart items: ' + cartItems.size());
                        for(E_CartItem__c item: cartItems){
                            System.debug('------ applyCouponsToCart: beginningPrice: ' + item.Quantity__c.intValue() + '--' + item.Price__c + '--' + coupon.Rule__r.ID);
                            //Start - Case 00001011 - odd coupon calculations - 02/22/2010

                            //modifiedPrice = modifier.applyModifier(1, (Double)item.Price__c, coupon.Rule__r.ID);
                            modifiedPrice = modifier.applyModifier(item.Quantity__c.intValue(), (Double)item.Price__c, coupon.Rule__r.ID);
                            System.debug('------ applyCouponsToCart: modifiedPrice: ' + modifiedPrice);
                            //item.SubAmount__c = modifiedPrice + (item.Quantity__c-1)*item.Price__c;
                            item.SubAmount__c = modifiedPrice ;
                            item.Coupon__c = coupon.Id;

                            // Percentage off order total
                            // Enter percent off each item
                            // Calculate and enter amount off each item
                            System.debug('------------------ discount, not SKU related---------');
                            item.AbsoluteDiscount__c = (item.Quantity__c * item.Price__c) - item.SubAmount__c;
                            //End - Case 00001011 - odd coupon calculations - 02/22/2010
                            item.PercentDiscount__c = (item.AbsoluteDiscount__c/(item.Quantity__c * item.Price__c))*100;
                            System.debug('------------------ abs. discount: ' + item.AbsoluteDiscount__c);
                            System.debug('------------------ percent disct: ' + item.PercentDiscount__c);
                        }
                    }
                }
            }
        }
    }

    public static Boolean validateMatches(List<E_CartItem__c> sourceMatches, List<E_CartItem__c> targetMatches, Double sourceMinQty) {
        if(sourceMinQty == null || sourceMinQty <= 0.0) {
            return true;
        }

        Boolean result = false;
        System.debug('--- validateMatches: sourceMatches=' + sourceMatches);
        System.debug('--- validateMatches: targetMatches=' + targetMatches);
        System.debug('--- validateMatches: sourceMinQty=' + sourceMinQty);

        for(E_CartItem__c targetMatch : targetMatches) {
            System.debug('--- validateMatches: checking targetMatch=' + targetMatch);
			/* Kaplan NEW: don't evalaute targets if they don't allow discounts */
			if(targetMatch.AllowsDiscounts__c){
	            // verify sourceMatches meet minQty requirement while excluding targetMatch
	            Double passQty = 0.0;
	
	            for(E_CartItem__c sourceMatch : sourceMatches) {
	                Double sourceQty = sourceMatch.Quantity__c;
	                System.debug('--- validateMatches: checking sourceMatch=' + sourceMatch);
	
	                // the price of the source item must be greater than or equal to that of the target item
	                //if(sourceMatch.Price__c < targetMatch.Price__c) {
	                //    continue;
	                //}
	
	                if(sourceMatch.Product__c == targetMatch.Product__c) {
	                	System.debug('ah sourceQty ' + sourceQty); 
	                    sourceQty -= 1;
	                }
	
	                passQty += sourceQty;
	                System.debug('--- validateMatches: passQty=' + passQty);
					System.debug('ah passQty >=sourceMinQty ' + passQty + ' ' + sourceMinQty); 
	                if(passQty >= sourceMinQty) {
	                    result = true;
	                    break;
	                }
	            }
	
	            if(result) {
	                break;
	            }
			}
        }

        return result;
    }

    /**
     * Figure out which of the targetMatches to apply the discount to
     * sourcematches are not just sources and targetMatches are not just targets which get discount. sourceMatches are cartItems which are eligible "sources" as per defined rules.
     * targetMatches are eligible "targets" as per defined rules.
     */
/*
    public static List<E_CartItem__c> getApplicableTargets(List<E_CartItem__c> sourceMatches, List<E_CartItem__c> targetMatches, Double sourceMinQty, Double targetQty) {
        System.debug('--- getApplicableTargets: sourceMatches=' + sourceMatches);
        System.debug('--- getApplicableTargets: targetMatches=' + targetMatches);
        for(E_CartItem__c c1 : sourceMatches)
        {
        	System.debug('--- roy getApplicableTargets: sourceMatches=' + c1.Product__r.SKU__c + ' qty = ' + c1.Quantity__c);
        }
        for(E_CartItem__c c2 : targetMatches)
        {
        	System.debug('--- roy getApplicableTargets: targetMatches=' + c2.Product__r.SKU__c+ ' qty = ' + c2.Quantity__c);
        }
        System.debug('--- getApplicableTargets: sourceMinQty=' + sourceMinQty + ', targetQty=' + targetQty);

        List<E_CartItem__c> applicableTargets = new List<E_CartItem__c>();

        if(targetQty == null || targetQty <= 0.0) {
            return applicableTargets;
        }

        cc_hlpr_CartItemPriceComparator itemPriceComparator = new cc_hlpr_CartItemPriceComparator();

        Map<Id,E_CartItem__c> targetMap = cc_util_Cart.getCartProductMap(targetMatches);
        // remove sourceMatches * sourceMinQty from targetMatches
		
		Map<Id,E_CartItem__c> remainingTargetMatchMap = new Map<Id,E_CartItem__c>();
		for(Id key : targetMap.keySet()) {
			System.debug('--- roy1 getApplicableTargets: targetMap key=' + key +  ' productId' + targetMap.get(key).Product__r.SKU__c+ ' qty = ' + targetMap.get(key).Quantity__c);
            remainingTargetMatchMap.put(key, targetMap.get(key));
            System.debug('--- roy2 getApplicableTargets: targetMap key=' + key +  ' productId' + targetMap.get(key).Product__r.SKU__c+ ' qty = ' + targetMap.get(key).Quantity__c);
        }
		
        if(sourceMinQty != null && sourceMinQty > 0.0) {
            // sort sourceMatches by price, desc
            sourceMatches = al.ArrayUtils.qsort(sourceMatches, itemPriceComparator, false);
            System.debug('--- getApplicableTargets: sorted sourceMatches=' + sourceMatches);

            for(E_CartItem__c sourceMatch : sourceMatches) {
               
                if(targetMap.get(sourceMatch.Product__c) != null) {
                	E_CartItem__c targetMatch = targetMap.get(sourceMatch.Product__c).clone(false, true);
                	Id matchedProduct = sourceMatch.Product__c;
                    // reduce target qty by source qty or sourceMinQty, whichever is less
                    if(sourceMatch.Quantity__c > sourceMinQty) {
                        targetMatch.Quantity__c -= sourceMinQty;
                        sourceMinQty = 0.0;
                        remainingTargetMatchMap.put(matchedProduct, targetMatch);
                    } else {
                        sourceMinQty -= sourceMatch.Quantity__c;
                        targetMap.remove(sourceMatch.Product__c);
                        remainingTargetMatchMap.remove(sourceMatch.Product__c);
                    }
                    
                }
                
                if(sourceMinQty == 0.0) {
                    break;
                }
            }
        }
        List<E_CartItem__c> remainingTargetMatches = new List<E_CartItem__c>();
        for(Id key : remainingTargetMatchMap.keySet()) {
            E_CartItem__c copy = remainingTargetMatchMap.get(key).clone(false, true); // create a deep clone of the cart item without the id
            //copy.Product__r = targetMap.get(key).Product__r;
            remainingTargetMatches.add(copy);
        }
       
*/
/*

	if(sourceMinQty != null && sourceMinQty > 0.0) {
            // sort sourceMatches by price, desc
            sourceMatches = ArrayUtils.qsort(sourceMatches, itemPriceComparator, false);
            System.debug('--- getApplicableTargets: sorted sourceMatches=' + sourceMatches);

            for(E_CartItem__c sourceMatch : sourceMatches) {
                E_CartItem__c targetMatch = targetMap.get(sourceMatch.Product__c);
                if(targetMatch != null) {
                    // reduce target qty by source qty or sourceMinQty, whichever is less
                    if(sourceMatch.Quantity__c > sourceMinQty) {
                        targetMatch.Quantity__c -= sourceMinQty;
                        sourceMinQty = 0.0;
                    } else {
                        sourceMinQty -= sourceMatch.Quantity__c;
                        targetMap.remove(sourceMatch.Product__c);
                    }
                }

                if(sourceMinQty == 0.0) {
                    break;
                }
            }
        }

        List<E_CartItem__c> remainingTargetMatches = new List<E_CartItem__c>();
        for(Id key : targetMap.keySet()) {
            E_CartItem__c copy = targetMap.get(key).clone(false, true); // create a deep clone of the cart item without the id
            //copy.Product__r = targetMap.get(key).Product__r;
            remainingTargetMatches.add(copy);
        }
*/
/*
		for(Id key : targetMap.keySet()) {
            E_CartItem__c copy = targetMap.get(key); // create a deep clone of the cart item without the id
            System.debug('--- roy getApplicableTargets: targetMap item=' + copy.Product__r.SKU__c + ' qty = ' + copy.Quantity__c);
        }
        
		for(E_CartItem__c remainingTargetMatch : remainingTargetMatches) {
			System.debug('--- roy getApplicableTargets: remainingTargetMatches=' + remainingTargetMatch);
			System.debug('--- roy getApplicableTargets: remainingTargetMatches=' + remainingTargetMatch.Product__r.SKU__c );
			System.debug('--- roy getApplicableTargets: remainingTargetMatches=' + remainingTargetMatch.Product__r.SKU__c + ' qty = ' + remainingTargetMatch.Quantity__c);
		}

	
        // reduce target list to only the target quantity including the lowest priced items
        // sort targetMatches by price, asc
        remainingTargetMatches = al.ArrayUtils.qsort(remainingTargetMatches, itemPriceComparator, true);
        System.debug('--- getApplicableTargets: sorted remainingTargetMatches=' + remainingTargetMatches);

        for(E_CartItem__c remainingTargetMatch : remainingTargetMatches) {
            if(remainingTargetMatch.Quantity__c > targetQty) {
                remainingTargetMatch.Quantity__c = targetQty;
                applicableTargets.add(remainingTargetMatch);
                targetQty = 0.0;
            } else {
                applicableTargets.add(remainingTargetMatch);
                targetQty -= remainingTargetMatch.Quantity__c;
            }

            if(targetQty == 0.0) {
                break;
            }
        }

        System.debug('--- getApplicableTargets: returning applicableTargets=' + applicableTargets);
        return applicableTargets;
    }
*/
    
      /**
     * Figure out which of the targetMatches to apply the discount to
     * @ sourceMatches --> list of cart items that are eligible as "sources" as per the defined rules
     * @ targetMatches --> 
     */
     
     /* 
     public static List<E_CartItem__c> getApplicableTargetsVer2(List<E_CartItem__c> sourceMatches, List<E_CartItem__c> targetMatches, Integer sourceMinQty, Integer targetQty) {
        System.debug('--- getApplicableTargetsVer2: sourceMatches=' + sourceMatches);
        System.debug('--- getApplicableTargetsVer2: targetMatches=' + targetMatches);
        System.debug('--- getApplicableTargetsVer2: sourceMinQty=' + sourceMinQty + ', targetQty=' + targetQty);
        
        List<E_CartItem__c> applicableTargets = new List<E_CartItem__c>();

        // no targets, return empty cart item list
        if(targetMatches == null || targetQty == null || targetQty <= 0.0) {
            System.debug('--- getApplicableTargetsVer2: no targets, return empty cart item list');
            return applicableTargets;
        }
        if(sourceMinQty==null)
        {
        	sourceMinQty = 0; 
        	
        }
        if(sourceMatches == null) {
        	sourceMatches = new List<E_CartItem__c>();
        }
        
        Integer sourceMatchSize=sourceMatches.size();
        Integer targetMatchSize=targetMatches.size();
       
        Integer sourceMatchLoopIndex=0;
        Integer targetMatchLoopIndex=targetMatchSize-1;
        
        //variable to accumulate source quantity of the cart item quantity is less than source min quantity
        Decimal sourceAccumulator=0;
        cc_hlpr_CartItemPriceComparator itemPriceComparator = new cc_hlpr_CartItemPriceComparator();
        
        //sort sourceMatches by price, desc
        sourceMatches = al.ArrayUtils.qsort(sourceMatches, itemPriceComparator, false);
        
        //sort targetMatches by price, desc
        targetMatches = al.ArrayUtils.qsort(targetMatches, itemPriceComparator, false);

        Map<Id,E_CartItem__c> targetMap = cc_util_Cart.getCartProductMap(targetMatches);
        
        //iterate while still there are sources or target to match. The loop exits when there are no more sources to match or no more targets to match, whichever comes first
        while(sourceMatchLoopIndex < sourceMatchSize && targetMatchLoopIndex >= 0) {

            //clone the target since we might be updating target cart item
            E_CartItem__c targetMatchUnderConsideration=targetMatches.get(targetMatchLoopIndex).clone(false,true);
            System.debug('--- getApplicableTargetsVer2: targetMatchUnderConsideration=' + targetMatchUnderConsideration);

            //number of target quantities, that is eligible for discount.
            Double noOfTargets = targetQty;
        	
        	if(sourceMatchSize > 0) {
	        	E_CartItem__c sourceMatchUnderConsideration=sourceMatches.get(sourceMatchLoopIndex);
	        	Integer noOfSourceBlocks=(Math.floor((sourceAccumulator + sourceMatchUnderConsideration.Quantity__c)/sourceMinQty).intValue());
	        	
	        	System.debug('--- getApplicableTargetsVer2: noOfSourceBlocks=' + noOfSourceBlocks);
	        	System.debug('--- getApplicableTargetsVer2: sourceMatchUnderConsideration=' + sourceMatchUnderConsideration);
        	
	        	//cart item quantity is not sufficient to meet the sourceMinQty, accumulate until available source matches.
	        	if(noOfSourceBlocks==0){
	        		sourceAccumulator+=sourceMatchUnderConsideration.Quantity__c;
	        	}
	        	//got enough number of source blocks including sourceAccumulator. reinitialize accumulator to zero
	        	else{
	        		sourceAccumulator=0;
	        	}

	            //number of target quantities, that is eligible for discount.
	            noOfTargets *= noOfSourceBlocks;
            }
        	
        	System.debug('--- getApplicableTargetsVer2: noOfTargets=' + noOfTargets);
        	
        	Double addedTargetQty=0.0;
        	
        	//repat until we reach the requisite number of targets and there are more targets to match
        	while(addedTargetQty < noOfTargets && targetMatchLoopIndex >= 0) {
        		//the target item under consideration has more quantity than that eligible to be discounted
        		if(targetMatchUnderConsideration.Quantity__c > (noOfTargets-addedTargetQty)){
        			targetMatchUnderConsideration.Quantity__c = noOfTargets-addedTargetQty;
        		}
        		applicableTargets.add(targetMatchUnderConsideration);
        		addedTargetQty += targetMatchUnderConsideration.Quantity__c;
        		
        		System.debug('--- getApplicableTargetsVer2: addedTargetQty=' + addedTargetQty);
        		System.debug('--- getApplicableTargetsVer2: noOfTargets=' + noOfTargets);
        		//still have targets....set the next target.
        		if(targetMatchLoopIndex > 0) {
        		   targetMatchLoopIndex--;
        		   targetMatchUnderConsideration=targetMatches.get(targetMatchLoopIndex);
        		}
        	}
        	
        	sourceMatchLoopIndex++;
        }

        //return the applicable targets list
        System.debug('--- getApplicableTargetsVer2: returning applicableTargets=' + applicableTargets);
        return applicableTargets;
    }  */ 
    /*
    public static List<E_CartItem__c> getApplicableTargetsVer2(List<E_CartItem__c> sourceMatches, List<E_CartItem__c> targetMatches, Integer sourceMinQty, Integer targetQty) {
        List<E_CartItem__c> applicableTargets = new List<E_CartItem__c>();
        Map<ID, E_CartItem__c> applicableTargetMap = new Map<ID, E_CartItem__c>();

		// check if there are any targets
		if(targetMatches == null || targetQty == null || targetQty <= 0.0){
			System.debug(' - getApplicableTargetsVer3 targetQty: ' + targetQty);
			return applicableTargets;
		}
			System.debug(' - getApplicableTargetsVer3 targetMatches: ' + targetMatches.size());
		

		// ensure sourceMinQty is a valid number
     	if(sourceMinQty == null){
			// This means no source matches are required, only target matches
     		sourceMinQty = 0;
     	}
     	if(sourceMatches == null){
     		sourceMatches = new List<E_CartItem__c>();
     	}
		System.debug(' - getApplicableTargetsVer3 sourceMinQty: ' + sourceMinQty);
			System.debug(' - getApplicableTargetsVer3 sourceMatches: ' + sourceMatches.size());

		// Create a map that contains all sources and targets (the same cart item may be in both lists)
		Map<ID, E_CartItem__c> cartItemMap = new Map<ID, E_CartItem__c>();
		for(E_CartItem__c item: sourceMatches){
			// clone the item and put it in the map
			cartItemMap.put(item.ID, item.clone(true,true)); //prakash spec fix
			System.debug('-- getApplicableTargetsVer3: Adding source item to map: ' + item.ID);
		}
		for(E_CartItem__c item: targetMatches){
			// if the item is not already in the map clone it and put it in the map
			if(cartItemMap.get(item.ID)==null){
				cartItemMap.put(item.ID, item.clone(true,true)); //prakash spec fix
				System.debug('-- getApplicableTargetsVer3: Adding target item to map: ' + item.ID);
			}
		}

        //sort sourceMatches by price, desc
        cc_hlpr_CartItemPriceComparator itemPriceComparator = new cc_hlpr_CartItemPriceComparator();
        sourceMatches = al.arrayutils.qsort(sourceMatches, itemPriceComparator, false);
        //sort targetMatches by price, desc
        targetMatches = al.arrayutils.qsort(targetMatches, itemPriceComparator, false);

		Integer sourceIndex = 0;
		Integer targetIndex = targetMatches.size() - 1;    
		Boolean matchedSource = false;
//		Boolean matchedTarget = false; 	
		Decimal targetsToDiscount = 0.0;
		E_CartItem__c sourceItem = null;
     	while(targetIndex >= 0){
     		matchedSource = false;
//     		matchedTarget = false;
			// check if the source matches meet the sourceMinQty
			System.debug('-- getApplicableTargetsVer 3 - determine sources');
			if(sourceMinQty > 0){
				Decimal neededQuantity = sourceMinQty;
				
				// While the source quantity is not high enough, keep checking until the quantity is high enough or there are no more sources
				while(sourceIndex < sourceMatches.size() && !matchedSource){
					// Get the next source item from the map
					sourceItem = cartItemMap.get(sourceMatches[sourceIndex].ID);
					
					// If the quantity is high enough, decrement the quantity based on sourceMinQty and set matchedSource to true
					if(sourceItem.Quantity__c >= neededQuantity){
						sourceItem.Quantity__c -= neededQuantity;
						neededQuantity = 0.0;
						matchedSource = true;
						if(sourceItem.Quantity__c == 0){
							sourceIndex++;
						}
					}
					else { 
						// implies the quantity is less than we need
						neededQuantity -= sourceItem.Quantity__c;
						sourceItem.Quantity__c = 0;
						sourceIndex++;
					}
					
				}
				
			}
			else{
				matchedSource = true;
			}
			if(! matchedSource){
				break;
			}
			
			
			// get the target matches
			targetsToDiscount = targetQty;
			System.debug('-- getApplicableTargetsVer 3 - determine targets');
			while(targetsToDiscount > 0 && targetIndex >= 0){
				
				// Get the next target item - get it from the map - the cloned item
				E_CartItem__c targetItem = cartItemMap.get(targetMatches[targetIndex].ID);
				
				if(targetItem.Quantity__c > 0){
					// If the quantity is less than or equal to targetQty, add the entire cart item to applicable targets and continue
					if(targetItem.Quantity__c <= targetsToDiscount){
						// get the target from the map
						E_CartItem__c matchedTarget = applicableTargetMap.get(targetItem.ID);	
						if(matchedTarget == null){
							matchedTarget = targetItem.clone(false, true);
							applicableTargetMap.put(targetItem.ID, matchedTarget);
						}
						else {
							matchedTarget.Quantity__c += targetItem.Quantity__c;
						}
						targetsToDiscount -= targetItem.Quantity__c;
						targetItem.Quantity__c = 0;
						targetIndex--;
					}
					else {
						// If the quantity is greater than targetQty
						// get the target from the map
						E_CartItem__c matchedTarget = applicableTargetMap.get(targetItem.ID);	
						if(matchedTarget == null){
							matchedTarget = targetItem.clone(false, true);
							matchedTarget.Quantity__c = targetsToDiscount;
							applicableTargetMap.put(targetItem.ID, matchedTarget);
						}
						else {
							matchedTarget.Quantity__c += targetsToDiscount;
						}
						targetItem.Quantity__c -= targetsToDiscount;
						targetsToDiscount = 0;
					}
				}
				else {
					targetIndex--;
				}
			}


     	}
		System.debug('-- getApplicableTargetsVer 3 - return applicable targets: ' + applicableTargetMap.values());
     	return applicableTargetMap.values();
     }
     */ 
     public static List<E_CartItem__c> getApplicableTargetsVer2(List<E_CartItem__c> sourceMatches, List<E_CartItem__c> targetMatches, Integer sourceMinQty, Integer targetQty) {
        List<E_CartItem__c> applicableTargets = new List<E_CartItem__c>();
        Map<ID, E_CartItem__c> applicableTargetMap = new Map<ID, E_CartItem__c>();

		// check if there are any targets
		if(targetMatches == null || targetQty == null || targetQty <= 0.0){
			System.debug(' - getApplicableTargetsVer3 targetQty: ' + targetQty);
			return applicableTargets;
		}
			System.debug(' - getApplicableTargetsVer3 targetMatches: ' + targetMatches.size());
		

		// ensure sourceMinQty is a valid number
     	if(sourceMinQty == null){
			// This means no source matches are required, only target matches
     		sourceMinQty = 0;
     	}
     	if(sourceMatches == null){
     		sourceMatches = new List<E_CartItem__c>();
     	}
		System.debug(' - getApplicableTargetsVer3 sourceMinQty: ' + sourceMinQty);
			System.debug(' - getApplicableTargetsVer3 sourceMatches: ' + sourceMatches.size());

		// Create a map that contains all sources and targets (the same cart item may be in both lists)
		Map<ID, E_CartItem__c> cartItemMap = new Map<ID, E_CartItem__c>();
		for(E_CartItem__c item: sourceMatches){
			// clone the item and put it in the map
			cartItemMap.put(item.ID, item.clone(true,true)); //prakash spec fix
			System.debug('-- getApplicableTargetsVer3: Adding source item to map: ' + item.ID);
		}
		for(E_CartItem__c item: targetMatches){
			// if the item is not already in the map clone it and put it in the map
			if(cartItemMap.get(item.ID)==null){
				cartItemMap.put(item.ID, item.clone(true,true)); //prakash spec fix
				System.debug('-- getApplicableTargetsVer3: Adding target item to map: ' + item.ID);
			}
		}

        //sort sourceMatches by price, desc
        cc_hlpr_CartItemPriceComparator itemPriceComparator = new cc_hlpr_CartItemPriceComparator();
        sourceMatches = al.arrayutils.qsort(sourceMatches, itemPriceComparator, false);
        //sort targetMatches by price, desc
        targetMatches = al.arrayutils.qsort(targetMatches, itemPriceComparator, false);

		Integer sourceIndex = 0;
		Integer targetIndex = targetMatches.size() - 1;    
		Boolean matchedSource = false;
//		Boolean matchedTarget = false; 	
		Decimal targetsToDiscount = 0.0;
		E_CartItem__c sourceItem = null;
     	while(targetIndex >= 0){
     		matchedSource = false;
//     		matchedTarget = false;
			// check if the source matches meet the sourceMinQty
			System.debug('-- getApplicableTargetsVer 3 - determine sources');
			if(sourceMinQty > 0){
				Decimal neededQuantity = sourceMinQty;
				
				// While the source quantity is not high enough, keep checking until the quantity is high enough or there are no more sources
				while(sourceIndex < sourceMatches.size() && !matchedSource){
					// Get the next source item from the map
					sourceItem = cartItemMap.get(sourceMatches[sourceIndex].ID);
					
					// If the quantity is high enough, decrement the quantity based on sourceMinQty and set matchedSource to true
					if(sourceItem.Quantity__c >= neededQuantity){
						sourceItem.Quantity__c -= neededQuantity;
						neededQuantity = 0.0;
						matchedSource = true;
						if(sourceItem.Quantity__c == 0){
							sourceIndex++;
						}
					}
					else { 
						// implies the quantity is less than we need
						neededQuantity -= sourceItem.Quantity__c;
						sourceItem.Quantity__c = 0;
						sourceIndex++;
					}
					
				}
				
			}
			else{
				matchedSource = true;
			}
			if(! matchedSource){
				break;
			}
			
			
			// get the target matches
			targetsToDiscount = targetQty;
			System.debug('-- getApplicableTargetsVer 3 - determine targets');
			while(targetsToDiscount > 0 && targetIndex >= 0){
				
				// Get the next target item - get it from the map - the cloned item
				E_CartItem__c targetItem = cartItemMap.get(targetMatches[targetIndex].ID);
				
				if(targetItem.Quantity__c > 0){
					// If the quantity is less than or equal to targetQty, add the entire cart item to applicable targets and continue
					if(targetItem.Quantity__c <= targetsToDiscount){
						// get the target from the map
						E_CartItem__c matchedTarget = applicableTargetMap.get(targetItem.ID);	
						if(matchedTarget == null){
							matchedTarget = targetItem.clone(false, true);
							applicableTargetMap.put(targetItem.ID, matchedTarget);
						}
						else {
							matchedTarget.Quantity__c += targetItem.Quantity__c;
						}
						targetsToDiscount -= targetItem.Quantity__c;
						targetItem.Quantity__c = 0;
						targetIndex--;
					}
					else {
						// If the quantity is greater than targetQty
						// get the target from the map
						E_CartItem__c matchedTarget = applicableTargetMap.get(targetItem.ID);	
						if(matchedTarget == null){
							matchedTarget = targetItem.clone(false, true);
							matchedTarget.Quantity__c = targetsToDiscount;
							applicableTargetMap.put(targetItem.ID, matchedTarget);
						}
						else {
							matchedTarget.Quantity__c += targetsToDiscount;
						}
						targetItem.Quantity__c -= targetsToDiscount;
						targetsToDiscount = 0;
					}
				}
				else {
					targetIndex--;
				}
			}


     	}
		System.debug('-- getApplicableTargetsVer 3 - return applicable targets: ' + applicableTargetMap.values());
     	return applicableTargetMap.values();
     }
}