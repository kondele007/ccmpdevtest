public with sharing class cc_api_dl_ruleSource extends cc_api_dl_productDataLoaderBase {
	 
	public override SObject getNewSObject(){
		return new  E_RuleSourceSKU__c();
	}
	
	public override void deleteObject() {
		//delete [Select c.Id From E_AccountGroup__c c LIMIT 2000];
	}
	public override String getDataFileName() {
		return 'ruleSource.xml';
	}
	public override Map<String, Schema.SObjectField> getFieldMap() {
		return Schema.SObjectType.E_RuleSourceSKU__c.fields.getMap();
	}
	
	public override void postProcess(List<SObject> objs) {
		List<E_RuleSourceSKU__c> cats = new List<E_RuleSourceSKU__c>();
		for(SObject so : objs) {
			
			E_Rule__c rule = new E_Rule__c(RULEID__C=String.valueOf(so.get('RULE__C')));
			E_Product__c product = new E_Product__c(PRODUCTID__C=String.valueOf(so.get('PRODUCT__C')));
			Double minQty = 0.0;
			try {
				minQty = Double.valueOf(String.valueOf(so.get('MINQTY__C')));
			} catch(Exception e) {
				minQty = 0.0;
			}
			cats.add(new E_RuleSourceSKU__c(RULE__R=rule, PRODUCT__R=product,MINQTY__C=minQty));
		}
		insert cats;
	}
	
	public override String getTestString() {
		return '<document><row><Rule__c>1</Rule__c><MinQty__c>1</MinQty__c><Product__c>99991</Product__c></row></document>';
	}
}