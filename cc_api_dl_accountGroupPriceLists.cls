public with sharing class cc_api_dl_accountGroupPriceLists extends cc_api_dl_productDataLoaderBase {
	 
	public override SObject getNewSObject(){
		return new  E_AccountGroupPriceList__c();
	}
	public override void deleteObject() {
		//delete [Select c.Id From E_AccountGroup__c c LIMIT 2000];
	}
	public override String getDataFileName() {
		return 'accountGroupPriceList.xml';
	}
	public override Map<String, Schema.SObjectField> getFieldMap() {
		return Schema.SObjectType.E_AccountGroupPriceList__c.fields.getMap();
	}
	
	public override void postProcess(List<SObject> objs) {
		List<E_AccountGroupPriceList__c> cats = new List<E_AccountGroupPriceList__c>();
		for(SObject so : objs) {
			E_AccountGroup__c ag = new E_AccountGroup__c(AccountGroupID__c=String.valueOf(so.get('ACCOUNTGROUP__C')));
			E_PriceList__c p = new E_PriceList__c(PRICELISTID__C=String.valueOf(so.get('PRICELIST__C')));
			
			Boolean enabled = true;
			try {
				
				enabled = true;//Boolean.valueOf(String.valueOf(so.get('ENABLED__C')));
			} catch (Exception e) {
				
			}
			cats.add(new E_AccountGroupPriceList__c(ACCOUNTGROUP__R=ag, PRICELIST__R=p, ENABLE__C=enabled, SEQUENCE__C=Double.valueOf(so.get('SEQUENCE__C'))));
		}
		insert cats;
	}
	
	public override String getTestString() {
		return '<document><Row><ACCOUNTGROUP__C>1</ACCOUNTGROUP__C><PRICELIST__C>1</PRICELIST__C><SEQUENCE__C>500</SEQUENCE__C></Row><Row><ACCOUNTGROUP__C>1</ACCOUNTGROUP__C><PRICELIST__C>2</PRICELIST__C><SEQUENCE__C>500</SEQUENCE__C></Row><Row><ACCOUNTGROUP__C>2</ACCOUNTGROUP__C><PRICELIST__C>1</PRICELIST__C><SEQUENCE__C>500</SEQUENCE__C></Row><Row><ACCOUNTGROUP__C>2</ACCOUNTGROUP__C><PRICELIST__C>2</PRICELIST__C><SEQUENCE__C>500</SEQUENCE__C></Row></document>';
	}
	
}