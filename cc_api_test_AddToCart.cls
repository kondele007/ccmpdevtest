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
private class cc_api_test_AddToCart {
	
     static testMethod void addToCartTest() {
     	
     	cc_test_TestDataSetup.LoadData();
     	
        cc_api_dl_products prods = new cc_api_dl_products();
        prods.loadData();
        cc_api_dl_priceListLines priceLines = new cc_api_dl_priceListLines();
        priceLines.loadData();
        
        String currentProductId = null;
        integer quantity = 1;
        integer qtyAvailable = 20;
        map<string, integer> skuQtyMap = new map<string, integer>();
        for(E_Product__c p : [select sku__c, id, name from e_product__c where name like 'CloudCrazeTestProduct%']) {
        	if(p.name == 'CloudCrazeTestProduct1') {
        		currentProductId = p.id;
        	} else {
        		skuQtyMap.put(p.sku__c, 1);
        	}
        }
        	
        System.runas(cc_test_TestDataSetup.testUser) {
        	Test.startTest();
			
        	ID accountId = cc_util_CloudCraze.getAccountID(cc_test_TestDataSetup.testUser);
        	list<id> plAssigned = cc_ctrl_PricingEngine.getAssignedPriceLists(accountID, null);
        	List<E_PriceListItem__c> plis = cc_ctrl_PricingEngine.getPriceLines(new list<string>{'99990','99991', '99992', '99993'} , accountId, null, null, null);
      
        	cc_ctrl_Homepage homepageCtrl = new cc_ctrl_Homepage();
        	Pagereference currentPage = System.Page.HomePage;
        	Test.setCurrentPage(currentPage);
        	E_Cart__c cart = insertCart(true);
        	cart = [select id, encryptedID__c from e_cart__c where id = :cart.id];
        	cc_api_addToCart add2CartApi = new cc_api_addToCart(homepageCtrl);
        	add2CartApi.currentProductId = currentProductId;
        	add2CartApi.quantity = quantity;
        	add2CartApi.qtyAvailable = qtyAvailable;
        	
        	add2CartApi.skuQtyMap = skuQtyMap;
        	add2CartApi.currentCartID = cart.id;
        	add2CartApi.addToCart();
        	E_Cart__c c=cc_dao_Cart.retrieveCartHeaderAddressesLineItems(add2CartApi.currentCartID);
        	System.debug('ryl-> add2Cart->' + c);
        	for(e_cartitem__c ci : c.E_CartItems__r) {
        		System.debug('ryl-> add2Cart->' + ci);
        	}
        	/*
        cc_ctrl_AddToCart con = new cc_ctrl_AddToCart();
        
        //Pagereference currentPage = new Pagereference('/apex/DEAD_CartPage');
        Pagereference currentPage = System.Page.Cart;
                
        currentPage.getParameters().put('cartID', cart.id); 
        currentPage.getParameters().put('prodId', prod[0].id);
        currentPage.getParameters().put('qty', '1');
        
        
        currentPage.getParameters().put('skuTextCount', '5');
        currentPage.getParameters().put('sku1', prod[0].SKU__c);
        currentPage.getParameters().put('sku2', prod[1].SKU__c);
        currentPage.getParameters().put('sku3', prod[2].SKU__c);
        currentPage.getParameters().put('sku4', prod[3].SKU__c);
        currentPage.getParameters().put('sku5', prod[4].SKU__c);
        
        currentPage.getParameters().put('qty1',String.valueOf(prod[0].QuantityPerUnit__c));
        currentPage.getParameters().put('qty2',String.valueOf(prod[1].QuantityPerUnit__c));
        currentPage.getParameters().put('qty3',String.valueOf(prod[2].QuantityPerUnit__c));
        currentPage.getParameters().put('qty4',String.valueOf(prod[3].QuantityPerUnit__c));
        currentPage.getParameters().put('qty5',String.valueOf(prod[4].QuantityPerUnit__c));
        //currentPage.getParameters().put('store', cc_util_CloudCraze.application.Default_Storefront__c);
        currentPage.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, 'US');
        
        Test.setCurrentPage(currentPage);
        System.assertNotEquals(null, con.addToCart());
        System.assertNotEquals(null, con.addToWishList());
        */
        test.stopTest();
        }
     }
     
