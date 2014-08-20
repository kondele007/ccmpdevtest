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
 * Handles the request to/response from FedEx Web Services
 * 
 * ============================================================
 */
public with sharing class cc_svc_ShippingAndHandlingFedEx implements cc_svc_IShippingAndHandling {
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
	public cc_bean_ShippingOptionsRequest shippingOptionsRequest {get; set;} 
	private String storeID {get;set;}
    private E_StorefrontSettings__c storefront {get;set;}
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
    // CONSTRUCTOR
    //==================================================
	public cc_svc_ShippingAndHandlingFedEx(E_StorefrontSettings__c storefront) {
		this.storefront = storefront;
	}
	//==================================================
    // DERIVED METHODS
    //==================================================		
	public cc_bean_ShippingOptions getShippingAndHandlingRates(cc_bean_ShippingOptionsRequest shippingRequest){
		shippingOptionsRequest = shippingRequest;
		System.debug('----------JLL2---------------');
		String requestXML = buildRatingServiceSelectionRequestXML();			
		System.debug('-----requestXML in cc_svc_ShippingAndHandlingFedEx.getShippingAndHandlingRates = ' + requestXML);
		cc_hlpr_XMLDom theXMLDom = sendRequestAndReceiveResponse(requestXML);
		System.debug('----------JLL3---------------' + theXMLDom.toXmlString());
		Long startTime = datetime.now().getTime();
		System.debug('----------JLL1---------------');
		cc_bean_ShippingOptions shipOptions = new cc_bean_ShippingOptions();			
		shipOptions = getShippingServiceAndCost(theXMLDom);
		Long endTime = datetime.now().getTime();
		Long totalTime = endTime - startTime;	
		System.debug('-----Time in FedEx - Parse XML ----- = ' + totalTime + ' ms');			
		System.debug('-----shipOptions.status in cc_svc_ShippingAndHandlingFedEx.getShippingAndHandlingRates = ' + shipOptions.status);
		return shipOptions;
	}	
	//==================================================
    // HELPER METHODS
    //==================================================
	// This method visibility is public, for unit testing purposes.
	public String buildRatingServiceSelectionRequestXML() {
		XmlStreamWriter xmlWriter = new XmlStreamWriter();
        	xmlWriter.writeStartDocument(cc_cnst_FedExXMLTag.ENCODINGTYPE, cc_cnst_FedExXMLTag.XMLVERSION); 
       			xmlWriter.writeStartElement(cc_cnst_FedExXMLTag.URIPREFIX, cc_cnst_FedExXMLTag.RATEREQUEST, cc_cnst_FedExXMLTag.NAMESPACEURI);
       			xmlWriter.writeNamespace(cc_cnst_FedExXMLTag.URIPREFIX, cc_cnst_FedExXMLTag.NAMESPACEURI);        	
       			xmlWriter.writeNamespace('xsi', cc_cnst_FedExXMLTag.SCHEMAINSTANCE);
       			xmlWriter.writeAttribute(null, null, 'xsi:schemaLocation', cc_cnst_FedExXMLTag.SCHEMALOCATION);
				buildAuthAndClientXML(xmlWriter);
				buildVersionXML(xmlWriter);
       			buildShipmentRequestXML(xmlWriter);
        		xmlWriter.writeEndElement(); //end rate request
        	xmlWriter.writeEndDocument(); // end document
 			String xmlOutput = xmlWriter.getXmlString();
        xmlWriter.close();
        return xmlOutput;
	} 

	private void buildAuthAndClientXML(XmlStreamWriter xmlWriter) {
    	xmlWriter.writeStartElement(cc_cnst_FedExXMLTag.URIPREFIX, cc_cnst_FedExXMLTag.WEBAUTHENTICATIONDETAIL, cc_cnst_FedExXMLTag.NAMESPACEURI);
       		xmlWriter.writeStartElement(cc_cnst_FedExXMLTag.URIPREFIX, cc_cnst_FedExXMLTag.USERCREDENTIAL, cc_cnst_FedExXMLTag.NAMESPACEURI);
       			xmlWriter.writeStartElement(cc_cnst_FedExXMLTag.URIPREFIX, cc_cnst_FedExXMLTag.KEY, cc_cnst_FedExXMLTag.NAMESPACEURI);
       				xmlWriter.writeCharacters(storefront.FedEx_Key__c);
        		xmlWriter.writeEndElement(); //end key
       	    	xmlWriter.writeStartElement(cc_cnst_FedExXMLTag.URIPREFIX, cc_cnst_FedExXMLTag.PASSWORD, cc_cnst_FedExXMLTag.NAMESPACEURI);
       				xmlWriter.writeCharacters(storefront.FedEx_Password__c);
        		xmlWriter.writeEndElement(); //end password       		
        	xmlWriter.writeEndElement(); //end user credential       		
        xmlWriter.writeEndElement(); //end web auth detail
    	xmlWriter.writeStartElement(cc_cnst_FedExXMLTag.URIPREFIX, cc_cnst_FedExXMLTag.CLIENTDETAIL, cc_cnst_FedExXMLTag.NAMESPACEURI);
      		xmlWriter.writeStartElement(cc_cnst_FedExXMLTag.URIPREFIX, cc_cnst_FedExXMLTag.ACCOUNTNUMBER, cc_cnst_FedExXMLTag.NAMESPACEURI);
       			xmlWriter.writeCharacters(storefront.FedEx_Account_Number__c);
        	xmlWriter.writeEndElement(); //end account number
       	    xmlWriter.writeStartElement(cc_cnst_FedExXMLTag.URIPREFIX, cc_cnst_FedExXMLTag.METERNUMBER, cc_cnst_FedExXMLTag.NAMESPACEURI);
       			xmlWriter.writeCharacters(storefront.FedEx_Meter_Number__c);
        	xmlWriter.writeEndElement(); //end meter number       		
        xmlWriter.writeEndElement(); //end client detail        
	}

	private void buildVersionXML(XmlStreamWriter xmlWriter) {
        xmlWriter.writeStartElement(cc_cnst_FedExXMLTag.URIPREFIX, cc_cnst_FedExXMLTag.VERSION, cc_cnst_FedExXMLTag.NAMESPACEURI);
        	xmlWriter.writeStartElement(cc_cnst_FedExXMLTag.URIPREFIX, cc_cnst_FedExXMLTag.SERVICEID, cc_cnst_FedExXMLTag.NAMESPACEURI);
        	xmlWriter.writeCharacters(cc_cnst_FedExXMLTag.SERVICEIDVALUE); 
        	xmlWriter.writeEndElement(); //end service id
        	xmlWriter.writeStartElement(cc_cnst_FedExXMLTag.URIPREFIX, cc_cnst_FedExXMLTag.MAJOR, cc_cnst_FedExXMLTag.NAMESPACEURI);
        	xmlWriter.writeCharacters(cc_cnst_FedExXMLTag.MAJORVALUE);
        	xmlWriter.writeEndElement(); //end major
        	xmlWriter.writeStartElement(cc_cnst_FedExXMLTag.URIPREFIX, cc_cnst_FedExXMLTag.INTERMEDIATE, cc_cnst_FedExXMLTag.NAMESPACEURI);
        	xmlWriter.writeCharacters(cc_cnst_FedExXMLTag.INTERMEDIATEVALUE);
        	xmlWriter.writeEndElement(); //end intermediate        	        	
        	xmlWriter.writeStartElement(cc_cnst_FedExXMLTag.URIPREFIX, cc_cnst_FedExXMLTag.MINOR, cc_cnst_FedExXMLTag.NAMESPACEURI);
        	xmlWriter.writeCharacters(cc_cnst_FedExXMLTag.MINORVALUE);
        	xmlWriter.writeEndElement(); //end minor        	        	        	
        xmlWriter.writeEndElement(); //end version
	}
	
	private void buildShipmentRequestXML(XmlStreamWriter xmlWriter) {
    	xmlWriter.writeStartElement(cc_cnst_FedExXMLTag.URIPREFIX, cc_cnst_FedExXMLTag.REQUESTEDSHIPMENT, cc_cnst_FedExXMLTag.NAMESPACEURI);
        	xmlWriter.writeStartElement(cc_cnst_FedExXMLTag.URIPREFIX, cc_cnst_FedExXMLTag.PACKAGETYPE, cc_cnst_FedExXMLTag.NAMESPACEURI);
        	xmlWriter.writeCharacters(cc_cnst_FedExXMLTag.PACKAGINGTYPEVALUE);
        	xmlWriter.writeEndElement(); //end packaging type        	           	
       	    xmlWriter.writeStartElement(cc_cnst_FedExXMLTag.URIPREFIX, cc_cnst_FedExXMLTag.SHIPPER, cc_cnst_FedExXMLTag.NAMESPACEURI);
				buildAddressXML(xmlWriter, cc_cnst_CloudCraze.SHIPFROM_ZIPCODE, cc_cnst_CloudCraze.SHIPFROM_COUNTRYCODE);
        	xmlWriter.writeEndElement(); //end shipper        		    	
       	    xmlWriter.writeStartElement(cc_cnst_FedExXMLTag.URIPREFIX, cc_cnst_FedExXMLTag.RECIPIENT, cc_cnst_FedExXMLTag.NAMESPACEURI);
				buildAddressXML(xmlWriter, shippingOptionsRequest.recepientZipCode, shippingOptionsRequest.recepientCountryCode);
        	xmlWriter.writeEndElement(); //end shipto        		
        buildPackageXML(xmlWriter);
		xmlWriter.writeEndElement(); //end requested shipment
	}

	private void buildAddressXML(XmlStreamWriter xmlWriter, String postalCode, String countryCode) {
       	xmlWriter.writeStartElement(cc_cnst_FedExXMLTag.URIPREFIX, cc_cnst_FedExXMLTag.ADDRESS, cc_cnst_FedExXMLTag.NAMESPACEURI);
    		xmlWriter.writeStartElement(cc_cnst_FedExXMLTag.URIPREFIX, cc_cnst_FedExXMLTag.POSTALCODE, cc_cnst_FedExXMLTag.NAMESPACEURI);
    			xmlWriter.writeCharacters(postalCode);
        	xmlWriter.writeEndElement(); //end postal code
    		xmlWriter.writeStartElement(cc_cnst_FedExXMLTag.URIPREFIX, cc_cnst_FedExXMLTag.COUNTRYCODE, cc_cnst_FedExXMLTag.NAMESPACEURI);
    			xmlWriter.writeCharacters(countryCode);
        	xmlWriter.writeEndElement(); //end country code
		xmlWriter.writeEndElement(); //end address        		        		
	}
	
	private void buildPackageXML(XmlStreamWriter xmlWriter) { 
		List<cc_bean_ShippingAttributes> shippingAttributesList = shippingOptionsRequest.shippingAttributesList;
		Integer shippingAttributesListSize = shippingAttributesList.size();
		String noOfPackages = String.valueOf(shippingAttributesListSize);
			xmlWriter.writeStartElement(cc_cnst_FedExXMLTag.URIPREFIX, cc_cnst_FedExXMLTag.PACKAGECOUNT, cc_cnst_FedExXMLTag.NAMESPACEURI);
			xmlWriter.writeCharacters(noOfPackages);
			xmlWriter.writeEndElement(); //end package count			
			xmlWriter.writeStartElement(cc_cnst_FedExXMLTag.URIPREFIX, cc_cnst_FedExXMLTag.PACKAGEDETAIL, cc_cnst_FedExXMLTag.NAMESPACEURI);
			xmlWriter.writeCharacters(cc_cnst_FedExXMLTag.PACKAGEDETAILVALUE);
			xmlWriter.writeEndElement(); //end package detail
			Integer sequenceNumber = 0;
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
			sequenceNumber++;
			String seqNo = String.valueOf(sequenceNumber);
			xmlWriter.writeStartElement(cc_cnst_FedExXMLTag.URIPREFIX, cc_cnst_FedExXMLTag.REQUESTEDPACKAGELINEITEMS, cc_cnst_FedExXMLTag.NAMESPACEURI);
				xmlWriter.writeStartElement(cc_cnst_FedExXMLTag.URIPREFIX, cc_cnst_FedExXMLTag.SEQUENCENUMBER, cc_cnst_FedExXMLTag.NAMESPACEURI);
				xmlWriter.writeCharacters(seqNo);
				xmlWriter.writeEndElement(); //end sequence number
				xmlWriter.writeStartElement(cc_cnst_FedExXMLTag.URIPREFIX, cc_cnst_FedExXMLTag.WEIGHT, cc_cnst_FedExXMLTag.NAMESPACEURI);
					xmlWriter.writeStartElement(cc_cnst_FedExXMLTag.URIPREFIX, cc_cnst_FedExXMLTag.UNITS, cc_cnst_FedExXMLTag.NAMESPACEURI);
    				xmlWriter.writeCharacters(cc_cnst_FedExXMLTag.WEIGHTUOMVALUE);
        			xmlWriter.writeEndElement(); //end units				
					xmlWriter.writeStartElement(cc_cnst_FedExXMLTag.URIPREFIX, cc_cnst_FedExXMLTag.VALUE, cc_cnst_FedExXMLTag.NAMESPACEURI);
    				xmlWriter.writeCharacters(String.valueOf(shipAttributes.weight));
        			xmlWriter.writeEndElement(); //end value        			
				xmlWriter.writeEndElement(); //end weight
			xmlWriter.writeEndElement(); //end requested package line items
		}		
	}	

	private cc_hlpr_XMLDom sendRequestAndReceiveResponse(String requestXML) {
		System.debug('----------JLL4---------------');
		Long startTime = datetime.now().getTime();		
		HttpRequest req = new HttpRequest();
		req.setEndpoint(storefront.FedEx_Endpoint__c);
		//req.setEndpoint('https://gatewaybeta.fedex.com:443/xml/rate');
		req.setMethod('POST');
		req.setBody(requestXML);
		System.debug('----------JLL5---------------');
		Http http = new Http();
		HttpResponse res = http.send(req);
		Long endTime = datetime.now().getTime(); 
		Long totalTime = endTime - startTime;	
		System.debug('-----Time in FedEx - sendRequestAndReceiveResponse ----- = ' + totalTime + ' ms');		
		System.debug('-----responseXML in cc_svc_ShippingAndHandlingFedEx.sendRequestAndReceiveResponse = ' + res.getBody());
		Long parseXMLStartTime = datetime.now().getTime();		
		cc_hlpr_XMLDom theXMLDom = new cc_hlpr_XMLDom(res.getBody());
		Long parseXMLEndTime = datetime.now().getTime(); 
		Long parseXMLTotalTime = parseXMLEndTime - parseXMLStartTime;	
		System.debug('-----Time in FedEx - Create cc_hlpr_XMLDom object ----- = ' + parseXMLTotalTime + ' ms');		
		System.debug('-----Status message returned for the response = ' + res.getStatus());
		System.debug('-----Status code returned in the response = ' + res.getStatusCode());
		return theXMLDom;
	}	
	
	// This method visibility is public, for unit testing purposes.
	public cc_bean_ShippingOptions getShippingServiceAndCost(cc_hlpr_XMLDom theXMLDom) {
		cc_bean_ShippingOptions shippingOptions = new cc_bean_ShippingOptions();
		List<cc_bean_ShippingServicesAndCostDetails> shippingServicesAndCostList = new List<cc_bean_ShippingServicesAndCostDetails>();  
		boolean responseStatus = isResponseStatusSuccess(theXMLDom);
		shippingOptions.status = responseStatus;
		shippingOptions.shippingProvider = cc_cnst_FedExXMLTag.SHIPPINGPROVIDER;
		cc_dao_ShippingAndHandling cc_dao_ShippingAndHandling = new cc_dao_ShippingAndHandling();
		if (responseStatus) {
			List<cc_hlpr_XMLDom.Element> rateReplyDetailsElementList = theXMLDom.getElementsByTagName(cc_cnst_FedExXMLTag.RATEREPLYDETAILS);
			for (cc_hlpr_XMLDom.Element rateReplyDetailElement : rateReplyDetailsElementList) {
				cc_hlpr_XMLDom.Element serviceTypeElement = rateReplyDetailElement.getElementByTagName(cc_cnst_FedExXMLTag.SERVICETYPE);
				cc_bean_ShippingServicesAndCostDetails shippingServicesAndCostDetail = new cc_bean_ShippingServicesAndCostDetails();
				shippingServicesAndCostDetail.shipService = serviceTypeElement.nodeValue;				
				cc_hlpr_XMLDom.Element ratedShipmentDetailElement = rateReplyDetailElement.getElementsByTagName(cc_cnst_FedExXMLTag.RATEDSHIPMENTDETAILS).get(0);
				cc_hlpr_XMLDom.Element shipmentRateDetailElement = ratedShipmentDetailElement.getElementByTagName(cc_cnst_FedExXMLTag.SHIPMENTRATEDETAIL);
				cc_hlpr_XMLDom.Element totalNetChargeElement = shipmentRateDetailElement.getElementByTagName(cc_cnst_FedExXMLTag.TOTALNETCHARGE);
				cc_hlpr_XMLDom.Element currencyElement = totalNetChargeElement.getElementByTagName(cc_cnst_FedExXMLTag.AMOUNTCURRENCY);
				cc_hlpr_XMLDom.Element amountElement = totalNetChargeElement.getElementByTagName(cc_cnst_FedExXMLTag.AMOUNT);
				if ('USD'.equals(currencyElement.nodeValue)) {
					shippingServicesAndCostDetail.currencyCode = '$';					
				} else {
					shippingServicesAndCostDetail.currencyCode = currencyElement.nodeValue;					
				}				
				shippingServicesAndCostDetail.shipCost = includeHandlingCost(amountElement.nodeValue);
				// Apply shipping coupons
				shippingServicesAndCostDetail = handleShippingDiscounts(shippingServicesAndCostDetail);
				if (groundShipFlag) {
					if (shippingServicesAndCostDetail.shipService.equals(cc_cnst_FedExXMLTag.FEDEX_GROUND)) {
 						shippingServicesAndCostList.add(shippingServicesAndCostDetail);						
					}
				} else if (overnightAirFlag) {
					if (cc_cnst_FedExXMLTag.FEDEX_OVERNIGHT.indexOf(shippingServicesAndCostDetail.shipService, 0) != -1) {
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

	private String includeHandlingCost(String cost) {
		System.debug('-----Shipping Cost from FedEx----- : ' + cost);		
		Decimal shippingCost = decimal.valueOf(cost);
		Decimal handlingCost = (shippingCost * decimal.valueOf(cc_cnst_CloudCraze.HANDLING_COST_PERCENT)).divide(100, 2);
/* commenting client-specific code
		if (shippingOptionsRequest.dryIceWeight != null && shippingOptionsRequest.dryIceWeight > 0) {
			Decimal dryIceCost = decimal.valueOf(constants.DRYICE_COST_PER_POUND) * shippingOptionsRequest.dryIceWeight;
			handlingCost = handlingCost + dryIceCost;
		}
*/
		System.debug('-----Handling cost----- : ' + handlingCost);		
		Decimal shippingAndHandlingCost = shippingCost + handlingCost;
		String totalCost = String.valueOf(shippingAndHandlingCost);
		return totalCost;
	}
	
	private boolean isResponseStatusSuccess(cc_hlpr_XMLDom shippingXMLDom) {
		boolean success = false;
		cc_hlpr_XMLDom.Element severityElement = shippingXMLDom.getElementByTagName(cc_cnst_FedExXMLTag.HIGHESTSEVERITY);
		System.debug('-----Response status from FedEx : ' + severityElement.nodeValue);
		if ('WARNING'.equals(severityElement.nodeValue) || 'NOTE'.equals(severityElement.nodeValue) || 'SUCCESS'.equals(severityElement.nodeValue)) {
			success = true;
		}
		return success;
	}
	
	private cc_bean_ShippingServicesAndCostDetails handleShippingDiscounts(cc_bean_ShippingServicesAndCostDetails shippingServicesAndCostDetail) {
		try {
			System.debug('-----cc_svc_ShippingAndHandlingFedEx.handleShippingDiscounts-shippingServicesAndCostDetail(Start) : ' + shippingServicesAndCostDetail);		
			if (cc_cnst_FedExXMLTag.FEDEX_GROUND.equals(shippingServicesAndCostDetail.shipService) && al.StringUtils.isNotEmpty(shippingOptionsRequest.cartId)) {
				System.debug('-----cc_svc_ShippingAndHandlingFedEx.handleShippingDiscounts-shippingOptionsRequest.cartId : ' + shippingOptionsRequest.cartId);
				cc_api_Cart cartDetails = new cc_api_Cart();
				List<E_CartCoupon__c> cartCoupons = cartDetails.getCartCoupons(shippingOptionsRequest.cartId);
				if (al.ArrayUtils.isNotEmpty(cartCoupons)) {
					System.debug('-----cc_svc_ShippingAndHandlingFedEx.handleShippingDiscounts-cartCoupons : ' + cartCoupons);
					for (E_CartCoupon__c cartCoupon : cartCoupons) {
						System.debug('-----cc_svc_ShippingAndHandlingUPS.handleShippingDiscounts-Shipping Coupon : ' + cartCoupon.Coupon__r.Rule__r.RuleType__c);
						if(al.StringUtils.isNotEmpty(cartCoupon.Coupon__r.Rule__r.RuleType__c) && SHIPPING_COUPON_RULE.equals(cartCoupon.Coupon__r.Rule__r.RuleType__c)){
							shippingServicesAndCostDetail.discountedShipCost = shippingServicesAndCostDetail.shipCost;
							shippingServicesAndCostDetail.shipCost = '0';
							System.debug('-----cc_svc_ShippingAndHandlingFedEx.handleShippingDiscounts-shippingServicesAndCostDetail.discountedShipCost : ' + shippingServicesAndCostDetail.discountedShipCost);
						} 			
					}				
				}			
			}
			System.debug('-----cc_svc_ShippingAndHandlingFedEx.handleShippingDiscounts-shippingServicesAndCostDetail(End) : ' + shippingServicesAndCostDetail);			
		} catch (Exception e) {
			System.debug('Exception while handling shipping discounts : ' + e);
		}
		return shippingServicesAndCostDetail;
	}	
}