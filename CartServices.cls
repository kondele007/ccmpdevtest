public with sharing class CartServices
{
    public static void rollUpAmountCharged( List<E_Order__c> incomingOrders )
    {
        Map<Id, Decimal> cartToTotalAmount = new Map<Id, Decimal>();
        for( E_Order__c anOrder : incomingOrders )
        {
            if( anOrder.OriginatedCart__c != NULL )
            {
                cartToTotalAmount.put( anOrder.OriginatedCart__c, 0.0 );
            }
        }

        if( !cartToTotalAmount.isEmpty() )
        {
            List<AggregateResult> cartSummedAmounts = [ SELECT OriginatedCart__c, SUM( AmountCharged__c ) totalAmount
                                                         FROM E_Order__c WHERE OriginatedCart__c IN :cartToTotalAmount.keySet() GROUP BY OriginatedCart__c ];
            for( AggregateResult aResult : cartSummedAmounts )
            {
                cartToTotalAmount.put( (Id)aResult.get('OriginatedCart__c'), (Decimal)aResult.get( 'totalAmount' ) );
            }

            List<E_Cart__c> cartsToModify = new List<E_Cart__c>();
            for( Id cartId : cartToTotalAmount.keySet() )
            {
                cartsToModify.add( new E_Cart__c( Id = cartId, Total_Amount_Charged__c = cartToTotalAmount.get( cartId ) ) );
            }

            updateCarts( cartsToModify, incomingOrders );
        }
    }

    @TestVisible private static void updateCarts( List<E_Cart__c> cartsToModify, List<E_Order__c> triggerRecords )
    {
        try
        {
            update cartsToModify;
        }
        catch( System.DMLException ex )
        {
            Map<Id, List<E_Order__c>> cartsToOrders = new Map<Id, List<E_Order__c>>();
            for( E_Order__c anOrder : triggerRecords )
            {
                if( !cartsToOrders.containsKey( anOrder.OriginatedCart__c ) )
                {
                    cartsToOrders.put( anOrder.OriginatedCart__c, new List<E_Order__c>() );
                }
                cartsToOrders.get( anOrder.OriginatedCart__c ).add( anOrder );
            }
            for( Integer index = 0; index < ex.getNumDml(); index++ )
            {
                Id errorId = cartsToModify[ ex.getDmlIndex(index) ].Id;
                for( E_Order__c anOrder : cartsToOrders.get( errorId ) )
                {
                    anOrder.addError( ex.getDmlMessage( index ) );
                }
            }
        }
    }
}