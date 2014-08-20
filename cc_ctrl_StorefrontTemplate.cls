public with sharing class cc_ctrl_StorefrontTemplate {

	public cc_api_PageConfiguration pageConfigAPI = cc_api_PageConfiguration.getInstance();

	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public E_StorefrontSettings__c storefront {get; private set;}
    public String store {get;set;}

	public String uiKey {
		get {
			System.debug('--- cc_ctrl_StorefrontTemplate.uiKey: returning uiKey=' + uiKey);
			return uiKey;
		}
		private set;
	}
	
	//==================================================
    // CONSTRUCTORS
    //==================================================
    
	public cc_ctrl_StorefrontTemplate() {
        System.debug('--- cc_ctrl_StorefrontTemplate: instantiating without a controller');
        System.debug(Logginglevel.INFO, '--- cc_ctrl_StorefrontTemplate: currentPage=' + ApexPages.currentPage());
        System.debug(Logginglevel.INFO, '--- cc_ctrl_StorefrontTemplate: currentPage url=' + ApexPages.currentPage().getUrl());
        
        uiKey = cc_api_PageUIKey.getUIKeyForPage(cc_util_CloudCraze.getCurrentPageName());

    	store = ApexPages.currentPage().getParameters().get('store');
    	System.debug('--- cc_ctrl_StorefrontTemplate: store url param=' + store + ', Site.getPrefix= ' + Site.getPrefix());

    	if(store == null) {
    		store = Site.getPrefix();
    	}

    	if(store == null) {
    		store = cc_util_CloudCraze.application.Default_Storefront__c;
    	}

    	storefront = cc_util_CloudCraze.getStorefrontSettings(store);
        System.debug('--- cc_ctrl_StorefrontTemplate: storefront ' + storefront.Name + '=' + storefront);
	}
	
	//==================================================
    // METHODS
    //==================================================
	public List<String> getPageResources(String resourceType) {
		List<String> styles = new List<String>();
		
		// case insensitive pattern
		Pattern configKeyPattern = Pattern.compile('(?i)^(' +
			cc_cnst_PageConfiguration.ALL_STOREFRONTS + '|' + storefront.Name +
			')\\.(' +
			cc_cnst_PageConfiguration.ALL_UI_KEYS + '|' + uiKey +
			')\\.' +
			resourceType +
			'\\.[\\w.]*');
		
		List<cc_api_NameValuePair> nvpMap = pageConfigAPI.getPageConfigurationValues(configKeyPattern);
		for(cc_api_NameValuePair nvp : nvpMap) {
			styles.add(themeResourcePath + '/' + nvp.value);
		}
		
		return styles;
	}
	
	public List<String> getPageStyles() {
		List<String> styles = getPageResources(cc_cnst_PageConfiguration.RESOURCE_CSS);
		System.debug('--- cc_ctrl_StorefrontTemplate.getPageStyles: returning styles=' + styles);
		return styles;
	}
	
	public List<String> getPageJs() {
		List<String> jsList = getPageResources(cc_cnst_PageConfiguration.RESOURCE_JS);
		System.debug('--- cc_ctrl_StorefrontTemplate.getPageJs: returning jsList=' + jsList);
		return jsList;
	}

	public String currentTheme {
		get {
			if(currentTheme == null) {
				currentTheme = pageConfigAPI.getPageConfigurationValue(storefront.Name + '.theme');
			}
			System.debug('--- cc_ctrl_StorefrontTemplate.getCurrentTheme: returning currentTheme=' + currentTheme);
			return currentTheme;
		}
		set;
	}
	
	public String themeResourcePath {
		get {
			if(themeResourcePath == null) {
				themeResourcePath = cc_util_UserInterface.getStaticResource(currentTheme);
			}
			System.debug('--- cc_ctrl_StorefrontTemplate.themeResourcePath: returning themeResourcePath=' + themeResourcePath);
			return themeResourcePath;
		}
		set;
	}
	
	public String getStorefrontJSON() {
		String sfJSON = JSON.serialize(storefront);
		System.debug('--- cc_ctrl_StorefrontTemplate.getStorefrontJSON: sfJSON=' + sfJSON);
		return sfJSON;
	}

	//==================================================
    // TESTS
    //==================================================
    static testMethod void testStorefrontTemplate() {
    	cc_test_PrepTestData.loadCustomSettings();
    	cc_hlpr_InitLoadCustomSettings.loadTestPageUIKeys();
    	cc_hlpr_InitLoadCustomSettings.loadTestPageConfigurations();

        Test.setCurrentPage(System.Page.HomePage);

    	cc_ctrl_StorefrontTemplate controller = new cc_ctrl_StorefrontTemplate();

    	List<String> pageStyles = controller.getPageStyles();
    	System.assertEquals(9, pageStyles.size());

    	List<String> pageJs = controller.getPageJs();
    	System.assertEquals(8, pageJs.size());
    	
    	System.assertNotEquals(null, controller.getStorefrontJSON());
    }
}