@isTest
public without sharing class cc_kap_test_GetRealMessage {
	
	static testMethod void buildGetRealOrderPlaceMessage(){
		Test.startTest();
		KapGetRealPersonVO person = populateKaplanValueObject();
		KapGetRealUtil.createCloudCrazeOrderPlaceMessage(person);
		Test.stopTest();
	}
	private static KapGetRealPersonVO populateKaplanValueObject(){
		KapGetRealPersonVO personVO = new KapGetRealPersonVO();
		personVO.CloudCrazeMessageId = String.valueOf(123456);
		populateHeaderInfo(personVO);
		populateOrderInfo(personVO);
		return personVO;
	}
	
	private static void populateHeaderInfo(KapGetRealPersonVO personVO){
			personVO.student_id = String.valueOf(123445);
			populateAdditionalIdentificationInfo(personVO);
        personVO.f_name = 'TEST';//thisAccount.FirstName;
        personVO.m_name = 'TEST';//thisAccount.Middle_Name__c;
        personVO.l_name = 'TEST';//thisAccount.LastName;
       	personVO.entry_date = System.now().format();
	}
	private static void populateAdditionalIdentificationInfo(KapGetRealPersonVO personVO){
			KapGetRealAddressVO permAddr = new KapGetRealAddressVO();
			permAddr.addr_type = 'TEST';//billToAddress.KBSAddressType;
			permAddr.line_1 = 'TEST';//billToAddress.address1;
			permAddr.line_2 = 'TEST';//billToAddress.address2;
			permAddr.line_3 = 'TEST';//billToAddress.address3;
			permAddr.city = 'TEST';//billToAddress.city;
			permAddr.state = 'TEST';//billToAddress.state;
			permAddr.country = 'TEST';//billToAddress.country;
			permAddr.postal_code = 'TEST';//billToAddress.postalCode;
			permAddr.mail = 'true';
			permAddr.addr_type = 'TEST';//billToAddress.KBSAddressType;
			personVO.addressList = new List<KapGetRealAddressVO>{permAddr};
		
			KapGetRealEmailVO emailVO = new KapGetRealEmailVO();
			emailVO.index = '0';
			emailVO.email_address = 'TEST';//thisUser.Email;
			personVO.emailList = new List<KapGetRealEmailVO>{emailVO};
		
		KapGetRealInternationalInfoVO intlVO = new KapGetRealInternationalInfoVO();
		intlVO.aba_number = 'TEST';//thisAccount.ABA_Number__c;
		intlVO.ama_number = 'TEST';//thisAccount.AMA_Number__c; 
		personVO.intlInfoList = new List<KapGetRealInternationalInfoVO>{intlVO};
		
			KapGetRealPhoneVO phoneVO = new KapGetRealPhoneVO();
			phoneVO.index ='0';
			phoneVO.phone_number = 'TEST';//thisUser.Phone;
			personVO.phoneList = new List<KapGetRealPhoneVO>{phoneVO};
	}
	
	private static void populateOrderInfo(KapGetRealPersonVO personVO){
		personVO.cloudCrazeOrder = new KapGetRealCloudCrazeOrderVO();
		populateOrderPaymentMethods(personVO);
		populateOrderItemAndShippingInfo(personVO);
	}
	
	/**
	* Could theoretically support multiple payment/shipping methods, but for now we just have one
	*/
	private static void populateOrderPaymentMethods(KapGetRealPersonVO personVO){
		List<KapGetRealPaymentMethodVO> paymentMethodList = new List<KapGetRealPaymentMethodVO>();
		KapGetRealPaymentMethodVO currentPayMethod = new KapGetRealPaymentMethodVO();
		currentPaymethod.index = 0;
		//CC info
			currentPaymethod.cc_maskedNumber = 'TEST';//creditCard.getCardNumberMasked();
			currentPaymethod.cc_subscriptionId = 'TEST';//creditCard.subscriptionId;
			currentPaymethod.cc_authCode = 'TEST';//creditCard.authCode;
			currentPaymethod.cc_expirationDate = 'TEST';//creditCard.expiryYear + '-' + creditCard.expiryMonth;
			currentPaymethod.cc_type = 'TEST';//cc_kap_utils_AppUtils.getCreditCardGetRealNameByName(creditCard.cardType);
			currentPaymethod.name = 'TEST';//billToAddress.firstName + ' ' + billToAddress.lastName;
		
			//Billing address info
				KapGetRealAddressVO billAddr = new KapGetRealAddressVO();
				billAddr.addr_type = 'TEST';//billToAddress.KBSAddressType;
				billAddr.line_1 = 'TEST';//billToAddress.address1;
				billAddr.line_2 = 'TEST';//billToAddress.address2;
				billAddr.line_3 = 'TEST';//billToAddress.address3;
				billAddr.city = 'TEST';//billToAddress.city;
				billAddr.state = 'TEST';//billToAddress.state;
				billAddr.country = 'TEST';//billToAddress.country;
				billAddr.postal_code = 'TEST';//billToAddress.postalCode;
				currentPayMethod.cc_billingAddress = billAddr;
				paymentMethodList.add(currentPayMethod);
		personVO.cloudCrazeOrder.paymentMethodList = paymentMethodList;				
	}
	
	private static void populateOrderItemAndShippingInfo(KapGetRealPersonVO personVO){
		List<KapGetRealCCOrderItemVO> itemList = new List<KapGetRealCCOrderItemVO>();
		Integer itemCounter = 0;
		E_Product__c currentProduct;
			KapGetRealCCOrderItemVO itemVO = new KapGetRealCCOrderItemVO();
			//itemVO.ccItemBean = item;
			itemVO.client_sys_id = 'TEST';//orderId + '_item-' + itemCounter;
			itemVO.basePrice = 123456;//item.price;
				itemVO.discountCode = 'TEST';// item.couponCode;
				itemVO.discountCode = 'KAPTEST-SALE';
			itemVO.discountAmount = 1234;//item.discountAmount;
			itemVO.installmentsRemaining = 1;//item.installments - 1;
			itemVO.balanceRemaining = 100;//Integer.valueOf(item.subAmount - item.amountPaid);
			itemVO.deliveryType = 'TEST';//cc_kap_utils_AppUtils.getDeliveryTypeItemType(item.deliveryTypeDesc);

				itemVO.transactionCode = cc_kap_utils_AppConstants.TRANS_CODE_MARKETING_EVENT;
				itemVO.startDate = System.now().format();//item.flexDate.format('yyyy-MM-dd');			
				itemVO.classId ='TEST';// item.sku;

			
			List<KapGetRealPaymentVO> paymentList = new List<KapGetRealPaymentVO>();
				KapGetRealPaymentVO payment = new KapGetRealPaymentVO();
				payment.index = 0;
				payment.payMethodIndex = 0;
				payment.cc_authCode = 'TEST';//creditCard.authCode;
				payment.cc_subscriptionId = 'TEST';//creditCard.subscriptionId;
				payment.cc_settlmentDate = System.now().format();//creditCard.settlementDate.format('yyyy-MM-dd');
				payment.cc_batchId = '';
				payment.amount = 100;//item.amountPaid + item.shipCharge;
				paymentList.add(payment);
			itemVO.payments = paymentList;
			
			KapGetRealShippingMethodVO currentShipMethod = new KapGetRealShippingMethodVO();
			currentShipMethod.method = 'TEST';//item.shipMethod;
				currentShipMethod.fee = 12345;//item.shipCharge;
			KapGetRealAddressVO shipAddr = new KapGetRealAddressVO();
			shipAddr.addr_type = 'TEST';//shipToAddress.KBSAddressType;
			shipAddr.line_1 = 'TEST';//shipToAddress.address1;
			shipAddr.line_2 = 'TEST';//shipToAddress.address2;
			shipAddr.line_3 = 'TEST';//shipToAddress.address3;
			shipAddr.city = 'TEST';//shipToAddress.city;
			shipAddr.state = 'TEST';//shipToAddress.state;
			shipAddr.country = 'TEST';//shipToAddress.country;
			shipAddr.postal_code = 'TEST';//shipToAddress.postalCode;
			currentShipMethod.shippingAddress = shipAddr;
			itemVO.shippingMethod = currentShipMethod;
			
			itemList.add(itemVO);
			itemCounter++;
		personVO.cloudCrazeOrder.itemList = itemList;
	}

}