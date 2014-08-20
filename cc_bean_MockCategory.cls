public with sharing class cc_bean_MockCategory {
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
	public String id { get; set; }
	public String name { get; set; }
	public String ShortDesc{ get; set; } 
	//==================================================
    // CONSTRUCTOR
    //==================================================
	public cc_bean_MockCategory(E_Category__c cat) {
		this.id=cat.id;
		this.name=cat.name;
		this.ShortDesc=cat.ShortDesc__c;
	
	}
}