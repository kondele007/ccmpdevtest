/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 
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
private class cc_dao_test_CompositeProduct {	
	static String bundleProductSKU='sku001';
	/*
	static User testUser;
	static String AU_ERROR_NULL=Global_Variable__c.getValues('SSO.ErrorMissingField').value__c; //'ERROR: INPUT_VALUE is missing.';
	static String AU_ERROR_INVALID_FORMAT=Global_Variable__c.getValues('SSO.ErrorInvalidFormat').value__c; //'ERROR: INPUT_VALUE is invalid format.';
	static String AU_ERROR_DUPLICATE_USER=Global_Variable__c.getValues('SSO.ErrorDuplicateUsername').value__c; //'ERROR: Duplicate Username - INPUT_VALUE ';
	static String AU_SUCCESS=Global_Variable__c.getValues('SSO.Success').value__c; //'SUCCESS';
	static String AU_CUSTOMER_PRICELIST=Global_Variable__c.getValues('SSO.CustomerPriceList').value__c;  //'Customer Price List' - PortalAccount;

	static String AU_EMAIL_ENCODING_KEY=Global_Variable__c.getValues('SSO.EmailEncodingKey').value__c; //'UTF-8';
	static String AU_LOCALEKEY=Global_Variable__c.getValues('SSO.LocalesIdKey').value__c; //'en_US';
	static String AU_TIMEZONEKEY=Global_Variable__c.getValues('SSO.TimeZonesIdKey').value__c; //'America/Los_Angeles';
	static String profileName=Global_Variable__c.getValues('SSO.CCAuthenticateUserProfileName').value__c;//'QCS Authenticated Website';
	static E_PriceList__c priceList;
	static E_Product__c bundleProduct;
	static E_Product__c kitProduct;
	static E_Product__c bundleProduct2;
	static void setupData()
	{
		cc_test_TestDataSetup.loadData();
		cc_test_TestDataSetup.loadCompositeProducts();
        Map<String, string> selectedAggregatedProduct = cc_test_TestDataSetup.selectedAggregatedProduct;
        E_Category__c category = new E_Category__c(Name='Handsets', CategoryID__c='myCategoryId');
        insert category;
         
    	bundleProduct = new E_Product__c(Name='bundle 1', Sku__c='sku001', ProductStatus__c='Released', ProductType__c='Bundle');
    	E_Product__c aggregated1 = new E_Product__c(Name='Aggregated 1', Sku__c='sku002', ProductStatus__c='Released', ProductType__c='Aggregated');
    	E_Product__c childProduct1 = new E_Product__c(Name='Aggregate 1', Sku__c='sku003', ProductStatus__c='Released', ProductType__c='Product');
    	E_Product__c childProduct2 = new E_Product__c(Name='Aggregate 2', Sku__c='sku004', ProductStatus__c='Released', ProductType__c='Product');
    	E_Product__c childProduct3 = new E_Product__c(Name='Aggregate 3', Sku__c='sku005', ProductStatus__c='Released', ProductType__c='Product');
    	E_Product__c regularProduct = new E_Product__c(Name='product 1', Sku__c='sku006', ProductStatus__c='Released', ProductType__c='Product');
    	E_Product__c aggregated2 = new E_Product__c(Name='Aggregated 2', Sku__c='sku007', ProductStatus__c='Released', ProductType__c='Aggregated');
    	E_Product__c childProduct4 = new E_Product__c(Name='Aggregate 4', Sku__c='sku008', ProductStatus__c='Released', ProductType__c='Product');
    	E_Product__c childProduct5 = new E_Product__c(Name='Aggregate 5', Sku__c='sku009', ProductStatus__c='Released', ProductType__c='Product');
    	E_Product__c childProduct6 = new E_Product__c(Name='Aggregate 6', Sku__c='sku0010', ProductStatus__c='Released', ProductType__c='Product');
    	bundleProduct2 = new E_Product__c(Name='bundle 2', Sku__c='sku0011', ProductStatus__c='Released', ProductType__c='Bundle');
    	E_Product__c childProduct7 = new E_Product__c(Name='Product 7', Sku__c='sku0012', ProductStatus__c='Released', ProductType__c='Product');
    	E_Product__c childProduct8 = new E_Product__c(Name='Product 8', Sku__c='sku0013', ProductStatus__c='Released', ProductType__c='Product');
    	E_Product__c childProduct9 = new E_Product__c(Name='Product 9', Sku__c='sku0014', ProductStatus__c='Released', ProductType__c='Product');
    	kitProduct = new E_Product__c(Name='Kit 1', Sku__c='sku0015', ProductStatus__c='Released', ProductType__c='Kit');
    	E_Product__c childProduct11 = new E_Product__c(Name='Kit child 1', Sku__c='sku0016', ProductStatus__c='Released', ProductType__c='Product');
    	E_Product__c childProduct12 = new E_Product__c(Name='Kit child 2', Sku__c='sku0017', ProductStatus__c='Released', ProductType__c='Product');
    	E_Product__c childProduct13 = new E_Product__c(Name='Kit child 3', Sku__c='sku0018', ProductStatus__c='Released', ProductType__c='Product');
    	
    	
        
    	List<E_Product__c> pList = new List<E_Product__c> {bundleProduct, aggregated1, childProduct1, childProduct2, childProduct3, 
    			aggregated2, childProduct4, childProduct5, childProduct6, regularProduct, bundleProduct2, childProduct7, childProduct8, childProduct9,
    			kitProduct, childProduct11, childProduct12, childProduct13};
    	insert pList;
    	
    	List<E_ProductCategory__c> pcs = new List<E_ProductCategory__c>{
        		new E_ProductCategory__c(Category__c=category.id, Product__c=bundleProduct.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=aggregated1.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=childProduct1.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=childProduct2.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=childProduct3.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=aggregated2.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=childProduct4.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=childProduct5.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=childProduct6.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=regularProduct.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=bundleProduct2.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=childProduct7.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=childProduct8.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=kitProduct.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=childProduct11.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=childProduct12.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=childProduct13.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=childProduct9.id)
        };
        
        insert pcs;
        
    	selectedAggregatedProduct.put(aggregated1.id, childProduct2.id);
    	selectedAggregatedProduct.put(aggregated2.id, childProduct5.id);
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
    	
    	priceLineList.add( new E_PriceListItem__c(Pricelist__c=priceList.Id, Product__c=bundleProduct2.id, Price__c=200));
    	priceLineList.add( new E_PriceListItem__c(Pricelist__c=priceList.Id, Product__c=childProduct7.id, Price__c=100));
    	priceLineList.add( new E_PriceListItem__c(Pricelist__c=priceList.Id, Product__c=childProduct8.id, Price__c=100));
    	priceLineList.add( new E_PriceListItem__c(Pricelist__c=priceList.Id, Product__c=childProduct9.id, Price__c=100));
    	priceLineList.add( new E_PriceListItem__c(Pricelist__c=priceList.Id, Product__c=childProduct11.id, Price__c=100));
    	priceLineList.add( new E_PriceListItem__c(Pricelist__c=priceList.Id, Product__c=childProduct12.id, Price__c=200));
    	priceLineList.add( new E_PriceListItem__c(Pricelist__c=priceList.Id, Product__c=childProduct13.id, Price__c=90));
    	priceLineList.add( new E_PriceListItem__c(Pricelist__c=priceList.Id, Product__c=kitProduct.id, Price__c=90));
    	
    	
        insert priceLineList;
        
        List<E_ProductMedia__c> pMedias = new List<E_ProductMedia__c>();
        pMedias.add(new E_ProductMedia__c(Product__c=childProduct1.id, MediaType__c='Product Search Image', ProductMediaSource__c='URI', URI__c='MyImageURI'));
        pMedias.add(new E_ProductMedia__c(Product__c=childProduct2.id, MediaType__c='Product Search Image', ProductMediaSource__c='URI', URI__c='MyImageURI'));
        pMedias.add(new E_ProductMedia__c(Product__c=childProduct3.id, MediaType__c='Product Search Image', ProductMediaSource__c='URI', URI__c='MyImageURI'));
        pMedias.add(new E_ProductMedia__c(Product__c=childProduct4.id, MediaType__c='Product Search Image', ProductMediaSource__c='URI', URI__c='MyImageURI'));
        pMedias.add(new E_ProductMedia__c(Product__c=childProduct5.id, MediaType__c='Product Search Image', ProductMediaSource__c='URI', URI__c='MyImageURI'));
        pMedias.add(new E_ProductMedia__c(Product__c=childProduct6.id, MediaType__c='Product Search Image', ProductMediaSource__c='URI', URI__c='MyImageURI'));
    	insert pMedias;
    	
    	//E_CompositeProduct__c cp0=new E_CompositeProduct__c( Component__c=bundleProduct.Id, Quantity__c=1, Optional__c=false);
    	//insert cp0;
    	
    	E_CompositeProduct__c cp1=new E_CompositeProduct__c(Composite__c=bundleProduct.id, Component__c=aggregated1.Id, Quantity__c=1, Optional__c=false);
    	insert cp1;
    	List<E_CompositeProduct__c> cp2l = new List<E_CompositeProduct__c>{
    		new E_CompositeProduct__c(Composite__c=aggregated1.id, Component__c=childProduct1.Id, Quantity__c=1, Optional__c=false, Parent__c=cp1.id),
    		new E_CompositeProduct__c(Composite__c=aggregated1.id, Component__c=childProduct2.Id, Quantity__c=1, Optional__c=false, Parent__c=cp1.id),
    		new E_CompositeProduct__c(Composite__c=aggregated1.id, Component__c=childProduct3.Id, Quantity__c=1, Optional__c=false, Parent__c=cp1.id)
    	};
    	insert cp2l;
    	E_CompositeProduct__c cp9=new E_CompositeProduct__c(Composite__c=bundleProduct.id, Component__c=aggregated2.Id, Quantity__c=1, Optional__c=true);
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
    	
    	E_CompositeProduct__c cp15=new E_CompositeProduct__c(Composite__c=bundleProduct2.id, Component__c=kitProduct.Id, Quantity__c=1, Optional__c=false, Parent__c=cp14.id);
    	insert cp15;
    	
    	E_CompositeProduct__c cp16=new E_CompositeProduct__c(Composite__c=kitProduct.id, Component__c=childProduct11.Id, Quantity__c=2, Optional__c=false, Parent__c=cp15.id);
    	insert cp16;
    	E_CompositeProduct__c cp17=new E_CompositeProduct__c(Composite__c=kitProduct.id, Component__c=childProduct12.Id, Quantity__c=3, Optional__c=false, Parent__c=cp15.id);
    	insert cp17;
    	E_CompositeProduct__c cp18=new E_CompositeProduct__c(Composite__c=kitProduct.id, Component__c=childProduct13.Id, Quantity__c=4, Optional__c=false, Parent__c=cp15.id);
    	insert cp18;
    	
	}
	*/
    static testMethod void getCompositeProductTest() {
    	cc_test_TestDataSetup.loadData();
		cc_test_TestDataSetup.loadCompositeProducts();
    	
    	system.runAs(cc_test_TestDataSetup.testUser){ 
	        List<E_CompositeProduct__c> compositeProducts = [select Name, Composite__r.Id, Composite__r.Name, Composite__r.SKU__c from E_CompositeProduct__c limit 5];
	        system.assertEquals(5, compositeProducts.size());
	        
	        cc_bean_ProductListViewData cc_bean_ProductListViewData = cc_dao_CompositeProduct.getCompositeProduct(compositeProducts);
	        system.assert(cc_bean_ProductListViewData!=null);
    	}
    }
    
    
    static testMethod void getCompositeProductsTest() {  
    	cc_test_TestDataSetup.loadData();
    	System.assert([Select c.Id From E_ApplicationSettings__c c where name='CloudCraze'].size() != 0);
		cc_test_TestDataSetup.loadCompositeProducts();
        Map<String, string> selectedAggregatedProduct = cc_test_TestDataSetup.getSelectedAggregatedProduct();  
        system.runAs(cc_test_TestDataSetup.testUser){ 
        	List<cc_bean_ProductListViewData> cc_bean_ProductListViewData = cc_dao_CompositeProduct.getCompositeProducts('Handsets', 'Bundle');
        }
    }
    
    
    
