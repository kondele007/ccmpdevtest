public with sharing class cc_ctrl_myaccount_Profile {/*
	
	//==================================================
	// INSTANCE PROPERTIES
	//==================================================
	public E_StorefrontSettings__c storefront {get;set;}
	public cc_ctrl_MyAccount myAccountController {get;set;}
	public cc_bean_MockContact userContact {get;set;}
	public cc_bean_Account userAccount {get;set;}
	public User userProfile {get;set;}

	public String mailingState {get;set;}
	public String mailingStateCA {get;set;}
	public String mailingStateText {get;set;}

	public String otherState {get;set;}
	public String otherStateCA {get;set;}
	public String otherStateText {get;set;}

	//==================================================
	// CONSTRUCTORS
	//==================================================
	public cc_ctrl_myaccount_Profile() {
    	String store = ApexPages.currentPage().getParameters().get('store');
    	storefront = cc_util_CloudCraze.getStorefrontSettings(store);
		
		initUserInfo();
	}
	
	public void initUserInfo() {
		userProfile = cc_api_User.getCurrentUserProfile();
		System.debug(LoggingLevel.INFO, '--- cc_ctrl_myaccount_Profile.initUserInfo: userProfile=' + userProfile);

		/* UNCOMMENT FOR TESTING AS ADMIN
		if(userProfile != null && userProfile.Username == 'matt.burton@76demo.com') {
			userProfile = cc_api_User.getUserProfile('005E0000000Jbgz'); // matt portal
		}
		System.debug(LoggingLevel.INFO, '--- cc_ctrl_myaccount_Profile.initUserInfo: userProfile=' + userProfile);
		*/
		/*
		if(userProfile != null) {
			userContact = new cc_bean_MockContact(userProfile.Contact);
			System.debug(LoggingLevel.INFO, '--- cc_ctrl_myaccount_Profile.initUserInfo: userContact=' + userContact);
			
			System.debug(LoggingLevel.INFO, '--- cc_ctrl_myaccount_Profile.initUserInfo: storefront=' + storefront);
			if('B2B'.equalsIgnoreCase(storefront.eCommerceType__c) && userContact.accountId != null) {
				// TODO: move to api/dao classes for Account
				List<Account> accounts = [select Name, E_AccountGroup__r.Name, Phone, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry from Account where Id = :userContact.accountId];
				if(accounts.size() == 1) {
					userAccount = new cc_bean_Account(accounts[0]);
					System.debug(LoggingLevel.INFO, '--- cc_ctrl_myaccount_Profile.initUserInfo: userAccount=' + userAccount);
				}
			}
			
			initAddressInfo();
		}
	}
	
	public void initAddressInfo() {
		if(userContact != null && userContact.mailingAddress != null) {
			// set mailing state
			String countryCode = userContact.mailingAddress.countryCode;
			String stateCode = userContact.mailingAddress.stateCode;
			System.debug(LoggingLevel.INFO, '--- cc_ctrl_myaccount_Profile.initAddressInfo: mailing countryCode=' + countryCode + ', stateCode=' + stateCode);

			if(countryCode == 'US') {
				mailingState = stateCode;
			} else if(countryCode == 'CA') {
				mailingStateCA = stateCode;
			} else {
				mailingStateText = stateCode;
			}
			System.debug(LoggingLevel.INFO, '--- cc_ctrl_myaccount_Profile.initAddressInfo: mailingState=' + mailingState);
		}

		if(userContact != null && userContact.otherAddress != null) {
			// set other state
			String countryCode = userContact.otherAddress.countryCode;
			String stateCode = userContact.otherAddress.stateCode;
			System.debug(LoggingLevel.INFO, '--- cc_ctrl_myaccount_Profile.initAddressInfo: other countryCode=' + countryCode + ', stateCode=' + stateCode);

			if(countryCode == 'US') {
				otherState = stateCode;
			} else if(countryCode == 'CA') {
				otherStateCA = stateCode;
			} else {
				otherStateText = stateCode;
			}
			System.debug(LoggingLevel.INFO, '--- cc_ctrl_myaccount_Profile.initAddressInfo: otherState=' + otherState);
		}
	}
	
	private boolean validateUserInfo() {
		myAccountController.clearPageMessages();
		List<String> errors = myAccountController.errorMessages;
		
		if(userContact.firstName == null || userContact.firstName.length() == 0) {
			errors.add('Contact First Name is required');
		}

		if(userContact.lastName == null || userContact.lastName.length() == 0) {
			errors.add('Contact Last Name is required');
		}

		errors.addAll(cc_api_AddressBook.validateAddress(userContact.mailingAddress, null));
		errors.addAll(cc_api_AddressBook.validateAddress(userContact.otherAddress, null));
		
		if(userProfile.Username == null || userProfile.Username.length() == 0) {
			errors.add('Username is required');
		}

		if(userProfile.Email == null || userProfile.Email.length() == 0) {
			errors.add('Email is required');
		}

		return errors.size() == 0;
	}

	public PageReference saveUserInfo() {

		System.debug(LoggingLevel.INFO, '--- cc_ctrl_myaccount_Profile.saveUserInfo: saving user info...');
		System.debug(LoggingLevel.INFO, '--- cc_ctrl_myaccount_Profile.saveUserInfo: userContact=' + userContact);
		System.debug(LoggingLevel.INFO, '--- cc_ctrl_myaccount_Profile.saveUserInfo: userProfile=' + userProfile);
		
		if(userContact.mailingAddress.countryCode == 'US') {
			userContact.mailingAddress.stateCode = mailingState;
		} else if(userContact.mailingAddress.countryCode == 'CA') {
			userContact.mailingAddress.stateCode = mailingStateCA;
		} else {
			userContact.mailingAddress.stateCode = mailingStateText;
		}
		
		/*
		CountryCode__c countryCode = cc_util_CustomSettings.getCountryCodeByCode(mailingCountryCode);
		userContact.MailingCountry = countryCode != null ? countryCode.Country__c : null;
		*/
		/*
		if(userContact.otherAddress.countryCode == 'US') {
			userContact.otherAddress.stateCode = otherState;
		} else if(userContact.otherAddress.countryCode == 'CA') {
			userContact.otherAddress.stateCode = otherStateCA;
		} else {
			userContact.otherAddress.stateCode = otherStateText;
		}
		
		/*
		countryCode = cc_util_CustomSettings.getCountryCodeByCode(otherCountryCode);
		userContact.OtherCountry = countryCode != null ? countryCode.Country__c : null;
		*/
		/*
		if(validateUserInfo()) {
			try {
				update userContact.dataObject;
				update userProfile;
			} catch(DMLException e) {
				myAccountController.errorMessages.add('Unable to save changes: ' + e.getMessage());
			}
		}
		
		if(myAccountController.errorMessages.size() == 0) {
			myAccountController.successMessages.add('Successfully updated profile.');
			myAccountController.viewState = myAccountController.ACCOUNT_INFO_VIEW;
		}

		return null;
	}
	
	public List<SelectOption> getStateListUS() {
	   return cc_util_Picklist.getStateOptionsList('US');
	}

	public List<SelectOption> getStateListCA() {
	   return cc_util_Picklist.getStateOptionsList('CA');
	}

	public List<SelectOption> getCountryOptions() {
		return cc_util_Picklist.getCountryOptionsList();
	}

    public List<SelectOption> getLanguageOptions(){
        return cc_util_Picklist.getLanguageOptionsList(this.storefront);
    } 

    public List<SelectOption> getCurrencyOptions() {
    	return cc_util_Picklist.getCurrencyOptions(Schema.sObjectType.User.fields.getMap(), storefront);
    }

	public List<SelectOption> getSalutation() {
		System.debug('-----cc_ctrl_MyAccount');
		return cc_util_Picklist.getUserSalutations();
	}

	public List<SelectOption> getIndustry() {
		return cc_util_Picklist.getUserIndustries();
	}

	public List<SelectOption> getContactTypeRole() {
		return cc_util_Picklist.getUserContactTypes();
	}
	*/
}