public with sharing class cc_api_dl_promotions extends cc_api_dl_productDataLoaderBase {
	 
	public override SObject getNewSObject(){
		return new  E_Promo__c();
	}
	public override void deleteObject() {
		//delete [Select c.Id From E_Promo__c c LIMIT 2000];
	}
	public override String getDataFileName() {
		return 'promotion.xml';
	}
	public override Map<String, Schema.SObjectField> getFieldMap() {
		return Schema.SObjectType.E_Promo__c.fields.getMap();
	}
	
	public override void postProcess(List<SObject> objs) {
  
		List<E_Promo__c> cats = new List<E_Promo__c>();
		for(SObject so : objs) {
			String name = String.valueOf(so.get('NAME'));
			String staticResource = String.valueOf(so.get('STATICRESOURCE__C'));
			String imageUri = String.valueOf(so.get('IMAGEURI__C'));
			String pageLocation = String.valueOf(so.get('PAGELOCATION__C'));
			String locationType = String.valueOf(so.get('LOCATIONTYPE__C'));
			String imageSource = String.valueOf(so.get('IMAGESOURCE__C'));
			Boolean Enabled = Boolean.valueOf(so.get('ENABLED__C'));
			Double Sequence = Double.valueOf(so.get('SEQUENCE__C'));
			E_Promo__c prom = new E_Promo__c(NAME=name, IMAGEURI__C=imageUri, PAGELOCATION__C=pageLocation, 
				LOCATIONTYPE__C=locationType, IMAGESOURCE__C=imageSource, STATICRESOURCE__C=staticResource, ENABLED__C=Enabled, SEQUENCE__C=Sequence);
			//System.debug('product sku = ' +	so.get('PRODUCT__C'));
			String sku = String.valueOf(so.get('PRODUCT__C'));
			if(sku != null && sku.trim().length() != 0) {
				prom.PRODUCT__r=new E_Product__c(SKU__c=sku);
				
			}
			cats.add(prom);
		}
		insert cats;
	}
	
	public override String getTestString() {
		return '<document>'
			+ '<row><NAME>Banner Order Review</NAME ><COUPON__C></COUPON__C ><ENABLED__C>TRUE</ENABLED__C ><STATICRESOURCE__C>CC</STATICRESOURCE__C><IMAGEURI__C>images/promotion/orderReview/banner/bannerPromo2.jpeg</IMAGEURI__C ><PAGELOCATION__C>Order Review</PAGELOCATION__C ><SEQUENCE__C>1</SEQUENCE__C ><LOCATIONTYPE__C>Banner</LOCATIONTYPE__C ><IMAGESOURCE__C>Static Resource</IMAGESOURCE__C ><PRODUCT__C>99991</PRODUCT__C ></row>'
			+ '<row><NAME>CloudBurst Acer Monitor 50%</NAME><ENABLED__C>TRUE</ENABLED__C><IMAGESOURCE__C>Static Resource</IMAGESOURCE__C><IMAGEURI__C>images/promo_200x198_4.jpg</IMAGEURI__C><LOCATIONTYPE__C>Left Nav</LOCATIONTYPE__C><PAGELOCATION__C>Product List Page</PAGELOCATION__C><PRODUCT__C>99991</PRODUCT__C><SEQUENCE__C>100.0</SEQUENCE__C><STATICRESOURCE__C>Promos_CloudBurst</STATICRESOURCE__C></row>'
			+ '<row><NAME>CloudBurst Proliant G7</NAME><ENABLED__C>TRUE</ENABLED__C><IMAGESOURCE__C>Static Resource</IMAGESOURCE__C><IMAGEURI__C>images/promo_200x198_7.jpg</IMAGEURI__C><LOCATIONTYPE__C>Left Nav</LOCATIONTYPE__C><PAGELOCATION__C>Product Detail</PAGELOCATION__C><PRODUCT__C>99991</PRODUCT__C><SEQUENCE__C>150.0</SEQUENCE__C><STATICRESOURCE__C>Promos_CloudBurst</STATICRESOURCE__C></row>'
			+ '<row><NAME>CloudBurst Free Shipping</NAME><ENABLED__C>TRUE</ENABLED__C><IMAGESOURCE__C>Static Resource</IMAGESOURCE__C><IMAGEURI__C>images/promo_200x198_1.jpg</IMAGEURI__C><LOCATIONTYPE__C>Left Nav</LOCATIONTYPE__C><PAGELOCATION__C>Product Detail</PAGELOCATION__C><PRODUCT__C></PRODUCT__C><SEQUENCE__C>10.0</SEQUENCE__C><STATICRESOURCE__C>Promos_CloudBurst</STATICRESOURCE__C></row>'
			+ '</document>';
	}
}