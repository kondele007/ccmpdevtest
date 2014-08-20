//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing virtual class cc_ctrl_JQueryInclude {
	private static String txtReturn = cc_util_logging.SUCCESS;
    private static String txStatus = cc_util_logging.SUCCESS;
    private static String CLASSNAME = 'cc_ctrl_JQueryInclude';
    private static String transactionLog = ''; 
	
    //==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public String categoryforProduct{get;set;}
    //==================================================
    // INSTANCE VARIABLES
    //==================================================
    public String sku;
    //==================================================
    // CONSTRUCTOR
    //==================================================
    public cc_ctrl_JQueryInclude(){
        sku = Apexpages.currentPage().getParameters().get('sku');
        if(cc_util_CloudCraze.productCategory!=null && cc_util_CloudCraze.productCategory!=''&&cc_util_CloudCraze.productCategory.length()>0){
            categoryforProduct=cc_util_CloudCraze.productCategory;
        }
        else{
            categoryforProduct='abc';
        }
    }
    
    /*public void updateCategoryforProduct(){
        List<E_ProductCategory__c> productCategory = [Select p.CategoryID__c 
                                            , p.Product__r.Name
                                       from E_ProductCategory__c p 
                                       where p.Product__r.SKU__c =:sku
                                       limit 1
                                      ];
         if(productCategory!=null && productCategory.size()>0 && productCategory.size()==1){
            categoryforProduct=productCategory[0].CategoryID__c;
         }
         else{
            categoryforProduct='';
         }
        
    }*/

	//IL - Use for UI Custom Setting
	public static String ovValue {get;set;}	// need to be deleted.
	public static String ccStyle { get { return cc_util_UserInterface.getccStyle();}}	        
 	public static String getccStaticResourceLogo() { return cc_util_UserInterface.getSRHeaderLogo();}	
 	public static String getccStaticResourceTaggLine() { return cc_util_UserInterface.getSRHeaderTagLine();}	
  	public static String getccTransactionLog() { return cc_util_UserInterface.getTransactionLog();}
	//IL - Use for UI Custom Setting

}