//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public class ktp_cc_dao_Cart {
    
    //==================================================
    // STATIC CONSTANTS
    //==================================================
    public static final integer CART_HEADER = 1;
    public static final integer CART_ADDRESSES = 2;
    public static final integer CART_ITEMS = 4;
    
    //==================================================
    // CONSTRUCTOR
    //==================================================
    public ktp_cc_dao_Cart () {
        
    }
    
     
	public static List<ccrz__E_CartItem__c> getDisplayCartItems(String cartId) {
		return [SELECT c.ccrz__Cart__c, c.ccrz__Cart__r.ccrz__Storefront__c, c.Name, c.ccrz__Product__r.Name, c.ccrz__Product__r.ccrz__ProductType__c, c.ccrz__Product__r.ccrz__ProductStatus__c,
					c.ccrz__cartItemType__c, c.ccrz__ParentCartItem__r.ccrz__Product__r.ccrz__ProductType__c,
					c.ccrz__Product__r.ccrz__ShortDesc__c, c.ccrz__Product__r.ccrz__SKU__c, c.ccrz__Quantity__c, c.ccrz__Price__c, c.ccrz__SubAmount__c, ccrz__ProductType__c, c.ccrz__ItemLabel__c,
					c.ccrz__AdjustmentAmount__c, c.ccrz__ItemTotal__c, c.ccrz__Comments__c,
					c.ccrz__PercentDiscount__c, c.ccrz__AbsoluteDiscount__c, c.Allows_Discounts__c, c.Amount_Owed__c, c.Billing_Installments__c, c.Flex_Date__c, c.Flex_End_Date__c, c.Shipping_Charge__c, c.Shipping_Method__c, 
					c.ccrz__Coupon__c, c.ccrz__Product__r.ccrz__UnitOfMeasure__c, c.ccrz__Product__r.ccrz__StartDate__c, c.ccrz__Product__r.ccrz__EndDate__c, c.ccrz__ItemStatus__c,
					c.ccrz__DisplayProduct__c, c.ccrz__DisplayProduct__r.ccrz__Sku__c, c.ccrz__DisplayProduct__r.Name,
					(SELECT ccrz__Cart__c, Name, ccrz__Product__r.Name, ccrz__cartItemType__c, ccrz__Product__r.ccrz__ProductType__c, ccrz__Product__r.ccrz__ProductStatus__c,
						ccrz__Product__r.ccrz__ShortDesc__c, ccrz__Product__r.ccrz__SKU__c, ccrz__Product__r.ccrz__StartDate__c, ccrz__Product__r.ccrz__EndDate__c, ccrz__Quantity__c,
						ccrz__Price__c, ccrz__SubAmount__c, ccrz__ProductType__c, ccrz__ItemLabel__c,
						ccrz__AdjustmentAmount__c, ccrz__ItemTotal__c, ccrz__Comments__c, ccrz__PercentDiscount__c, Allows_Discounts__c, Amount_Owed__c, Billing_Installments__c, Flex_Date__c, Flex_End_Date__c, Shipping_Charge__c, 
						Shipping_Method__c, ccrz__AbsoluteDiscount__c, 
						ccrz__Coupon__c, ccrz__ParentCartItem__r.ccrz__Product__r.ccrz__ProductType__c,ccrz__Product__r.ccrz__UnitOfMeasure__c,
						ccrz__DisplayProduct__c, ccrz__DisplayProduct__r.ccrz__Sku__c, ccrz__DisplayProduct__r.Name, ccrz__ItemStatus__c
					FROM ccrz__Cart_Items__r),
					(SELECT ccrz__Quantity__c, ccrz__Price__c, ccrz__SubAmount__c FROM ccrz__Cart_Item_Pricing_Tiers__r ORDER BY ccrz__Price__c DESC)
				FROM ccrz__E_CartItem__c c
				WHERE c.isDeleted = false
					AND c.ccrz__cartitemtype__c IN ('Major','Coupon')
					AND c.ccrz__Cart__r.ccrz__EncryptedID__c = :cartId
				ORDER BY
					c.Name
				];
	}  
	/**
	 *
	 * description
	 *
	 * @param: userId
	 * @param: storefront
	 * @return return_type
	 */
   	public static List<ccrz__E_Cart__c> getUserCarts(Id userId, string storefront) {
   		return getUserCarts(userId, storefront, new List<String> {cc_cnst_PickListConstants.CARTSTATUS_OPEN} , new List<String> {cc_cnst_PickListConstants.CARTTYPE_CART}, new List<String> {'LastModifiedDate desc'}, false, false, false);
	}

    
	/**
	 *
	 * description
	 *
	 * @param: userId
	 * @param: storefront
	 * @return return_type
	 */
	public static List<ccrz__E_Cart__c> getActiveCartOwnedBy(Id userId, string storefront) {
		return getUserCarts(userId, storefront, new List<String> {cc_cnst_PickListConstants.CARTSTATUS_OPEN} , new List<String> {cc_cnst_PickListConstants.CARTTYPE_CART}, new List<String> {'LastModifiedDate desc'}, true, true, false);
	}

	/**
	 *
	 * description
	 *
	 * @param: userId        the id of the user
	 * @param: storefront    the storefront
	 * @param: cartStatus    the cart status
	 * @param: cartTypes     the cart types
	 * @param: orderBys      order by criteria
	 * @param: isActive      cart active status
	 * @param: isOwnedBy
	 * @param: byUserName    description
	 * @return return_type
	 */
	public static List<ccrz__E_Cart__c> getUserCarts(string userId, string storefront, list<string> cartStatus, list<string> cartTypes, list<string> orderBys, boolean isActive, boolean isOwnedBy, boolean byUserName) {
		List<ccrz__E_Cart__c> retCarts = new List<ccrz__E_Cart__c>();

		if (String.isNotBlank(userId) && String.isNotBlank(storefront)) {

			userId       = String.escapeSingleQuotes(userId);
			String query = getCartHeaderQuery();

			query += ',';
			query += getCartAddressesQuery();
			query += ' from ccrz__e_cart__c e where ' + formatUserCriteria(userId, isOwnedBy, byUserName);

			if (cartTypes != null && cartTypes.size() > 0) {
				String cTypes = '(';

				for (string s: cartTypes) {
					cTypes += '\'' + s + '\',';
				}

				cTypes = cTypes.removeEnd(',');
				cTypes += ')';

				query += ' and ccrz__CartType__c in ' + cTypes;
			}

			if (cartStatus != null && cartStatus.size() > 0) {
				String cStatus = '(';

				for (string s: cartStatus) {
					cStatus += '\'' + s + '\',';
				}

				cStatus = cStatus.removeEnd(',');
				cStatus += ')';

				query += ' and ccrz__CartStatus__c in ' + cStatus ;
			}

			query += ' and IsDeleted = false and ccrz__AnonymousID__c = false';

			storefront = string.escapeSingleQuotes(storefront);

			query += ' and ccrz__storefront__c = \''+ storefront + '\'';

			if (isActive) {
				query += ' and ccrz__ActiveCart__c = true ';
			}

			if (orderBys != null && orderBys.size() > 0) {
				query += ' order by ';

				for (string s : orderBys) {
					query += s + ',';
				}

				query = query.removeEnd(',');
			}

			query += '  LIMIT 1000';

			System.debug(logginglevel.info, '@@@-> query =' + query);

			retCarts =  Database.query(query);
	   	}
	   	return retCarts;
	}
	
	/**
	 *
	 * description
	 *
	 * @param: userId
	 * @param: isOwnedBy
	 * @param: byUserName
	 * @return return_type
	 */
	public static string formatUserCriteria(string userId, boolean isOwnedBy, boolean byUserName) {
		String q = '';

		if (isOwnedBy) {
			q += ' ownerid ';
		} else {
			q += ' ccrz__User__c ';
		}

		if (byUserName) {
			q += ' in (select id from user where Username = \'' + userId + '\')';
		} else {
			q += ' =\'' + userId + '\'';
		}

		q += ' ';

		return q;
	}	
	/**
	 *
	 * description
	 *
	 * @param: none
	 * @return return_type
	 */
	private static String getCartHeaderQuery() {
		String cartHeaderQuery = 'Select e.ccrz__Account__c, e.ccrz__Account__r.ccrz__TaxExemptAccount__c, e.ccrz__TaxExemptFlag__c, e.ccrz__TaxAmount__c, e.ccrz__ShipAmount__c, e.ccrz__CartStatus__c, e.ccrz__CurrencyISOCode__c, e.Id, e.ccrz__ActiveCart__c,';
		cartHeaderQuery       += 'e.Name, e.ccrz__Name__c, e.ccrz__Note__c, e.OwnerId, e.ccrz__RequestDate__c, e.ccrz__SessionID__c, e.ccrz__CartType__c, e.ccrz__TotalAmount__c, e.ccrz__TotalSurcharge__c, e.Owner.Email, e.ccrz__storefront__c,';
		cartHeaderQuery       += 'e.ccrz__TotalDiscount__c, e.ccrz__ShipDiscountAmount__c, e.ccrz__ShipComplete__c, e.ccrz__User__c, e.ccrz__EncryptedId__c, e.ccrz__ShipTo__c, e.ccrz__BillTo__c, e.ccrz__SubTotalAmount__c,e.ccrz__AnonymousID__c,';
		cartHeaderQuery       += 'e.ccrz__Contact__c, e.ccrz__BuyerCompanyName__c, e.ccrz__BuyerFirstName__c, e.ccrz__BuyerLastName__c, e.ccrz__BuyerPhone__c, e.ccrz__BuyerMobilePhone__c, e.ccrz__BuyerEmail__c, e.ccrz__CCEmailAddress__c, ';
		cartHeaderQuery       += 'e.ccrz__PaymentMethod__c, e.ccrz__PONumber__c, e.ccrz__ShipMethod__c,e.ccrz__ContractId__c,e.LastModifiedDate, e.ccrz__AdjustmentAmount__c, e.ccrz__ValidationStatus__c ';

		return cartHeaderQuery;
	}

	/**
	 *
	 * description
	 *
	 * @param: none
	 * @return return_type
	 */
	private static String getCartAddressesQuery() {
		String addresses = 'e.ccrz__BillTo__r.ccrz__State__c, e.ccrz__BillTo__r.ccrz__PostalCode__c, e.ccrz__BillTo__r.ccrz__MiddleName__c,  e.ccrz__BillTo__r.ccrz__LastName__c, e.ccrz__BillTo__r.ccrz__CompanyName__c,';
		addresses       += 'e.ccrz__BillTo__r.Id, e.ccrz__BillTo__r.ccrz__FirstName__c, e.ccrz__BillTo__r.ccrz__City__c, e.ccrz__BillTo__r.ccrz__AddressThirdline__c, e.ccrz__BillTo__r.ccrz__AddressSecondline__c,';
		addresses       += 'e.ccrz__BillTo__r.ccrz__AddressFirstline__c,e.ccrz__BillTo__r.ccrz__HomePhone__c, e.ccrz__BillTo__r.ccrz__DaytimePhone__c, e.ccrz__BillTo__r.ccrz__StateISOCode__c, e.ccrz__BillTo__r.ccrz__Country__c,';
		addresses       += 'e.ccrz__BillTo__r.ccrz__CountryISOCode__c,e.ccrz__BillTo__r.ccrz__Email__c, e.ccrz__BillTo__r.ccrz__MailStop__c, e.ccrz__BillTo__r.ccrz__Partner_Id__c, e.ccrz__BillTo__r.ccrz__ShippingComments__c,';
		addresses       += 'e.ccrz__ShipTo__r.ccrz__State__c, e.ccrz__ShipTo__r.ccrz__PostalCode__c, e.ccrz__ShipTo__r.ccrz__MiddleName__c,  e.ccrz__ShipTo__r.ccrz__LastName__c, e.ccrz__ShipTo__r.ccrz__CompanyName__c,';
		addresses       += 'e.ccrz__ShipTo__r.Id, e.ccrz__ShipTo__r.ccrz__FirstName__c, e.ccrz__ShipTo__r.ccrz__City__c, e.ccrz__ShipTo__r.ccrz__AddressThirdline__c, e.ccrz__ShipTo__r.ccrz__AddressSecondline__c,';
		addresses       += 'e.ccrz__ShipTo__r.ccrz__AddressFirstline__c,e.ccrz__ShipTo__r.ccrz__HomePhone__c, e.ccrz__ShipTo__r.ccrz__DaytimePhone__c, e.ccrz__ShipTo__r.ccrz__StateISOCode__c, e.ccrz__ShipTo__r.ccrz__Country__c,';
		addresses       += 'e.ccrz__ShipTo__r.ccrz__CountryISOCode__c,e.ccrz__ShipTo__r.ccrz__Email__c, e.ccrz__ShipTo__r.ccrz__MailStop__c, e.ccrz__ShipTo__r.ccrz__ShippingComments__c, e.ccrz__ShipTo__r.ccrz__Partner_Id__c';

		return addresses;
	}


    
}