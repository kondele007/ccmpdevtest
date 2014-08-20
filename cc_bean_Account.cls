public with sharing class cc_bean_Account {
/*
    //==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public Id sfid {get;set;}
    public String name {get;set;}
    public String phone {get;set;}
    public String accountGroupName {get;set;}
	public cc_bean_MockContactAddress billingAddress {get;set;}
	public cc_bean_MockContactAddress shippingAddress {get;set;}
    public Account dataObject {get;set;}
    
    //==================================================
    // CONSTRUCTORS
    //==================================================
    public cc_bean_Account() {}
    
    public cc_bean_Account(Account account) {
        if(account != null) {
            dataObject = account;
            try{sfid = account.Id;}catch(SObjectException e){}
            try{name = account.Name;}catch(SObjectException e){}
            try{phone = account.Phone;}catch(SObjectException e){}
            try{accountGroupName = account.E_AccountGroup__r.Name;}catch(SObjectException e){}

            billingAddress = new cc_bean_MockContactAddress();
            try{billingAddress.address1 = account.BillingStreet;}catch(SObjectException e){}
            try{billingAddress.city = account.BillingCity;}catch(SObjectException e){}
            try{billingAddress.stateCode = account.BillingState;}catch(SObjectException e){}
            try{billingAddress.postalCode = account.BillingPostalCode;}catch(SObjectException e){}
            try{billingAddress.country = account.BillingCountry;}catch(SObjectException e){}
            if(billingAddress.country != null) {
            	CountryCode__c countryCode = cc_util_CustomSettings.getCountryCodeByName(billingAddress.country);
            	billingAddress.countryCode = countryCode != null ? countryCode.Name : null;
            }

            shippingAddress = new cc_bean_MockContactAddress();
            try{shippingAddress.address1 = account.ShippingStreet;}catch(SObjectException e){}
            try{shippingAddress.city = account.ShippingCity;}catch(SObjectException e){}
            try{shippingAddress.stateCode = account.ShippingState;}catch(SObjectException e){}
            try{shippingAddress.postalCode = account.ShippingPostalCode;}catch(SObjectException e){}
            try{shippingAddress.country = account.ShippingCountry;}catch(SObjectException e){}
            if(shippingAddress.country != null) {
            	CountryCode__c countryCode = cc_util_CustomSettings.getCountryCodeByName(shippingAddress.country);
            	shippingAddress.countryCode = countryCode != null ? countryCode.Name : null;
            }
        }
    }
    */
}