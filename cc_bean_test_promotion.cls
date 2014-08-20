@isTest
private class cc_bean_test_promotion {
	static testMethod void myUnitTest() {
		E_Coupon__c coupon = new E_Coupon__c(
			couponCode__c = 'code',
			couponName__c= 'codename',
			coupontype__c='Percentage',
			DiscountType__c = 'type',
			MaxUse__c = 1,
			TotalUsed__c = 0
		);
		insert coupon;
		
		List<E_Product__c> productList = cc_test_PrepTestData.insertProduct(2);
		
		E_Promo__c promo = new E_Promo__c(
			Name = 'name',
			Coupon__c = coupon.Id,
			LongDesc__c = 'long',
			ShortDesc__c = 'short',
			PageLocation__c = 'location',
			LocationType__c = 'type',
			Sequence__c = 0,
			Product__c = productList[0].Id
		);
		insert promo;
		System.assert(promo.Product__c != null);
		
		// cc_bean_promotion bean = new cc_bean_promotion(promo);
	}
}