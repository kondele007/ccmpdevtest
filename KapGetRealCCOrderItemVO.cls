/*
Description   : A Value Object (VO) used to hold line items for CloudCraze orders
*/
public with sharing class KapGetRealCCOrderItemVO {

    public String productCode{get; set;}
    public String classId{get; set;}
    public String client_sys_id{get; set;}
    public String studyCenter{get; set;}
    public String startDate{get; set;}
    public String endDate{get; set;}
    public String transactionCode{get; set;}
    public Decimal basePrice{get; set;}
    public Decimal discountAmount{get; set;}
    public String deliveryType{get; set;}
    public Integer installmentsRemaining{get; set;}
    public Integer balanceRemaining{get; set;}
    public String discountCode{get; set;}
    //Roster Changes
    public Decimal channel{get; set;}
    public Decimal balanceDue { get; set; }
    public String centerCode { get; set; }
    public Boolean isIBFee{get; set;}
    
    public ktp_cc_bean_MockOrderItem ccItemBean{get; set;}
    public List<KapGetRealPaymentVO> payments{get; set;}
    public KapGetRealShippingMethodVO shippingMethod{get; set;}
}