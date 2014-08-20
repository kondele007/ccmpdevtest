public with sharing class cc_ctrl_admin_Catalog {
    public with sharing class dataAlreadyLoadedException extends Exception {}
    //==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public String loadStatus {get; set;}
    public Boolean disableFlag {get;set;}
	
	//==================================================
    // CONSTRUCTOR  
    //==================================================
    public cc_ctrl_admin_Catalog() {
    }
	
	//==================================================
    // METHODS
    //==================================================
    public void loadBreadCrumbs() {
    	cc_util_BreadCrumb.clearBreadCrumbs();
    	cc_util_BreadCrumb.loadBreadCrumbs();
    	disableFlag = false;
    }

    public void refreshMenuCaches() {
    	cc_api_HtmlCache.deleteAllMenuHtmlCaches();
    	cc_api_HtmlCache.cacheMenus();
    }

    public void refreshCategoryCaches() {
    	cc_api_HtmlCache.deleteAllCategoryTreeHtmlCaches();
    	cc_api_HtmlCache.cacheCategoryTreeHtml();
    }

    public void refreshProductSpecIndexData() {
        //delete existing productspecindex
        List<E_ProductSpecIndex__c> productSpecList = [select Id from E_ProductSpecIndex__c];
        try{
            Database.delete(productSpecList);
        } catch(Exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Error deleting existing product spec index entries. Message ' + e.getMessage());
            ApexPages.addMessage(myMsg);
            return;
        }

        ID batchprocessid = Database.executeBatch(new cc_job_LoadProductSpecIndex('Select Id from E_Product__c'), 5);
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'ProductSpecIndex table is being refreshed!');
        ApexPages.addMessage(myMsg);
    }
}