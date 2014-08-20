//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public without sharing class cc_util_Order_va {
    //==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public Boolean orderHasCouponLineItem {
        get {
            if(orderHasCouponLineItem == null) {
                orderHasCouponLineItem = false;
            }
            return orderHasCouponLineItem;
        }
        set;
    }
    public Boolean printViewEnabled{get; set;}
    public ID orderID {get;set;}
    public String encrytpedId { get; set; }
    public Boolean orderComplete{get; set;}
    public String orderTaxAmount {
        get {
            return (this.orderObj!=null && this.orderObj.TaxAmount__c != null ? String.valueOf(this.orderObj.TaxAmount__c.setScale(2)) :'');
        }
    }
    
    public String orderShipAmount {
        get {
            return (this.orderObj!=null && this.orderObj.ShipAmount__c != null ? String.valueOf(this.orderObj.ShipAmount__c.setScale(2)) :'');
        }
    }
    
    public String orderSubTotal{
        get{
            return (this.orderObj!=null && this.orderObj.SubTotalAmount__c != null ?String.valueOf(this.orderObj.SubTotalAmount__c.setScale(2)) :'');
        }
    }
    public String orderTotalAmount{
        get{
            return (this.orderObj!=null && this.orderObj.TotalAmount__c != null ?String.valueOf(this.orderObj.TotalAmount__c.setScale(2)) :'');
        }
    }
    public Boolean orderOnHold{
        get{
            return (this.orderObj!=null?(this.orderObj.OrderStatus__c == cc_cnst_PickListConstants.ORDERSTATUS_ONHOLD):false);
        }
    }
    //==================================================
    // CONSTRUCTOR
    //==================================================
    public cc_util_Order_va(){
        this.orderComplete= false;
        printViewEnabled = false;       
    }
    //==================================================
    // INSTANCE VARIABLES
    //==================================================
    private E_Order__c orderObj =null;
    private cc_bean_MockOrder_va mockOrderBean=null;
    public List<cc_bean_CreditCard> creditCards;
    public List<E_OrderItem__c> orderItems;
    //==================================================
    // HELPER METHODS
    //==================================================
    public cc_bean_MockOrder_va getMockOrder() 
    { 
        if(mockOrderBean == null) 
        {
            orderObj = getOrder();
            mockOrderBean = new cc_bean_MockOrder_va(orderObj);
            if(orderObj == null)
            {
                //mockOrderBean.billTo = new cc_bean_MockContactAddress();
                //mockOrderBean.billTo.address1='order == null';
            }
            if(mockOrderBean.billTo == null)
            {
                //mockOrderBean.billTo = new cc_bean_MockContactAddress();
                //mockOrderBean.billTo.address1='cc_bean_MockOrder.billTo == null';
            }
            if(orderObj != null && orderObj.OriginatedCart__c != null){
                creditCards = getCreditCardItems(orderObj.OriginatedCart__c);
                if(creditCards.size() > 0){
                    mockOrderBean.creditCard = creditCards[0];
                }
            }
        } 
        return mockOrderBean;
    } 
    //public String paymentType
    
    //==================================================
    // SERVICE METHODS
    //==================================================
    public Integer getItemsSize(){
        return getOrder().E_OrderItems__r.size();
        //return ((List<E_OrderItem__c>)(getOrder().E_OrderItems__r)).size();
    }
    
    public List<E_OrderItem__c> getItems() {
        List<E_OrderItem__c> items = null;
        if(getOrder() != null) {
            items = [select Name, Order__c, ProductType__c, OrderItemID__c, Price__c, Quantity__c, AmountPaid__c, Category__r.Name, AbsoluteDiscount__c,
                             RequestDate__c, SubAmount__c, StoreId__c, Product__r.ProductId__c, Product__r.Name, Product__c, Product__r.SKU__c, Coupon__r.DiscountType__c,UnitOfMeasure__c,
                             OrderLineType__c, Coupon__c, Coupon__r.Rule__r.Name__c, Coupon__r.CouponCode__c, 
                             (select Quantity__c, Price__c, SubAmount__c from CC_Order_Item_Pricing_Tiers__r order by Price__c desc)
                     From E_OrderItem__c
                     where Order__c = :this.orderId];
        } else {
            items = new List<E_OrderItem__c>();
        }       
        return items;
    }
    
    public List<cc_bean_MockOrderItem_va> getMockOrderItems()
    {
        List<cc_bean_MockOrderItem_va> mockItems = new List<cc_bean_MockOrderItem_va> ();
        if(this.orderId != null){
            List<E_OrderItem__c> orderItems = [Select SubAmount__c, StoreId__c, Quantity__c, Product__r.SKU__c, Category__r.Name,
                    Product__r.ProductId__c, Product__r.Name, Product__c, Price__c, AbsoluteDiscount__c,
                    Name, OrderLineType__c, Coupon__c, Coupon__r.Rule__r.Name__c, AmountPaid__c, Transaction_Code__c, Channel__c, Center_Code__c, Balance_Due__c,
                    (select Quantity__c, Price__c, SubAmount__c from CC_Order_Item_Pricing_Tiers__r order by Price__c desc)
             From E_OrderItem__c
             Where Order__c=:this.orderId];
             
             for(E_OrderItem__c item : orderItems) {
                 mockItems.add(new cc_bean_MockOrderItem_va(item));
                if (item.OrderLineType__c == 'Coupon') {
                    orderHasCouponLineItem = true;
                }
             }
            
        }
        return mockItems; 
    }
    
    /** Kaplan Phase 1 Begin */
    public cc_bean_MockOrder_va retrieveFullOrderData() {
        return retrieveFullOrderData(false);
    }
    
    public cc_bean_MockOrder_va retrieveFullOrderData(boolean includeRules) {
        String queryId = this.orderId;
        if (queryId == null)
            queryId = this.encrytpedId;
        if (queryId == null)
            return null;
        E_Order__c currOrder = cc_dao_Order.getOrder(queryId, false);
        if (currOrder == null)
            return null;
        this.orderObj = currOrder;
        cc_bean_MockOrder_va orderWrapper = getMockOrder();
        List<E_CartItem__c> cartItems = cc_dao_Cart_va.getDisplayCartItems(currOrder.OriginatedCart__c);
        cc_kap_api_rules_CartRules_va displayRulesApi = new cc_kap_api_rules_CartRules_va(cartItems, currOrder.CurrencyISOCode__c);
        displayRulesApi.constructLineData();
        if (includeRules)
            orderWrapper.displayRulesApi = displayRulesApi;
        List<E_OrderItem__c> orderItems = cc_dao_Order.getOrderItems(currOrder.Id);
        List<cc_bean_MockOrderItem_va> orderLines = new List<cc_bean_MockOrderItem_va> ();
        Double totalLineAmountPaid = 0.0;
        for (E_OrderItem__c orderItem: orderItems) {
            cc_bean_MockOrderItem_va orderLineWrapper = new cc_bean_MockOrderItem_va(orderItem);
            cc_kap_rules_bean_CartDataRulesBean_va rulesBean = displayRulesApi.getDisplayRuleBean(orderItem.Product__r.SKU__c);
            if (rulesBean != null) {
                System.debug(LoggingLevel.INFO,'rulesBean.flexDate --' + rulesBean.flexDate);
                orderLineWrapper.flexDate = rulesBean.flexDate;
                System.debug(LoggingLevel.INFO,'rulesBean.flexEndDate --' + rulesBean.flexEndDate);
                orderLineWrapper.flexEndDate = rulesBean.flexEndDate;
                orderLineWrapper.installments = rulesBean.selectedInstallment;
                orderLineWrapper.parentCode = rulesBean.parentCode;
                orderLineWrapper.productCode = rulesBean.code;
                orderLineWrapper.shipCharge = rulesBean.line.Shipping_Charge__c;
                orderLineWrapper.shipMethod = rulesBean.line.Shipping_Method__c;
                orderLineWrapper.startDate = rulesBean.classStartDate;
                orderLineWrapper.endDate = rulesBean.classEndDate;
                orderLineWrapper.centerId = rulesBean.centerId;
                orderLineWrapper.deliveryTypeCode = Integer.valueOf(rulesBean.productDeliveryType);
                orderLineWrapper.deliveryTypeDesc = rulesBean.displayDeliveryType;
                orderLineWrapper.sbuCode = rulesBean.sbuCode;
                orderLineWrapper.listPrice = rulesBean.availableInstallments.get(0).listPrice;
                orderLineWrapper.discountAmount = rulesBean.availableInstallments.get(0).totalDiscount;
                orderLineWrapper.couponDiscount = rulesBean.availableInstallments.get(0).couponDiscount;
                orderLineWrapper.offeredPrice = rulesBean.availableInstallments.get(0).offeredPrice;
                if (rulesBean.line.Product__r.EventType__c != null)
                    orderLineWrapper.eventType = rulesBean.line.Product__r.EventType__c;
                else if (rulesBean.line.Product__r.ParentProduct__c != null)
                    orderLineWrapper.eventType = rulesBean.line.Product__r.ParentProduct__r.EventType__c;
                if (includeRules) {
                    orderLineWrapper.rulesBean = rulesBean;
        }
            }
            else
                System.debug('Could not retrieve Rules bean for ' + orderItem.Product__r.SKU__c);
            orderLines.add(orderLineWrapper);
            if (orderItem.OrderLineType__c == 'Coupon')
                orderHasCouponLineItem = true;
            totalLineAmountPaid += orderItem.AmountPaid__c != null? orderItem.AmountPaid__c : 0.0;
        }
        orderWrapper.totalDueNow = totalLineAmountPaid;
        orderWrapper.orderItems = orderLines;
        return orderWrapper;
    }
    /** Kaplan Phase 1 End */
    
    public E_Order__c getOrder(){
        if(orderObj == null){
            List<E_Order__c> orders = [Select e.shipEstimateGiven__c, e.TotalSurcharge__c, e.ExtShipTrackNo__c, e.TotalShipDiscount__c, e.SubTotalAmount__c, e.EncryptedId__c,
                                            e.TotalDiscount__c, e.TotalAmount__c, e.TaxAmount__c, e.ShipTo__r.Email__c, e.due_today__c,e.second_payment__c,
                                            e.ShipTo__r.State__c, e.ShipTo__r.PostalCode__c, e.ShipTo__r.Country__c,e.third_payment__c,
                                            e.ShipTo__r.MiddleName__c, e.ShipTo__r.StateISOCode__c, e.ShipTo__r.LastName__c, e.ShipTo__r.HomePhone__c, 
                                            e.ShipTo__r.FirstName__c, e.ShipTo__r.City__c, e.ShipTo__r.AddressSecondline__c, 
                                            e.ShipTo__r.AddressFirstline__c, e.ShipTo__c, e.ShipAmount__c, e.PONumber__c, e.OrderNumber__c, 
                                            e.OrderID__c, e.Name, e.Id, e.BillTo__r.Email__c, e.BillTo__r.State__c, 
                                            e.BillTo__r.StateISOCode__c, e.BillTo__r.PostalCode__c, e.BillTo__r.MiddleName__c, 
                                            e.BillTo__r.LastName__c, e.BillTo__r.HomePhone__c, e.BillTo__r.FirstName__c, 
                                            e.BillTo__r.Country__c, e.BillTo__r.CountryISOCode__c, e.BillTo__r.City__c, e.BillTo__r.AddressSecondline__c, 
                                            e.BillTo__r.AddressFirstline__c, e.BillTo__c, e.OriginatedCart__r.EncryptedID__c, e.BillTo__r.KBSAddressType__c, e.ShipTo__r.KBSAddressType__c,CurrencyIsoCode__c,
                                            e.OrderStatus__c, e.ShippingMethod__c, e.Owner.Name, e.PaymentMethod__c, e.SubTotalAmount2__c, e.BuyerEmail__c, BuyerFirstName__c, BuyerLastName__c, BuyerPhone__c, BuyerMobilePhone__c, BuyerCompanyName__c,
                                             (Select Name, Order__c, ProductType__c, OrderItemID__c, Price__c, Quantity__c, 
                                                     RequestDate__c, SubAmount__c, StoreId__c, Product__r.name,Product__r.SKU__c, Coupon__r.DiscountType__c,UnitOfMeasure__c  From E_OrderItems__r),
                                                     OriginatedCart__c
                                    From E_Order__c e
                    where e.Id=:this.orderId];
            if(orders.size()==0){
                return null;
            } else {
                orderObj = orders[0];
            }
        }
        return orderObj;


    }
    
    public List<E_OrderItem__c> getOrderItems(){
        if(orderItems == null){
            orderItems = [select
                Id,
                Name,
                ProductType__c,
                Coupon__r.DiscountType__c,
                DeliveryDate__c,
                Order__c,
                Price__c,
                Product__r.Name,
                Quantity__c,
                StoreId__c,
                SubAmount__c,
                UnitOfMeasure__c,
                Product__r.SKU__c
                
                from E_OrderItem__c
                where Order__c = :orderID
            ];
        }

        
        return orderItems;
    }   
    
    public List<cc_bean_CreditCard> getCreditCardItems(Id cartId){
        List<cc_bean_CreditCard> retList = new List<cc_bean_CreditCard>();
        List<E_PaymentDetail__c> objList = [Select Payment_Method__c, Credit_Card_Type__c, Expiration_Month__c, Expiration_Year__c, Masked_Card_Number__c, Authorization_Code__c, Subscription_Id__c, Settlement_Date__c From E_PaymentDetail__c where CC_cart__c =: cartId];
        for(E_PaymentDetail__c paymentDetail: objList){
            cc_bean_CreditCard newCreditCardBean = new cc_bean_CreditCard();
            newCreditCardBean.cardType = paymentDetail.Credit_Card_Type__c;
            newCreditCardBean.cardNumber = paymentDetail.Masked_Card_Number__c;
            newCreditCardBean.expiryMonth = paymentDetail.Expiration_Month__c ;
            newCreditCardBean.expiryYear = String.valueOf(paymentDetail.Expiration_Year__c) ;
            newCreditCardBean.authCode = paymentDetail.Authorization_Code__c ;
            newCreditCardBean.subscriptionId = paymentDetail.Subscription_Id__c ;
            newCreditCardBean.settlementDate = paymentDetail.Settlement_Date__c;
            retList.add(newCreditCardBean);
        }
        return retList;
    }

}