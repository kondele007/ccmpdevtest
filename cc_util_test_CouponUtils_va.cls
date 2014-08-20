/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest 
private class cc_util_test_CouponUtils_va {
    
    static E_Cart__c testCart;
    
    static void setupData() {
        List<E_Product__c> ps = new List<E_Product__c>{
            new E_Product__c(Name='Product1', Sku__c='sku1', ProductStatus__c='Released', shippingWeight__c=20.0),
            new E_Product__c(Name='Product2', Sku__c='sku2', ProductStatus__c='Released', shippingWeight__c=20.0),
            new E_Product__c(Name='Product3', Sku__c='sku3', ProductStatus__c='Released', shippingWeight__c=20.0),
            new E_Product__c(Name='Product4', Sku__c='sku4', ProductStatus__c='Released', shippingWeight__c=20.0)
        };
        insert ps;
        testCart = new E_Cart__c(SessionID__c='anySessionId', CartType__c=cc_cnst_PickListConstants.CARTTYPE_CART);
        insert testCart;
        List<E_CartItem__c> cartItems = new List<E_CartItem__c> {
            new E_CartItem__c(Quantity__c=1, product__r=new E_Product__c(SKU__c='sku1'), cart__c=testCart.id, price__c=100, SubAmount__c=100.0),
            new E_CartItem__c(Quantity__c=1, product__r=new E_Product__c(SKU__c='sku2'), cart__c=testCart.id, price__c=100, SubAmount__c=100.0),
            new E_CartItem__c(Quantity__c=1, product__r=new E_Product__c(SKU__c='sku3'), cart__c=testCart.id, price__c=100, SubAmount__c=100.0),
            new E_CartItem__c(Quantity__c=1, product__r=new E_Product__c(SKU__c='sku4'), cart__c=testCart.id, price__c=100, SubAmount__c=100.0)
        };
        insert cartItems;
    }
    
    static List<E_CartItem__c> getCartItems(String cartId)
    {
        return  [Select c.Cart__c, c.Name, c.Product__r.Name, c.cartItemType__c, 
                    c.Product__r.ShortDesc__c, c.Product__r.SKU__c, c.Quantity__c, c.Price__c, c.SubAmount__c, c.Product__r.ProductType__c,
                    c.Coupon__c, c.AllowsDiscounts__c, (Select Cart__c, Name, Product__r.Name, cartItemType__c, 
                    Product__r.ShortDesc__c, Product__r.SKU__c, Quantity__c, Price__c, SubAmount__c, ProductType__c, AllowsDiscounts__c,
                    Coupon__c From Cart_Items__r) from E_CartItem__c c where  c.Cart__c = :cartId];
    }
    static List<E_CartItem__c> getTestSourceCartItems() {
        List<E_CartItem__c> cartItems = new List<E_CartItem__c>();
        
        E_CartItem__c cartItem1 = new E_CartItem__c(Quantity__c = 1);
        E_CartItem__c cartItem3 = new E_CartItem__c(Quantity__c = 1);
        E_CartItem__c cartItem2 = new E_CartItem__c(Quantity__c = 1);
        
        cartItems.add(cartItem1);
        cartItems.add(cartItem2);
        cartItems.add(cartItem3);
        
        return cartItems;
    }
    
    
    static List<E_CartItem__c> getTestTargetCartItems() {
        List<E_CartItem__c> cartItems = new List<E_CartItem__c>();
        
        E_CartItem__c cartItem1 = new E_CartItem__c(Quantity__c = 2);
        E_CartItem__c cartItem3 = new E_CartItem__c(Quantity__c = 2);
        E_CartItem__c cartItem2 = new E_CartItem__c(Quantity__c = 2);
        
        cartItems.add(cartItem1);
        cartItems.add(cartItem2);
        cartItems.add(cartItem3);
        
        return cartItems;
    }
    

