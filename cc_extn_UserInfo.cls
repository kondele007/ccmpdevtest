public without sharing class cc_extn_UserInfo extends cc_ExtensionBase {

	//==================================================
	// INSTANCE VARIABLES
	//==================================================
	public static final String name = 'UserInfo';

	//==================================================
	// INSTANCE PROPERTIES
	//==================================================
	public cc_ctrl_CheckOut checkOutController {get;set;}
	public cc_bean_Cart cartBean {get;set;}

	public cc_bean_AddressBookWrapper addressBookWrapper {get;set;}
	public boolean preventNewAddrCheckout {get;set;}
	
	public E_ContactAddr__c cartBillingAddress {get;set;}
	public E_ContactAddr__c cartShippingAddress {get;set;}

	public String billState {get;set;}
	public String billStateCA {get;set;}
	public String billStateText {get;set;}
	public String shipState {get;set;}
	public String shipStateCA {get;set;}
	public String shipStateText {get;set;}

	// used for address book selection
	public string selectedAddressId {get;set;}
	public string selectedAddressType {get;set;}

	public List<SelectOption> countryList {
		get {
			if(countryList == null) {
				countryList = cc_util_Picklist.getCountryOptionsList();
			}
			return countryList;
		}
		set;
	}

	public List<SelectOption> stateListUS {
		get {
			if(stateListUS == null) {
				stateListUS = cc_util_Picklist.getStateOptionsList('US');
			}
			return stateListUS;
		}
		set;
	}

	public List<SelectOption> stateListCA {
		get {
			if(stateListCA == null) {
				stateListCA = cc_util_Picklist.getStateOptionsList('CA');
			}
			return stateListCA;
		}
		set;
	}

	public List<SelectOption> salutationList {
		get {
			if(salutationList == null) {
				salutationList = new List<SelectOption> {
					new Selectoption('Mr', 'Mr'),
					new Selectoption('Mrs', 'Mrs'),
					new Selectoption('Ms', 'Ms'),
					new Selectoption('Dr', 'Dr')
				};
			}
			return salutationList;
		}
		set;
	}

	//==================================================
	// CONSTRUCTORS
	//==================================================
	public cc_extn_UserInfo(cc_ctrl_CloudCraze c) {
		super(c);

		// add references to parent
		checkOutController = (cc_ctrl_CheckOut) parentController;
		cartBean = checkOutController.cartBean;

		initUserInfo();
	}

	//==================================================
	// OVERRIDE METHODS
	//==================================================
	public override string getName() {
		return name;
	}

	public override PageReference gotoStep() {
		return checkOutController.gotoStep(cc_extn_UserInfo.name);
	}

	//==================================================
	// HELPER METHODS
	//==================================================
	public cc_extn_UserInfo getUserInfo() { return this; }

	//==================================================
	// SERVICE METHODS
	//==================================================
	private void validateUserInfo() {
		System.debug(LoggingLevel.INFO, '--- cc_extn_UserInfo.validateUserInfo: cartBean=' + cartBean);
		System.debug(LoggingLevel.INFO, '--- cc_extn_UserInfo.validateUserInfo: billToAddress=' + cartBean.billToAddress);
		System.debug(LoggingLevel.INFO, '--- cc_extn_UserInfo.validateUserInfo: shipToAddress=' + cartBean.shipToAddress);
		
		
		if(al.StringUtils.isEmpty(cartBean.buyerFirstName)){
			parentController.messages.add(Label.AccountInformation_RequiredField_FirstName);
		}

		if(al.StringUtils.isEmpty(cartBean.buyerLastName)){
			parentController.messages.add(Label.AccountInformation_RequiredField_LastName);
		}

		if(al.StringUtils.isEmpty(cartBean.buyerPhone)){
			parentController.messages.add(Label.AccountInformation_RequiredField_Phone);
		}
		
		parentController.messages.addAll(cc_api_AddressBook.validateAddress(cartBean.billToAddress, cc_cnst_CloudCraze.AddressType_Billing));
		parentController.messages.addAll(cc_api_AddressBook.validateAddress(cartBean.shipToAddress, cc_cnst_CloudCraze.AddressType_Shipping));
	}

	public void initUserInfo() {
		// get addresses for current user
		List<cc_bean_AddressBook> availAddressBooks = cc_api_AddressBook.getAddressBooksForCurrentUser();
		addressBookWrapper = new cc_bean_AddressBookWrapper(availAddressBooks);

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

		initUserAddresses();
	}

	public void initUserAddresses() {
		if(cartBean.billToAddress != null) {
			String country = cartBean.billToAddress.countryCode;
			String state = cartBean.billToAddress.stateCode;
			System.debug(LoggingLevel.INFO, '--- cc_extn_UserInfo.initUserAddresses: billTo country=' + country + ', state=' + state);

			if(country == 'US') {
				billState = state;
			} else if(country == 'CA') {
				billStateCA = state;
			} else {
				billStateText = state;
			}
			System.debug(LoggingLevel.INFO, '--- cc_extn_UserInfo.initUserAddresses: billState=' + billState);
		} else {
			cartBean.billToAddress = new cc_bean_MockContactAddress();
		}

		if(cartBean.shipToAddress != null) {
			String country = cartBean.shipToAddress.countryCode;
			String state = cartBean.shipToAddress.stateCode;
			System.debug(LoggingLevel.INFO, '--- cc_extn_UserInfo.initUserAddresses: shipTo country=' + country + ', state=' + state);

			if(country == 'US') {
				shipState = state;
			} else if(country == 'CA') {
				shipStateCA = state;
			} else {
				shipStateText = state;
			}
			System.debug(LoggingLevel.INFO, '--- cc_extn_UserInfo.initUserAddresses: shipState=' + shipState);
		} else {
			cartBean.shipToAddress = new cc_bean_MockContactAddress();
		}
	}

	public PageReference saveAddress() {
		parentController.messages.clear();

		if (cartBean.billToAddress.firstName == null)
			cartBean.billToAddress.firstName = cartBean.buyerFirstName;
		if (cartBean.billToAddress.lastName == null)
			cartBean.billToAddress.lastName = cartBean.buyerLastName;
		if(cartBean.billToAddress.countryCode == 'US') {
			cartBean.billToAddress.stateCode = this.billState;
		} else if(cartBean.billToAddress.countryCode == 'CA') {
			cartBean.billToAddress.stateCode = this.billStateCA;
		} else {
			cartBean.billToAddress.stateCode = this.billStateText;
		}

		if (cartBean.shipToAddress.firstName == null)
			cartBean.shipToAddress.firstName = cartBean.buyerFirstName;
		if (cartBean.shipToAddress.lastName == null)
			cartBean.shipToAddress.lastName = cartBean.buyerLastName;
		if(cartBean.shipToAddress.countryCode == 'US') {
			cartBean.shipToAddress.stateCode = this.shipState;
		} else if(cartBean.shipToAddress.countryCode == 'CA') {
			cartBean.shipToAddress.stateCode = this.shipStateCA;
		} else {
			cartBean.shipToAddress.stateCode = this.shipStateText;
		}

		validateUserInfo();

		System.debug(LoggingLevel.INFO, '--- cc_extn_UserInfo.validateUserInfo: validation message size:' + parentController.messages.size());
		if(parentController.messages.size() > 0) {
			return null;
		}
		
		E_Cart__c cart = checkOutController.cart; // TODO: change to cartBean.dataObject

		// save billing address
		System.debug(LoggingLevel.INFO, '--- cc_extn_UserInfo.validateUserInfo: cart.BillTo__c=' + cart.BillTo__c);
		if(cart.BillTo__c == null) {
			cartBean.billToAddress.dataObject = null;
		}
		cartBillingAddress = cartBean.billToAddress.dataObject;
		System.debug(LoggingLevel.INFO, '--- cc_extn_UserInfo.validateUserInfo: upserting cartBillingAddress=' + cartBillingAddress);
		upsert cartBillingAddress;
		
		// save shipping address
		System.debug(LoggingLevel.INFO, '--- cc_extn_UserInfo.validateUserInfo: cart.ShipTo__c=' + cart.ShipTo__c);
		if(cart.ShipTo__c == null) {
			cartBean.shipToAddress.dataObject = null;
		}
		cartShippingAddress = cartBean.shipToAddress.dataObject;
		System.debug(LoggingLevel.INFO, '--- cc_extn_UserInfo.validateUserInfo: upserting cartShippingAddress=' + cartShippingAddress);
		upsert cartShippingAddress;
		
		// save cart header
		if(cart.BillTo__c == null) {
			cart.BillTo__c = cartBillingAddress.Id;
			cartBean.billToAddress.sfid = cartBillingAddress.Id;
		}

		if(cart.ShipTo__c == null) {
			cart.ShipTo__c = cartShippingAddress.Id;
			cartBean.shipToAddress.sfid = cartShippingAddress.Id;
		}
		
		cart.BuyerFirstName__c = cartBean.buyerFirstName;
		cart.BuyerLastName__c = cartBean.buyerLastName;
		cart.BuyerPhone__c = cartBean.buyerPhone;

		System.debug(LoggingLevel.INFO, '--- cc_extn_UserInfo.saveAddress: upserting cart=' + cart);
		/** Kaplan Phase 1 Begin */
		Map<String, Decimal> totals = cc_kap_utils_Cart.updateCartTotalsAndShipping(cart.Id, cartBean.shipToAddress.country, true);
		cart.ShipAmount__c = totals.get(cc_kap_utils_AppConstants.TOTALS_SHIPPING);
		cartBean.shipAmount = cart.ShipAmount__c;
		/** Kaplan Phase 1 Begin */
		upsert cart;

		/* TODO: is this necessary?
		//reload cart
		checkOutController.loadCurrentCart();

		this.mockBillingAddress = new cc_bean_MockContactAddress(checkedOutBillingAddress);
		System.debug('saveAddress -> mockBillingAddress' + mockBillingAddress);
		this.mockShippingAddress = new cc_bean_MockContactAddress(checkedOutshippingAddress);
		System.debug('saveAddress -> mockShippingAddress' + mockShippingAddress);
		*/

		return checkOutController.nextStep(cc_extn_UserInfo.name);
	}

	// TODO: refactor to update cartBean instead of cart
	public PageReference selectThisAddress() {
		System.debug(LoggingLevel.INFO, '--- cc_extn_UserInfo.selectThisAddress: selectedAddressId='+ selectedAddressId);
		System.debug(LoggingLevel.INFO, '--- cc_extn_UserInfo.selectThisAddress: selectedAddressType='+ selectedAddressType);

		if(selectedAddressType.equalsIgnoreCase(cc_cnst_CloudCraze.AddressType_Billing)) {
			for(cc_bean_AddressBook ab : addressBookWrapper.billingAddresses) {
				System.debug(LoggingLevel.INFO, '--- cc_extn_UserInfo.selectThisAddress: billing ab.addressBean.sfid=' + ab.addressBean.sfid);
				if(ab.addressBean.sfid == selectedAddressId) {
					System.debug(LoggingLevel.INFO, '--- cc_extn_UserInfo.selectThisAddress: setting billto=' + ab.addressBean);
					cartBean.billToAddress = ab.addressBean;
				}
			}
		} else if (selectedAddressType.equalsIgnoreCase(cc_cnst_CloudCraze.AddressType_Shipping)) {
			for(cc_bean_AddressBook ab : addressBookWrapper.shippingAddresses) {
				System.debug(LoggingLevel.INFO, '--- cc_extn_UserInfo.selectThisAddress: shipping ab.addressBean.sfid=' + ab.addressBean.sfid);
				if(ab.addressBean.sfid == selectedAddressId) {
					System.debug(LoggingLevel.INFO, '--- cc_extn_UserInfo.selectThisAddress: setting shipto=' + ab.addressBean);
					cartBean.shipToAddress = ab.addressBean;
				}
			}
		}
		initUserAddresses();

		return null;
	}
}