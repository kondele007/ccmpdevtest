public with sharing class cc_ctrl_admin_Themes extends cc_ctrl_admin_Storefront {
	
	public cc_api_PageConfiguration pageConfigAPI = cc_api_PageConfiguration.getInstance();
	
	public String currentTheme {get;set;}
	public Document newDoc {get;set;}
	public String newDocLabel {get;set;}

	public cc_ctrl_admin_Themes() {
		super();
	}
	
	public PageReference selectStorefront() {
		setCurrentStorefrontTheme();
		return null;
	}
	
	public void setCurrentStorefrontTheme() {
		System.debug('--- cc_ctrl_admin_Themes.getStorefrontTheme: storefrontName=' + storefrontName);
		if(storefrontName != null) {
			currentTheme = pageConfigAPI.getPageConfigurationValue(storefrontName + '.theme');
		}
	}
	
	public List<String> getThemes() {
		List<String> themes = new List<String>();

		for(StaticResource sr : [select NamespacePrefix, Name from StaticResource where Name like '%theme%' limit 1000]) {
			String themeName = sr.Name;
			if(sr.NamespacePrefix != null) {
				themeName = sr.NamespacePrefix + '__' + themeName;
			}
			themes.add(themeName);
		}

		return themes;
	}
	
	public List<SelectOption> getThemeOptionList() {
		List<SelectOption> selectOptions = new List<SelectOption>();
		
		for(StaticResource sr : [select NamespacePrefix, Name from StaticResource where Name like '%theme%' limit 1000]) {
			String themeName = sr.Name;
			if(sr.NamespacePrefix != null) {
				themeName = sr.NamespacePrefix + '__' + themeName;
			}
			selectOptions.add(new SelectOption(themeName, themeName));
		}
		return selectOptions;
	}
	
	public PageReference uploadStaticResource() {
		return null;
	}
	
	static testMethod void myUnitTest() {
	 	cc_test_TestDataSetup.loadData();
		list<PageConfiguration__c> pcs = new list<PageConfiguration__c> {
        	new PageConfiguration__c(name='DefaultStore.Theme', value__c='CCThemeRed', Enabled__c=true)
        };
        insert pcs;
		System.runAs(cc_test_TestDataSetup.testUser) {
			cc_ctrl_admin_Themes admin = new cc_ctrl_admin_Themes();
			admin.storefrontName = 'DefaultStore';
			admin.getThemeOptionList();
			admin.getThemes();
			admin.setCurrentStorefrontTheme();
		
			system.assert(admin.selectStorefront() == null);
			system.assert(admin.uploadStaticResource() == null);
		}
	 }
	 
}