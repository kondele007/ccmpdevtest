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
private class cc_api_testPromotion {

    static testMethod void myUnitTest() {
    	cc_test_PrepTestData.loadCustomSettings();
        cc_api_dl_products prods = new cc_api_dl_products();
        prods.loadData();
        cc_api_dl_promotions test = new cc_api_dl_promotions();
        test.loadData();
        cc_api_promotion promo = new cc_api_promotion();
        promo.getPromotionBeanMap('Order Review');
        system.assert(promo.getPromotionBeanMap('Order Review') != null);
        system.assert(promo.getPromotionBeanMapList('Order Review') != null);
        map<String, map<String, list<cc_bean_promotion>>> promoMap=promo.getAllPromotionBeanMapList();
 		if(promoMap!=null && promoMap.size()>0) {
			for(String pageLocation:promoMap.keySet()) {
				map<String, list<cc_bean_promotion>> locpromoMap = promoMap.get(pageLocation);
				if(locpromoMap!=null && locpromoMap.size()>0) {
					for(String locType:locpromoMap.keySet()) {
						list<cc_bean_promotion> promobeanList = promo.getPromoBeanList(promoMap,pageLocation,locType);
						break;
					}						
				}
			}
		}
    }
}