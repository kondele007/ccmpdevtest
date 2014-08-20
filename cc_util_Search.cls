//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
// 
//
public with sharing class cc_util_Search {
	private String txtReturn = cc_util_logging.SUCCESS;
    private String txStatus = cc_util_logging.SUCCESS;
    private static String CLASSNAME = 'cc_util_Search';
    private static String transactionLog = ''; 
	//==================================================
    // STATIC SERVICE METHODS
    //==================================================
	public static List<List<SObject>> searchObjects(String searchString){
		return searchObjects(searchString, 'All fields', null, null);
	}

	public static List<List<SObject>> searchObjects(String searchString, String returningAttributes){
		return searchObjects(searchString, 'All fields', returningAttributes,null);
	}

	public static List<List<SObject>> searchObjects(String searchString, String searchFields, String returningAttributes){
		return searchObjects(searchString, searchFields, returningAttributes, null);
		
	}

	public static List<List<SObject>> searchObjects(String searchString, String searchFields, String returningAttributes, String whereClause){				
		String methodName = 'searchObjects ';
		String query = 'FIND \'' + String.escapeSingleQuotes(searchString) + '\' IN ' + String.escapeSingleQuotes(searchFields);
		System.debug(LoggingLevel.INFO,'sns: query = ' + query);
		
		if(returningAttributes != null) {
			query += ' RETURNING ' + returningAttributes;
		}
		if(whereClause != null) {
			query += ' WHERE ' + whereClause;
		}
		query += ' LIMIT 200';
		System.debug('sns: query: ' + query);
		transactionLog = cc_util_logging.log(transactionLog, methodName + 'line 35: query = ' + query);
		List<List<SObject>> result = performSearch(query);
		//result = [FIND :searchString IN All fields RETURNING E_Product__c(Id WHERE ProductStatus__c IN ('Released', 'Not Orderable') AND ProductType__c != 'Coupon' AND Storefront__c includes ('DefaultStore')), E_ProductItemI18N__c(Product__c WHERE Product__r.ProductStatus__c IN ('Released', 'Not Orderable') AND Product__r.ProductType__c != 'Coupon' AND locale__c = 'en_US' AND Product__r.Storefront__c includes ('DefaultStore')), E_ProductTab__c(Product__c WHERE Product__r.ProductStatus__c IN ('Released', 'Not Orderable') AND Product__r.ProductType__c != 'Coupon' AND locale__c = 'en_US' AND Product__r.Storefront__c includes ('DefaultStore')), E_ProductSpecIndex__c(Product__c WHERE Product__r.ProductStatus__c IN ('Released', 'Not Orderable') AND Product__r.ProductType__c != 'Coupon' AND Product__r.Storefront__c includes ('DefaultStore')) LIMIT 200];
		cc_util_logging.addToCCLog(CLASSNAME, methodName, '', '', cc_util_logging.SUCCESS, transactionLog);
		return result;
	}

	public static List<List<SObject>> performSearch(String query){
		String methodName = 'performSearch ';
		//System.debug('-----cc_util_Search.performSearch-query : ' + query);		
		List<List<sObject>> searchResults  = new List<List<sObject>>{};
		try
		{	
		for (List<sObject> recordBatch : search.query(query)){
			String logString = '';
			for(sObject so : recordBatch) {
				logString += so.get('Id');
				logString += ';';
			}
			transactionLog = cc_util_logging.log(transactionLog, methodName + 'found ids ' + logString); 
			searchResults.add(recordBatch);
			transactionLog = cc_util_logging.log(transactionLog, methodName + 'line 55: recordBatch = ' + recordBatch);
			//System.debug('---------->' + recordBatch.size());
		}
		} finally {
			cc_util_logging.addToCCLog(CLASSNAME, methodName, '', '', cc_util_logging.SUCCESS, transactionLog);
		}
		return searchResults;
	}

}