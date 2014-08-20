//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_hlpr_InitLoadCustomSettings {
	
    public static void loadCloudCrazeApplicationSettings()
    {	
        cc_api_dl_cs_application app = new cc_api_dl_cs_application();
        app.loadData();
    }


    public static void loadCloudCrazeStorefrontSettings()
    {
    	cc_api_dl_cs_storeFront app = new cc_api_dl_cs_storeFront(); 
        app.loadData();
    }

    
    public static void loadCountryCodes() {
        cc_api_dl_country app = new cc_api_dl_country(); 
        app.loadData();
    }
	
	 public static Map<String,String> INIT_COUNTRY_CODES = new Map<String,String> {
        'ES' => 'Spain',
        'FR' => 'France',
        'HK' => 'Hong Kong',
        'GB' => 'United Kingdom',
        'US' => 'United States',
        'CA' => 'Canada',
        'IT' => 'Italy',
        'DE' => 'Germany',
        'IN' => 'India',
        'JP' => 'Japan',
        'MX' => 'Mexico',
        'ZA' => 'South Africa'
	};
    
    public static void loadCountryCodes(Set<String> codes) {
        List<CountryCode__c> countries = [Select c.Id From CountryCode__c c Where c.Name in :codes];
        delete countries;

        countries = new List<CountryCode__c>();
        for(String code : codes) {
        	if(cc_hlpr_InitLoadCustomSettings.INIT_COUNTRY_CODES.containsKey(code)) {
                countries.add(new CountryCode__c(
                		Name = code,
                		COUNTRY__C = cc_hlpr_InitLoadCustomSettings.INIT_COUNTRY_CODES.get(code),
                		Storefront__c = cc_util_CloudCraze.application.Default_Storefront__c
                	));
        	}
        }
        insert countries;
    }
	

    public static void loadStateCodes()
    {
    	cc_api_dl_cs_state cs = new cc_api_dl_cs_state();
    	cs.loadData();
        
    }

    public static void loadPageConfigurations()
    {
        cc_api_dl_cs_pageConfiguration cs = new cc_api_dl_cs_pageConfiguration();
    	cs.loadData();
    	cc_api_dl_cs_PageUIKey pui = new cc_api_dl_cs_PageUIKey();
    	pui.loadData();
    }
    
	
    public static void loadCurrencyCodes()
    {
        List<CurrencyCode__c> currencyCodes = [Select c.Name, c.Id, c.Currency_Name__c From CurrencyCode__c c LIMIT 2000];
        delete currencyCodes;

        currencyCodes = new List<CurrencyCode__c>();
        currencyCodes.add(new CurrencyCode__c(Name='USD', CURRENCY_NAME__C='USD', STOREFRONT__C='DefaultStore'));
        insert currencyCodes;
    }
    
    public static void loadLanguageCodes()
    {
        List<E_Language__c> languageCodes = [Select c.Id From E_Language__c c LIMIT 2000];
        delete languageCodes;

        languageCodes = new List<E_Language__c>();
        languageCodes.add(new E_Language__c(Name='en_US', Language__c='English', Locale__c='en_US', Storefront__c='DefaultStore', default__c=true));
        insert languageCodes;
    }

    public static void loadTestPageConfigurations() {
    	List<PageConfiguration__c> configList = new List<PageConfiguration__c> {
    		new PageConfiguration__c(Name='DefaultStore.Theme', Value__c='mytheme'),
    		new PageConfiguration__c(Name='Global.All.css.010', Value__c='css1'),
    		new PageConfiguration__c(Name='Global.All.css.020', Value__c='css2'),
    		new PageConfiguration__c(Name='Global.HomePage.css.010', Value__c='css3'),
    		new PageConfiguration__c(Name='Global.HomePage.css.020', Value__c='css4'),
    		new PageConfiguration__c(Name='DefaultStore.All.css.010', Value__c='css5'),
    		new PageConfiguration__c(Name='DefaultStore.All.css.020', Value__c='css6'),
    		new PageConfiguration__c(Name='DefaultStore.HomePage.css.010', Value__c='css7'),
    		new PageConfiguration__c(Name='DefaultStore.HomePage.css.020', Value__c='css8'),
    		new PageConfiguration__c(Name='DefaultStore.HomePage.css.030', Value__c='css9'),
            new PageConfiguration__c(Name='Global.All.js.010', Value__c='js1'),
            new PageConfiguration__c(Name='Global.All.js.020', Value__c='js2'),
            new PageConfiguration__c(Name='Global.HomePage.js.010', Value__c='js3'),
            new PageConfiguration__c(Name='Global.HomePage.js.020', Value__c='js4'),
            new PageConfiguration__c(Name='DefaultStore.All.js.010', Value__c='js5'),
            new PageConfiguration__c(Name='DefaultStore.All.js.020', Value__c='js6'),
            new PageConfiguration__c(Name='DefaultStore.HomePage.js.010', Value__c='js7'),
            new PageConfiguration__c(Name='DefaultStore.HomePage.js.020', Value__c='js8'),
            new PageConfiguration__c(Name='DefaultStore.HomePage.js.030', Value__c='js9', Enabled__c=false),
            new PageConfiguration__c(Name='DefaultStore.HomePage.uiKey', Value__c='HomePage'),
            new PageConfiguration__c(Name='DefaultStore.Cart.uiKey', Value__c='Cart')
    	};
    	upsert configList;
    }

    public static void loadTestPageUIKeys() {
		List<PageUIKey__c> pagekeys = new List<PageUIKey__c> {
			new PageUIKey__c(Name='homepage', Value__c='homepage'),
			new PageUIKey__c(Name='products', Value__c='prodlist'),
			new PageUIKey__c(Name='productdetail', Value__c='proddetail'),
			new PageUIKey__c(Name='cart', Value__c='cart'),
			new PageUIKey__c(Name='checkoutnew', Value__c='checkout'),
			new PageUIKey__c(Name='orderview', Value__c='order'),
			new PageUIKey__c(Name='myaccount', Value__c='myaccount'),
			new PageUIKey__c(Name='ccbandwidthexceeded', Value__c='error'),
			new PageUIKey__c(Name='ccchangepassword', Value__c='login'),
			new PageUIKey__c(Name='ccexception', Value__c='error'),
			new PageUIKey__c(Name='ccfilenotfound', Value__c='error'),
			new PageUIKey__c(Name='ccforgotpassword', Value__c='login'),
			new PageUIKey__c(Name='ccforgotpasswordconfirm', Value__c='login'),
			new PageUIKey__c(Name='ccinmaintenance', Value__c='error'),
			new PageUIKey__c(Name='ccsitelogin', Value__c='login'),
			new PageUIKey__c(Name='ccsiteregister', Value__c='register'),
			new PageUIKey__c(Name='ccsiteregisterconfirm', Value__c='login'),
			new PageUIKey__c(Name='ccunauthorized', Value__c='error'),
			new PageUIKey__c(Name='ccunderconstruction', Value__c='error')
		};
		insert pagekeys;
    }
}