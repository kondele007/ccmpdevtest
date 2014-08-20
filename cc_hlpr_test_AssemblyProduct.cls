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
private class cc_hlpr_test_AssemblyProduct {
	static testMethod void unitTestAll() {
		System.assert(true);
	}
/* CC SaaS Mod - Schema Change - removed E_ModelValue__c 
	private static Id assemblyProductId;
    
    
   static void loadModelData() {
   		
   		E_Model__c newModel = new E_Model__c(ModelID__c = 'testModel', Name='testModel');
        insert newModel;
        E_Product__c assembly = new E_Product__c(Model__c=newModel.id, SKU__C='Assembly',  Name='test product 1', ShortDesc__c='Short Desc 1', LongDesc__c='Long Desc1', ProductStatus__c='Released', ProductType__c='Assembly');
        insert assembly;
        
        assemblyProductId = assembly.id; 
        insert new list<E_Product__c> {
        	
        	new E_Product__c(SKU__C='testSKU2',  Name='test product 2', ShortDesc__c='Short Desc 2', LongDesc__c='Long Desc2', ProductStatus__c='Released'),
            new E_Product__c(SKU__C='testSKU3',  Name='test product 3', ShortDesc__c='Short Desc 3', LongDesc__c='Long Desc3', ProductStatus__c='Released'),
            new E_Product__c(SKU__C='testSKU4',  Name='test product 4', ShortDesc__c='Short Desc 4', LongDesc__c='Long Desc4', ProductStatus__c='Released'),
            new E_Product__c(SKU__C='testSKU5',  Name='test product 5', ShortDesc__c='Short Desc 5', LongDesc__c='Long Desc5', ProductStatus__c='Released')
        };
        
        insert new List<E_ModelOption__c> {
        	new E_ModelOption__c(Model__r = new E_Model__c(ModelID__c = 'testModel'), Advice__c='question1', ModelOptionID__c='testModelOption1'),
        	new E_ModelOption__c(Model__r = new E_Model__c(ModelID__c = 'testModel'), Advice__c='question2', ModelOptionID__c='testModelOption2')
        };
        
        insert new list<E_ModelValue__c> {
	        new E_ModelValue__c(Product__r=new E_Product__c(sku__c='testSKU2'), ModelOption__r=new E_ModelOption__c(ModelOptionID__c='testModelOption1'), ValueText__c='test'),
	        new E_ModelValue__c(Product__r=new E_Product__c(sku__c='testSKU3'), ModelOption__r=new E_ModelOption__c(ModelOptionID__c='testModelOption1'), ValueText__c='test'),
	        new E_ModelValue__c(Product__r=new E_Product__c(sku__c='testSKU4'), ModelOption__r=new E_ModelOption__c(ModelOptionID__c='testModelOption2'), ValueText__c='test'),
	        new E_ModelValue__c(Product__r=new E_Product__c(sku__c='testSKU5'), ModelOption__r=new E_ModelOption__c(ModelOptionID__c='testModelOption2'), ValueText__c='test')
        };
        
        insert new list<E_PriceListItem__c> {
        	new E_PriceListItem__c(Pricelist__r=new E_PriceList__c(PricelistId__c='Enterprise'), Product__r=new E_Product__c(sku__c='Assembly'), Price__c=200),
        	new E_PriceListItem__c(Pricelist__r=new E_PriceList__c(PricelistId__c='Enterprise'), Product__r=new E_Product__c(sku__c='testSKU2'), Price__c=200),
        	new E_PriceListItem__c(Pricelist__r=new E_PriceList__c(PricelistId__c='Enterprise'), Product__r=new E_Product__c(sku__c='testSKU3'), Price__c=200),
        	new E_PriceListItem__c(Pricelist__r=new E_PriceList__c(PricelistId__c='Enterprise'), Product__r=new E_Product__c(sku__c='testSKU4'), Price__c=200),
        	new E_PriceListItem__c(Pricelist__r=new E_PriceList__c(PricelistId__c='Enterprise'), Product__r=new E_Product__c(sku__c='testSKU5'), Price__c=200) 
        };
   } 

  
   static testMethod void unitTestAll() {
   		cc_test_TestDataSetup.loadData();
   		loadModelData();
   		List<cc_util_CompositeProduct.NamedSelectOptionList> options = cc_util_CompositeProduct.getAssemblyModelOptions(assemblyProductId);
   		map<String, E_Product__c> sku2Product = new map<String, E_Product__c>();
   		for(E_Product__c p : [select id, sku__c from E_Product__c where sku__c like 'test%']) {
   			sku2Product.put(p.sku__c, p);
   		}
   		System.assertEquals(options.size(), 2);
   		
   		options[0].selectedOption = sku2Product.get('testSKU2').id;
   		options[1].selectedOption = sku2Product.get('testSKU4').id;
   		
   		cc_hlpr_AssemblyProduct testClass = new cc_hlpr_AssemblyProduct();
   		testClass.assemblyModelOptionValues = options;
   		testClass.getAssemblyModelData(assemblyProductId, cc_test_TestDataSetup.testAccount.id);
        
        Test.startTest();
       	cc_api_Cart api = new cc_api_Cart();
       	api.accountId = cc_test_TestDataSetup.testAccount.id;
       	E_Cart__c testCart = api.createEmptyCart();
       	String placeOrderCart1 = api.addToCart(assemblyProductId, testCart.id, 1, true, cc_util_CloudCraze.application.Default_Storefront__c);
        
        E_CartItem__c majorCartItemInstance=[Select c.ParentCartItem__c,c.StoreID__c,c.Cart__c, c.Name, c.Product__r.Name, c.cartItemType__c, c.Product__r.ShortDesc__c, c.Product__r.SKU__c, c.Quantity__c, c.Price__c, c.SubAmount__c, ProductType__c, c.Coupon__c from E_CartItem__c c where Product__c=:assemblyProductId LIMIT 1];
		
        testClass.addComponentProductsToCart(majorCartItemInstance, cc_test_TestDataSetup.testAccount.id, System.now().date(), null, null, true, null);
        
        E_CartItem__c newcartItem = [select id, (select id, price__c, quantity__c from Cart_Items__r) from E_CartItem__c where id =: majorCartItemInstance.id];
        
        Decimal retVal = testClass.calAggregatedPrice(newcartItem);
        
        system.assertEquals(retVal,400);
        
        Test.stopTest();
   }
   */
 
}