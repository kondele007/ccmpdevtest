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
private class cc_ctrl_test_CouponAdmin {
	private static map<string, E_Coupon__c> couponMap = null;
	
	static E_Coupon__c queryCoupon(string couponId) {
		return [Select e.TotalUsed__c, e.TargetSpec__c, e.TargetSpecValue__c, e.TargetSpecQty__c, e.TargetRelation__c, e.TargetQty__c, 
			e.TargetProduct__c, e.StartDate__c, e.SourceSpec__c, e.SourceSpecValue__c, e.SourceSpecMiniQty__c, e.SourceRelation__c, 
			e.SourceProduct__c, e.SourceMinQty__c, e.Rule__c, e.RuleType__c, e.RuleName__c, e.Name, e.MinQty__c, e.MaxUse__c, 
			e.Id, e.EndDate__c, e.DiscountType__c, e.DiscountAmount__c, e.Coupon_Notes__c, e.CouponType__c, e.CouponName__c, 
			e.CouponId__c, e.CouponCode__c, e.CartTotalAmount__c From E_Coupon__c e where e.couponid__c = :couponid limit 1];
	}
    static testMethod void myUnitTest() {
    	E_Coupon__c coupon1 = new E_Coupon__c(discountAmount__c = 10, DiscountType__c = 'Absolute', MaxUse__c=2, TotalUsed__c =0, COUPONCODE__C='MyCartTotalCOupon', RuleType__c='CartTotal', couponType__c='Absolute', CouponName__c='test', StartDate__c=Date.today(), EndDate__c=Date.today(), minQty__c=1, cartTotalAmount__c=100);
    	//insert coupon1;
    	insert new E_Product__c(sku__c='targetSku', name='targetSku');
    	insert new E_Product__c(sku__c='sourceSku', name='sourceSku');
    	insert new E_Spec__c(name='spec1', specid__c='targetSpec');
    	insert new E_Spec__c(name='spec1', specid__c='sourceSpec');
    	E_Coupon__c coupon2 = new E_Coupon__c(discountAmount__c = 10, DiscountType__c = 'Percentage', MaxUse__c=9999, 
    		TotalUsed__c =0, COUPONCODE__C='THINK4MONITOR', RuleType__c='General', couponType__c='Percentage', 
    		CouponName__c='By one and get another 10% off', StartDate__c=Date.today(), EndDate__c=Date.today(), minQty__c=1,
    		TargetSpec__r=new e_spec__c(specid__c='targetSpec'),TargetSpecValue__c='1', TargetSpecQty__c=1, TargetRelation__c=cc_cnst_PickListConstants.RULERELATION_SKU, 
    		TargetQty__c=1,TargetProduct__r=new E_Product__c(sku__c='targetSku'),SourceSpec__r=new e_spec__c(specid__c='sourceSpec'),
    		SourceSpecValue__c='1', SourceSpecMiniQty__c=1, SourceRelation__c=cc_cnst_PickListConstants.RULERELATION_SPEC, SourceProduct__r=new E_Product__c(sku__c='sourceSku'), SourceMinQty__c=1,
    		Coupon_Notes__c='test');
    	
    	//insert coupon2;
    	
    	insert new list<E_Coupon__c> {coupon1, coupon2};
    	coupon1.CartTotalAmount__c = 120;
    	coupon2.DiscountAmount__c = 20;
    	update new list<E_Coupon__c> {coupon1, coupon2};
    	delete new list<E_Coupon__c> {coupon1, coupon2};
    	try{
    		cc_hlpr_CouponTrigger helper = new cc_hlpr_CouponTrigger();
    		helper.createCoupons(new list<E_Coupon__c>{coupon1, coupon2});
    	}
    	catch(Exception e){
    		
    	}
    	//ApexPages.StandardController stc = new ApexPages.StandardController(TestLeadTask); 
    	
    }
    
