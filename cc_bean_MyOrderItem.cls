//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_bean_MyOrderItem {
	 //==================================================
    // INSTANCE PROPERTIES
    //==================================================
    // Used for currrencies (orderTotal,shippingCost,tax,orderSubtotal) 
    public E_Order__c order {get;set;}
    public E_ContactAddr__c billingAddress{get;set;}
    public E_ContactAddr__c shippingAddress{get;set;}
    //public cc_bean_MockContactAddress mockBillingAddress{get; set;}
    //public cc_bean_MockContactAddress mockShippingAddress{get;  set;}
    public List<E_OrderItem__c> orderItems {get;set;}
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
        return String.valueOf(order.OrderId__c);
    }

    public String getOrderStatus(){
        return order.OrderStatus__c;
    }   

    public String getShippingName(){
        String name = '';
        if(shippingAddress != null){
        	if (shippingAddress.FirstName__c !=null){
        		name = shippingAddress.FirstName__c + ' ';
        	}
            if (shippingAddress.MiddleName__c !=null){
            	name = name+shippingAddress.MiddleName__c + ' ';
            }
            if (shippingAddress.LastName__c !=null){
            	name = name+shippingAddress.LastName__c ;
            }
        }
        return name;
    }   

    public String getBillingName(){
        String name = '';
        if(billingAddress != null){
            if (billingAddress.FirstName__c !=null){
        		name = billingAddress.FirstName__c + ' ';
        	}
            if (billingAddress.MiddleName__c !=null){
            	name = name+billingAddress.MiddleName__c + ' ';
            }
            if (billingAddress.LastName__c !=null){
            	name = name+billingAddress.LastName__c ;
            }
        }
        return name;
    }
    public String getOrderEmail(){
        // VALIDATE -- we really should have email in the Order and possibly the Cart.
        // The user could change their email address after having placed an order.
        User user = cc_api_User.getCurrentUser;
        return user.Email;
    }

}