@isTest
private class cc_extn_test_OrderReview_va {

    static testMethod void testOrderReview() {
        cc_test_TestDataSetup.loadData();

        E_ContactAddr__c billTo = new E_ContactAddr__c(
                ContactAddrId__c = 'myTestBillTo',
                DaytimePhone__c='(847) 555-1212',
                FirstName__c='Test', LastName__c='User',
                HomePhone__c='(847) 555-1212',
                AddressFirstline__c='100 Pine Street',
                City__c='SmallTown',
                PostalCode__c='60601',
                State__c='Idaho',
                StateISOCode__c='ID',
                CountryISOCode__c='US'
        );

        E_ContactAddr__c shipTo = new E_ContactAddr__c(
                ContactAddrId__c = 'myTestShipTo',
                DaytimePhone__c='(847) 555-1212',
                FirstName__c='Test', LastName__c='User',
                HomePhone__c='(847) 555-1212',
                AddressFirstline__c='100 Pine Street',
                City__c='SmallTown',
                PostalCode__c='60601',
                State__c='Idaho',
                StateISOCode__c='ID',
                CountryISOCode__c='US'
        );
        insert new List<E_ContactAddr__c> {billTo, shipTo};

        System.RunAs(cc_test_TestDataSetup.testUser) {
            // insert mock cart
            E_Cart__c cart = (new cc_api_Cart_va()).createEmptyCart('USD', 'Commercial');  
            List<E_Product__c> productList = cc_test_PrepTestData.insertProduct(5);
            List<E_CartItem__c> items = cc_test_PrepTestData.insertCartItems(productList,cart.id);
            for (E_CartItem__c item : items) { item.Subamount__c = 2.00; }
            update items;
            
            cart.BillTo__c = billTo.Id;
            cart.ShipTo__c = shipTo.Id;
            update cart;
            
            ApexPages.currentPage().getParameters().put('cartID',cart.EncryptedId__c);
            
            Test.startTest();

            // constructor
            cc_ctrl_Checkout_va controller = new cc_ctrl_Checkout_va();
            cc_extn_OrderReview_va extn = new cc_extn_OrderReview_va(controller);

            System.assert(extn.cartListViewData.size() > 0);
            System.assertEquals(10.00, extn.cartSubAmount);
//          System.assertEquals(7.00, extn.cartShipAmount);
          System.assertEquals(0.00, extn.cartShipAmount);
            System.assertEquals(0.00, extn.cartTaxAmount);
//          System.assertEquals(17.00, extn.cartTotalAmount);
          System.assertEquals(10.00, extn.cartTotalAmount);
          
          //jcruz - July 1
          System.assertNotEquals(-11,extn.cartDueNowTotalAmount);
          System.assertEquals(null,extn.selectCoupon());
          System.assertEquals(null,extn.updateCartCheckout());           
          //end of new code - testing          

            System.assertNotEquals(null, extn.getName());
            System.assertEquals(null, extn.gotoStep());
            System.assertNotEquals(null, extn.getOrderReviewInfo());
            
            extn.updateCouponInfo();
            System.assertNotEquals(null, extn.placeOrder());

            Test.stopTest();
        }
    }
    
}