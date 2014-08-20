public class cc_bean_MockCartItem {
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
	public string cartItemId { get; set; }
	public decimal price { get; set; }
	public integer quantity { get; set; }
	public string sku { get; set; }
	public string productId { get; set; }
	public string productName { get; set; }
	//==================================================
    // CONSTRUCTOR
    //==================================================
	public cc_bean_MockCartItem(E_CartItem__c ci) {
		this.cartItemId = ci.id;
		this.price = ci.price__c;
		this.quantity = ci.Quantity__c.intValue();
		this.sku = ci.product__r.sku__c;
		this.productName = ci.product__r.name;
		this.productId = ci.product__c;
	}
}