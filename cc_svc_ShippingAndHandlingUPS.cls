//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
/* ============================================================
 * Handles the request to/response from UPS Web Services
 * 
 * ============================================================
 */
public with sharing class cc_svc_ShippingAndHandlingUPS implements cc_svc_IShippingAndHandling { 
	
    //==================================================
    // INSTANCE PROPERTIES
    //==================================================
	public cc_bean_ShippingOptionsRequest shippingOptionsRequest {get; set;}
    private String storeID {get;set;}
    private E_StorefrontSettings__c storefront {get;set;}
	//==================================================
    // CONSTRUCTOR
    //==================================================
	public cc_svc_ShippingAndHandlingUPS(E_StorefrontSettings__c storefront) {
        this.storefront = storefront;
    }
	
	//==================================================
    // INSTANCE VARIABLES
    //==================================================
	private boolean groundShipFlag = false;
	private boolean overnightAirFlag = false;
	
	//==================================================
    // CONSTANTS
    //==================================================
	private String SHIPPING_COUPON_RULE = 'Shipping';
	
	//==================================================
    // SERVICE METHODS
    //==================================================
		
	public cc_bean_ShippingOptions getShippingAndHandlingRates(cc_bean_ShippingOptionsRequest shippingRequest){
		cc_bean_ShippingOptions shipOptions = new cc_bean_ShippingOptions();
		shippingOptionsRequest = shippingRequest;
		String requestXML = buildRatingServiceSelectionRequestXML();
		System.debug('-----requestXML in cc_svc_ShippingAndHandlingUPS.getShippingAndHandlingRates = ' + requestXML);
		cc_hlpr_XMLDom theXMLDom = sendRequestAndReceiveResponse(requestXML);
		Long startTime = datetime.now().getTime();
		shipOptions = getShippingServiceAndCost(theXMLDom);
		Long endTime = datetime.now().getTime(); 
		Long totalTime = endTime - startTime;	
		//System.debug('-----Time in UPS - Parse XML ----- = ' + totalTime + ' ms');
		//System.debug('-----shipOptions.status in cc_svc_ShippingAndHandlingUPS.getShippingAndHandlingRates = ' + shipOptions.status);
		return shipOptions;
	}	
	//==================================================
    // HELPER METHODS
    //==================================================
	
	// This method visibility is public, for unit testing purposes.
	public String buildRatingServiceSelectionRequestXML() {
		XmlStreamWriter xmlWriter = new XmlStreamWriter();
        	xmlWriter.writeStartDocument(cc_cnst_UPSXMLTag.ENCODINGTYPE, cc_cnst_UPSXMLTag.XMLVERSION);
				buildAccessRequestXML(xmlWriter);
			xmlWriter.writeEndDocument();
			xmlWriter.writeStartDocument(cc_cnst_UPSXMLTag.ENCODINGTYPE, cc_cnst_UPSXMLTag.XMLVERSION);
       			xmlWriter.writeStartElement(null, cc_cnst_UPSXMLTag.RATINGSERVICESELECTIONREQUEST, null);
					buildRequestOptionXML(xmlWriter);
        			buildShipmentRequestXML(xmlWriter);
        		xmlWriter.writeEndElement(); //end rating service selection request        
        	xmlWriter.writeEndDocument();
 			String xmlOutput = xmlWriter.getXmlString();
        xmlWriter.close();
        return xmlOutput;
	} 

	private void buildRequestOptionXML(XmlStreamWriter xmlWriter) {
    	xmlWriter.writeStartElement(null, cc_cnst_UPSXMLTag.REQUEST, null);
       		xmlWriter.writeStartElement(null, cc_cnst_UPSXMLTag.REQUESTACTION, null);
       		xmlWriter.writeCharacters(cc_cnst_UPSXMLTag.REQUESTACTIONVALUE);
        	xmlWriter.writeEndElement(); //end request action
       	    xmlWriter.writeStartElement(null, cc_cnst_UPSXMLTag.REQUESTOPTION, null);
       		xmlWriter.writeCharacters(cc_cnst_UPSXMLTag.REQUESTOPTIONVALUE);
        	xmlWriter.writeEndElement(); //end request option        		
        xmlWriter.writeEndElement(); //end request
	}

	private void buildAccessRequestXML(XmlStreamWriter xmlWriter) {
        xmlWriter.writeStartElement(null, cc_cnst_UPSXMLTag.ACCESSREQUEST, null);
        	xmlWriter.writeAttribute(null, null, cc_cnst_UPSXMLTag.LANGATTRIBUTE, cc_cnst_UPSXMLTag.LANGATTRIBUTEVALUE); 
        	xmlWriter.writeStartElement(null, cc_cnst_UPSXMLTag.ACCESSLICENSENUMBER, null);
        	xmlWriter.writeCharacters(storefront.UPS_License__c);
        	xmlWriter.writeEndElement(); //end access license number
        	xmlWriter.writeStartElement(null, cc_cnst_UPSXMLTag.USERID, null);
        	xmlWriter.writeCharacters(storefront.UPS_Username__c);
        	xmlWriter.writeEndElement(); //end user id
        	xmlWriter.writeStartElement(null, cc_cnst_UPSXMLTag.PASSWORD, null);
        	xmlWriter.writeCharacters(storefront.UPS_Password__c);
        	xmlWriter.writeEndElement(); //end password        	        	
        xmlWriter.writeEndElement(); //end access request
	}
	
	private void buildShipmentRequestXML(XmlStreamWriter xmlWriter) {
    	xmlWriter.writeStartElement(null, cc_cnst_UPSXMLTag.SHIPMENT, null);
       	    xmlWriter.writeStartElement(null, cc_cnst_UPSXMLTag.SHIPPER, null);
				buildAddressXML(xmlWriter, cc_cnst_CloudCraze.SHIPFROM_ZIPCODE, cc_cnst_CloudCraze.SHIPFROM_COUNTRYCODE);
        	xmlWriter.writeEndElement(); //end shipper        		    	
       	    xmlWriter.writeStartElement(null, cc_cnst_UPSXMLTag.SHIPTO, null);
				buildAddressXML(xmlWriter, shippingOptionsRequest.recepientZipCode, shippingOptionsRequest.recepientCountryCode);
        	xmlWriter.writeEndElement(); //end shipto        		
       	    xmlWriter.writeStartElement(null, cc_cnst_UPSXMLTag.SHIPFROM, null);
				buildAddressXML(xmlWriter, cc_cnst_CloudCraze.SHIPFROM_ZIPCODE, cc_cnst_CloudCraze.SHIPFROM_COUNTRYCODE);
        	xmlWriter.writeEndElement(); //end shipfrom        	
        buildPackageXML(xmlWriter);
		xmlWriter.writeEndElement(); //end shipment
	}

	private void buildAddressXML(XmlStreamWriter xmlWriter, String postalCode, String countryCode) {
       	xmlWriter.writeStartElement(null, cc_cnst_UPSXMLTag.ADDRESS, null);
    		xmlWriter.writeStartElement(null, cc_cnst_UPSXMLTag.POSTALCODE, null);
    			xmlWriter.writeCharacters(postalCode);
        	xmlWriter.writeEndElement(); //end postal code
    		xmlWriter.writeStartElement(null, cc_cnst_UPSXMLTag.COUNTRYCODE, null);
    			xmlWriter.writeCharacters(countryCode);
        	xmlWriter.writeEndElement(); //end country code
		xmlWriter.writeEndElement(); //end address        		        		
	}
	
	private void buildPackageXML(XmlStreamWriter xmlWriter) {
		List<cc_bean_ShippingAttributes> shippingAttributesList = shippingOptionsRequest.shippingAttributesList;
		for (cc_bean_ShippingAttributes shipAttributes : shippingAttributesList) {
			if (!groundShipFlag && shipAttributes.groundShippingRequired != null && shipAttributes.groundShippingRequired) {
				groundShipFlag = true;
			}
			if (!overnightAirFlag && shipAttributes.overnightAirRequired != null && shipAttributes.overnightAirRequired) {
				overnightAirFlag = true;
			}				
			if (!overnightAirFlag && ((shipAttributes.dryIceRequired != null && shipAttributes.dryIceRequired) || (shipAttributes.coolerPakRequired != null && shipAttributes.coolerPakRequired))) {
				overnightAirFlag = true;
			}			
       		xmlWriter.writeStartElement(null, cc_cnst_UPSXMLTag.PACKAGETAG, null);
    			xmlWriter.writeStartElement(null, cc_cnst_UPSXMLTag.PACKAGETYPE, null);
    				xmlWriter.writeStartElement(null, cc_cnst_UPSXMLTag.CODE, null);
    				xmlWriter.writeCharacters(cc_cnst_UPSXMLTag.PACKAGETYPECODEVALUE);
        			xmlWriter.writeEndElement(); //end code
        		xmlWriter.writeEndElement(); //end packaging type
    			xmlWriter.writeStartElement(null, cc_cnst_UPSXMLTag.PACKAGEWEIGHT, null);
    					xmlWriter.writeStartElement(null, cc_cnst_UPSXMLTag.UNITOFMEASUREMENT, null);
    						xmlWriter.writeStartElement(null, cc_cnst_UPSXMLTag.CODE, null);
    						xmlWriter.writeCharacters(cc_cnst_UPSXMLTag.WEIGHTUOMVALUE);
        					xmlWriter.writeEndElement(); //end code
        				xmlWriter.writeEndElement(); //end unit of measurement        					    			
    					xmlWriter.writeStartElement(null, cc_cnst_UPSXMLTag.WEIGHT, null);
    					xmlWriter.writeCharacters(String.valueOf(shipAttributes.weight));
        				xmlWriter.writeEndElement(); //end weight        				
        		xmlWriter.writeEndElement(); //end package weight
        		if (shipAttributes.hazardousflag != null && shipAttributes.hazardousflag) {
        			xmlWriter.writeStartElement(null, cc_cnst_UPSXMLTag.ADDTHANDLING, null);
        			xmlWriter.writeEndElement(); //end additional handling    		                			
        		}
			xmlWriter.writeEndElement(); //end package     			
		}
	}	
	
	private cc_hlpr_XMLDom sendRequestAndReceiveResponse(String requestXML) {
		Long startTime = datetime.now().getTime();		
		HttpRequest req = new HttpRequest();
		System.debug('-----JLL-----' + storefront.UPS_Endpoint__c);
		req.setEndpoint(storefront.UPS_Endpoint__c);
		req.setMethod('POST');
		req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
		req.setBody(requestXML);
		Http http = new Http();
		HttpResponse res = http.send(req);
		Long endTime = datetime.now().getTime(); 
		Long totalTime = endTime - startTime;	
		//System.debug('-----Time in UPS - sendRequestAndReceiveResponse ----- = ' + totalTime + ' ms');
		//System.debug('-----responseXML in cc_svc_ShippingAndHandlingUPS.sendRequestAndReceiveResponse = ' + res.getBody());
		Long parseXMLStartTime = datetime.now().getTime();
		cc_hlpr_XMLDom theXMLDom = new cc_hlpr_XMLDom(res.getBody());
		Long parseXMLEndTime = datetime.now().getTime(); 
		Long parseXMLTotalTime = parseXMLEndTime - parseXMLStartTime;	
		//System.debug('-----Time in UPS - Create cc_hlpr_XMLDom object ----- = ' + parseXMLTotalTime + ' ms');
		//System.debug('-----Status message returned for the response = ' + res.getStatus());
		//System.debug('-----Status code returned in the response = ' + res.getStatusCode());
		return theXMLDom;
	}	

	// This method visibility is public, for unit testing purposes.	
	public cc_bean_ShippingOptions getShippingServiceAndCost(cc_hlpr_XMLDom theXMLDom) {
		cc_bean_ShippingOptions shippingOptions = new cc_bean_ShippingOptions();
		List<cc_bean_ShippingServicesAndCostDetails> shippingServicesAndCostList = new List<cc_bean_ShippingServicesAndCostDetails>();  
		boolean responseStatus = isResponseStatusSuccess(theXMLDom);
		shippingOptions.status = responseStatus; 
		shippingOptions.shippingProvider = cc_cnst_UPSXMLTag.SHIPPINGPROVIDER;
		cc_dao_ShippingAndHandling cc_dao_ShippingAndHandling = new cc_dao_ShippingAndHandling();
		if (responseStatus) {
			List<cc_hlpr_XMLDom.Element> ratedShipmentElementList = theXMLDom.getElementsByTagName(cc_cnst_UPSXMLTag.RATEDSHIPMENT);
			for (cc_hlpr_XMLDom.Element ratedShipmentElement : ratedShipmentElementList) {
				cc_hlpr_XMLDom.Element serviceElement = ratedShipmentElement.getElementByTagName(cc_cnst_UPSXMLTag.SERVICE);
				cc_hlpr_XMLDom.Element serviceCodeElement = serviceElement.getElementByTagName(cc_cnst_UPSXMLTag.CODE);
				String serviceCodeName = getServiceCodeName(serviceCodeElement.nodeValue);
				cc_bean_ShippingServicesAndCostDetails shippingServicesAndCostDetail = new cc_bean_ShippingServicesAndCostDetails();
				shippingServicesAndCostDetail.shipService = serviceCodeName;
				cc_hlpr_XMLDom.Element totalChargesElement = ratedShipmentElement.getElementByTagName(cc_cnst_UPSXMLTag.TOTALCHARGES);
				cc_hlpr_XMLDom.Element currencyCodeElement = totalChargesElement.getElementByTagName(cc_cnst_UPSXMLTag.CURRENCYCODE);
				cc_hlpr_XMLDom.Element monetaryValueElement = totalChargesElement.getElementByTagName(cc_cnst_UPSXMLTag.MONETARYVALUE);
				if ('USD'.equals(currencyCodeElement.nodeValue)) {
					shippingServicesAndCostDetail.currencyCode = '$';					
				} else {
					shippingServicesAndCostDetail.currencyCode = currencyCodeElement.nodeValue;					
				}
				shippingServicesAndCostDetail.shipCost = includeHandlingCost(monetaryValueElement.nodeValue);
				// Apply shipping coupons
				shippingServicesAndCostDetail = handleShippingDiscounts(shippingServicesAndCostDetail);
				if (groundShipFlag) {
					if (serviceCodeName.equals(cc_cnst_UPSXMLTag.SERVICECODE_03)) {
 						shippingServicesAndCostList.add(shippingServicesAndCostDetail);						
					}
				} else if (overnightAirFlag) {
					if (serviceCodeName.equals(cc_cnst_UPSXMLTag.SERVICECODE_14)) {
 						shippingServicesAndCostList.add(shippingServicesAndCostDetail);						
					}					
				} else {
 						shippingServicesAndCostList.add(shippingServicesAndCostDetail);					
				}
			}
			shippingOptions.shippingServicesAndCostDetails = shippingServicesAndCostList;
		}
		return shippingOptions;
	}

	private String getServiceCodeName(String serviceCode) {
		String serviceCodeName = '';
		if (serviceCode.equals('01')) {
			serviceCodeName = cc_cnst_UPSXMLTag.SERVICECODE_01;
		} else if (serviceCode.equals('02')) {
			serviceCodeName = cc_cnst_UPSXMLTag.SERVICECODE_02;
		} else if (serviceCode.equals('03')) {
			serviceCodeName = cc_cnst_UPSXMLTag.SERVICECODE_03;
		} else if (serviceCode.equals('12')) {
			serviceCodeName = cc_cnst_UPSXMLTag.SERVICECODE_12;
		} else if (serviceCode.equals('13')) {
			serviceCodeName = cc_cnst_UPSXMLTag.SERVICECODE_13;
		} else if (serviceCode.equals('14')) {
			serviceCodeName = cc_cnst_UPSXMLTag.SERVICECODE_14;
		} else if (serviceCode.equals('59')) {
			serviceCodeName = cc_cnst_UPSXMLTag.SERVICECODE_59;
		} else if (serviceCode.equals('07')) {
			serviceCodeName = cc_cnst_UPSXMLTag.SERVICECODE_07;
		} else if (serviceCode.equals('08')) {
			serviceCodeName = cc_cnst_UPSXMLTag.SERVICECODE_08;
		} else if (serviceCode.equals('11')) {
			serviceCodeName = cc_cnst_UPSXMLTag.SERVICECODE_11;
		} else if (serviceCode.equals('54')) {
			serviceCodeName = cc_cnst_UPSXMLTag.SERVICECODE_54;
		} else if (serviceCode.equals('65')) {
			serviceCodeName = cc_cnst_UPSXMLTag.SERVICECODE_65;
		}
		return serviceCodeName;
	}

	private String includeHandlingCost(String cost) {
		//System.debug('-----Shipping Cost from UPS----- : ' + cost);
		Decimal shippingCost = decimal.valueOf(cost);
		Decimal handlingCost = (shippingCost * decimal.valueOf(cc_cnst_CloudCraze.HANDLING_COST_PERCENT)).divide(100, 2);
/* commenting client-specific code
		if (shippingOptionsRequest.dryIceWeight != null && shippingOptionsRequest.dryIceWeight > 0) {
			Decimal dryIceCost = decimal.valueOf(constants.DRYICE_COST_PER_POUND) * shippingOptionsRequest.dryIceWeight;
			handlingCost = handlingCost + dryIceCost;
		}
*/
		//System.debug('-----Handling cost----- : ' + handlingCost);
		Decimal shippingAndHandlingCost = shippingCost + handlingCost;
		String totalCost = String.valueOf(shippingAndHandlingCost);
		return totalCost;
	}
	
	private boolean isResponseStatusSuccess(cc_hlpr_XMLDom shippingXMLDom) {
		boolean success = false;
		cc_hlpr_XMLDom.Element responseElement = shippingXMLDom.getElementByTagName(cc_cnst_UPSXMLTag.RESPONSE);
		cc_hlpr_XMLDom.Element statusCodeElement = responseElement.getElementByTagName(cc_cnst_UPSXMLTag.RESPONSESTATUSCODE);
		cc_hlpr_XMLDom.Element statusDescriptionElement = responseElement.getElementByTagName(cc_cnst_UPSXMLTag.RESPONSESTATUSDESCRIPTION);		
		//System.debug('-----Response status from UPS : ' + statusDescriptionElement.nodeValue);
		if ('1'.equals(statusCodeElement.nodeValue)) {
			success = true;
		}
		return success;
	}
	
	private cc_bean_ShippingServicesAndCostDetails handleShippingDiscounts(cc_bean_ShippingServicesAndCostDetails shippingServicesAndCostDetail) {
		try {
			//System.debug('-----cc_svc_ShippingAndHandlingUPS.handleShippingDiscounts-shippingServicesAndCostDetail(Start) : ' + shippingServicesAndCostDetail);		
			if (cc_cnst_UPSXMLTag.SERVICECODE_03.equals(shippingServicesAndCostDetail.shipService) && al.StringUtils.isNotEmpty(shippingOptionsRequest.cartId)) {
				//System.debug('-----cc_svc_ShippingAndHandlingUPS.handleShippingDiscounts-shippingOptionsRequest.cartId : ' + shippingOptionsRequest.cartId);
				cc_api_Cart cartDetails = new cc_api_Cart();
				List<E_CartCoupon__c> cartCoupons = cartDetails.getCartCoupons(shippingOptionsRequest.cartId);
				if (al.ArrayUtils.isNotEmpty(cartCoupons)) {
					//System.debug('-----cc_svc_ShippingAndHandlingUPS.handleShippingDiscounts-cartCoupons : ' + cartCoupons);
					for (E_CartCoupon__c cartCoupon : cartCoupons) {
						//System.debug('-----cc_svc_ShippingAndHandlingUPS.handleShippingDiscounts-Shipping Coupon : ' + cartCoupon.Coupon__r.Rule__r.RuleType__c);
						if(al.StringUtils.isNotEmpty(cartCoupon.Coupon__r.Rule__r.RuleType__c) && SHIPPING_COUPON_RULE.equals(cartCoupon.Coupon__r.Rule__r.RuleType__c)){
							shippingServicesAndCostDetail.discountedShipCost = shippingServicesAndCostDetail.shipCost;
							shippingServicesAndCostDetail.shipCost = '0';
							//System.debug('-----cc_svc_ShippingAndHandlingUPS.handleShippingDiscounts-shippingServicesAndCostDetail.discountedShipCost : ' + shippingServicesAndCostDetail.discountedShipCost);
						} 			
					}				
				}			
			}
			//System.debug('-----cc_svc_ShippingAndHandlingUPS.handleShippingDiscounts-shippingServicesAndCostDetail(End) : ' + shippingServicesAndCostDetail);			
		} catch (Exception e) {
			//System.debug('Exception while handling UPS shipping discounts : ' + e);
		}
		return shippingServicesAndCostDetail;
	}		
}