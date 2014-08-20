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
private class cc_bean_test_MockCartItem {

    static testMethod void myUnitTest() {
        E_Product__c p = new E_Product__c(name='testProduct');
         p.SKU__c = '123';
         p.LongDesc__c = 'This is long description for testing product';
         p.ShortDesc__c = 'This is short description for testing product';
         p.QuantityPerUnit__c = 1.0;
         insert p;
               
        E_Cart__c cart =  new E_Cart__c(SessionId__c='12345');
        insert cart;
        E_CartItem__c ci = new E_CartItem__c(Quantity__c = 1.0, Product__c = p.Id, SubAmount__c = 50.99, Price__c   = 50.99, cart__c = cart.id);
        insert ci;
        E_CartItem__c ciTest = [Select e.Quantity__c, e.Product__r.SKU__c, e.Product__r.Name, e.Product__c, e.Price__c, e.Id, e.Cart__c From E_CartItem__c e where e.id = :ci.id];
        cc_bean_MockCartItem mci = new cc_bean_MockCartItem(ciTest);
        system.assertEquals(mci.cartItemId, ci.id);
        system.assertEquals(mci.price, 50.99);
        system.assertEquals(mci.productId, p.id);
        system.assertEquals(mci.productName, p.name);
        system.assertEquals(mci.sku, p.SKU__c);
        
    }
}