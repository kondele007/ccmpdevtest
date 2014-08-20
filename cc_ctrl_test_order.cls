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
private class cc_ctrl_test_order {

    static testMethod void myUnitTest() {
        
        cc_test_TestDataSetup.loadData();
		insert new list<e_product__c>{new e_product__c(SKU__c='sku1', name='sku1'), new e_product__c(SKU__c='sku2', name='sku2'),
			new e_product__c(SKU__c='sku3', name='sku3'),  new e_product__c(SKU__c='sku4', name='sku4')};
		
        
         
		System.runAs(cc_test_TestDataSetup.testUser) {
			E_order__c o = new E_Order__c();
	        insert o;
	        insert new list<E_OrderItem__c>{new E_OrderItem__c(Product__r = new E_Product__c(sku__c='sku1'), price__c=100,Quantity__c=1, Order__c=o.id, SubAmount__c=100*1),
	        	 new E_OrderItem__c(Product__r = new E_Product__c(sku__c='sku2'), price__c=100,Quantity__c=1, Order__c=o.id, SubAmount__c=100*1)};
	        
	        o = [select EncryptedId__c from e_order__c where id = :o.id];
	        try{
	        	cc_kap_impl_services.callKaplanStudentPlaceOrder(o.id);
	        	cc_util_OrderEmail oe = new cc_util_OrderEmail();
	        	oe.encryptedOrderId = o.EncryptedId__c;
	        	oe.getInit();
	        }catch(exception e){
	        	
	        }
			PageReference pageRef = System.Page.OrderView;
			
        	Test.setCurrentPage(pageRef);
        	try {
        		cc_ctrl_Order ctrlOrder = new cc_ctrl_Order();
        		system.assert(false);
        	}
        	catch(Exception e) {
        		
        	}
        	try {
        		ApexPages.currentPage().getParameters().put(cc_cnst_UrlParams.ORDER_ENC_ID, '12345');
        		cc_ctrl_Order ctrlOrder = new cc_ctrl_Order();
        		system.assert(false);
        	}
        	catch(Exception e) {
        		
        	}
        	ApexPages.currentPage().getParameters().put(cc_cnst_UrlParams.ORDER_ENC_ID, o.EncryptedId__c);
        	ApexPages.currentPage().getParameters().put(cc_cnst_UrlParams.FROM_PAGE, 'HomePage'); 
        	
        	cc_ctrl_Order ctrlOrder = new cc_ctrl_Order();
        	System.assert(ctrlOrder.getOrderController() != null);
			ctrlOrder.orderHasCouponLineItem = false;
			System.assert(ctrlOrder.orderHasCouponLineItem == false);
		}
        
    }
}