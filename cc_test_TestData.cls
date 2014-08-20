public with sharing class cc_test_TestData {
    public static cc_bean_DoDirectPaymentInfo createDirectPaymentInfo(){
        cc_bean_DoDirectPaymentInfo ddpi = new cc_bean_DoDirectPaymentInfo();
        

        
        cc_hlpr_CreditCard cc= new cc_hlpr_CreditCard();
        cc.ccType               ='Maestro';
        //cc.ccCVV2             ='123';
        cc.ccExpirationMonth    ='01';
        cc.ccExpirationYear     ='2010';
        cc.issueNumber          = '123';
        cc.ccNumber             = '1234567890';
        cc.startMonth           = '01';
        cc.startYear            = '2008';
        
        
        PaypalAddressInfo paiBilling = new PaypalAddressInfo(false);
        paiBilling.city                 = 'New York';
        paiBilling.countryCode          = 'US';
        paiBilling.name                 = 'name';
        paiBilling.state                = 'NY';
        paiBilling.street               = '123 5th St';
        paiBilling.street2              = 'Apt 312';
        paiBilling.zip                  = '10210';
        paiBilling.phoneNumber          = '1234567890';
        
        PaypalAddressInfo paiShipping = new PaypalAddressInfo(true);
        paiShipping.city                 = 'New York';
        paiShipping.countryCode          = 'US';
        paiShipping.name                 = 'name';
        paiShipping.state                = 'NY';
        paiShipping.street               = '123 5th St';
        paiShipping.street2              = 'Apt 312';
        paiShipping.zip                  = '10210';
        paiShipping.phoneNumber          = '1234567890';
        
        
        cc_bean_PaymentDetails pd       = new cc_bean_PaymentDetails();
        pd.amount                   = Decimal.valueOf('10.99');
        pd.buttonSource             = '123';
        pd.currencyCode             = 'USD';
        pd.customField              = 'custom field';
        pd.description              = 'desc';
        pd.handlingAmount           = Decimal.valueOf('1.99');
        pd.insuranceAmount          = Decimal.valueOf('1.99');
        pd.insuranceOptionsOffered  = true;
        pd.invoiceNumber            = '111';
        pd.itemAmount               = Decimal.valueOf('9.99');
        pd.notifyUrl                = 'www.salesforce.com';
        pd.shippingAmount           = Decimal.valueOf('5.99');
        pd.shippingDiscount         = Decimal.valueOf('1.00');
        pd.taxAmount                = Decimal.valueOf('2.99');
         
        ddpi.payerInfo       = createPaypalPayerInfo();
        ddpi.payment         = pd;
        ddpi.cc_hlpr_CreditCard      = cc;
        ddpi.billingAddress = paiBilling;
        ddpi.shippingAddress = paiShipping;
        ddpi.paymentAction   = cc_bean_DoDirectPaymentInfo.PAYMENT_ACTION_AUTH;
        ddpi.ipAddress       = '127.0.0.1';
        ddpi.returnDetails   = true;
        
        //System.debug(ddpi.getPaypalRequestString());
        
        ddpi.returnDetails   = false;
        return ddpi;
    }
    
    public static PaypalPayerInfo createPaypalPayerInfo(){
        PaypalPayerInfo ppi = new PaypalPayerInfo();
        ppi.firstName          = 'fname';
        ppi.middleName         = 'mname';
        ppi.lastName           = 'lname';
        ppi.businessName       = 'bname';
        ppi.countryCode        = 'US';
        ppi.email              = 'email@test.com';
        ppi.payerId            = '112';
        ppi.payerStatus        = PaypalPayerInfo.PAYER_STATUS_VERIFIED;
        ppi.salutation         = 'Mr.';
        ppi.suffix             = 'Sr.';
        return ppi;
    }
}