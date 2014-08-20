//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_ctrl_IEIncludes {
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public String ie7StartBlock {
        get {
            return '<!--[if IE 7]>';
        }
    }
    public String ie7EndBlock {
        get {
            return '<![endif]-->';
        }
    }
    
    public String obtainIE7StartBlock(){
    	return ie7StartBlock;    	
    }
    
    public String obtainIE7EndBlock(){
    	return ie7EndBlock;    	
    }
    
    //==================================================
    // CONSTRUCTOR
    //==================================================
    public cc_ctrl_IEIncludes() {}
}