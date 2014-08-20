//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class ktp_cc_bean_MyOrderItem {
     //==================================================
    // INSTANCE PROPERTIES
    //==================================================
    // Used for currrencies (orderTotal,shippingCost,tax,orderSubtotal) 
    public ccrz__E_Order__c order {get;set;}
    public ccrz__E_ContactAddr__c billingAddress{get;set;}
    public ccrz__E_ContactAddr__c shippingAddress{get;set;}
    //public cc_bean_MockContactAddress mockBillingAddress{get; set;}
    //public cc_bean_MockContactAddress mockShippingAddress{get;  set;}
    public List<ccrz__E_OrderItem__c> orderItems {get;set;}
    public String poNumber {
        get {
            return 'credit';
        }
        set;
    }
    
    //==================================================
    // HELPER METHODS
    //==================================================
    public String getOrderNumber(){
        return String.valueOf(order.ccrz__OrderId__c);
    }

    public String getOrderStatus(){
        return order.ccrz__OrderStatus__c;
    }   

    public String getShippingName(){
        String name = '';
        if(shippingAddress != null){
            if (shippingAddress.ccrz__FirstName__c !=null){
                name = shippingAddress.ccrz__FirstName__c + ' ';
            }
            if (shippingAddress.ccrz__MiddleName__c !=null){
                name = name+shippingAddress.ccrz__MiddleName__c + ' ';
            }
            if (shippingAddress.ccrz__LastName__c !=null){
                name = name+shippingAddress.ccrz__LastName__c ;
            }
        }
        return name;
    }   

    public String getBillingName(){
        String name = '';
        if(billingAddress != null){
            if (billingAddress.ccrz__FirstName__c !=null){
                name = billingAddress.ccrz__FirstName__c + ' ';
            }
            if (billingAddress.ccrz__MiddleName__c !=null){
                name = name+billingAddress.ccrz__MiddleName__c + ' ';
            }
            if (billingAddress.ccrz__LastName__c !=null){
                name = name+billingAddress.ccrz__LastName__c ;
            }
        }
        return name;
    }
    public String getOrderEmail(){
        // VALIDATE -- we really should have email in the Order and possibly the Cart.
        // The user could change their email address after having placed an order.
        User user = ktp_cc_api_User.getCurrentUser;
        return user.Email;
    }

}