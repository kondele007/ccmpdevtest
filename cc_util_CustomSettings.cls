//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_util_CustomSettings {
	public static String encodeCountryCode(String countryCode){
        if (al.StringUtils.isNotBlank(countryCode)) {
            countryCode = Encodingutil.base64Encode(Blob.valueOf(countryCode));
        } else {
            countryCode = '';
        }
        return countryCode;
    }
    
    /**
    	This section contains new methods that use CustomSettings instead of E_Code__c
    	to get various values.  The following CustomSettings have been created to replace
    	sections of E_Code__c:
    	
    	CountryCode
    	StateCode
    
    */

	public static List<CountryCode__c> getCountryCodes(){
		/*
		 * Not happy with the below code...there should be a way to order the result in a more efficient way
		 */ 
		
			List<CountryCode__c> countryUnsorted= CountryCode__c.getAll().values();
			List<CountryCode__c> sortedCountryCodes=new List<CountryCode__c>();
			List<String> countries = new List<String>();
			Map<String,String> countryMap=new Map<String,String>();
			for(CountryCode__c country:countryUnsorted){
				countries.add(country.Country__c);
				countryMap.put(country.Country__c,country.Name);
			}
			
			countries.sort();
			
			for(String country:countries){
				CountryCode__c tempCountry=new CountryCode__c();
				tempCountry.Country__c=country;
				tempCountry.Name=countryMap.get(country);
				sortedCountryCodes.add(tempCountry);
			}
			
			return sortedCountryCodes;
		
		//List<String> countries=countryUnsorted.
	}
	
	public static List<StateCode__c> getStateCodes(){
		
		/*
		 * Not happy with the below code...there should be a way to order the result in a more efficient way
		 */ 
		
			List<StateCode__c> stateUnsorted= StateCode__c.getAll().values();
			List<StateCode__c> sortedStateCodes=new List<StateCode__c>();
			List<String> states = new List<String>();
			Map<String,String> stateMap=new Map<String,String>();
			for(StateCode__c state:stateUnsorted){
				states.add(state.State__c);
				stateMap.put(state.State__c,state.Name);
			}
			
			states.sort();
			
			for(String state:states){
				StateCode__c tempCountry=new StateCode__c();
				tempCountry.State__c=state;
				tempCountry.Name=stateMap.get(state);
				/* address book mod begin by roy */
				// code__c is needed for removing country code prefix from state code in cc_util_Picklist.getStateOptionsList() 
				String[] stateCodeParts = stateMap.get(state).split('_');
				if(stateCodeParts.size() == 2) {
					tempCountry.Code__c=stateCodeParts[1];
					tempCountry.CountryCode__c = stateCodeParts[0];
				} else if(stateCodeParts.size() == 1) {
					tempCountry.Code__c=stateCodeParts[0];
				} 
				
				/* address book mod end by roy */
				sortedStateCodes.add(tempCountry);
			}
			
			return sortedStateCodes;
		
		//List<String> countries=countryUnsorted.
	}
	
    public static String getLanguageCodeByLocale(E_StorefrontSettings__c storefront, String locale){
      if(storefront != null){		
        List<E_Language__c> languages = E_Language__c.getAll().values();
        for(E_Language__c language : languages){
          if(language!= null && 
	        al.StringUtils.equalsIgnoreCase(language.storefront__c, storefront.name) &&
            !al.StringUtils.isEmpty(locale) &&
            al.StringUtils.equalsIgnoreCase(language.Locale__c,locale)){
      	    return language.LanguageCode__c;	
          }
        }
      }
      return null;
    }
	
	public static List<E_Language__c> getLanguages(E_StorefrontSettings__c storefront){
		List<E_Language__c> languagesSorted = new List<E_Language__c>();
		
		if(storefront != null){
			List<E_Language__c> languagesUnsorted = E_Language__c.getAll().values();
		    List<String> languages = new List<String>();
		    Map<String,String> languageMap = new Map<String,String>();
		
		    List<E_Language__c> defaultLanguage = new List<E_Language__c>();
		    for(E_Language__c language : languagesUnsorted){
		    	if(language!=null && al.StringUtils.equalsIgnoreCase(language.storefront__c,storefront.name)){
		    		if(!language.default__c){
		    		  languages.add(language.Language__c);
					  languageMap.put(language.Language__c,language.Locale__c);
		    		}else{
		    		  defaultLanguage.add(language);
		    		}
				
		    	}
		    }
		    
		    languages.sort();
		    
		    for(E_Language__c language : defaultLanguage){
		    	languagesSorted.add(language);
		    }
		    
		    for(String language : languages){
		    	E_Language__c tempLanguage = new E_Language__c();
		    	tempLanguage.Language__c = language;
		    	tempLanguage.Locale__c = languageMap.get(language);
		    	tempLanguage.Storefront__c = storefront.name;
		    	languagesSorted.add(tempLanguage);
		    }
		}
		
		return languagesSorted;
	}
	
	public static List<StateCode__c> getStateCodes(String countryCode){
		System.debug('Retreiving codes for countrycode: ' + countryCode);
			List<StateCode__c> stateUnsorted= StateCode__c.getAll().values();
			List<StateCode__c> sortedStateCodes=new List<StateCode__c>();
			List<String> states = new List<String>();
			Map<String,String> stateMap=new Map<String,String>();
			
			for(StateCode__c state:stateUnsorted){
				if(state.CountryCode__c == countryCode){
					states.add(state.State__c);
					stateMap.put(state.State__c,state.Name);
				}
			}
			
			states.sort();
			
			for(String state:states){
				StateCode__c tempCountry=new StateCode__c();
				tempCountry.State__c=state;
				tempCountry.Name=stateMap.get(state);
				tempCountry.CountryCode__c = countryCode;
				/* address book mod begin by roy */
				// code__c is needed for removing country code prefix from state code in cc_util_Picklist.getStateOptionsList() 
				String[] stateCodeParts = stateMap.get(state).split('_');
				if(stateCodeParts.size() == 2) {
					tempCountry.Code__c=stateCodeParts[1];
				} else if(stateCodeParts.size() == 1) {
					tempCountry.Code__c=stateCodeParts[0];
				}
				/* address book mod end by roy */
				sortedStateCodes.add(tempCountry);
			}
			
			return sortedStateCodes;
	}
    
    public static StateCode__c getStateCodeByCode(String countryCode, String stateCode){
    	return getStateCodeByISOCode(countryCode + '_' + stateCode);
    }
    
     public static StateCode__c getStateCodeByISOCode(String stateisoCode){
     	List<StateCode__c> states = StateCode__c.getAll().values();
     	if(states != null){
     	  for(StateCode__c state : states){
     	  	System.debug('ryl getStateCodeByISOCode--> state code name = ' + state.Name + '-- statecode=' + stateisoCode);
     	    if(al.StringUtils.equals(state.Name,stateisoCode)){
     	      return state;
     	    }	
     	  }	
     	}
     	return null;
    }
    
      public static CurrencyCode__c getCurrencyCodeByISOCode(String currencyisoCode){
    	CurrencyCode__c code = CurrencyCode__c.getValues(currencyisoCode);    	
    	return code;
    }
    
    public static StateCode__c getStateCodeByName(String countryCode, String name){
    	StateCode__c code = null;

    	//CountryCode__c country = getCountryCodeByCode(countryCode);
    	List<StateCode__c> stateCodes = StateCode__c.getAll().values();
    	for(StateCode__c state: stateCodes){
    		if(state.CountryCode__c == countryCode && state.State__c == name){
    			code = state;
    			break;
    		}
    	}  
    	
    	return code;
    }
    public static CountryCode__c getCountryCodeByCode(String isoCode){
    	CountryCode__c code = CountryCode__c.getValues(isoCode);
    	return code;
    }
    public static CountryCode__c getCountryCodeByName(String name){
    	CountryCode__c code = null;

    	// Get he CountryCode custom objects
    	List<CountryCode__c> countryCodes = CountryCode__c.getAll().values();

    	for(CountryCode__c c: countryCodes){
    		if(c.Country__c == name){
    			code = c;
    			break;
    		}
    	} 
    	
    	return code;
    }
}