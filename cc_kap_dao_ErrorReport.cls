public with sharing class cc_kap_dao_ErrorReport {

	public static List<ErrorReportEntry__c> getErrorReportEntries(){
	
		List <ErrorReportEntry__c> entries = [Select EC_SOURCE_ID__C, STUDENTID__C, FIRSTNAME__C, LASTNAME__C,BILLADDR1__C, BILLADDR2__C, BILLCITY__C,BILLSTATE__C, 
		BILLCOUNTRY__C, BILLPOSTALCODE__C, SHIPADDR1__C, SHIPADDR2__C, SHIPCITY__C, SHIPSTATE__C, SHIPCOUNTRY__C, SHIPPOSTALCODE__C, BILLPHONENUMBER__C, SHIPPHONENUMBER__C, 
		EMAIL__C, SCHOOLNAME__C, GRADYEAR__C, CENTERID__C, COURSEOFINTEREST__C, EXPECTEDSTARTDATE__C, EXPECTEDEXAMDATE__C, LEADSOURCECODE__C, TRANSACTIONCODE__C, CLASSCODE__C, 
		CLASSID__C, BASEFEE__C, FEEADJUSTMENT__C, SHIPPINGMETHOD__C, SHIPPINGFEE__C, PAYMENTTYPE__C, CCEXPIRATIONDATE__C, PAYMENTAMOUNT__C, CCAUTHCODE__C, CCBATCHID__C, 
		CCSETTLEMENTDATE__C, CYBERSOURCEREQUESTID__C, SIBLINGCCCNUMBER__C, MODULEID1__C, MODULEID2__C,MODULEID3__C, MODULEID4__C, MODULEID5__C, MODULECODE1__C, MODULECODE2__C, 
		MODULECODE3__C, MODULECODE4__C, MODULECODE5__C,  SUBSCRIPTIONID__C, MASKEDCCNUMBER__C, CREDITCARDTYPE__C From ErrorReportEntry__c where Exported_Date__c = null and GetRealResultCode__c not in ('-2000', '10', '-30', '-50') and BaseFee__c > 0 order by CreatedDate desc];
		
		return entries;
	}

	/*
	public static List<ErrorReportEntry__c> getFreeErrorReportEntries(){
	
		List <ErrorReportEntry__c> entries = [Select EC_SOURCE_ID__C, STUDENTID__C, FIRSTNAME__C, LASTNAME__C,BILLADDR1__C, BILLADDR2__C, BILLCITY__C,BILLSTATE__C, 
		BILLCOUNTRY__C, BILLPOSTALCODE__C, SHIPADDR1__C, SHIPADDR2__C, SHIPCITY__C, SHIPSTATE__C, SHIPCOUNTRY__C, SHIPPOSTALCODE__C, BILLPHONENUMBER__C, SHIPPHONENUMBER__C, 
		EMAIL__C, SCHOOLNAME__C, GRADYEAR__C, CENTERID__C, COURSEOFINTEREST__C, EXPECTEDSTARTDATE__C, EXPECTEDEXAMDATE__C, LEADSOURCECODE__C, TRANSACTIONCODE__C, CLASSCODE__C, 
		CLASSID__C, BASEFEE__C, FEEADJUSTMENT__C, SHIPPINGMETHOD__C, SHIPPINGFEE__C, PAYMENTTYPE__C, CCEXPIRATIONDATE__C, PAYMENTAMOUNT__C, CCAUTHCODE__C, CCBATCHID__C, 
		CCSETTLEMENTDATE__C, CYBERSOURCEREQUESTID__C, SIBLINGCCCNUMBER__C, MODULEID1__C, MODULEID2__C,MODULEID3__C, MODULEID4__C, MODULEID5__C, MODULECODE1__C, MODULECODE2__C, 
		MODULECODE3__C, MODULECODE4__C, MODULECODE5__C,  SUBSCRIPTIONID__C, MASKEDCCNUMBER__C, CREDITCARDTYPE__C From ErrorReportEntry__c where Exported_Date__c = null and GetRealResultCode__c not in ('-2000', '10', '-30', '-50') and BaseFee__c = 0 order by CreatedDate desc];
		
		return entries;
	}
	
		public static List<ErrorReportEntry__c> getPaidErrorReportEntries(){
	
		List <ErrorReportEntry__c> entries = [Select EC_SOURCE_ID__C, STUDENTID__C, FIRSTNAME__C, LASTNAME__C,BILLADDR1__C, BILLADDR2__C, BILLCITY__C,BILLSTATE__C, 
		BILLCOUNTRY__C, BILLPOSTALCODE__C, SHIPADDR1__C, SHIPADDR2__C, SHIPCITY__C, SHIPSTATE__C, SHIPCOUNTRY__C, SHIPPOSTALCODE__C, BILLPHONENUMBER__C, SHIPPHONENUMBER__C, 
		EMAIL__C, SCHOOLNAME__C, GRADYEAR__C, CENTERID__C, COURSEOFINTEREST__C, EXPECTEDSTARTDATE__C, EXPECTEDEXAMDATE__C, LEADSOURCECODE__C, TRANSACTIONCODE__C, CLASSCODE__C, 
		CLASSID__C, BASEFEE__C, FEEADJUSTMENT__C, SHIPPINGMETHOD__C, SHIPPINGFEE__C, PAYMENTTYPE__C, CCEXPIRATIONDATE__C, PAYMENTAMOUNT__C, CCAUTHCODE__C, CCBATCHID__C, 
		CCSETTLEMENTDATE__C, CYBERSOURCEREQUESTID__C, SIBLINGCCCNUMBER__C, MODULEID1__C, MODULEID2__C,MODULEID3__C, MODULEID4__C, MODULEID5__C, MODULECODE1__C, MODULECODE2__C, 
		MODULECODE3__C, MODULECODE4__C, MODULECODE5__C,  SUBSCRIPTIONID__C, MASKEDCCNUMBER__C, CREDITCARDTYPE__C From ErrorReportEntry__c where Exported_Date__c = null and GetRealResultCode__c not in ('-2000', '10', '-30') and BaseFee__c > 0 order by CreatedDate desc];
		
		return entries;
	}
	*/
	
	// *************************************** CW - EC Error File Time Out Fix - BEGIN ***************************************
	public static List<ErrorReportEntry__c> getFreeErrorReportEntries(){
	
		List <ErrorReportEntry__c> entries = [Select EC_SOURCE_ID__C, STUDENTID__C, FIRSTNAME__C, LASTNAME__C,BILLADDR1__C, BILLADDR2__C, BILLCITY__C,BILLSTATE__C, 
		BILLCOUNTRY__C, BILLPOSTALCODE__C, SHIPADDR1__C, SHIPADDR2__C, SHIPCITY__C, SHIPSTATE__C, SHIPCOUNTRY__C, SHIPPOSTALCODE__C, BILLPHONENUMBER__C, SHIPPHONENUMBER__C, 
		EMAIL__C, SCHOOLNAME__C, GRADYEAR__C, CENTERID__C, COURSEOFINTEREST__C, EXPECTEDSTARTDATE__C, EXPECTEDEXAMDATE__C, LEADSOURCECODE__C, TRANSACTIONCODE__C, CLASSCODE__C, 
		CLASSID__C, BASEFEE__C, FEEADJUSTMENT__C, SHIPPINGMETHOD__C, SHIPPINGFEE__C, PAYMENTTYPE__C, CCEXPIRATIONDATE__C, PAYMENTAMOUNT__C, CCAUTHCODE__C, CCBATCHID__C, 
		CCSETTLEMENTDATE__C, CYBERSOURCEREQUESTID__C, SIBLINGCCCNUMBER__C, MODULEID1__C, MODULEID2__C,MODULEID3__C, MODULEID4__C, MODULEID5__C, MODULECODE1__C, MODULECODE2__C, 
		MODULECODE3__C, MODULECODE4__C, MODULECODE5__C,  SUBSCRIPTIONID__C, MASKEDCCNUMBER__C, CREDITCARDTYPE__C From ErrorReportEntry__c where Exported__c = false and GetRealResultCode__c in ('25', '20', '5', '0', '-10', '-20', '-21', '-35', '-40', '-60', '-70', '-80') and BaseFee__c = 0 order by CreatedDate desc limit 100];
		
		return entries;
	}
	
	public static List<ErrorReportEntry__c> getPaidErrorReportEntries(){
	
		List <ErrorReportEntry__c> entries = [Select EC_SOURCE_ID__C, STUDENTID__C, FIRSTNAME__C, LASTNAME__C,BILLADDR1__C, BILLADDR2__C, BILLCITY__C,BILLSTATE__C, 
		BILLCOUNTRY__C, BILLPOSTALCODE__C, SHIPADDR1__C, SHIPADDR2__C, SHIPCITY__C, SHIPSTATE__C, SHIPCOUNTRY__C, SHIPPOSTALCODE__C, BILLPHONENUMBER__C, SHIPPHONENUMBER__C, 
		EMAIL__C, SCHOOLNAME__C, GRADYEAR__C, CENTERID__C, COURSEOFINTEREST__C, EXPECTEDSTARTDATE__C, EXPECTEDEXAMDATE__C, LEADSOURCECODE__C, TRANSACTIONCODE__C, CLASSCODE__C, 
		CLASSID__C, BASEFEE__C, FEEADJUSTMENT__C, SHIPPINGMETHOD__C, SHIPPINGFEE__C, PAYMENTTYPE__C, CCEXPIRATIONDATE__C, PAYMENTAMOUNT__C, CCAUTHCODE__C, CCBATCHID__C, 
		CCSETTLEMENTDATE__C, CYBERSOURCEREQUESTID__C, SIBLINGCCCNUMBER__C, MODULEID1__C, MODULEID2__C,MODULEID3__C, MODULEID4__C, MODULEID5__C, MODULECODE1__C, MODULECODE2__C, 
		MODULECODE3__C, MODULECODE4__C, MODULECODE5__C,  SUBSCRIPTIONID__C, MASKEDCCNUMBER__C, CREDITCARDTYPE__C From ErrorReportEntry__c where Exported__c = false and GetRealResultCode__c in ('-20', '-21', '-40') and BaseFee__c > 0 order by CreatedDate desc limit 100];
		
		return entries;
	}	//GetRealResultCode__c in ('25', '20', '5', '0', '-10', '-20', '-21', '-35', '-40', '-50', '-60', '-70', '-80')
	// *************************************** CW - EC Error File Time Out Fix - END ***************************************

	public static List<ErrorReportEntry__c> getFilteredErrorReportEntries(Set<String> filters){
	
		List <ErrorReportEntry__c> entries = [Select EC_SOURCE_ID__C, STUDENTID__C, FIRSTNAME__C, LASTNAME__C,BILLADDR1__C, BILLADDR2__C, BILLCITY__C,BILLSTATE__C, 
		BILLCOUNTRY__C, BILLPOSTALCODE__C, SHIPADDR1__C, SHIPADDR2__C, SHIPCITY__C, SHIPSTATE__C, SHIPCOUNTRY__C, SHIPPOSTALCODE__C, BILLPHONENUMBER__C, SHIPPHONENUMBER__C, 
		EMAIL__C, SCHOOLNAME__C, GRADYEAR__C, CENTERID__C, COURSEOFINTEREST__C, EXPECTEDSTARTDATE__C, EXPECTEDEXAMDATE__C, LEADSOURCECODE__C, TRANSACTIONCODE__C, CLASSCODE__C, 
		CLASSID__C, BASEFEE__C, FEEADJUSTMENT__C, SHIPPINGMETHOD__C, SHIPPINGFEE__C, PAYMENTTYPE__C, CCEXPIRATIONDATE__C, PAYMENTAMOUNT__C, CCAUTHCODE__C, CCBATCHID__C, 
		CCSETTLEMENTDATE__C, CYBERSOURCEREQUESTID__C, SIBLINGCCCNUMBER__C, MODULEID1__C, MODULEID2__C,MODULEID3__C, MODULEID4__C, MODULEID5__C, MODULECODE1__C, MODULECODE2__C, 
		MODULECODE3__C, MODULECODE4__C, MODULECODE5__C,  SUBSCRIPTIONID__C, MASKEDCCNUMBER__C, CREDITCARDTYPE__C From ErrorReportEntry__c where Exported_Date__c = null and GetRealResultCode__c in ('-2000', '10', '-30', '-50') and BaseFee__c > 0 order by CreatedDate desc];
		
		return entries;
	}
}