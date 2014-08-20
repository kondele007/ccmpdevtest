//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class ktp_cc_bean_MockOrderItem {
    //==================================================
    // INNER CLASS 
    //==================================================
    public class OrderItemPricingTier {
        //==================================================
        // INSTANCE PROPERTIES
        //==================================================
        public integer quantity { get; set; }
        public decimal price { get; set; }
        public decimal subAmount { get; set; }
        public decimal amountPaid{get; set;}
        
        //==================================================
        // CONSTRUCTOR
        //==================================================
        public OrderItemPricingTier(integer qty, decimal price, decimal subAmount) {
            this.quantity = qty;
            this.price = price;
            this.subAmount = subAmount;
        }
        public OrderItemPricingTier(ccrz__E_OrderItemPricingTier__c t) {
            this.quantity = t.ccrz__Quantity__c.intValue();
            this.price = t.ccrz__Price__c;
            this.subAmount = t.ccrz__subAmount__c;
        }
        
    }
    //==================================================
    // CONSTRUCTOR
    //==================================================
    public ktp_cc_bean_MockOrderItem(ccrz__E_OrderItem__c item) 
    {
        dataObject = item;
        if(item != null)
        {
            //Roster Changes
            transactionCode = item.Transaction_Code__c;
            channel = item.Channel__c;
            centerCode = item.Center_Code__c;
            balanceDue = item.Balance_Due__c;
            sfid = item.Id;
            name = item.Name;
            subAmount = item.ccrz__SubAmount__c;
            storeId = item.ccrz__StoreId__c;
            quantity = item.ccrz__Quantity__c;
            sku = item.ccrz__Product__r.ccrz__SKU__c;
            productName = item.ccrz__Product__r.Name;
            price = item.ccrz__Price__c;
            categoryName = item.ccrz__Category__r.Name;
            productId = item.ccrz__Product__r.id;
            orderLineType = item.ccrz__OrderLineType__c;
            couponId = item.ccrz__Coupon__c;
            ruleName = item.ccrz__Coupon__r.ccrz__Rule__r.ccrz__Name__c;
            couponCode = item.ccrz__Coupon__r.ccrz__CouponCode__c;
            absoluteDiscount = item.ccrz__AbsoluteDiscount__c;
            amountPaid = item.AmountPaid__c;
            if(item.ccrz__CC_Order_Item_Pricing_Tiers__r != null) {
                pricingTiers = new List<OrderItemPricingTier>();
                for(ccrz__E_OrderItemPricingTier__c tier : item.ccrz__CC_Order_Item_Pricing_Tiers__r ) {
                    pricingTiers.add(new OrderItemPricingTier(tier));
                }
            }
        }
    }

    //==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public decimal subAmount { get; set;}
    public decimal amountPaid { get; set;}
    public String storeId { get; set;}
    public double quantity { get; set;} 
    public String sku  { get; set;}
    public String productName { get; set;}
    public decimal price { get; set;}
    public String categoryName { get; set; }
    public String productId { get; set; }
    public String orderLineType { get; set; }
    public String couponId { get; set; }
    public String ruleName { get; set; }
    public List<OrderItemPricingTier> pricingTiers { get; set; }
    
    public Decimal absoluteDiscount {get;set;}
    public Decimal percentDiscount {get;set;}
    
    /** Kaplan Phase 1 Begin */
    public cc_kap_rules_bean_CartDataRulesBean rulesBean { get; set; }
    public DateTime flexDate { get; set; } 
    public DateTime flexEndDate{get; set;}
    public DateTime startDate { get; set; }
    public DateTime endDate { get; set; }
    public String startDateStrET { get; set; }
    public String endDateStrET { get; set; }
    public String productCode { get; set; }
    public String parentCode { get; set; }
    public String shipMethod { get; set; }
    public Decimal shipCharge { get; set; }
    public Integer installments { get; set; }
    public String centerId { get; set; }
    public Integer deliveryTypeCode { get; set; }
    public String deliveryTypeDesc { get; set; }
    public String eventType { get; set; }
    public Decimal discountAmount { get; set; }
    public Decimal listPrice { get; set; }
    public Decimal offeredPrice { get; set; }
    public Decimal couponDiscount { get; set; }
    public ccrz__E_OrderItem__c dataObject {get; set; }
    public String couponCode { get; set; }
    public Id sfid {get;set;}
    public String sbuCode { get; set; }
    public String name { get; set; }

    //Roster Changes
    public String transactionCode { get; set; }
    public Decimal channel { get; set; }
    public Decimal balanceDue { get; set; }
    public String centerCode { get; set; }
    
    /** Kaplan Phase 1 End */

    /************* CASE # 1732 - Begin ************/

    public String kbsProgramCode {get;set;}

    /************* CASE # 1732 - End ************/
    
}