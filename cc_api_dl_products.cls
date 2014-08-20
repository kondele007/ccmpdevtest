public with sharing class cc_api_dl_products extends cc_api_dl_productDataLoaderBase {
	public override SObject getNewSObject(){
		return new  E_Product__c();
	}
	public override void deleteObject() {
		//delete [Select c.Id From E_Product__c c LIMIT 2000];
	}
	public override String getDataFileName() {
		return 'product.xml';
	}
	public override Map<String, Schema.SObjectField> getFieldMap() {
		return Schema.SObjectType.E_Product__c.fields.getMap();
	}
	
	public override String getTestString() {
		return '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
				'<Root xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
				'<row><NAME>CloudCrazeTestProduct1</NAME ><PRODUCTID__C>99991</PRODUCTID__C><INVENTORYTYPE__C>STANDARD</INVENTORYTYPE__C ><LEADTIME__C>1</LEADTIME__C ><PRODUCTSTATUS__C>Released</PRODUCTSTATUS__C ><PRODUCTTYPE__C>Product</PRODUCTTYPE__C ><QUANTITYPERUNIT__C>1</QUANTITYPERUNIT__C ><SKU__C>99991</SKU__C ><SHIPPINGWEIGHT__C>1</SHIPPINGWEIGHT__C ><STOREFRONT__C>DefaultStore</STOREFRONT__C ></row>' +
				'<row><NAME>CloudCrazeTestProduct2</NAME ><PRODUCTID__C>99992</PRODUCTID__C><INVENTORYTYPE__C>STANDARD</INVENTORYTYPE__C ><LEADTIME__C>1</LEADTIME__C ><PRODUCTSTATUS__C>Released</PRODUCTSTATUS__C ><PRODUCTTYPE__C>Product</PRODUCTTYPE__C ><QUANTITYPERUNIT__C>1</QUANTITYPERUNIT__C ><SKU__C>99992</SKU__C ><SHIPPINGWEIGHT__C>1</SHIPPINGWEIGHT__C ><STOREFRONT__C>DefaultStore</STOREFRONT__C ></row>' +
				'<row><NAME>CloudCrazeTestProduct3</NAME ><PRODUCTID__C>99993</PRODUCTID__C><INVENTORYTYPE__C>STANDARD</INVENTORYTYPE__C ><LEADTIME__C>1</LEADTIME__C ><PRODUCTSTATUS__C>Released</PRODUCTSTATUS__C ><PRODUCTTYPE__C>Product</PRODUCTTYPE__C ><QUANTITYPERUNIT__C>1</QUANTITYPERUNIT__C ><SKU__C>99993</SKU__C ><SHIPPINGWEIGHT__C>1</SHIPPINGWEIGHT__C ><STOREFRONT__C>DefaultStore</STOREFRONT__C ><SHORTDESC__C>&lt;p&gt;Ensure your Nokia phone stays charged on the road with this vehicle power charger and adapter.&lt;/p&gt;</SHORTDESC__C><LONGDESC__C>&lt;p&gt;&lt;ul&gt;&lt;li&gt;Compatible with most Nokia mobile phones&lt;/li&gt;&lt;li&gt;Powers your cell phone through your vehicle\'s power outlet    &lt;/li&gt;&lt;li&gt;Includes both charger (LCH-12) and adapter (CA-44)&lt;/li&gt;&lt;/ul&gt;&lt;/p&gt;</LONGDESC__C></row>' +
				'<row><NAME>CloudCrazeTestProduct4</NAME ><PRODUCTID__C>99990</PRODUCTID__C><INVENTORYTYPE__C>STANDARD</INVENTORYTYPE__C ><LEADTIME__C>1</LEADTIME__C ><PRODUCTSTATUS__C>Released</PRODUCTSTATUS__C ><PRODUCTTYPE__C>Bundle</PRODUCTTYPE__C ><QUANTITYPERUNIT__C>1</QUANTITYPERUNIT__C ><SKU__C>99990</SKU__C ><SHIPPINGWEIGHT__C>1</SHIPPINGWEIGHT__C ><STOREFRONT__C>DefaultStore</STOREFRONT__C ><SHORTDESC__C>&lt;p&gt;Ensure your Nokia phone stays charged on the road with this vehicle power charger and adapter.&lt;/p&gt;</SHORTDESC__C><LONGDESC__C>&lt;p&gt;&lt;ul&gt;&lt;li&gt;Compatible with most Nokia mobile phones&lt;/li&gt;&lt;li&gt;Powers your cell phone through your vehicle\'s power outlet    &lt;/li&gt;&lt;li&gt;Includes both charger (LCH-12) and adapter (CA-44)&lt;/li&gt;&lt;/ul&gt;&lt;/p&gt;</LONGDESC__C></row>' +
				'</Root>';
	}
	
}