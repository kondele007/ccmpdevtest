public without sharing class ktp_cc_GR_UtilOrder {

//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
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
            return (this.orderObj!=null && this.orderObj.ccrz__TaxAmount__c != null ? String.valueOf(this.orderObj.ccrz__TaxAmount__c.setScale(2)) :'');
        }
    }
    
    public String orderShipAmount {
        get {
            return (this.orderObj!=null && this.orderObj.ccrz__ShipAmount__c != null ? String.valueOf(this.orderObj.ccrz__ShipAmount__c.setScale(2)) :'');
        }
    }
    
    public String orderSubTotal{
        get{
            return (this.orderObj!=null && this.orderObj.ccrz__SubTotalAmount__c != null ?String.valueOf(this.orderObj.ccrz__SubTotalAmount__c.setScale(2)) :'');
        }
    }
    public String orderTotalAmount{
        get{
            return (this.orderObj!=null && this.orderObj.ccrz__TotalAmount__c != null ?String.valueOf(this.orderObj.ccrz__TotalAmount__c.setScale(2)) :'');
        }
    }
    public Boolean orderOnHold{
        get{
            return (this.orderObj!=null?(this.orderObj.ccrz__OrderStatus__c == ktp_cc_cnst_PickListConstants.ORDERSTATUS_ONHOLD):false);
        }
    }
    //==================================================
    // CONSTRUCTOR
    //==================================================
    public ktp_cc_GR_UtilOrder(){
        this.orderComplete= false;
        printViewEnabled = false;       
    }
    //==================================================
    // INSTANCE VARIABLES
    //==================================================
    private ccrz__E_Order__c orderObj =null;
    private ktp_cc_bean_MockOrder mockOrderBean=null;
    public List<ktp_cc_bean_CreditCard> creditCards;
    public List<ccrz__E_OrderItem__c> orderItems;
    //==================================================
    // HELPER METHODS
    //==================================================
    public ktp_cc_bean_MockOrder getMockOrder() 
    { 
        if(mockOrderBean == null) 
        {
            orderObj = getOrder();
            mockOrderBean = new ktp_cc_bean_MockOrder(orderObj);
            if(orderObj == null)
            {
                //mockOrderBean.billTo = new cc_bean_MockContactAddress();
                //mockOrderBean.billTo.address1='order == null';
            }
            if(mockOrderBean.billTo == null)
            {
                //mockOrderBean.billTo = new cc_bean_MockContactAddress();
                //mockOrderBean.billTo.address1='ktp_cc_bean_MockOrder.billTo == null';
            }
            if(orderObj != null && orderObj.ccrz__OriginatedCart__c != null){
                creditCards = getCreditCardItems(orderObj.ccrz__OriginatedCart__c);
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
        return getOrder().ccrz__E_OrderItems__r.size();
        //return ((List<E_OrderItem__c>)(getOrder().E_OrderItems__r)).size();
    }
    
    public List<ccrz__E_OrderItem__c> getItems() {
        List<ccrz__E_OrderItem__c> items = null;
        if(getOrder() != null) {
            items = [select Name, ccrz__Order__c, ccrz__ProductType__c, ccrz__OrderItemID__c, ccrz__Price__c, ccrz__Quantity__c, AmountPaid__c, ccrz__Category__r.Name, ccrz__AbsoluteDiscount__c,
                             ccrz__RequestDate__c, ccrz__SubAmount__c, ccrz__StoreId__c, ccrz__Product__r.ccrz__ProductId__c, ccrz__Product__r.Name, ccrz__Product__c, ccrz__Product__r.ccrz__SKU__c, ccrz__Coupon__r.ccrz__DiscountType__c,ccrz__UnitOfMeasure__c,
                             ccrz__OrderLineType__c, ccrz__Coupon__c, ccrz__Coupon__r.ccrz__Rule__r.ccrz__Name__c, ccrz__Coupon__r.ccrz__CouponCode__c, 
                             (select ccrz__Quantity__c, ccrz__Price__c, ccrz__SubAmount__c from ccrz__CC_Order_Item_Pricing_Tiers__r order by ccrz__Price__c desc)
                     From ccrz__E_OrderItem__c
                     where ccrz__Order__c = :this.orderId];
        } else {
            items = new List<ccrz__E_OrderItem__c>();
        }       
        return items;
    }
    
    public List<ktp_cc_bean_MockOrderItem> getMockOrderItems()
    {
        List<ktp_cc_bean_MockOrderItem> mockItems = new List<ktp_cc_bean_MockOrderItem> ();
        if(this.orderId != null){
            List<ccrz__E_OrderItem__c> orderItems = [Select ccrz__SubAmount__c, ccrz__StoreId__c, ccrz__Quantity__c, ccrz__Product__r.ccrz__SKU__c, ccrz__Category__r.Name,
                    ccrz__Product__r.ccrz__ProductId__c, ccrz__Product__r.Name, ccrz__Product__c, ccrz__Price__c, ccrz__AbsoluteDiscount__c,
                    Name, ccrz__OrderLineType__c, ccrz__Coupon__c, ccrz__Coupon__r.ccrz__Rule__r.ccrz__Name__c, AmountPaid__c, Transaction_Code__c, Channel__c, Center_Code__c, Balance_Due__c,
                    (select ccrz__Quantity__c, ccrz__Price__c, ccrz__SubAmount__c from ccrz__CC_Order_Item_Pricing_Tiers__r order by ccrz__Price__c desc)
             From ccrz__E_OrderItem__c
             Where ccrz__Order__c=:this.orderId];
             
             for(ccrz__E_OrderItem__c item : orderItems) {
                 mockItems.add(new ktp_cc_bean_MockOrderItem(item));
                if (item.ccrz__OrderLineType__c == 'Coupon') {
                    orderHasCouponLineItem = true;
                }
             }
            
        }
        return mockItems; 
    }
    
    /** Kaplan Phase 1 Begin */
    public ktp_cc_bean_MockOrder retrieveFullOrderData() {
        return retrieveFullOrderData(false);
    }
    
    public ktp_cc_bean_MockOrder retrieveFullOrderData(boolean includeRules) {
        String queryId = this.orderId;
        if (queryId == null)
            queryId = this.encrytpedId;
        if (queryId == null)
            return null;
        ccrz__E_Order__c currOrder = ktp_cc_dao_Order.getOrder(queryId, false);
        if (currOrder == null)
            return null;
        this.orderObj = currOrder;
        ktp_cc_bean_MockOrder orderWrapper = getMockOrder();
        List<ccrz__E_CartItem__c> cartItems = ktp_cc_dao_Cart.getDisplayCartItems(currOrder.ccrz__OriginatedCart__c);
        ktp_cc_GR_api_rules_CartRules displayRulesApi = new ktp_cc_GR_api_rules_CartRules(cartItems, currOrder.ccrz__CurrencyISOCode__c);
        System.debug(LoggingLevel.INFO,'&&Calling constructLineData' + displayRulesApi);
        displayRulesApi.constructLineData();
        if (includeRules)
            orderWrapper.displayRulesApi = displayRulesApi;
        List<ccrz__E_OrderItem__c> orderItems = ktp_cc_dao_Order.getOrderItems(currOrder.Id);
        List<ktp_cc_bean_MockOrderItem> orderLines = new List<ktp_cc_bean_MockOrderItem> ();
        Double totalLineAmountPaid = 0.0;
        Double totalLineAmountPrice = 0.0;
        for (ccrz__E_OrderItem__c orderItem: orderItems) {
            ktp_cc_bean_MockOrderItem orderLineWrapper = new ktp_cc_bean_MockOrderItem(orderItem);
            ktp_cc_GR_rules_bean_CartDataRulesBean rulesBean = displayRulesApi.getDisplayRuleBean(orderItem.ccrz__Product__r.ccrz__SKU__c);
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
                if(rulesBean.productDeliveryType != null){
                    orderLineWrapper.deliveryTypeCode = Integer.valueOf(rulesBean.productDeliveryType);
                    orderLineWrapper.deliveryTypeDesc = rulesBean.displayDeliveryType;
                }
                orderLineWrapper.sbuCode = rulesBean.sbuCode;
                orderLineWrapper.listPrice = rulesBean.availableInstallments.get(0).listPrice;
                orderLineWrapper.discountAmount = rulesBean.availableInstallments.get(0).totalDiscount;
                orderLineWrapper.couponDiscount = rulesBean.availableInstallments.get(0).couponDiscount;
                orderLineWrapper.offeredPrice = rulesBean.availableInstallments.get(0).offeredPrice;
                if (rulesBean.line.ccrz__Product__r.EventType__c != null)
                    orderLineWrapper.eventType = rulesBean.line.ccrz__Product__r.EventType__c;
                else if (rulesBean.line.ccrz__Product__r.ccrz__ParentProduct__c != null)
                    orderLineWrapper.eventType = rulesBean.line.ccrz__Product__r.ccrz__ParentProduct__r.EventType__c;
                if (includeRules) {
                    orderLineWrapper.rulesBean = rulesBean;
                }
            }
            else
                System.debug('Could not retrieve Rules bean for ' + orderItem.ccrz__Product__r.ccrz__SKU__c);
            orderLines.add(orderLineWrapper);
            if (orderItem.ccrz__OrderLineType__c == 'Coupon')
                orderHasCouponLineItem = true;
            totalLineAmountPaid += orderItem.AmountPaid__c != null? orderItem.AmountPaid__c : 0.0;
            totalLineAmountPrice += orderItem.ccrz__Price__c != null? orderItem.ccrz__Price__c : 0.0;
        }
        orderWrapper.totalDueNow = totalLineAmountPaid;
        Double orderSubtotal = double.valueOf((currOrder.SubTotalAmount2__c != null ? currOrder.SubTotalAmount2__c : 0));
        orderWrapper.totalDiscountAmount = (decimal.valueOf(totalLineAmountPrice - orderSubtotal)).divide(1,2,System.RoundingMode.UP);
        System.debug(LoggingLevel.INFO, '$$totalLineAmountPrice=' + totalLineAmountPrice);
        System.debug(LoggingLevel.INFO, '$$totalLineAmountPaid=' + totalLineAmountPaid);
        System.debug(LoggingLevel.INFO, '$$totalDiscountAmount=' + orderWrapper.totalDiscountAmount);
        /*
        System.debug(LoggingLevel.INFO, '$$myCart.Due_Today__c=' + myCart.Due_Today__c);
        System.debug(LoggingLevel.INFO, '$$myCart.second_payment__c=' + myCart.second_payment__c);
        System.debug(LoggingLevel.INFO, '$$myCart.third_payment__c' + myCart.third_payment__c);
        orderWrapper.dueTodayAmount= myCart.Due_Today__c;
        orderWrapper.secondPaymentAmount= myCart.second_payment__c;
        orderWrapper.thirdPaymentAmount= myCart.third_payment__c;
        */
        orderWrapper.orderItems = orderLines;
        return orderWrapper;
    }
    /** Kaplan Phase 1 End */
   
  
    public ccrz__E_Order__c getOrder(){
        if(orderObj == null){
            List<ccrz__E_Order__c> orders = [Select e.shipEstimateGiven__c, e.ccrz__TotalSurcharge__c, e.ccrz__ExtShipTrackNo__c, e.TotalShipDiscount__c, e.ccrz__SubTotalAmount__c, e.ccrz__EncryptedId__c,
                                            e.ccrz__TotalDiscount__c, e.ccrz__TotalAmount__c, e.ccrz__TaxAmount__c, e.ccrz__ShipTo__r.ccrz__Email__c, e.due_today__c, second_payment__c, e.third_payment__c,
                                            e.ccrz__ShipTo__r.ccrz__State__c, e.ccrz__ShipTo__r.ccrz__PostalCode__c, e.ccrz__ShipTo__r.ccrz__Country__c,
                                            e.ccrz__ShipTo__r.ccrz__MiddleName__c, e.ccrz__ShipTo__r.ccrz__StateISOCode__c, e.ccrz__ShipTo__r.ccrz__LastName__c, e.ccrz__ShipTo__r.ccrz__HomePhone__c, 
                                            e.ccrz__ShipTo__r.ccrz__FirstName__c, e.ccrz__ShipTo__r.ccrz__City__c, e.ccrz__ShipTo__r.ccrz__AddressSecondline__c, 
                                            e.ccrz__ShipTo__r.ccrz__AddressFirstline__c, e.ccrz__ShipTo__c, e.ccrz__ShipAmount__c, e.ccrz__PONumber__c, e.ccrz__OrderNumber__c, 
                                            e.ccrz__OrderID__c, e.Name, e.Id, e.ccrz__BillTo__r.ccrz__Email__c, e.ccrz__BillTo__r.ccrz__State__c, 
                                            e.ccrz__BillTo__r.ccrz__StateISOCode__c, e.ccrz__BillTo__r.ccrz__PostalCode__c, e.ccrz__BillTo__r.ccrz__MiddleName__c, 
                                            e.ccrz__BillTo__r.ccrz__LastName__c, e.ccrz__BillTo__r.ccrz__HomePhone__c, e.ccrz__BillTo__r.ccrz__FirstName__c, 
                                            e.ccrz__BillTo__r.ccrz__Country__c, e.ccrz__BillTo__r.ccrz__CountryISOCode__c, e.ccrz__BillTo__r.ccrz__City__c, e.ccrz__BillTo__r.ccrz__AddressSecondline__c, 
                                            e.ccrz__BillTo__r.ccrz__AddressFirstline__c, e.ccrz__BillTo__c, e.ccrz__OriginatedCart__r.ccrz__EncryptedID__c, e.ccrz__BillTo__r.KBSAddressType__c, e.ccrz__ShipTo__r.KBSAddressType__c,ccrz__CurrencyIsoCode__c,
                                            e.ccrz__OrderStatus__c, e.ccrz__ShipMethod__c, e.Owner.Name, e.ccrz__PaymentMethod__c, e.SubTotalAmount2__c, e.ccrz__BuyerEmail__c, ccrz__BuyerFirstName__c, ccrz__BuyerLastName__c, ccrz__BuyerPhone__c, ccrz__BuyerMobilePhone__c, ccrz__BuyerCompanyName__c,
                                             (Select Name, ccrz__Order__c, ccrz__ProductType__c, ccrz__OrderItemID__c, ccrz__Price__c, ccrz__Quantity__c, 
                                                     ccrz__RequestDate__c, ccrz__SubAmount__c, ccrz__StoreId__c, ccrz__Product__r.name,ccrz__Product__r.ccrz__SKU__c, ccrz__Coupon__r.ccrz__DiscountType__c,ccrz__UnitOfMeasure__c  From ccrz__E_OrderItems__r),
                                                     ccrz__OriginatedCart__c
                                    From ccrz__E_Order__c e
                    where e.Id=:this.orderId];
            if(orders.size()==0){
                return null;
            } else {
                orderObj = orders[0];
            }
        }
        return orderObj;


    }
    
    
    public List<ccrz__E_OrderItem__c> getOrderItems(){
        if(orderItems == null){
            orderItems = [select
                Id,
                Name,
                ccrz__ProductType__c,
                ccrz__Coupon__r.ccrz__DiscountType__c,
                DeliveryDate__c,
                ccrz__Order__c,
                ccrz__Price__c,
                ccrz__Product__r.Name,
                ccrz__Quantity__c,
                ccrz__StoreId__c,
                ccrz__SubAmount__c,
                ccrz__UnitOfMeasure__c,
                ccrz__Product__r.ccrz__SKU__c
                
                from ccrz__E_OrderItem__c
                where ccrz__Order__c = :orderID
            ];
        }

        
        return orderItems;
    }   

    
    public List<ktp_cc_bean_CreditCard> getCreditCardItems(Id cartId){
        List<ktp_cc_bean_CreditCard> retList = new List<ktp_cc_bean_CreditCard>();
        List<ccrz__E_PaymentDetail__c> objList = [Select ccrz__Payment_Method__c, ccrz__Credit_Card_Type__c, ccrz__Expiration_Month__c, ccrz__Expiration_Year__c, ccrz__Masked_Card_Number__c, Authorization_Code__c, Subscription_Id__c, Settlement_Date__c From ccrz__E_PaymentDetail__c where ccrz__Cart__c =: cartId];
        for(ccrz__E_PaymentDetail__c paymentDetail: objList){
            ktp_cc_bean_CreditCard newCreditCardBean = new ktp_cc_bean_CreditCard();
            newCreditCardBean.cardType = paymentDetail.ccrz__Credit_Card_Type__c;
            newCreditCardBean.cardNumber = paymentDetail.ccrz__Masked_Card_Number__c;
            newCreditCardBean.expiryMonth = paymentDetail.ccrz__Expiration_Month__c ;
            newCreditCardBean.expiryYear = String.valueOf(paymentDetail.ccrz__Expiration_Year__c) ;
            newCreditCardBean.authCode = paymentDetail.Authorization_Code__c ;
            newCreditCardBean.subscriptionId = paymentDetail.Subscription_Id__c ;
            newCreditCardBean.settlementDate = paymentDetail.Settlement_Date__c;
            retList.add(newCreditCardBean);
        }
        return retList;
    }

}