public with sharing class cc_api_PageConfiguration {
	private cc_api_PageConfiguration() {}
	private Map<String,String> pageConfigMap = null; 
	private static cc_api_PageConfiguration instance = null;
	public static cc_api_PageConfiguration getInstance() {
		if(instance == null) {
			instance = new cc_api_PageConfiguration();
		}
		return instance;
	}
	
	public list<string> getPageConfigurationNames() {
		Map<String,String> pcMap =  cc_dao_PageConfiguration.getInstance().getPageConfigMap();
		list<string> retList = new list<string>();
		retList.addAll(pcMap.keyset());
		return retList;
    }
    public list<string> getPageConfigurationAttributes() {
		set<string> attrNames = new set<string>();
		for(string s : getPageConfigurationNames()) {
			system.debug('ryl-> s = ' + s);
			string[] nameParts = s.split('\\.');
			if(nameParts.size() == 4) {
				//form a name such as H.UsePI
				attrNames.add(nameParts[2] + '.' + nameParts[3]);
			}
		}
		list<string> retList = new list<string>();
		retList.addAll(attrNames);
		return retList;
    }
    
	public String getPageConfigurationValue(String sname, String defaultName) {
		return cc_dao_PageConfiguration.getInstance().getPageConfigurationValue(sname, defaultName);
    }
    
    public String getPageConfigurationValue(String sname) {
		return cc_dao_PageConfiguration.getInstance().getPageConfigurationValue(sname);
    }
    
    public list<cc_api_NameValuePair> getPageConfigurationValues(String sname) {
    	return cc_dao_PageConfiguration.getInstance().getPageConfigurationValues(sname);
    }
    
    public list<cc_api_NameValuePair> getPageConfigurationValues(Pattern spattern) {
    	return cc_dao_PageConfiguration.getInstance().getPageConfigurationValues(spattern);
    }
   
   	public String getValueWithOverride(String storefrontName, String uiKey, String sname) {
   		return getPageConfigurationOverriddenValue(storefrontName, uiKey, sname);
   	}
    
    public map<string, string> getAttributeMap(String storefrontName, String uiKey) {
    	map<string, string> retMap = new map<string, string>();
    	string ret = null;
		Pattern configKeyPattern = Pattern.compile('(?i)^(' +
			cc_cnst_PageConfiguration.ALL_STOREFRONTS + '|' + storefrontName +
			')\\.(' +
			cc_cnst_PageConfiguration.ALL_UI_KEYS + '|' + uiKey +
			')\\.(.*)$');
			
    	list<cc_api_NameValuePair> pairs = cc_dao_PageConfiguration.getInstance().getPageConfigurationValues(configKeyPattern);
    	for(cc_api_NameValuePair p : pairs) {
    		string[] parts = p.name.split('\\.');
    		if(parts.size() == 4) {
    			string name = parts[2] + '.' + parts[3];
    			retMap.put(name, p.value);
    		} 
    	}
    	return retMap;
    }
    public String getPageConfigurationOverriddenValue(String storefrontName, String uiKey, String sname) {
		string ret = null;
		Pattern configKeyPattern = Pattern.compile('(?i)^(' +
			cc_cnst_PageConfiguration.ALL_STOREFRONTS + '|' + storefrontName +
			')\\.(' +
			cc_cnst_PageConfiguration.ALL_UI_KEYS + '|' + uiKey +
			')\\.' +
			sname);
		system.debug('roy lou->' + cc_dao_PageConfiguration.getInstance().getPageConfigurationValues(configKeyPattern));	
		list<cc_api_NameValuePair> values = (list<cc_api_NameValuePair>) al.ArrayUtils.reverse(cc_dao_PageConfiguration.getInstance().getPageConfigurationValues(configKeyPattern));
		if(values.size() > 0) {
			ret = values[0].value;
		} 
		return ret;
    }	
}