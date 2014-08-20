/*
Description   : A Value Object (VO) used to hold line-item level payment data,
with references to order-level payment methods, for a CloudCraze order
*/
public with sharing class KapGetRealPaymentVO {

	public Integer index{get; set;}
	public Integer payMethodIndex{get; set;}
	public Decimal amount {get; set;}
	public String cc_authCode{get; set;}
	public String cc_subscriptionId{get; set;}
	public String cc_batchId{get; set;}
	public String cc_settlmentDate{get; set;}
}