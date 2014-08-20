public with sharing class cc_api_dl_productSpec extends cc_api_dl_productDataLoaderBase {
	public override SObject getNewSObject(){
		return new  E_ProductSpec__c();
	}
	public override void deleteObject() {
		delete [Select c.Id From E_ProductSpec__c c LIMIT 2000];
	}
	public override String getDataFileName() {
		return 'productSpec.xml';
	}
	public override Map<String, Schema.SObjectField> getFieldMap() {
		return Schema.SObjectType.E_ProductSpec__c.fields.getMap();
	}
	
	public override void postProcess(List<SObject> objs) {
		List<E_ProductSpec__c> cats = new List<E_ProductSpec__c>();
		for(SObject so : objs) {
			E_Product__c p = new E_Product__c(productid__c=String.valueOf(so.get('PRODUCT__C')));
			E_Spec__c c = new E_Spec__c(specid__c=String.valueOf(so.get('SPEC__C')));
			
			cats.add(new E_ProductSpec__c(product__r=p,
				Spec__r = c, SpecValue__c=String.valueOf(so.get('SPECVALUE__C'))));
		}
		insert cats;
	}
	
	public override String getTestString() {
		return '<document><row><PRODUCT__C>99991</PRODUCT__C ><SPEC__C>1</SPEC__C ><SPECVALUE__C>95 F</SPECVALUE__C ></row></document>';
	}
}