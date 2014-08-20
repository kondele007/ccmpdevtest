public with sharing class cc_bean_MockContact {

    //==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public Id sfid {get;set;}
	public String firstName {get;set;}
	public String lastName {get;set;}
	public String phone {get;set;}
	public String mobilePhone {get;set;}
	public String homePhone {get;set;}
	public String companyName {get;set;}
	public String email {get;set;}
	public cc_bean_MockContactAddress mailingAddress {get;set;}
	public cc_bean_MockContactAddress otherAddress {get;set;}
	public Id accountId {get;set;}
	public Contact dataObject {
		get {
			if(dataObject == null) {
				dataObject = new Contact();
			}
			dataObject.FirstName = firstName;
			dataObject.LastName = lastName;
			dataObject.Phone = phone;
			dataObject.MobilePhone = mobilePhone;
			dataObject.HomePhone = homePhone;
			dataObject.CompanyName__c = companyName;
			dataObject.email = email;
			dataObject.AccountId = accountId;
			
			if(mailingAddress != null) {
				dataObject.MailingStreet = mailingAddress.address1;
				dataObject.MailingCity = mailingAddress.city;
				dataObject.MailingState = mailingAddress.stateCode;
				dataObject.MailingPostalCode = mailingAddress.postalCode;
				if(mailingAddress.countryCode != null) {
					CountryCode__c countryCode = cc_util_CustomSettings.getCountryCodeByCode(mailingAddress.countryCode);
					dataObject.MailingCountry = countryCode != null ? countryCode.Country__c : mailingAddress.country;
				} else {
					dataObject.MailingCountry = mailingAddress.country;
				}
			}

			if(otherAddress != null) {
				dataObject.OtherStreet = otherAddress.address1;
				dataObject.OtherCity = otherAddress.city;
				dataObject.OtherState = otherAddress.stateCode;
				dataObject.OtherPostalCode = otherAddress.postalCode;
				if(otherAddress.countryCode != null) {
					CountryCode__c countryCode = cc_util_CustomSettings.getCountryCodeByCode(otherAddress.countryCode);
					dataObject.OtherCountry = countryCode != null ? countryCode.Country__c : otherAddress.country;
				} else {
					dataObject.OtherCountry = otherAddress.country;
				}
			}
			return dataObject;
		}
		set;
	}
	
    //==================================================
    // CONSTRUCTORS
    //==================================================
	public cc_bean_MockContact() {
        mailingAddress = new cc_bean_MockContactAddress();
        otherAddress = new cc_bean_MockContactAddress();
	}
	
	public cc_bean_MockContact(Contact con) {
        if(con != null) {
            dataObject = con;
            try{sfid = con.Id;}catch(SObjectException e){/*System.debug(e);*/}
            try{firstName = con.FirstName;}catch(SObjectException e){/*System.debug(e);*/}
            try{lastName = con.LastName;}catch(SObjectException e){/*System.debug(e);*/}
            try{phone = con.Phone;}catch(SObjectException e){/*System.debug(e);*/}
            try{mobilePhone = con.MobilePhone;}catch(SObjectException e){/*System.debug(e);*/}
            try{homePhone = con.HomePhone;}catch(SObjectException e){/*System.debug(e);*/}
            try{companyName = con.CompanyName__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{email = con.Email;}catch(SObjectException e){/*System.debug(e);*/}
            try{accountId = con.AccountId;}catch(SObjectException e){/*System.debug(e);*/}
            
            mailingAddress = new cc_bean_MockContactAddress();
            try{mailingAddress.address1 = con.MailingStreet;}catch(SObjectException e){/*System.debug(e);*/}
            try{mailingAddress.city = con.MailingCity;}catch(SObjectException e){/*System.debug(e);*/}
            try{mailingAddress.stateCode = con.MailingState;}catch(SObjectException e){/*System.debug(e);*/}
            try{mailingAddress.postalCode = con.MailingPostalCode;}catch(SObjectException e){/*System.debug(e);*/}
            try{mailingAddress.country = con.MailingCountry;}catch(SObjectException e){/*System.debug(e);*/}
            if(mailingAddress.country != null) {
            	CountryCode__c countryCode = cc_util_CustomSettings.getCountryCodeByName(mailingAddress.country);
            	mailingAddress.countryCode = countryCode != null ? countryCode.Name : null;
            }

            otherAddress = new cc_bean_MockContactAddress();
            try{otherAddress.address1 = con.OtherStreet;}catch(SObjectException e){/*System.debug(e);*/}
            try{otherAddress.city = con.OtherCity;}catch(SObjectException e){/*System.debug(e);*/}
            try{otherAddress.stateCode = con.OtherState;}catch(SObjectException e){/*System.debug(e);*/}
            try{otherAddress.postalCode = con.OtherPostalCode;}catch(SObjectException e){/*System.debug(e);*/}
            try{otherAddress.country = con.OtherCountry;}catch(SObjectException e){/*System.debug(e);*/}
            if(otherAddress.country != null) {
            	CountryCode__c countryCode = cc_util_CustomSettings.getCountryCodeByName(otherAddress.country);
            	otherAddress.countryCode = countryCode != null ? countryCode.Name : null;
            }
        }
	}

    //==================================================
    // TESTS
    //==================================================
	static testMethod void myUnitTest() {
		cc_bean_MockContact bean = new cc_bean_MockContact();
		System.assert(bean != null);
		bean.firstName = 'first';
		bean.lastName = 'last';
		bean.phone = '555-555-5555';
		bean.mobilePhone = '555-555-5555';
		bean.homePhone = '555-555-5555';
		bean.companyName = 'company';
		bean.email = 'email@email.com';
	}
}