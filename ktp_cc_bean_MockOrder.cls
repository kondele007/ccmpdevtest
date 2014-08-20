public with sharing class ktp_cc_bean_MockOrder {
	public ktp_cc_bean_MockOrder(ccrz__E_Order__c order)
		{
			System.debug(LoggingLevel.INFO, '$$order=' + order);
			dataObject = order;
			if(order != null)
			{
				if(order.ccrz__BillTo__r != null)
				{
					billTo = new ktp_cc_bean_MockContactAddress(order.ccrz__BillTo__r);
				}
				if(order.ccrz__ShipTo__r != null)
				{
					shipTo = new ktp_cc_bean_MockContactAddress(order.ccrz__ShipTo__r);
				}
				paymentMethod = order.ccrz__PaymentMethod__c;
				poNumber = order.ccrz__PONumber__c;
				shippingMethod = order.ccrz__ShipMethod__c;
				shipAmount = order.ccrz__ShipAmount__c;
				subTotalAmount = order.ccrz__SubTotalAmount__c;
				subTotalAmount2 = order.SubTotalAmount2__c;
				shipEstimateGiven = null; //order.ccrz__shipEstimateGiven__c;
				name=order.Name;
				orderNumber = order.ccrz__OrderNumber__c;
				orderNumberAsString = order.Name;
				sfid = order.Id;
				taxAmount = order.ccrz__TaxAmount__c;
				totalAmount = order.ccrz__TotalAmount__c;
				buyerEmail = order.ccrz__BuyerEmail__c;
				buyerFirstName = order.ccrz__BuyerFirstName__c;
				buyerLastName = order.ccrz__BuyerLastName__c;
				buyerPhone = order.ccrz__BuyerPhone__c;
				buyerMobilePhone = order.ccrz__BuyerMobilePhone__c;
				buyerCompanyName = order.ccrz__BuyerCompanyName__c;
				currencyCode = order.ccrz__CurrencyISOCode__c;
				System.debug(LoggingLevel.INFO, '$$dueTodayAmount=' + order.due_today__c);
				dueTodayAmount = order.due_today__c;
				if(shipAmount != null && dueTodayAmount != null){
					dueTodayAmount= dueTodayAmount+shipAmount;
				}
				secondPaymentAmount = order.second_payment__c;
				thirdPaymentAmount = order.third_payment__c;
			}
		}
		public ktp_cc_bean_MockOrder(ktp_cc_bean_MyOrderItem order)
		{
			if(order != null)
			{
				this.orderDate = order.order.ccrz__OrderDate__c;
				this.encryptedId = order.order.ccrz__EncryptedId__c;
				this.status = order.order.ccrz__OrderStatus__c;
				this.name = order.order.name;
				this.subTotalAmount = order.order.Sub_Total_Amount__c; 
				this.totalAmount = order.order.ccrz__TotalAmount__c;
				this.shippingMethod = order.order.ccrz__ShipMethod__c;
				this.paymentMethod = order.order.ccrz__PaymentMethod__c;
			}
		}
		//==================================================
	    // INSTANCE PROPERTIES
	    //==================================================
	    /* Kaplan */
	    public ktp_cc_bean_CreditCard creditCard{get; set;}
	    public List<ktp_cc_bean_MockOrderItem> orderItems { get; set; }
	    public ccrz__E_Order__c dataObject {get; set;}
	    public ktp_cc_GR_api_rules_CartRules displayRulesApi { get; set; }
	    public Double totalDueNow { get; set; }
	    public String currencyCode { get; set; }
	    /* Kaplan */
		public ktp_cc_bean_MockContactAddress billTo { get; set;}
		public ktp_cc_bean_MockContactAddress shipTo { get; set;} 
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