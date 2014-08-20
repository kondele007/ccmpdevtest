//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_ctrl_PriceListExtension {
	//==================================================
    // INSTANCE VARIABLES
    //==================================================
	private ApexPages.StandardController controller;
	//==================================================
    // CONSTRUCTOR
    //==================================================
	public cc_ctrl_PriceListExtension(ApexPages.StandardController c){
        this.controller=c;
        
    } 
    //==================================================
    // SERVICE METHODS
    //==================================================
    public PageReference ClonePriceList(){
    	 E_PriceList__c priceList = (E_PriceList__c) controller.getRecord();
    	 cc_dao_PriceList dao = new cc_dao_PriceList();
    	 E_PriceList__c newPriceList = dao.clone(priceList, true);
    	 PageReference home = new PageReference('/' + newPriceList.id);
            home.setRedirect(true);
            return home;
    	 
    } 
}