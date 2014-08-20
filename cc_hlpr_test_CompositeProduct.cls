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
private class cc_hlpr_test_CompositeProduct {

    static testMethod void testFactory() {
        cc_hlpr_CompositeProductHelperBase helper1 = cc_hlpr_CompositeProductHelperFactory.getCompositeProductHelper('Bundle');
        System.assert(helper1 instanceOf cc_hlpr_BundleProduct);
        cc_hlpr_CompositeProductHelperBase helper2 = cc_hlpr_CompositeProductHelperFactory.getCompositeProductHelper('Kit');
        System.assert(helper2 instanceOf cc_hlpr_KitProduct);
        cc_hlpr_CompositeProductHelperBase helper3 = cc_hlpr_CompositeProductHelperFactory.getCompositeProductHelper('Assembly');
        System.assert(helper3 instanceOf cc_hlpr_AssemblyProduct);
        cc_hlpr_CompositeProductHelperBase helper4 = cc_hlpr_CompositeProductHelperFactory.getCompositeProductHelper('Product');
        System.assert(helper4 instanceOf cc_hlpr_RegularProduct);
    }
    
    static testMethod void testCompositeProductUtils() {
    	cc_test_TestDataSetup.LoadData();
    	System.assert([Select c.Id From E_ApplicationSettings__c c where name='CloudCraze'].size() != 0);
    	E_AccountGroup__c accountGroup = new E_AccountGroup__c();
        insert accountGroup;
//        Account unitTestAccount = new Account(name='UnitTestAccount', E_AccountGroup__c=accountGroup.Id);
//        insert unitTestAccount;
	RecordType rt = [Select r.Name, r.Id From RecordType r where r.Name = 'Person Account' limit 1];
		
	Account unitTestAccount = new Account(LastName='UnitTestAccount', RecordTypeID = rt.Id,E_AccountGroup__c=accountGroup.Id, OwnerId=userInfo.getUserId());
	insert unitTestAccount;
        System.runas(cc_test_TestDataSetup.testUser) {

        System.debug('yowhua-->' + unitTestAccount.id);
        E_PriceList__c priceList = new E_PriceList__c(Name='Enterprise');
        List<E_PriceList__c> pll = [select a.id from E_PriceList__c a where a.name='Enterprise' and a.isDeleted=false];
        if(pll.size() != 0)
        {
            priceList = pll[0];
        }
        else 
        {
            insert priceList;
        }
        E_AccountGroupPriceList__c agpl = new E_AccountGroupPriceList__c(AccountGroup__c = accountGroup.Id, Pricelist__c=priceList.id);
        insert agpl;
    	E_Product__c bundleProduct = new E_Product__c(Name='bundle 1', Sku__c='sku001', ProductStatus__c='Released', ProductType__c='Bundle');
    	E_Product__c aggregated1 = new E_Product__c(Name='Aggregated 1', Sku__c='sku002', ProductStatus__c='Released', ProductType__c='Aggregated');
    	E_Product__c childProduct1 = new E_Product__c(Name='Aggregate 1', Sku__c='sku003', ProductStatus__c='Released', ProductType__c='Product');
    	E_Product__c childProduct2 = new E_Product__c(Name='Aggregate 2', Sku__c='sku004', ProductStatus__c='Released', ProductType__c='Product');
    	E_Product__c childProduct3 = new E_Product__c(Name='Aggregate 3', Sku__c='sku005', ProductStatus__c='Released', ProductType__c='Product');
    	E_Product__c regularProduct = new E_Product__c(Name='product 1', Sku__c='sku006', ProductStatus__c='Released', ProductType__c='Product');
    	E_Product__c aggregated2 = new E_Product__c(Name='Aggregated 2', Sku__c='sku007', ProductStatus__c='Released', ProductType__c='Aggregated');
    	E_Product__c childProduct4 = new E_Product__c(Name='Aggregate 4', Sku__c='sku008', ProductStatus__c='Released', ProductType__c='Product');
    	E_Product__c childProduct5 = new E_Product__c(Name='Aggregate 5', Sku__c='sku009', ProductStatus__c='Released', ProductType__c='Product');
    	E_Product__c childProduct6 = new E_Product__c(Name='Aggregate 6', Sku__c='sku0010', ProductStatus__c='Released', ProductType__c='Product');
    	
    	List<E_Product__c> pList = new List<E_Product__c> {bundleProduct, aggregated1, childProduct1, childProduct2, childProduct3, aggregated2, childProduct4, childProduct5, childProduct6, regularProduct};
    	insert pList;
    	
    	List<E_PriceListItem__c> priceLineList = new List<E_PriceListItem__c> ();
    	priceLineList.add( new E_PriceListItem__c(Pricelist__c=priceList.Id, Product__c=bundleProduct.id, Price__c=200));
    	priceLineList.add( new E_PriceListItem__c(Pricelist__c=priceList.Id, Product__c=aggregated1.id, Price__c=100));
    	priceLineList.add( new E_PriceListItem__c(Pricelist__c=priceList.Id, Product__c=childProduct1.id, Price__c=100));
    	priceLineList.add( new E_PriceListItem__c(Pricelist__c=priceList.Id, Product__c=childProduct2.id, Price__c=100));
    	priceLineList.add( new E_PriceListItem__c(Pricelist__c=priceList.Id, Product__c=childProduct3.id, Price__c=100));
    	priceLineList.add( new E_PriceListItem__c(Pricelist__c=priceList.Id, Product__c=regularProduct.id, Price__c=200));
    	priceLineList.add( new E_PriceListItem__c(Pricelist__c=priceList.Id, Product__c=aggregated2.id, Price__c=90));
    	priceLineList.add( new E_PriceListItem__c(Pricelist__c=priceList.Id, Product__c=childProduct4.id, Price__c=90));
    	priceLineList.add( new E_PriceListItem__c(Pricelist__c=priceList.Id, Product__c=childProduct5.id, Price__c=90));
    	priceLineList.add( new E_PriceListItem__c(Pricelist__c=priceList.Id, Product__c=childProduct6.id, Price__c=90));
        insert priceLineList;
        
        List<E_ProductMedia__c> pMedias = new List<E_ProductMedia__c>();
        pMedias.add(new E_ProductMedia__c(Product__c=childProduct1.id, MediaType__c='Product Search Image', ProductMediaSource__c='URI', URI__c='MyImageURI'));
        pMedias.add(new E_ProductMedia__c(Product__c=childProduct2.id, MediaType__c='Product Search Image', ProductMediaSource__c='URI', URI__c='MyImageURI'));
        pMedias.add(new E_ProductMedia__c(Product__c=childProduct3.id, MediaType__c='Product Search Image', ProductMediaSource__c='URI', URI__c='MyImageURI'));
        pMedias.add(new E_ProductMedia__c(Product__c=childProduct4.id, MediaType__c='Product Search Image', ProductMediaSource__c='URI', URI__c='MyImageURI'));
        pMedias.add(new E_ProductMedia__c(Product__c=childProduct5.id, MediaType__c='Product Search Image', ProductMediaSource__c='URI', URI__c='MyImageURI'));
        pMedias.add(new E_ProductMedia__c(Product__c=childProduct6.id, MediaType__c='Product Search Image', ProductMediaSource__c='URI', URI__c='MyImageURI'));
    	insert pMedias;
    	List<E_CompositeProduct__c> cps = new List<E_CompositeProduct__c> ();
    	cps.add(new E_CompositeProduct__c(Composite__c=aggregated1.id, Component__c=childProduct1.Id, Quantity__c=1, Optional__c=false));
    	cps.add(new E_CompositeProduct__c(Composite__c=aggregated1.id, Component__c=childProduct2.Id, Quantity__c=1, Optional__c=false));
    	cps.add(new E_CompositeProduct__c(Composite__c=aggregated1.id, Component__c=childProduct3.Id, Quantity__c=1, Optional__c=false));
    	cps.add(new E_CompositeProduct__c(Composite__c=bundleProduct.id, Component__c=aggregated1.Id, Quantity__c=1, Optional__c=false));
    	cps.add(new E_CompositeProduct__c(Composite__c=aggregated2.id, Component__c=childProduct4.Id, Quantity__c=1, Optional__c=false));
    	cps.add(new E_CompositeProduct__c(Composite__c=aggregated2.id, Component__c=childProduct5.Id, Quantity__c=1, Optional__c=false));
    	cps.add(new E_CompositeProduct__c(Composite__c=aggregated2.id, Component__c=childProduct6.Id, Quantity__c=1, Optional__c=false));
    	cps.add(new E_CompositeProduct__c(Composite__c=bundleProduct.id, Component__c=aggregated2.Id, Quantity__c=1, Optional__c=false));
    	
    	cps.add(new E_CompositeProduct__c(Composite__c=bundleProduct.id, Component__c=regularProduct.Id, Quantity__c=1, Optional__c=false));
    	
    	insert cps;
    	List<cc_util_CompositeProduct.NamedSelectOptionList> l1 = cc_util_CompositeProduct.getTopLevelAggregateProducts(aggregated1.Id);
    	System.debug(l1);
    	
    	
        List<cc_util_CompositeProduct.NamedSelectOptionList> l2 = cc_util_CompositeProduct.getChildAggregatesSelectOption(bundleProduct.Id);
        
        for(cc_util_CompositeProduct.NamedSelectOptionList s2 : l2)
    	{
    		System.debug('---->'+s2.name );
    		for(SelectOption s3 : s2.optionList)
    		{
    			System.debug('--------->'+s3.getLabel() + '--->'+s3.getValue());
    		}
    	}
    	System.debug(l2);
    	List<E_Product__c> aggreateList = cc_util_CompositeProduct.getChildAggregates(bundleProduct.Id);
    	String jsonString = cc_util_CompositeProduct.getListViewDataAsJSONString(aggreateList, unitTestAccount.id);
    	
    	
    	List<cc_bean_ProductListViewData> lv = cc_util_CompositeProduct.getListViewData(aggreateList, cc_util_CloudCraze.getAccountID());
    	
    	
    	
        }
    }
    
    
    
/*    
    static testMethod void  testJSONObject()
	{
		cc_hlpr_JSONObject parentObj = new cc_hlpr_JSONObject();
		
		cc_hlpr_JSONObject viewData = new cc_hlpr_JSONObject();
		viewData.putOpt('sku', new cc_hlpr_JSONObject.value('sku123'));
		viewData.putOpt('price', new cc_hlpr_JSONObject.value('100'));
		viewData.putOpt('uri', new cc_hlpr_JSONObject.value('here'));
		viewData.putOpt('sourceType', new cc_hlpr_JSONObject.value('testType'));
		parentObj.putOpt('opt1', new cc_hlpr_JSONObject.value(viewData));
		
		cc_hlpr_JSONObject viewData2 = new cc_hlpr_JSONObject();
		viewData2.putOpt('sku', new cc_hlpr_JSONObject.value('sku456'));
		viewData2.putOpt('price', new cc_hlpr_JSONObject.value('200'));
		viewData2.putOpt('uri', new cc_hlpr_JSONObject.value('there'));
		viewData2.putOpt('sourceType', new cc_hlpr_JSONObject.value('testType2'));
		
		parentObj.putOpt('opt2', new cc_hlpr_JSONObject.value(viewData2));
		
		System.debug( parentObj.valueToString() );
	}
	*/
	
}