    static testMethod void validateCartTotalCouponRulesTest() {
        String couponCode = cc_util_RandomString.randomAlphanumeric(10);
        cc_test_PrepTestData.loadAllCustomSettings();
        cc_test_PrepTestData.loadInitData();
        setupData();
        Date startDate = System.today();
        Date endDate = System.today().addMonths(2);
        E_Coupon__c coupon = new E_Coupon__c(DiscountType__c='Absolute', CouponType__c = 'Absolute', StartDate__c=startDate, EndDate__c=endDate,
            RuleType__c='CartTotal', MaxUse__c=2, TotalUsed__c=0, CouponCode__c=couponCode, CouponName__c=couponCode);
        insert coupon;  
        E_Rule__c rule = new E_Rule__c(Name__c='$10 off', 
                RuleType__c= coupon.RuleType__c, 
                RuleSource__c = 'Coupon', Enabled__c=true, StartDate__c= 
                coupon.StartDate__c, EndDate__c=coupon.EndDate__c, 
                RuleMinQty__c=1.0,RuleMinAmt__c=100.0);
        insert rule;
        
        E_PriceModifier__c modifier = new E_PriceModifier__c(DiscountType__c=coupon.DiscountType__c, 
                Amount__c=10.0, Quantity__c=3, CartTotalAmount__c=100.0);
        insert modifier;
        insert new E_RulePricingModifier__c(Rule__c=rule.Id, PriceModifier__c=modifier.Id);
        
        coupon.Rule__c=rule.Id;
        coupon.TotalUsed__c=0.0;
        
        update coupon;
        
        
        Test.startTest();

        List<E_CartItem__c> cartItems = cc_util_test_CouponUtils_va.getCartItems(testCart.id);
        
        coupon = [Select e.Rule__r.SourceRelation__c, e.Rule__r.StartDate__c, e.Rule__r.EndDate__c, e.Rule__r.RuleType__c, e.Rule__r.RuleSource__c, e.Rule__r.RuleMinQty__c, 
        e.Rule__r.RuleMinAmt__c, e.Rule__r.Name__c, e.Rule__r.CustomerTypeCode__c, e.Rule__r.CurrencyISOCode__c, e.Rule__c, e.Rule__r.Relation__c,
         e.RuleType__c, e.RuleName__c, e.Name, e.DiscountType__c, e.CouponType__c, e.TotalUsed__c, e.MaxUse__c, e.Enabled__c, e.CouponCode__c From E_Coupon__c e where e.CouponCode__c=:couponCode limit 1];
        
        System.debug('roy lou-> +' + coupon);        
        Double cartTotal = 400.0;
        E_CartCoupon__c cc = new E_CartCoupon__c(cart__c=testCart.id, coupon__c=coupon.id);
        insert cc;
        String validationResult = cc_util_Coupon_va.validateCouponRules(coupon, testCart.id, cartItems, cartTotal);
        System.assertEquals('Success', validationResult); 
        cc_util_Coupon_va.applyCouponsToCart(testCart.Id, cc_util_test_CouponUtils_va.getCartItems(testCart.id));
    }
    
    
    static testMethod void validateGeneralCouponRulesTest() {
        String couponCode = cc_util_RandomString.randomAlphanumeric(10);
        cc_test_PrepTestData.loadAllCustomSettings();
        cc_test_PrepTestData.loadInitData();
        setupData();
        insert new E_Product__c(Name=couponCode, Sku__c=couponCode, ProductStatus__c='Released', shippingWeight__c=20.0);
        insert new E_CartItem__c(Quantity__c=1, product__r=new E_Product__c(SKU__c=couponCode), cart__c=testCart.id, price__c=100, subamount__c=100);
        Double sourceMinQty = 1.0;
        Double targetQuantity = 1.0;
        Date startDate = System.today();
        Date endDate = System.today().addMonths(2);
        E_Coupon__c coupon = new E_Coupon__c(DiscountType__c='Absolute', CouponType__c = 'Absolute',  StartDate__c=startDate, EndDate__c=endDate,
            RuleType__c='General', MaxUse__c=2, TotalUsed__c=0, CouponCode__c=couponCode, CouponName__c=couponCode, SourceProduct__r=new E_Product__c(sku__c='sku1'),
            TargetProduct__r=new E_Product__c(sku__c='sku2'));
        insert coupon;  
        E_Rule__c rule = new E_Rule__c(Name__c='$10 off', 
                RuleType__c= coupon.RuleType__c, 
                RuleSource__c = 'Coupon', Enabled__c=true, StartDate__c= 
                coupon.StartDate__c, EndDate__c=coupon.EndDate__c, SourceRelation__c=cc_cnst_PickListConstants.RULERELATION_SKU,
                RuleMinQty__c=1.0,RuleMinAmt__c=100.0);
        insert rule;
        
        E_PriceModifier__c modifier = new E_PriceModifier__c(DiscountType__c=coupon.DiscountType__c, 
                Amount__c=10.0, Quantity__c=3, CartTotalAmount__c=100.0);
        insert modifier;
        insert new E_RulePricingModifier__c(Rule__c=rule.Id, PriceModifier__c=modifier.Id);
        insert new E_RuleSourceSKU__c(Rule__c=rule.Id, Product__r=new E_Product__c(sku__c='sku1'), MinQty__c=sourceMinQty);
        insert new E_RuleTargetSKU__c(Rule__c=rule.Id, Product__r=new E_Product__c(sku__c='sku2'),Quantity__c=targetQuantity);
        coupon.Rule__c=rule.Id;
        coupon.TotalUsed__c=0.0;
        
        update coupon;
        
        
        Test.startTest();

        List<E_CartItem__c> cartItems = cc_util_test_CouponUtils_va.getCartItems(testCart.id);
        
        coupon = [Select e.Rule__r.SourceRelation__c, e.Rule__r.StartDate__c, e.Rule__r.EndDate__c, e.Rule__r.RuleType__c, e.Rule__r.RuleSource__c, e.Rule__r.RuleMinQty__c, 
        e.Rule__r.RuleMinAmt__c, e.Rule__r.Name__c, e.Rule__r.CustomerTypeCode__c, e.Rule__r.CurrencyISOCode__c, e.Rule__c, e.Rule__r.Relation__c,
         e.RuleType__c, e.RuleName__c, e.Name, e.DiscountType__c, e.CouponType__c, e.TotalUsed__c, e.MaxUse__c, e.Enabled__c, e.CouponCode__c From E_Coupon__c e where e.CouponCode__c=:couponCode limit 1];
        
            
        Double cartTotal = 400.0;
        E_CartCoupon__c cc = new E_CartCoupon__c(cart__c=testCart.id, coupon__c=coupon.id);
        insert cc;
        String validationResult = cc_util_Coupon_va.validateCouponRules(coupon, testCart.id, cartItems, cartTotal);
        
        System.assertEquals('Success', validationResult); 
        cc_util_Coupon_va.applyCouponsToCart(testCart.Id, cc_util_test_CouponUtils_va.getCartItems(testCart.id));
    }
    
       
    static testMethod void getApplicableTargetsTest() {
        
        List<E_CartItem__c> sourceMatches = getTestSourceCartItems();
        List<E_CartItem__c> targetMatches = getTestTargetCartItems();
        Double sourceMinQty = 1.0;
        Double targetQty = 1.0;
        
        //cc_util_Coupon_va.getApplicableTargets(sourceMatches, targetMatches, sourceMinQty, targetQty);
        cc_util_Coupon_va.getApplicableTargetsVer2(sourceMatches, targetMatches, Integer.valueOf(sourceMinQty), Integer.valueOf(targetQty));
       system.assert(sourceMatches.size() != 0);
    }
    
