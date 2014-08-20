//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_excn_DuplicateRootCategoryException extends Exception {
	 static testMethod void myUnitTest() {
	 	try {
	 		throw new cc_excn_DuplicateRootCategoryException('Test Exception');	 	
	 		system.assert(false);	
	 	} catch(Exception e) {}
	 }
}