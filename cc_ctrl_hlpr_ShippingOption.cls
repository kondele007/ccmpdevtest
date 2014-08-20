public with sharing class cc_ctrl_hlpr_ShippingOption {
    	//==================================================
	    // INSTANCE PROPERTIES
	    //==================================================
	    public String provider {get;set;}
	    public String serviceName {get;set;}
	    public Decimal price {get;set;}
	    public Decimal discountedShipCost {get;set;}
	    public Decimal discount {get;set;}
	    public Decimal getNetPrice() {
	        Decimal netPrice = price;
	        if(discount != null) {
	            netPrice = price - discount;
	        }
	        if(netPrice < 0) {
	            netPrice = 0;
	        }
	        return netPrice;
	    }
	    public String uid {
	    	get {
	    		return provider + ' - ' + serviceName;
	    	}
	    }
    	//==================================================
	    // CONSTRUCTORS
	    //==================================================
	    public cc_ctrl_hlpr_ShippingOption(String prv, String serv, Decimal prc) {
	        this.provider    = prv;
	        this.serviceName = serv;
	        this.price       = prc;
	    }
    	
	    public cc_ctrl_hlpr_ShippingOption(String prv, String serv, Decimal prc, Decimal newDiscountedShipCost) {
	        this.provider    = prv;
	        this.serviceName = serv;
	        this.price       = prc;
	        this.discountedShipCost = newDiscountedShipCost;
	    }
        
}