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
private class cc_dao_test_Cart_va {

    static testMethod void myUnitTest() {
        
        E_ContactAddr__c shipTo = new E_ContactAddr__c(
        AddressFirstline__c='100 Pine Street', City__c='SmallTown', DaytimePhone__c='(847) 555-1212',
        FirstName__c='Craig', HomePhone__c='(847) 555-1212', LastName__c='Traxler',
        PostalCode__c='60601', State__c='Idaho', StateISOCode__c='ID',
        CountryISOCode__c='USA');
        insert shipTo;
        System.assertNotEquals(null, shipTo.Id);

        E_ContactAddr__c billTo = new E_ContactAddr__c(
        AddressFirstline__c='100 Pine Street', City__c='SmallTown', DaytimePhone__c='(847) 555-1212',
        FirstName__c='Craig', HomePhone__c='(847) 555-1212', LastName__c='Traxler',
        PostalCode__c='60601', State__c='Idaho', StateISOCode__c='ID',
        CountryISOCode__c='USA');
        insert billTo;
        System.assertNotEquals(null, billTo.Id);
        
        List<E_Product__c> ps = new List<E_Product__c>{
            new E_Product__c(Name='Product1', Sku__c='sku1', ProductStatus__c='Released', shippingWeight__c=20.0),
            new E_Product__c(Name='Product2', Sku__c='sku2', ProductStatus__c='Released', shippingWeight__c=20.0),
            new E_Product__c(Name='Product3', Sku__c='sku3', ProductStatus__c='Released', shippingWeight__c=20.0),
            new E_Product__c(Name='Product4', Sku__c='sku4', ProductStatus__c='Released', shippingWeight__c=20.0)
        };
        insert ps;

        delete [select Id from E_Cart__c where User__c = :UserInfo.getUserId()];

        E_Cart__c testCart = new E_Cart__c(SessionID__c='anySessionId', Name__c='testCart', CartType__c=cc_cnst_PickListConstants.CARTTYPE_CART, billto__c = billTo.id, shipto__c = shipTo.id,
                            CartStatus__c='Open', AnonymousID__c=false, User__c=UserInfo.getUserId());
        insert testCart;
        List<E_CartItem__c> cartItems = new List<E_CartItem__c> {
            new E_CartItem__c(Quantity__c=1, product__r=new E_Product__c(SKU__c='sku1'), cart__c=testCart.id, price__c=100, SubAmount__c=100.0, cartItemType__c='Major'),
            new E_CartItem__c(Quantity__c=1, product__r=new E_Product__c(SKU__c='sku2'), cart__c=testCart.id, price__c=100, SubAmount__c=100.0, cartItemType__c='Minor'),
            new E_CartItem__c(Quantity__c=1, product__r=new E_Product__c(SKU__c='sku3'), cart__c=testCart.id, price__c=100, SubAmount__c=100.0, cartItemType__c='Major'),
            new E_CartItem__c(Quantity__c=1, product__r=new E_Product__c(SKU__c='sku4'), cart__c=testCart.id, price__c=100, SubAmount__c=100.0, cartItemType__c='Minor')
        };
        insert cartItems;
        
        test.startTest();
        
        testCart = cc_dao_Cart_va.retrieveCartHeader(testCart.id);
        System.assertEquals('testCart', testCart.Name__c);
        try
        {
            E_ContactAddr__c ca = testCart.ShipTo__r;
            System.assert(false); // line above should throw exception
        }catch(Exception e){
            
        }
        
        testCart = cc_dao_Cart_va.retrieveCartHeaderAddresses(testCart.id);
        System.assertEquals('100 Pine Street', testCart.ShipTo__r.AddressFirstline__c);
        System.assertEquals('60601', testCart.BillTo__r.PostalCode__c);
        
        testCart = cc_dao_Cart_va.retrieveCartHeaderAddressesLineItems(testCart.id);
        System.assertEquals(4, testCart.E_CartItems__r.size());
        testCart = cc_dao_Cart_va.retrieveCartHeader(testCart.EncryptedId__c);
        
        testCart = cc_dao_Cart_va.retrieveCartHeaderAddresses(testCart.EncryptedId__c);
        System.assertEquals('100 Pine Street', testCart.ShipTo__r.AddressFirstline__c);
        System.assertEquals('60601', testCart.BillTo__r.PostalCode__c);
        testCart = cc_dao_Cart_va.retrieveCartHeaderAddressesLineItems(testCart.EncryptedId__c);
        System.assertNotEquals(null, cc_dao_Cart_va.getLastModifiedValidCart(UserInfo.getUserId()));
        testCart.CartStatus__c = cc_cnst_PickListConstants.CARTSTATUS_CLOSED;
        update testCart;
        try
        {
            cc_dao_Cart_va.retrieveCartHeaderAddressesLineItems(testCart.EncryptedId__c);
            System.assert(false); // line above should throw exception
        }
        catch(cc_api_Cart.CartIsClosedException e) {
            
        }
        
        
        System.assertEquals(null, cc_dao_Cart_va.retrieveCartHeader(null));
        
        System.assertEquals(4, cc_dao_Cart_va.getCartItems(testCart.EncryptedId__c, 0).size());
        System.assertEquals(2, cc_dao_Cart_va.getCartItems(testCart.EncryptedId__c, 2).size());
        System.assertEquals(0, cc_dao_Cart_va.getCartItems(null, 2).size());
        System.assertEquals(2, cc_dao_Cart_va.getMajorCartItems(testCart.EncryptedId__c, 0).size());
        
        E_Cart__c testCart2 = new E_Cart__c(SessionID__c='anySessionId12', Name__c='testCart', CartType__c=cc_cnst_PickListConstants.CARTTYPE_CART, billto__c = billTo.id, shipto__c = shipTo.id,
                            CartStatus__c='Open', AnonymousID__c=false, User__c=UserInfo.getUserId(), ActiveCart__c = true);
        insert testCart2;
        
        System.assertEquals(1, cc_dao_Cart_va.getActiveCartOwnedBy(UserInfo.getUserId()).size()); 
        
        list<E_Cart__c> testCarts = [Select e.Account__c,e.CartStatus__c, e.CurrencyISOCode__c, e.CustomerTypeCode__c, e.DeliveryDate__c, e.Id, e.ActiveCart__c,e.Name, e.Name__c, e.Note__c, e.OwnerId, e.RequestDate__c, e.SessionID__c, e.SubTotalAmount__c, e.TotalAmount__c, e.Owner.Email,e.TotalDiscount__c, e.TotalShipDiscount__c, e.User__c, e.EncryptedId__c, e.ShipTo__c, e.BillTo__c, e.SubTotalAmount_2__c,e.AnonymousID__c, e.owner.username from e_cart__c e where  e.CartType__c = 'Cart' and e.IsDeleted = false and e.ActiveCart__c = true and e.CartStatus__c = 'Open' order by e.LastModifiedDate desc];
        for(E_Cart__c cart : testCarts) {
            system.debug('user name =' + cart.owner.username);
        }
        
        System.debug('username = ' + UserInfo.getUsername()); 
        System.assertEquals(1, cc_dao_Cart_va.getActiveCartOwnedByUserName(UserInfo.getUsername()).size());
        
        test.stopTest();
        
    }
}