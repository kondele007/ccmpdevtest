public with sharing class cc_ctrl_MyAccountAddressBook {

    //==================================================
    // INSTANCE VARIABLES
    //==================================================
    String[] selectedAddressTypes = new String[]{};
    String[] selectedDefaultAddressTypes = new String[]{};
    public String[] errorMessages {get { if(errorMessages == null) errorMessages = new String[1]; return errorMessages;} private set;}

    //==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public String abid {get;set;}
    public cc_bean_AddressBook addressBookBean {get;set;}

    public List<SelectOption> addressTypeOptions {
        get {
            if(addressTypeOptions == null) {
                addressTypeOptions = cc_util_Picklist.getAddressTypes();
            }
            return addressTypeOptions;
        }
        set;
    }

    public List<SelectOption> defaultAddressTypeOptions {
        get {
            if (defaultAddressTypeOptions == null || addressTypeOptions == null) {
                addressTypeOptions = cc_util_Picklist.getAddressTypes();
            	defaultAddressTypeOptions = new List<SelectOption>();
            	for (SelectOption opt: addressTypeOptions) {
            		SelectOption newOpt = new SelectOption(opt.getValue(), 'Default');
            		defaultAddressTypeOptions.add(newOpt);
            	}
            }
            return defaultAddressTypeOptions;
        }
        set;
    }

	public List<SelectOption> getStateOptions() {
	   return cc_util_Picklist.getStateOptionsList('US');
	}

	public List<SelectOption> getStateOptionsCanada() {
	   return cc_util_Picklist.getStateOptionsList('CA');
	}

	public List<SelectOption> getCountries() {
		return cc_util_Picklist.getCountryOptionsList();
	}
    //==================================================
    // CONSTRUCTOR
    //==================================================
    public cc_ctrl_MyAccountAddressBook() {
        addressBookBean = new cc_bean_AddressBook();
        System.debug('--- cc_ctrl_MyAccountAddressBook: addressBookBean=' + addressBookBean);
    }

    //==================================================
    // INSTANCE METHODS
    //==================================================
    public cc_ctrl_MyAccountAddressBook getAddressBookController() { return this; }
    
    public List<cc_bean_AddressBook> getAddressBooksForCurrentUser() {
        List<cc_bean_AddressBook> books = cc_api_AddressBook.getAddressBooksForCurrentUser();

        if(books == null) {
            books = new List<cc_bean_AddressBook>();
        }

		// TODO: for testing, remove
		if(books.size() == 0) {
			books = cc_api_AddressBook.getAddressBooksForUser('005E0000000Jbgz');
		}

        return books;
    }
    
    public PageReference saveAddress() {
        //addressBookBean.addressBean.firstName = getFirstName();
        //addressBookBean.addressBean.lastName = getLastName();
        addressBookBean.addressTypes = new List<cc_bean_AddressBook.AddressTypeInfo>();
        System.debug('--- cc_ctrl_MyAccountAddressBook.saveAddress: selectedAddressTypes=' + selectedAddressTypes);
        Set<String> defaults = new Set<String>();
		defaults.addAll(selectedDefaultAddressTypes);
        for(String selectedAddressType : selectedAddressTypes) {
            addressBookBean.addressTypes.add(new cc_bean_AddressBook.AddressTypeInfo(selectedAddressType, defaults.contains(selectedAddressType)));
        }
        System.debug('--- cc_ctrl_MyAccountAddressBook.saveAddress: addressBookBean=' + addressBookBean);
        errorMessages = cc_api_AddressBook.validateAddress(addressBookBean);
        System.debug('--- cc_ctrl_MyAccountAddressBook.saveAddress: validation errors =' + errorMessages);
        if (errorMessages.size() == 0) {
	        String saveResult = cc_api_AddressBook.saveAddressBook(addressBookBean);
	        System.debug('--- cc_ctrl_MyAccountAddressBook.saveAddress: saveResult=' + saveResult);
	        if ('success'.equalsIgnoreCase(saveResult)) {
	        	errorMessages = new String[]{};
	            resetAddressBookBean();
	        }
        }
        return null;
    }
    
    public PageReference editAddress() {
        System.debug('--- cc_ctrl_MyAccountAddressBook.editAddress: abid=' + abid);
        if(abid != null) {
            cc_bean_AddressBook editAddressBook = null;
            List<cc_bean_AddressBook> editAddressBooks = cc_api_AddressBook.getAddressBooksForCurrentUser(abid);
            if(editAddressBooks.size() == 1) {
                addressBookBean = editAddressBooks[0];
                
                for(cc_bean_AddressBook.AddressTypeInfo typeInfo : addressBookBean.addressTypes) {
                    selectedAddressTypes.add(typeInfo.addressType);
                    if (typeInfo.isDefault)
                    	selectedDefaultAddressTypes.add(typeInfo.addressType);
                }
                
            } else {
                // TODO: returned more than one cc_bean_AddressBook
            }
        }
        return null;
    }
    
    public PageReference deleteAddress() {
        System.debug('--- cc_ctrl_MyAccountAddressBook.deleteAddress: abid=' + abid);
        if(abid != null) {
            //delete address book entries and address
            Id accountID = cc_util_CloudCraze.getAccountID();
            String deleteResult = cc_api_AddressBook.deleteAddressBooks(accountID, abid);
            // TODO: are there cases where we would not want to delete the address, but just the address book entries?
            if('success'.equalsIgnoreCase(deleteResult)) {
                resetAddressBookBean();
            }
        }
        return null;
    }
    
    public String[] getSelectedAddressTypes() {
        return selectedAddressTypes;
    }
    
    public void setSelectedAddressTypes(String[] addressTypes) {
        this.selectedAddressTypes = addressTypes;
    }
    
    public String[] getSelectedDefaultAddressTypes() {
        return selectedDefaultAddressTypes;
    }
    
    public void setSelectedDefaultAddressTypes(String[] defaultAddressTypes) {
        this.selectedDefaultAddressTypes = defaultAddressTypes;
    }
    
    public PageReference resetAddressBookBean() {
        abid = null;
        addressBookBean = new cc_bean_AddressBook();
        selectedAddressTypes = new String[]{};
        selectedDefaultAddressTypes = new String[]{};
        errorMessages = new String[]{};
        return null;
    }
    
    
}