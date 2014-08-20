//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_bean_MockOrder {
	//==================================================
    // CONSTRUCTOR
    //==================================================
	public cc_bean_MockOrder(E_Order__c order)
	{
		System.debug(LoggingLevel.INFO, '$$order=' + order);
		dataObject = order;
		if(order != null)
		{
			if(order.BillTo__r != null)
			{
				billTo = new cc_bean_MockContactAddress(order.BillTo__r);
			}
			if(order.ShipTo__r != null)
			{
				shipTo = new cc_bean_MockContactAddress(order.ShipTo__r);
			}
			paymentMethod = order.PaymentMethod__c;
			poNumber = order.PONumber__c;
			shippingMethod = order.ShippingMethod__c;
			shipAmount = order.ShipAmount__c;
			subTotalAmount = order.SubTotalAmount__c;
			subTotalAmount2 = order.SubTotalAmount2__c;
			shipEstimateGiven = order.shipEstimateGiven__c;
			name=order.Name;
			orderNumber = order.OrderNumber__c;
			orderNumberAsString = order.Name;
			sfid = order.Id;
			taxAmount = order.TaxAmount__c;
			totalAmount = order.TotalAmount__c;
			buyerEmail = order.BuyerEmail__c;
			buyerFirstName = order.BuyerFirstName__c;
			buyerLastName = order.BuyerLastName__c;
			buyerPhone = order.BuyerPhone__c;
			buyerMobilePhone = order.BuyerMobilePhone__c;
			buyerCompanyName = order.BuyerCompanyName__c;
			currencyCode = order.CurrencyISOCode__c;
			System.debug(LoggingLevel.INFO, '$$dueTodayAmount=' + order.due_today__c);
			//System.debug(LoggingLevel.INFO, '$$secondPaymentAmount=' + order.second_payment__c);
			//System.debug(LoggingLevel.INFO, '$$thirdPaymentAmount=' + order.third_payment__c);
			dueTodayAmount = order.due_today__c;
			if(shipAmount != null && dueTodayAmount != null){
				dueTodayAmount= dueTodayAmount+shipAmount;
			}
			secondPaymentAmount = order.second_payment__c;
			thirdPaymentAmount = order.third_payment__c;
		}
	}
	public cc_bean_MockOrder(cc_bean_MyOrderItem order)
	{
		if(order != null)
		{
			this.orderDate = order.order.OrderDate__c;
			this.encryptedId = order.order.EncryptedId__c;
			this.status = order.order.OrderStatus__c;
			this.name = order.order.name;
			this.subTotalAmount = order.order.SubTotalAmount__c; 
			this.totalAmount = order.order.TotalAmount__c;
			this.shippingMethod = order.order.ShippingMethod__c;
			this.paymentMethod = order.order.PaymentMethod__c;
		}
	}
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
    /* Kaplan */
    public cc_bean_CreditCard creditCard{get; set;}
    public List<cc_bean_MockOrderItem> orderItems { get; set; }
    public E_Order__c dataObject {get; set;}
    public cc_kap_api_rules_CartRules displayRulesApi { get; set; }
    public Double totalDueNow { get; set; }
    public String currencyCode { get; set; }
    /* Kaplan */
	public cc_bean_MockContactAddress billTo { get; set;}
	public cc_bean_MockContactAddress shipTo { get; set;} 
    public String buyerEmail {get;set;}
    public String buyerFirstName {get;set;}
    public String buyerLastName {get;set;}
    public String buyerPhone {get;set;}
    public String buyerMobilePhone {get;set;}
    public String buyerCompanyName {get;set;}
    public String paymentMethod {get;set;}
	public String poNumber { get; set; }
	public String name { get; set; }
	public String shippingMethod { get; set; }
	public double shipAmount { get; set; }
	public double subTotalAmount { get; set; }
	public double subTotalAmount2 { get; set; }
	public boolean shipEstimateGiven { get; set; }
	public Date orderDate { get; set; }
	public String encryptedId { get; set; }
	public String status { get; set; }
	public Decimal orderNumber { get; set; }
	public String orderNumberAsString {get;set;}
	public Id sfid {get;set;}
	public Double taxAmount {get;set;}
	public Double totalAmount {get;set;}
	public Double totalDiscountAmount {get;set;}
	public Double dueTodayAmount {get;set;}
	public Double secondPaymentAmount {get;set;}
	public Double thirdPaymentAmount {get;set;}
	

    public String orderTaxAmount {
        get {
            return (taxAmount != null ? String.valueOf(taxAmount) : '');
        }
    }
    
    public String orderShipAmount {
        get {
            return (shipAmount != null ? String.valueOf(shipAmount) : '');
        }
    }
    
    public String orderSubTotal{
        get{
            return (subTotalAmount != null ? String.valueOf(subTotalAmount) : '');
        }
    }

    public String orderTotalAmount{
        get{
            return (totalAmount != null ? String.valueOf(totalAmount) : '');
        }
    }

}