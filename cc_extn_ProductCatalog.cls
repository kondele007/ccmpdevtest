public with sharing class cc_extn_ProductCatalog extends cc_ExtensionBase {
	public cc_extn_ProductCatalog getProductCatalog() { return this; }
	public String currentProductID { get; set; }
	public string searchString {get; set; }
	
	public static final String name = 'ProductCatalog';
	public override string getName() {
		return name;
	}
	public cc_extn_ProductCatalog(cc_ctrl_CloudCraze c) {
		super(c);
	}
	
	public override Object query(Object subject, String q) {
		if(q == cc_ExtensionBase.Query_ProductIdId) {
			return currentProductID;
		}
		return null;
	}
	
	public PageReference quickSearch()  {
		
		PageReference page=System.Page.Products;
		page.getParameters().put('cartID', parentController.ccCartId);
		page.getParameters().put('operation', 'quickSearch');
		page.getParameters().put('searchText', searchString);
		page.getParameters().put(parentController.ipAddressLocationKey, parentController.ipAddressLocation);
		page.setRedirect(true);
        System.debug('--- forwarding to page: ' + page.getUrl());
        //set cookie
        //setProductListViewCookie();
		return page;
	}
}