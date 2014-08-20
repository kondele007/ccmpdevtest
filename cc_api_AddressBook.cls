public with sharing class cc_api_AddressBook {

    //==================================================
    // STATIC METHODS  
    //==================================================
    public static List<cc_bean_AddressBook> getAddressBooksForCurrentUser() {
        return getAddressBooksForCurrentUser(null);
    }

    public static List<cc_bean_AddressBook> getAddressBooksForCurrentUser(Id addressID) {
        Id accountID = cc_util_CloudCraze.getAccountID();
        return getAddressBooksForAccount(accountID, addressID);
    }
    
    public static List<cc_bean_AddressBook> getAddressBooksForUser(Id userID) {
        return getAddressBooksForUser(userID, null);
    }

    public static List<cc_bean_AddressBook> getAddressBooksForUser(Id userID, Id addressID) {
        Id accountID = cc_util_CloudCraze.getAccountID(new User(Id=userID));
        return getAddressBooksForAccount(accountID, addressID);
    }

    public static List<cc_bean_AddressBook> getAddressBooksForAccount(Id accountID, Id addressID) {
        List<cc_bean_AddressBook> books = null;

        List<E_AddressBook__c> ebooks = null;
        if(addressID != null) {
            ebooks = cc_dao_AddressBook.getAddressBooksForAccount(accountID, addressID);
        } else {
            ebooks = cc_dao_AddressBook.getAddressBooksForAccount(accountID);
        }
        System.debug('--- cc_api_AddressBook.getAddressBooksForCurrentUser: ebooks=' + ebooks);

        if(ebooks != null) {
            books = new List<cc_bean_AddressBook>();
            Map<Id,cc_bean_AddressBook> addressXaddressBook = new Map<Id,cc_bean_AddressBook>();

            for(E_AddressBook__c ebook : ebooks) {
                cc_bean_AddressBook ab = addressXaddressBook.get(ebook.E_ContactAddress__c);
                if(ab == null) {
                    ab = new cc_bean_AddressBook(ebook);
                    addressXaddressBook.put(ab.addressBean.sfid, ab);
                } else {
                    // add AddressTypeInfo to cc_bean_AddressBook
                    ab.addressTypes.add(new cc_bean_AddressBook.AddressTypeInfo(ebook.AddressType__c, ebook.Default__c));
                }
            }
            System.debug('--- cc_api_AddressBook.getAddressBooksForCurrentUser: addressXaddressBook=' + addressXaddressBook);
            books.addAll(addressXaddressBook.values());
        }
        
        System.debug('--- cc_api_AddressBook.getAddressBooksForCurrentUser: returning books=' + books);
        return books;
    }

    public static String saveAddressBook(cc_bean_AddressBook addressBookBean) {
        System.debug('--- cc_api_AddressBook.saveAddressBook: addressBookBean=' + addressBookBean);
        String result = 'failed';
        
        // TODO: validate address
        
        Id addressID = cc_dao_AddressBook.upsertAddress(addressBookBean.addressBean);
        Id accountID = cc_util_CloudCraze.getAccountID();
        
        if(addressID != null && accountID != null) {
            // replace address book entries for current user
            String deleteResult = cc_dao_AddressBook.deleteAddressBooks(accountID, addressID);
            if('success'.equalsIgnoreCase(deleteResult)) {
                result = cc_dao_AddressBook.insertAddressBooks(accountID, addressID, addressBookBean.addressTypes);
            }
        }
        
        return result;
    }
    
    
    public static String deleteAddressBooks(Id accountID, Id addressID) {
        // TODO: delete E_ContactAddr__c too?
        return cc_dao_AddressBook.deleteAddressBooks(accountID, addressID);
    }
    
    /**
     * Handles validation of the address book entry, ensuring that the address fields are set appropriately.
     */
    public static List<String> validateAddress(cc_bean_AddressBook addressBookBean) {
    	List<String> errorMessages = new List<String>();

		if(addressBookBean.addressTypes.size() == 0) {
			errorMessages.add(Label.Address_RequiredField_BillingAddress1); // TODO: what label should this be?
		}
		
		errorMessages.addAll(cc_api_AddressBook.validateAddress(addressBookBean.addressBean, null));
    	
    	return errorMessages;
    }
    
    public static List<String> validateAddress(cc_bean_MockContactAddress mockAddr, String addrType) {
    	List<String> errorMessages = new List<String>();
    	// assumes billing if addrType is null
    	Boolean isBilling = addrType == null || cc_cnst_CloudCraze.AddressType_Billing.equalsIgnoreCase(addrType);
    	// assumes shipping if not billing

    	if(al.StringUtils.isEmpty(mockAddr.address1)) {
			if(isBilling) {
	            errorMessages.add(Label.Address_RequiredField_BillingAddress1);
			} else {
	            errorMessages.add(Label.Address_RequiredField_ShippingAddress1);
			}
    	}

        if(al.StringUtils.isEmpty(mockAddr.city)) {
			if(isBilling) {
	            errorMessages.add(Label.Address_RequiredField_BillingCity);
			} else {
	            errorMessages.add(Label.Address_RequiredField_ShippingCity);
			}
        }

        if(al.StringUtils.isEmpty(mockAddr.postalCode)) {
			if(isBilling) {
	            errorMessages.add(Label.Address_RequiredField_BillingPostalCode);
			} else {
	            errorMessages.add(Label.Address_RequiredField_ShippingPostalCode);
			}
        }
        
        if(al.StringUtils.isEmpty(mockAddr.countryCode)) {
			if(isBilling) {
	            errorMessages.add(Label.Address_RequiredField_BillingCountry);
			} else {
	            errorMessages.add(Label.Address_RequiredField_ShippingCountry);
			}
        }

        if(mockAddr.stateCode == null && (mockAddr.countryCode == 'US' || mockAddr.countryCode == 'CA')) {
			if(isBilling) {
	            errorMessages.add(Label.Address_RequiredField_BillingState);
			} else {
	            errorMessages.add(Label.Address_RequiredField_ShippingState);
			}
        }

		return errorMessages;
    }
    
    /**
     * Creates address book entries for the newly created account and addresses.  These are created
     * as the default addresses for the corresponding type.  The shipping address was marked as the 
     * same as billing, then only only contact address is used, with two address book entires pointing to it.
     */
    public static void createAddressBookEntries(Id accountId, E_ContactAddr__c shippingAddress, E_ContactAddr__c billingAddress, Id ownerId) {
    	List<E_AddressBook__c> entries = new List<E_AddressBook__c>();
    	entries.add(createAddressBookEntry(accountId, billingAddress, true, 'Billing', ownerId));
    	entries.add(createAddressBookEntry(accountId, shippingAddress, true, 'Shipping', ownerId));
    	insert entries;
    }
    
    /**
     * Creates address book entries for the newly created account and addresses.  These are created
     * as the default addresses for the corresponding type.  The shipping address was marked as the 
     * same as billing, then only only contact address is used, with two address book entires pointing to it.
     */
    public static void createAddressBookEntries(Id accountId, Id shippingAddress, Id billingAddress, Id ownerId) {
    	List<E_AddressBook__c> entries = new List<E_AddressBook__c>();
    	entries.add(createAddressBookEntry(accountId, billingAddress, true, 'Billing', ownerId));
    	entries.add(createAddressBookEntry(accountId, shippingAddress, true, 'Shipping', ownerId));
    	insert entries;
    }
    
    /**
     * Create an invidual address book entry with the passed in account id, address, and settings.
     */
    public static E_AddressBook__c createAddressBookEntry(Id accountId, E_ContactAddr__c address, boolean defaultFlag, String addressType, Id ownerId) {
    	E_AddressBook__c addressBookEntry = new E_AddressBook__c();
    	addressBookEntry.Account__c = accountId;
    	addressBookEntry.E_ContactAddress__c = address.Id;
    	addressBookEntry.AddressType__c = addressType;
    	addressBookEntry.Default__c = defaultFlag;
    	addressBookEntry.Owner__c = ownerId;
    	return addressBookEntry;
    }
    
    /**
     * Create an invidual address book entry with the passed in account id, address, and settings.
     */
    public static E_AddressBook__c createAddressBookEntry(Id accountId, Id addressId, boolean defaultFlag, String addressType, Id ownerId) {
    	E_AddressBook__c addressBookEntry = new E_AddressBook__c();
    	addressBookEntry.Account__c = accountId;
    	addressBookEntry.E_ContactAddress__c = addressId;
    	addressBookEntry.AddressType__c = addressType;
    	addressBookEntry.Default__c = defaultFlag;
    	addressBookEntry.Owner__c = ownerId;
    	return addressBookEntry;
    }
    
    
}