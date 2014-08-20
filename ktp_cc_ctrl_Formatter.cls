public with sharing class ktp_cc_ctrl_Formatter {
 //==================================================
  // INSTANCE PROPERTIES
  //==================================================
  public boolean rendered {get; set;}
  public String num {get; set;}
  public Double numerator { get; set; }
  public Double denominator { get; set; }
  public String currencyCode { get; set; }
  //==================================================
  // CONSTRUCTOR
  //==================================================
  public ktp_cc_ctrl_Formatter(){
  	//Default value for rendered is true
  	this.rendered = true;
  	numerator=1;
  	denominator=1;
  	
  }
  
  public ktp_cc_ctrl_Formatter(String currencyCode, String num){
  	//Default value for rendered is true
  	this.rendered = true;
  	numerator=1;
  	denominator=1;
  	this.currencyCode = currencyCode;
  	this.num = num;
  }
  
  //==================================================
  // SERVICE METHODS
  //==================================================
  public ccrz__E_LocaleFormatter__c getFormatted(){
  	ccrz__E_LocaleFormatter__c formatter = new ccrz__E_LocaleFormatter__c();
  	formatter.ccrz__Currency__c = 0.0;
  	if(this.num != null && !''.equals(this.num)){
  	  formatter.ccrz__Currency__c = Decimal.valueOf(num);
  	  //formatter.CurrencyIsoCode = 'USD';
  	} 
  	
  	if(numerator != null && denominator != null && denominator != 0) {
  		formatter.ccrz__Percent__c = numerator/denominator * 100;
  	}
  	return formatter;
  }
  
	public String formatCurrency {
		get {
	  		if (currencyCode == null)
	  			currencyCode = 'USD';
			ktp_cc_CurrencyFormatter formatter = new ktp_cc_CurrencyFormatter();
			return formatter.format(currencyCode, num);
		}
		set;
	}
  

	public class ktp_cc_CurrencyFormatter {
		Map<String, ktp_cc_CurrencyEntry> currencyEntries { get; private set; }
		
		public 	ktp_cc_CurrencyFormatter() {
			currencyEntries = new Map<String, ktp_cc_CurrencyEntry>();
			currencyEntries.put('USD', new ktp_cc_CurrencyEntry(',', '.', '$', 'USD', '[SYMBOL][VALUE]'));
			currencyEntries.put('CAD', new ktp_cc_CurrencyEntry(',', '.', '$', 'CAD', '[VALUE] [CODE]'));
			currencyEntries.put('EUR_Germany', new ktp_cc_CurrencyEntry('.', ',', '€', 'EUR', '[VALUE][SYMBOL]'));
			currencyEntries.put('GBP', new ktp_cc_CurrencyEntry(',', '.', '£', 'GBP', '[SYMBOL][VALUE]'));
			currencyEntries.put('Default', new ktp_cc_CurrencyEntry(',', '.', '', '', '[VALUE]'));
		}
		
		public String format(String currCode, String value) {
			ktp_cc_CurrencyEntry entry = currencyEntries.get(currCode);
			if (entry == null)
				entry = currencyEntries.get('Default');
			return entry.format(value);
		}
	}
	
	
	public class ktp_cc_CurrencyEntry {
		public String separator { get; set; }
		public String decimalSeparator { get; set; }
		public String currencySymbol { get; set; }
		public String currencyCode { get; set; }
		public String format { get; set; }
		
		public ktp_cc_CurrencyEntry(String separator, String decimalSeparator, String currencySymbol, String currencyCode, String format) {
			this.separator = separator;
			this.decimalSeparator = decimalSeparator;
			this.currencySymbol = currencySymbol;
			this.currencyCode = currencyCode;
			this.format = format;
		}
		
		public String format(String num) {
			//TODO jll temp fix
			if( num == null || num == '')
				num = '0.00';
			ccrz__E_LocaleFormatter__c formatter = new ccrz__E_LocaleFormatter__c();
  			formatter.ccrz__Currency__c = Decimal.valueOf(num);
  			String formatted = doFormatting(formatter.ccrz__Currency__c, separator, decimalSeparator);
  			String retVal = format;
  			retVal = al.StringUtils.replace(retVal, '[SYMBOL]', currencySymbol);
  			retVal = al.StringUtils.replace(retVal, '[VALUE]', formatted);
  			retVal = al.StringUtils.replace(retVal, '[CODE]', currencyCode);
  			return retVal;
		}
		
		public String doFormatting(Decimal val, String osep, String nsep) {
			String s, tmp; Integer i = 6;
			s = val.setScale(2).toPlainString().replace(osep, nsep);
			while(s.length() > i)
			{
				tmp = s.substring(0, s.length() - i) + osep + s.substring(s.length() - i);
				s = tmp;
				i += 4;
			}
			return s;
		}
	}

	/*static public testMethod void ktp_cc_CurrencyEntryTest() {
		//test for English (United States) format
		ktp_cc_CurrencyFormatter formatter = new ktp_cc_CurrencyFormatter();
		String results1 = formatter.format('USD', '1234.56');
		System.assertEquals('$1,234.56', results1); 
		results1 = formatter.format('USD', '1234567');
		System.assertEquals('$1,234,567.00', results1); 
		results1 = formatter.format('CAD', '1234.56');
		System.assertEquals('1,234.56 CAD', results1); 
		results1 = formatter.format('GBP', '1234.56');
		System.assertEquals('£1,234.56', results1); 
		results1 = formatter.format('EUR_Germany', '1234.56');
		System.assertEquals('1.234,56€', results1); 
	}*/
}