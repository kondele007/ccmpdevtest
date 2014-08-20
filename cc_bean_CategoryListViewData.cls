public with sharing class cc_bean_CategoryListViewData {
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
	public E_Category__c category { get; set; }
	public String Alt_Message { get; set; }
	public Id attachmentId { get; set; }
	public String categoryId { get; set; }
	public cc_bean_MockCategory mockCategory { get; set; }
}