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
private class cc_bean_test_MockOrderItem {

    static testMethod void myUnitTest() {
         E_Product__c p = new E_Product__c();
         p.SKU__c = '123';
         p.LongDesc__c = 'This is long description for testing product';
         p.ShortDesc__c = 'This is short description for testing product';
         p.QuantityPerUnit__c = 1.0;
         insert p;
         
         E_Order__c o = new E_Order__c();
         insert o;
         E_OrderItem__c oi = new E_OrderItem__c();
         oi.AmountPaid__c = 15.00;
         oi.Product__c = p.Id;
         oi.Price__c = 100;
         oi.Quantity__c=1;
         oi.Order__c = o.Id;
         oi.SubAmount__c=oi.Price__c*oi.Quantity__c;
         insert oi;
         
         oi = [select Name, product__r.sku__c, product__r.Name,product__r.Id, SubAmount__c, StoreId__c, Quantity__c, Price__c, 
            Category__r.Name, OrderLineType__c, Coupon__c, Coupon__r.Rule__r.Name__c, AbsoluteDiscount__c, AmountPaid__c,Transaction_Code__c,Channel__c,Center_Code__c,Balance_Due__c,
            (select Quantity__c, Price__c, SubAmount__c from CC_Order_Item_Pricing_Tiers__r order by Price__c desc) from E_OrderItem__c where id= :oi.id];
         
         cc_bean_MockOrderItem moi = new cc_bean_MockOrderItem(oi);
         System.assertEquals(moi.subAmount, oi.Quantity__c * oi.Price__c );
         System.assertEquals(moi.quantity, 1);
         System.assertEquals(moi.price, 100);
         System.assertEquals(moi.sku, '123');
         
    }
}