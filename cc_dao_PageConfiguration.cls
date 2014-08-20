//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_dao_PageConfiguration {

    //==================================================
    // INSTANCE VARIABLES
    //==================================================
	private Map<String,String> pageConfigMap = null; 
	private static cc_dao_PageConfiguration instance = null;

	//==================================================
    // CONSTRUCTORS
    //==================================================
	private cc_dao_PageConfiguration() {}

    //==================================================
    // HELPER METHODS
    //==================================================
	public static cc_dao_PageConfiguration getInstance() {
		if(instance == null) {
			instance = new cc_dao_PageConfiguration();
		}
		if(instance.pageConfigMap == null) {
			instance.pageConfigMap = instance.getPageConfigMap();
		}
		return instance;
	}
	
	public Map<String,String> getPageConfigMap() {
		System.debug(Logginglevel.INFO, '--- cc_api_PageReference.getPageConfigMap: PageConfiguration__c.getAll().values()=' + PageConfiguration__c.getAll().values());
		//System.debug('--- cc_api_PageReference.getPageConfigMap: PageConfiguration__c.getAll().values()=' + PageConfiguration__c.getAll().values());
		
		Map<String,String> gvMap = new Map<String,String>();
		for(PageConfiguration__c gv : PageConfiguration__c.getAll().values()) {
			if(gv.Enabled__c) {
				gvMap.put(gv.Name.toLowerCase(), gv.Value__c);
			}
		}
		System.debug('--- cc_api_PageReference.getPageConfigMap: returning gvMap=' + gvMap);
		
		return gvMap;
	}
	
	public String getPageConfigurationValue(String sname, String defaultName) {
		String result = null;
    	if(sname!=null) sname=sname.toLowerCase();
    	if(defaultName!=null) defaultName=defaultName.toLowerCase();
		
    	if((sname!=null && sname.length()>0)
    	|| (defaultName!=null && defaultName.length()>0)) {
	    	if(pageConfigMap==null 
	    	|| (sname!=null && sname.length()>0 && !pageConfigMap.containsKey(sname))
	    	|| (defaultName!=null && defaultName.length()>0 && !pageConfigMap.containsKey(defaultName))) {
	    		pageConfigMap=new Map<String,String>();
	    		loadStorePagenameMapping();
	    		pageConfigMap = getPageConfigMap();
	    	}
			if((pageConfigMap.containsKey(defaultName)) || Test.isRunningTest() ) {
				result=pageConfigMap.get(defaultName);
			}
    		if(pageConfigMap.containsKey(sname)) {
    			result=pageConfigMap.get(sname);
    		}
    	} 
    	return result;
    }
    
    public String getPageConfigurationValue(String sname) {
		String result = null;
    	if(sname!=null) sname=sname.toLowerCase();
		System.debug('--- cc_dao_PageConfiguration.getPageConfigurationValue: getting value for sname=' + sname);
		
    	if((sname!=null && sname.length()>0)) {
	    	if(pageConfigMap==null 
	    	|| (sname!=null && sname.length()>0 && !pageConfigMap.containsKey(sname))) {
	    		pageConfigMap=new Map<String,String>();
	    		loadStorePagenameMapping();
	    		pageConfigMap = getPageConfigMap();
	    	}
    		if(pageConfigMap.containsKey(sname)) {
    			result=pageConfigMap.get(sname);
    		}
    	} 
		System.debug('--- cc_api_PageReference.getPageConfigurationValue: returning result=' + result);
    	return result;
    }
    
    public list<cc_api_NameValuePair> getPageConfigurationValues() {
    	list<cc_api_NameValuePair> result = new list<cc_api_NameValuePair>();
    	
    	set<string> keys = pageConfigMap.keyset();
    	for(string key : pageConfigMap.keyset()) {
    		result.add(new cc_api_NameValuePair(key, pageConfigMap.get(key)));
    	}
	    
    	result = (list<cc_api_NameValuePair>) cc_hlpr_CloudCrazeSorter.IntrospectionSort(result, 0, result.size(), new cc_api_NameValuePair.PageSettingComparator());
    	return result;
    }
    
    public list<cc_api_NameValuePair> getPageConfigurationValues(String sname) {
    	list<cc_api_NameValuePair> result = new list<cc_api_NameValuePair>();
    	if(sname!=null) {
	    	set<string> keys = pageConfigMap.keyset();
	    	for(string key : pageConfigMap.keyset()) {
	    		if(key.toLowerCase().contains(sname.toLowerCase())) {
	    			result.add(new cc_api_NameValuePair(key, pageConfigMap.get(key)));
	    		}
	    	}
	    }
    	result = (list<cc_api_NameValuePair>) cc_hlpr_CloudCrazeSorter.IntrospectionSort(result, 0, result.size(), new cc_api_NameValuePair.PageSettingComparator());
    	return result;
    }
    
    public list<cc_api_NameValuePair> getPageConfigurationValues(Pattern spattern) {
    	list<cc_api_NameValuePair> result = new list<cc_api_NameValuePair>();
   		//System.debug('--- cc_dao_PageConfiguration.getPageConfigurationValues(Pattern): spattern=' + spattern);
    	if(spattern!=null) {
	    	set<string> keys = pageConfigMap.keyset();
   			//System.debug('--- cc_dao_PageConfiguration.getPageConfigurationValues(Pattern): keys=' + keys);
	    	for(string key : pageConfigMap.keyset()) {
	    		//System.debug('--- cc_dao_PageConfiguration.getPageConfigurationValues(Pattern): checking against key=' + key);
	    		if(spattern.matcher(key).matches()) {
	    			result.add(new cc_api_NameValuePair(key, pageConfigMap.get(key)));
	    		}
	    	}
	    }
	    
   		//System.debug('--- cc_dao_PageConfiguration.getPageConfigurationValues(Pattern): result before compare=' + result);
    	result = (list<cc_api_NameValuePair>) cc_hlpr_CloudCrazeSorter.IntrospectionSort(result, 0, result.size(), new cc_api_NameValuePair.PageSettingComparator());
   		//System.debug('--- cc_dao_PageConfiguration.getPageConfigurationValues(Pattern): result after compare=' + result);
    	return result;
    }

    private void loadStorePagenameMapping() {
		if(pageConfigMap==null) {
			pageConfigMap=new Map<String,String>();
		}
		//Mapping default storename
		pageConfigMap.put('storefront.map.defaultstore','ds');
		
		//Mapping default pagename
		pageConfigMap.put('pagename.map.homepage','hp');
		pageConfigMap.put('pagename.map.products','pl');
		pageConfigMap.put('pagename.map.productdetails','pd');
		pageConfigMap.put('pagename.map.cart','ca');
		pageConfigMap.put('pagename.map.checkout','ck');
		pageConfigMap.put('pagename.map.checkoutnew','ck');
		pageConfigMap.put('pagename.map.orderview','ov');
		pageConfigMap.put('pagename.map.myaccount','ma');

		//default mapping
		pageConfigMap.put('ds.hp.l.dsplcattree','Y');
	}
	
	public static String getValue(String pKey)
	{
		system.debug('sns cc_dao_PageConfiguration.getValue(\'' + pKey + '\')');
		String ret = null;
		if(pKey != null && pKey.trim().length() != 0)
		{
			Map<String, PageConfiguration__c> m = PageConfiguration__c.getAll();
			if(m.containsKey(pKey)) {
				ret = m.get(pKey).Value__c;
				System.debug('--- getting pageconfiguration for key (' + pKey + ') = ' + ret + ' ---');
			}
		}
		return ret;
	}
}