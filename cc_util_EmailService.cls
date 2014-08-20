//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
global with sharing class cc_util_EmailService implements Messaging.InboundEmailHandler{
	//==================================================
     // CONSTANTS
     //==================================================
	 global static Integer FILE_CHUNK_ROW_SIZE = 300;
	 global static Integer DML_MAX_ROW_SIZE    = 190;
	 //==================================================
    // INNER CLASS
    //==================================================
	 global with sharing class CC_Shipment{
	 	//==================================================
	    // INSTANCE PROPERTIES
	    //==================================================
		global String 	contactName 			{get;set;}
		global String 	contactEmail 			{get;set;}
		global String 	shipName				{get;set;}
		global DateTime	shipDate				{get;set;}
		global String 	description				{get;set;}
		global String 	carrierDesc   			{get;set;}
		global String	zBiShipTrackNumbers		{get;set;}
		global String	id						{get;set;}
		global String 	webOrder				{get;set;}
	}
	 //==================================================
     // SERVICE METHODS
     //================================================== 
	 global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, 
                                                            Messaging.InboundEnvelope env){
     	// Create an inboundEmailResult object for returning the result of the Apex Email Service 
    	Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();                                                  	
     	//CloudCrazeConfiguration config= CloudCrazeConfiguration.getInstance();
     	Messaging.Inboundemail.Binaryattachment xmlAttachment=null;
     	if(email.Binaryattachments!=null && email.Binaryattachments.size()>0){
     		xmlAttachment = email.Binaryattachments.get(0);
     	} 
     	
     	//System.debug('***************handleInboundEmail********************');
     	if(xmlAttachment==null || xmlAttachment.fileName==null){
     		result.message	= 'No Attachment or Attachment File Name found!';
     		result.success	= false;
     		//System.debug('Result : ' + result.success + ' - Message : ' + result.message);
     		return result;
     	}
     	 
     	Messaging.InboundEmail.Binaryattachment[] bAttachments = email.binaryAttachments;
		if(bAttachments !=null){
			for(Messaging.InboundEmail.Binaryattachment tt :bAttachments){
            	if(tt.filename!=null && tt.filename.endsWith('.csv')){
                 	String csvbody =  tt.body.toString();
                 	//System.debug('Hex : '+EncodingUtil.convertToHex(Blob.valueOf(csvbody)));
                 	//System.debug('MIME : ' + tt.mimeTypeSubType);
                 	//System.debug('Body : ' + csvbody);
             	    processCSV(csvBody,0);
             	}
        	}
		} 
     	
		 // Return the result for the Apex Email Service  
    	//System.debug('Result : ' + result.success + ' - Message : ' + result.message);
    	return result;
 	
     }
     
     //==================================================
     // HELPER METHODS
     //==================================================
     private void processCSV(String csvBody, Integer recursionDepth){
     	List<String> splitted = csvBody.split('\n', FILE_CHUNK_ROW_SIZE);
     	List<String> splittedLast  =  splitted.get(splitted.size()-1).split('\n',FILE_CHUNK_ROW_SIZE);
        String body = '';
       	//al.StringUtils.joinStrings(strings, separator)
       	for(Integer i=(recursionDepth==0?1:0);i<splitted.size()-1;i++){
       		body += splitted[i] + '\n';
       	}
       	//System.debug('Last : ' + splitted.get(splitted.size()-1));
       	if(splittedLast.size()>1){
       		//System.debug('Body : ' + body + ' recursionDepth : ' + recursionDepth);
       		//System.debug('Call parseProductPriceCSV');
       		cc_util_EmailService.parseShipmentCSV(body);
       		//System.debug('Recursive Call processCSV');
       		processCSV(splitted.get(splitted.size()-1), recursionDepth+1);
       	} else {
       		body += splitted.get(splitted.size()-1);
       		//System.debug('Body : ' + body + ' recursionDepth : ' + recursionDepth);
       		//System.debug('Call parseProductPriceCSV');
       		cc_util_EmailService.parseShipmentCSV(body);
       	}
     }
     
    // @future
     global static void parseShipmentCSV(String csvBody){

		//System.debug('parseShipmentCSV :' + csvBody);
		Map<String,CC_Shipment> shipmentMap = new Map<String,CC_Shipment>(); 
		List<String> csvLines = csvBody.split('\n',0);
		for(String line:csvLines){
			List<String> attributes = line.split('\t',0);
			//System.debug('Attribute Size :' + attributes.size());
			if(attributes!=null && attributes.size()==5){
				CC_Shipment shipment = new CC_Shipment();
				//shipment.contactName = attributes.get(0);
				//shipment.contactEmail = attributes.get(1);
				//shipment.shipName = attributes.get(2);
				shipment.shipDate = parseDateTimeString(attributes.get(4));
				//shipment.description = attributes.get(4);
				shipment.carrierDesc = attributes.get(2);
				shipment.zBiShipTrackNumbers = attributes.get(3);
				shipment.id = attributes.get(1);
				shipment.webOrder = attributes.get(0);
				if(al.StringUtils.isNotEmpty(shipment.webOrder)){
					shipmentMap.put(shipment.webOrder,shipment);
				}
			}
		}
		cc_util_EmailService.processShipments(shipmentMap);
	//	return shipmentMap;
	}
     
     global static DateTime parseDateTimeString(String dateTimeStr){
		//2009-09-15T00:00:00
		try{
			return DateTime.valueOf(al.StringUtils.replace(dateTimeStr, 'T', ' '));
		}catch(Exception exp){
			return null;
		}
	}
	
	global static void processShipments(Map<String,CC_Shipment> shipmentMap){
		
		Savepoint sp=Database.setSavepoint();
		try{
			Integer insertCount=0;
			Integer updateCount=0;
			List<List<E_Order__c>> updateList=new List<List<E_Order__c>>();
			List<E_Order__c> tempList = new List<E_Order__c>();
			Map<String,E_ContactAddr__c> newContactMap = new Map<String,E_ContactAddr__c>();
			//String shippedCodeId = cc_util_EmailService.getShippedStatusCode();
			List<E_Order__c> existingOrders = [Select e.ShipTo__r.Email__c,  
													  e.ShipTo__r.ContactAddrID__c, e.ShipTo__c, 
													  e.ShipDate__c, e.OrderNumber__c, 
													  e.OrderID__c, e.OrderDate__c, e.Name, e.Id,
													  e.ExtShipTrackNo__c, e.ExtShipTo__c, e.ExtCarrier__c
										  	  From E_Order__c e
										  	  Where Name in :shipmentMap.keySet()];
			//System.debug('Keyset : ' + shipmentMap.keySet());
			//System.debug('Shipment Map : ' + shipmentMap);
			//System.debug('OrderList Size : ' + existingOrders.size());
			//System.debug('OrderList : ' + existingOrders);
			for(Integer i=0;i<existingOrders.size();i++){
				 //System.debug('Inside for loop index :' + i);
				 E_Order__c order = existingOrders[i];
					//order.OrderProductStatus__c = shippedCodeId;
					order.OrderStatus__c=cc_cnst_PickListConstants.ORDERSTATUS_COMPLETED;
					 //System.debug('Order Name :' + order.Name);
					CC_Shipment shipmentNode = shipmentMap.get(order.Name);
					//System.debug('ShipmentNode :' + shipmentNode);
						order.ExtShipTrackNo__c = shipmentNode.zBiShipTrackNumbers;
						order.ShipDate__c		= shipmentNode.shipDate.date();
						order.ExtCarrier__c		= shipmentNode.carrierDesc;
						order.OrderID__c		= shipmentNode.id;
						
						if(tempList.size()<DML_MAX_ROW_SIZE){
							tempList.add(order);
						} else {
							updateList.add(tempList);
							tempList = new List<E_Order__c>();
						}
				}						
			if(templist.size()>0){
				updateList.add(templist);
			}
			//System.debug('Update List :' + updateList);
			for(List<E_Order__c> orders: updateList){
				//System.debug('Update Order List :' + orders);
				if(orders.size()>0){
					update orders;
				}
				
				//updateCount += orderList.size();
			}

		} catch(Exception exp){
			Database.rollBack(sp);
			//System.debug('EXCEPTION in EmailAttachmentXMLUtils.processShipments');
			//System.debug('EXCEPTION Message : ' + exp.getMessage());
		}
	}
	
	
	// Learn about ship status code and change the query based on that
	global static String getShippedStatusCode(){
		/*
		List<E_Code__c> codes= [Select e.Name, e.Id, e.Code__c, e.CodeType__c, e.CodeID__c 
		 						From E_Code__c e 
		 						Where CodeType__c='OrderStatus' and Decode__c='Completed'];
		if(codes.size()>0){
			return codes[0].Id;
		} else {
			return null;
		}
		*/
		return cc_cnst_PickListConstants.ORDERSTATUS_COMPLETED;
	}
}