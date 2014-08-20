/**
 * @author serge kandukuri
 */

public with sharing class  KapConnectionWS {
    
     
   Kaplan_Custom_Config__c kap_config = Kaplan_Custom_Config__c.getValues('Kaplan Custom Config');
    //kapengine username and password and endpoint
    String usernameke = kap_config.KapEngineUsername__c; 
    String passwordke = kap_config.kapEnginePassword__c;
    String Endpointke = kap_config.KapEngineEndpoint__c;
    // kaptest username password and endpoint
    String usernamekp = kap_config.KaptestUsername__c; 
    String passwordkp = kap_config.kaptestPassword__c;
    String Endpointkp = kap_config.KaptestEndpoint__c;
    
    // rtcap username password and endpoint
    String usernameRtcap = kap_config.RTCAPUsername__c; 
    String passwordRtcap = kap_config.RTCAPPassword__c;
    String EndpointRtcap = kap_config.RTCAPEndpoint__c;    
    // get real username password and endpoint
    
    String usernamegr = kap_config.GetrealUsername__c;
    String passwordgr = kap_config.GetrealPassword__c;
    String endpointgr = kap_config.GetrealEndpoint__c;
    
    // catalog username password and endpoint
    
    String usernamecw = kap_config.catalogUsername__c;
    String passwordcw = kap_config.catalogPassword__c;
    String endpointcw = kap_config.catalogEndpoint__c;
    
     
    public KapXmlResponseWS connection (String endpoint,String username,String password,String requestMethod) 
    {           
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint(Endpointke);
            req.setHeader('X-If-No-Redirect', '1' );    
            req.setMethod(requestMethod);
            //if(content!=null){req.setBody(content);}
            Blob headerValue = Blob.valueOf(usernameke + ':' + passwordke);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader);
            req.setMethod(requestMethod);   
            req.setEndpoint(endPoint);
            httpResponse response = null;
            KapXmlResponseWS kapXmlResponse;
                    try 
                    {
                        System.debug('HttpRequest :' +req);
                        Http http = new Http();
                        response = http.send(req);
                        System.debug('STATUS:'+ response.getStatusCode() );
                        
                        System.debug('STATUS:'+ response.getStatus() );
                        System.debug('STATUS_CODE:'+ response.getStatusCode() );
                        System.debug('BODY: '+ response.getBody() );
                            
                        kapXmlResponse = new KapXmlResponseWS();
                        String responseMessage;
                        Integer statusCode;       
                        responseMessage = response.getBody();
                        statusCode=response.getStatusCode();
                        kapXmlResponse.xmlBody = response.getBody();
                        kapXmlResponse.statusCode = response.getStatusCode();       
                        
                        
                         
                    }   
                    catch( System.Exception e) 
                    {
                        System.debug('Error sending request');
                        System.debug('ERROR: '+ e);
                     
                    }
         return kapXmlResponse; 
    }
    
    public KapXmlResponseWS connectionPasswordReset (String endpoint,String username,String password,String requestMethod,String requestBody) 
    {           
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint(Endpointkp);
            req.setHeader('X-If-No-Redirect', '1' );    
            //req.setHeader('content-type', 'application/xml');
            req.setHeader('content-type', 'application/x-www-form-urlencoded');
            req.setMethod(requestMethod);
           
            Blob headerValue = Blob.valueOf(usernamekp + ':' + passwordkp);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader);
            req.setMethod(requestMethod);   
            req.setBody(requestBody);
            httpResponse response = null;
            KapXmlResponseWS kapXmlResponse;
                    try 
                    {
                        System.debug('HttpRequest :' +req);
                        Http http = new Http();
                        response = http.send(req);
                        System.debug('STATUS:'+ response.getStatusCode() );
                        
                        System.debug('STATUS:'+ response.getStatus() );
                        System.debug('STATUS_CODE:'+ response.getStatusCode() );
                        System.debug('BODY: '+ response.getBody() );
                            
                        kapXmlResponse = new KapXmlResponseWS();
                        String responseMessage;
                        Integer statusCode;       
                        responseMessage = response.getBody();
                        statusCode=response.getStatusCode();
                        kapXmlResponse.xmlBody = response.getBody();
                        kapXmlResponse.statusCode = response.getStatusCode();       
                        
                        
                         
                    }   
                    catch( System.Exception e) 
                    {
                        System.debug('Error sending request');
                        System.debug('ERROR: '+ e);
                     
                    }
         return kapXmlResponse; 
    }
    
     public KapXmlResponseWS connectionOnlineExtension (String endpoint,String username,String password,String requestMethod,String requestBody) 
    {           
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpointcw);
            req.setHeader('X-If-No-Redirect', '1' );    
            req.setHeader('content-type', 'application/xml');
            req.setMethod(requestMethod);
           
            Blob headerValue = Blob.valueOf(usernamecw + ':' + passwordcw);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader);
            req.setMethod(requestMethod);   
            req.setTimeout(60000);
            req.setBody(requestBody);
            httpResponse response = null;
            
                       
                        System.debug('BODY before: '+ req.getBody() );
            
            KapXmlResponseWS kapXmlResponse;
                    try 
                    {
                        System.debug('HttpRequest :' +req);
                        Http http = new Http();
                        response = http.send(req);
                        System.debug('STATUS:'+ response.getStatusCode() );
                        
                        System.debug('STATUS:'+ response.getStatus() );
                        System.debug('STATUS_CODE:'+ response.getStatusCode() );
                        System.debug('BODY: '+ response.getBody() );
                            
                        kapXmlResponse = new KapXmlResponseWS();
                        String responseMessage;
                        Integer statusCode;       
                        responseMessage = response.getBody();
                        statusCode=response.getStatusCode();
                        kapXmlResponse.xmlBody = response.getBody();
                        kapXmlResponse.statusCode = response.getStatusCode();       
                        
                        
                         
                    }   
                    catch( System.Exception e) 
                    {
                        System.debug('Error sending request');
                        System.debug('ERROR: '+ e);
                     
                    }
         return kapXmlResponse; 
    }
    
     public KapXmlResponseWS connectionGetReal (String endpoint,String username,String password,String requestMethod,String requestBody) 
    {           
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpointgr);
            req.setHeader('X-If-No-Redirect', '1' );    
          //  req.setHeader('content-type', 'application/x-www-form-urlencoded');
            req.setMethod(requestMethod);
           system.debug('webservice has been called ');
            Blob headerValue = Blob.valueOf(usernamegr + ':' + passwordgr);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader);
            req.setMethod(requestMethod);   
            req.setBody(requestBody);
            
            req.setHeader('content-type', 'application/xml');
            req.setTimeout(120000);
            
            httpResponse response = null;
            KapXmlResponseWS kapXmlResponse;
                    try 
                    {
                        System.debug('HttpRequest :' +req);
                        Http http = new Http();
                        response = http.send(req);
                        System.debug('STATUS:'+ response.getStatusCode() );
                        
                        System.debug('STATUS:'+ response.getStatus() );
                        System.debug('STATUS_CODE:'+ response.getStatusCode() );
                        System.debug('BODY: '+ response.getBody() );
                            
                        kapXmlResponse = new KapXmlResponseWS();
                        String responseMessage;
                        Integer statusCode;       
                        responseMessage = response.getBody();
                        statusCode=response.getStatusCode();
                        kapXmlResponse.xmlBody = response.getBody();
                        kapXmlResponse.statusCode = response.getStatusCode();       
                        
                        
                         
                    }   
                    catch( System.Exception e) 
                    {
                        System.debug('Error sending request');
                        System.debug('ERROR: '+ e);
                     
                    }
         return kapXmlResponse; 
    }
     
     public KapXmlResponseWS connectionRTCAP (String orderItemId) 
    {           
            String requestBody = 'xmlreqdoc=<?xml version="1.0" encoding="UTF-8" standalone="yes"?><ns2:kaplan_event_msg xmlns:ns2="http://www.kaptest.com/schema/1.0/kaplan_platform_event"><ns2:abstract_event xsi:type="ns2:evt_type_enrollment" evt_sys_name="40" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><enrollment code="' + orderItemId+ '" id="' + orderItemId+ '"><callback>N/A callbackUrl</callback></enrollment><balance_due>0</balance_due></ns2:abstract_event></ns2:kaplan_event_msg>';
            System.debug('HttpRequest :' +requestBody);
            HttpRequest req = new HttpRequest();
            req.setEndpoint(EndpointRtcap + EncodingUtil.urlEncode(requestBody, 'UTF-8'));
            req.setHeader('X-If-No-Redirect', '1' );    
            req.setHeader('content-type', 'application/x-www-form-urlencoded');
            req.setMethod('POST');
           system.debug('webservice has been called ');
            Blob headerValue = Blob.valueOf(usernameRtcap + ':' + passwordRtcap);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader);
            req.setBody(requestBody);
            
            //req.setHeader('content-type', 'application/xml');
            req.setTimeout(60000);
            
            httpResponse response = null;
            KapXmlResponseWS kapXmlResponse;
                    try 
                    {
                        System.debug('HttpRequest :' +req);
                        Http http = new Http();
                        response = http.send(req);
                        System.debug('STATUS:'+ response.getStatusCode() );
                        
                        System.debug('STATUS:'+ response.getStatus() );
                        System.debug('STATUS_CODE:'+ response.getStatusCode() );
                        System.debug('BODY: '+ response.getBody() );
                            
                        kapXmlResponse = new KapXmlResponseWS();
                        String responseMessage;
                        Integer statusCode;       
                        responseMessage = response.getBody();
                        statusCode=response.getStatusCode();
                        kapXmlResponse.xmlBody = response.getBody();
                        kapXmlResponse.statusCode = response.getStatusCode();       
                        
                        
                         
                    }   
                    catch( System.Exception e) 
                    {
                        System.debug('Error sending request');
                        System.debug('ERROR: '+ e);
                     
                    }
         return kapXmlResponse; 
    }   
        
    

}