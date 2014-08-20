//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_hlpr_StackNode {
	//==================================================
    // INSTANCE VARIABLES
    //==================================================
    private String categoryName;
    private String sequence;
    private String categoryID;    
    private String parent;
    private String locale;
    private boolean visitedFlag;
    private String defaultLocaleCategoryName;
    //==================================================
    // HELPER METHODS
    //==================================================
    
    /*
     * public getter methods for the private entitites
     */
     
    public String getCategoryName(){
    	return categoryName;
    }
    
    public String getCategoryID(){
    	return categoryID;
    }
    
    public String getSequence(){
    	return sequence;
    }
    
    public boolean isVisited(){
    	return visitedFlag;
    } 
    
    public String getParent(){
    	return parent;
    }
    
    public String getLocale(){
    	return locale;
    }
    
    public String getDefaultLocaleCategoryName(){
    	return defaultLocaleCategoryName;
    }
    
    /*
     * public setter methods for the private entitites
     */
    
    public void setCategoryName(String catName){
    	categoryName=catName;
    }
    
    public void setSequence(String seq){
    	sequence=seq;
    }
    public void setVisted(boolean visited){
    	visitedFlag=visited;
    }
    public void setCategoryID(String IDValue){
    	categoryID=IDValue;
    }
    public void setParent(String parentCategory){
    	parent=parentCategory;
    }
    public void setLocale(String localeValue){
    	locale=localeValue;
    }
    
    public void setDefaultLocaleCategoryName(String defaultName){
    	defaultLocaleCategoryName=defaultName;
    }
   
}