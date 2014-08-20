public with sharing class ktp_cc_GR_rules_bean_CartDataRulesBean {
    public String sku { get; set; }
    public String code { get; set; }
    public String parentCode { get; set; }
    public String productDeliveryType { get; set; }
    public String sbuCode { get; set; }
    public String displayDeliveryType { get; set; }
    public Boolean showSchedulingLink { get; set; }
    public List<ktp_cc_rules_bean_CartDataInstallPrice> availableInstallments { get; set; }
    public Integer selectedInstallment { get; set; }
    public String flexStartType { get;  set; }
    public Integer flexStartRange { get; set; }
    public String selectedFlexStartDate { get; set; }
    public DateTime classStartDate { get; set; }
    public DateTime classEndDate { get; set; }
    public String location { get; set; }
    public String programCode { get; set; }
    public String fullSpecs { get; set; }
    public ccrz__E_CartItem__c line {get; set; }
    public DateTime flexDate { get; set; }
    public DateTime flexEndDate { get; set; }
    public String centerId { get; set; }
    public Boolean IBFee{
        get{
            System.debug(LoggingLevel.INFO, '$$IBFee=' + IBFee);
            if(IBFee == NULL)
                return false; 
            return IBFee;   
        }
        set;
    }
    
    public ktp_cc_GR_rules_bean_CartDataRulesBean(ccrz__E_CartItem__c line) {
        this.code = line.ccrz__Product__r.Code__c;
        this.classStartDate = line.ccrz__Product__r.ClassStartDate__c;
        this.classEndDate = line.ccrz__Product__r.ClassEndDate__c;
        this.location = line.ccrz__Product__r.Country__c;
        this.line = line;
        this.availableInstallments = new List<ktp_cc_rules_bean_CartDataInstallPrice>();
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
        if (line.ccrz__Product__r.ccrz__ParentProduct__c != null)
            this.parentCode = line.ccrz__Product__r.ccrz__ParentProduct__r.Code__c;
        this.centerId = line.ccrz__Product__r.CenterId__c;
    }
    
    public void setProductDeliveryType(String productDeliveryType, String description) {
        this.productDeliveryType = productDeliveryType;
        this.displayDeliveryType = description;
    }
    
    public String addAvailableInstallment(Decimal listPrice, Integer installments, String currencyCode) {
        ktp_cc_rules_bean_CartDataInstallPrice priceBean = new ktp_cc_rules_bean_CartDataInstallPrice(line, listPrice, installments);
        availableInstallments.add(priceBean);
        if (selectedInstallment == 1 || selectedInstallment != installments)
            return null;
        else {
            ktp_cc_ctrl_Formatter formatter = new ktp_cc_ctrl_Formatter(currencyCode, String.valueOf(priceBean.offeredPrice.round(System.RoundingMode.DOWN)));
            return 'For ' + line.ccrz__Product__r.Name + ': You will be charged ' + (selectedInstallment-1) + ' additional installment(s) of  ' + formatter.formatCurrency;
        }
    }
    
}