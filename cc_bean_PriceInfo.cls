public class cc_bean_PriceInfo {
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
	public E_PriceListItem__c priceListItem {get;set;}
	public Double quantity {get;set;}
	public Double price {get;set;} // price of each item
	public Double subAmount {get;set;} // subtotal for whole quantity

    public Double[] quantityArray {get;set;}
    public Double[] priceArray {get;set;}
    public Double[] subAmountArray {get;set;}

    public String ruleType {get;set;}
    
    //==================================================
    // CONSTRUCTOR
    //==================================================
    public cc_bean_PriceInfo() {
    	quantityArray = new List<Double>();
        priceArray = new List<Double>();
        subAmountArray = new List<Double>();
    }
}