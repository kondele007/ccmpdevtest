/*
*This class used to store cloud craze information in the temporary object.The message is mapped/built in below class and the xml is populated in KapGetRealUtil. 
*XML message is sent to KBS using ktp_cc_GR_ext_OrderIntegration.
*Classes used for GetRealIntegration:ktp_cc_GR_ext_OrderIntegration/KapGetRealUtil/ktp_cc_GR_ext_OrderVOPopulator
*Logic Flow: Person---> cc Order ---> cc Order Detail
*/

public with sharing class ktp_cc_GR_ext_OrderVOPopulator {
	
	
public KapGetRealPersonVO personVO{get
        {
            if (personVO == null){
                populateKaplanValueObject();
            }
            return personVO;
        }
        set;}
    
    public Id orderId{get; set;}
    public List<ktp_cc_bean_MockOrderItem> ccOrderItems{get; set;}
    public List<ErrorReportEntry__c> errorReports{get; set;}
    Public Account Acct{get;set;}
    
    private User thisUser;
    private Account thisAccount;
    private Student_School__c currStudentSchool;
    
    private Id userId;
    private ktp_cc_GR_UtilOrder orderUtil;
    private ktp_cc_bean_MockOrder ccOrder;
    private ktp_cc_bean_MockContactAddress billToAddress;
    private ktp_cc_bean_MockContactAddress shipToAddress;
    private ktp_cc_bean_CreditCard creditCard;

    public ktp_cc_GR_ext_OrderVOPopulator(Id orderId){
        this.orderId = orderId;
        orderUtil = new ktp_cc_GR_UtilOrder();
        orderUtil.orderID = orderId;
        errorReports = new List<ErrorReportEntry__c>();
        restorePersonAccountAndOrderInfo();
    }
    
    private void populateKaplanValueObject(){
        personVO = new KapGetRealPersonVO();
        personVO.CloudCrazeMessageId = String.valueOf(orderId);
        populateHeaderInfo();
        if(ccOrder != null)
            populateOrderInfo();
    }

    private void populateHeaderInfo(){
        if(thisAccount.Student_ID__c != null){
            personVO.student_id = String.valueOf(thisAccount.Student_ID__c);
        }
        else{
            populateAdditionalIdentificationInfo();
        }
        personVO.f_name = thisAccount.FirstName;
        personVO.m_name = thisAccount.Middle_Name__c;
        personVO.l_name = thisAccount.LastName;
        //Roster Changes
        System.debug(LoggingLevel.INFO, '$$Roster currStudentSchool=' + currStudentSchool);
        if (currStudentSchool != null){
            personVO.grad_year = currStudentSchool.Graduation_Year__c;
            personVO.subordinateUID=currStudentSchool.School_ID__c;
            }
        if(thisAccount.Entry_Date__c != null)
            personVO.entry_date = thisAccount.Entry_Date__c.format();
    }

    private void populateAdditionalIdentificationInfo(){
        if(billToAddress != null) {
            KapGetRealAddressVO permAddr = new KapGetRealAddressVO();
            permAddr.addr_type = billToAddress.KBSAddressType != null ? billToAddress.KBSAddressType : 'Perm';
            permAddr.line_1 = billToAddress.address1;
            permAddr.line_2 = billToAddress.address2;
            permAddr.line_3 = billToAddress.address3;
            permAddr.city = billToAddress.city;
            permAddr.state = billToAddress.state;
            permAddr.country = billToAddress.country;
            permAddr.postal_code = billToAddress.postalCode;
            permAddr.mail = 'true';
            personVO.addressList = new List<KapGetRealAddressVO>{permAddr};
        }
        
        if(thisUser.Email != null) {
            KapGetRealEmailVO emailVO = new KapGetRealEmailVO();
            emailVO.index = '0';
            emailVO.email_address = thisUser.Email;
            personVO.emailList = new List<KapGetRealEmailVO>{emailVO};
        }
        
        KapGetRealInternationalInfoVO intlVO = new KapGetRealInternationalInfoVO();
        intlVO.aba_number = thisAccount.ABA_Number__c;
        intlVO.ama_number = thisAccount.AMA_Number__c; 
        personVO.intlInfoList = new List<KapGetRealInternationalInfoVO>{intlVO};
        
        if(thisUser.Phone != null) {
            KapGetRealPhoneVO phoneVO = new KapGetRealPhoneVO();
            phoneVO.index ='0';
            phoneVO.phone_number = thisUser.Phone;
            personVO.phoneList = new List<KapGetRealPhoneVO>{phoneVO};
        }
        //Roster Changes
        System.debug(LoggingLevel.INFO, '$$Roster thisAccount=' + thisAccount); 

        Map<String, String> exclusionsetup = new Map<String, String>();
        if(thisAccount.Do_Not_Call2__c){
            exclusionsetup.put(KapConstants.KAP_FLD_STUDENT_DO_NOT_CALL, 'true');
        }else{
            exclusionsetup.put(KapConstants.KAP_FLD_STUDENT_DO_NOT_CALL, 'false');
        }
        if(thisAccount.Email_Opt_Out2__c){
            exclusionsetup.put(KapConstants.KAP_FLD_STUDENT_DO_NOT_EMAIL, 'true');
        }else{
            exclusionsetup.put(KapConstants.KAP_FLD_STUDENT_DO_NOT_EMAIL, 'false');
        }
        if(thisAccount.Do_Not_Mail_Flag__c){
            exclusionsetup.put(KapConstants.KAP_FLD_STUDENT_DO_NOT_MAIL, 'true');
        }else{
            exclusionsetup.put(KapConstants.KAP_FLD_STUDENT_DO_NOT_MAIL, 'false');
        }
        if(thisAccount.Do_Not_Share_Flag__c){
            exclusionsetup.put(KapConstants.KAP_FLD_STUDENT_DO_NOT_SHARE, 'true');
        }else{
            exclusionsetup.put(KapConstants.KAP_FLD_STUDENT_DO_NOT_SHARE, 'false');
        }

        personVO = KapGetRealUtil.populateStudentExclusionInfo(personVO,exclusionsetup); 

        //Roster Changes
    }
    
    private void populateOrderInfo(){
        personVO.cloudCrazeOrder = new KapGetRealCloudCrazeOrderVO();
        populateOrderPaymentMethods();
        populateOrderItemAndShippingInfo();
    }
    
    /**
    * Could theoretically support multiple payment/shipping methods, but for now we just have one
    */
    private void populateOrderPaymentMethods(){
        List<KapGetRealPaymentMethodVO> paymentMethodList = new List<KapGetRealPaymentMethodVO>();
        KapGetRealPaymentMethodVO currentPayMethod = new KapGetRealPaymentMethodVO();
        currentPaymethod.index = 0;
        //CC info
        if(creditCard != null){
            currentPaymethod.cc_maskedNumber = creditCard.getCardNumberMasked();
            currentPaymethod.cc_subscriptionId = creditCard.subscriptionId;
            currentPaymethod.cc_authCode = creditCard.authCode;
            currentPaymethod.cc_expirationDate = creditCard.expiryYear + '-' + creditCard.expiryMonth;
            currentPaymethod.cc_type = ktp_cc_kap_utils_AppUtils.getCreditCardGetRealNameByName(creditCard.cardType);
            currentPaymethod.name = billToAddress.firstName + ' ' + billToAddress.lastName;
        
            //Billing address info
            if(billToAddress != null){
                KapGetRealAddressVO billAddr = new KapGetRealAddressVO();
                billAddr.addr_type = billToAddress.KBSAddressType != null ? billToAddress.KBSAddressType : 'Perm';
                billAddr.line_1 = billToAddress.address1;
                billAddr.line_2 = billToAddress.address2;
                billAddr.line_3 = billToAddress.address3;
                billAddr.city = billToAddress.city;
                billAddr.state = billToAddress.state;
                billAddr.country = billToAddress.country;
                billAddr.postal_code = billToAddress.postalCode;
                currentPayMethod.cc_billingAddress = billAddr;
                paymentMethodList.add(currentPayMethod);
            }
        }
        personVO.cloudCrazeOrder.paymentMethodList = paymentMethodList;             
    }
    
    private void setIBFee(KapGetRealCCOrderItemVO itemVO, ktp_cc_bean_MockOrderItem item) {
    	 if(item.categoryName == 'IB Fee'){
                itemVO.isIBFee = true;
            }else{
                itemVO.isIBFee = false;
            }
    }
    
    private void setPriceInfo(KapGetRealCCOrderItemVO itemVO, ktp_cc_bean_MockOrderItem item) {
    	itemVO.basePrice = item.price;
            //Add sale amount to determine the original base price
            if(item.discountAmount != null){
                itemVO.basePrice += (item.discountAmount - (item.couponDiscount != null ? item.couponDiscount : 0.0));
            }
            if (item.couponId != null)
                itemVO.discountCode = item.couponCode;
            else if(item.couponId == null && item.discountAmount != null && item.discountAmount > 0)
                itemVO.discountCode = 'KAPTEST-SALE';
            itemVO.discountAmount = item.discountAmount != null ? item.discountAmount : 0;
            itemVO.installmentsRemaining = item.installments != null ? item.installments - 1 : 0;
            itemVO.balanceRemaining = item.amountPaid != null ? Integer.valueOf(item.subAmount - item.amountPaid) : Integer.valueOf(item.subAmount);
    }
    
    private void setCenterCode(KapGetRealCCOrderItemVO itemVO, ktp_cc_bean_MockOrderItem item) {
    	// Study center only for online items and tutor items
            if((item.deliveryTypeCode != null) && ((item.deliveryTypeCode == ktp_cc_kap_utils_AppConstants.DELIV_TYPE_ONLINE) || (item.deliveryTypeCode == ktp_cc_kap_utils_AppConstants.DELIV_TYPE_TUTORING) || (item.deliveryTypeCode == ktp_cc_kap_utils_AppConstants.DELIV_TYPE_ONLINE_EVENTS))) {
                itemVO.studyCenter = ktp_cc_kap_utils_AppConstants.DEFAULT_CENTER_CODE;
                if(item.sbuCode != null) {
                    if(item.sbuCode == ktp_cc_kap_utils_AppConstants.SBU_GRAD) {
                        itemVO.studyCenter = ktp_cc_kap_utils_AppConstants.DEFAULT_GRAD_CENTER_CODE;
                    } else if(item.sbuCode == ktp_cc_kap_utils_AppConstants.SBU_PC) {
                        itemVO.studyCenter = ktp_cc_kap_utils_AppConstants.DEFAULT_PC_CENTER_CODE;
                    } else if(item.sbuCode == ktp_cc_kap_utils_AppConstants.SBU_HEALTH) {
                        itemVO.studyCenter = ktp_cc_kap_utils_AppConstants.DEFAULT_HEALTH_CENTER_CODE;
                    } else if(item.sbuCode == ktp_cc_kap_utils_AppConstants.SBU_BAR) {
                        itemVO.studyCenter = ktp_cc_kap_utils_AppConstants.DEFAULT_BAR_CENTER_CODE;
                    }
                }
            } else {
                itemVO.studyCenter = null;
            }
    }
    
    private void setPaymentInfo(KapGetRealCCOrderItemVO itemVO, ktp_cc_bean_MockOrderItem item){
    	List<KapGetRealPaymentVO> paymentList = new List<KapGetRealPaymentVO>();
            if(creditCard != null){
                KapGetRealPaymentVO payment = new KapGetRealPaymentVO();
                payment.index = 0;
                payment.payMethodIndex = 0;
                payment.cc_authCode = creditCard.authCode;
                payment.cc_subscriptionId = creditCard.subscriptionId;
                payment.cc_settlmentDate = creditCard.settlementDate.format('yyyy-MM-dd');
                payment.cc_batchId = '';
                Decimal paymentAmount = 0;
                if(item.amountPaid != null) paymentAmount += item.amountPaid;
                if(item.shipCharge != null) paymentAmount += item.shipCharge;
                payment.amount = paymentAmount;
                //payment.amount = item.amountPaid != null ? item.amountPaid + item.shipCharge : item.shipCharge;
                paymentList.add(payment);
                 }
             itemVO.payments = paymentList;
    }
    private void setShippingInfo(KapGetRealCCOrderItemVO itemVO,ktp_cc_bean_MockOrderItem item){
    	
            KapGetRealShippingMethodVO currentShipMethod = new KapGetRealShippingMethodVO();
            if(item.shipMethod != null && item.shipMethod != ktp_cc_kap_utils_AppConstants.SHIP_NONE){
                currentShipMethod.method = item.shipMethod;
                currentShipMethod.fee = item.shipCharge;
            }
            if(shipToAddress != null){
                KapGetRealAddressVO shipAddr = new KapGetRealAddressVO();
                shipAddr.addr_type = shipToAddress.KBSAddressType != null ? shipToAddress.KBSAddressType : 'Perm';
                shipAddr.line_1 = shipToAddress.address1;
                shipAddr.line_2 = shipToAddress.address2;
                shipAddr.line_3 = shipToAddress.address3;
                shipAddr.city = shipToAddress.city;
                shipAddr.state = shipToAddress.state;
                shipAddr.country = shipToAddress.country;
                shipAddr.postal_code = shipToAddress.postalCode;
                currentShipMethod.shippingAddress = shipAddr;
            }
            itemVO.shippingMethod = currentShipMethod;
    }
    private void setTransactionCode(KapGetRealCCOrderItemVO itemVO,ktp_cc_bean_MockOrderItem item){
    	if(itemVO.transactionCode == null){
                System.debug(LoggingLevel.INFO,'item.parentCode:'+item.parentCode + 'LOOK HERE');
                if(itemVO.isIBFee){
                    itemVO.transactionCode = ktp_cc_kap_utils_AppConstants.TRANS_CODE_MARKETING_EVENT; 
                    System.debug(LoggingLevel.INFO,'txnCode:'+itemVO.transactionCode + 'LOOK HERE - IB Fee True');
                }else{
                System.debug(LoggingLevel.INFO,'offeredPrice:'+item.offeredPrice +'LOOK HERE - Price');
                    if (item.offeredPrice == 0.0 && ((item.eventType != null && item.eventType.length() > 0) || (item.deliveryTypeCode == 6 || item.deliveryTypeCode == 7 || item.deliveryTypeCode == 13))){
                        itemVO.transactionCode = ktp_cc_kap_utils_AppConstants.TRANS_CODE_MARKETING_EVENT;
                        System.debug(LoggingLevel.INFO,'txnCode:'+itemVO.transactionCode + ', deliveryTypeCode:' + item.deliveryTypeCode +'LOOK HERE - Marketing');
                    }else if (item.offeredPrice == 0.0 && item.discountAmount > 0){
                        itemVO.transactionCode = ktp_cc_kap_utils_AppConstants.TRANS_CODE_FREE_BUNDLE;
                        System.debug(LoggingLevel.INFO,'txnCode:'+itemVO.transactionCode + ', deliveryTypeCode:' + item.deliveryTypeCode +'LOOK HERE - Free Bundle');
                    }else if (item.discountAmount > 0){
                        itemVO.transactionCode = ktp_cc_kap_utils_AppConstants.TRANS_CODE_DISCOUNT_ENROLL;
                        System.debug(LoggingLevel.INFO,'txnCode:'+itemVO.transactionCode + ', deliveryTypeCode:' + item.deliveryTypeCode +'LOOK HERE - Discount');
                    }else{
                        itemVO.transactionCode = ktp_cc_kap_utils_AppConstants.TRANS_CODE_FULL_TUITION_ENROLL;
                        System.debug(LoggingLevel.INFO,'txnCode:'+itemVO.transactionCode + ', deliveryTypeCode:' + item.deliveryTypeCode +'LOOK HERE - Full');
                    }
                }
            }
    }
    private void setFlexStartandEnddate(KapGetRealCCOrderItemVO itemVO,ktp_cc_bean_MockOrderItem item){
           if(item.flexEndDate != null)                
                itemVO.endDate = item.flexEndDate.adddays(1).format('yyyy-MM-dd');

            System.debug(LoggingLevel.INFO,'Rosteritem.flexDate --' + item.flexDate);
            if(item.flexDate != null) 
                // itemVO.startDate = item.flexDate.format('yyyy-MM-dd');
                itemVO.startDate = item.flexDate.adddays(1).format('yyyy-MM-dd');
            else if(item.deliveryTypeCode != null && (item.deliveryTypeCode == ktp_cc_kap_utils_AppConstants.DELIV_TYPE_CENTER_BASED || item.deliveryTypeCode == ktp_cc_kap_utils_AppConstants.DELIV_TYPE_LIVE_ONLINE || item.deliveryTypeCode == ktp_cc_kap_utils_AppConstants.DELIV_TYPE_SIT
                || item.deliveryTypeCode == ktp_cc_kap_utils_AppConstants.DELIV_TYPE_CENTER_BASED_EVENTS || item.deliveryTypeCode == ktp_cc_kap_utils_AppConstants.DELIV_TYPE_LIVE_ONLINE_EVENTS)){

                itemVO.startDate = null;
                itemVO.endDate = null;
            } 
            else{
                itemVO.startDate = DateTime.now().format('yyyy-MM-dd');
            }
             System.debug(LoggingLevel.INFO,'Rosteritem.startDate --' + itemVO.startDate);	
             System.debug(LoggingLevel.INFO,'Rosteritem.flexEndDate --' + item.flexEndDate);
    }
    
    private void setDeliveryType(KapGetRealCCOrderItemVO itemVO,ktp_cc_bean_MockOrderItem item){
    	
    	 if(item.deliveryTypeCode != null && (item.deliveryTypeCode == ktp_cc_kap_utils_AppConstants.DELIV_TYPE_CENTER_BASED || item.deliveryTypeCode == ktp_cc_kap_utils_AppConstants.DELIV_TYPE_LIVE_ONLINE || item.deliveryTypeCode == ktp_cc_kap_utils_AppConstants.DELIV_TYPE_SIT
                || item.deliveryTypeCode == ktp_cc_kap_utils_AppConstants.DELIV_TYPE_CENTER_BASED_EVENTS || item.deliveryTypeCode == ktp_cc_kap_utils_AppConstants.DELIV_TYPE_LIVE_ONLINE_EVENTS)) {
                itemVO.classId = item.sku;
            } else {
                itemVO.productCode = item.parentCode; //use parent code
            }
            
            System.debug('--------------' + item.deliveryTypeCode);
    }
    private void populateOrderItemAndShippingInfo(){
        List<KapGetRealCCOrderItemVO> itemList = new List<KapGetRealCCOrderItemVO>();
        Integer itemCounter = 0;
        ccrz__E_Product__c currentProduct;
        for(ktp_cc_bean_MockOrderItem item : ccOrderItems){
            KapGetRealCCOrderItemVO itemVO = new KapGetRealCCOrderItemVO();
            itemVO.ccItemBean = item;
            System.debug(LoggingLevel.INFO, '$$item='+ item);
//          System.debug(LoggingLevel.INFO, '$$item.rulesBean.IBFee=' + item.rulesBean.IBFee);
            setIBFee(itemVO, item);
            // Format should be KTPO-itemid-orderid-quantity
            //itemVO.client_sys_id = 'KTPO' + '-' + item.sfid + '-' + orderId + '-' + item.quantity.longValue(); // Length too big to fit on KBS field
            itemVO.client_sys_id = ccOrder.name + '-' + item.name;
            setPriceInfo(itemVO, item);
            itemVO.deliveryType = ktp_cc_kap_utils_AppUtils.getDeliveryTypeItemType(item.deliveryTypeDesc);
            
            //Roster Changes            
            itemVO.transactionCode = item.transactionCode;          
            itemVO.channel = item.channel;
            System.debug(LoggingLevel.INFO,'itemVO.transactionCode Before' + itemVO.transactionCode); 
            if(itemVO.channel == 0 || itemVO.channel == null){
                itemVO.channel = 20;
            }
            System.debug(LoggingLevel.INFO,'itemVO.channel --' + itemVO.channel); 
            setTransactioncode(itemVO,item);

            
            setFlexStartandEnddate(itemVO,item);
            if(itemVO.isIBFee){
                itemVO.productCode = item.productCode;
            }
            setDeliveryType(itemVO,item);
            setCenterCode(itemVO, item);
            setPaymentInfo(itemVO,item);
            setShippingInfo(itemVO,item);
            //JLL rounding fixes...round any values here
            itemVO.basePrice = Math.rint(itemVO.basePrice * 1000)/1000;
            itemVO.discountAmount = Math.rint(itemVO.discountAmount * 1000)/1000;
            System.debug(LoggingLevel.INFO,'itemVO:'+itemVO + 'LOOK HERE - item VO Content');
            itemList.add(itemVO);
            itemCounter++;
            errorReports.add(buildECEntry(itemVO, item));
        }
        personVO.cloudCrazeOrder.itemList = itemList;
    }
    
    private void restorePersonAccountAndOrderInfo(){
        ccOrder = orderUtil.retrieveFullOrderData();
        ccOrderItems = ccOrder.orderItems;
        userId = orderUtil.getOrder().OwnerId;
        System.debug(LoggingLevel.INFO,'userId' + userId);
        System.debug(LoggingLevel.INFO,'ccOrder' + ccOrder);
        System.debug(LoggingLevel.INFO,'ccOrderItems' + ccOrderItems);
        billToAddress = ccOrder.billTo;
        shipToAddress = ccOrder.shipTo;
        creditCard = ccOrder.creditCard; 
        //thisUser = [select Email, Phone, ContactId, AccountId from User where id = :userId Limit 1];
        thisUser = [select Email, Phone, ContactId, AccountId from User where id = '005M0000005nsIX' Limit 1];
        System.debug(LoggingLevel.INFO,'thisUser' + thisUser);
        thisAccount = [select Student_Id__c, ABA_Number__c, AMA_Number__c, OnBehalfPurchaseAccount__c, Gender__c, PersonEmail, Kaptest_Username__c, Phone, Phone_1_Type__c, Nat_Do_Not_Call_Flag__c, Entry_Date__c, Middle_Name__c, FirstName, LastName, BillingStreet, BillingPostalCode, ShippingStreet, ShippingPostalCode, School_Address_Line_1__c, School_Postal_Code__c, Other_Address_Line_1__c, Other_Postal_Code__c,Do_Not_Call2__c,Email_Opt_Out2__c,Do_Not_Mail_Flag__c,Do_Not_Share_Flag__c  FROM Account WHERE Id = :thisUser.AccountId Limit 1];
        System.debug(LoggingLevel.INFO,'thisAccount' + thisAccount);
        
        if(thisAccount.OnBehalfPurchaseAccount__c != null){
            thisAccount = [select Student_Id__c, ABA_Number__c, AMA_Number__c, OnBehalfPurchaseAccount__c, Gender__c, PersonEmail, Kaptest_Username__c, Phone, Phone_1_Type__c, Nat_Do_Not_Call_Flag__c, Entry_Date__c, Middle_Name__c, FirstName, LastName, BillingStreet, BillingPostalCode, ShippingStreet, ShippingPostalCode, School_Address_Line_1__c, School_Postal_Code__c, Other_Address_Line_1__c, Other_Postal_Code__c,Do_Not_Call2__c,Email_Opt_Out2__c,Do_Not_Mail_Flag__c,Do_Not_Share_Flag__c FROM Account WHERE Id = :thisAccount.OnBehalfPurchaseAccount__c Limit 1];
        }
        
        Acct=thisAccount;
        System.debug('Account Id is:'+acct);
        try {
            this.currStudentSchool = [
                SELECT
                    Student_School_ID__c, Graduation_Year__c, School_name__c,School_ID__c
                FROM
                    Student_School__c
                WHERE
                    Account__c = :thisAccount.Id 
                ORDER BY
                    Graduation_Year__c Desc
                Limit 1];
        }
        catch (Exception e) {
            this.currStudentSchool = null;
        }
    }
    
    private ErrorReportEntry__c buildECEntry(KapGetRealCCOrderItemVO itemVO, ktp_cc_bean_MockOrderItem item) {
        if(item.amountPaid == null) item.amountPaid = 0;
        if(item.shipCharge == null) item.shipCharge = 0;
        ErrorReportEntry__c entry = new ErrorReportEntry__c();
        entry.OrderID__c = ccOrder.sfId;
        entry.EC_Source_ID__c = itemVO.client_sys_id;
        entry.FirstName__c = thisAccount.FirstName;
        entry.LastName__c = thisAccount.LastName;
        if(thisAccount.Student_ID__c != null)
            entry.StudentID__c = String.valueOf(thisAccount.Student_ID__c);
        if(billToAddress != null){
            entry.BillAddr1__c = billToAddress.address1;
            entry.BillAddr2__c = billToAddress.address2;
            entry.BillAddr3__c = billToAddress.address3;
            entry.BillCity__c = billToAddress.city;
            entry.BillCountry__c = billToAddress.country;
            entry.BillPhoneNumber__c = billToAddress.homePhone;
            entry.BillPostalCode__c = billToAddress.postalCode;
            entry.BillState__c = billToAddress.state;
        }
        if(shipToAddress != null){
            entry.ShipAddr1__c = shipToAddress.address1;
            entry.ShipAddr2__c = shipToAddress.address2;
            entry.ShipAddr3__c = shipToAddress.address3;
            entry.ShipCity__c = shipToAddress.city;
            entry.ShipCountry__c = shipToAddress.country;
            entry.ShipPhoneNumber__c = shipToAddress.homePhone;
            entry.ShipPostalCode__c = shipToAddress.postalCode;
            entry.ShipState__c = shipToAddress.state;
        }
        entry.ShippingFee__c = item.shipCharge;
        entry.ShippingMethod__c = item.shipMethod;
        if(creditCard != null){ 
            entry.CreditCardNumber__c = creditCard.cardNumber;
            entry.CreditCardType__c = ktp_cc_kap_utils_AppUtils.getCreditCardGetRealNameByName(creditCard.cardType);
            entry.MaskedCCNumber__c = creditCard.getCardNumberMasked();
            entry.CCAuthCode__c = creditCard.authCode;
            entry.SubscriptionID__c = creditCard.subscriptionId;
            entry.CCExpirationDate__c = creditCard.expiryMonth + '/1/' + creditCard.expiryYear;
            entry.CCSettlementDate__c = creditCard.settlementDate;
        }
        entry.TransactionCode__c = itemVO.transactionCode;
        entry.PromoCode__c = itemVO.discountCode;
        entry.CenterID__c = itemVO.studyCenter;
        entry.ExpectedStartDate__c = item.startDate;
        entry.BaseFee__c = itemVO.basePrice;
        entry.CCBatchID__c = System.now().format('ddMMyyyy');
        entry.CCCNumber__c = '';
        entry.ClassCode__c = item.productCode;
        entry.ClassID__c = item.sku;
        entry.CourseOfInterest__c = '';
        entry.Email__c = thisAccount.PersonEmail;
        entry.ExpectedExamDate__c = '';
        entry.FeeAdjustment__c = item.discountAmount;
        if (currStudentSchool != null)
        {
            entry.SchoolId__c=currStudentSchool.School_ID__c;
            entry.GradYear__c = currStudentSchool.Graduation_Year__c;
          }
        entry.Password__c = '';
        entry.PaymentAmount__c = item.amountPaid + item.shipCharge;
        entry.PaymentType__c = (item.amountPaid > 0 || item.shipCharge > 0) ? 'Credit Card' : '';
        entry.PurchaseAddMod__c = '';
        entry.PurchaseID__c = '';
        entry.Quantity__c = String.valueOf(item.quantity);
        if (currStudentSchool != null)
            entry.SchoolName__c = String.valueOf(currStudentSchool.Student_School_ID__c);
        entry.SiblingCCCNumber__c = '';
        entry.Username__c = thisAccount.Kaptest_Username__c;
        return entry;
    }
}