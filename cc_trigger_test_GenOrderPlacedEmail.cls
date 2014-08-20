//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
@isTest
private class cc_trigger_test_GenOrderPlacedEmail {

    static testMethod void sendEmailTest() {
       cc_test_PrepTestData.loadCustomSettings();
       Test.startTest();

       String orderID = createOrder();
       updateOrder(orderID);
       String orderItem = createOrderItem(orderID, cc_util_CloudCraze.application.Default_Storefront__c);
       List<E_OrderItem__c> orderItemList = [Select e.Id,
                                                    e.StoreId__c, 
                                                    e.Order__c
                                             From E_OrderItem__c e
                                             Where e.StoreId__c = :cc_util_CloudCraze.application.Default_Storefront__c
                                             And e.Order__c = :orderID
                                             ];
      System.assertEquals(1, orderItemList.size());
      String orderItemIDFrmDB = orderItemList[0].id;
      System.assertEquals(orderItem, orderItemIDFrmDB);

      Test.stopTest();
    }

    private static String createOrder(){
        E_Order__c order = new E_Order__c();
        order.orderDate__c = System.today();
        order.OrderNumber__c = 1010;
        order.ShipAmount__c = 25;
        order.shipDate__c = System.today();
        order.SubTotalAmount__c =2;
        //order.TotalAmount__c = 23;
        order.TotalDiscount__c = 0;
        order.TotalShipDiscount__c = 0;
        order.TotalSurCharge__c = 1;
        //order.Name = 'Test-1';
        insert order;
        return order.id;
    }
    
     private static void updateOrder(String orderID){
        List<E_Order__c> orderList=[select e.Id,e.ShipAmount__c from E_Order__c e where e.Id=:orderID];
        update orderList;
    }
    
    private static String createOrderItem(String orderID, String storeid){
        E_OrderItem__c thisOrderItem = new E_OrderItem__c();
        thisOrderItem.Quantity__c = 1;
        thisOrderItem.Price__c = 23;
        thisOrderItem.SubAmount__c= 5;
        thisOrderItem.Order__c = orderID;
        thisOrderItem.StoreId__c = storeid;
        insert thisOrderItem;
        return thisOrderItem.id;
    
    }
}