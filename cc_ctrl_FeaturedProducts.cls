public with sharing class cc_ctrl_FeaturedProducts {
	
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public map<Id, String> featuredProductText { get { return cc_api_FeaturedProducts.getInstance().featuredProductText; }  private set; }
	public List<Id> featuredProductList { get { return cc_api_FeaturedProducts.getInstance().featuredProductList;}  private set; }
	public List<Id> spotLightProductList { get { return cc_api_FeaturedProducts.getInstance().spotLightProductList; } private set; }
 	//==================================================
     // CONSTRUCTOR
     //==================================================
    public cc_ctrl_FeaturedProducts() {
    }
    
}