    static void setupTestData() {
    	insert new E_Product__c(sku__c='targetSku', name='targetSku');
    	insert new E_Product__c(sku__c='sourceSku', name='sourceSku');
    	insert new E_Spec__c(name='spec1', specid__c='targetSpec');
    	insert new E_Spec__c(name='spec1', specid__c='sourceSpec');
    	couponMap = new map<string, E_Coupon__c> {
    		'CartTotalCoupon1'=> new E_Coupon__c(CouponId__c='CartTotalCoupon1', discountAmount__c = 10, DiscountType__c = 'Absolute', 
    			couponType__c='Absolute', MaxUse__c=2, TotalUsed__c =0, COUPONCODE__C='CartTotalCoupon1', RuleType__c='CartTotal',  
    			CouponName__c='CartTotalCoupon1', StartDate__c=Date.today(), EndDate__c=Date.today().addDays(60), minQty__c=1, 
    			cartTotalAmount__c=100),
    		'CartTotalCoupon2'=> new E_Coupon__c(CouponId__c='CartTotalCoupon2', discountAmount__c = 20, DiscountType__c = 'Percentage', 
    			couponType__c='Percentage',MaxUse__c=2, TotalUsed__c =0, COUPONCODE__C='CartTotalCoupon2', RuleType__c='CartTotal', 
    			CouponName__c='CartTotalCoupon2', StartDate__c=Date.today(), EndDate__c=Date.today().addDays(60), minQty__c=1, 
    			cartTotalAmount__c=200),
    		'GeneralCoupon10%Off'=> new E_Coupon__c(CouponId__c='GeneralCoupon10%Off', discountAmount__c = 10, DiscountType__c = 'Percentage', MaxUse__c=9999, 
	    		TotalUsed__c =0, COUPONCODE__C='GeneralCoupon1', RuleType__c='General', couponType__c='Percentage', 
	    		CouponName__c='10% off', StartDate__c=Date.today(), EndDate__c=Date.today().addDays(60), minQty__c=1,
	    		TargetRelation__c=cc_cnst_PickListConstants.RULERELATION_SKU, TargetQty__c=1,
	    		Coupon_Notes__c='10% off'),
	    	'GeneralCouponBOGO50%Off'=> new E_Coupon__c(CouponId__c='GeneralCouponBOGO50%Off', discountAmount__c = 50, DiscountType__c = 'Percentage', MaxUse__c=9999, 
	    		TotalUsed__c =0, COUPONCODE__C='GCBOGO50%Off', RuleType__c='General', couponType__c='Percentage', 
	    		CouponName__c='GeneralCouponBOGO50%Off', StartDate__c=Date.today(), EndDate__c=Date.today().addDays(60), minQty__c=1,
	    		TargetRelation__c=cc_cnst_PickListConstants.RULERELATION_SKU, SourceRelation__c=cc_cnst_PickListConstants.RULERELATION_SKU,
	    		TargetQty__c=1, SourceMinQty__c=1,
	    		Coupon_Notes__c='GeneralCouponBOGO50'),
	    	'GeneralCoupon10%OffSpec'=> new E_Coupon__c(CouponId__c='GeneralCoupon10%OffSpec', discountAmount__c = 10, DiscountType__c = 'Percentage', MaxUse__c=9999, 
	    		TotalUsed__c =0, COUPONCODE__C='GC10%OffSpec', RuleType__c='General', couponType__c='Percentage', 
	    		CouponName__c='GeneralCoupon10%OffSpec', StartDate__c=Date.today(), EndDate__c=Date.today().addDays(60), minQty__c=1,
	    		TargetRelation__c=cc_cnst_PickListConstants.RULERELATION_SPEC, TargetSpecValue__c='1', TargetSpecQty__c=1,
	    		Coupon_Notes__c='10% off'),
	    	'GeneralCouponBOGO50%OffSpec'=> new E_Coupon__c(CouponId__c='GeneralCouponBOGO50%OffSpec', discountAmount__c = 50, DiscountType__c = 'Percentage', MaxUse__c=9999, 
	    		TotalUsed__c =0, COUPONCODE__C='GeneralCouponBOGO50%OffSpec', RuleType__c='General', couponType__c='Percentage', 
	    		CouponName__c='GeneralCouponBOGO50%OffSpec', StartDate__c=Date.today(), EndDate__c=Date.today().addDays(60), minQty__c=1,
	    		TargetRelation__c=cc_cnst_PickListConstants.RULERELATION_SPEC, TargetSpecValue__c='1', TargetSpecQty__c=1,
	    	 	SourceSpecValue__c='1', SourceSpecMiniQty__c=1, SourceRelation__c=cc_cnst_PickListConstants.RULERELATION_SPEC,
	    		Coupon_Notes__c='10% off')
    	};
    }
    static testMethod void CartTotalCouponTest() {
     	setupTestData();
     	string couponid = 'CartTotalCoupon1';
    	E_Coupon__c coupon = couponMap.get(couponid);
    	ApexPages.StandardController stc = new ApexPages.StandardController(coupon); 
    	cc_ctrl_CouponAdmin couponAdmin = new cc_ctrl_CouponAdmin(stc);
    	couponAdmin.saveCoupon();
    	coupon = [select id, cartTotalAmount__c from E_Coupon__c where CouponId__c= :couponid limit 1];
    	coupon.CartTotalAmount__c = 200;
    	update coupon;
    	delete [select id from E_Coupon__c where CouponId__c= :couponid];
    }
    static testMethod void GeneralDiscountCouponTest() {
     	setupTestData();
     	string couponid = 'GeneralCoupon10%Off';
    	E_Coupon__c coupon = couponMap.get(couponid);
    	System.assert(coupon != null);
    	ApexPages.StandardController stc = new ApexPages.StandardController(coupon); 
    	cc_ctrl_CouponAdmin couponAdmin = new cc_ctrl_CouponAdmin(stc);
    	couponAdmin.saveCoupon();
    	system.assert(couponAdmin.messages.size() !=0);
    	coupon.TargetProduct__c = [select id from E_Product__c where sku__c='targetSku' limit 1].id;
    	couponAdmin.saveCoupon();
    	system.assert(couponAdmin.messages.size() ==0);
    	coupon = queryCoupon(couponid);
    	PageReference pr = System.Page.cc_admin_coupon;
    	Test.setCurrentPageReference(pr);
    	pr.getParameters().put('id', coupon.id);
    	coupon.TargetRelation__c=cc_cnst_PickListConstants.RULERELATION_SPEC;
    	coupon.TargetSpec__c= [select id from E_Spec__c where specid__c='targetSpec' limit 1].id;
    	coupon.TargetSpecValue__c='1';
    	coupon.TargetSpecQty__c=1;
    	stc = new ApexPages.StandardController(coupon); 
    	couponAdmin = new cc_ctrl_CouponAdmin(stc);
    	couponAdmin.saveCoupon();
    	system.debug('GeneralDiscountCouponTest=>error msg=' + couponAdmin.messages);
    	system.assert(couponAdmin.messages.size() ==0);
    	delete [select id from E_Coupon__c where CouponId__c= :couponid];
    }
    static testMethod void GeneralDiscountSpecCouponTest() {
     	setupTestData();
     	
     	string couponid = 'GeneralCoupon10%OffSpec';
    	E_Coupon__c coupon = couponMap.get(couponid);
    	System.assert(coupon != null);
    	ApexPages.StandardController stc = new ApexPages.StandardController(coupon); 
    	cc_ctrl_CouponAdmin couponAdmin = new cc_ctrl_CouponAdmin(stc);
    	couponAdmin.saveCoupon();
    	system.assert(couponAdmin.messages.size() !=0);
    	coupon.TargetSpec__c = [select id from E_Spec__c where specid__c='targetSpec' limit 1].id;
    	couponAdmin.saveCoupon();
    	system.debug('sourceSku=>error msg=' + couponAdmin.messages);
    	system.assert(couponAdmin.messages.size() ==0);
    	coupon = queryCoupon(couponid);
    	PageReference pr = System.Page.cc_admin_coupon;
    	Test.setCurrentPageReference(pr);
    	pr.getParameters().put('id', coupon.id);
    	coupon.TargetRelation__c=cc_cnst_PickListConstants.RULERELATION_SKU;
    	coupon.TargetProduct__c= [select id from E_Product__c where sku__c='targetSKU' limit 1].id;
    	coupon.minQty__c=20;
    	
    	stc = new ApexPages.StandardController(coupon); 
    	couponAdmin = new cc_ctrl_CouponAdmin(stc);
    	couponAdmin.saveCoupon();
    	coupon.TargetRelation__c=cc_cnst_PickListConstants.RULERELATION_SKU;
    	coupon.TargetProduct__c= [select id from E_Product__c where sku__c='targetSKU' limit 1].id;
    	coupon.minQty__c=20;
    	
    	update coupon;
    	//make sure rule's target relation and source relation have been set to coupon's corresponding value
    	for(E_Rule__c r : [Select e.StartDate__c, e.SourceRelation__c, e.Relation__c, e.RuleType__c, e.RuleSource__c, 
    					e.RuleMinQty__c, e.RuleMinAmt__c, e.EndDate__c, e.Enabled__c From E_Rule__c e where e.RuleId__c = :coupon.id]) {
    						system.assertEquals(cc_cnst_PickListConstants.RULERELATION_SKU, r.Relation__c);
    	}
    	delete [select id from E_Coupon__c where CouponId__c= :couponid];
    }
    static testMethod void GeneralBOGODiscountCouponTest() {
     	setupTestData();
     	string couponid = 'GeneralCouponBOGO50%Off';
    	E_Coupon__c coupon = couponMap.get(couponid);
    	System.assert(coupon != null);
    	ApexPages.StandardController stc = new ApexPages.StandardController(coupon); 
    	cc_ctrl_CouponAdmin couponAdmin = new cc_ctrl_CouponAdmin(stc);
    	couponAdmin.saveCoupon();
    	system.assert(couponAdmin.messages.size() !=0);
    	coupon.TargetProduct__c = [select id from E_Product__c where sku__c='targetSku' limit 1].id;
    	coupon.SourceProduct__c = [select id from E_Product__c where sku__c='sourceSku' limit 1].id;
    	couponAdmin.saveCoupon();
    	system.debug('sourceSku=>error msg=' + couponAdmin.messages);
    	system.assert(couponAdmin.messages.size() ==0);
    	coupon = queryCoupon(couponid);
    	PageReference pr = System.Page.cc_admin_coupon;
    	Test.setCurrentPageReference(pr);
    	pr.getParameters().put('id', coupon.id);
    	coupon.TargetRelation__c=cc_cnst_PickListConstants.RULERELATION_SPEC;
    	coupon.TargetSpec__c= [select id from E_Spec__c where specid__c='targetSpec' limit 1].id;
    	coupon.TargetSpecValue__c='1';
    	coupon.TargetSpecQty__c=1;
    	coupon.SourceRelation__c=cc_cnst_PickListConstants.RULERELATION_SPEC;
    	coupon.SourceSpec__c= [select id from E_Spec__c where specid__c='sourceSpec' limit 1].id;
    	coupon.SourceSpecValue__c='1';
    	coupon.SourceSpecMiniQty__c=1;
    	stc = new ApexPages.StandardController(coupon); 
    	couponAdmin = new cc_ctrl_CouponAdmin(stc);
    	couponAdmin.saveCoupon();
    	delete [select id from E_Coupon__c where CouponId__c= :couponid];
    }
    static testMethod void GeneralBOGOSpecDiscountCouponTest() {
     	setupTestData();
     	string couponid = 'GeneralCouponBOGO50%OffSpec';
    	E_Coupon__c coupon = couponMap.get(couponid);
    	System.assert(coupon != null);
    	ApexPages.StandardController stc = new ApexPages.StandardController(coupon); 
    	cc_ctrl_CouponAdmin couponAdmin = new cc_ctrl_CouponAdmin(stc);
    	couponAdmin.saveCoupon();
    	delete [select id from E_Coupon__c where CouponId__c= :couponid];
    }
    
}