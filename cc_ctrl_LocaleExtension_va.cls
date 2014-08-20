//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_ctrl_LocaleExtension_va {
	private static String txtReturn = cc_util_logging.SUCCESS;
    private static String txStatus = cc_util_logging.SUCCESS;
    private static String CLASSNAME = 'cc_ctrl_LocaleExtension_va';
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
    public cc_ctrl_LocaleExtension_va(ApexPages.StandardController c) {
        this();
        this.controller = c;  
    }
    public cc_ctrl_LocaleExtension_va(cc_ctrl_HomePage controller) { this(); }
    public cc_ctrl_LocaleExtension_va() { userLanguageCode = cc_util_Locale.getUserLanguage(); }
    public cc_ctrl_LocaleExtension_va(cc_ctrl_CloudCraze_va ctrl) { this(); }
    public cc_ctrl_LocaleExtension_va(cc_ctrl_AddToCart controller) { this(); }
    public cc_ctrl_LocaleExtension_va(cc_ctrl_Admin controller) { this(); }
    public cc_ctrl_LocaleExtension_va(cc_ctrl_Banner controller) { this(); }
    public cc_ctrl_LocaleExtension_va(cc_ctrl_SendEmail controller) { this(); }
    public cc_ctrl_LocaleExtension_va(cc_ctrl_UserLocationHandler controller) { this(); }
    public cc_ctrl_LocaleExtension_va(cc_ctrl_ForgotPassword controller) { this(); }
    public cc_ctrl_LocaleExtension_va(cc_ctrl_IEIncludes controller) { this(); }
    public cc_ctrl_LocaleExtension_va(cc_ctrl_MenuBar controller) { this(); }
    public cc_ctrl_LocaleExtension_va(cc_ctrl_Cart controller) { this(); }
    public cc_ctrl_LocaleExtension_va(cc_ctrl_GetSession controller) { this(); }
    //public cc_ctrl_LocaleExtension_va(Marshall controller) { this(); }
    public cc_ctrl_LocaleExtension_va(cc_ctrl_MyAccount controller) { this(); }
    public cc_ctrl_LocaleExtension_va(cc_ctrl_ShippingAndHandling controller) { this(); }
    public cc_ctrl_LocaleExtension_va(cc_ctrl_SiteLogin controller) { this(); }
    public cc_ctrl_LocaleExtension_va(cc_ctrl_MyAccountAddressBook controller) { this(); }    
	
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
    
}