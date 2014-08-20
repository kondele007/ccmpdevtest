//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
@IsTest
private class cc_util_test_EmailService {
    
    private static testmethod void testWithNoAttachment(){
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        Messaging.InboundEmail.Textattachment inAtt = new Messaging.InboundEmail.Textattachment();
 
        email.subject = 'test';
        env.fromAddress = 'user@acme.com';
        email.Textattachments = new Messaging.inboundEmail.Textattachment[] {inAtt }; 
 
        // call the class and test it with the data in the testMethod
        cc_util_EmailService emailService = new cc_util_EmailService();
        Messaging.InboundEmailResult result =emailService.handleInboundEmail(email, env );
        System.assertEquals(false,result.success);
    }
    
    private static testmethod void testWithNoAttachment2(){
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        Messaging.InboundEmail.Binaryattachment inAtt = new Messaging.InboundEmail.Binaryattachment();

        email.subject = 'test';
        env.fromAddress = 'user@acme.com';
        email.binaryAttachments = new Messaging.inboundEmail.Binaryattachment [] {inAtt }; 

        // call the class and test it with the data in the testMethod
        cc_util_EmailPriceList emailService = new cc_util_EmailPriceList();
        Messaging.InboundEmailResult result =emailService.handleInboundEmail(email, env );
        System.assertEquals(true,result.success);
    } 
    
    private static testmethod void testProductPriceEmail(){
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        Messaging.InboundEmail.Binaryattachment inAtt = new Messaging.InboundEmail.Binaryattachment();

        
        email.subject = 'test';
        env.fromAddress = 'user@acme.com';
        // set the body of the attachment
        String fbody = 'PART_NO DESCRIPTION DESC_2  Z_US_PRICE  PRODUCT_CODE\n';
        for(Integer i=0;i<25;i++){
            if(Math.min(i, 2)==0){
                fbody += 'LI-'+ String.valueOf(6400 + i) +'XTR  FLUORESCENCE AND GAS        42900.00    E100\n';
            } else {
                fbody += 'LI-'+ String.valueOf(6400 + i) +'XTR  FLUORESCENCE AND GAS    EXCHANGE SYSTEM PKG 42900.00    E100\n';
            }
        }
        inAtt.body = Blob.valueOf(fbody);
        inAtt.fileName = 'filename.csv';
        //inAtt.mimeTypeSubType = 'plain/txt';

        email.binaryAttachments = new Messaging.inboundEmail.binaryAttachment[] {inAtt }; 
 
        // call the class and test it with the data in the testMethod
        cc_util_EmailPriceList emailService = new cc_util_EmailPriceList();
        cc_util_EmailPriceList.FILE_CHUNK_ROW_SIZE = 25;
        cc_util_EmailPriceList.DML_MAX_ROW_SIZE    = 5;
        Messaging.InboundEmailResult result =emailService.handleInboundEmail(email, env );
        System.assertEquals(true,result.success);
        
        String fBody2 = 'PART_NO    DESCRIPTION DESC_2  Z_US_PRICE  PRODUCT_CODE\n';
        for(Integer i=0;i<50;i++){
            if(Math.min(i, 2)==0){
                fBody2 += 'LI-'+ String.valueOf(6400 + i) +'XTR FLUORESCENCE AND GAS        42900.00    E100\n';
            } else {
                fBody2 += 'LI-'+ String.valueOf(6400 + i) +'XTR FLUORESCENCE AND GAS    EXCHANGE SYSTEM PKG 42900.00    E100\n';
            }
        }
        
        inAtt.body = Blob.valueOf(fBody2);
        result =emailService.handleInboundEmail(email, env );
        System.assertEquals(true,result.success);
        
    }
     
    
    
