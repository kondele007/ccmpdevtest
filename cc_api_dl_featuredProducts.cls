public with sharing class cc_api_dl_featuredProducts extends cc_api_dl_productDataLoaderBase {
	public override SObject getNewSObject(){
		return new  E_FeaturedProduct__c();
	}
	public override void deleteObject() {
		//delete [Select c.Id From E_FeaturedProduct__c c LIMIT 2000];
	}
	public override String getDataFileName() {
		return 'featuredProduct.xml';
	}
	public override Map<String, Schema.SObjectField> getFieldMap() {
		return Schema.SObjectType.E_FeaturedProduct__c.fields.getMap();
	}
	
	public override void postProcess(List<SObject> objs) {
  
		List<E_FeaturedProduct__c> cats = new List<E_FeaturedProduct__c>();
		for(SObject so : objs) {
			String name = String.valueOf(so.get('NAME'));
			String fType = String.valueOf(so.get('TYPE__C'));
			String pDesc = String.valueOf(so.get('DESCRIPTION__C'));
			 
			Double Sequence = 0.0;
			Boolean enabled = true;
			try {
				Sequence = Double.valueOf(so.get('SEQUENCE__C'));
				enabled = Boolean.valueOf(String.valueOf(so.get('ENABLED__C')));
			} catch (Exception e) {
				
			}
			
			E_FeaturedProduct__c prom = new E_FeaturedProduct__c(Type__c=fType, Description__c=pDesc, SEQUENCE__C=Sequence, Enabled__c=enabled);
			//System.debug('product sku = ' +	so.get('PRODUCT__C'));
			String sku = String.valueOf(so.get('PRODUCT__C'));
			if(sku != null && sku.trim().length() != 0) {
				prom.Product__r=new E_Product__c(SKU__c=sku);
			}
			cats.add(prom);
		}
		insert cats;
	}
	
	public override String getTestString() {
		return '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
				'<Root xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
				'<row><NAME>Gold Tier Spotlight</NAME ><PRODUCT__C>99993</PRODUCT__C ><TYPE__C>Spotlight</TYPE__C ><DESCRIPTION__C>The heavy-duty Managed Dedicated Performance Features One package is tuned for maximum workloads. Find out more!</DESCRIPTION__C ><ENABLED__C>TRUE</ENABLED__C ><SEQUENCE__C>600</SEQUENCE__C ></row>' +
				'</Root>';
	}
}