    static testMethod void validateGeneralSKUCouponRulesTest() {
        String couponCode = cc_util_RandomString.randomAlphanumeric(10);
        cc_test_PrepTestData.loadAllCustomSettings();
        cc_test_PrepTestData.loadInitData();
        System.assert([Select c.Id From E_ApplicationSettings__c c where name='CloudCraze'].size() != 0); 
        setupData();
        insert new E_Product__c(Name=couponCode, Sku__c=couponCode, ProductStatus__c='Released', shippingWeight__c=20.0);
        insert new E_CartItem__c(Quantity__c=1, product__r=new E_Product__c(SKU__c=couponCode), cart__c=testCart.id, price__c=100, subamount__c=100, AllowsDiscounts__c = true);
        Double sourceMinQty = 1.0;
        Double targetQuantity = 1.0;
        Date startDate = System.today();
        Date endDate = System.today().addMonths(2);
        E_Coupon__c coupon = new E_Coupon__c(DiscountType__c='Absolute', CouponType__c = 'Absolute',  StartDate__c=startDate, EndDate__c=endDate,
            RuleType__c='General', MaxUse__c=2, TotalUsed__c=0, CouponCode__c=couponCode, SourceProduct__r=new E_Product__c(sku__c='sku1'),
            TargetProduct__r=new E_Product__c(sku__c='sku2'), CouponName__c=couponCode);
        insert coupon;  
        E_Rule__c rule = new E_Rule__c(Name__c='$10 off', 
                RuleType__c= coupon.RuleType__c, 
                RuleSource__c = 'Coupon', Enabled__c=true, StartDate__c= 
                coupon.StartDate__c, EndDate__c=coupon.EndDate__c, SourceRelation__c=cc_cnst_PickListConstants.RULERELATION_SKU, Relation__c=cc_cnst_PickListConstants.RULERELATION_SKU,
                RuleMinQty__c=1.0,RuleMinAmt__c=100.0);
        insert rule;
        
        E_PriceModifier__c modifier = new E_PriceModifier__c(DiscountType__c=coupon.DiscountType__c, 
                Amount__c=10.0, Quantity__c=3, CartTotalAmount__c=100.0);
        insert modifier;
        insert new E_RulePricingModifier__c(Rule__c=rule.Id, PriceModifier__c=modifier.Id);
        insert new E_RuleSourceSKU__c(Rule__c=rule.Id, Product__r=new E_Product__c(sku__c='sku1'), MinQty__c=sourceMinQty);
        insert new E_RuleTargetSKU__c(Rule__c=rule.Id, Product__r=new E_Product__c(sku__c='sku1'),Quantity__c=targetQuantity);
        coupon.Rule__c=rule.Id;
        coupon.TotalUsed__c=0.0;
        
        update coupon;
        
        
        Test.startTest();

        List<E_CartItem__c> cartItems = cc_util_test_CouponUtils_va.getCartItems(testCart.id);
        
        coupon = [Select e.Rule__r.SourceRelation__c, e.Rule__r.StartDate__c, e.Rule__r.EndDate__c, e.Rule__r.RuleType__c, e.Rule__r.RuleSource__c, e.Rule__r.RuleMinQty__c, 
        e.Rule__r.RuleMinAmt__c, e.Rule__r.Name__c, e.Rule__r.CustomerTypeCode__c, e.Rule__r.CurrencyISOCode__c, e.Rule__c, e.Rule__r.Relation__c,
         e.RuleType__c, e.RuleName__c, e.Name, e.DiscountType__c, e.CouponType__c, e.TotalUsed__c, e.MaxUse__c, e.Enabled__c, e.CouponCode__c From E_Coupon__c e where e.CouponCode__c=:couponCode limit 1];
        
        System.debug('roy lou-> +' + coupon);        
        Double cartTotal = 400.0;
        E_CartCoupon__c cc = new E_CartCoupon__c(cart__c=testCart.id, coupon__c=coupon.id);
        insert cc;
        String validationResult = cc_util_Coupon_va.validateCouponRules(coupon, testCart.id, cartItems, cartTotal);
        //System.assertEquals('Success', validationResult); 
        cc_util_Coupon_va.applyCouponsToCart(testCart.Id, cc_util_test_CouponUtils_va.getCartItems(testCart.id));
        String JSONString = JSON.serialize(coupon);
        System.debug('Serialized coupon into JSON format: ' + JSONString);  
    }
    
