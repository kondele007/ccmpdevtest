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
private class cc_hlpr_test_CloudCrazeSorter {

	static List<cc_bean_ProductListViewData> prodListView;
    static testMethod void myUnitTest() {
    	createData();
        List<cc_bean_ProductListViewData> sorted= cc_hlpr_CloudCrazeSorter.sortStandard(prodListView);
    	System.assertEquals(sorted[1].sortRank, 2);
    }
    
    static void createData() {
    	prodListView = new List<cc_bean_ProductListViewData>();
    	cc_bean_ProductListViewData plvd = new cc_bean_ProductListViewData();
		plvd.product=new E_Product__c(Name='TestProduct',SKU__c='SKUTEST');
		plvd.priceListItem= new E_PriceListItem__c(Price__c=10);
		plvd.priceBean=new cc_bean_PriceInfo();
		plvd.compositeProductObj = new E_CompositeProduct__c();
		plvd.averageReview=10;
		plvd.attachmentID='000000000000000000';
		plvd.mediaWrapper=new cc_bean_MediaWrapper();
		plvd.Alt_Message='test';
		plvd.mockProduct=new cc_bean_MockProduct(plvd.product);
		plvd.ccProduct=new cc_bean_Product(plvd.product);
		plvd.cc_bean_MockPriceListItem=new cc_bean_MockPriceListItem(plvd.priceListItem);
		plvd.name='TestProd';
		plvd.short_desc='Short Desc';
		plvd.long_desc='Long Desc';
		plvd.optional=true;
		plvd.qty=1;
		plvd.category='Test';
		plvd.categoryId='000000000000000000';
		plvd.lines=1;
		plvd.voiceMail='Voicemail';
		plvd.expandable = 'Y';
		plvd.productInventory=10;
		plvd.productSearchRank=1;
		plvd.sortRank=1;
		prodListView.add(plvd);

    	cc_bean_ProductListViewData plvd1 = new cc_bean_ProductListViewData();
		plvd1.product=new E_Product__c(Name='TestProduct1',SKU__c='SKUTEST1');
		plvd1.priceListItem= new E_PriceListItem__c(Price__c=20);
		plvd1.priceBean=new cc_bean_PriceInfo();
		plvd1.compositeProductObj = new E_CompositeProduct__c();
		plvd1.averageReview=10;
		plvd1.attachmentID='000000000000000000';
		plvd1.mediaWrapper=new cc_bean_MediaWrapper();
		plvd1.Alt_Message='test';
		plvd1.mockProduct=new cc_bean_MockProduct(plvd.product);
		plvd1.ccProduct=new cc_bean_Product(plvd.product);
		plvd1.cc_bean_MockPriceListItem=new cc_bean_MockPriceListItem(plvd.priceListItem);
		plvd1.name='TestProd';
		plvd1.short_desc='Short Desc';
		plvd1.long_desc='Long Desc';
		plvd1.optional=true;
		plvd1.qty=1;
		plvd1.category='Test';
		plvd1.categoryId='000000000000000000';
		plvd1.lines=1;
		plvd1.voiceMail='Voicemail';
		plvd1.expandable = 'Y';
		plvd1.productInventory=10;
		plvd1.productSearchRank=1;
		plvd1.sortRank=2;
		prodListView.add(plvd1);

    }
}