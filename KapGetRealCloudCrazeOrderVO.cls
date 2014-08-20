/*
Description   : A Value Object (VO) used to hold CloudCraze order data
*/
public with sharing class KapGetRealCloudCrazeOrderVO {
	public List<KapGetRealPaymentMethodVO> paymentMethodList {get; set;}
	public List<KapGetRealCCOrderItemVO> itemList {get; set;}
}