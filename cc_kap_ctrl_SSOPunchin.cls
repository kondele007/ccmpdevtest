/**
// * Created by CloudCraze, LLC.
// * Copyright 2010-12 CloudCraze, LLC. All rights reserved
// * @Description: Handles SSO integration.
// * @Version: 1.0
// * @File: cc_kap_ctrl_SSOPunchin
// * =======================================================================================
**/

public without sharing class cc_kap_ctrl_SSOPunchin {

	/**
	* Public constructor - transfers the cart to the SSO user and sets up cart addresses for use by the payment page
	*/

	public cc_kap_ctrl_SSOPunchin(){
		transferCart();
		loadAddressesIntoCart();
	}
	
	/**
	* Public PageReference to redirect to the payment page
	* Also does the upserts because they cannot be done during class instantiation
	*/
	public PageReference saveAndContinue(){
		//JLL - dupe order fix
		//refresh the order to see if its actually already been placed
		E_Cart__c freshCart = [select CartStatus__c from E_Cart__c where Id =: cart.Id];

    	String sbu = ' ';
    	String productNames = ' ';

		if(freshCart.CartStatus__c == cc_cnst_PickListConstants.CARTSTATUS_OPEN){
			if (cartBean.billToAddress != null) {
				cartBillingAddress = cartBean.billToAddress.dataObject;
				System.debug(LoggingLevel.INFO, '--- cc_extn_UserInfo.validateUserInfo: upserting cartBillingAddress=' + cartBillingAddress);
				upsert cartBillingAddress;
				if(cart.BillTo__c == null) {
					cart.BillTo__c = cartBillingAddress.Id;
					cartBean.billToAddress.sfid = cartBillingAddress.Id;
				}
			}
	
			if (cartBean.shipToAddress != null) {
				cartShippingAddress = cartBean.shipToAddress.dataObject;
				System.debug(LoggingLevel.INFO, '--- cc_extn_UserInfo.validateUserInfo: upserting cartShippingAddress=' + cartShippingAddress);
				upsert cartShippingAddress;
				if(cart.ShipTo__c == null) {
					cart.ShipTo__c = cartShippingAddress.Id;
					cartBean.shipToAddress.sfid = cartShippingAddress.Id;
				}
			}
			
			cart.BuyerFirstName__c = cartBean.buyerFirstName;
			cart.BuyerLastName__c = cartBean.buyerLastName;
			cart.BuyerPhone__c = cartBean.buyerPhone;
			cart.BuyerEmail__c = cartBean.buyerEmail;
	
			System.debug(LoggingLevel.INFO, '--- cc_extn_UserInfo.saveAddress: upserting cart=' + cart);
			String shipCalcCountry = cc_kap_utils_AppConstants.COUNTRY_USA_ABBREV;
			if (cartBean.shipToAddress != null)
				shipCalcCountry = cartBean.shipToAddress.country;
			//JLL bug fix - before calculating new shipping totals, we need to re-run pricing engine
			//EG if user goes from Anonymous to AMA logged in, they might have a new price
			System.debug(LoggingLevel.INFO, '$$$$$$$$ Start of cart reprice timing');
			update cart;
			List<E_CartItem__c> cartItemList = cc_dao_cart.getDisplayCartItems(currentCartID);
			cartAPI.updateCart(cartItemList, cart.CurrencyISOCode__c, cart.CustomerTypeCode__c);
			cart = updatePayInInstallPrice(cart);//KP Fix Phase 2: Since Cart is Re-priced, need to calculate and set the DueToday, 2nd and 3rd installment price again as they might have changed.
			//JLL End re-run pricing engine fix
			Map<String, Decimal> totals = cc_kap_utils_Cart.updateCartTotalsAndShipping(cart.Id, shipCalcCountry, true);
			cart.ShipAmount__c = totals.get(cc_kap_utils_AppConstants.TOTALS_SHIPPING);
			update cart;
			System.debug(LoggingLevel.INFO, '$$$$$$$$ End of cart reprice timing');
			
			Double total = totals.get(cc_kap_utils_AppConstants.TOTALS_GRAND);
			if (total != null && total == 0 && cartitemlist.size()!=0){
				System.debug('^^^^^^^^^^^^ in zero dollar cart scenario ^^^^^^^^^^^^^');
				return cc_hlpr_Cart.placeOrderAndRedirect(cart.Id);
			}
			else {
				System.debug('^^^^^^^^^^^^ in NONzero dollar cart scenario ^^^^^^^^^^^^^');
				String ABPath = cc_kap_utils_AppUtils.retrieveCookie('ABPath');
				PageReference checkOutPage;
				if(ABPath == null || ABPath.length() == 0 || 'A'.equals(ABPath))
					checkOutPage = System.Page.CheckoutNew;
				else
					checkoutPage = System.Page.CheckoutNew_va;
				checkOutPage.getParameters().put('ViewState', 'OrderPaymentReview');
				checkOutPage.getParameters().put('cartID', currentCartID);

				cc_kap_api_rules_CartRules cartRulesAPI = new cc_kap_api_rules_CartRules(cartItemList);

				productNames = cartItemList.get(0).Product__r.Name;

				for(integer i = 1; i < cartItemList.size(); i++){
		    		productNames = productNames + ', ' + cartItemList.get(i).Product__r.Name;
		    	}

		    	sbu = getSpecs(cartRulesAPI.getSpecValues(cc_kap_utils_AppConstants.SPEC_SBU), false);

		    	Cookie productNamesCookie = new Cookie('ccprodnames', productNames,null,-1,false);
		    	Set<String> specValues = cartRulesAPI.getSpecValues(cc_kap_utils_AppConstants.SPEC_KBS_PROGRAM_CODE);		
				Cookie kbsProgramCodesCookie = new Cookie('cckpgid',getSpecs(specValues, true),null,-1,false);
				Cookie sbuCookie = new Cookie('ccbuid',sbu,null,-1,false);

				checkOutPage.getParameters().put('cckpgid', getSpecs(specValues, false));
				checkOutPage.getParameters().put('ccpgid', getSpecs(cartRulesAPI.getSpecValues(cc_kap_utils_AppConstants.SPEC_PROGRAM_CODE), false));				
				checkOutPage.getParameters().put('ccbuid', sbu);

				ApexPages.currentPage().setCookies(new Cookie[]{kbsProgramCodesCookie, sbuCookie, productNamesCookie});

				return checkOutPage;
			}
			
		}
		else{
			System.debug('-----Caught duplicate Order Place------');
			throw new cc_excn_CartException('This order has already been placed.');
		}
	}
	
	/*
	*Phase II - IB Fee changes - if Cart was repriced, then it would not have the new dueToday price and Cybersource would show wrong value. Fixed this issue
	*/
	private E_Cart__c updatePayInInstallPrice(E_Cart__c cart)
	{
		cc_ctrl_MiniCart ctrlMiniCart = new cc_ctrl_MiniCart();
		System.debug(LoggingLevel.INFO,'@@dueToday='+ cart.due_today__c);
		if(cart.due_today__c != null){
			System.debug(LoggingLevel.INFO,'@@MiniCart dueToday='+ ctrlMiniCart.dueTodayPrice);
			if(cart.due_today__c != ctrlMiniCart.dueTodayPrice){
				cart.due_today__c = ctrlMiniCart.dueTodayPrice;
				cart.second_payment__c = ctrlMiniCart.totalInstallmentPrice;
    			cart.third_payment__c = ctrlMiniCart.totalInstallmentPrice;
				//update cart; 
			}
		}
		return cart;
	}
	
	/**
	* Private helper methods
	* Mostly copied and refactored from cc_ctrl_sitelogin and cc_extn_UserInfo
	*/	
	
	private void transferCart(){
		loggedInUser = null;
		currentCartID = Apexpages.currentPage().getParameters().get('cartID');
		if(!cc_cnst_CloudCraze.USER_TYPE_GUEST.equals(UserInfo.getUserType())){
			String userName = UserInfo.getUserName();
			System.debug('----------userName from sso = ' + userName );
			loggedInUser = [Select id from User where UserName = :userName limit 1];
		}
		//TODO jll handle error if cannot find user or cart id
		if(currentCartID != null && currentCartID != '' && loggedInUser != null)
		{
			cartAPI = new cc_api_cart();
			cart = cartAPI.retrieveCart(currentCartID);
			if(cart != null)
			{
				cartBean = new cc_bean_Cart(cart);
				System.debug('----reassigning cart account------');
				cart.ActiveCart__c = true;
				cart.OwnerId = loggedInUser.Id;
				cart.User__c = loggedInUser.Id;
				cart.AnonymousID__c = false;
				cart.Account__c = cc_util_CloudCraze.getAccountID(loggedInUser);
			}	
		}
	}
	
	private void loadAddressesIntoCart() {
		// get addresses for current user
		List<cc_bean_AddressBook> availAddressBooks = cc_api_AddressBook.getAddressBooksForCurrentUser();
		cc_bean_AddressBookWrapper addressBookWrapper = new cc_bean_AddressBookWrapper(availAddressBooks);
		boolean preventNewAddrCheckout = false;
		if(cartBean.buyerFirstName == null) {
			// populate cartBean from contact and address book

			// populate contact info
			Contact userContact = cc_api_User.getCurrentUserContact();
			if(userContact != null) {
				cartBean.populateBuyerInfo(userContact);
				preventNewAddrCheckout = userContact.Account.PreventNewAddrCheckout__c;
			} else {
				System.debug(LoggingLevel.WARN, '--- cc_extn_UserInfo.initUserInfo: Contact record for current user not found');
			}

			// populate billing address
			if(cartBean.billToAddress == null && addressBookWrapper.defaultBillingAddress != null) {
				cartBean.billToAddress = addressBookWrapper.defaultBillingAddress.addressBean;
			}

			// populate shipping address
			if(cartBean.shipToAddress == null && addressBookWrapper.defaultShippingAddress != null) {
				cartBean.shipToAddress = addressBookWrapper.defaultShippingAddress.addressBean;
			}
		}
	}

	private static String getSpecs(Set<String> specValuesSet, boolean getAll){ 
    	String specs = ' ';	    	
    	List<String> specValuesList = new List<String>(); 

    	if (specValuesSet != null) {
    		specValuesList.addAll(specValuesSet);  
    		specs = specValuesList.get(0);	  	

    		if(getAll){
    			specs = specValuesList.get(specValuesList.size()-1);
    			for(integer i = specValuesList.size() - 2; i >= 0; i--){
	    			specs = specs + ', ' + specValuesList.get(i);
	    		}
			}		        		
    	}  
    	return specs;
    }

	private User loggedInUser{get; set;}
	private E_Cart__c cart{get; set;}
	private cc_bean_Cart cartBean {get;set;}
	private String currentCartID{get; set;}
	private cc_api_cart cartAPI {get; set;}
	private E_ContactAddr__c cartBillingAddress {get;set;}
	private E_ContactAddr__c cartShippingAddress {get;set;}
	
}