//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_ctrl_LocaleExtension {
	private static String txtReturn = cc_util_logging.SUCCESS;
    private static String txStatus = cc_util_logging.SUCCESS;
    private static String CLASSNAME = 'cc_ctrl_LocaleExtension';
    private static String transactionLog = ''; 
	
    //==================================================
    // INSTANCE VARIABLE
    //================================================== 
    private ApexPages.StandardController controller;

    //==================================================
    // INSTANCE PROPERTIES
    //==================================================  
    public String userLanguageCode {get;set; }

    //==================================================
    // CONSTRUCTOR
    //================================================== 
    public cc_ctrl_LocaleExtension(ApexPages.StandardController c) {
        this();
        this.controller = c;  
    }
    public cc_ctrl_LocaleExtension(cc_ctrl_HomePage controller) { this(); }
    public cc_ctrl_LocaleExtension() { userLanguageCode = cc_util_Locale.getUserLanguage(); }
    public cc_ctrl_LocaleExtension(cc_ctrl_CloudCraze ctrl) { this(); }
    public cc_ctrl_LocaleExtension(cc_ctrl_AddToCart controller) { this(); }
    public cc_ctrl_LocaleExtension(cc_ctrl_Admin controller) { this(); }
    public cc_ctrl_LocaleExtension(cc_ctrl_Banner controller) { this(); }
    public cc_ctrl_LocaleExtension(cc_ctrl_SendEmail controller) { this(); }
    public cc_ctrl_LocaleExtension(cc_ctrl_UserLocationHandler controller) { this(); }
    public cc_ctrl_LocaleExtension(cc_ctrl_ForgotPassword controller) { this(); }
    public cc_ctrl_LocaleExtension(cc_ctrl_IEIncludes controller) { this(); }
    public cc_ctrl_LocaleExtension(cc_ctrl_MenuBar controller) { this(); }
    public cc_ctrl_LocaleExtension(cc_ctrl_Cart controller) { this(); }
    public cc_ctrl_LocaleExtension(cc_ctrl_GetSession controller) { this(); }
    //public cc_ctrl_LocaleExtension(Marshall controller) { this(); }
    public cc_ctrl_LocaleExtension(cc_ctrl_MyAccount controller) { this(); }
    public cc_ctrl_LocaleExtension(cc_ctrl_ShippingAndHandling controller) { this(); }
    public cc_ctrl_LocaleExtension(cc_ctrl_SiteLogin controller) { this(); }
    public cc_ctrl_LocaleExtension(cc_ctrl_MyAccountAddressBook controller) { this(); }    
	
    //==================================================
    // SERVICE METHODS
    //==================================================
    public String getHomepageTemplate() {
        return cc_dao_PageConfiguration.getValue('HomepageTemplate');
    }
    public String getHomepageHeader() {
        return cc_dao_PageConfiguration.getValue('HomepageHeader');
    }
    public String getHomepageSplash() {
        return cc_dao_PageConfiguration.getValue('HomepageSplash');
    }
    public String getHomepageQuickSearch() {
        return cc_dao_PageConfiguration.getValue('HomepageQuickSearch');
    }
    public String getHomepageLeftNav() {
        return cc_dao_PageConfiguration.getValue('HomepageLeftNav');
    }
    public String getHomepageBody() {
        return cc_dao_PageConfiguration.getValue('HomepageBody');
    }
    public String getHomepageListView() {
        return cc_dao_PageConfiguration.getValue('HomepageListView');
    }
    public String getHomepageQuickOrder() {
        return cc_dao_PageConfiguration.getValue('HomepageQuickOrder');
    }
    public String getHomepageMiniQuickOrder() {
        return cc_dao_PageConfiguration.getValue('HomepageMiniQuickOrder');
    }
    
	//IL - Use for UI Custom Setting
    public static String getccStyle() { return cc_util_UserInterface.getccStyle();}  //Todo - need to change it to public.
  	public static String getccStaticResourceLogo() { return cc_util_UserInterface.getSRHeaderLogo();}	
 	public static String getccStaticResourceTaggLine() { return cc_util_UserInterface.getSRHeaderTagLine();}	
  	public static String getccTransactionLog() { return cc_util_UserInterface.getTransactionLog();}
	//IL - Use for UI Custom Setting
 
    static testMethod void myUnitTest() {
        cc_test_TestDataSetup.LoadData();
        System.runas(cc_test_TestDataSetup.testUser) {
        E_Product__c product = new E_Product__c();
        System.assert(new cc_ctrl_LocaleExtension(new ApexPages.StandardController(product)) != null);
        System.assert(new cc_ctrl_LocaleExtension(new cc_ctrl_HomePage()) != null);
        System.assert(new cc_ctrl_LocaleExtension(new cc_ctrl_CloudCraze()) != null);
        System.assert(new cc_ctrl_LocaleExtension(new cc_ctrl_AddToCart()) != null);
        
        System.assert(new cc_ctrl_LocaleExtension(new cc_ctrl_Admin()) != null);
        System.assert(new cc_ctrl_LocaleExtension(new cc_ctrl_Banner()) != null);
        System.assert(new cc_ctrl_LocaleExtension(new cc_ctrl_SendEmail()) != null);
        System.assert(new cc_ctrl_LocaleExtension(new cc_ctrl_UserLocationHandler()) != null);
        
        System.assert(new cc_ctrl_LocaleExtension(new cc_ctrl_ForgotPassword()) != null);
        System.assert(new cc_ctrl_LocaleExtension(new cc_ctrl_IEIncludes()) != null);
        System.assert(new cc_ctrl_LocaleExtension(new cc_ctrl_MenuBar()) != null);
        System.assert(new cc_ctrl_LocaleExtension(new cc_ctrl_Cart()) != null);
        
        System.assert(new cc_ctrl_LocaleExtension(new cc_ctrl_GetSession()) != null);
        System.assert(new cc_ctrl_LocaleExtension(new cc_ctrl_MyAccount()) != null);
        System.assert(new cc_ctrl_LocaleExtension(new cc_ctrl_ShippingAndHandling()) != null);
        
        System.assert(new cc_ctrl_LocaleExtension(new cc_ctrl_SiteLogin()) != null);
        System.assert(new cc_ctrl_LocaleExtension(new cc_ctrl_SiteRegister()) != null);
         System.assert(new cc_ctrl_LocaleExtension(new cc_ctrl_MyAccountAddressBook()) != null);
        
        /*
        System.assert(new cc_ctrl_LocaleExtension(new cc_ctrl_ConfigureProduct()) != null);
        */
        
        cc_ctrl_LocaleExtension ctrl = new cc_ctrl_LocaleExtension();
        
        delete [select id from PageConfiguration__c where name like 'Home%'];
        List<PageConfiguration__c> pcList = new List<PageConfiguration__c>();
        pcList.add(new PageConfiguration__c(Name = 'HomePageTemplate', Value__c = 'HomePageTemplate'));
        pcList.add(new PageConfiguration__c(Name = 'HomepageHeader', Value__c = 'HomepageHeader'));
        pcList.add(new PageConfiguration__c(Name = 'HomepageSplash', Value__c = 'HomepageSplash'));
        pcList.add(new PageConfiguration__c(Name = 'HomepageQuickSearch', Value__c = 'HomepageQuickSearch'));
        pcList.add(new PageConfiguration__c(Name = 'HomepageLeftNav', Value__c = 'HomepageLeftNav'));
        pcList.add(new PageConfiguration__c(Name = 'HomepageBody', Value__c = 'HomepageBody'));
        pcList.add(new PageConfiguration__c(Name = 'HomepageListView', Value__c = 'HomepageListView'));
        pcList.add(new PageConfiguration__c(Name = 'HomepageQuickOrder', Value__c = 'HomepageQuickOrder'));
        pcList.add(new PageConfiguration__c(Name = 'HomepageMiniQuickOrder', Value__c = 'HomepageMiniQuickOrder'));
        insert pcList;
        
        //System.assert(ctrl.getHomePageTemplate() != null);
        System.assert(ctrl.getHomepageHeader() != null);
        System.assert(ctrl.getHomepageSplash() != null);
        System.assert(ctrl.getHomepageQuickSearch() != null);
        System.assert(ctrl.getHomepageLeftNav() != null);
        System.assert(ctrl.getHomepageBody() != null);
        System.assert(ctrl.getHomepageListView() != null);
        System.assert(ctrl.getHomepageQuickOrder() != null);
        System.assert(ctrl.getHomepageMiniQuickOrder() != null);

    	String tsccstyle=cc_ctrl_LocaleExtension.getccStyle();
    	String tslogo=cc_ctrl_LocaleExtension.getccStaticResourceLogo();
    	String tsLog=cc_ctrl_LocaleExtension.getccStaticResourceTaggLine();
    	String tstline=cc_ctrl_LocaleExtension.getccTransactionLog();
        }
    }
    
}