public with sharing class cc_dao_Order {

    /**
     * Retrieves the order corresponding to the passed in id.  If the passed in Id is of
     * type Id, then this is the sf id, and query appropriately.  Otherwise, this is the 
     * encrypted order id and query using that field instead. 
     * @param orderId
     * @return Order
     */
    public static E_Order__c getOrder(String orderId, boolean retrieveItems) {
        List<E_Order__c> orderList = new List<E_Order__c>();
        String query = buildOrderSelectQuery();
        if (retrieveItems)
            query += buildOrderItemsQuery(true, null);
        query += 'From E_Order__c ' ;
        if (orderId instanceof Id)
            query += 'Where Id = :orderId';
        else
            query += 'Where EncryptedId__c = :orderId';
        orderList = Database.query(query);
        if (orderList.size() > 0)
            return orderList[0];
        else
            return null;
    }
    
    /**
     * Retrieves the order items corresponding to the passed in id.  If the passed in Id is of
     * type Id, then this is the sf id, and query appropriately.  Otherwise, this is the 
     * encrypted order id and query using that field instead. 
     * @param orderId
     * @return Order
     */
    public static List<E_OrderItem__c> getOrderItems(String orderId) {
        String query = buildOrderItemsQuery(false, orderId);
        List<E_OrderItem__c> orderItemList = Database.query(query);
        return orderItemList;
    }
    
    /**
     * Constructs the select clause for the order query.
     * @return select portion of the query
     */
    public static String buildOrderSelectQuery() {
        String query = 
            'Select ' +
                'Id, ' +
                'Name, ' +
                'OrderID__c, ' +
                'EncryptedId__c, ' +
                'OrderNumber__c, ' +
                'PONumber__c, ' +
                'OriginatedCart__c, ' +
                'OriginatedCart__r.EncryptedID__c, ' +
                'CurrencyISOCode__c, ' +
                'OrderStatus__c, ' +
                'Owner.Name, ' +
                'BuyerEmail__c, ' +
                'BuyerFirstName__c, ' +
                'BuyerLastName__c, ' +
                'BuyerPhone__c, ' +
                'BuyerMobilePhone__c, ' +
                'BuyerCompanyName__c, ' +
                'TotalSurcharge__c, ' +
                'TotalShipDiscount__c, ' +
                'ShipAmount__c, ' +
                'SubTotalAmount__c, ' +
                'SubTotalAmount2__c, ' +
                'TotalDiscount__c, ' +
                'TaxAmount__c, ' +
                'TotalAmount__c, ' +
                'PaymentMethod__c, ' +
                'ExtShipTrackNo__c, ' +
                'shipEstimateGiven__c, ' +
                'ShippingMethod__c, ' +
                'ShipTo__c, ' +
                'ShipTo__r.FirstName__c, ' +
                'ShipTo__r.MiddleName__c, ' +
                'ShipTo__r.LastName__c, ' +
                'ShipTo__r.Email__c, ' +
                'ShipTo__r.HomePhone__c, ' +
                'ShipTo__r.DaytimePhone__c, ' +
                'ShipTo__r.CompanyName__c, ' +
                'ShipTo__r.MailStop__c, ' +
                'ShipTo__r.AddressFirstline__c, ' +
                'ShipTo__r.AddressSecondline__c, ' +
                'ShipTo__r.AddressThirdline__c, ' +
                'ShipTo__r.City__c, ' +
                'ShipTo__r.State__c, ' +
                'ShipTo__r.StateISOCode__c, ' +
                'ShipTo__r.PostalCode__c, ' +
                'ShipTo__r.Country__c, ' +
                'ShipTo__r.CountryISOCode__c, ' +
                'ShipTo__r.KBSAddressType__c, ' +
                'BillTo__c, ' +
                'BillTo__r.FirstName__c, ' +
                'BillTo__r.MiddleName__c, ' +
                'BillTo__r.LastName__c, ' +
                'BillTo__r.Email__c, ' +
                'BillTo__r.HomePhone__c, ' +
                'BillTo__r.DaytimePhone__c, ' +
                'BillTo__r.MailStop__c, ' +
                'BillTo__r.AddressFirstline__c, ' +
                'BillTo__r.AddressSecondline__c, ' +
                'BillTo__r.AddressThirdline__c, ' +
                'BillTo__r.City__c, ' +
                'BillTo__r.State__c, ' +
                'BillTo__r.StateISOCode__c, ' +
                'BillTo__r.PostalCode__c, ' +
                'BillTo__r.Country__c, ' +
                'BillTo__r.KBSAddressType__c, ' +
                'BillTo__r.CountryISOCode__c, ' +
                'due_today__c,' +
                'second_payment__c,' +
                'third_payment__c ';
        return query;
    }
    
    /**
     * Constructs the select clause for the order item query.
     * @param boolean if this is called as a subquery
     * @return order item query
     */
    public static String buildOrderItemsQuery(boolean subquery, String orderId) {
        String query = '';
        if (subquery)
            query += ', (';
        //Roster Changes
        query = 
            'Select ' +
                'Transaction_Code__c, ' +
                'Balance_Due__c, ' +
                'Channel__c, ' +
                'Center_Code__c, ' +
                'Name, ' +
                'Order__c, ' +
                'OrderItemId__c, ' +
                'ProductType__c, ' +
                'Price__c, ' +
                'Quantity__c, ' +
                'RequestDate__c, ' +
                'SubAmount__c, ' +
                'StoreId__c, ' +
                'Product__r.Name, ' +
                'Product__r.SKU__c, ' +
                'Coupon__r.DiscountType__c, ' +
                'UnitOfMeasure__c,  ' +
                'AmountPaid__c, ' +
                'Category__r.Name, ' +
                'AbsoluteDiscount__c, ' +
                'Product__r.ProductId__c, ' +
                'Product__c, ' +
                'OrderLineType__c, ' +
                'Coupon__c, ' +
                'Coupon__r.Rule__r.Name__c, ' +
                'Coupon__r.CouponCode__c,  ';
        if (!subquery)
            query += '(Select Quantity__c, Price__c, SubAmount__c From CC_Order_Item_Pricing_Tiers__r order by Price__c desc) ';
        if (subquery)
            query += 'From E_OrderItems__r ';
        else
            query += 'From E_OrderItem__c Where Order__c = :orderId';
        if (subquery)
            query += ') ';
        return query;
    }

    public static E_Order__c getOrderByEncId(String encryptedOrderId) {
        E_Order__c eOrder = null;

        List<E_Order__c> orderList =
            [select
                Id,
                Name,
                OrderID__c,
                EncryptedId__c,
                OrderNumber__c,
                PONumber__c,
                OriginatedCart__r.EncryptedID__c,
                OrderStatus__c,
                Owner.Name,
                due_today__c,
                BuyerEmail__c,
                BuyerFirstName__c,
                BuyerLastName__c,
                BuyerPhone__c,
                BuyerMobilePhone__c,
                BuyerCompanyName__c,

                TotalSurcharge__c,
                TotalShipDiscount__c,
                ShipAmount__c,
                SubTotalAmount__c,
                SubTotalAmount2__c,
                TotalDiscount__c,
                TaxAmount__c,
                TotalAmount__c,
                PaymentMethod__c,
                ExtShipTrackNo__c,
                shipEstimateGiven__c,
                ShippingMethod__c,
                
                ShipTo__c,
                ShipTo__r.FirstName__c,
                ShipTo__r.MiddleName__c,
                ShipTo__r.LastName__c,
                ShipTo__r.Email__c,
                ShipTo__r.HomePhone__c,
                ShipTo__r.DaytimePhone__c,
                ShipTo__r.CompanyName__c,
                ShipTo__r.MailStop__c,
                
                ShipTo__r.AddressFirstline__c,
                ShipTo__r.AddressSecondline__c,
                ShipTo__r.AddressThirdline__c,
                ShipTo__r.City__c,
                ShipTo__r.State__c,
                ShipTo__r.StateISOCode__c,
                ShipTo__r.PostalCode__c,
                ShipTo__r.Country__c,
                ShipTo__r.CountryISOCode__c,
                
                BillTo__c,
                BillTo__r.FirstName__c,
                BillTo__r.MiddleName__c,
                BillTo__r.LastName__c,
                BillTo__r.Email__c,
                BillTo__r.HomePhone__c,
                BillTo__r.DaytimePhone__c,
                BillTo__r.MailStop__c,
                
                BillTo__r.AddressFirstline__c,
                BillTo__r.AddressSecondline__c,
                BillTo__r.AddressThirdline__c,
                BillTo__r.City__c,
                BillTo__r.State__c,
                BillTo__r.StateISOCode__c,
                BillTo__r.PostalCode__c,
                BillTo__r.Country__c,
                BillTo__r.CountryISOCode__c,
                CurrencyISOCode__c,
                
                /*Kaplan*/
                OriginatedCart__c,
                
                (select Name, Order__c, OrderItemId__c, ProductType__c, Price__c, Quantity__c, 
                    RequestDate__c, SubAmount__c, StoreId__c, Product__r.name,Product__r.SKU__c, Coupon__r.DiscountType__c,UnitOfMeasure__c 
                 from E_OrderItems__r)

            from E_Order__c
            where EncryptedId__c = : encryptedOrderId];

        if(orderList.size() > 0) {
            eOrder = orderList[0];
        }
        
        return eOrder;
    }
}