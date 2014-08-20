public class cc_ctrl_RichText {
	//==================================================
	// INSTANCE PROPERTIES
	//==================================================
	public boolean rendered { get;set; }
	public String text { get;set; }
	
	//==================================================
	// CONSTRUCTOR
	//==================================================
	public cc_ctrl_RichText() {
		// Default value for rendered is true
		this.rendered = true;
	}

	//==================================================
	// SERVICE METHODS
	//==================================================
	public E_LocaleFormatter__c getFormatted() {
		E_LocaleFormatter__c formatter = new E_LocaleFormatter__c();
		if (this.text != null && !''.equals(this.text)) {
			formatter.RichText__c = text;
			// formatter.CurrencyIsoCode = 'USD';
		}
		return formatter;
	}
	
	static testMethod void myUnitTest() {
		cc_ctrl_RichText richText = new cc_ctrl_RichText();
		richText.text = 'test';
		System.assert(richText.getFormatted() != null);
		System.assert(richText.getFormatted().RichText__c.equals(richText.text));
	}
}