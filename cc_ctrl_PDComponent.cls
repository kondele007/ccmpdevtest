public with sharing class cc_ctrl_PDComponent {
	private cc_ctrl_ProductDetail vPDController = null;
	public map<string, string> widgetConfiguration { get { return vPDController.widgetConfiguration; } private set; }
	public cc_bean_ProductForm getProductForm() { return vPDController.productForm; }
	public string CurrentCartID { get{ return vPDController.currentCartID; } set { vPDController.currentCartID=value;}} 
	public string CurrentProductID { get{ return vPDController.CurrentProductID; } set { vPDController.CurrentProductID=value;}} 
	public string CurrentCategory { get{ return vPDController.CurrentCategory; } set { vPDController.CurrentCategory=value;}}
	public cc_ctrl_ProductDetail ProductDetailController { 	
		get {return vPDController;} 
		set {
				System.debug(LoggingLevel.INFO, 'cc_ctrl_PDComponent.setProductDetailController: setting controller=' + value);
				Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.INFO,'cc_ctrl_PDComponent.setProductDetailController: setting controller=' + value));
				vPDController = value;
				vPDController.productDetail();
		}
	}
	
	public void addRecentItemInPD() {
		vPDController.addRecentItemInPD();
	}
	public PageReference addProductsToCart() {
		return vPDController.addProductsToCart();
	}
	public PageReference AddMainProductToCart() {
		return vPDController.AddMainProductToCart();
	}
	public String storeID {
    	get {
    		return vPDController.storeID;
    	}
    }
    
	public E_StorefrontSettings__c getStorefront() { return vPDController.storeFront; }
	public Integer quantity { get { return vPDController.quantity;} set {vPDController.quantity=value;} }
	public String selectedProduct { get { return vPDController.selectedProduct;} set {vPDController.selectedProduct=value;} }
	public List<cc_bean_SelectableProduct> selectableProductList { get { return vPDController.selectableProductList;} set {vPDController.selectableProductList=value;} }
	public List<cc_bean_SelectableProduct> requiredItems { get { return vPDController.requiredItems;} private set;}
	public PageReference configureProduct() {
		return vPDController.configureProduct();
	}
	public string ipAddressLocation {get {return vPDController.ipAddressLocation;} set { vPDController.ipAddressLocation = value;} } 
	public string ipAddressLocationKey {get {return cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY;} set;}  
	public List<cc_bean_ProductListViewData> getAccessoryProductList() { return vPDController.AccessoryProductList; }
	
	public List<cc_bean_ProductListViewData> getItemIncludedListViewData() { return vPDController.ItemIncludedListViewData; }
	public List<cc_bean_ProductListViewData> getRelatedProductList() { return vPDController.RelatedProductList; }
	public List<cc_bean_ProductListViewData> getCrossSellProductList() { return vPDController.CrossSellProductList; }
	public List<cc_bean_ProductListViewData> getUpSellProductList() { return vPDController.UpSellProductList; }
	public List<cc_bean_ProductListViewData> getRequiredItemList() { return vPDController.RequiredItemList; }
	public List<cc_bean_ProductListViewData> getCompetitiveProductList() { return vPDController.CompetitiveProductList; }
	public List<cc_bean_ProductListViewData> getComplementaryProductList() { return vPDController.ComplementaryProductList; }
	
}