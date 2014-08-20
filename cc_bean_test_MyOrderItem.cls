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
private class cc_bean_test_MyOrderItem {

    static testMethod void myUnitTest() {
         E_Product__c p = new E_Product__c();
         p.SKU__c = '123';
         p.LongDesc__c = 'This is long description for testing product';
         p.ShortDesc__c = 'This is short description for testing product';
         p.QuantityPerUnit__c = 1.0;
         insert p;
         
         E_Order__c o = new E_Order__c();
         o.OrderStatus__c = 'Order Submitted';
         insert o;
         
         E_OrderItem__c oi = new E_OrderItem__c();
         oi.Product__c = p.Id;
         oi.Price__c = 100;
         oi.Quantity__c=1;
         oi.Order__c = o.Id;
         oi.SubAmount__c=oi.Price__c*oi.Quantity__c;
         insert oi;
         
         E_ContactAddr__c address = new E_ContactAddr__c(
        							AddressFirstline__c='100 Pine Street', 
        							City__c='SmallTown', 
        							DaytimePhone__c='(847) 555-1212',
        							FirstName__c='Craig', 
        							HomePhone__c='(847) 555-1212', 
        							LastName__c='Traxler',
        							PostalCode__c='60601', 
        							State__c='Idaho', 
        							StateISOCode__c='ID',
        							CountryISOCode__c='US');
        insert address;
         
         Test.startTest();
         cc_bean_MyOrderItem ordItem  =  new cc_bean_MyOrderItem();
         ordItem.order = o;
         ordItem.billingAddress = address;
         ordItem.shippingAddress = address;
         
         System.assertEquals(o.OrderId__c,ordItem.getOrderNumber());
         System.assertEquals('Order Submitted',ordItem.getOrderStatus());
         System.assertEquals('Craig Traxler',ordItem.getShippingName());
         System.assertEquals('Craig Traxler',ordItem.getBillingName());
         System.assertNotEquals(null,ordItem.getOrderEmail());
         Test.stopTest();
    }
}