public with sharing class cc_kap_rules_bean_CartDataRulesBean_va {
	public String sku { get; set; }
	public String code { get; set; }
	public String parentCode { get; set; }
	public String productDeliveryType { get; set; }
	public String sbuCode { get; set; }
	public String displayDeliveryType { get; set; }
	public Boolean showSchedulingLink { get; set; }
	public List<cc_kap_rules_bean_CartDataInstallPrice> availableInstallments { get; set; }
	public Integer selectedInstallment { get; set; }
	public String flexStartType { get;  set; }
	public Integer flexStartRange { get; set; }
	public String selectedFlexStartDate { get; set; }
	public DateTime classStartDate { get; set; }
	public DateTime classEndDate { get; set; }
	public String location { get; set; }
	public String programCode { get; set; }
	public String fullSpecs { get; set; }
	public E_CartItem__c line {get; set; }
	public DateTime flexDate { get; set; }
	public DateTime flexEndDate { get; set; }
	public String centerId { get; set; }
	
	public cc_kap_rules_bean_CartDataRulesBean_va(E_CartItem__c line) {
		this.code = line.Product__r.Code__c;
		this.classStartDate = line.Product__r.ClassStartDate__c;
		this.classEndDate = line.Product__r.ClassEndDate__c;
		this.location = line.Product__r.Country__c;
		this.line = line;
		this.availableInstallments = new List<cc_kap_rules_bean_CartDataInstallPrice>();
		this.flexStartType = '0';
		if (line.Billing_Installments__c == null)
			line.Billing_Installments__c = 1;
		this.selectedInstallment = Integer.valueOf(line.Billing_Installments__c);
		System.debug(LoggingLevel.INFO,'line.Flex_Date__c --' + line.Flex_Date__c);
		if (line.Flex_Date__c != null) {
			this.flexDate = line.Flex_Date__c;
			this.selectedFlexStartDate = line.Flex_Date__c.format();
		}
		System.debug(LoggingLevel.INFO,'line.Flex_End_Date__c --' + line.Flex_End_Date__c);
		if (line.Flex_End_Date__c != null) {
			this.flexEndDate = line.Flex_End_Date__c;
		}
		if (line.Product__r.ParentProduct__c != null)
			this.parentCode = line.Product__r.ParentProduct__r.Code__c;
		this.centerId = line.Product__r.CenterId__c;
	}
	
	public void setProductDeliveryType(String productDeliveryType, String description) {
		this.productDeliveryType = productDeliveryType;
		this.displayDeliveryType = description;
	}
	
	public String addAvailableInstallment(Decimal listPrice, Integer installments, String currencyCode) {
		cc_kap_rules_bean_CartDataInstallPrice priceBean = new cc_kap_rules_bean_CartDataInstallPrice(line, listPrice, installments);
		availableInstallments.add(priceBean);
		if (selectedInstallment == 1 || selectedInstallment != installments)
			return null;
		else {
			cc_ctrl_Formatter formatter = new cc_ctrl_Formatter(currencyCode, String.valueOf(priceBean.offeredPrice.round(System.RoundingMode.DOWN)));
			return 'For ' + line.Product__r.Name + ': You will be charged ' + (selectedInstallment-1) + ' additional installment(s) of  ' + formatter.formatCurrency;
		}
	}
	
}