    private static testmethod void testShipmentEmail(){
        // Create a new email, envelope object and Attachment
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        Messaging.InboundEmail.Binaryattachment inAtt = new Messaging.InboundEmail.Binaryattachment();

        email.subject = 'test';
        env.fromAddress = 'user@acme.com';
        
        // set the body of the attachment
        String body =   'WEB_ORDER  ID  CARRIER_DESC    Z_BI_SHIP_TRACKNOS  SHIP_DATE\n';
        List<E_Order__c> orders = new List<E_Order__c>();
        
        //Select e.StateCode__c, e.LastName__c, e.FirstName__c, e.Email__c, e.CountryISOCode__c, e.City__c From E_ContactAddr__c e
        List<E_ContactAddr__c> contacts = new List<E_ContactAddr__c>();
        for(Integer i=0;i<50;i++){ 
            contacts.add(new E_ContactAddr__c(StateISOCode__c='GA',AddressFirstline__c='234 5th St', City__c='Atlanta', LastName__c='Contact',FirstName__c='Test',Email__c='test@contact.com'));
        }
        insert contacts;
        for(Integer i=0;i<50;i++){ 
            orders.add(new E_Order__c(OrderID__c=String.valueOf(116197+i), ShipTo__c=contacts[i].Id));
        }
        insert orders;
        List<E_Order__c> insertedOrders=[Select Id, Name from E_Order__c Where Id in :orders order by createdDate LIMIT 100] ;
        for(Integer i=0;i<insertedOrders.size();i++){ 
            //orders.add(new E_Order__c(OrderID__c=String.valueOf(116197+i), ShipTo__c=contacts[i].Id));
            //if(Math.min(i, 2)==0){
                body += insertedOrders[i].Name+'    ' + String.valueOf(116197+i) +' FedEx   248625660209020 2009-09-14T00:00:00\n';
            //} else {
            //  inAtt.body += 'Accounts Payable jamie_rees@brown.edu    Brown University'+ i '  2009-09-14T00:00:00 FEDEX STD OVERNIGHT FedEx   248625660209020 116197  472706253\n';
            //}
        }
        inAtt.body = Blob.valueOf(body);
        //inAtt.body += 'Accounts Payable   jamie_rees'+ 400+ '@brown.edu   Brown University'+ 400 +'   20abcd00    FEDEX STD OVERNIGHT FedEx   248625660209020 '+ String.valueOf(116197+400)+ '    '+ String.valueOf(472706253+400)+'\n';
        
        //              +'Accounts Payable  jamie_rees@brown.edu    Brown University    2009-09-14T00:00:00 FEDEX STD OVERNIGHT FedEx   248625660209020 116197  472706253\n'
        //              +'Accounts Payable  jam_re@brown.edu    Byron University    2009-09-15T00:00:00 FEDEX STD OVERNIGHT FedEx   248625660209021 116198  472706254\n';
        inAtt.fileName = 'filename.csv';
        inAtt.mimeTypeSubType = 'plain/txt';

        email.binaryAttachments = new Messaging.inboundEmail.binaryAttachment[] {inAtt };  
 
        // call the class and test it with the data in the testMethod
        cc_util_EmailService emailService = new cc_util_EmailService();
        cc_util_EmailService.FILE_CHUNK_ROW_SIZE = 25;
        cc_util_EmailService.DML_MAX_ROW_SIZE    = 5;
        Messaging.InboundEmailResult result =emailService.handleInboundEmail(email, env );
        System.assertEquals(true,result.success);
    }
    //processShipments
    
    private static testmethod void testProcessShipments(){
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        Messaging.InboundEmail.Textattachment inAtt = new Messaging.InboundEmail.Textattachment();
 
        email.subject = 'test';
        env.fromAddress = 'user@acme.com';
        email.Textattachments = new Messaging.inboundEmail.Textattachment[] {inAtt }; 
 
        // call the class and test it with the data in the testMethod
        cc_util_EmailService emailService = new cc_util_EmailService();
        Messaging.InboundEmailResult result =emailService.handleInboundEmail(email, env );
        System.assertEquals(false,result.success);
    }
    
    
     private static testmethod void testProcessCC_Shipment(){
     	cc_util_EmailService.CC_Shipment ccShip = new cc_util_EmailService.CC_Shipment();
     	ccShip.carrierDesc = 'test';
     	ccShip.contactEmail = 'test@test.com';
     	ccShip.contactName = 'test name';
     	ccShip.description = 'test';
     	ccShip.id='test';
     	ccShip.shipDate = datetime.now();
     	ccShip.shipName='testShipname';
     	ccShip.webOrder = 'testweborder';
     	
     	E_Order__c orderObj = new E_Order__c();
     	orderObj.ShipAmount__c = 20;
    	orderObj.ShippingMethod__c = 'Ground';
    	insert orderObj;
    	
    	Map<String,cc_util_EmailService.CC_Shipment> shipmentMap = new Map<String,cc_util_EmailService.CC_Shipment>();
    	shipmentMap.put(orderObj.Name,ccShip);
    	
     	string csvBody ='test\tBody\ttest\tbody\t'+datetime.now()+'\ntest\tBody\ttest\tbody\t'+datetime.now();
     	cc_util_EmailService.parseShipmentCSV(csvBody);
     	
     	cc_util_EmailService.processShipments(shipmentMap);
     	System.assertNotEquals(null, cc_util_EmailService.getShippedStatusCode());
     	
     }
}