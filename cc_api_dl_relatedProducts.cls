public with sharing class cc_api_dl_relatedProducts extends cc_api_dl_productDataLoaderBase {
	
	public override SObject getNewSObject(){
		return new  E_RelatedProduct__c();
	}
	public override void deleteObject() {
		//delete [Select c.Id From E_RelatedProduct__c c LIMIT 2000];
	}
	public override String getDataFileName() {
		return 'relatedProduct.xml';
	}
	public override Map<String, Schema.SObjectField> getFieldMap() {
		return Schema.SObjectType.E_RelatedProduct__c.fields.getMap();
	}
	
	public override void postProcess(List<SObject> objs) {
  
		List<E_RelatedProduct__c> cats = new List<E_RelatedProduct__c>();
		for(SObject so : objs) {
			String fType = String.valueOf(so.get('RELATEDPRODUCTTYPE__C'));
			Double Sequence = 0.0;
			Boolean enabled = true;
			try {
				Sequence = Double.valueOf(so.get('SEQUENCE__C'));
				enabled = Boolean.valueOf(String.valueOf(so.get('ENABLED__C')));
			} catch (Exception e) {
				
			}
			E_RelatedProduct__c prom = new E_RelatedProduct__c(RELATEDPRODUCTTYPE__C=fType, ENABLED__C=enabled, SEQUENCE__C=Sequence);
			//System.debug('product sku = ' +	so.get('PRODUCT__C'));
			String sku = String.valueOf(so.get('PRODUCT__C'));
			if(sku != null && sku.trim().length() != 0) {
				prom.Product__r=new E_Product__c(SKU__c=sku);
			}
			String relatedSku = String.valueOf(so.get('RELATEDPRODUCT__C'));
			if(relatedSku != null && relatedSku.trim().length() != 0) {
				prom.RelatedProduct__r=new E_Product__c(SKU__c=relatedSku);
			}
			cats.add(prom);
		}
		insert cats;
	}
	
	public override String getTestString() {
		return '<document><row><PRODUCT__C>99991</PRODUCT__C ><ENABLED__C>TRUE</ENABLED__C ><RELATEDPRODUCTTYPE__C>Competitive</RELATEDPRODUCTTYPE__C ><RELATEDPRODUCT__C>99992</RELATEDPRODUCT__C ><SEQUENCE__C>500</SEQUENCE__C ></row></document>';
	}
}