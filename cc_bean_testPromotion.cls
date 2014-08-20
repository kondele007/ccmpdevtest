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
private class cc_bean_testPromotion {

    static testMethod void myUnitTest() {
        cc_test_PrepTestData.loadCustomSettings();
        System.assert([Select c.Id From E_ApplicationSettings__c c where name='CloudCraze'].size() != 0);
        cc_api_dl_products prods = new cc_api_dl_products();
        prods.loadData();
        cc_api_dl_promotions test = new cc_api_dl_promotions();
        test.loadData();
        list<E_Promo__c> promos = [Select e.SplashRotate__c, e.ShortDesc__c, e.Sequence__c, e.Product__c, e.ProductRelated__c, 
        	e.PageLocation__c, e.Name, e.LongDesc__c, e.LocationType__c, e.ImageURI__c, e.ImageSource__c, 
        	e.Enabled__c, e.Coupon__c, e.Coupon__r.couponCode__c, e.StaticResource__c, e.product__r.sku__c, e.Script__c From E_Promo__c e where e.name='Banner Order Review'];
        for(E_Promo__c p : promos) {
        	cc_bean_promotion beanPromotion = new cc_bean_promotion(p);
        }
        cc_bean_promotion.toPromotionBeanMap(promos);
        cc_bean_promotion.toPromotionBeanMapList(promos);
        
    }
}