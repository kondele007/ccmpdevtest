/**
// * Created by CloudCraze, LLC.
// * Copyright 2010-12 CloudCraze, LLC. All rights reserved
// * @Description: Handles cybersource HOP integration.
// * @Author: 1.0
// * @File: cc_ctrl_CyberSourceHOP
// * =======================================================================================
// * 2012/08/30 1.1 IL -  Refactored
**/
public with sharing class cc_ctrl_CyberSourceHOP_va {
    public String ipAddressLocation{ get; set; }
	public String ipAddressLocationKey { get { return cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY; } set; }
	public String currentCartID{ get; set; }
	public String sfCartName{ get; set; }
	public cc_bean_MockContactAddress billingAddress{ get;set; }
    public cc_bean_MockContactAddress shippingAddress{ get;set; }
    public cc_payment_cs_bean_Transaction csTransaction { get; private set; }
    public cc_payment_cs_bean_SubscriptionTransaction csSubscription { get; private set; }
	
	/**
	 * Prepares the hop controller setting up the necessary data required
	 * to submit to the HOP to disply the payment entry fields.  Will also handle
	 * any post processing in the event of a payment rejection.
	 */
	public cc_ctrl_CyberSourceHOP_va() {
		this.ipAddressLocation = Apexpages.currentPage().getParameters().get(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY);
		this.currentCartID = ApexPages.currentPage().getParameters().get('cartID');
		processCart();
		//debug();
	}
	
	/**
	 * Processes the cart, retrieving the cart currency, addresses and
	 * amounts, along with information needed to determine the appropriate
	 * merchant.  Based on the processing, will determine if this is a standard
	 * transaction or a subscription based one.
	 */
	public void processCart() {
		if(currentCartID == null && Test.isRunningTest()){
			E_Cart__c testcart = [select Id from E_Cart__c limit 1];
			currentCartID = testcart.Id;
		}
		E_Cart__c cart = cc_dao_Cart_va.retrieveCartHeaderAddresses(currentCartID);
		sfCartName = cart.name;
		billingAddress = new cc_bean_MockContactAddress(cart.BillTo__r);
		shippingAddress = new cc_bean_MockContactAddress(cart.ShipTo__r);
		List<E_CartItem__c> cartItems = cc_dao_Cart_va.getDisplayCartItems(currentCartID);
		Map<String, Decimal> totals = cc_kap_utils_Cart.calculateCartTotals(cartItems);
		cc_kap_api_rules_CartRules cartRulesAPI = new cc_kap_api_rules_CartRules(cartItems);
		Double shippingAmount = cart.ShipAmount__c;
		if (shippingAmount == null) {
			if (cartRulesAPI != null)
    			shippingAmount = cc_kap_utils_Cart.calculateLineBasedShipping(cartRulesAPI, shippingAddress.country, totals.get(cc_kap_utils_AppConstants.TOTALS_UPFRONT));
		}
		String region = '';
		Set<String> regions = cartRulesAPI.getSpecValues(cc_kap_utils_AppConstants.SPEC_REGION);
		if(regions !=  null){
		for (String r: regions) {
			region = r;
			break;
		}}
		else if (Test.isRunningTest()){
			region = 'US';
		}
		E_CCKapPaymentSettings__c paySettings = cc_kap_utils_AppUtils.getPaymentSettings(region);
		if (paySettings == null)
			paySettings = cc_kap_utils_AppUtils.getPaymentSettings('US');
		String merchantId = paySettings == null ? '' : paySettings.Merchant_ID__c;
		String serialNumber = paySettings == null ? '' : paySettings.Serial_Number__c;
		String sharedSecret = paySettings == null ? '' : paySettings.Shared_Secret__c;
		if(Test.isRunningTest()){
			merchantId = 'test';
			serialNumber = 'test';
			sharedSecret = 'test';
		}
		csTransaction = new cc_payment_cs_bean_Transaction(merchantId, sharedSecret, serialNumber);
		if (cart.CurrencyISOCode__c == null)
			csTransaction.currencyCode = 'usd';
		else
			csTransaction.currencyCode = cart.CurrencyISOCode__c;
		csTransaction.amount = String.valueOf(totals.get(cc_kap_utils_AppConstants.TOTALS_UPFRONT) + shippingAmount);
		if (totals.get(cc_kap_utils_AppConstants.TOTALS_INSTALLS) > 1 || true) {
			csTransaction.transactionType = 'sale,subscription';
			csSubscription = new cc_payment_cs_bean_SubscriptionTransaction(sharedSecret);
			csSubscription.numPayments = String.valueOf(totals.get(cc_kap_utils_AppConstants.TOTALS_INSTALLS).setScale(0));
		}
		else
			csTransaction.transactionType = 'sale';
	}
	
	public PageReference handleErrors() {
		return null;
	}
	
	private void debug() {
		csTransaction.amount = '2100';
	}
	
	
	/**
	 * Holds the basic transaction information and data needed to post
	 * the payment to the processor.
	 */
	public with sharing class cc_payment_cs_bean_Transaction {
		public String transactionType { get; set; }
		public String publicDigest;
		public String currencyCode { get; set; }
		public String amount { get; set; }
		public String merchantID { get; private set; }
	    public String sharedSecret { get; private set; }
	    public String serialNumber { get; private set; }
	    public String currTime { get; private set; }
		
		public cc_payment_cs_bean_Transaction(String merchantID, String sharedSecret, String serialNumber) {
			this.merchantID = merchantID;
			this.sharedSecret = sharedSecret;
			this.serialNumber = serialNumber;
			this.currTime = String.valueOf(System.currentTimeMillis());
		}
		
		public String getPublicDigest() {
			if (publicDigest == null)
				createSignature();
			return publicDigest;
		}
		
		public  void createSignature() {
			try {
				String customValues = merchantID + amount + currencyCode + currTime;
				publicDigest = EncodingUtil.base64Encode(Crypto.generateMac('HmacSHA1', Blob.valueOf(customValues), Blob.valueOf(sharedSecret)));
				publicDigest = publicDigest.replaceAll('\n', '');
			}
			catch(Exception e) {
				publicDigest = null;
			}
		}
		
	}
	
	/**
	 * Holds the basic subscription information and data needed to post
	 * the payment to the processor.
	 */
	public with sharing class cc_payment_cs_bean_SubscriptionTransaction {
		public String publicSubscriptionDigest;
		public String amount  {get;set;}
		public String startDate  {get;set;}
		public String numPayments  {get;set;}
		public String frequency  {get;set;}
		public String autoRenew  {get;set;}
		public String sharedSecret { get; private set; }
		
		public cc_payment_cs_bean_SubscriptionTransaction(String sharedSecret) {
			this.sharedSecret = sharedSecret;
			this.amount = '0.0';
			this.frequency = 'on-demand';
			this.autoRenew = 'false';
        	Datetime dt = system.today().addDays(2);
        	this.startDate = dt.format('yyyyMMdd'); 
		}
		
		public String getPublicSubscriptionDigest() {
			if (publicSubscriptionDigest == null)
				createSubscriptionSignature();
			return publicSubscriptionDigest;
		}
		
		private void createSubscriptionSignature() {
			try {			
				String customValues = amount + startDate + frequency + numPayments + autoRenew;
				publicSubscriptionDigest = EncodingUtil.base64Encode(Crypto.generateMac('HmacSHA1', Blob.valueOf(customValues), Blob.valueOf(sharedSecret)));
				publicSubscriptionDigest = publicSubscriptionDigest.replaceAll('\n', '');
			}
			catch (Exception e) {
				publicSubscriptionDigest = null;
			}
		}
	}
		
	public String getPostalCode(){
		return this.billingAddress.postalCode == null ? '10018' : this.billingAddress.postalCode;
	}
}