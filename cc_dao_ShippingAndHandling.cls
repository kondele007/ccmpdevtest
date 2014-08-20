//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
/**
 * This class is used to get the shipping attributes.
 */ 
public with sharing class cc_dao_ShippingAndHandling { 
	//==================================================
    // SERVICE METHODS
    //==================================================
    /**
     * This method is used to get the cart product ids.
     * 
     */    
    public List<E_CartItem__c> getCartProductIds(String cartId) {
    	List<E_CartItem__c> cartList = [Select Product__c, StoreId__c, Quantity__c     
    				 			   		from E_CartItem__c 
    				 			   		where Cart__c = :cartId
    				 			  	   ];
		return cartList;
    }  
    /**
     * This method is used to get the shipping specs.
     * 
     */     
     public List<E_Product__c> getShippingSpecs(Set<String> productList) {
     	List<E_Product__c> shippingSpecs = [Select ProductId__c, ShippingWeight__c, OvernightFlag__c, HazardousOutside48Flag__c,  
     											   HazardousFlag__c, GroundFlag__c, DryIceWeight__c, DryIceFlag__c, CoolerPakFlag__c
     										from E_Product__c 
     										where Id IN :	productList  
     									   ];
     	
     	return shippingSpecs; 
     }
}