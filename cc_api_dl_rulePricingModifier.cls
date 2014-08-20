public with sharing class cc_api_dl_rulePricingModifier extends cc_api_dl_productDataLoaderBase {
	 
	public override SObject getNewSObject(){
		return new  E_RulePricingModifier__c();
	}
	
	public override void deleteObject() {
		//delete [Select c.Id From E_AccountGroup__c c LIMIT 2000];
	}
	public override String getDataFileName() {
		return 'rulePricingModifier.xml';
	}
	public override Map<String, Schema.SObjectField> getFieldMap() {
		return Schema.SObjectType.E_RulePricingModifier__c.fields.getMap();
	}
	
	public override void postProcess(List<SObject> objs) {
		List<E_RulePricingModifier__c> cats = new List<E_RulePricingModifier__c>();
		for(SObject so : objs) {
			
			E_Rule__c rule = new E_Rule__c(RULEID__C=String.valueOf(so.get('RULE__C')));
			E_PriceModifier__c priceModifier = new E_PriceModifier__c(PRICEMODIFIERID__C=String.valueOf(so.get('PRICEMODIFIER__C')));
			
			cats.add(new E_RulePricingModifier__c(RULE__R=rule, PRICEMODIFIER__R=priceModifier));
		}
		insert cats;
	}
	
	public override String getTestString() {
		return '<document><row><RULE__C>1</RULE__C ><PRICEMODIFIER__C>1</PRICEMODIFIER__C ></row></document>';
	}
}