//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without
//  modification is PROHIBITED.
//
//
public with sharing virtual class cc_ctrl_MyAccount extends cc_ctrl_CloudCraze {
 
	//==================================================
	// INSTANCE PROPERTIES
	//==================================================
	public String currentCartID {get;set;}
	public String ACCOUNT_INFO_VIEW {get { return 'viewAccountInfo'; } private set; }
	public String CHANGE_PASSWORD_VIEW {get { return 'viewChangePassword'; } private set; }
	public String ACCOUNT_INFO_EDIT_VIEW {get { return 'editAccountInfo'; } private set; }
	public String ADDRESS_BOOK_VIEW {get { return 'viewAddressBook';} private set; }
	public String ORDERS_VIEW {get { return 'viewOrders';} private set; }
	public String CARTS_VIEW {get { return 'viewCarts';} private set; }
	public String WISHLIST_VIEW { get {return 'wishlists'; } private set; }
	public String ALL {get {return 'All';} private set;}

	public User currentUser {
		get {
			if(currentUser == null) {
				currentUser = cc_api_User.getCurrentUser;
			}
			return currentUser;
		}
		set;
	}

	public List<String> errorMessages {get { if(errorMessages == null) errorMessages = new List<String>(); return errorMessages;} private set;}
	public List<String> successMessages {get { if(successMessages == null) successMessages = new List<String>(); return successMessages;} private set;}


	/**
	 * Retrieves the flag to see if the user can manage this account's address book.
	 */
	public boolean canManageAddressBook {
		get {
			System.debug('checking addr book flag');
			if(currentUser != null) {
				canManageAddressBook = !currentUser.Contact.Account.PreventAddrBookSave__c;
				System.debug('checking addr book flag'+ currentUser.Contact.Account.PreventAddrBookSave__c);
			} else {
				canManageAddressBook = true;
			}
			return canManageAddressBook;
		}
		set;
	}

/*

	public String currentPassword {get; set {currentPassword = value == null ? value : value.trim(); } }
	public String password {get; set {password = value == null ? value : value.trim(); } }
	public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }

	public Integer cartItemCount {get {
		if(cartItemCount == null) {
			cartItemCount = 0;
		}
		return cartItemCount;
	}
		set;
	}
	public String cartTotal {get;set;}
*/

	public E_Order__c dateProxy {
		get {
			if(dateProxy == null) {
				dateProxy = new E_Order__c();
			}
			return dateProxy;
		}
		set;
	}

/*
	public List<SelectOption> getLanguageOptions() {
		return cc_util_Picklist.getLanguageOptionsList(this.storefront);
	}
	
	public cc_bean_MockContactAddress mockBillTo {get;set;}
	public cc_bean_MockContactAddress mockShipTo {get;set;}
*/
	//==================================================
	// CONSTRUCTORS
	//==================================================
	public cc_ctrl_MyAccount() {
		super();

		// default viewState to account info view
		if(viewState == null) {
			viewState = ACCOUNT_INFO_VIEW;
		}

		currentCartID = getCartId();
	}

	//==================================================
	// HELPER METHODS
	//==================================================
	public cc_ctrl_MyAccount getMyAccountController() { return this; }


	public void clearPageMessages() {
		this.errorMessages.clear();
		this.successMessages.clear();
	}

/*
	public List<SelectOption> getCurrencyOptions() {
		return cc_util_Picklist.getCurrencyOptions(Schema.sObjectType.User.fields.getMap(), storefront);
	}

	public String getDatetimeQueryFormat(Date thedate) {
		String formattedDate = null;
		if(thedate != null) {
			Datetime thedatetime = Datetime.newInstance(thedate.year(),thedate.month(),thedate.day());
			formattedDate = getDatetimeQueryFormat(thedatetime);
		}
		return formattedDate;
	}

	public String getDatetimeQueryFormat(Datetime thedatetime) {
		String formattedDate = null;

		if(thedatetime != null) {
			formattedDate = thedatetime.format('yyyy-MM-dd')+'T'+thedatetime.format('hh:mm:ss') + 'Z';
		}
		return formattedDate;
	}
*/

	public String getDateQueryFormat(Date thedate) {
		String formattedDate = null;

		if(thedate != null) {
			Datetime thedatetime = Datetime.newInstance(thedate.year(),thedate.month(),thedate.day());
			formattedDate = thedatetime.format('yyyy-MM-dd');
		}
		return formattedDate;
	}

/*
	public String formatAmount(Decimal amount) {
		String formattedAmount = '';
		if(amount != null) {
			formattedAmount = amount.toPlainString();
			if(formattedAmount.length() > 0) {
				formattedAmount = '$' + formattedAmount;
			}
		// TODO -- make sure we get 2 decimal places
//          Integer i = formattedAmount.indexOf('.');
//          if(i ) {

//          }
		}
		return formattedAmount;
	}

	public void getAccountInfo() {
		// TODO: setup address beans and populate
		cc_bean_MockContactAddress mockShipTo = new cc_bean_MockContactAddress();
		mockShipTo.address1 = currentUser.Contact.MailingStreet;
		mockShipTo.city = currentUser.Contact.MailingCity;
		mockShipTo.stateCode = currentUser.Contact.MailingState;
		mockShipTo.state = currentUser.Contact.MailingState;
		mockShipTo.postalCode = currentUser.Contact.MailingPostalCode;
		mockShipTo.country = currentUser.Contact.MailingCountry;
		cc_bean_MockContactAddress mockBillTo = new cc_bean_MockContactAddress();
		mockBillTo.address1 = currentUser.Contact.OtherStreet;
		mockBillTo.city = currentUser.Contact.OtherCity;
		mockBillTo.stateCode = currentUser.Contact.OtherState;
		mockBillTo.state = currentUser.Contact.OtherState;
		mockBillTo.postalCode = currentUser.Contact.OtherPostalCode;
		mockBillTo.country = currentUser.Contact.OtherCountry;
		for (SelectOption opt:this.getCountries()) {
			if (currentUser.Contact.MailingCountry != null && currentUser.Contact.MailingCountry.equals(opt.getLabel()))
				shipCountry = opt.getValue();
			if (currentUser.Contact.OtherCountry != null && currentUser.Contact.OtherCountry.equals(opt.getLabel()))
				billCountry = opt.getValue();
		}
		if (shipCountry == 'US')
			shipState = mockShipTo.stateCode;
		else if (shipCountry == 'CA')
			shipStateCA = mockShipTo.stateCode;
		else
			shipStateText = mockShipTo.stateCode;
		if (billCountry == 'US')
			billState = mockBillTo.stateCode;
		else if (billCountry == 'CA')
			billStateCA = mockBillTo.stateCode;
		else
			billStateText = mockBillTo.stateCode;
	}

	public void setAccountInfo() {
		system.debug(mockShipTo);
		for (SelectOption opt:this.getCountries()) {
			if (shipCountry != null && shipCountry.equals(opt.getValue()))
				currentUser.Contact.MailingCountry = opt.getLabel();
			if (billCountry != null && billCountry.equals(opt.getValue()))
				currentUser.Contact.OtherCountry = opt.getLabel();
		}
		currentUser.Contact.MailingStreet = mockShipTo.address1;
		currentUser.Contact.MailingCity = mockShipTo.city;
		currentUser.Contact.MailingPostalCode = mockShipTo.postalCode;
		if (shipCountry == 'US')
			currentUser.Contact.MailingState = shipState;
		else if (shipCountry == 'CA')
			currentUser.Contact.MailingState = shipStateCA;
		else
			currentUser.Contact.MailingState = shipStateText;
		currentUser.Contact.OtherStreet = mockBillTo.address1;
		currentUser.Contact.OtherCity = mockBillTo.city;
		currentUser.Contact.OtherPostalCode = mockBillTo.postalCode;
		if (billCountry == 'US')
			currentUser.Contact.OtherState = billState;
		else if (billCountry == 'CA')
			currentUser.Contact.OtherState = billStateCA;
		else
			currentUser.Contact.OtherState = billStateText;
		currentUser.User_Salutation__c = userSalutation;
		currentUser.User_Industry__c = userIndustry;
		currentUser.ContactTypeRole__c = contactTypeRoleValue;
		currentUser.LanguageLocaleKey = cc_util_CustomSettings.getLanguageCodeByLocale(storefront,currentUser.LocaleSidKey);
	}

	private boolean isValidPassword() {
		return password == confirmPassword;
	}
*/
	//==================================================
	// SERVICE METHODS
	//==================================================
	/* moved to cc_ctrl_myaccount_Profile
	public PageReference updateAccount() {
		//System.debug('--- cc_ctrl_MyAccount.updateAccount: currentUser=' + currentUser);
		this.clearPageMessages();
		//System.debug('-----cc_ctrl_MyAccount.updateAccount-Request values- currentCartID|storeID|ipAddressLocation : ' + currentCartID + '|' + storeID + '|' + ipAddressLocation);

		if(!validateAddresses()) {
			//System.debug('--- cc_ctrl_MyAccount.updateAccount: address validation errors=' + errorMessages);
			return null;
		}

		if(password != null && password != '') {
			if (!isValidPassword()) {
				//ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.site.passwords_dont_match);
				//ApexPages.addMessage(msg);
				this.errorMessages.add(Label.site.passwords_dont_match);
				return null;
			} else{
				//System.debug('Passwords Match');
				cc_ctrl_ChangePassword change = new cc_ctrl_ChangePassword(this);
				change.newPassword = password;
				change.verifyNewPassword = confirmPassword;
				change.oldPassword = currentPassword;
				//System.debug('************SITE INFO 1 ************ : Name ' + Site.getName()+', Domain : ' + Site.getDomain()+', Prefix : ' + Site.getPrefix());
				PageReference page = change.changePasswordForMyAccount();
				if(page == null) {
					return null;
				}


				//System.debug('Pagereference'+page);
				//PageReference page = Site.changePassword(password, confirmPassword, '1testuser');
				//if(page != null)
				 //   //System.debug(page);
				//System.debug('After Password Change');
			}
		}


		//System.debug('Set Account Info!' );
		setAccountInfo();
		update currentUser.Contact;
		update currentUser;

		//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Account Updated Succesfully'));
		this.successMessages.add(Label.Account_UpdatedSuccessfully);
		//System.debug('---------- Setting VIEW_STATE ----------------');
		viewState = SUMMARY_VIEW;
		generateMyAccountList();

		PageReference page = System.Page.MyAccount;
		page.getParameters().put('cartID', getCartId());
		return page;
	}
	*/

	public PageReference showCartList() {
		return changeViewState(CARTS_VIEW, true);
	}

	public PageReference showOrderList() {
		return changeViewState(ORDERS_VIEW, true);
	}

	public PageReference showAccountInfoView() {
		return changeViewState(ACCOUNT_INFO_VIEW, true);
	}

	public PageReference showAccountInfoEditView() {
		return changeViewState(ACCOUNT_INFO_EDIT_VIEW, true);
	}

	public PageReference showChangePasswordView() {
		return changeViewState(CHANGE_PASSWORD_VIEW, true);
	}

	public PageReference showAddressBookView() {
		return changeViewState(ADDRESS_BOOK_VIEW, true);
	}

	public PageReference showMyWishList() {
		return changeViewState(WISHLIST_VIEW, true);
	}
	
	public PageReference changeViewState(String state, Boolean clearMessages) {
		if(clearMessages) {
			clearPageMessages();
		}
		viewState = state;
		return null;
	}
}