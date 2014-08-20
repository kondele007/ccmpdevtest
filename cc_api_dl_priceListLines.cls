public with sharing class cc_api_dl_priceListLines extends cc_api_dl_productDataLoaderBase {
	 
	public override SObject getNewSObject(){
		return new  E_PriceListItem__c();
	}
	public override void deleteObject() {
		//delete [Select c.Id From E_AccountGroup__c c LIMIT 2000];
	}
	public override String getDataFileName() {
		return 'pricelistItem.xml';
	}
	public override Map<String, Schema.SObjectField> getFieldMap() {
		return Schema.SObjectType.E_PriceListItem__c.fields.getMap();
	}
	
	public override void postProcess(List<SObject> objs) {
		List<E_PriceListItem__c> cats = new List<E_PriceListItem__c>();
		for(SObject so : objs) {
			E_Product__c prod = new E_Product__c(SKU__c=String.valueOf(so.get('PRODUCT__C')));
			E_PriceList__c p = new E_PriceList__c(PRICELISTID__C=String.valueOf(so.get('PRICELIST__C')));
			Decimal price = 0.0;
			
			try {
				price = Decimal.valueOf(String.valueOf(so.get('PRICE__C')));
			} catch(Exception e) {
				price = 0.0;
			}
			cats.add(new E_PriceListItem__c(PRODUCT__R=prod, PRICELIST__R=p, PRICELISTITEMID__C=String.valueOf(so.get('PRICELISTITEMID__C')), Price__c=price));
		}
		insert cats;
	}
	public override String getTestString() {
		return '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
				'<Root xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
				'<Row><Pricelist__c>1</Pricelist__c><PRICE__C>199.99</PRICE__C><Product__c>99990</Product__c></Row><Row><Pricelist__c>1</Pricelist__c><PRICE__C>199.99</PRICE__C><Product__c>99991</Product__c></Row><Row><Pricelist__c>1</Pricelist__c><PRICE__C>199.99</PRICE__C><Product__c>99992</Product__c></Row>' +
				'<Row><Pricelist__c>1</Pricelist__c><PRICE__C>199.99</PRICE__C><Product__c>99993</Product__c></Row><Row><Pricelist__c>2</Pricelist__c><PRICE__C>99.999</PRICE__C><Product__c>99990</Product__c></Row><Row><Pricelist__c>2</Pricelist__c><PRICE__C>99.99</PRICE__C><Product__c>99991</Product__c></Row>' +
				'<Row><Pricelist__c>2</Pricelist__c><PRICE__C>99.99</PRICE__C><Product__c>99992</Product__c></Row><Row><Pricelist__c>2</Pricelist__c><PRICE__C>99.99</PRICE__C><Product__c>99993</Product__c></Row>' +
				'</Root>';
	}
}