    static testMethod void validateGeneralSPECCouponRulesTest() {
        setupData();
        E_Spec__c spec = new E_Spec__c(name='spec1');
        insert spec;
        
        insert new  List<E_ProductSpecIndex__c> {
            new E_ProductSpecIndex__c(product__r=new E_Product__c(SKU__c='sku1'), Spec__c=spec.id, specValue__c='specValue', productSpecIndexId__c='sku1'),
            new E_ProductSpecIndex__c(product__r=new E_Product__c(SKU__c='sku2'), Spec__c=spec.id, specValue__c='specValue', productSpecIndexId__c='sku2')
        };
        String couponCode = cc_util_RandomString.randomAlphanumeric(10);
        cc_test_PrepTestData.loadAllCustomSettings();
        cc_test_PrepTestData.loadInitData();
        System.assert([Select c.Id From E_ApplicationSettings__c c where name='CloudCraze'].size() != 0); 
        insert new E_Product__c(Name=couponCode, Sku__c=couponCode, ProductStatus__c='Released', shippingWeight__c=20.0);
        insert new E_CartItem__c(Quantity__c=1, product__r=new E_Product__c(SKU__c=couponCode), cart__c=testCart.id, price__c=100, subamount__c=100);
        Double sourceMinQty = 1.0;
        Double targetQuantity = 1.0;
        Date startDate = System.today();
        Date endDate = System.today().addMonths(2);
        E_Coupon__c coupon = new E_Coupon__c(DiscountType__c='Absolute', CouponType__c = 'Absolute',  StartDate__c=startDate, EndDate__c=endDate,
            RuleType__c='General', MaxUse__c=2, TotalUsed__c=0, CouponCode__c=couponCode, SourceProduct__r=new E_Product__c(sku__c='sku1'),
            TargetProduct__r=new E_Product__c(sku__c='sku2'), CouponName__c=couponCode);
        insert coupon;  
        E_Rule__c rule = new E_Rule__c(Name__c='$10 off', 
                RuleType__c= coupon.RuleType__c, 
                RuleSource__c = 'Coupon', Enabled__c=true, StartDate__c= 
                coupon.StartDate__c, EndDate__c=coupon.EndDate__c, SourceRelation__c=cc_cnst_PickListConstants.RULERELATION_SPEC, Relation__c=cc_cnst_PickListConstants.RULERELATION_SPEC,
                RuleMinQty__c=1.0,RuleMinAmt__c=100.0);
        insert rule;
        
        E_PriceModifier__c modifier = new E_PriceModifier__c(DiscountType__c=coupon.DiscountType__c, 
                Amount__c=10.0, Quantity__c=3, CartTotalAmount__c=100.0);
        insert modifier;
        insert new E_RuleSourceSpec__c(rule__c=rule.Id, SpecValue__c='specValue', MinQty__c=1.0, Spec__c=spec.id);
        insert new E_RuleTargetSpec__c(rule__c=rule.Id, SpecValue__c='specValue', Spec__c=spec.id,Quantity__c=1.0);
        
 
        insert new E_RulePricingModifier__c(Rule__c=rule.Id, PriceModifier__c=modifier.Id);
        
        coupon.Rule__c=rule.Id;
        coupon.TotalUsed__c=0.0;
        
        update coupon;
        
        
        Test.startTest();

        List<E_CartItem__c> cartItems = cc_util_test_CouponUtils_va.getCartItems(testCart.id);
        
        coupon = [Select e.Rule__r.SourceRelation__c, e.Rule__r.StartDate__c, e.Rule__r.EndDate__c, e.Rule__r.RuleType__c, e.Rule__r.RuleSource__c, e.Rule__r.RuleMinQty__c, 
        e.Rule__r.RuleMinAmt__c, e.Rule__r.Name__c, e.Rule__r.CustomerTypeCode__c, e.Rule__r.CurrencyISOCode__c, e.Rule__c, e.Rule__r.Relation__c,
         e.RuleType__c, e.RuleName__c, e.Name, e.DiscountType__c, e.CouponType__c, e.TotalUsed__c, e.MaxUse__c, e.Enabled__c, e.CouponCode__c From E_Coupon__c e where e.CouponCode__c=:couponCode limit 1];
        
        System.debug('roy lou-> +' + coupon);        
        Double cartTotal = 400.0;
        E_CartCoupon__c cc = new E_CartCoupon__c(cart__c=testCart.id, coupon__c=coupon.id);
        insert cc;
        String validationResult = cc_util_Coupon_va.validateCouponRules(coupon, testCart.id, cartItems, cartTotal);
        //System.assertEquals('Success', validationResult); 
        cc_util_Coupon_va.applyCouponsToCart(testCart.Id, cc_util_test_CouponUtils_va.getCartItems(testCart.id));
    }
    
}