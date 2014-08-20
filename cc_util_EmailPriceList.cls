//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
global with sharing class cc_util_EmailPriceList implements Messaging.InboundEmailHandler{
	 //==================================================
     // CONSTANTS
     //==================================================
	 global static Integer FILE_CHUNK_ROW_SIZE = 300;
	 global static Integer DML_MAX_ROW_SIZE    = 190;
	 //==================================================
     // SERVICE METHODS
     //================================================== 
	 global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, 
                                                            Messaging.InboundEnvelope env){
     	// Create an inboundEmailResult object for returning the result of the Apex Email Service 
    	Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();                                                  	
     	//CloudCrazeConfiguration config= CloudCrazeConfiguration.getInstance();
     	Messaging.Inboundemail.Binaryattachment xmlAttachment=null;
     	//if(email.Binaryattachments!=null && email.Binaryattachments.size()>0){
     	//	xmlAttachment = email.Binaryattachments.get(0);
     	//} 
     	 
     	//System.debug('***************handleInboundEmail********************');
     	//if(xmlAttachment==null || xmlAttachment.fileName==null){
     	//	result.message	= 'No Attachment or Attachment File Name found!';
     	//	result.success	= false;
     	//	//System.debug('Result : ' + result.success + ' - Message : ' + result.message);
     	//	return result;
     	//}
     	 
     	////System.debug('Attachment Content : ' + xmlAttachment.body.toString());
     	//if(config.EMAIL_FILENAME_SHIPMENT.equalsIgnoreCase(xmlAttachment.fileName)){
     	//	Map<String,EmailAttachmentXMLUtils.CC_Shipment> shipmentList = EmailAttachmentXMLUtils.parseShipmentXML(xmlAttachment.body.toString());
     	//	result.success = EmailAttachmentXMLUtils.processShipments(shipmentList);
     	//} else if (config.EMAIL_FILENAME_PRODUCT_PRICE.equalsIgnoreCase(xmlattachment.fileName)){
     	/*Messaging.InboundEmail.BinaryAttachment[] bAttachments = email.BinaryAttachments;
        String csvbody='';
     	if(bAttachments !=null){
			for(Messaging.InboundEmail.BinaryAttachment btt :bAttachments){
            	if(btt.filename.endsWith('.csv')){
                 csvbody =  btt.body.toString();
                 
                 //System.debug('Hex : '+EncodingUtil.convertToHex(Blob.valueOf(csvbody)));
                 //System.debug('MIME : ' + btt.mimeTypeSubType);
                 //System.debug('Body : ' + csvbody);
             	 EmailAttachmentXMLUtils.parseProductPriceCSV(csvbody);
        	}
		}
     	}*/
		
		Messaging.InboundEmail.Binaryattachment[] bAttachments = email.Binaryattachments;
		if(bAttachments !=null){
			for(Messaging.InboundEmail.Binaryattachment bt :bAttachments){
            	if(bt.filename!=null && bt.filename.endsWith('.csv')){
                 	String csvbody =  bt.body.toString();
                 	//System.debug('Hex : '+EncodingUtil.convertToHex(Blob.valueOf(csvbody)));
                 	//System.debug('MIME : ' + bt.mimeTypeSubType);
                 	//System.debug('Body : ' + csvbody);
             	    processCSV(csvBody,0);
             	}
        	}
		}
		
		/*
		Messaging.InboundEmail.Textattachment[] tAttachments = email.textAttachments;
		if(tAttachments !=null){
			for(Messaging.InboundEmail.Textattachment tt :tAttachments){
            	if(tt.filename!=null && tt.filename.endsWith('.txt')){
                 	String csvbody =  tt.body;
                 	//System.debug('Hex : '+EncodingUtil.convertToHex(Blob.valueOf(csvbody)));
                 	//System.debug('MIME : ' + tt.mimeTypeSubType);
                 	//System.debug('Body : ' + csvbody);
             	    processCSV(csvBody,0);
             	}
        	}
		}*/
     	
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
       		cc_util_EmailPriceList.parseProductPriceCSV(body);
       		//System.debug('Recursive Call processCSV');
       		processCSV(splitted.get(splitted.size()-1), recursionDepth+1);
       	} else {
       		body += splitted.get(splitted.size()-1);
       		//System.debug('Body : ' + body + ' recursionDepth : ' + recursionDepth);
       		//System.debug('Call parseProductPriceCSV');
       		cc_util_EmailPriceList.parseProductPriceCSV(body);
       	}
     }
    
     
     @future
	global static void parseProductPriceCSV(String csvBody){
		//csvBody = filterUnicode(csvBody);
		//System.debug('parseProductPriceCSV :' + csvBody);
		Map<String,CC_ProductPrice> priceMap = new Map<String,CC_ProductPrice>(); 
		List<String> csvLines = csvBody.split('\n',0);
		//System.debug('csvLines :' + csvLines.size());
		//Integer lineIndex=0;
		for(String line:csvLines){
			List<String> attributes = line.split('\t',0);
			//System.debug('Attribute Size :' + attributes.size());
			if(attributes!=null && (attributes.size()==5 || attributes.size()==4) ){
				CC_ProductPrice price = new CC_ProductPrice();
				price.partNo = attributes.get(0);
				price.description = attributes.get(1);
				price.description2 = (attributes.size()==5?attributes.get(2):'');
				price.zUSPrice = (attributes.size()==5?Decimal.valueOf(attributes.get(3)):Decimal.valueOf(attributes.get(2)));
				price.productCode =attributes.get(0);//(attributes.size()==5?attributes.get(4):attributes.get(3));//.substring(0,attributes.get(4).length()-1);
				if(al.StringUtils.isNotEmpty(price.productCode)){
					priceMap.put(price.productCode,price);
				}
			}// else {
			//	throw new al.IllegalArgumentException('Attribute size : ' +attributes.size());
			//}
			//lineIndex++;
		}
		//System.debug('PriceMap size:' + priceMap.size());
		//return priceMap;
		cc_util_EmailPriceList.processPrices(priceMap);
	}
	
	private static Messaging.InboundEmailResult processPrices(Map<String,CC_ProductPrice> productPrices){
		Savepoint sp=Database.setSavepoint();
		//System.debug('*******************EmailAttachmentXMLUtils.processPrices*******************');
		Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();  
		try{
			Integer insertProductCount=0;
			Integer insertPriceCount=0;
			Integer updateCount=0;
			List<String> productCodeList = new List<String>();
			for(String key:productPrices.keySet()){
				productCodeList.add(key);
			}
			List<E_PriceList__c> priceLists=[Select e.SupplierKey__c, e.PricelistId__c, 
													e.Id, e.Enabled__c 
											 From E_PriceList__c e 
											 Where e.Name='Enterprise'];
			
			String priceListId = priceLists[0].Id;
			//System.debug('Product Price Keyset size : ' + productCodeList);
			for(String key : productCodeList){
				//System.debug('Key :' + key);
			}
			
			
			List<E_Product__c> existingProducts = new List<E_Product__c>();
			if(productCodeList.size()>0){
				String existingProductQuery = ' Select Id,Product__c,SKU__c,Name ' + 
											  ' From E_Product__c ' + 
											  ' Where Product__c = \''+ productCodeList.get(0) +'\' ';
				if(productCodeList.size()>1){
					for(Integer i=1;i<productCodeList.size();i++){
						existingProductQuery += ' OR Product__c = \''+ productCodeList.get(i) +'\'';
					}
				}
				//System.debug('Existing Product Query :' +existingProductQuery);
				existingProducts= Database.query(existingProductQuery);						
			}
			  
			
			//List<E_Product__c> existingProducts= [Select Id,Product__c,SKU__c,Name 
			//									  From E_Product__c 
			//									  Where Product__c in :productCodeList];
						
			Map<String,E_Product__c> existingProductMap = new Map<String,E_Product__c>();
			for(E_Product__c existingProd:existingProducts){
				existingProductMap.put(existingProd.ProductId__c, existingProd);
			}
			
			Map<String,E_Product__c> productMap = new Map<String,E_Product__c>();
			for(String key:productPrices.keySet()){	
				if(!existingProductMap.containsKey(key)){
					CC_ProductPrice price = productPrices.get(key);
					E_Product__c prod = new E_Product__c();
					prod.ProductId__c	= price.productCode;
					prod.SKU__c			= price.productCode;
					prod.Name			= price.description;
					prod.ShortDesc__c	= price.description;
					prod.LongDesc__c	= price.description2;
					productMap.put(price.productCode,prod);
				}
			}
			List<E_Product__c> tempProdList = new List<E_Product__c>();
			List<E_PriceListItem__c> tempPriceListItems = new List<E_PriceListItem__c>();
			for(E_Product__c prod:productMap.values()){
				if(tempProdList.size()>=DML_MAX_ROW_SIZE){
					insert tempProdList;
					insertProductCount += tempProdList.size();
					for(E_Product__c insProd:tempProdList){
						E_PriceListItem__c priceListItem = new E_PriceListItem__c();
						priceListItem.Product__c 	 = insProd.Id;
						priceListItem.Pricelist__c = priceListId;
						priceListItem.Price__c		 = productPrices.get(prod.ProductId__c).zUSPrice;
						tempPriceListItems.add(priceListItem);
					}
					insert tempPriceListItems;
					insertPriceCount += tempPriceListItems.size();
					tempPriceListItems.clear();
					tempProdList.clear();
				}
				if(!existingProductMap.containsKey(prod.ProductId__c)){
					tempProdList.add(prod);
				}		
			}
			//System.debug('tempProdList Size :' + tempProdList.size());
			if(tempProdList.size()>0){
				insert tempProdList;
				insertProductCount += tempProdList.size();
				//System.debug('tempProdList inserted! Size :' + tempProdList.size());
			}

			
			
			List<E_PriceListItem__c> priceListItems =[Select e.Product__r.SKU__c, e.Product__r.ProductId__c, 
												 			e.Product__r.Name, e.Product__r.Id, e.Product__c, 
												 			e.Price__c, e.PriceListItemID__c, 
												 			e.Pricelist__c, e.Name, e.Id 
										  			  From E_PriceListItem__c e
										  			  Where e.Product__r.ProductId__c in :productPrices.keySet()];
			Map<String,E_PriceListItem__c> existingPriceMap = new Map<String,E_PriceListItem__c>();
			for(E_PriceListItem__c item:priceListItems){
				existingPriceMap.put(item.Product__r.ProductId__c,item);
			}
			
			for(String key:productPrices.keySet()){	
				if(existingProductMap.containsKey(key) && 
				   !existingPriceMap.containsKey(key)){
					E_PriceListItem__c priceListItem = new E_PriceListItem__c();
					priceListItem.Product__c 	 = existingProductMap.get(key).Id;
					priceListItem.Pricelist__c = priceListId;
					priceListItem.Price__c		 = productPrices.get(key).zUSPrice;
					tempPriceListItems.add(priceListItem);
				}
			}
			if(tempPriceListItems.size()>0){
				insert tempPriceListItems;
				insertPriceCount += tempPriceListItems.size();
			}
			for(E_PriceListItem__c priceListItem:priceListItems){
				CC_ProductPrice xmlPrice = productPrices.get(priceListItem.Product__r.ProductId__c);
//				existingProductPrices.put(xmlPrice.productCode,xmlPrice);
				priceListItem.Price__c=xmlPrice.zUSPrice;
			}
			if(priceListItems.size()>0){	
				Database.update(priceListItems);
				updateCount += priceListItems.size();
			}						  							  				
			
			//for(CC_ProductPrice price: productPrices.values()){
			//	if(existingProductPrices.get(price.productCode)==null){
			//		newProductPrices.put(price.productCode,price);
			//	}
			//}
			
			result.success	= true;
			result.message  = 'Result Successful! Insert Price Count:' + insertPriceCount + 
								' - Update Price Count :' + updateCount + 
								' - Insert Product Count :' + insertProductCount;
			return result;
		} catch(Exception exp){
			Database.rollBack(sp);
			//System.debug('EXCEPTION in EmailAttachmentXMLUtils.processPrices');
			//System.debug('EXCEPTION Message : ' + exp.getMessage());
			result.success	= false;
			result.message  = 'EXCEPTION Message : ' + exp.getMessage();
			return result;
		}
	}
	//==================================================
    // INNER CLASS
    //==================================================
    global with sharing class CC_ProductPrice{
    	//==================================================
	    // INSTANCE PROPERTIES
	    //==================================================
		global String partNo 				{get;set;}
		global String description 			{get;set;}
		global String description2 			{get;set;}
		global Decimal zUSPrice				{get;set;}
		global String productCode 			{get;set;}
	} 
}