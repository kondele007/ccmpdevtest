public with sharing class cc_bean_CreditCard {

	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public String cardType {get;set;}
    public String cardNumber {get;set;}
    public String cvv {get;set;}
    public String expiryDate {get;set;}
    public String expiryMonth {get;set;}
    public String expiryYear {get;set;}
    public String authCode{get; set;}
    public String subscriptionId{get; set;}
    public DateTime settlementDate { get; set; }
    public cc_bean_MockContactAddress address {get;set;}
    
	//==================================================
    // CONSTRUCTORS
    //==================================================
    public cc_bean_CreditCard() {
    	address = new cc_bean_MockContactAddress();
    }

	//==================================================
    // HELPER METHODS
    //==================================================
    public String getCardNumberLastFour() {
		String lastFour = '';
		Integer len = cardNumber.length();
		if(cardNumber != null &&  cardNumber.length() > 4) {
			lastFour = cardNumber.substring(len - 4, len);
		}
		return lastFour;
    }
    
	public String getCardNumberMasked() {
		String displayNumber = '';
		Integer len = cardNumber.length();
		if(cardNumber != null &&  cardNumber.length() > 4) {
			String lastFour = cardNumber.substring(len - 4, len);
			displayNumber = al.StringUtils.leftPad(lastFour, len, '*');
		}
		return displayNumber;
	}
	
	private static testMethod void testCreditCardBean() {
		cc_bean_CreditCard cc = new cc_bean_CreditCard();
		cc.cardNumber = '123456789012';
		String lastFour = cc.getCardNumberLastFour();
		System.debug('--- lastFour=' + lastFour);
		String displayNumber = cc.getCardNumberMasked();
		System.debug('--- displayNumber=' + displayNumber);
		System.assertEquals(cc.cardNumber.length(), displayNumber.length());
	}
}