    static testMethod void getChildProductsTest() { 
    	   	
    	cc_test_TestDataSetup.loadData();
		cc_test_TestDataSetup.loadCompositeProducts();
        Map<String, string> selectedAggregatedProduct = cc_test_TestDataSetup.getSelectedAggregatedProduct();  
    	map<String, E_Product__c> sku2Product = new map<String, E_Product__c>();
   		for(E_Product__c p : [select id, sku__c from E_Product__c where sku__c like 'sku%']) {
   			sku2Product.put(p.sku__c, p);
   		}
   		system.runAs(cc_test_TestDataSetup.testUser){ 
    	List<cc_bean_ProductListViewData> cc_bean_ProductListViewData = cc_dao_CompositeProduct.getChildProducts(sku2Product.get(bundleProductSKU).id);
    	system.assert(cc_bean_ProductListViewData != null);
   		}
    }
    
    static testMethod void myUnitTest() {
    	
		cc_test_TestDataSetup.loadData();
		cc_test_TestDataSetup.loadCompositeProducts();
        Map<String, string> selectedAggregatedProduct = cc_test_TestDataSetup.getSelectedAggregatedProduct();  
        map<String, E_Product__c> sku2Product = new map<String, E_Product__c>();
   		for(E_Product__c p : [select id, sku__c from E_Product__c where sku__c like 'sku%']) {
   			sku2Product.put(p.sku__c, p);
   		}
   		
		system.runAs(cc_test_TestDataSetup.testUser){  
		List<E_CompositeProduct__c> bps = [Select e.Quantity__c, e.Optional__c, e.Name, e.Id, e.Component__r.UnitOfMeasure__c, e.Composite__r.UnitOfMeasure__c, e.Component__r.ProductType__c,
				e.Component__c, e.Component__r.sku__c, e.Component__r.name, e.Component__r.ShortDesc__c, e.Category__c, e.Category__r.name, e.Composite__c, e.Composite__r.sku__c , 
				e.Composite__r.name From E_CompositeProduct__c e where e.Composite__c = :sku2Product.get(bundleProductSKU).id];
				
    	cc_bean_ProductListViewData cc_bean_ProductListViewData = cc_dao_CompositeProduct.getCompositeProduct(bps); 
        system.assert( cc_bean_ProductListViewData != null);
    	List<cc_bean_ProductListViewData> productListViewDatas = cc_dao_CompositeProduct.getCompositeOptionalProducts(sku2Product.get(bundleProductSKU).id);
    	system.assert( cc_dao_CompositeProduct.getCompositeNonOptionalProducts(sku2Product.get(bundleProductSKU).id) != null);
    	//system.assert( cc_dao_CompositeProduct.(bundleProduct.id) != null);
		}
    }
    
    /*
    static testmethod void getChildProductsTest2() {
    	E_Product__c product = new E_Product__c();
    	product.SKU__c = '12345';
    	product.Name = 'Test';
    	product.ProductType__c = 'Bundle';
    	insert product;
 
        E_Category__c category = new E_Category__c();
        category.Name = 'TestName';
        category.CategoryID__c = 'testCategory';
        insert category;
        
        E_CompositeProduct__c compositeProduct = new E_CompositeProduct__c();
        compositeProduct.Optional__c = false;
        compositeProduct.Quantity__c = 10;   	
    	compositeProduct.Component__c = product.Id;
    	compositeProduct.Category__c = category.id;
    	compositeProduct.Composite__c = product.Id;    	
    	insert compositeProduct;
    	
    	List<E_CompositeProduct__c> compositeProducts = new list<E_CompositeProduct__c>();
    	compositeProducts.add(compositeProduct);
    	
    	List<cc_bean_ProductListViewData> returnVal = cc_dao_CompositeProduct.getChildProducts(compositeProducts);
    }
    */
}