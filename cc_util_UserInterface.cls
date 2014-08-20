//
//
//  Created by CloudCraze, LLC.
//  Copyright 2012 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_util_UserInterface {
	private static final String DEFAULT_CC_NAMESPACE='ccsaas2012';
    private static final String DEFAULT_CC_LOGO='/images/cloudburst_logo.gif';
    private static final String DEFAULT_CC_TAGGLINE='/images/home/tagline.gif';
    private static final String CC_OVERRIDESTATIC='CC_OverrideStatic';
    private static final String DEFAULT_CC_STATIC='CC_Static2';
	private static String txtReturn = cc_util_logging.SUCCESS;
    private static String txStatus = cc_util_logging.SUCCESS;
    private static String CLASSNAME = 'cc_util_UserInterface';

    public static String transactionLog = ''; 
	public static Map<String,String> gvMap {get;set;}
	public static Map<String,String> staticResourcesMap {get;set;}
    
    
    public cc_util_UserInterface() { 
    }
    public cc_util_UserInterface(object controller) { 
    }
    
    public static String getGvStorePagename() {
    	System.debug('>>>getGvStorePagename gvMap='+gvMap);
    	if(gvMap==null || gvMap.size()==0) {
    		getGlobalVariableValue('H.Logo', 'H.Logo');
    	}
    	System.debug('>>>getGvStorePagename gvMap2='+gvMap);
    	return getStorefrontName()+'.'+getPagename();
    }
    
    
    public static String getTransactionLog() {
    	String result='';
		String gvValue = getGlobalVariableValue('TransactionLog','Global.TransactionLog');
    	if(gvValue!=null && 'Y'.equalsIgnoreCase(gvValue)) {
    		result=transactionLog;
    	}
    	return result;
    }
    

    
    public static String getSRHeaderTagLine() {
    	String methodName = 'getSRHeaderTaggLine ';
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'Start');
    	String defaultValue='H.TLine';
    	String ovvalue=getPageOverrideSettingValue('HomePage',defaultValue);
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'ovvalue='+ovvalue);
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'defaultValue='+defaultValue);
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'DEFAULT_CC_TAGGLINE='+DEFAULT_CC_TAGGLINE);
    	String result =getccStaticResourceByCustomSetting(ovvalue,defaultValue, DEFAULT_CC_TAGGLINE);
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'result='+result);
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'End');
		//cc_util_logging.addToCCLogFuture(CLASSNAME, methodName, '', '', txStatus, transactionLog);
    	return result;
    }
        
    public static String getSRHeaderLogo() {
    	String methodName = 'getSRHeaderLogo ';
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'Start');
    	String defaultValue='H.Logo';
    	String ovvalue=getPageOverrideSettingValue('HomePage',defaultValue);
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'ovvalue='+ovvalue);
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'defaultValue='+defaultValue);
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'DEFAULT_CC_LOGO='+DEFAULT_CC_LOGO);
    	String result =getccStaticResourceByCustomSetting(ovvalue,defaultValue, DEFAULT_CC_LOGO);
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'result='+result);
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'End');
		//cc_util_logging.addToCCLogFuture(CLASSNAME, methodName, '', '', txStatus, transactionLog);
    	return result;
    }

	public static String getccStaticResourceURL(Boolean boverride, String defaultValue) {
    	String methodName = 'getccStaticResourceURL ';
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'Start');
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'defaultValue='+defaultValue);
    	String result='';
		if(defaultValue!=null && defaultValue.length()>0) {		
			String srString = getStaticResource(getCCNameSpace() +'__'+DEFAULT_CC_STATIC);
			transactionLog = cc_util_logging.log(transactionLog, methodName + 'srString 1='+srString);
			if(srString==null || srString.length()==0)
				srString=getStaticResource(DEFAULT_CC_STATIC);
			transactionLog = cc_util_logging.log(transactionLog, methodName + 'srString 2='+srString);
			result = srString + defaultValue;
			transactionLog = cc_util_logging.log(transactionLog, methodName + 'result='+result);
			if(boverride) {
				String ovccstaticResource = getStaticResource(CC_OVERRIDESTATIC) + defaultValue;
				transactionLog = cc_util_logging.log(transactionLog, methodName + 'ovccstaticResource='+ovccstaticResource);
				result=ovccstaticResource;	
			}
			if(boverride && defaultValue.toLowerCase().startsWith('http')) {
				result=defaultValue;
			}
		}
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'final result='+result);
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'End');
		return result;
	}
	    
	private static String getccStaticResourceByCustomSetting(String ovstaticResource,String globalStaticResource, String defaultValue) {
    	String methodName = 'getccStaticResourceByCustomSetting ';
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'Start');
		String srString = getStaticResource(getCCNameSpace() +'__'+DEFAULT_CC_STATIC);
		if(srString==null || srString.length()==0)
			srString=getStaticResource(DEFAULT_CC_STATIC);
		String ccstaticResource = srString + defaultValue;
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'ccstaticResource='+ccstaticResource);
		if(ovstaticResource!=null && ovstaticResource.length()>0) {
			String storefrontName=getStorefrontName();			
			if(storefrontName!=null && storefrontName.length()>0) {
				transactionLog = cc_util_logging.log(transactionLog, methodName + 'storefrontName='+storefrontName);
				transactionLog = cc_util_logging.log(transactionLog, methodName + 'override='+storefrontName + '.'+ovstaticResource);
				transactionLog = cc_util_logging.log(transactionLog, methodName + 'global='+'Global.'+globalStaticResource);
				//Get Mapping for storefront name
				//String istorefront=storefrontName;
				//transactionLog = cc_util_logging.log(transactionLog, methodName + 'istorefront 1='+istorefront);
				//if(gvMap!=null && gvMap.containskey('storefront.map.'+storefrontName.toLowerCase())) {
				//	transactionLog = cc_util_logging.log(transactionLog, methodName + 'istorefront 2='+istorefront);
				//	istorefront=gvMap.get('storefront.map.'+storefrontName.toLowerCase());
				//	transactionLog = cc_util_logging.log(transactionLog, methodName + 'istorefront 3='+istorefront);
				//}
				String gvValue = getGlobalVariableValue(storefrontName + '.'+ovstaticResource,'Global.'+globalStaticResource);
				transactionLog = cc_util_logging.log(transactionLog, methodName + 'gvValue='+gvValue);
				if(gvValue!=null && gvValue.length()>0 && !'NotAvailalbe'.equalsIgnoreCase(gvValue)) {
					String ovccstaticResource = getStaticResource(CC_OVERRIDESTATIC);
					transactionLog = cc_util_logging.log(transactionLog, methodName + 'ovccstaticResource='+ovccstaticResource);
					if(ovccstaticResource!=null && ovccstaticResource.length()>0) {
						ccstaticResource=ovccstaticResource+gvValue;
						transactionLog = cc_util_logging.log(transactionLog, methodName + 'ccstaticResource 111='+ccstaticResource);
					}
					if(gvValue.toLowerCase().startsWith('http')) {
						ccstaticResource=gvValue;
					}
				} else if(gvValue!=null && gvValue.length()>0 && 'NotAvailable'.equalsIgnoreCase(gvValue)) {
					ccstaticResource=gvValue;
				}
			}
		}
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'ccstaticResource='+ccstaticResource);
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'End');
		return ccstaticResource;
	}
	
    private static String getCCNameSpace() {
    	String snamespace= cc_util_CloudCraze.localNamespace;
    	if(!al.StringUtils.isBlank(snamespace)) {
    		integer index = snamespace.lastIndexOf('__');
    		if(index != -1) {
    			snamespace = snamespace.substring(0, index);
    		}
    	}
    	return snamespace;
    }
    
    public static String getStaticResource(String srname) {
    	String methodName = 'getStaticResource ';
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'Start');
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'srname='+srname);
    	String result=null;
    	if(staticResourcesMap==null) {
    		staticResourcesMap=new Map<String,String>();
    	}
    	//if(srname!=null && srname.length()>0 && !staticResourcesMap.containsKey(srname)) {
    	if(srname!=null && srname.length()>0 && staticResourcesMap.size()==0) {
    		for(StaticResource sr:[Select s.SystemModstamp, s.NamespacePrefix, 
    		                              s.Name, s.LastModifiedDate, s.Id, s.CreatedDate
    		                         From StaticResource s limit 1000]) {
    		    String skey = sr.Name;                     	
    		    if(sr.NamespacePrefix!=null && sr.NamespacePrefix.length()>0) {
    		    	skey=sr.NamespacePrefix+'__'+sr.Name;
    		    }                     	
    		    String svalue='/resource/'+sr.SystemModstamp.getTime()+'/'+skey;
				transactionLog = cc_util_logging.log(transactionLog, methodName + 'skey_svalue='+skey+'_'+svalue);
				staticResourcesMap.put(skey,svalue);    			
    		}    		
    	}
     	if(srname!=null && srname.length()>0 && staticResourcesMap.containsKey(srname)) {
     		result=staticResourcesMap.get(srname);
     	}
     	if(result==null || result.length()==0) 
     		result=''; 
     	if(Test.isRunningTest() && srname.equalsIgnoreCase(CC_OVERRIDESTATIC)) {
     		result='/resources/1234567890/Test';
     	}
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'result='+result);
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'End');
		return result;    	
    }

    private static String getPageOverrideSettingValue(String defaultPageName, String svalue) {
    	String methodName = 'getOverrideSettingValue ';
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'Start');
		String result = defaultPageName+'.'+svalue;
    	String pgURL = ApexPages.currentPage().getUrl();
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'pgURL='+pgURL);
		if(Test.isRunningTest()) {
			pgURL='/apex/'+getCCNameSpace()+'__'+'HomePage?test=';
		}
    	if(pgURL!=null && pgURL.length()>0) {
    		result = getPagename()+'.'+svalue;
			transactionLog = cc_util_logging.log(transactionLog, methodName + 'result 3='+result);
    	}
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'result='+result);
    	return result;
    }    
    
    private static String getStorefrontName() {
    	
    	String sstorefrontName='DefaultStore';
		cc_ctrl_CloudCraze ccController = new cc_ctrl_CloudCraze();
		if(ccController!=null && ccController.storefront!=null
			&& ccController.storefront.Name!=null && ccController.storefront.Name.length()>0) {   
			sstorefrontName=ccController.storefront.Name;
			if(sstorefrontName!=null && sstorefrontName.length()>0
			&& gvMap!=null && gvMap.containskey('storefront.map.'+sstorefrontName.toLowerCase())) {
				sstorefrontName=gvMap.get('storefront.map.'+sstorefrontName.toLowerCase());
			}
		} 	
    	return sstorefrontName;
    }
    
    //todo jll making this public for now - talk to matt
    public static String getPagename() {
    	String methodName = 'getPagename ';
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'Start');
		String result = '';
    	String pgURL = ApexPages.currentPage().getUrl();
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'pgURL='+pgURL);
		if(Test.isRunningTest()) {
			pgURL='/apex/'+getCCNameSpace()+'__'+'HomePage?test=';
		}
    	if(pgURL!=null && pgURL.length()>0) {
    		if(pgURL.contains('?')) {
    			Integer idx=pgURL.indexOf('?');
    			if(idx>0) {
    				pgURL=pgURL.substring(0, idx);
    			}
    		}
			transactionLog = cc_util_logging.log(transactionLog, methodName + 'pgURL 1='+pgURL);
    		String nspace = getCCNameSpace()+'__';
    		if(pgURL.contains(nspace)) {
    			pgURL=pgURL.replaceAll(nspace,'');
    		}
			transactionLog = cc_util_logging.log(transactionLog, methodName + 'pgURL 2='+pgURL);
    		if(pgURL.contains('/apex/')) {
    			pgURL=pgURL.replaceAll('/apex/','');
    		}
			transactionLog = cc_util_logging.log(transactionLog, methodName + 'pgURL 3='+pgURL);
			//Get Mapping for the pagename
			if(pgURL!=null && gvMap!=null && gvMap.containsKey('pagename.map.'+pgURL.toLowerCase())) {
				transactionLog = cc_util_logging.log(transactionLog, methodName + 'pgURL 4='+pgURL);
				pgURL=gvMap.get('pagename.map.'+pgURL.toLowerCase());
				transactionLog = cc_util_logging.log(transactionLog, methodName + 'pgURL 5='+pgURL);
			}
    		result=pgURL;
			transactionLog = cc_util_logging.log(transactionLog, methodName + 'result 3='+result);
    	}
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'result='+result);
    	return result;    	
    }    
        
    public static String getGlobalVariableValue(String sname, String defaultName) {
    	String methodName = CLASSNAME + '-getGlobalVariableValue ';
    	if(sname!=null) sname=sname.toLowerCase();
    	if(defaultName!=null) defaultName=defaultName.toLowerCase();
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'Start');
    	String result = '';
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'sname='+sname);
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'defaultName='+defaultName);
    	if((sname!=null && sname.length()>0)
    	|| (defaultName!=null && defaultName.length()>0)) {
			transactionLog = cc_util_logging.log(transactionLog, methodName + 'gvMap='+gvMap);
	    	if(gvMap==null 
	    	|| (sname!=null && sname.length()>0 && !gvMap.containsKey(sname))
	    	|| (defaultName!=null && defaultName.length()>0 && !gvMap.containsKey(defaultName))) {
	    		gvMap=new Map<String,String>();
	    		loadStorePagenameMapping();
	    		for(PageConfiguration__c gv:PageConfiguration__c.getAll().values()) {
					transactionLog = cc_util_logging.log(transactionLog, methodName + 'gv='+gv);
	    			gvMap.put(gv.Name.toLowerCase(),gv.Value__c);
	    		}
	    	}
			transactionLog = cc_util_logging.log(transactionLog, methodName + 'defaultName='+defaultName);
			if((gvMap.containsKey(defaultName)) || Test.isRunningTest() ) {
				result=gvMap.get(defaultName);
				transactionLog = cc_util_logging.log(transactionLog, methodName + 'result GL='+result);
			}
    		if(gvMap.containsKey(sname)) {
    			result=gvMap.get(sname);
				transactionLog = cc_util_logging.log(transactionLog, methodName + 'result OV='+result);
    		}
    	} 
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'result='+result);
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'End');
		System.debug('\n\n transactionlog=\n\n'+transactionLog+'\n\n');
    	return result;
    }
    
	private static String OverrideStaticResourceValue {
		get {
	    	String methodName = CLASSNAME + '-getOverrideStaticResourceValue ';
			transactionLog = cc_util_logging.log(transactionLog, methodName + 'Start');
			String result =null;
			String sglobalovresource='Global.'+cc_cnst_CloudCraze.UI_GLOBAL_OVERRIDESTATICRESOURCE;
			String sovresource=null;
			cc_ctrl_CloudCraze ccController = new cc_ctrl_CloudCraze();
			if(ccController!=null && ccController.storefront!=null
			&& ccController.storefront.Name!=null && ccController.storefront.Name.length()>0) {
				sovresource=ccController.storefront.Name + '.'+cc_cnst_CloudCraze.UI_GLOBAL_OVERRIDESTATICRESOURCE;
			}
			transactionLog = cc_util_logging.log(transactionLog, methodName + 'sovresource='+sovresource);
			result=getGlobalVariableValue(sovresource,sglobalovresource);
			transactionLog = cc_util_logging.log(transactionLog, methodName + 'result='+result);
			transactionLog = cc_util_logging.log(transactionLog, methodName + 'End');
	    	//cc_util_logging.addToCCLogFuture(CLASSNAME, methodName, '', '', txStatus, transactionLog);
			System.debug('\n\n transactionlog=\n\n'+transactionLog+'\n\n');
			return result;
		}
	}
		
	public static String getccStyle() { 
	    	String methodName = CLASSNAME + '-getccStyle ';
			transactionLog = cc_util_logging.log(transactionLog, methodName + 'Start');
			String result='';
			transactionLog = cc_util_logging.log(transactionLog, methodName + 'OverrideStaticResourceValue='+OverrideStaticResourceValue);
	        if(OverrideStaticResourceValue!=null && OverrideStaticResourceValue.length()>0) {
				//List<StaticResource> srList = [Select s.SystemModstamp, s.Name, s.LastModifiedDate, s.Id, s.CreatedDate From StaticResource s where s.Name=:CC_OVERRIDESTATIC limit 1];
				String sr= getStaticResource(CC_OVERRIDESTATIC);
				transactionLog = cc_util_logging.log(transactionLog, methodName + 'sr='+sr);
				//if(Test.isRunningTest()) {
				//	srList= new List<StaticResource>();
				//	StaticResource sr = new StaticResource(Name=CC_OVERRIDESTATIC);
				//	srList.add(sr);
				//}
	        	if(sr!=null && sr.length()>0) {
	        		//Long lSr = System.now().getTime();
	        		//if(srList[0].SystemModstamp!=null) {
	        		//	lSr=srList[0].SystemModstamp.getTime();
	        		//}	        		
		        	//result = '/resource/'+lSr+'/'+OverrideStaticResourceValue;
		        	result=sr+'/'+OverrideStaticResourceValue;
		        	if(OverrideStaticResourceValue.toLowerCase().startsWith('http')) {
		        		result=OverrideStaticResourceValue;
		        	}
					transactionLog = cc_util_logging.log(transactionLog, methodName + 'result 1='+result);
		        	//if(OverrideStaticResourceValue.startsWith('http')) {
					//	transactionLog = cc_util_logging.log(transactionLog, methodName + 'result 2='+result);
		        	//	result = OverrideStaticResourceValue;
		        	//}
	        	}
	        }
			transactionLog = cc_util_logging.log(transactionLog, methodName + 'result 3='+result);
			transactionLog = cc_util_logging.log(transactionLog, methodName + 'End');
	    	//cc_util_logging.addToCCLogFuture(CLASSNAME, methodName, '', '', txStatus, transactionLog);
 			System.debug('\n\n transactionlog=\n\n'+transactionLog+'\n\n');
 			
 	        return result;
	}      	
	
	public static void loadStorePagenameMapping() {
		if(gvMap==null) {
			gvMap=new Map<String,String>();
		}
		//Mapping default storename
		gvMap.put('storefront.map.defaultstore','ds');
		
		//Mapping default pagename
		gvMap.put('pagename.map.homepage','hp');
		gvMap.put('pagename.map.products','pl');
		gvMap.put('pagename.map.productdetails','pd');
		gvMap.put('pagename.map.cart','ca');
		gvMap.put('pagename.map.checkout','ck');
		gvMap.put('pagename.map.checkoutnew','ck');
		gvMap.put('pagename.map.orderview','ov');
		gvMap.put('pagename.map.myaccount','ma');

		//default mapping
		gvMap.put('ds.hp.l.dsplcattree','Y');
	}
	
	static testMethod void myUnitTest() {
        cc_test_PrepTestData.loadCustomSettings();
        System.assert([Select c.Id From E_ApplicationSettings__c c where name='CloudCraze'].size() != 0); 
        cc_test_PrepTestData.loadInitData();
        cc_test_PrepTestData.loadTestCategoryData();		
        delete [Select Id from PageConfiguration__c limit 1000];        
        cc_ctrl_CloudCraze ccController = new cc_ctrl_CloudCraze();
        List<PageConfiguration__c> tgvList = new List<PageConfiguration__c>();
        PageConfiguration__c gv = new PageConfiguration__c();
        gv.Name='Global.'+cc_cnst_CloudCraze.UI_GLOBAL_OVERRIDESTATICRESOURCE;
        gv.value__c='http://thisistest/styles.css';
        tgvList.add(gv);
        
        PageConfiguration__c gv1 = new PageConfiguration__c();
        gv1.Name=ccController.storefront.Name +'.'+cc_cnst_CloudCraze.UI_GLOBAL_OVERRIDESTATICRESOURCE;
        gv1.value__c='http://thisistest/styles.css';
        tgvList.add(gv1);

        PageConfiguration__c gv2 = new PageConfiguration__c();
        gv2.Name=ccController.storefront.Name +'.Homepage.'+'H.Logo';
        gv2.value__c='Y';
        tgvList.add(gv2);

        PageConfiguration__c gv3 = new PageConfiguration__c();
        gv3.Name='Global.'+'H.Logo';
        gv3.value__c='Y';
        tgvList.add(gv3);

        PageConfiguration__c gv4 = new PageConfiguration__c();
        gv4.Name='Global.'+'TransactionLog';
        gv4.value__c='Y';
        tgvList.add(gv4);

		upsert tgvList;
		        
		String testccStyle=cc_util_UserInterface.getccStyle();
		String testStaticResource = cc_util_UserInterface.getSRHeaderLogo();
		String testtlog = cc_util_UserInterface.getTransactionLog();
		String testtaggLine = cc_util_UserInterface.getSRHeaderTagLine();
		
		gv2.value__c='NotAvailable';
		update gv2;
		testStaticResource = cc_util_UserInterface.getSRHeaderLogo();
		System.debug('>>> testccStyle='+testccStyle);
		System.debug('>>> namespace =' + cc_util_UserInterface.getCCNameSpace());
	}	
}