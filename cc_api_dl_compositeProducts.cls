public with sharing class cc_api_dl_compositeProducts extends cc_api_dl_productDataLoaderBase {
	 
	public override SObject getNewSObject(){
		return new  E_CompositeProduct__c();
	}
	public override void deleteObject() {
		//delete [Select c.Id From E_AccountGroup__c c LIMIT 2000];
	}
	public override String getDataFileName() {
		return 'compositeProduct.xml';
	}
	public override Map<String, Schema.SObjectField> getFieldMap() {
		return Schema.SObjectType.E_CompositeProduct__c.fields.getMap();
	}
	
	public override void postProcess(List<SObject> objs) {
		List<E_CompositeProduct__c> cats = new List<E_CompositeProduct__c>();
		for(SObject so : objs) {
			E_Product__c component = new E_Product__c(PRODUCTID__C=String.valueOf(so.get('COMPONENT__C')));
			E_Product__c composite = new E_Product__c(PRODUCTID__C=String.valueOf(so.get('COMPOSITE__C')));
			E_Category__c p = new E_Category__c(CATEGORYID__C=String.valueOf(so.get('CATEGORY__C')));
			Double qty = 0.0;
			
			try {
				qty = Double.valueOf(String.valueOf(so.get('QUANTITY__C')));
			} catch(Exception e) {
				qty = 1;
			}
			
			Boolean optional = true;
			try {
				optional = Boolean.valueOf(String.valueOf(so.get('OPTIONAL__C')));
			} catch(Exception e) {
				optional = true;
			} 
			
			cats.add(new E_CompositeProduct__c(COMPONENT__R=component, COMPOSITE__R=composite, CATEGORY__R=p, QUANTITY__C = qty, OPTIONAL__C=optional));
		}
		insert cats;
	}
	
	public override String getTestString() {
		return '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
				'<Root xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
				'<row><CATEGORY__C>99997</CATEGORY__C ><COMPONENT__C>99993</COMPONENT__C ><COMPOSITE__C>99990</COMPOSITE__C ><OPTIONAL__C>FALSE</OPTIONAL__C ><QUANTITY__C>1</QUANTITY__C ></row></Root>';
	}
	
}