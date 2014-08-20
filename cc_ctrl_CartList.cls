//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
/*
    cc_ctrl_CartList gets the list of carts for the current user.  If the user is not signed
    in, no carts will be made available. 
*/ 
global with sharing class cc_ctrl_CartList extends cc_hlpr_Paginator implements al.ObjectPaginatorListener {
   public cc_ctrl_CartList getMyCartController() { return this; }
   public cc_ctrl_MyAccount  myAccount { get; set; }
	//==================================================
    // CONSTRUCTOR
    //==================================================
	public cc_ctrl_CartList(){
        initialization();
        system.debug('cc_ctrl_CartList default constructor');
	}	

    public cc_ctrl_CartList(cc_ctrl_MyAccount c) {
		this();
        this.myAccount = c;
        system.debug('cc_ctrl_CartList cc_ctrl_CartList =>should not be here');
    }
	
	private void initialization() {
		system.debug('cc_ctrl_CartList initialization');
		this.paginate = false;
        pageCarts = new List<cc_bean_MyCartItem>();
			}

	//==================================================
    // SERVICE METHODS
    //==================================================

	//==================================================
    // CONSTANTS
    //==================================================
    public final Integer MAX_RECORDS = 5;
    //==================================================
    // INSTANCE PROPERTIES
    //==================================================
	//public String cartNumber {get;set;}
    public String cartName {get;set;}
    public String status {get;set;}
    public List<cc_bean_MyCartItem> pageCarts {get; set;}
    
    public cc_bean_MyCartItem selectedCart {get;set;}
    public String selectedCartNumber {get;set;}
 	
 	 public String ipAddressLocationKey { 
        get {
            return cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY;
        }
        set;
    } 
    public string ipAddressLocation {get {return myAccount.ipAddressLocation;} set { myAccount.ipAddressLocation = value;} }
	public String currentCartID { get { return myAccount.getCartId(); } set { myAccount.CCCartId = value; } }
    public  List<SelectOption> statusCodes {
        get {
            List<SelectOption> optionList = new List<SelectOption>();
            return optionList;
        }
        set;
        
    }

    // Indicates whether this page should be paginated or only list a sub-set of results
    // true=paginate all results, false=display a subset of results
    public boolean paginate { 
        get {
        	System.debug(myAccount);
        	boolean b1=myAccount.CARTS_VIEW == null;
        	boolean b2=myAccount.viewState == null;
            if(myAccount.CARTS_VIEW==myAccount.viewState){
                return true;
            }
            return false;
        }
        
        set;
    }
    //==================================================
    // INSTANCE VARIABLES
    //==================================================
    public List<cc_bean_MyCartItem> cartList = new List<cc_bean_MyCartItem>();
    
    //==================================================
    // HELPER METHODS
    //==================================================     
    public List<cc_bean_MockCart> getMockCartList() {
    	List<cc_bean_MockCart> mockCarts = new List<cc_bean_MockCart>();
    	List<cc_bean_MyCartItem> carts = getCartList();
    	if(carts != null) {
    		for(cc_bean_MyCartItem ci : carts) {
    			mockCarts.add(new cc_bean_MockCart(ci ));
    		}
    	}
    	return mockCarts;
    }
    public List<cc_bean_MyCartItem> getCartList(){
        if(paginator == null){
            queryCarts();
        }
        if(paginate){
            return pageCarts;
        }
        else {
            Integer listSize = MAX_RECORDS;
            if(listSize > paginator.all.size()){
                listSize = paginator.all.size();
            }
            List<cc_bean_MyCartItem> shortList = new List<cc_bean_MyCartItem>();
            for(Integer i = 0; i < listSize; i++){
                shortList.add((cc_bean_MyCartItem)paginator.all.get(i));
            }
            
            return shortList;
        }
    }

	 global void handlePageChange(List<Object> newPage){
            pageCarts.clear();
            
            // Get all the productCategoryList objects
            // Update the  list of records that should be returned (set them in the paginator)
            if(paginator.page != null){
                for(Object o: paginator.page){
                    pageCarts.add((cc_bean_MyCartItem)o);
                }
            }

    }
    
    public void queryCarts(){
        queryCarts(null);
    }

    // Get and set the order list for the current user
    public void queryCarts(String cartId) {
            List<E_Cart__c> carts = new List<E_Cart__c>();
        
            cartList.clear();
            
            // Get the current user
            //ID portalUserID = al.UserUtils.getCurrentUserPortalAccountID();
            
            // Query for orders for the current user
            // TODO - PONumber doesn't seem to exist - is it in a related object?
            //if(portalUserID != null){
                // TODO -- make this for only the current user
                //myList = [select ID, OrderDate__c, OrderNumber__c, TotalAmount__c, OrderProductStatus__c from E_Order__c where User__r.ID = :portalUserID];
                String query = 'select ID,'
                    + 'CartId__c,'
                    + 'Name,'
                    + 'Name__c,'
                    + 'EncryptedID__c,' 
                    + 'TotalAmount__c,'                    
                    + 'CartStatus__c,'
                    + 'ActiveCart__c,'
                    + 'LastModifiedDate,'  
                    + 'SubtotalAmount__c,'
                    + 'TotalDiscount__c,'
                    + 'TotalShipDiscount__c,'
                    + 'BillTo__r.FirstName__c,'
                    + 'BillTo__r.MiddleName__c,'
                    + 'BillTo__r.LastName__c,'
                    + 'BillTo__r.AddressFirstline__c,'
                    + 'BillTo__r.AddressSecondline__c,'
                    + 'BillTo__r.City__c,'   
                    + 'BillTo__r.StateISOCode__c,'       
                    + 'BillTo__r.PostalCode__c,'
                    + 'ShipTo__r.FirstName__c,'
                    + 'ShipTo__r.MiddleName__c,'
                    + 'ShipTo__r.LastName__c,'
                    + 'ShipTo__r.AddressFirstline__c,'
                    + 'ShipTo__r.AddressSecondline__c,'
                    + 'ShipTo__r.City__c,'          
                    + 'ShipTo__r.StateISOCode__c,'       
                    + 'ShipTo__r.PostalCode__c,'
                    + 'SubTotalAmount_2__c'
                    + ' from E_Cart__c'
                    + ' Where OwnerId = ' + '\'' + UserInfo.getUserId() + '\''
                    + ' And CartStatus__c = \'' + cc_cnst_PickListConstants.CARTSTATUS_OPEN + '\''
                    + ' And CartType__c = \'' + cc_cnst_PickListConstants.CARTTYPE_CART + '\'';
                    
                if(cartId != null){
                    query += ' And Cart__c = \'' + cartId + '\' LIMIT 1';
                } else {
                    query += ' LIMIT 1000';
                }
                //System.debug('QWERTY'+query);
                carts = Database.query(query);
                buildCartListFromResults(carts);                
            //} 
            
            
            //return myList;
        } 
        
        private void buildCartListFromResults(List<E_Cart__c> carts){
                cc_bean_MyCartItem item;
                for(E_Cart__c cart: carts){
                	if (al.StringUtils.isNotBlank(cart.EncryptedID__c)) {
                    	item = new cc_bean_MyCartItem();
                    	item.cart = cart;
                    	item.billingAddress = cart.BillTo__r;
                    	item.shippingAddress = cart.ShipTo__r;
                    	cartList.add(item);                		
                	}
                }
            paginator = new al.ObjectPaginator((al.ObjectPaginatorListener)this);
            paginator.setRecords((List<Object>)cartList);
        }
    
   //==================================================
    // SERVICE METHODS
    //==================================================

    public PageReference displayCartSummary(){
    	String cartToActivate = selectedCartNumber;
    	String encryptedActiveCart = '';
    	PageReference page = System.Page.Cart; //new PageReference('/apex/Cart');
    	List<E_Cart__c> listOfCarts = cc_dao_Cart.getOpenCartOwnedBy(UserInfo.getUserId());
    	//System.debug('-----cc_ctrl_CartList.displayCartSummary-listofcarts : ' + listOfCarts);
    	if(al.ArrayUtils.isNotEmpty(listOfCarts) && al.StringUtils.isNotBlank(cartToActivate)){
    		for(E_Cart__c thisCart : listOfCarts){
    			if(thisCart.id == cartToActivate){
    				thisCart.ActiveCart__c = true;
    				encryptedActiveCart = thisCart.EncryptedID__c;
    			}else{
    				thisCart.ActiveCart__c = false; 
    			} 
    		}
    		//System.debug('-----cc_ctrl_CartList.displayCartSummary-(after update)listofcarts : ' + listOfCarts);
    		update listOfCarts;
        	page.getParameters().put('cartID', encryptedActiveCart);
        	page.getParameters().put('viewState','CartView');
        	page.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY,ipAddressLocation);
        	page.setRedirect(true);
    	} else {
    		page = System.Page.HomePage; //new PageReference('/apex/HomePage');
        	page.getParameters().put('cartID', encryptedActiveCart);
        	page.getParameters().put(cc_cnst_CloudCraze.IP_ADDRESS_LOCATION_KEY,ipAddressLocation);
        	page.setRedirect(true);    		
    	}
        return page;  
    }
        
        public void searchCarts(){
            // Clear the cart list
            cartList.clear();
            
            // Get the base query
            String query = 'select ID, CartId__c, Name,TotalAmount__c, CartStatus__c, LastModifiedDate,EncryptedID__c,' +
                           'BillTo__r.FirstName__c, BillTo__r.MiddleName__c, BillTo__r.LastName__c,' +
                           'ShipTo__r.FirstName__c, ShipTo__r.MiddleName__c, ShipTo__r.LastName__c ' +
                           'from E_Cart__c ';
            
            // Build the 'where' clause
            String whereClause = '';
            
            // Add cart number clause
            // Added to prevent SOQL Injection
            if(selectedCartNumber != null) {
                selectedCartNumber = String.escapeSingleQuotes(selectedCartNumber);
            }

            if(selectedCartNumber != null && selectedCartNumber.length() > 0){
                    whereClause += ' ID=\'' + selectedCartNumber + '\'';
            }
            
            // Add cart name clause
            if(cartName != null && cartName.length() > 0){
            	// Added to prevent SOQL Injection
            	cartName = String.escapeSingleQuotes(cartName);	
                    if(whereClause.length() > 0){
                        whereClause += ' and';
                    }               
                    whereClause += ' Name=\'' + cartName + '\'';
            }
            // Add status clause
            if(status != null && status.length() > 0 && !status.equals(myaccount.ALL)){
            	// Added to prevent SOQL Injection
            	status = String.escapeSingleQuotes(status);
            	String cartStatusCode = String.escapeSingleQuotes('CartStatus');
                    if(whereClause.length() > 0){
                        whereClause += ' and';
                    }               
                    whereClause += ' CartStatus__c=\'' + status + '\'';                 
                    
            }

            // Add from date
            String fromDate = myaccount.getDateQueryFormat(myaccount.dateProxy.RequestDate__c);
            if(fromDate != null){
                if(whereClause.length() > 0){
                    whereClause += ' and';
                }
                whereClause += ' LastModifiedDate >= ' + fromDate;
            }
            
            
            // Add to date
            String toDate = myaccount.getDateQueryFormat(myaccount.dateProxy.DeliveryDate__c);
            if(toDate != null){
                if(whereClause.length() > 0){
                    whereClause += ' and';
                }
                
                whereClause += ' LastModifiedDate <= ' + toDate;
            }
            
            // Set the limit
            if(whereClause.length() > 0){
                query += ' where ' +whereClause + ' LIMIT 1000';
            }
            //System.debug('------- CARTLIST QUERY: ' + query);
            
            // Run the query
            List<sObject> results = Database.query(query);
            List<E_Cart__c> carts = (List<E_Cart__c>)results; 
            buildCartListFromResults(carts);
        }

    
    
   

}