public with sharing class cc_api_FeaturedProducts {
	private static cc_api_FeaturedProducts fp = null;
	private cc_api_FeaturedProducts() {
		initialize();
	}
	public static cc_api_FeaturedProducts getInstance() { 
		if(fp == null) {
			fp = new cc_api_FeaturedProducts(); 
		} 
		return fp;
	}
	
	private List<E_FeaturedProduct__c> vProductList = null;
	private map<Id, String> vFeaturedProductText = null;
	private List<Id> vFeaturedProductList = null;
	private List<Id> vSpotLightProductList =null;
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public map<Id, String> featuredProductText { get { return vFeaturedProductText; }  private set; }
	public List<Id> featuredProductList { get { return vFeaturedProductList;}  private set; }
	public List<Id> spotLightProductList { get { return vSpotLightProductList; } private set; }
 	//==================================================
     // CONSTRUCTOR
     //==================================================
    public void initialize() {
    	
    	if(vProductList == null) {
    		vProductList = [select e.Product__c, e.Product__r.Name, e.Description__c, Type__c  from E_FeaturedProduct__c e where Type__c in ( 'Spotlight', 'Featured') AND e.Enabled__c = true ORDER BY e.Sequence__c DESC];
    		vFeaturedProductText = new map<Id, String>();
    		vFeaturedProductList = new List<Id>();
    		vSpotLightProductList = new List<Id>();
    		for(E_FeaturedProduct__c feat : vProductList) {
    			if(feat.Type__c.equals('Spotlight')) {
    				//Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO,'spot product=' + feat.Product__r.Name));
    				vSpotLightProductList.add(feat.Product__c); 	
    				vFeaturedProductText.put(feat.Product__c, feat.Description__c);
    			} else if(feat.Type__c.equals('Featured')) {
    				//Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO,'feature product=' + feat.Product__r.Name));
    				vFeaturedProductList.add(feat.Product__c);
    				vFeaturedProductText.put(feat.Product__c, feat.Description__c);
    			}
    		}
    	}
    	
    }
}