/*
Description   : A Value Object (VO) used to hold order level payment method data for a CloudCraze order
*/
public with sharing class KapGetRealPaymentMethodVO {

	public String client_sys_id{get; set;}
	public Integer index{get; set;}
	public String cc_type{get; set;}
	public String cc_maskedNumber{get; set;}
	public String encryption_key{get; set;}
	public String cc_expirationDate{get; set;}
	public String cc_subscriptionId{get; set;}
	public String cc_authCode{get; set;}
	public String name{get; set;}
	public KapGetRealAddressVO cc_billingAddress{get; set;}
	
}