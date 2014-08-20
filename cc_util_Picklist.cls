//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_util_Picklist {
	public static List<SelectOption> getLanguageOptionsList(E_StorefrontSettings__c storefront){
		List<SelectOption> languageList = new List<SelectOption>();
	    //languageList.add(new SelectOption('','Please Select One'));
	    for(E_Language__c language : cc_util_CustomSettings.getLanguages(storefront)){
	      languageList.add(new SelectOption(language.Locale__c,language.Language__c));	
	    }
	    return languageList; 
	}
	
	public static List<SelectOption> getCountryOptionsList(){
    
	    List<SelectOption> countryList= new List<SelectOption>();
	    countryList.add(new SelectOption('','Please Select One'));
	    List<CountryCode__c> countryCodeList=new List<CountryCode__c>();
	    countryCodeList=cc_util_CustomSettings.getCountryCodes();
	    
	    for(CountryCode__c country:countryCodeList){
	     countryList.add(new SelectOption(country.Name,country.Country__c));
	    }
	    
	    return  countryList; 
    }
    
    public static List<SelectOption> getStateOptionsList(String countryCode){
    	List<SelectOption> stateList= new List<SelectOption>();
	    stateList.add(new SelectOption('','Please Select One'));
	    List<StateCode__c> stateCodeList = cc_util_CustomSettings.getStateCodes(countryCode);
	   
	    for(StateCode__c state:stateCodeList) {
	    	/* address book mod begin by roy */
	    	/* replace state.name with state..code__c to remove country code prefix */
	    	stateList.add(new SelectOption(state.Code__c,state.State__c));
	     	/* address book mod end by roy */
	    }
	   
	    return stateList;
    }
    
    public static List<SelectOption> getAllStateOptionsList(){
    
	    List<SelectOption> stateList= new List<SelectOption>();
	    stateList.add(new SelectOption('','Please Select One'));
	    List<StateCode__c> stateCodeList=new List<StateCode__c>();
	    stateCodeList=cc_util_CustomSettings.getStateCodes();
	    for(StateCode__c state:stateCodeList){
	    	/* address book mod begin by roy */
	    	/* replace state.name with state..code__c to remove country code prefix */
	     stateList.add(new SelectOption(state.Code__c,state.State__c));
	     /* address book mod end by roy */
	    }
	    
	    return  stateList; 
    }
    
    public static List<SelectOption> getStateOptionsWithCountryCode()
	{
        List<SelectOption> billingStateList= new List<SelectOption>();
        billingStateList.add(new SelectOption('','Please Select One'));

    	List<StateCode__c> stateCodes = cc_util_CustomSettings.getStateCodes(); 
    	for(StateCode__c state: stateCodes){
    		billingStateList.add(new SelectOption(state.CountryCode__c + '--' + state.Code__c, state.CountryCode__c + '--' + state.State__c));
    	}
    	return  billingStateList;
		
	}
	
	
    public static List<SelectOption> getPicklistValues(Schema.DescribeFieldResult result)
	{
		List<SelectOption> options = new List<SelectOption>();
		List <Schema.PicklistEntry> ples = result.getPicklistValues(); 
		for(Schema.PicklistEntry e : ples)
		{
			options.add(new SelectOption(e.getValue(), e.getLabel()));
		}
		return options;
	} 
	
	
	/**
	 * Gets the list of organization currencies defined in a multi-currency organization.
	 */
	 /* Note: This method can't be tested without Multi-language feature gets turned on - roy lou */
	private static List<SelectOption> getOrgCurrencies(Map<String, Schema.SObjectField> fieldMap) {
    	List<SelectOption> ans = new List<SelectOption>();
		if (fieldMap.containsKey('DefaultCurrencyIsoCode')) {
			Schema.DescribeFieldResult currencies = fieldMap.get('DefaultCurrencyIsoCode').getDescribe();
			for (Schema.PickListEntry current : currencies.getPicklistValues())
				ans.add(new SelectOption(current.getValue(),current.getLabel()));
		}
		return ans;
    }
    
    /**
     * If this is a multi-currency org, then retrieves the org's list of of currencies, otherwise
     * retrieves the list of currencies from the currency code list.
     */
    public static List<SelectOption> getCurrencyOptions(Map<String, Schema.SObjectField> fieldMap, E_StorefrontSettings__c storefront) {
		List<SelectOption> ans = new List<SelectOption>();
		if (fieldMap.containsKey('DefaultCurrencyIsoCode'))
            ans = getOrgCurrencies(fieldMap);
        if (ans.size() == 0) {
			if (storefront != null) {
				List<CurrencyCode__c> currencyCodeList = CurrencyCode__c.getAll().values();
				for (CurrencyCode__c curr : currencyCodeList) {
					if (curr != null && al.StringUtils.equalsIgnoreCase(curr.storefront__c, storefront.name))
						ans.add(new SelectOption(curr.Currency_Name__c,curr.Currency_Name__c));
				}
			}
		}
        return ans;
    }
    
    /**
     * Retrieves the list of saluations for the user saluatation picklist.
     */
    public static List<SelectOption> getUserSalutations() {
    	return getPicklistValues(User.User_Salutation__c.getDescribe());
    }
 
 	/**
     * Retrieves the list of industries for the user saluatation picklist.
     */
    public static List<SelectOption> getUserIndustries() {
    	return getPicklistValues(User.User_Industry__c.getDescribe());
    }
    
    /**
     * Retrieves the list of industries for the user saluatation picklist.
     */
    public static List<SelectOption> getCompanyTypes() {
    	return getPicklistValues(User.CompanyType__c.getDescribe());
    }
    
    /**
     * Retrieves the list of industries for the user saluatation picklist.
     */
    public static List<SelectOption> getUserContactTypes() {
    	return getPicklistValues(User.ContactTypeRole__c.getDescribe());
    }
 
    public static List<SelectOption> getAddressTypes() {
    	return getPicklistValues(E_AddressBook__c.AddressType__c.getDescribe());
    }

}