public with sharing class cc_api_dl_productMedia extends cc_api_dl_productDataLoaderBase {
	 
	public override SObject getNewSObject(){
		return new  E_ProductMedia__c();
	}
	
	public override void deleteObject() {
		//delete [Select c.Id From E_AccountGroup__c c LIMIT 2000];
	}
	public override String getDataFileName() {
		return 'productMedia.xml';
	}
	public override Map<String, Schema.SObjectField> getFieldMap() {
		return Schema.SObjectType.E_ProductMedia__c.fields.getMap();
	}
	
	public override void postProcess(List<SObject> objs) {
		List<E_ProductMedia__c> cats = new List<E_ProductMedia__c>();
		for(SObject so : objs) {
			
			E_Product__c product = new E_Product__c(SKU__C=String.valueOf(so.get('PRODUCT__C')));
			
			Boolean enabled = true;
			try {
				if(so.get('ENABLED__C') != null)
					enabled = Boolean.valueOf(String.valueOf(so.get('ENABLED__C')));
			} catch(Exception e) {
				enabled = true;
			}
			
			String filePath = '';
			try {
				if(so.get('FILEPATH__C') != null)
					filePath = String.valueOf(so.get('FILEPATH__C'));
			} catch(Exception e) {
				filePath = '';
			}
			
			String locale='en_US';
			try {
				if(so.get('FILEPATH__C') != null)
					filePath = String.valueOf(so.get('FILEPATH__C'));
			} catch(Exception e) {
				filePath = '';
			}
			
			String mediaType = '';
			try {
				if(so.get('MEDIATYPE__C') != null)
					mediaType = String.valueOf(so.get('MEDIATYPE__C'));
			} catch(Exception e) {
				mediaType = '';
			}
			
			String productMediaSource='';
			try {
				if(so.get('PRODUCTMEDIASOURCE__C') != null)
					productMediaSource = String.valueOf(so.get('PRODUCTMEDIASOURCE__C'));
			} catch(Exception e) {
				productMediaSource = '';
			}
			
			Integer sequence = 0;
			try {
				if(so.get('SEQUENCE__C') != null)
					sequence = Integer.valueOf(so.get('SEQUENCE__C'));
			} catch(Exception e) {
				sequence = 0;
			} 
			
			String URI = '';
			try {
				if(so.get('URI__C') != null)
					URI = String.valueOf(so.get('URI__C'));
			} catch(Exception e) {
				URI = '';
			} 			
			
			cats.add(new E_ProductMedia__c(PRODUCT__R=product, ENABLED__C=enabled,FILEPATH__C=filePath,MEDIATYPE__C=mediaType,PRODUCTMEDIASOURCE__C=productMediaSource,SEQUENCE__C=sequence,URI__C=URI));
		}
		insert cats;
	}
	
	public override String getTestString() {
		return '<document><row><PRODUCT__C>99991</PRODUCT__C ><ENABLED__C>TRUE</ENABLED__C ><FILEPATH__C>images/products/WDH2NC20000N/Product_Search_Image/WDH2NC20000N_SearchImage.jpg</FILEPATH__C ><LOCALE__C>en_US</LOCALE__C ><MEDIATYPE__C>Product Search Image</MEDIATYPE__C ><PRODUCTMEDIASOURCE__C>Static Resource</PRODUCTMEDIASOURCE__C ><SEQUENCE__C>500</SEQUENCE__C ><URI__C>WDH2NC20000N_SearchImage.jpg</URI__C ></row></document>';
	}
}