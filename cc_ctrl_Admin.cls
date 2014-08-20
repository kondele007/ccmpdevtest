//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without
//  modification is PROHIBITED.
//
//
public with sharing class cc_ctrl_Admin {
	
	public static final Map<String,String> tabs = new Map<String,String> {
		'Indexing' => 'cc_admin_Catalog',
		'Themes' => 'cc_admin_Themes'
	};
	
	public static final String TAB_INDEXING = 'Indexing';
	public static final String TAB_THEMES = 'Themes';
	
	public String currentTab {get;set;}
	public String currentPage {get;set;}
	
	public cc_ctrl_Admin() {
		currentTab = ApexPages.currentPage().getParameters().get('t');
		if(currentTab != null) {
			currentPage = tabs.get(currentTab);
		}

		if(currentPage == null) {
			gotoDefaultTab();
		}
	}
	
	public void gotoDefaultTab() {
		currentTab = cc_ctrl_Admin.TAB_INDEXING;
		currentPage = tabs.get(currentTab);
	}
	
	public PageReference gotoTab() {
		System.debug('--- cc_ctrl_Admin.gotoTab: currentTab=' + currentTab);
		currentPage = tabs.get(currentTab);
		System.debug('--- cc_ctrl_Admin.gotoTab: currentPage=' + currentPage);
		if(currentPage == null) {
			gotoDefaultTab();
		}
		return null;
	}
	
}