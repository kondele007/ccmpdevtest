//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public class cc_dao_Cart {
	
	//==================================================
    // STATIC CONSTANTS
    //==================================================
	public static final integer CART_HEADER = 1;
	public static final integer CART_ADDRESSES = 2;
	public static final integer CART_ITEMS = 4;
	
	//==================================================
    // CONSTRUCTOR
    //==================================================
	public cc_dao_Cart () {
		
	}
	
	//==================================================
    // STATIC SERVICE METHODS
    //==================================================
	public static E_Cart__c retrieveCartHeader(String cartId) {
		return cc_dao_Cart.retrieveCart(cartId, cc_dao_Cart.CART_HEADER);
	}
	
	public static E_Cart__c retrieveCartHeaderAddresses(String cartId) {
		return cc_dao_Cart.retrieveCart(cartId,  cc_dao_Cart.CART_ADDRESSES);
	}
	
	public static E_Cart__c retrieveCartHeaderAddressesLineItems(String cartId) {
		return cc_dao_Cart.retrieveCart(cartId, cc_dao_Cart.CART_ITEMS | cc_dao_Cart.CART_ADDRESSES);
	}
	
	public static E_Cart__c retrieveCart(String cartId, integer retrievalFlag) {
		E_Cart__c retCart = null;
		if(!al.StringUtils.isBlank(cartID)) {
	        cartID = String.escapeSingleQuotes(cartID);
			String query = cc_dao_Cart.getCartHeaderQuery();
			
			if((retrievalFlag & CART_ADDRESSES) == CART_ADDRESSES) {
				
				query += ',';
				query += cc_dao_Cart.getCartAddressesQuery();
				//query += ', ' + buildCartPaymentDetailsQuery();
			}
			if((retrievalFlag & CART_ITEMS) == CART_ITEMS)
			{
				query += ',';
				query += cc_dao_Cart.getCartItemsQuery(true);
			}
			query += cc_dao_Cart.getFromWhereClause(cartId, cc_cnst_PickListConstants.CARTTYPE_CART);
			System.debug(query);
			List<E_Cart__c> cartList = Database.query(query);
			if(cartList.size() > 1)
	        {
	           throw new cc_api_Cart.DuplicatedEncryptedCartIdException(cartList[0].EncryptedId__c, 'Duplicated Id');
	        }
	        else if(cartList.size() == 1)
	        {
	           retCart = cartList[0];
	           if(retCart.CartStatus__c == cc_cnst_PickListConstants.CARTSTATUS_CLOSED) {
	           		throw new cc_api_Cart.CartIsClosedException('Cart: '+ cartId +' is Closed');
	           }
	        }
		}
        return retCart;
	}
	
	//==================================================
    // STATIC HELPER METHODS
    //==================================================
	public static boolean isID(String cartId) {
	
		if(cartId instanceof Id)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	
	private static String getCartHeaderQuery() {
		String cartHeaderQuery = 'Select e.Account__c, e.Account__r.TaxExemptAccount__c, e.TaxExemptFlag__c, e.TaxAmount__c, e.TotalQuantity__c, e.ShipAmount__c, e.CartStatus__c, e.CurrencyISOCode__c, e.CustomerTypeCode__c, e.DeliveryDate__c, e.Id, e.ActiveCart__c,'; 
        cartHeaderQuery += 	'e.Name, e.Name__c, e.Note__c, e.OwnerId, e.RequestDate__c, e.SessionID__c, e.SubTotalAmount__c, e.TotalAmount__c, e.Owner.Email,Pay_in_Installments__c, e.Due_Today__c, e.second_payment__c, e.third_payment__c,'; 
        cartHeaderQuery +=	'e.TotalDiscount__c, e.TotalShipDiscount__c, e.User__c, e.EncryptedId__c, e.ShipTo__c, e.BillTo__c, e.SubTotalAmount_2__c,e.AnonymousID__c,e.CartType__c,';
        cartHeaderQuery +=	'e.Contact__c, e.BuyerCompanyName__c, e.BuyerFirstName__c, e.BuyerLastName__c, e.BuyerPhone__c, e.BuyerMobilePhone__c, e.BuyerEmail__c,';
        cartHeaderQuery +=  'e.PaymentMethod__c, e.PONumber__c, e.ShippingMethod__c';
		return cartHeaderQuery;
	}
	
	private static String getCartAddressesQuery() {
		String addresses = 'e.BillTo__r.State__c, e.BillTo__r.PostalCode__c, e.BillTo__r.MiddleName__c,  e.BillTo__r.LastName__c, e.BillTo__r.CompanyName__c,';
		    addresses += 'e.BillTo__r.Id, e.BillTo__r.FirstName__c, e.BillTo__r.City__c, e.BillTo__r.AddressThirdline__c, e.BillTo__r.AddressSecondline__c,'; 
		    addresses += 'e.BillTo__r.AddressFirstline__c,e.BillTo__r.HomePhone__c, e.BillTo__r.DaytimePhone__c, e.BillTo__r.StateISOCode__c, e.BillTo__r.Country__c,';
		    addresses += 'e.BillTo__r.CountryISOCode__c,e.BillTo__r.Email__c, e.BillTo__r.MailStop__c,';
		    addresses += 'e.ShipTo__r.State__c, e.ShipTo__r.PostalCode__c, e.ShipTo__r.MiddleName__c,  e.ShipTo__r.LastName__c, e.ShipTo__r.CompanyName__c,'; 
		    addresses += 'e.ShipTo__r.Id, e.ShipTo__r.FirstName__c, e.ShipTo__r.City__c, e.ShipTo__r.AddressThirdline__c, e.ShipTo__r.AddressSecondline__c,'; 
		    addresses += 'e.ShipTo__r.AddressFirstline__c,e.ShipTo__r.HomePhone__c, e.ShipTo__r.DaytimePhone__c, e.ShipTo__r.StateISOCode__c, e.ShipTo__r.Country__c,';
		    addresses += 'e.ShipTo__r.CountryISOCode__c,e.ShipTo__r.Email__c, e.ShipTo__r.MailStop__c, e.ShipTo__r.ShippingComments__c';
		return addresses;
	}
	
	 /*
     * Constructs the intl sub-select clause for product queries.
     * @return base select statement
     */
    private static String buildCartPaymentDetailsQuery() {
    	return '(Select ' + 
    					'Name, ' +
						'Authorization_Code__c, ' + 
						'Credit_Card_Type__c, ' + 
						'Expiration_Month__c, ' + 
						'Expiration_Year__c, ' + 
						'Masked_Card_Number__c, ' + 
						'Payment_Method__c, ' + 
						'Subscription_Id__c ' + 
					'From ' + 
						'E_PaymentDetails__r' +
					') ';
    }
	
	private static String getLineItemsOrderBy()
	{
		return '';
	}
	private static String getCartItemsQuery(boolean isSubQuery) 
	{
		String query = '{0}Select c.Cart__c, c.Name, c.Product__r.Name, c.cartItemType__c, c.Product__r.ShortDesc__c, c.Product__r.SKU__c, c.Product__r.ProductType__c, c.Product__r.ParentProduct__c,';
			query +=  'c.Quantity__c, c.Price__c, c.SubAmount__c, c.ProductType__c, c.ParentProduct__c, c.ParentCartItem__r.ProductType__c, c.ParentCartItem__c,c.Billing_Installments__c,c.AmountOwed__c,c.Category__c,c.AllowsDiscounts__c, c.UnitOfMeasure__c, c.StoreID__c,c.AbsoluteDiscount__c, c.PercentDiscount__c,';
			query +=  'c.Product__r.ParentProduct__r.SKU__c, c.Product__r.ClassStartDate__c, c.Product__r.ClassEndDate__c, c.Product__r.Country__c, c.Comments__c,  c.Coupon__c, c.Coupon__r.CouponCode__c, c.DeliveryDate__c from {1} c where c.isDeleted = false{2}';
		String param0 = '';
		String param1 = 'E_CartItem__c';
		String param2 = '';
		if(isSubQuery) {
			param0='(';
			param1='E_CartItems__r';
			param2=')';
		}
		return String.format(query, new List<String> {param0, param1, param2} );
	}
	
	private static String getFromWhereClause(String cartId, String cartType)
	{
		String idParam = cc_dao_Cart.isID(cartId) ? 'ID' : 'EncryptedId__c';
		String formatStr = ' from E_Cart__c e where e.' + idParam + ' = \'' + cartId + '\' and e.isDeleted=false and e.CartType__c = \'' + cartType + '\'';
		
		return formatStr;
	}
   
   	public static List<E_Cart__c> getUserCarts(Id userId) {
		List<E_Cart__c> retCarts = new List<E_Cart__c>();
		if(!al.StringUtils.isBlank(userId)) {
	        userId = String.escapeSingleQuotes(userId);
	        String query = cc_dao_Cart.getCartHeaderQuery();
	        query += ' from e_cart__c e where e.User__c = \'' + userId + '\' and e.CartType__c = \'' + cc_cnst_PickListConstants.CARTTYPE_CART + '\'';
	        query += ' and e.IsDeleted = false and e.AnonymousID__c = false and e.CartStatus__c = \'' + cc_cnst_PickListConstants.CARTSTATUS_OPEN + '\'';
	        query += ' order by e.LastModifiedDate desc';
	        retCarts =  Database.query(query);
	   	}
	   	return retCarts;
	} 
	
	public static List<E_Cart__c> getActiveCartOwnedBy(Id userId) {
		List<E_Cart__c> retCarts = new List<E_Cart__c>();
		if(!al.StringUtils.isBlank(userId)) {
	        userId = String.escapeSingleQuotes(userId);
	        String query = cc_dao_Cart.getCartHeaderQuery();
	        query += ' from e_cart__c e where e.ownerid = \'' + userId + '\' and e.CartType__c = \'' + cc_cnst_PickListConstants.CARTTYPE_CART + '\'';
	        query += ' and e.IsDeleted = false and e.ActiveCart__c = true and e.CartStatus__c = \'' + cc_cnst_PickListConstants.CARTSTATUS_OPEN + '\'';
	        query += ' order by e.LastModifiedDate desc';
	        System.debug('getActiveCartOwnedBy-->' + query);
	        retCarts =   Database.query(query); 
	   	}
	   	return retCarts;
	} 
	
	public static List<E_Cart__c> getOpenCartOwnedBy(Id userId) {
		List<E_Cart__c> retCarts = new List<E_Cart__c>();
		if(!al.StringUtils.isBlank(userId)) {
	        userId = String.escapeSingleQuotes(userId);
	        String query = cc_dao_Cart.getCartHeaderQuery();
	        query += ' from e_cart__c e where e.ownerid = \'' + userId + '\' and e.CartType__c = \'' + cc_cnst_PickListConstants.CARTTYPE_CART + '\'';
	        query += ' and e.IsDeleted = false and e.CartStatus__c = \'' + cc_cnst_PickListConstants.CARTSTATUS_OPEN + '\'';
	        query += ' order by e.LastModifiedDate desc';
	        System.debug('getActiveCartOwnedBy-->' + query);
	        retCarts =   Database.query(query); 
	   	}
	   	return retCarts;
	} 
	
	public static List<E_Cart__c> getActiveCartOwnedByUserName(String name) {
		List<E_Cart__c> retCarts = new List<E_Cart__c>();
		if(!al.StringUtils.isBlank(name)) {
	        name = String.escapeSingleQuotes(name);
	        String query = cc_dao_Cart.getCartHeaderQuery();
	        query += ' from e_cart__c e where e.OwnerId in (select id from user where Username = \'' + name + '\') and e.CartType__c = \'' + cc_cnst_PickListConstants.CARTTYPE_CART + '\'';
	        query += ' and e.IsDeleted = false and e.ActiveCart__c = true and e.CartStatus__c = \'' + cc_cnst_PickListConstants.CARTSTATUS_OPEN + '\'';
	        query += ' order by e.LastModifiedDate desc';
	        retCarts =   Database.query(query); 
	   	}
	   	return retCarts;
	} 
	
	public static List<E_Cart__c> getOpenCartOwnedByUserName(String name) {
		List<E_Cart__c> retCarts = new List<E_Cart__c>();
		if(!al.StringUtils.isBlank(name)) {
	        name = String.escapeSingleQuotes(name);
	        String query = cc_dao_Cart.getCartHeaderQuery();
	        query += ' from e_cart__c e where e.OwnerId in (select id from user where Username = \'' + name + '\') and e.CartType__c = \'' + cc_cnst_PickListConstants.CARTTYPE_CART + '\'';
	        query += ' and e.IsDeleted = false and e.CartStatus__c = \'' + cc_cnst_PickListConstants.CARTSTATUS_OPEN + '\'';
	        query += ' order by e.LastModifiedDate desc';
	        retCarts =   Database.query(query); 
	   	}
	   	return retCarts;
	} 
            
	public static E_Cart__c getLastModifiedValidCart(Id userId) {
		E_Cart__c retCart = null;
        for(E_Cart__c cart : cc_dao_Cart.getUserCarts(userId))
        {
            retCart = cart; 
            //only take first one
            break;
        }
        return retCart;
	}
	
	
	public static List<E_CartItem__c> getCartItems(String cartId, Integer max, boolean majorLineOnly) {
		List<E_CartItem__c> cartItems = new List<E_CartItem__c>();
		if(!al.StringUtils.isBlank(cartID)) {
	        cartID = String.escapeSingleQuotes(cartID);
			String cartLineItemQuery = cc_dao_Cart.getCartItemsQuery(false);
			String idParam = cc_dao_Cart.isID(cartId) ? 'ID' : 'EncryptedId__c';
			String whereClause = ' and c.cart__r.' + idParam + ' = \'' + cartId + '\''; 
			cartLineItemQuery += whereClause;
			if(majorLineOnly != null && majorLineOnly == true) {
				cartLineItemQuery += ' and c.cartItemType__c = \'Major\'';
			}
			cartLineItemQuery += cc_dao_Cart.getLineItemsOrderBy();
			if(max > 0)
	        {
	            cartLineItemQuery += ' limit ' + max;
	        }
			cartItems = Database.query(cartLineItemQuery);
		}
		return cartItems;
	}
	
	public static List<E_CartItem__c> getDisplayCartItems(String cartId) {

		if (cartId instanceof Id) {
			return [Select c.Cart__c, c.Name, c.Product__r.Name, c.Product__r.ProductType__c, c.Product__r.ProductStatus__c, c.cartItemType__c, c.ParentCartItem__r.Product__r.ProductType__c,
		            		c.Product__r.ShortDesc__c, c.Product__r.SKU__c, c.Quantity__c, c.Price__c, c.SubAmount__c, ProductType__c, c.DiscountAmount__c, c.PercentDiscount__c, c.AbsoluteDiscount__c,
		            		c.Coupon__c, c.Coupon__r.CouponCode__c, c.Product__r.UnitOfMeasure__c, c.Product__r.StartDate__c, c.Product__r.EndDate__c, c.Product__r.EventType__c, c.Billing_Installments__c, c.Flex_Date__c, Flex_End_Date__c,
		            		c.Shipping_Method__c, c.Shipping_Charge__c, c.AmountOwed__c, c.Product__r.Code__c, c.Product__r.ClassStartDate__c, c.Product__r.ClassEndDate__c, c.Product__r.Country__c,  
		            		c.Product__r.IsLiveOnlineEvent__c, c.Product__r.FacilityId__c,
		            		c.AllowsDiscounts__c, c.Product__r.CenterId__c, c.Product__r.ParentProduct__c, c.Product__r.ParentProduct__r.SKU__c, c.Product__r.ParentProduct__r.Code__c,c.Product__r.ParentProduct__r.EventType__c,  
		            		(Select Cart__c, Name, Product__r.Name, cartItemType__c, Product__r.ProductType__c, Product__r.ProductStatus__c, Product__r.ShortDesc__c, Product__r.SKU__c, Product__r.StartDate__c, 
		            		Product__r.EndDate__c, Quantity__c, Price__c, SubAmount__c, ProductType__c, DiscountAmount__c, PercentDiscount__c, AbsoluteDiscount__c, Coupon__c, 
		            		ParentCartItem__r.Product__r.ProductType__c,Product__r.UnitOfMeasure__c, Billing_Installments__c, Flex_Date__c, Flex_End_Date__c, Shipping_Method__c, Shipping_Charge__c, Product__r.Code__c, 
		            		Product__r.ClassStartDate__c, Product__r.ClassEndDate__c, Product__r.Country__c, Product__r.CenterId__c, Product__r.EventType__c, Product__r.ParentProduct__c, 
		            		Product__r.IsLiveOnlineEvent__c, Product__r.FacilityId__c, AllowsDiscounts__c,
		            		Product__r.ParentProduct__r.SKU__c, Product__r.ParentProduct__r.Code__c, Product__r.ParentProduct__r.EventType__c From Cart_Items__r ),
		            		(select Quantity__c, Price__c, SubAmount__c from Cart_Item_Pricing_Tiers__r order by Price__c desc) 
		            		from E_CartItem__c c where c.isDeleted = false and c.cartitemtype__c in ('Major','Coupon') and c.Cart__r.Id =:cartId];
		}
		else {
			return [Select c.Cart__c, c.Name, c.Product__r.Name, c.Product__r.ProductType__c, c.Product__r.ProductStatus__c, c.cartItemType__c, c.ParentCartItem__r.Product__r.ProductType__c,
		            		c.Product__r.ShortDesc__c, c.Product__r.SKU__c, c.Quantity__c, c.Price__c, c.SubAmount__c, ProductType__c, c.DiscountAmount__c, c.PercentDiscount__c, c.AbsoluteDiscount__c,
		            		c.Coupon__c, c.Coupon__r.CouponCode__c, c.Product__r.UnitOfMeasure__c, c.Product__r.StartDate__c, c.Product__r.EndDate__c, c.Product__r.EventType__c, c.Billing_Installments__c, c.Flex_Date__c, Flex_End_Date__c,
		            		c.Shipping_Method__c, c.Shipping_Charge__c, c.AmountOwed__c, c.Product__r.Code__c, c.Product__r.ClassStartDate__c, c.Product__r.ClassEndDate__c, c.Product__r.Country__c,  
		            		c.Product__r.CenterId__c, c.Product__r.IsLiveOnlineEvent__c, c.Product__r.FacilityId__c,
		            		c.AllowsDiscounts__c,c.Product__r.ParentProduct__c, c.Product__r.ParentProduct__r.SKU__c, c.Product__r.ParentProduct__r.Code__c, c.Product__r.ParentProduct__r.EventType__c,(Select Cart__c, Name, Product__r.Name, cartItemType__c, Product__r.ProductType__c, Product__r.ProductStatus__c,
		            		Product__r.ShortDesc__c, Product__r.SKU__c, Product__r.StartDate__c, Product__r.EndDate__c, Quantity__c, Price__c, SubAmount__c, ProductType__c, DiscountAmount__c, 
		            		PercentDiscount__c, AbsoluteDiscount__c, Coupon__c, ParentCartItem__r.Product__r.ProductType__c,Product__r.UnitOfMeasure__c, Billing_Installments__c, Flex_Date__c, Flex_End_Date__c,
		            		Shipping_Method__c, Shipping_Charge__c, Product__r.Code__c, Product__r.ClassStartDate__c, Product__r.ClassEndDate__c, Product__r.Country__c, Product__r.CenterId__c, 
		            		Product__r.EventType__c, Product__r.IsLiveOnlineEvent__c, Product__r.FacilityId__c, AllowsDiscounts__c,
		            		Product__r.ParentProduct__c, Product__r.ParentProduct__r.SKU__c, Product__r.ParentProduct__r.Code__c, Product__r.ParentProduct__r.EventType__c From Cart_Items__r ),
		            		(select Quantity__c, Price__c, SubAmount__c from Cart_Item_Pricing_Tiers__r order by Price__c desc) 
                            from E_CartItem__c c where c.Cart__r.Id != null and c.isDeleted = false and c.cartitemtype__c in ('Major','Coupon') and c.Cart__r.EncryptedID__c =:cartId];

		}
	}
	public static List<E_CartItem__c> getMajorCartItems(String cartId, Integer max) {
		return cc_dao_Cart.getCartItems(cartId, max, true);
	}
	
	public static List<E_CartItem__c> getCartItems(String cartId, Integer max) {
		return cc_dao_Cart.getCartItems(cartId, max, false);
	}
	
	public static Integer countOfProduct(String cartId, String prodId) {
		System.debug(LoggingLevel.INFO, 'JLL count of prod 0 ' + cartId + ' ' + prodId);
		if (prodId instanceof Id){
			if(cartId instanceof Id){
				System.debug(LoggingLevel.INFO, 'JLL count of prod 1');
				return [ Select Count() From E_CartItem__c ci Where ci.Product__c = :prodID and ci.Cart__c = :cartID and ci.IsDeleted = false ];
			}
			else{
				System.debug(LoggingLevel.INFO, 'JLL count of prod 2');
				return [ Select Count() From E_CartItem__c ci Where ci.Product__c = :prodID and ci.Cart__r.EncryptedId__c = :cartID and ci.IsDeleted = false ];
			}
		}
		else{
			if(cartId instanceof Id){
				System.debug(LoggingLevel.INFO, 'JLL count of prod 3');
				return [ Select Count() From E_CartItem__c ci Where ci.Product__r.SKU__c = :prodId and ci.Cart__c = :cartID and ci.IsDeleted = false ];
			}
			else{
				System.debug(LoggingLevel.INFO, 'JLL count of prod 4');
				return [ Select Count() From E_CartItem__c ci Where ci.Product__r.SKU__c = :prodId and ci.Cart__r.EncryptedId__c = :cartID and ci.IsDeleted = false ];
			}
		}
	}
	
	public static List<E_CartItem__c> getEvents(String cartId) {
		if (cartId instanceof Id)
			return [ Select Id, Price__c, Product__r.EventType__c, Product__r.ParentProduct__r.EventType__c From E_CartItem__c Where Cart__c = :cartID and IsDeleted = false ];
		else
	        return [ Select Id, Price__c, Product__r.EventType__c, Product__r.ParentProduct__r.EventType__c From E_CartItem__c Where Cart__r.Id != null and Cart__r.EncryptedId__c = :cartID and IsDeleted = false ];

	}
	
}