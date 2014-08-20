@isTest
private class CartServicesTest
{
    final static Integer NUM_CARTS = 10;
    final static Integer NUM_ORDERS_PER = 5;
    final static Decimal ORDER_AMOUNT = 10.9;

    static testMethod void testRollUpAmountCharged()
    {
        List<E_Cart__c> testCarts = KapTestUtil.createCarts( NUM_CARTS, true );
        List<E_Order__c> testOrders = new List<E_Order__c>();
        for( E_Cart__c aCart : testCarts )
        {
            for( E_Order__c anOrder : KapTestUtil.createOrders( NUM_ORDERS_PER, aCart.Id, false ) )
            {
                anOrder.ShipAmount__c = ORDER_AMOUNT;
                testOrders.add( anOrder );
            }
        }

        Test.startTest();

            insert testOrders;

        Test.stopTest();

        List<E_Cart__c> updatedCarts = [ SELECT Id, Total_Amount_Charged__c FROM E_Cart__c ];
        System.assertEquals( NUM_CARTS, updatedCarts.size(), 'There should be as many carts as were created' );
        for( E_Cart__c aCart : updatedCarts )
        {
            System.assertEquals( NUM_ORDERS_PER * ORDER_AMOUNT, aCart.Total_Amount_Charged__c, 'The cart should have rolled up the amounts of all its orders' );
        }
    }

    static testMethod void testRollUpAmountCharted_ErrorHandling()
    {
        List<E_Cart__c> testCarts = KapTestUtil.createCarts( NUM_CARTS, true );
        List<E_Order__c> testOrders = new List<E_Order__c>();
        for( E_Cart__c aCart : testCarts )
        {
            testOrders.add( KapTestUtil.createOrders( 1, aCart.Id, false )[0] );
        }
        insert testOrders;

        Test.startTest();

            for( E_Cart__c aCart : testCarts )
            {
                aCart.Total_Amount_Charged__c = ORDER_AMOUNT;
                aCart.SessionId__c = null; // force dml exception
            }
            CartServices.updateCarts( testCarts, testOrders );

        Test.stopTest();

        List<E_Cart__c> updatedCarts = [ SELECT Id, Total_Amount_Charged__c FROM E_Cart__c ];
        System.assertEquals( NUM_CARTS, updatedCarts.size(), 'There should be as many carts as were created' );
        for( E_Cart__c aCart : updatedCarts )
        {
            System.assertNotEquals( ORDER_AMOUNT, aCart.Total_Amount_Charged__c, 'The cart should not have been updated' );
        }
    }
}