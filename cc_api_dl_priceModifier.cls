public with sharing class cc_api_dl_priceModifier extends cc_api_dl_productDataLoaderBase {
	 
	public override SObject getNewSObject(){
		return new  E_PriceModifier__c();
	}
	
	public override void deleteObject() {
		//delete [Select c.Id From E_AccountGroup__c c LIMIT 2000];
	}
	public override String getDataFileName() {
		return 'priceModifier.xml';
	}
	public override Map<String, Schema.SObjectField> getFieldMap() {
		return Schema.SObjectType.E_PriceModifier__c.fields.getMap();
	}
	
	public override void postProcess(List<SObject> objs) {
		List<E_PriceModifier__c> cats = new List<E_PriceModifier__c>();
		for(SObject so : objs) {
			
			
			
			Double amount = 0.0;
			try {
				if(so.get('AMOUNT__C') != null)
					amount = Double.valueOf(String.valueOf(so.get('AMOUNT__C')));
			} catch(Exception e) {
				amount = 0.0;
			}
			
			Double cartTotalAmount = 0.0;
			try {
				if(so.get('CARTTOTALAMOUNT__C')!= null)
					cartTotalAmount = Double.valueOf(String.valueOf(so.get('CARTTOTALAMOUNT__C')));
			} catch(Exception e) {
				cartTotalAmount = 0.0;
			}
			
			String discountType = '';
			try {
				if(so.get('DISCOUNTTYPE__C') != null)
					discountType = String.valueOf(so.get('DISCOUNTTYPE__C'));
			} catch(Exception e) {
				discountType = '';
			}
			
			String priceModifierId = '';
			try {
				if(so.get('PRICEMODIFIERID__C') != null)
					priceModifierId = String.valueOf(so.get('PRICEMODIFIERID__C'));
			} catch(Exception e) {
				priceModifierId = '';
			}	
			
			
			Double qty = 1;
			try {
				if(so.get('QUANTITY__C') != null)
					qty = Double.valueOf(String.valueOf(so.get('QUANTITY__C')));
			} catch(Exception e) {
				qty = 0.0;
			}			
			
			cats.add(new E_PriceModifier__c(AMOUNT__C=amount, CARTTOTALAMOUNT__C=cartTotalAmount,DISCOUNTTYPE__C=discountType,PRICEMODIFIERID__C=priceModifierId,QUANTITY__C=qty));
		}
		insert cats;
	}
	
	public override String getTestString() {
		return '<document><row><AMOUNT__C>99</AMOUNT__C ><CARTTOTALAMOUNT__C></CARTTOTALAMOUNT__C ><DISCOUNTTYPE__C>Discount</DISCOUNTTYPE__C ><QUANTITY__C>1</QUANTITY__C ><PriceModifierID__c>1</PriceModifierID__c></row></document>';
	}
}