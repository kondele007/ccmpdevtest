public with sharing class cc_api_dl_productCategories extends cc_api_dl_productDataLoaderBase {
	public override SObject getNewSObject(){
		return new  E_ProductCategory__c();
	}
	public override void deleteObject() {
		//delete [Select c.Id From E_ProductCategory__c c LIMIT 2000];
	}
	public override String getDataFileName() {
		return 'productCategory.xml';
	}
	public override Map<String, Schema.SObjectField> getFieldMap() {
		return Schema.SObjectType.E_ProductCategory__c.fields.getMap();
	}
	
	public override void postProcess(List<SObject> objs) {
		List<E_ProductCategory__c> cats = new List<E_ProductCategory__c>();
		for(SObject so : objs) {
			E_Product__c p = new E_Product__c(productid__c=String.valueOf(so.get('PRODUCT__C')));
			E_Category__c c = new E_Category__c(categoryid__c=String.valueOf(so.get('CATEGORY__C')));
			cats.add(new E_ProductCategory__c(product__r=p,
				Category__r = c));
		}
		insert cats;
	}
	
	public override String getTestString() {
		return '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
				'<Root xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
				'<row><PRODUCT__C>99991</PRODUCT__C ><CATEGORY__C>99997</CATEGORY__C ></row><row><PRODUCT__C>99992</PRODUCT__C ><CATEGORY__C>99997</CATEGORY__C ></row><row><PRODUCT__C>99993</PRODUCT__C ><CATEGORY__C>99997</CATEGORY__C ></row>' +
				'</Root>';
	}
}