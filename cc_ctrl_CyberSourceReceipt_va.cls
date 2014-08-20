/**
// * Created by CloudCraze, LLC.
// * Copyright 2010-12 CloudCraze, LLC. All rights reserved
// * @Description: Handles cybersource HOP integration.
// * @Author: 1.0
// * @File: cc_ctrl_CyberSourceHOP
// * =======================================================================================
// * 2012/08/30 1.1 IL -  Refactored
**/
public without sharing class cc_ctrl_CyberSourceReceipt_va {
	public Map<String,String> myData {get; set; }
	public List<String> responseData { get;  set; }
	public String currentCartId { get; set; }
	public String errorCode { get; set; }
	public String errorMessage { get; set; }
	public String avsCode { get; set; }
	public String cvnCode { get; set; }
    public String result { get; private set; }
    public String decision { get; private set; }
	public String authCode { get; private set; }
    public String subscriptionId { get; private set; }
    public String cardNumber { get; private set; }
    public String cardType { get; private set; }
    public String expMonth { get; private set; }
    public String expYear { get; private set; }
    public String ipAddressLocation{ get; set; }
	public String ipAddressLocationKey { get { return cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY; } set; }
    public cc_extn_OrderReview reviewcontroller {get; set;}

	public cc_ctrl_CyberSourceReceipt_va(ApexPages.StandardController c) {
		this();
	}
	
	public cc_ctrl_CyberSourceReceipt_va() {
		init();
		//debug();
	}
	
	public void debug() {
		result = 'DEBUG';
		responseData = new List<String>();
		for (String key: Apexpages.currentPage().getParameters().keySet())
			responseData.add(key + '=' +Apexpages.currentPage().getParameters().get(key) + '\n');
	}
	
	/**
	 * Takes in the parameters passed in the response from the cybersource hop, and proceses
	 * based on the decision made by cybersource.  If accepted, captures the card info, auth and 
	 * subscription codes.  If it was rejected, captures the reason code, along with the avs and cv
	 * reason codes.
	 */
	public void init() {
		this.currentCartId = Apexpages.currentPage().getParameters().get('cartID');
		decision = Apexpages.currentPage().getParameters().get('decision');
		if (!al.StringUtils.isBlank(decision)) {
			this.result = decision;
			if (decision == 'ACCEPT') {
				this.authCode = Apexpages.currentPage().getParameters().get('ccAuthReply_authorizationCode');
				this.subscriptionId = Apexpages.currentPage().getParameters().get('paySubscriptionCreateReply_subscriptionID');
				this.cardNumber = Apexpages.currentPage().getParameters().get('card_accountNumber');
				this.cardNumber = al.StringUtils.replace(cardNumber, '#', 'X');
				this.cardType = Apexpages.currentPage().getParameters().get('card_cardType');
				this.cardType = cc_kap_utils_AppUtils.getCreditCardNameByCode(this.cardType);
				this.expMonth = Apexpages.currentPage().getParameters().get('card_expirationMonth');
				this.expYear = Apexpages.currentPage().getParameters().get('card_expirationYear');
				
			}
			else {
				this.errorCode = Apexpages.currentPage().getParameters().get('ccAuthReply_reasonCode');
				this.avsCode = Apexpages.currentPage().getParameters().get('ccAuthReply_avsCode');
				this.cvnCode = Apexpages.currentPage().getParameters().get('ccAuthReply_cvCode');
				translateErrors();
			}
		}
		if(!Test.isRunningTest())
			this.ipAddressLocation = Apexpages.currentPage().getParameters().get(ipAddressLocationKey);
	}
	
	/**
	 * Translates the error code, avs code and cv code into a meaningful error message
	 * to display to the end user.
	 */
	 private void translateErrors() {
	 	if (avsCode != null && cc_kap_utils_AppConstants.PAYMENT_AVS_ERROR_CODES.contains(avsCode))
	 		this.errorMessage = System.Label.Kap_Pay_AVS_Error;
	 	else if (cvnCode != null && cc_kap_utils_AppConstants.PAYMENT_CV_ERROR_CODES.contains(cvnCode))
	 		this.errorMessage = System.Label.Kap_Pay_CV_Error;
	 	else
	 		this.errorMessage = System.Label.Kap_Pay_Error;

	 		System.debug(LoggingLevel.INFO, 'AH Error ' + this.errorMessage);

	 }
	 
	
}