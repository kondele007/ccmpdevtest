public with sharing class cc_kap_ctrl_ECFileGenerator {
	
	private static List<String> months = new String[]{'Jan', 'Feb', 'Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};
	
	public String filename {get;set;}
	public String reportDate {get;set;}
	
	private List<ErrorReportEntry__c> errorRows{get; set;}
	public List<cc_kap_bean_ErrorReportEntry> errorRowBeans{get; set;}
	
	public cc_kap_ctrl_ECFileGenerator(){		
		Datetime now = System.now();
		filename = 'ECFILE_' + now.year() + '_' + now.month() + '_' + now.day() + '.txt';
		reportDate = now.month() + '/' + now.day() + '/' + now.year();
		generateReport();
	}
	
	public void performQuery(){
		String reportType = ApexPages.currentPage().getParameters().get('reportType');
		if(reportType == null || reportType == 'paid')
			errorRows = cc_kap_dao_ErrorReport.getPaidErrorReportEntries();
		else if(reportType == 'free')
			errorRows = cc_kap_dao_ErrorReport.getFreeErrorReportEntries();
	}
	
	public void generateReport(){
		performQuery();
		Date todaysDate = Date.today();
		errorRowBeans = new List<cc_kap_bean_ErrorReportEntry>();
		for(ErrorReportEntry__c errorRow: errorRows)
		{
				cc_kap_bean_ErrorReportEntry errorBean = new cc_kap_bean_ErrorReportEntry(); 
				errorBean.EC_SOURCE_ID = errorRow.EC_SOURCE_ID__c; 
				errorBean.STUDENTID = errorRow.STUDENTID__c; 
				errorBean.FIRSTNAME = errorRow.FIRSTNAME__c; 
				errorBean.LASTNAME = errorRow.LASTNAME__c;
				errorBean.BILLADDR1 = errorRow.BILLADDR1__c; 
				errorBean.BILLADDR2 = errorRow.BILLADDR2__c; 
				errorBean.BILLCITY = errorRow.BILLCITY__c;
				errorBean.BILLSTATE = errorRow.BILLSTATE__c; 
				errorBean.BILLCOUNTRY = errorRow.BILLCOUNTRY__c; 
				errorBean.BILLPOSTALCODE = errorRow.BILLPOSTALCODE__c; 
				errorBean.SHIPADDR1 = errorRow.SHIPADDR1__c; 
				errorBean.SHIPADDR2 = errorRow.SHIPADDR2__c; 
				errorBean.SHIPCITY = errorRow.SHIPCITY__c; 
				errorBean.SHIPSTATE = errorRow.SHIPSTATE__c; 
				errorBean.SHIPCOUNTRY = errorRow.SHIPCOUNTRY__c; 
				errorBean.SHIPPOSTALCODE = errorRow.SHIPPOSTALCODE__c; 
				errorBean.BILLPHONENUMBER = errorRow.BILLPHONENUMBER__c; 
				errorBean.SHIPPHONENUMBER = errorRow.SHIPPHONENUMBER__c; 
				errorBean.EMAIL = errorRow.EMAIL__c; 
				errorBean.SCHOOLNAME = errorRow.SCHOOLNAME__c; 
				errorBean.GRADYEAR = errorRow.GRADYEAR__c; 
				errorBean.CENTERID = errorRow.CENTERID__c; 
				errorBean.COURSEOFINTEREST = errorRow.COURSEOFINTEREST__c == 'COURSE_OF_INTEREST' ? '' : errorRow.COURSEOFINTEREST__c; 
				errorBean.EXPECTEDSTARTDATE = scrubDate(String.valueOf(errorRow.EXPECTEDSTARTDATE__c), false); 
				errorBean.EXPECTEDEXAMDATE = String.valueOf(errorRow.EXPECTEDEXAMDATE__c) == 'EXPECTED_EXAM_DATE' ? '' : scrubDate(String.valueOf(errorRow.EXPECTEDEXAMDATE__c), false); 
				errorBean.LEADSOURCECODE = errorRow.LEADSOURCECODE__c; 
				errorBean.TRANSACTIONCODE = errorRow.TRANSACTIONCODE__c; 
				errorBean.CLASSCODE = errorRow.CLASSCODE__c; 
				errorBean.CLASSID = errorRow.CLASSID__c; 
				errorBean.BASEFEE = String.valueOf(errorRow.BASEFEE__c); 
				errorBean.FEEADJUSTMENT = String.valueOf(errorRow.FEEADJUSTMENT__c); 
				errorBean.SHIPPINGMETHOD = errorRow.SHIPPINGMETHOD__c; 
				errorBean.SHIPPINGFEE = String.valueOf(errorRow.SHIPPINGFEE__c); 
				errorBean.PAYMENTTYPE = errorRow.PAYMENTTYPE__c == 'PAYMENT_TYPE' ? '' : errorRow.PAYMENTTYPE__c; 
				errorBean.CCEXPIRATIONDATE = errorRow.CCEXPIRATIONDATE__c; 
				errorBean.PAYMENTAMOUNT = String.valueOf(errorRow.PAYMENTAMOUNT__c); 
				errorBean.CCAUTHCODE = errorRow.CCAUTHCODE__c; 
				errorBean.CCBATCHID = errorRow.CCBATCHID__c; 
				errorBean.CCSETTLEMENTDATE = scrubDate(String.valueOf(errorRow.CCSETTLEMENTDATE__c), true); 
				errorBean.CYBERSOURCEREQUESTID=  errorRow.CYBERSOURCEREQUESTID__c; 
				errorBean.SIBLINGCCCNUMBER = errorRow.SIBLINGCCCNUMBER__c; 
				errorBean.MODULEID1 = errorRow.MODULEID1__c; 
				errorBean.MODULEID2 = errorRow.MODULEID2__c;
				errorBean.MODULEID3 = errorRow.MODULEID3__c; 
				errorBean.MODULEID4 = errorRow.MODULEID4__c; 
				errorBean.MODULEID5 = errorRow.MODULEID5__c; 
				errorBean.MODULECODE1 = errorRow.MODULECODE1__c; 
				errorBean.MODULECODE2 = errorRow.MODULECODE2__c; 
				errorBean.MODULECODE3 = errorRow.MODULECODE3__c; 
				errorBean.MODULECODE4 = errorRow.MODULECODE4__c; 
				errorBean.MODULECODE5 = errorRow.MODULECODE5__c;  
				errorBean.SUBSCRIPTIONID = errorRow.SUBSCRIPTIONID__c; 
				errorBean.MASKEDCCNUMBER = errorRow.MASKEDCCNUMBER__c; 
				errorBean.CREDITCARDTYPE = errorRow.CREDITCARDTYPE__c;					
				errorRowBeans.add(errorBean);
				errorRow.Exported_Date__c = todaysDate;
				errorRow.Exported__c = true;
		}		
	}
	
	public PageReference markExported(){
		update errorRows;
		return null;
	}
	
	private String scrubDate(String dateStr, boolean isCCSettlementDate)
	{
		if(dateStr != null && dateStr.length() > 10){
			dateStr = dateStr.substring(0,10);
			List<String> elements = dateStr.split('-');
			if(isCCSettlementDate){
				dateStr = elements.get(2) + '-' + months.get(Integer.valueOf(elements.get(1)) - 1) + '-' + elements.get(0).substring(2,4);
			}
			else{
				dateStr = elements.get(1) + '/' + elements.get(2) + '/' + elements.get(0);
			}
		}
		return dateStr;
	}
}