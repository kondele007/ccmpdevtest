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
private class cc_hlpr_test_CompositeProduct2 {

    static testMethod void myUnitTest() {
        E_AccountGroup__c accountGroup = new E_AccountGroup__c();
        insert accountGroup;
//        Account unitTestAccount = new Account(name='UnitTestAccount', E_AccountGroup__c=accountGroup.Id);
//        insert unitTestAccount;
	RecordType rt = [Select r.Name, r.Id From RecordType r where r.Name = 'Person Account' limit 1];
		
	Account unitTestAccount = new Account(LastName='UnitTestAccount', RecordTypeID = rt.Id, E_AccountGroup__c=accountGroup.Id, OwnerId=userInfo.getUserId());
	insert unitTestAccount;
        
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
    	E_Product__c bundleProduct2 = new E_Product__c(Name='bundle 2', Sku__c='sku0011', ProductStatus__c='Released', ProductType__c='Bundle');
    	E_Product__c childProduct7 = new E_Product__c(Name='Product 7', Sku__c='sku0012', ProductStatus__c='Released', ProductType__c='Product');
    	E_Product__c childProduct8 = new E_Product__c(Name='Product 8', Sku__c='sku0013', ProductStatus__c='Released', ProductType__c='Product');
    	E_Product__c childProduct9 = new E_Product__c(Name='Product 9', Sku__c='sku0014', ProductStatus__c='Released', ProductType__c='Product');
    	
    	
    	List<E_Product__c> pList = new List<E_Product__c> {bundleProduct, aggregated1, childProduct1, childProduct2, childProduct3, 
    			aggregated2, childProduct4, childProduct5, childProduct6, regularProduct, bundleProduct2, childProduct7, childProduct8, childProduct9};
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
    	
    	E_CompositeProduct__c cp1=new E_CompositeProduct__c(Composite__c=bundleProduct.id, Component__c=aggregated1.Id, Quantity__c=1, Optional__c=false);
    	insert cp1;
    	List<E_CompositeProduct__c> cp2l = new List<E_CompositeProduct__c>{
    		new E_CompositeProduct__c(Composite__c=aggregated1.id, Component__c=childProduct1.Id, Quantity__c=1, Optional__c=false, Parent__c=cp1.id),
    		new E_CompositeProduct__c(Composite__c=aggregated1.id, Component__c=childProduct2.Id, Quantity__c=1, Optional__c=false, Parent__c=cp1.id),
    		new E_CompositeProduct__c(Composite__c=aggregated1.id, Component__c=childProduct3.Id, Quantity__c=1, Optional__c=false, Parent__c=cp1.id)
    	};
    	insert cp2l;
    	E_CompositeProduct__c cp9=new E_CompositeProduct__c(Composite__c=bundleProduct.id, Component__c=aggregated2.Id, Quantity__c=1, Optional__c=false);
    	insert cp9;
    	
    	E_CompositeProduct__c cp6=new E_CompositeProduct__c(Composite__c=aggregated2.id, Component__c=childProduct4.Id, Quantity__c=1, Optional__c=false, Parent__c=cp9.id);
    	E_CompositeProduct__c cp7=new E_CompositeProduct__c(Composite__c=aggregated2.id, Component__c=childProduct5.Id, Quantity__c=1, Optional__c=false, Parent__c=cp9.id);
    	E_CompositeProduct__c cp8=new E_CompositeProduct__c(Composite__c=aggregated2.id, Component__c=childProduct6.Id, Quantity__c=1, Optional__c=false, Parent__c=cp9.id);
    	insert new list<E_CompositeProduct__c> {cp6, cp7, cp8};
    	E_CompositeProduct__c cp10=new E_CompositeProduct__c(Composite__c=bundleProduct.id, Component__c=regularProduct.Id, Quantity__c=1, Optional__c=false);
    	insert cp10;
    	
    	E_CompositeProduct__c cp14=new E_CompositeProduct__c(Composite__c=bundleProduct.id, Component__c=bundleProduct2.Id, Quantity__c=1, Optional__c=false);
    	insert cp14;
    	
    	E_CompositeProduct__c cp11=new E_CompositeProduct__c(Composite__c=bundleProduct2.id, Component__c=childProduct7.Id, Quantity__c=1, Optional__c=false, Parent__c=cp14.id);
    	insert cp11;
    	E_CompositeProduct__c cp12=new E_CompositeProduct__c(Composite__c=bundleProduct2.id, Component__c=childProduct8.Id, Quantity__c=1, Optional__c=false, Parent__c=cp14.id);
    	insert cp12;
    	E_CompositeProduct__c cp13=new E_CompositeProduct__c(Composite__c=bundleProduct2.id, Component__c=childProduct9.Id, Quantity__c=1, Optional__c=false, Parent__c=cp14.id);
    	insert cp13;
    	
    	
    	system.assert(priceLineList.size() != 0);
    	
    }
}