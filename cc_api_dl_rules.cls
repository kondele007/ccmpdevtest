public with sharing class cc_api_dl_rules extends cc_api_dl_productDataLoaderBase {
	 
	public override SObject getNewSObject(){
		return new  E_Rule__c();
	}
	
	public override void deleteObject() {
		//delete [Select c.Id From E_AccountGroup__c c LIMIT 2000];
	}
	public override String getDataFileName() {
		return 'rule.xml';
	}
	public override Map<String, Schema.SObjectField> getFieldMap() {
		return Schema.SObjectType.E_Rule__c.fields.getMap();
	}
	
	public override void postProcess(List<SObject> objs) {
		List<E_Rule__c> cats = new List<E_Rule__c>();
		for(SObject so : objs) {
			
			Boolean enabled = true;
			try {
				enabled = Boolean.valueOf(String.valueOf(so.get('ENABLED__C')));
			} catch(Exception e) {
				enabled = true;
			} 
			
			String name = String.valueOf(so.get('NAME__C'));
			
			String relation = String.valueOf(so.get('RELATION__C'));
			
			String ruleId = String.valueOf(so.get('RULEID__C'));
			
			Double ruleMinAmt = 0.0;
			try {
				ruleMinAmt = Double.valueOf(String.valueOf(so.get('RULEMINAMT__C')));
			} catch(Exception e) {
				ruleMinAmt = 0.0;
			}
			
			Double ruleMinQty = 0.0;
			try {
				ruleMinQty = Double.valueOf(String.valueOf(so.get('RULEMINQTY__C')));
			} catch(Exception e) {
				ruleMinQty = 1;
			}
			
			String ruleSource = String.valueOf(so.get('RULESOURCE__C'));
			
			
			String ruleType = String.valueOf(so.get('RULETYPE__C'));
			
			
			String sourceRelation = String.valueOf(so.get('SOURCERELATION__C'));
					
			
			cats.add(new E_Rule__c(ENABLED__C=enabled, NAME__C=name, RELATION__C=relation, RULEID__C = ruleId, RULEMINAMT__C=ruleMinAmt,RULEMINQTY__C =ruleMinQty,RULESOURCE__C=ruleSource,RULETYPE__C=ruleType,SOURCERELATION__C=sourceRelation));
		}
		insert cats;
	}
	
	public override String getTestString() {
		return '<document><row><ENABLED__C>TRUE</ENABLED__C ><NAME__C>200 off HP G7</NAME__C ><RELATION__C>Production</RELATION__C ><RULEID__C>1</RULEID__C ><RULEMINAMT__C>0</RULEMINAMT__C ><RULEMINQTY__C>1</RULEMINQTY__C ><RULESOURCE__C>Coupon</RULESOURCE__C ><RULETYPE__C>General</RULETYPE__C ><SOURCERELATION__C></SOURCERELATION__C ></row>' +
			'<row><ENABLED__C>test</ENABLED__C ><NAME__C>200 off HP G7</NAME__C ><RELATION__C>Production</RELATION__C ><RULEID__C>2</RULEID__C ><RULEMINAMT__C>1</RULEMINAMT__C ><RULEMINQTY__C>2</RULEMINQTY__C ><RULESOURCE__C>Coupon</RULESOURCE__C ><RULETYPE__C>General</RULETYPE__C ><SOURCERELATION__C></SOURCERELATION__C ></row></document>';
	}
}