     static testMethod void addToCartTest2() {
     	
     	cc_test_TestDataSetup.LoadData();
     	
        cc_api_dl_products prods = new cc_api_dl_products();
        prods.loadData();
        cc_api_dl_priceListLines priceLines = new cc_api_dl_priceListLines();
        priceLines.loadData();
        
        String currentProductId = null;
        integer quantity = 2;
        integer qtyAvailable = 1;
        map<string, integer> skuQtyMap = new map<string, integer>();
        for(E_Product__c p : [select sku__c, id, name from e_product__c where name like 'CloudCrazeTestProduct%']) {
        	if(p.name == 'CloudCrazeTestProduct1') {
        		currentProductId = p.id;
        	} else {
        		skuQtyMap.put(p.sku__c, 1);
        	}
        }
        	
        System.runas(cc_test_TestDataSetup.testUser) {
        	Test.startTest();
			
        	ID accountId = cc_util_CloudCraze.getAccountID(cc_test_TestDataSetup.testUser);
        	list<id> plAssigned = cc_ctrl_PricingEngine.getAssignedPriceLists(accountID, null);
        	List<E_PriceListItem__c> plis = cc_ctrl_PricingEngine.getPriceLines(new list<string>{'99990','99991', '99992', '99993'} , accountId, null, null, null);
      
        	cc_ctrl_Homepage homepageCtrl = new cc_ctrl_Homepage();
        	Pagereference currentPage = System.Page.HomePage;
        	Test.setCurrentPage(currentPage);
        	E_Cart__c cart = insertCart(true);
        	cart = [select id, encryptedID__c from e_cart__c where id = :cart.id];
        	cc_api_addToCart add2CartApi = new cc_api_addToCart(homepageCtrl);
        	add2CartApi.currentProductId = currentProductId;
        	add2CartApi.quantity = quantity;
        	add2CartApi.qtyAvailable = qtyAvailable;
        	
        	add2CartApi.skuQtyMap = skuQtyMap;
        	add2CartApi.currentCartID = cart.id;
        	add2CartApi.addToCart();
        	E_Cart__c c=cc_dao_Cart.retrieveCartHeaderAddressesLineItems(add2CartApi.currentCartID);
        	System.debug('ryl-> add2Cart->' + c);
        	for(e_cartitem__c ci : c.E_CartItems__r) {
        		System.debug('ryl-> add2Cart->' + ci);
        	}
        	
        test.stopTest();
        }
     }
        
     static testMethod void addInvalidBulkItemsToCartTest() {
        //cc_test_PrepTestData.loadCustomSettings();
        cc_test_TestDataSetup.LoadData();
        System.runas(cc_test_TestDataSetup.testUser) {
        Test.startTest();

        E_Cart__c cart = insertCart(true);
        cc_ctrl_AddToCart con = new cc_ctrl_AddToCart();
        
        //Pagereference currentPage = new Pagereference('/apex/DEAD_CartPage');
        Pagereference currentPage = System.Page.Cart;
                
        currentPage.getParameters().put('cartID', cart.id); 
        
         /*
         * Test for invalid SKU case
         */
        currentPage.getParameters().put('skuTextCount', '5');
        currentPage.getParameters().put('sku1', 'dummysku1');
        currentPage.getParameters().put('sku2', 'dummysku2');
        currentPage.getParameters().put('sku3', 'dummysku3');
        currentPage.getParameters().put('sku4', 'dummysku4');
        currentPage.getParameters().put('sku5', 'dummysku5');
        
        //Qty can be same as it is SKU which matters
        currentPage.getParameters().put('qty1','1');
        currentPage.getParameters().put('qty2','1');
        currentPage.getParameters().put('qty3','1');
        currentPage.getParameters().put('qty4','1');
        currentPage.getParameters().put('qty5','1');
        //currentPage.getParameters().put('store', cc_util_CloudCraze.application.Default_Storefront__c);
        currentPage.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, 'US');
        
        Test.setCurrentPage(currentPage);
        //System.assertNotEquals(null, con.addToCart());
        con.addToCart();
        //System.assertNotEquals(null, con.addToWishList());
        con.addToWishList();
	try{
		con.addToCart();
	}catch(Exception e){
	}
	try{
		con.addToWishList();
	}catch(Exception e){
	}
        Test.stopTest();
        }
    }
    
    private static E_Cart__c insertCart(Boolean activeCart){
        
        E_Cart__c cartHeader = new E_Cart__c();
        cartHeader.CartStatus__c=cc_cnst_PickListConstants.CARTSTATUS_OPEN;       
        
        cartHeader.User__c = UserInfo.getUserId();
        cartHeader.Name__c = 'Dummy Cart Name';
        cartHeader.OwnerId = UserInfo.getUserId();
        cartHeader.AnonymousID__c = false;
        cartHeader.ActiveCart__c = activeCart;
        cartHeader.CartType__c = 'Cart';
        //System.debug('session id-->'+UserInfo.getSessionId());
         //System.debug('user name-->'+UserInfo.getName());
        
        cartHeader.SessionID__c = 'test session';
        
        insert cartHeader;
        return cartHeader;
    }   
     private Static E_Product__c insertProduct(String id){
        E_Product__c prod = new E_Product__c();
        prod.SKU__c = 'UNV21200'+id;
        prod.Name = 'ProductName'+id;
        prod.LeadTime__c = 1;
        prod.QuantityPerUnit__c = 1;
        prod.StartDate__c = System.today();
        prod.EndDate__c = System.today();
        insert prod;
        return prod;
    }
}