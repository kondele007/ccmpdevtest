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
private class cc_ctrl_test_SpecCoupon {
	static e_cart__c cart1;
	static e_cart__c cart2;
	static void setupData() {
		List<E_Product__c> ps = new List<E_Product__c>{
			new E_Product__c(Name='Product1', Sku__c='sku1', ProductStatus__c='Released', shippingWeight__c=20.0),
			new E_Product__c(Name='Product2', Sku__c='sku2', ProductStatus__c='Released', shippingWeight__c=20.0)
			
		};
		insert ps;
		cart1 = new E_Cart__c(cartid__c='cart1', SessionID__c='cart1', CartType__c=cc_cnst_PickListConstants.CARTTYPE_CART);
		cart2 = new E_Cart__c(cartid__c='cart2', SessionID__c='cart2', CartType__c=cc_cnst_PickListConstants.CARTTYPE_CART);
		insert cart1;
		insert cart2;
		
		List<E_CartItem__c> cartItems = new List<E_CartItem__c> {
			new E_CartItem__c(Quantity__c=1, product__r=new E_Product__c(SKU__c='sku1'), cart__c=cart1.id, price__c=100, SubAmount__c=100.0),
			new E_CartItem__c(Quantity__c=1, product__r=new E_Product__c(SKU__c='sku2'), cart__c=cart2.id, price__c=100, SubAmount__c=100.0)
		};
		insert cartItems;
	}
	
	static List<E_CartItem__c> getCartItems(String cartId)
	{
		return  [Select c.AllowsDiscounts__c, c.Cart__c, c.Name, c.Product__r.Name, c.cartItemType__c, 
            		c.Product__r.ShortDesc__c, c.Product__r.SKU__c, c.Quantity__c, c.Price__c, c.SubAmount__c, c.Product__r.ProductType__c,
            		c.Coupon__c, (Select Cart__c, Name, Product__r.Name, cartItemType__c, 
            		Product__r.ShortDesc__c, Product__r.SKU__c, Quantity__c, Price__c, SubAmount__c, ProductType__c, AllowsDiscounts__c,
            		Coupon__c From Cart_Items__r) from E_CartItem__c c where  c.Cart__c = :cartId];
	}
	
    static testMethod void validateGeneralSPECCouponRulesTest() {
    	setupData();
    	
    	insert new list<E_Spec__c> {new E_Spec__c(name='spec1', specid__c='spec1'), new E_Spec__c(name='spec2', specid__c='spec2')};
    	insert new  List<E_ProductSpecIndex__c> {
    		new E_ProductSpecIndex__c(product__r=new E_Product__c(SKU__c='sku1'), Spec__r=new E_Spec__c(specid__c='spec1'), specValue__c='specValue1', productSpecIndexId__c='sku1'),
    		new E_ProductSpecIndex__c(product__r=new E_Product__c(SKU__c='sku2'), Spec__r=new E_Spec__c(specid__c='spec2'), specValue__c='specValue2', productSpecIndexId__c='sku2')
    	};
    	String couponCode = cc_util_RandomString.randomAlphanumeric(10);
        cc_test_PrepTestData.loadAllCustomSettings();
        cc_test_PrepTestData.loadInitData();
        System.assert([Select c.Id From E_ApplicationSettings__c c where name='CloudCraze'].size() != 0); 
        insert new E_Product__c(Name=couponCode, Sku__c=couponCode, ProductStatus__c='Released', shippingWeight__c=20.0);
        insert new E_CartItem__c(Quantity__c=1, product__r=new E_Product__c(SKU__c=couponCode), cart__c=cart1.id, price__c=100, subamount__c=100);
        Double sourceMinQty = 1.0;
        Double targetQuantity = 1.0;
    	Date startDate = System.today();
    	Date endDate = System.today().addMonths(2);
    	E_Coupon__c coupon = new E_Coupon__c(discountAmount__c = 10, DiscountType__c = 'Percentage', MaxUse__c=9999, 
    		TotalUsed__c =0, COUPONCODE__C=couponCode, RuleType__c='General', couponType__c='Percentage', 
    		CouponName__c='10% off on spec1', StartDate__c=startDate, EndDate__c=endDate, minQty__c=1,
    		TargetSpec__r=new e_spec__c(specid__c='spec2'),TargetSpecValue__c='specValue2', TargetSpecQty__c=1, TargetRelation__c=cc_cnst_PickListConstants.RULERELATION_SPEC, 
    		TargetQty__c=1, Coupon_Notes__c='test');
    		
        insert coupon; 	
        
        Test.startTest();

        List<E_CartItem__c> cartItems = getCartItems(cart1.id);
        
        coupon = [Select e.Rule__r.SourceRelation__c, e.Rule__r.StartDate__c, e.Rule__r.EndDate__c, e.Rule__r.RuleType__c, e.Rule__r.RuleSource__c, e.Rule__r.RuleMinQty__c, 
        e.Rule__r.RuleMinAmt__c, e.Rule__r.Name__c, e.Rule__r.CustomerTypeCode__c, e.Rule__r.CurrencyISOCode__c, e.Rule__c, e.Rule__r.Relation__c,
         e.RuleType__c, e.RuleName__c, e.Name, e.DiscountType__c, e.CouponType__c, e.TotalUsed__c, e.Enabled__c, e.MaxUse__c, e.CouponCode__c From E_Coupon__c e where e.CouponCode__c=:couponCode limit 1];
        
        System.debug('roy lou-> +' + coupon);        
        Double cartTotal = 400.0;
        E_CartCoupon__c cc = new E_CartCoupon__c(cart__c=cart1.id, coupon__c=coupon.id);
        insert cc;
        String validationResult = cc_util_Coupon.validateCouponRules(coupon, cart1.id, cartItems, cartTotal);
        //System.assertNotEquals('Success', validationResult); 
        validationResult = cc_util_Coupon.validateCouponRules(coupon, cart2.id, getCartItems(cart2.id), cartTotal);
        //System.assertEquals('Success', validationResult); 
        try{
        	cc_util_Coupon.applyCouponsToCart(cart1.Id, getCartItems(cart1.id));
        }
        catch(Exception e){
        	//do nothing
        }
    }
}