//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class ktp_cc_dao_Order {

	/**
	 * Retrieves the order corresponding to the passed in id.  If the passed in Id is of
	 * type Id, then this is the sf id, and query appropriately.  Otherwise, this is the 
	 * encrypted order id and query using that field instead. 
	 * @param orderId
	 * @return Order
	 */
	public static ccrz__E_Order__c getOrder(String orderId, boolean retrieveItems) {
		if(string.isNotBlank(orderId)) {
			orderId = string.escapeSingleQuotes(orderId);
		}
		List<ccrz__E_Order__c> orderList = new List<ccrz__E_Order__c>();
		String query = buildOrderSelectQuery();
		if (retrieveItems)
			query += buildOrderItemsQuery(true, null);

		query += 'From ccrz__E_Order__c '	;
		if (orderId instanceof Id)
			query += 'Where Id = :orderId';
		else
			query += 'Where ccrz__EncryptedId__c = :orderId';
		
		orderList = Database.query(query);
		if (orderList.size() > 0)
        	return orderList[0];
        else
        	return null;
	}
	
	
	/**
	 * Retrieves the order items corresponding to the passed in id.  If the passed in Id is of
	 * type Id, then this is the sf id, and query appropriately.  Otherwise, this is the 
	 * encrypted order id and query using that field instead. 
	 * @param orderId
	 * @return Order
	 */
	public static List<ccrz__E_OrderItem__c> getOrderItems(String orderId) {
		String query = buildOrderItemsQuery(false, orderId);
		List<ccrz__E_OrderItem__c> orderItemList = Database.query(query);
		return orderItemList;
	}
	
	/**
	 * Constructs the select clause for the order query.
	 * @return select portion of the query
	 */
	public static String buildOrderSelectQuery() {
		String query = 
			'Select ' +
				'Id, ' +
				'Name, ' +
				'ccrz__OrderID__c, ' +
				'ccrz__EncryptedId__c, ' +
				'ccrz__OrderNumber__c, ' +
				'ccrz__OrderDate__c, ' +
				'ccrz__PONumber__c, ' +
				'ccrz__OriginatedCart__c, ' +
				'ccrz__OriginatedCart__r.ccrz__EncryptedID__c, ' +
				'ccrz__CurrencyISOCode__c, ' +
				'ccrz__OrderStatus__c, ' +
				'Owner.Name, ' +
				'ccrz__BuyerEmail__c, ' +
				'ccrz__BuyerFirstName__c, ' +
				'ccrz__BuyerLastName__c, ' +
				'ccrz__BuyerPhone__c, ' +
				'ccrz__BuyerMobilePhone__c, ' +
				'ccrz__BuyerCompanyName__c, ' +
				'ccrz__AdjustmentAmount__c, ' +
				'ccrz__TotalSurcharge__c, ' +
				'ccrz__ShipDiscountAmount__c, ' +
				'ccrz__ShipAmount__c, ' +
				'ccrz__SubTotalAmount__c, ' +
				'ccrz__TotalDiscount__c, ' +
				'ccrz__TaxAmount__c, ' +
				'ccrz__TotalAmount__c, ' +
				'ccrz__PaymentMethod__c, ' +
				'ccrz__ExtShipTrackNo__c, ' +
				'ccrz__ShipMethod__c, ' +
				'ccrz__ShipComplete__c, ' +
				'ccrz__RequestDate__c, ' +
				'Amount_Charged__c, ' +
				'Channel_hidden__c, ' +
				'CustomerTypeCode__c, ' +
				'DeliveryDate__c, ' +
				'due_today__c, ' +
				'second_payment__c, ' +
				'SubTotalAmount2__c, ' +
				'third_payment__c, ' +
			//	'Total_Ship_Discount__c, ' +
				'UpfrontCost__c, ' +
				'Coupon__c, ' +
				'Coupon__r.ccrz__DiscountType__c, ' +
				'Coupon__r.ccrz__Rule__r.ccrz__Name__c, ' +
				'Coupon__r.ccrz__CouponCode__c, ' +
				'ccrz__ShipTo__c, ' +
				'ccrz__ShipTo__r.ccrz__FirstName__c, ' +
				'ccrz__ShipTo__r.ccrz__MiddleName__c, ' +
				'ccrz__ShipTo__r.ccrz__LastName__c, ' +
				'ccrz__ShipTo__r.ccrz__Email__c, ' +
				'ccrz__ShipTo__r.ccrz__HomePhone__c, ' +
				'ccrz__ShipTo__r.ccrz__DaytimePhone__c, ' +
				'ccrz__ShipTo__r.ccrz__CompanyName__c, ' +
				'ccrz__ShipTo__r.ccrz__MailStop__c, ' +
				'ccrz__ShipTo__r.ccrz__AddressFirstline__c, ' +
				'ccrz__ShipTo__r.ccrz__AddressSecondline__c, ' +
				'ccrz__ShipTo__r.ccrz__AddressThirdline__c, ' +
				'ccrz__ShipTo__r.ccrz__City__c, ' +
				'ccrz__ShipTo__r.ccrz__State__c, ' +
				'ccrz__ShipTo__r.ccrz__StateISOCode__c, ' +
				'ccrz__ShipTo__r.ccrz__PostalCode__c, ' +
				'ccrz__ShipTo__r.ccrz__Country__c, ' +
				'ccrz__ShipTo__r.ccrz__CountryISOCode__c, ' +
				'ccrz__ShipTo__r.ccrz__ShippingComments__c, ' +
				'ccrz__BillTo__c, ' +
				'ccrz__BillTo__r.ccrz__FirstName__c, ' +
				'ccrz__BillTo__r.ccrz__MiddleName__c, ' +
				'ccrz__BillTo__r.ccrz__LastName__c, ' +
				'ccrz__BillTo__r.ccrz__Email__c, ' +
				'ccrz__BillTo__r.ccrz__HomePhone__c, ' +
				'ccrz__BillTo__r.ccrz__DaytimePhone__c, ' +
				'ccrz__BillTo__r.ccrz__MailStop__c, ' +
				'ccrz__BillTo__r.ccrz__AddressFirstline__c, ' +
				'ccrz__BillTo__r.ccrz__AddressSecondline__c, ' +
				'ccrz__BillTo__r.ccrz__AddressThirdline__c, ' +
				'ccrz__BillTo__r.ccrz__City__c, ' +
				'ccrz__BillTo__r.ccrz__State__c, ' +
				'ccrz__BillTo__r.ccrz__StateISOCode__c, ' +
				'ccrz__BillTo__r.ccrz__PostalCode__c, ' +
				'ccrz__BillTo__r.ccrz__Country__c, ' +
				'ccrz__BillTo__r.ccrz__CountryISOCode__c ';
		return query;
	}
	
	/**
	 * Constructs the select clause for the order item query.
	 * @param boolean if this is called as a subquery
	 * @return order item query
	 */
	public static String buildOrderItemsQuery(boolean subquery, String orderId) {
		if(string.isNotBlank(orderId)) {
			orderId = string.escapeSingleQuotes(orderId);
		}
		String query = '';
		if (subquery)
			query += ', (';
		query += 
			'Select ' +
				'oi.Name, ' +
				'oi.ccrz__Order__c, ' +
				'oi.ccrz__OrderItemId__c, ' +
				'oi.ccrz__ProductType__c, ' +
				'oi.ccrz__Price__c, ' +
				'oi.ccrz__Quantity__c, ' +
                'oi.ccrz__RequestDate__c, ' +
                'oi.ccrz__SubAmount__c, ' +
                'oi.ccrz__AdjustmentAmount__c, ' +
                'oi.ccrz__ItemTotal__c, ' +
                'oi.ccrz__StoreId__c, ' +
                'oi.ccrz__Product__r.Name, ' +
                'oi.ccrz__Product__r.ccrz__SKU__c, ' +
                'oi.ccrz__Product__r.ccrz__UnitOfMeasure__c, ' +
                'oi.ccrz__Product__r.ccrz__ProductType__c, ' +
                'oi.ccrz__Coupon__r.ccrz__DiscountType__c, ' +
                'oi.ccrz__UnitOfMeasure__c,  ' +
				'oi.ccrz__Category__r.Name, ' +
                'oi.ccrz__AbsoluteDiscount__c, ' +
                'oi.ccrz__Product__r.ccrz__ProductId__c, ' +
                'oi.ccrz__Product__c, ' +
                'oi.ccrz__OrderLineType__c, ' +
                'oi.ccrz__Coupon__c, ' +
                'oi.ccrz__Coupon__r.ccrz__Rule__r.ccrz__Name__c, ' +
                'oi.ccrz__ItemLabel__c, ' +
                'oi.ccrz__Comments__c, ' +
                'oi.ccrz__OrderItemStatus__c, ' +
                'oi.transaction_code__c, ' +
                'oi.channel__c, ' +
                'oi.center_code__c, ' +
                'oi.balance_due__c, ' +
                'oi.amountpaid__c, ' +
                'ccrz__AvailabilityMessage__c, ' +
				'oi.ccrz__Coupon__r.ccrz__CouponCode__c, ' +
				'oi.ccrz__DisplayProduct__c, ' +
				'oi.ccrz__DisplayProduct__r.ccrz__Sku__c, ' +
				'oi.ccrz__DisplayProduct__r.Name ';
		if (!subquery) {
			query += ', (Select ccrz__Quantity__c, ccrz__Price__c, ccrz__SubAmount__c From ccrz__CC_Order_Item_Pricing_Tiers__r order by ccrz__Price__c desc) ';
			query += ', (Select Name, ccrz__Order__c, ccrz__OrderItemId__c,ccrz__ProductType__c,ccrz__Price__c, ccrz__Quantity__c, ccrz__SubAmount__c, ccrz__AdjustmentAmount__c, ccrz__ItemTotal__c, ccrz__Product__r.Name, ccrz__Product__r.ccrz__UnitOfMeasure__c, ccrz__Product__r.ccrz__ProductType__c, ' +
						'ccrz__Product__r.ccrz__SKU__c, ccrz__Coupon__r.ccrz__DiscountType__c, ccrz__UnitOfMeasure__c, ccrz__AbsoluteDiscount__c, ccrz__Coupon__r.ccrz__Rule__r.ccrz__Name__c, ccrz__OrderLineType__c, ccrz__ItemLabel__c, ccrz__Comments__c, ccrz__OrderItemStatus__c,  ' +
						'ccrz__DisplayProduct__c, ccrz__DisplayProduct__r.ccrz__Sku__c, ccrz__DisplayProduct__r.Name ' +
						'From ccrz__Order_Items__r) ';
			query += 'From ccrz__E_OrderItem__c oi Where oi.ccrz__Order__c = :orderId and oi.ccrz__OrderLineType__c in (\'Major\',\'Coupon\')';
		}
		else
			query += 'From ccrz__E_OrderItems__r oi ';
		if (subquery)
			query += ') ';
		return query;
	}
	
	
}