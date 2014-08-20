public with sharing class cc_api_dl_priceLists extends cc_api_dl_productDataLoaderBase {
	public override SObject getNewSObject(){
		return new  E_PriceList__c();
	}
	public override void deleteObject() {
		delete [Select c.Id From E_PriceList__c c where PRICELISTID__C in ('1', '2')];
	}
	public override String getDataFileName() {
		return 'priceList.xml';
	}
	public override Map<String, Schema.SObjectField> getFieldMap() {
		return Schema.SObjectType.E_PriceList__c.fields.getMap();
	}
	public override String getTestString() {
		return '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
				'<Root xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
				'<row><NAME>Enterprise</NAME ><CURRENCYISOCODE__C>USD</CURRENCYISOCODE__C ><CUSTOMERTYPECODE__C>General</CUSTOMERTYPECODE__C ><DESC__C>Enterprise Price List</DESC__C ><ENABLED__C>TRUE</ENABLED__C ><PRICELISTID__C>1</PRICELISTID__C ></row>' +
				'<row><NAME>PortalAccount</NAME ><CURRENCYISOCODE__C>USD</CURRENCYISOCODE__C ><CUSTOMERTYPECODE__C>General</CUSTOMERTYPECODE__C ><DESC__C>PortalAccount Price List</DESC__C ><ENABLED__C>TRUE</ENABLED__C ><PRICELISTID__C>2</PRICELISTID__C ></row>' +
				'</Root>';
	}
}