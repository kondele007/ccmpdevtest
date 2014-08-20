public with sharing class cc_bean_Product {
	//==================================================
    // INNER CLASS
    //==================================================
	public class ProductSpec {
		public String specName { get; set; }
		public String specValue { get; set; }
		public String specGroup { get; set; }
		public ProductSpec(E_ProductSpecIndex__c ps) {
			specName = ps.Spec__r.DisplayName__c;
			specValue = ps.SpecValue__c;
			specGroup = ps.Spec__r.SpecGroup__c;
		}
	}
	//==================================================
    // INSTANCE PROERTIES
    //==================================================
	public String sku { get; set; }
	public Id id { get; set; }
	public String name { get; set; }
	public String shortDescRich { get; set; }
	public String longDescRich { get; set; }
	public String productType { get; set; }
	public String requiredItemDialogText { get; set; }
	public String inventoryType { get; set; }
	public List<ProductSpec> productSpecList { get; set; }
	public String UnitOfMeasure { get; set; }
	public String ProductStatus { get; set; }
	public Double productWeight {get; set;}
	public Double shippingWeight {get; set;}
	public Boolean groundFlag {get; set;}
	public Boolean hazardousFlag {get; set;}
	public Boolean coolerpakFlag {get; set;}
	public Boolean overnightFlag {get;set;}

	/*
	* Begin new fields for Kaplan
	*/
	public Double deliveryType {get; set;}
	public Double numberOfInstallments{get; set;}
	public DateTime classStartDate{get; set;}
	public DateTime classEndDate{get; set;}
	public String programCode{get;set;}
	public String classCode{get;set;}
	public String classCountry{get; set;}
	public String eventType{get; set;}
	public Boolean flexStartDateEnabled{get; set;}
	public Double flexStartDateMaxDuration{get; set;}
	public Boolean isHSKEnabled{get; set;}
	public Boolean isLiveOnline{get; set;}
	
	
	
	//==================================================
    // CONSTRUCTOR
    //==================================================
	public cc_bean_Product(E_Product__c p) {
		this.sku=p.sku__c;
		this.id=p.id;
		this.name=p.name;
		
		this.shortDescRich = p.ShortDesc__c;
		this.longDescRich = p.LongDesc__c;
		
		this.productType = p.productType__c;
		this.requiredItemDialogText = p.RequiredItemDialogText__c;
		this.InventoryType = p.InventoryType__c;
		this.UnitOfMeasure = p.UnitOfMeasure__c;
		this.productSpecList = new List<ProductSpec>();
		this.ProductStatus = p.ProductStatus__c;
		
		/* Shipping attributes */
		this.productWeight = p.ProductWeight__c;
		this.shippingWeight = p.ShippingWeight__c;
		this.groundFlag = p.GroundFlag__c;
		this.hazardousFlag = p.HazardousFlag__c;
		this.coolerpakFlag = p.CoolerpakFlag__c;
		this.overnightFlag = p.OvernightFlag__c;
		
		if(p.Product_Spec_Indicies__r != null) {
			for(E_ProductSpecIndex__c ps : p.Product_Spec_Indicies__r) {
				productSpecList.add(new ProductSpec(ps));
				
			}
		}
		this.classStartDate = p.ClassStartDate__c;
		this.classEndDate = p.ClassEndDate__c;

		/*
		* Begin new fields for Kaplan
		*/

		/*
		this.deliveryType = p.DeliveryType__c;
		this.numberOfInstallments = p.BillingInstallments__c;
		this.programCode = p.ProgramCode__c;
		this.classCode = p.Code__c;
		this.classCountry = p.Country__c;
		this.eventType = p.EventType__c;
		this.flexStartDateEnabled = p.FlexStartDateEnabled__c;
		this.flexStartDateMaxDuration = p.FlexStartDateMaxDuration__c;
		this.isHSKEnabled = p.IsHSKEnabled__c;
		this.isLiveOnlineEvent = p.isLiveOnlineEvent__c;
		*/

	}
	
	//==================================================
    // HELPER METHODS
    //==================================================
    
	public static String getStringValue(SObject obj, String name) {
		try
		{
			return String.valueOf(obj.get(name));
		} catch(Exception e) {
			return null;
		}
	}
	
	//==================================================
    // TEST METHODS
    //==================================================
	static testMethod void unitTest() { 
		E_Product__c p = new E_Product__c(name='sku1', sku__c='sku1', ShortDesc__c='sku1', LongDesc__c='sku1', productType__c='Bundle',ClassStartDate__c = DateTime.now(), ClassEndDate__c = DateTime.now(),
							RequiredItemDialogText__c='Hello', InventoryType__c='CLASS',  UnitOfMeasure__c='EA', ProductStatus__c='Released');
		insert p;
		E_Spec__c spec = new E_Spec__c(name='spec1');
    	insert spec;
    	
    	insert new  List<E_ProductSpecIndex__c> {
    		new E_ProductSpecIndex__c(product__r=new E_Product__c(SKU__c='sku1'), Spec__c=spec.id, specValue__c='specValue', productSpecIndexId__c='sku1')
    	};
    	
    	p = [Select e.UnitOfMeasure__c, e.productWeight__c, e.ShippingWeight__c, e.GroundFlag__c, e.HazardousFlag__c, 
    		e.CoolerpakFlag__c, e.OvernightFlag__c, e.ClassStartDate__c, e.ClassEndDate__c,
    		e.Storefront__c, e.ShortDesc__c, e.SKU__c, e.RequiredItemDialogText__c, e.Quantityperunit__c, 
    		e.ProductType__c, e.ProductStatus__c, e.Name, e.LongDesc__c, e.InventoryType__c, e.Id,  
    		(Select Spec__r.DisplayName__c, Spec__r.SpecGroup__c, SpecValue__c From Product_Spec_Indicies__r) From E_Product__c e where e.id = :p.id];
    	
		cc_bean_Product ccp = new cc_bean_Product(p);
		System.assertEquals(ccp.name, 'sku1');
		System.assertEquals(ccp.id, p.id);
		System.assertEquals(ccp.sku, 'sku1');
		System.assertEquals(ccp.productType, 'Bundle');
		System.assertEquals(ccp.requiredItemDialogText, 'Hello');
		System.assertEquals(ccp.InventoryType, 'CLASS');
		System.assertEquals(ccp.ProductStatus, 'Released');
		System.assertEquals(cc_bean_Product.getStringValue(p, 'ProductStatus__c'), 'Released');
		System.assertEquals(cc_bean_Product.getStringValue(p, 'NonExistence'), null);
	}
}