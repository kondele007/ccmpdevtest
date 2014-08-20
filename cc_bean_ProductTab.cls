public with sharing class cc_bean_ProductTab {
	
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public Id sfid {get;set;}
    public String name {get;set;}
    public String content {get;set;}
	
	//==================================================
    // CONSTRUCTORS
    //==================================================
	public cc_bean_ProductTab(E_ProductTab__c tab) {
		if(tab != null) {
            try{sfid = tab.Id;}catch(SObjectException e){/*System.debug(e);*/}
            try{name = tab.Tab__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{content = tab.Content__c;}catch(SObjectException e){/*System.debug(e);*/}
		}
	}
}