global with sharing class cc_ctrl_myaccount_Carts {
//extends cc_hlpr_Paginator implements al.ObjectPaginatorListener {
/*
	//==================================================
    // CONSTANTS
    //==================================================
    public final Integer MAX_RECORDS = 5;

    //==================================================
    // INSTANCE VARIABLES
    //==================================================
    public List<cc_bean_MyCartItem> cartList = new List<cc_bean_MyCartItem>();
	public string editCartId { get; set; }
	//==================================================
	// INSTANCE PROPERTIES
	//==================================================
	public cc_ctrl_MyAccount myAccountController {get;set;}
	public String currentCartID {get;set;}
    public List<cc_bean_MyCartItem> pageCarts {get; set;}
	public String deleteCartID {get; set;}
	public String cloneCartID { get; set; }
    public String selectedCartNumber {get;set;}

    // Indicates whether this page should be paginated or only list a sub-set of results
    // true=paginate all results, false=display a subset of results
    public boolean paginate { 
        get {
			return true;
        }
        set;
    }

	//==================================================
	// CONSTRUCTORS
	//==================================================
	public cc_ctrl_myaccount_Carts() {
		paginate = false;
        pageCarts = new List<cc_bean_MyCartItem>();
        //MockCartList = new List<cc_bean_MockCart>();
        MockCartList =getMockCartList();
	}

	//==================================================
	// METHODS
	//==================================================
    public PageReference displayCartSummary() {
    	String cartToActivate = selectedCartNumber;
    	String encryptedActiveCart = '';
    	PageReference page = System.Page.Cart; //new PageReference('/apex/Cart');
    	List<E_Cart__c> listOfCarts = cc_dao_Cart.getOpenCartOwnedBy(UserInfo.getUserId());
    	//System.debug('-----cc_ctrl_CartList.displayCartSummary-listofcarts : ' + listOfCarts);
    	if(al.ArrayUtils.isNotEmpty(listOfCarts) && al.StringUtils.isNotBlank(cartToActivate)) {
    		for(E_Cart__c thisCart : listOfCarts) {
    			if(thisCart.id == cartToActivate) {
    				thisCart.ActiveCart__c = true;
    				encryptedActiveCart = thisCart.EncryptedID__c;
    			} else {
    				thisCart.ActiveCart__c = false; 
    			} 
    		}
    		//System.debug('-----cc_ctrl_CartList.displayCartSummary-(after update)listofcarts : ' + listOfCarts);
    		update listOfCarts;
        	page.getParameters().put('cartID', encryptedActiveCart);
        	page.getParameters().put('viewState','CartView');
        	page.setRedirect(true);
    	} else {
    		page = null;
    	}

        return page;  
    }

	public List<cc_bean_MockCart> MockCartList { get ; set; }
    private List<cc_bean_MockCart> getMockCartList() {
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
                    query += ' order by Name desc LIMIT 1000';
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

	public PageReference editCart() {
		PageReference page = System.Page.Cart;
		page.getParameters().put('productID', '');
		page.getParameters().put('viewState','CartView');
		page.setRedirect(true);
		return page;
	}

	public PageReference createNewCart() {
		//System.debug('------------ IN createNewCart');
		cc_api_Cart cart = new cc_api_Cart();
		E_Cart__c newCart = cart.createEmptyCart();

		String cartID = '';
		if(newCart!=null) {
			 //System.debug('---------- newCart ID: ' + newCart.ID);
			cartID = newCart.EncryptedID__c;
			//cartID = newCart.ID;

		}

		PageReference pr = System.Page.HomePage;
		pr.getParameters().put('cartID', cartID);
		//pr.getParameters().put('store',store);
		return pr;
	}

	public PageReference makeCartActive() {
		String cartToActivate = ApexPages.currentPage().getParameters().get('make_active');
		String encryptedActiveCart = '';
		List<E_Cart__c> listOfCarts = cc_dao_Cart.getOpenCartOwnedBy(UserInfo.getUserId());
		/*
		[select id, ActiveCart__c, EncryptedID__c from E_Cart__c where ownerid = :UserInfo.getUserId()];
		*/
		/*
		//System.debug('listofcarts'+listOfCarts);
		//System.debug('cartToActivate->'+cartToActivate);
		if(listOfCarts != null && listOfCarts.size() > 0) {
			for(E_Cart__c thisCart : listOfCarts) {
				//System.debug('current cat->'+thisCart.id);
				if(thisCart.id == cartToActivate) {
					thisCart.ActiveCart__c = true;
					encryptedActiveCart = thisCart.EncryptedID__c;
					//System.debug('thisCart.id == cartToActivate');
				}else{
					thisCart.ActiveCart__c = false;
					//System.debug('thisCart.id != cartToActivate');
				}

			}


		update listOfCarts;

		PageReference page = System.Page.Cart;
		page.getParameters().put('cartID', encryptedActiveCart);
		page.getParameters().put('viewState','CartView');
		//page.getParameters().put('store',store);

		page.setRedirect(true);
		return page;
		}
		return null;
	}

	public PageReference cloneCart() {
		cc_api_cart cartApi = new cc_api_cart();
		
		cartApi.cloneCart(cloneCartID);
		paginator=null;
		MockCartList =getMockCartList();
		return null;
	}
	
	public PageReference inplaceEditCart() { 
		editCartId = ApexPages.currentPage().getParameters().get('editCartId'); 
		
		System.debug('----->edit cart---' + editCartId);
		return null;
	}
	public PageReference cancelEdit() { 
		editCartId = null; 
		
		return null;
	}
	public PageReference saveEdit() { 
		editCartId = ApexPages.currentPage().getParameters().get('editCartId'); 
		list<E_Cart__c> carts = new list<E_Cart__c>();
		for(cc_bean_MockCart bean: MockCartList)  {
			if(editCartId == bean.cartId) {
			
				carts.add(new E_Cart__c(id = bean.cartId, name__c = bean.cartName));
			}
		}
		update carts;
		editCartId=null;
		
		return null;
	}
	
	public PageReference deleteCart() {
		Boolean activeCartDeleted = false;
		//System.debug('deleteCartID'+deleteCartID);
		e_cart__c tmp = [select id, cartType__c from e_cart__c where id = :deleteCartID];
		//System.debug('ryl delete cart ->' + tmp);
		List<E_Cart__c> deleteThisCartList = new List<E_Cart__C> {cc_dao_Cart.retrieveCartHeader(deleteCartID)};
		/*
		[select id,EncryptedID__c, ActiveCart__c from E_Cart__c where id = :deleteCartID limit 1];
		*/
		/*
		if(deleteThisCartList != null && deleteThisCartList.size() > 0) {
			E_Cart__c cartToDelete = deleteThisCartList[0];
			if(cartToDelete.ActiveCart__c) {
				activeCartDeleted = true;
			}
			delete deleteThisCartList;
		}
		if(activeCartDeleted) {
			List<E_Cart__c> makeActiveCartList = cc_dao_Cart.getActiveCartOwnedBy(UserInfo.getUserId());
			/*
			[Select ActiveCart__c, EncryptedID__c from E_Cart__c where OwnerId = :UserInfo.getUserId() And isDeleted = false And CartStatus__c = :cc_cnst_PickListConstants.CARTSTATUS_OPEN limit 1];
			*/
			/*
			if(makeActiveCartList != null && makeActiveCartList.size() > 0) {
				E_Cart__c makeActive = makeActiveCartList[0];
				makeActive.ActiveCart__c = true;
				currentCartID = makeActive.EncryptedID__c;
				Cookie cartIdCookie = new Cookie('currentCartId',currentCartID,null,-1,false);
				ApexPages.currentPage().setCookies(new Cookie[]{cartIdCookie});
			}else {
				// Since there are no carts to make active, reset the currentCartID to empty
				myAccountController.removeCurrentCart();
				currentCartID = '';
			}
			update makeActiveCartList;
		}
		paginator=null;
		MockCartList =getMockCartList();
		return null;
	}
	*/
}