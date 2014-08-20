public with sharing class cc_api_dl_ruleTarget extends cc_api_dl_productDataLoaderBase {
	 
	public override SObject getNewSObject(){
		return new  E_RuleTargetSKU__c();
	}
	
	public override void deleteObject() {
		//delete [Select c.Id From E_AccountGroup__c c LIMIT 2000];
	}
	public override String getDataFileName() {
		return 'ruleTargetSku.xml';
	}
	public override Map<String, Schema.SObjectField> getFieldMap() {
		return Schema.SObjectType.E_RuleTargetSKU__c.fields.getMap();
	}
	 
	public override void postProcess(List<SObject> objs) {
		List<E_RuleTargetSKU__c> cats = new List<E_RuleTargetSKU__c>();
		for(SObject so : objs) {
			
			E_Rule__c rule = new E_Rule__c(RULEID__C=String.valueOf(so.get('RULE__C')));
			E_Product__c product = new E_Product__c(PRODUCTID__C=String.valueOf(so.get('PRODUCT__C')));
			Double qty = 0.0;
			try {
				qty = Double.valueOf(String.valueOf(so.get('QUANTITY__C')));
			} catch(Exception e) {
				qty = 0.0;
			}
			cats.add(new E_RuleTargetSKU__c(RULE__R=rule, PRODUCT__R=product,QUANTITY__C=qty));
		}
		insert cats; 
	}
	
	public override String getTestString() {
		return '<document><row><PRODUCT__C>99990</PRODUCT__C ><QUANTITY__C>1.0</QUANTITY__C ><RULE__C>1</RULE__C ></row><row><PRODUCT__C>99991</PRODUCT__C ><QUANTITY__C>0</QUANTITY__C ><RULE__C>1</RULE__C ></row><row><PRODUCT__C>99992</PRODUCT__C ><QUANTITY__C>1.0</QUANTITY__C ><RULE__C>1</RULE__C ></row><row><PRODUCT__C>99993</PRODUCT__C ><QUANTITY__C>1.0</QUANTITY__C ><RULE__C>1</RULE__C ></row></document>';
	}
}