public with sharing class cc_bean_AddressBookWrapper {
	public list<cc_bean_AddressBook> billingAddresses { get; set;}
	public list<cc_bean_AddressBook> shippingAddresses { get; set;}
	public cc_bean_AddressBook defaultBillingAddress { get; set; }
	public cc_bean_AddressBook defaultShippingAddress { get; set; }
	public cc_bean_AddressBookWrapper(List<cc_bean_AddressBook> abs) {
		billingAddresses = new list<cc_bean_AddressBook>();
		shippingAddresses = new list<cc_bean_AddressBook>();
		for(cc_bean_AddressBook bean : abs) {
			for(cc_bean_AddressBook.AddressTypeInfo aType : bean.addressTypes) {
				if(aType.addressType.equalsIgnoreCase(cc_cnst_CloudCraze.AddressType_Shipping)) {
					if(aType.isDefault) {
						defaultShippingAddress = bean;
					}
					shippingAddresses.add(bean);
				}
				if(aType.addressType.equalsIgnoreCase(cc_cnst_CloudCraze.AddressType_Billing)) {
					if(aType.isDefault) {
						defaultBillingAddress = bean;
					}
					billingAddresses.add(bean);
				}
			}
		}
	}
}