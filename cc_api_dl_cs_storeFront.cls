public with sharing class cc_api_dl_cs_storeFront extends cc_api_dl_customSettingsLoaderBase {
	public override SObject getNewSObject(){
		return new  E_StorefrontSettings__c();
	}
	public override void deleteObject() {
		delete [Select c.Id From E_StorefrontSettings__c c where name='DefaultStore'];
	}
	public override String getDataFileName() {
		return 'storefront.xml';
	}
	public override Map<String, Schema.SObjectField> getFieldMap() {
		return Schema.SObjectType.E_StorefrontSettings__c.fields.getMap();
	}
	
	public override String getTestString() {
		return '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
				'<Root xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
    				'<Row>' +
				        '<NAME>DefaultStore</NAME>' +
				        '<CUSTOMER_PORTAL_ACCOUNT_NAME__C>PortalAccount</CUSTOMER_PORTAL_ACCOUNT_NAME__C>' +
				        '<GOOGLE_ANALYTICS_ACCOUNT__C></GOOGLE_ANALYTICS_ACCOUNT__C>' +
				        '<GOOGLE_MAPS_API_KEY_EXTERNAL__C></GOOGLE_MAPS_API_KEY_EXTERNAL__C>' +
				        '<GOOGLE_MAPS_API_KEY_INTERNAL__C></GOOGLE_MAPS_API_KEY_INTERNAL__C>' +
				        '<SEO_DESCRIPTION__C>SEO Description</SEO_DESCRIPTION__C>' +
				        '<SEO_KEYWORDS__C>SEO Keywords</SEO_KEYWORDS__C>' +
				        '<SEO_TITLE_DETAIL__C>SEO Title Detail</SEO_TITLE_DETAIL__C>' +
				        '<SEO_TITLE_SITE__C>SEO Title Site</SEO_TITLE_SITE__C>' +
				        '<SUPPORT_URL__C>http://www.edlconsulting.com</SUPPORT_URL__C>' +
				        '<PAYPAL_API_VERSION__C>1</PAYPAL_API_VERSION__C>' +
				        '<PAYPAL_API_PASSWORD__C>paypal_password</PAYPAL_API_PASSWORD__C>' +
				        '<PAYPAL_API_USERNAME__C>paypal_username</PAYPAL_API_USERNAME__C>' +
				        '<PAYPAL_SIGNATURE__C>paypal_signature</PAYPAL_SIGNATURE__C>' +
				        '<PAYPAL_API_URL__C>http://paypaltesturl</PAYPAL_API_URL__C>' +
				        '<FEDEX_ACCOUNT_NUMBER__C>fedex_account</FEDEX_ACCOUNT_NUMBER__C>' +
				        '<FEDEX_ENDPOINT__C>http://fedextesturl</FEDEX_ENDPOINT__C>' +
				        '<FEDEX_KEY__C>fedex_key</FEDEX_KEY__C>' +
				        '<FEDEX_METER_NUMBER__C>fedex_meter</FEDEX_METER_NUMBER__C>' +
				        '<FEDEX_PASSWORD__C>fedex_password</FEDEX_PASSWORD__C>' +
				        '<UPS_ENDPOINT__C>http://upstesturl</UPS_ENDPOINT__C>' +
				        '<UPS_LICENSE__C>ups_license</UPS_LICENSE__C>' +
				        '<UPS_PASSWORD__C>ups_password</UPS_PASSWORD__C>' +
				        '<UPS_USERNAME__C>ups_username</UPS_USERNAME__C>' +
				        '<SITE_SECURE_DOMAIN__C>site.secure.force.com</SITE_SECURE_DOMAIN__C>' +
				        '<SITE_UNSECURE_DOMAIN__C>site.force.com</SITE_UNSECURE_DOMAIN__C>' +
				        '<SF_SERVER_URL__C>http://sfserverurl</SF_SERVER_URL__C>' +
        				'<ROOT_CATEGORY_NAME__C>Products</ROOT_CATEGORY_NAME__C>' + 
        				'<Root_Category_ID__c>0</Root_Category_ID__c>' +
				    '</Row>' +
				'</Root>';
	}

}