//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_ctrl_BreadCrumb  {
	private cc_ctrl_cloudCraze vDelegate=null;
	public cc_ctrl_cloudCraze delegate { get { return vDelegate; } set { vDelegate = value; initialize();} }
    //==================================================
    // INSTANCE PROPERTIES
    //==================================================	
	public Boolean displayCategoryBreadCrumb {get;set;}
    public Boolean displaySearchBreadCrumb {get;set;}
    
    public Boolean displaySearchBreadCrumbWithoutLink {get;set;}
    
	public String ipAddressLocationKey { 
		get {
			return cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY;
		} set; } 
    
    public String viewState  { get{ return vDelegate.viewState; } set { vDelegate.viewState=value;}} 
    
   // public String searchString { get; set; }
    public String currentCategory { get; set; }
    public String currentCartID { get{ return vDelegate.getCartId(); } private set; }
    
    public String sku {get;set;}
    public String searchText {get;set;}
    public String productName {get;set;}
    public string ipAddressLocation {get {return vDelegate.ipAddressLocation;} set { vDelegate.ipAddressLocation = value;} } 
    
	public Integer breadCrumbRowCount{get;set;}
    public Integer listSize{
        get{
            return breadCrumbNameList.size();
        }
        set;
    }
    public String breadCrumbSeperator{
        get{
            return cc_cnst_CloudCraze.breadCrumbSepearator;
        }
        set;
    }
    
    public String breadCrumbNameStr{get;set;}
   
    
    public List<String> breadCrumbNameList {get;set;}
    public Map<String,String> breadCrumbIDMap {get;set;}
    
    public String level1Page {get;set;}
    public String level1DisplayName {get;set;}
    public String level1Url {get;set;}
    
    public String level2Page {get;set;}
    public String level2DisplayName {get;set;}
    public String level2Url {get;set;}

    public String level3DisplayName {get;set;}
    //==================================================
    // INSTANCE VARIABLES
    //==================================================
    private ApexPages.StandardController controller;
    //==================================================
    // CONSTRUCTOR
    //==================================================
    public void initialize() {
    	//ipAddressLocation = Apexpages.currentPage().getParameters().get(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY);
        //currentcartID=Apexpages.currentPage().getParameters().get('cartID');
        
        if(level2DisplayName != null && level1Page != null) {
      	   level1Url = '/apex/' + level1Page;
        }

        if(level3DisplayName != null && level2Page != null) {
      	   level2Url = '/apex/' + level2Page;
        }
        
        //navigation is quick search when the user navigates to product details using quick search.    
        String navigation = Apexpages.currentPage().getParameters().get('navigationStr');   
        //Operation is quickSearch when  you click on quick search button or press enter on a quick search in the product search widget.   
        String op = Apexpages.currentPage().getParameters().get('operation');   
        searchText=Apexpages.currentPage().getParameters().get('searchText');  
        currentCategory=Apexpages.currentPage().getParameters().get('categoryID');     
	    //viewState=Apexpages.currentPage().getParameters().get('viewState');          
        sku = Apexpages.currentPage().getParameters().get('sku');
        if('CatalogSearchInc'.equals(navigation))
        {
            searchText=Apexpages.currentPage().getParameters().get('searchText');   
            displayCategoryBreadCrumb=false;
            displaySearchBreadCrumb=true;
            setNameofProduct();
            
        }
        else if('quickSearch'.equals(op)){
        	searchText=Apexpages.currentPage().getParameters().get('searchText');   
            displayCategoryBreadCrumb=false;
            displaySearchBreadCrumbWithoutLink=true;
        }
        else{
        	//System.debug('--------calling breadcrumbs-----------');
            displayCategoryBreadCrumb=true;
            displaySearchBreadCrumb=false;
            getBreadCrumbs();
        }
            
        //System.debug('--- cc_ctrl_BreadCrumb: level1Page=' + level1Page + ', level1DisplayName=' + level1DisplayName + ', level1Url=' + level1Url);
        //System.debug('--- cc_ctrl_BreadCrumb: level2Page=' + level2Page + ', level2DisplayName=' + level2DisplayName + ', level2Url=' + level2Url);
        //System.debug('--- cc_ctrl_BreadCrumb: level3DisplayName=' + level3DisplayName);
    }
    public cc_ctrl_BreadCrumb() {
    	
        
    }
    
    
    public cc_ctrl_BreadCrumb(ApexPages.StandardController c){
    	    this();
    	
    }
    
    //==================================================
    // HELPER METHODS
    //==================================================
    public void setNameofProduct(){
    	List<E_Product__c> productInstanceList= new List<E_Product__c>();
        String locale = cc_util_Locale.getUserLanguage();
        productInstanceList= [ Select e.Name,
                               (Select Name
                                  From Product_Item_I18Ns__r
                                  where Locale__c=:locale)
    	                   From E_Product__c e
    	                   where e.SKU__c =:sku
    	                   limit 1
    	                 ];
    	if(productInstanceList!=null && productInstanceList.size()>0){
    	   E_product__c prod = productInstanceList.get(0);
    	   productName = prod.Name;
    	   for(E_ProductItemI18N__c item : prod.Product_Item_I18Ns__r){
    	   	 if(!al.StringUtils.isEmpty(item.Name)){
    	   	 	productName = item.Name;
    	   	 }
    	   }
    	}
    	 
    }
    
            
	public void getBreadCrumbs() {
		String categoryName;
		String parentCategory = Apexpages.currentPage().getParameters().get('parentCategory');
		Integer loopIndex = 0;
		breadCrumbNameList = new List<String>();
		breadCrumbIDMap = new Map<String,String>();
		E_BreadCrumb__c breadCrumbInstance = new E_BreadCrumb__c();
		E_ProductCategory__c productCategory = new E_ProductCategory__c();
		
		if('DetailView'.equalsIgnoreCase(viewState) ) {
			//try { 
				if(parentCategory != null && parentCategory != '') {
					List<E_ProductCategory__c> pcats = [select p.Category__c, p.Product__r.Name
										from E_ProductCategory__c p 
										where p.Product__r.SKU__c = :sku
											and p.Category__c= :parentCategory];
					if(pcats.size() > 0) {
						productCategory = pcats[0];
					} 
				} else {
					List<E_ProductCategory__c> pcats = [select p.Category__c, p.Product__r.Name
										from E_ProductCategory__c p 
										where p.Product__r.SKU__c = :sku
										limit 1];
					if(pcats.size() > 0) {
						productCategory = pcats[0];
						cc_util_CloudCraze.productCategory=productCategory.Category__c;
					} 
					// Apexpages.currentPage().getParameters().put('categoryID',productCategory.Category__c);
				}
				
				// assign product name for use in breadcrumbs.
				setNameOfProduct();
				
				//System.debug('--- cc_ctrl_BreadCrumb.getBreadCrumbs: breadCrumbInstance DetailView query: productCategory.Category__c=' + productCategory.Category__c + ', cc_util_Locale.getUserLanguage=' + cc_util_Locale.getUserLanguage());
                
                List<E_BreadCrumb__c> bcis = [select BreadCrumbURL__c, BreadCrumb__c
										from E_BreadCrumb__c
										where CategoryId__c = :productCategory.Category__c
											and Locale__c = :cc_util_Locale.getUserLanguage()];
			    if(bcis.size() > 0) {
					breadCrumbInstance = bcis[0];
			    }
			//} catch(Exception e) {
				//ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'Product not associated with any category. Breadcrumbs will not be displayed',e.getMessage());
				//ApexPages.addMessage(myMsg);
			//	return;
			//}
		} else {
			try{
				//System.debug('--- cc_ctrl_BreadCrumb.getBreadCrumbs: breadCrumbInstance query: currentCategory=' + currentCategory + ', cc_util_Locale.getUserLanguage=' + cc_util_Locale.getUserLanguage());
				
				List<E_BreadCrumb__c> bcis = [select BreadCrumbURL__c, BreadCrumb__c
										from E_BreadCrumb__c
										where CategoryId__c = :currentCategory
											and Locale__c = :cc_util_Locale.getUserLanguage()];
				
			    if(bcis.size() > 0) {
					breadCrumbInstance = bcis[0];
			    }
			} catch(Exception e) {
				//ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'No Breadcrumb data available.Breadcrumbs will not be displayed',e.getMessage());
				//ApexPages.addMessage(myMsg);
				return;
			}
		}
            
		/*
		 * Avoid error when user changes store parameter in the URL. Parse breadcrumbs only if the category is associated to the particular
		 * storefront.
		 * 
		 * If the breadcrumb length is same as root, the product is associated with the parent category 
		 */
			 
		Integer rootBreadCrumbLength=cc_util_CloudCraze.getRootBreadCrumbLength(vDelegate.store);

		if(breadCrumbInstance == null || breadCrumbInstance.BreadCrumb__c == null || (breadCrumbInstance.BreadCrumb__c.length() <= rootBreadCrumbLength)) return;

		if(breadCrumbInstance != null && breadCrumbInstance.BreadCrumb__c != null && breadCrumbInstance.BreadCrumbURL__c != null) {
			//System.debug('---- getBreadCrumbs() check point 1------' + breadCrumbInstance.BreadCrumb__c);
			//System.debug('---- getBreadCrumbs() check point 2------' + rootBreadCrumbLength);
			//System.debug('---- getBreadCrumbs() check point 3------' + cc_util_CloudCraze.rootBreadCrumbURLLength);
			breadCrumbInstance.BreadCrumb__c=breadCrumbInstance.BreadCrumb__c.substring(rootBreadCrumbLength); 
			breadCrumbInstance.BreadCrumbURL__c=breadCrumbInstance.BreadCrumbURL__c.substring(cc_util_CloudCraze.rootBreadCrumbURLLength);                                  
			String[] splitStr=al.StringUtils.split(breadCrumbInstance.BreadCrumb__c,'>');
			
			//System.debug('---- getBreadCrumbs() splitStr------' + splitStr);
			
			String[] splitStrID = al.StringUtils.split(breadCrumbInstance.BreadCrumbURL__c,'>');
			
			for(loopIndex = 0; loopIndex < splitStr.size(); loopIndex++) {
				breadCrumbNameList.add(splitStr[loopIndex]);
			}
			
			////System.debug('---- getBreadCrumbs() breadCrumbNameList------' + breadCrumbNameList);

			if(splitStr != null && splitStr.size() > 0 && splitStrID != null && splitStrID.size() > 0) {
				for(loopIndex = 0; loopIndex < splitStr.size(); loopIndex++) {
					breadCrumbIDMap.put(splitStr[loopIndex],splitStrID[loopIndex]);
				}
			}
		}
		
		Integer noOfQueries = Limits.getQueries();
		//System.debug('----Limits.getQueries()-CC_BreadCrumbController.getBreadCrumbs---- : ' + noOfQueries);	
	}
    //==================================================
    // SERVICE METHODS
    //==================================================
    public PageReference breadCrumbURL(){
        if(breadCrumbIDMap!=null){
           currentCategory=breadCrumbIDMap.get(breadCrumbNameStr); 
        }
        //PageReference('/apex/Products');
	    PageReference page=System.Page.Products; 
	     
	    page.getParameters().put('categoryID', currentCategory);
	    page.getParameters().put('cartID', currentCartID);
	    page.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY, Apexpages.currentPage().getParameters().get(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY));
	  
	    page.setRedirect(true);
	    return page;	            
     }
        
	public PageReference quickSearch()  {
		PageReference page=System.Page.Products;
		page.getParameters().put('cartID', currentCartID);
		page.getParameters().put('operation', 'quickSearch');
		page.getParameters().put('searchText', searchText);
		page.getParameters().put(ipAddressLocationKey, ipAddressLocation);
		page.setRedirect(true);
        //System.debug('--- forwarding to page: ' + page.getUrl());
        //set cookie
        //setProductListViewCookie();
		return page;
	}
	
}