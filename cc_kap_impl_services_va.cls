/*
* This is the implementation of the integration to Kaplan's service code. 
* This should be the only file where Kaplan services code is referenced.
* The services api should be the only CloudCraze file referencing this impl.
* All CloudCraze requests should use the services api.
*/

public with sharing class cc_kap_impl_services_va {
    
    /*
    * This is the method to send user information to Kaplan when a new user registers/updates on CloudCraze
    * NOTE: For this phase, this method should not be used as there is no CloudCraze registration or My Account
    */
    public static void callKaplanStudentUpdateProfile(String userId){
    }
    
    /*
    * This is the method to send order & user information to Kaplan when a user places an order
    */
    public static void callKaplanStudentPlaceOrder(Id orderId){
        callKaplanStudentPlaceOrder(orderId, true,true);
    }
    public static void callKaplanStudentPlaceOrderGetRealOnly(Id orderId){
        callKaplanStudentPlaceOrder(orderId, true,false);
    }
    public static void callKaplanStudentPlaceOrderRTCAPOnly(Id orderId){
        callKaplanStudentPlaceOrder(orderId, false,true);
    }
    public static void callKaplanStudentPlaceOrderListRTCAPOnly(String orderIds){
        List<String> orderIdList = orderIds.split(',');
        for(String orderId : orderIdList){
            callKaplanStudentPlaceOrder(orderId, false,true);
        }
    }
    public static void callKaplanStudentPlaceOrderList(String orderIds){
        List<String> orderIdList = orderIds.split(',');
        for(String orderId : orderIdList){
            callKaplanStudentPlaceOrder(orderId, true,true);
        }
    }
    public static void callKaplanStudentPlaceOrderGetRealOnly(String orderIds){
        List<String> orderIdList = orderIds.split(',');
        for(String orderId : orderIdList){
            callKaplanStudentPlaceOrder(orderId, true,false);
        }
    }   
    public static void callKaplanStudentPlaceOrder(Id orderId, boolean doGetRealCall, boolean doRTCAPCall){
        System.Debug(LoggingLevel.INFO,'callKaplanStudentPlaceOrder ');
        System.Debug(LoggingLevel.INFO,'orderId ' +orderId);
        KapGetRealPersonVO personVO = null;
        cc_kap_hlpr_GetRealVOPopulater_va kapVOHelper = null;
        cc_kap_bean_GetRealResponseBean getRealResponseBean = null;
        Boolean saveGetRealOrderPlaceError = false;
        List<E_OrderItem__c> itemsToUpdate = new List<E_OrderItem__c>();
       
        KapXmlResponseWS xmlErrorResponse = null;
        try{
            kapVOHelper = new cc_kap_hlpr_GetRealVOPopulater_va(orderId);
            System.Debug(LoggingLevel.INFO,'kapVOHelper' +kapVOHelper);
            personVO = kapVOHelper.personVO;
            System.Debug(LoggingLevel.INFO,'callKaplanStudentPlaceOrder -> personVO' +personVO);
        }catch(Exception e){
            System.Debug(LoggingLevel.INFO,'callKaplanStudentPlaceOrder Error' +e.getmessage());
            System.debug(e);
            saveGetRealOrderPlaceError = true;
        }
        
        /*
        * Most of below code is copied, refactored, and slighty modifed from KapSendToGetRealBatch
        */
        
        if(personVO != null && doGetRealCall){
            String xmlRequest;
            KapXmlResponseWS xmlResponse;
            KapGetRealWS getRealWSStub;
            Boolean bMessageGenerated = false;
            Boolean bGetRealMessageSent = false;
            
            try {
                xmlRequest = KapGetRealUtil.createCloudCrazeOrderPlaceMessage(personVO);
                xmlRequest = xmlRequest.replaceAll('><','>\n<');
                
                System.Debug('***************************************');
                System.Debug(LoggingLevel.INFO,'In CloudCraze implementation of GetReal Request : '+xmlRequest);
                System.Debug('***************************************');
                
                bMessageGenerated = true;
            } catch (Exception e) {
                System.debug(e);
                saveGetRealOrderPlaceError = true;
            }
                
            if (bMessageGenerated && !Test.isRunningTest()) {
                try {
                    getRealWSStub = new KapGetRealWS();
                    xmlResponse = getRealWSStub.StudentProfileUpdate(xmlRequest);
                    bGetRealMessageSent = true;           
                    System.Debug('***************************************');
                    System.Debug(LoggingLevel.INFO,'CloudCraze -> GetReal Reques : '+xmlRequest);
                    System.Debug(LoggingLevel.INFO,'CloudCraze <- GetReal Response : '+xmlResponse);
                    System.Debug('***************************************');
                    getRealResponseBean = cc_kap_impl_services_va.handleGetRealResponse(xmlResponse);
                    if((getRealResponseBean.responseStatusCode != 200) || !((getRealResponseBean.resultStatusCode == KapConstants.KAP_GETREAL_RESP_CODE_PROCESSED) || (getRealResponseBean.resultStatusCode == KapConstants.KAP_GETREAL_RESP_CODE_DUPLICATE_STUDENT)) ){
                        System.debug(LoggingLevel.INFO,'-------------Received error response from GetReal--------------');
                        xmlErrorResponse = xmlResponse;
                        saveGetRealOrderPlaceError = true;
                    }
                    else{ //success condition: save Student ids
                         
                       
                       
                      //success condition: save enrollment ids
                        Map<String, String> enrollmentIds = getRealResponseBean.enrollmentIds;
                        for(KapGetRealCCOrderItemVO itemVO : personVO.cloudCrazeOrder.itemList)
                        {
                            String enrollmentId = enrollmentIds.get(itemVO.client_sys_id);
                            itemVO.ccItemBean.dataObject.EnrollmentId__c = enrollmentId;
                            itemsToUpdate.add(itemVO.ccItemBean.dataObject);
                        }
                        //JLL 1/7/2013 - we now record all orders like a log. Reports will filter on them.
                        saveGetRealOrderPlaceError = true;
                        
                          
                      //  Account Acnt = new Account();
                        kapVOHelper.Acct.Student_ID_display__C = getRealResponseBean.StudentId;
                        kapVOHelper.Acct.Student_ID__c =Integer.Valueof(getRealResponseBean.StudentId);
                       System.debug('Id Value in Account is'+kapVOHelper.Acct.Id);
                        System.debug('Modified Student Assignment'+kapVOHelper.Acct.Student_ID__c);
                        
                    }
                } catch (Exception e) {
                    System.debug(e);
                    saveGetRealOrderPlaceError = true;
                }
            }
        }

        //RTCAP separate call
        if(kapVOHelper != null && doRTCAPCall && !Test.isRunningTest()){
            try{
                KapXmlResponseWS kapxml5 = new KapXmlResponseWS();
                KapConnectionWS kapconnectionws = new KapConnectionWS();
                for(cc_bean_MockOrderItem item : kapVOHelper.ccOrderItems){
                    kapxml5 = kapconnectionws.connectionRTCAP(item.dataObject.Id);
                }           
            }
            catch(Exception e){
                System.debug(e);    
            }
        }
        //we do this now after all callouts
        if(saveGetRealOrderPlaceError)
            saveGetRealOrderPlaceError(kapVOHelper, getRealResponseBean, xmlErrorResponse);
        update itemsToUpdate;
        update kapVOHelper.acct;
    }
    
    private static void saveGetRealOrderPlaceError(cc_kap_hlpr_GetRealVOPopulater_va kapVOHelper, cc_kap_bean_GetRealResponseBean responseBean, KapXmlResponseWS xmlErrorResponse){
        if(kapVOHelper != null){
            for(ErrorReportEntry__c errorReport : kapVOHelper.errorReports){
                if(xmlErrorResponse != null)
                    errorReport.Response_XML__c = xmlErrorResponse.toDisplayString();
                errorReport.getRealResponseCode__c = (responseBean != null ? responseBean.responseStatusCode : -1000);
                errorReport.getRealResultCode__c = (responseBean != null ? responseBean.resultStatusCode : '-2000');
            }
            insert kapVOHelper.errorReports;
        }
    }

    private static cc_kap_bean_GetRealResponseBean handleGetRealResponse(KapXmlResponseWS xmlResponse) {
        cc_kap_bean_GetRealResponseBean responseBean = new cc_kap_bean_GetRealResponseBean();
        responseBean.responseStatusCode = xmlResponse.statusCode;
        Map<String, String> enrollments = new Map<String, String>();
        String StuId;
        
        responseBean.enrollmentIds = enrollments;
        
        Dom.Document xmlDoc;
        Dom.XMLNode xmlNode, responseNode, payloadNode, messageResultsNode, messageNode, resultNode, personNode, errorNode, errorNameNode, errorCodeNode, errorDescriptionNode, errorDetailNode, orderNode,itemListNode, orderItemNode;
        
        String errorName, errorCode, errorDescription, errorDetail, resultStatus;
        String nodeName;
        
        String xmlResponseMessage;
        
        xmlResponseMessage = xmlResponse.xmlBody;
        
        xmlDoc = new Dom.Document();
        try {
            xmlDoc.load(xmlResponseMessage);
            xmlNode = xmlDoc.getRootElement(); //Must be <response> node
            nodeName = xmlNode.getName();
        } catch(Exception e) {
            System.debug(e);
        }
        
        if (nodeName == 'response') {
            responseNode = xmlNode;
            
            payloadNode = responseNode.getChildElement('payload', null);
            if (payloadNode != null) {
                messageResultsNode = payloadNode.getChildElement('message_results', null);
                messageNode = messageResultsNode.getChildElement('message', null);
                resultNode = messageNode.getChildElement('result', null);
                personNode = messageNode.getChildElement('person', null);
                String personuid = personNode.getAttributeValue('uid', null);
                StuId=personuid;
                System.debug('Student Id Returned is'+stuId);
                responseBean.StudentId=StuId;
                System.debug('Response of Student Id Returned is'+responseBean.StudentId);
                System.debug(LoggingLevel.INFO, 'personNode - '+personNode);
                try {
                    orderNode = personNode.getChildElement('order', null);
                    itemListNode = orderNode.getChildelement('item_list', null);
                    List<dom.Xmlnode> orderItemList = itemListNode.getChildElements();
                    for(dom.Xmlnode itemNode : orderItemList){
                        String uid = itemNode.getAttributeValue('uid', null);
                        String sysId = itemNode.getAttributeValue('client_sys_id', null);
                        System.debug(LoggingLevel.INFO,'---------------' + sysId + '-------------------' + uid);
                        enrollments.put(sysId, uid);
                    }
                } catch (Exception e) {
                    System.debug(e);
                }
                
                if (resultNode != null) resultStatus = resultNode.getAttributeValue('status', null);
            }
        }
        responseBean.resultStatusCode = resultStatus;
        return responseBean;
    }
}