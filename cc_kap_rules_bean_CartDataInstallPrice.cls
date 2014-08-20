public with sharing class cc_kap_rules_bean_CartDataInstallPrice {
	public Decimal listPrice { get; set; }
	public Decimal offeredPrice { get; set; }
	public Decimal discountedPrice { get; set; }
	public Decimal discount { get; set; }
	public Decimal couponDiscount { get; set; }
	public Integer installments { get; set; }
	public String displayText { get; private set; }
	public String displayList { get; private set; }
	public Decimal totalDiscount { get; private set; }
	public String selectedVal { get; private set; }
	
	public cc_kap_rules_bean_CartDataInstallPrice(E_CartItem__c line, Decimal listPrice, Integer installments) {
		System.debug(LoggingLevel.INFO,'@@Amount line='+ listPrice);
		this.discountedPrice = line.SubAmount__c;
		if (line.Price__c != null)
			this.offeredPrice = line.Price__c/installments;
		if (line.AbsoluteDiscount__c != null) {
    		this.couponDiscount = line.AbsoluteDiscount__c/installments;
    		this.offeredPrice -= this.couponDiscount;
		}
    	this.installments = installments;
    	if (listPrice != null) {
    		this.listPrice = listPrice/installments;
    		this.discount = (listPrice - line.Price__c)/installments;
    	}
    	this.displayText = installments + ' installment';
    	if (installments > 1)
    		displayText += 's ';
    	displayText += ' of  ';
    	cc_ctrl_Formatter formatter = new cc_ctrl_Formatter();
    	if (this.listPrice == null)
    		this.listPrice = offeredPrice;
    	if (this.listPrice != null && this.listPrice == offeredPrice)
    		this.displayList = '';
    	else {
			formatter.num = '' + this.listPrice;
			displayList = formatter.getFormatted().Currency__c + '';
    	}
    	this.totalDiscount = 0;
    	if (this.discount != null)
    		this.totalDiscount += this.discount;
    	if (this.couponDiscount != null)
    		this.totalDiscount += this.couponDiscount;
    	if (line.Billing_Installments__c != null && Integer.valueOf(line.Billing_Installments__c) == installments)
    		selectedVal = ' checked ';
    	else
    		selectedVal = ' ';
    		
    		System.debug(LoggingLevel.INFO,'@@Amount line='+ line);
    		System.debug(LoggingLevel.INFO,'@@Amount this.listPrice='+ this.listPrice);
    		System.debug(LoggingLevel.INFO,'@@Amount this.discount='+ this.discount);
    		System.debug(LoggingLevel.INFO,'@@Amount this.offeredPricet='+ this.offeredPrice);
    		System.debug(LoggingLevel.INFO,'@@Amount this.couponDiscount='+ this.couponDiscount);

    		
	}
	
}