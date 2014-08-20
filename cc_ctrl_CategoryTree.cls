public with sharing class cc_ctrl_CategoryTree {

    //==================================================
    // INSTANCE PROPERTIES
    //==================================================
	public cc_ctrl_CloudCraze ccCtrl {get;set;}

    public String treeHtml {
    	get {
    		if(treeHtml == null) {
    			treeHtml = getCategoryTreeHtmlFromCache();
    		}
    		return treeHtml;
    	}
    	set;
    }
    
    //==================================================
    // CONSTRUCTOR
    //==================================================
    public cc_ctrl_CategoryTree() {}
    
    //==================================================
    // SERVICE METHODS
    //==================================================
    public String getCategoryTreeHtmlFromCache() {
    	String treeHtml = cc_api_HtmlCache.getCategoryTreeHtml(ccCtrl.storefront.Name, 'en_US');
    	//System.debug(LoggingLevel.INFO, 'cc_ctrl_CategoryTree.getCategoryTreeHtmlFromCache: treeHtml=' + treeHtml);
    	if(treeHtml == null) {
    		treeHtml = '';
    	}
    	return treeHtml;
    }
}