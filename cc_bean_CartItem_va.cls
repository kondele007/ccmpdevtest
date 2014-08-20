public with sharing class cc_bean_CartItem_va {
	//==================================================
    // INNWE CLASS
    //==================================================
    public class PricingTier {
    	//==================================================
	    // INSTANCE PROPERTIES
	    //==================================================
        public Integer quantity {get;set;} 
        public Decimal price {get;set;}
        //==================================================
	    // CONSTRUCTOR
	    //==================================================
        public PricingTier(Integer q, Decimal p) { 
        	quantity = q;
        	price = p;
        }
    }
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
	public E_Product__c product {get; set; }
	public cc_bean_MockProduct mockProduct { get; set; }
	public String createDate {get; set; }
	public Id attachmentID { get; set; }
	public Id itemID {get;set;}
	public E_PriceListItem__c priceListItem {get; set; }
	public cc_bean_PriceInfo priceBean {get;set;}
	public Decimal price {get;set;}
	public String comments {get; set; }
	public Integer quantity {get; set;}
	public Decimal SubAmount {get; set; }
	public Decimal AmountOwed {get; set; }
	public String displaySubAmount {get; set; }
	public Boolean evenLineNumber {get;set;}
	
	/** Kaplan Phase 1 Begin **/
	public cc_kap_rules_bean_CartDataRulesBean dataRulesBean { get; set; }
	public Decimal listPrice {get;set;}
	public Decimal totalDiscount { get; set; }
	public Decimal totalListPrice { get; set; }
	/** Kaplan Phase 1 End **/
	
	
	public Decimal absoluteDiscount {get;set;}
	public Decimal percentDiscount {get;set;} 
	
	public String appliedCoupon {get;set;}
	public cc_bean_MediaWrapper mediaWrapper { get; set;}
	public String cartItemType { get; set; }
	public String parentProductType { get; set; }
	public String thumbImage {get; set;} 
	public Decimal productInventory {get; set; }
	public Boolean displayMaxOutMessage {get; set; }
	public String translatedProductName {get; set;}
	//JLL -- adding minor line items
	public List<cc_bean_CartItem> minorLines {get; set;}
	
	public Integer[] quantityArray {get;set;}
	public Decimal[] priceArray {get;set;}
	
	public List<PricingTier> pricingTiers {get;set;}

	/************* CASE # 1732 - Begin ************/

	public String kbsProgramCode {get;set;}

	/************* CASE # 1732 - End ************/


	//==================================================
    // CONSTRUCTOR
    //==================================================
	public cc_bean_CartItem_va()
	{
		
		displayMaxoutMessage = false;
		pricingTiers = new List<PricingTier>();
		quantityArray = new List<Integer>();
		priceArray = new List<Decimal>();
		productInventory = 0;
		minorLines = new List<cc_bean_CartItem>();
	}
	
	public boolean getInventoryLow(){
	  return productInventory != null && productInventory < quantity;	
	}
	
	public boolean getExpired(){
	  return (product.StartDate__c != null && product.StartDate__c > System.today())
	   || (product.EndDate__c != null && product.EndDate__c < System.today()) || product.ProductStatus__c == cc_cnst_PickListConstants.PRODUCTSTATUS_NOTORDERABLE;	
	}
	
	public String getProductName(){
      return (!al.StringUtils.isEmpty(translatedProductName) ? translatedProductName : product.Name);
	}
	
	public String getProductDescription(){
      return product.ShortDesc__c;
	}
	public String getSKU(){
      return product.SKU__c;
	}
}