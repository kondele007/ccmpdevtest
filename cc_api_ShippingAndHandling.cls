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
 * Handles the business rules for Shipping & Handling
 * 
 * ============================================================
 */
public with sharing class cc_api_ShippingAndHandling {  
	//==================================================
    // CONSTANTS
    //==================================================
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
	private cc_bean_ShippingOptionsRequest shippingOptionsRequest {get; set;}
	public List<E_CartItem__c> cartItems {get; set;}
	private Set<String> productIdList {get; set;}
	//==================================================
    // INSTANCE VARIABLES
    //==================================================
	public Decimal MAX_PER_PACKAGE_WEIGHT; 
// need to add storefront ot shipping optionsRequestBean and use settings here: storefront = cc_util_CloudCraze.getStorefrontSettings(storeID);
	
	//==================================================
    // SERVICE METHODS
    //==================================================
    public List<cc_ctrl_hlpr_ShippingOption> getShippingOptions(String zipCode, String stateCode, String countryCode, Id cartId, String storeName) {
        System.debug(LoggingLevel.INFO, '--- cc_api_ShippingAndHandling.getShippingOptions: zipCode=' + zipCode + ', stateCode=' + stateCode + ', countryCode=' + countryCode + ', cartId=' + cartId + ', storeName=' + storeName);
        List<cc_ctrl_hlpr_ShippingOption> shipOptionsList = new List<cc_ctrl_hlpr_ShippingOption>();

        cc_bean_ShippingOptionsRequest shipOptionsRequest = new cc_bean_ShippingOptionsRequest();
        shipOptionsRequest.recepientZipCode = zipCode;
        shipOptionsRequest.recepientStateCode = stateCode;
        shipOptionsRequest.recepientCountryCode = countryCode;
        shipOptionsRequest.cartId = cartId;
        shipOptionsRequest.store = storeName;
        shipOptionsRequest.storefront = cc_util_CloudCraze.getStorefrontSettings(storeName);
                      
        List<cc_bean_ShippingOptions> beans = getShippingOptionsForCart(shipOptionsRequest);
        //System.debug('--- cc_extn_PaymentShippingInfo.setShippingOptions-beans : ' + beans); 
        if(beans != null) {
            for(cc_bean_ShippingOptions bean:beans) {
                //System.debug('--- cc_extn_PaymentShippingInfo.setShippingOptions-bean : ' + bean);
                if(bean.shippingServicesAndCostDetails == null) {
                    continue;
                }
                for(cc_bean_ShippingServicesAndCostDetails detail : bean.shippingServicesAndCostDetails) {
                    //System.debug('--- cc_extn_PaymentShippingInfo.setShippingOptions-detail : ' + detail);
                    String provider = '';
                    if(cc_cnst_FedExXMLTag.SHIPPINGPROVIDER.equals(bean.shippingProvider) || cc_cnst_UPSXMLTag.SHIPPINGPROVIDER.equals(bean.shippingProvider)) {
                        provider = bean.shippingProvider;
                    } else {
                        throw new cc_excn_CartException('Unknown provider! Provider:' + bean.shippingProvider);
                    }
                    //System.debug('ah shipCost ' + detail.shipCost);
                    if(detail.shipCost!=null) {
                        shipOptionsList.add(new cc_ctrl_hlpr_ShippingOption(provider, detail.shipService, Decimal.valueOf(detail.shipCost), Decimal.valueOf((al.StringUtils.isEmpty(detail.discountedShipCost)?'0':detail.discountedShipCost))));
                   		//System.debug('ah provider' + provider);
                    }
                }
            }
        }
        /* uncomment to sort by price
        if(this.shipOptionsList.size() > 1) {
            ArrayUtils.qsort(this.shipOptionsList,SHIPPING_OPTION_SORTER);
        }
        */
        return shipOptionsList;
    }

	public List<cc_bean_ShippingOptions> getShippingOptionsForCart(cc_bean_ShippingOptionsRequest shipOptionsRequest) {
		Long startTime = datetime.now().getTime();
		List<cc_bean_ShippingOptions> shippingOptionsList = new List<cc_bean_ShippingOptions>();
		try {
			shippingOptionsRequest = shipOptionsRequest;
			// Get the Cart Items, for Product & Quantity ordered
			cc_dao_ShippingAndHandling cc_dao_ShippingAndHandling = new cc_dao_ShippingAndHandling();
			cartItems = cc_dao_ShippingAndHandling.getCartProductIds(shippingOptionsRequest.cartId);
			// Check for Store
			boolean hasProductsFromSingleStore = checkForProductsWithMultipleStore();
			//System.debug('-----Has Products from Single Store : ' + hasProductsFromSingleStore);
			if (hasProductsFromSingleStore) {
				MAX_PER_PACKAGE_WEIGHT = shippingOptionsRequest.storefront.MaxShippingWeightPerProduct__c;
				
				// Build the shipping attributes
				shippingOptionsRequest = getShippingAttributes(shippingOptionsRequest);
				// Check for shipping attributes
				if (shippingOptionsRequest != null && shippingOptionsRequest.shippingAttributesList != null && shippingOptionsRequest.shippingAttributesList.size() > 0) {
					//System.debug(LoggingLevel.INFO,'-----getShippingOptionsForCart.getShippingOptionsForCart-Shipping specs are available----');
					// Check, if shipping provider can be called
					boolean displayAndNotCallShipOptions = checkToDisplayOrCallShipOptions(shippingOptionsRequest);
					//System.debug(LoggingLevel.INFO,'-----displayAndNotCallShipOptions in cc_api_ShippingAndHandling = ' + displayAndNotCallShipOptions);
					if (displayAndNotCallShipOptions) {
						// Build the required packages
						shippingOptionsRequest = buildPackageRequest(shipOptionsRequest);
						Long endTime = datetime.now().getTime(); 
				 		Long totalTime = endTime - startTime;
						//System.debug(LoggingLevel.INFO,'-----Time to build shipping packages-cc_api_ShippingAndHandling.getShippingOptionsForCart ----- = ' + totalTime + ' ms');
						cc_bean_ShippingOptions shippingOptions = new cc_bean_ShippingOptions();
						// Call the shipping providers
						//System.debug(LoggingLevel.INFO,'Call the shipping providers');
						cc_svc_IShippingAndHandling shippingAndHandlingService = cc_hlpr_ShippingAndHandlingSvcFactory.getShippingAndHandlingService(shippingOptionsRequest.storefront);			
						shippingOptions = shippingAndHandlingService.getShippingAndHandlingRates(shippingOptionsRequest);
						//System.debug(LoggingLevel.INFO,'ryl - shippingOptions=' + shippingOptions);
						shippingOptionsList.add(shippingOptions);				
					}
				}					
			}
		} catch (System.Exception e) {
			//System.debug(LoggingLevel.INFO,'ERROR------------: '+ e);
		}
		return shippingOptionsList;
	} 
	//==================================================
    // HELPER METHODS
    //==================================================
	// This method visibility is public, for unit testing purposes.
	public boolean checkForProductsWithMultipleStore() {
		boolean hasProductsFromSingleStore = true;
		Set<String> storeList = new Set<String>(); 
		for (E_CartItem__c cartItem : cartItems) {
			if (!storeList.contains(cartItem.StoreId__c)) {
				storeList.add(cartItem.StoreId__c);
			}
		}
		if (storeList.size() != 1) {
			hasProductsFromSingleStore = false;
		} 
		return hasProductsFromSingleStore;
	}	

	// This method visibility is public, for unit testing purposes.
	public cc_bean_ShippingOptionsRequest getShippingAttributes(cc_bean_ShippingOptionsRequest shippingOptionsRequest) { 
		cc_dao_ShippingAndHandling cc_dao_ShippingAndHandling = new cc_dao_ShippingAndHandling(); 
		Set<String> productIds = buildProductIds(shippingOptionsRequest.storefront.Name);
		List<E_Product__c> shippingSpecs = cc_dao_ShippingAndHandling.getShippingSpecs(productIds);
		//System.debug('-----shippingSpecs----- : ' + shippingSpecs);
		if (al.ArrayUtils.isNotEmpty(shippingSpecs)) {
			shippingOptionsRequest = handleShippingAttributes(shippingSpecs, shippingOptionsRequest);
		}
		return shippingOptionsRequest;
	}	

	private Set<String> buildProductIds(String store) {
		Set<String> productIds = new Set<String>();
		for (E_CartItem__c cartItem : cartItems) {
			if (cartItem.StoreId__c.equals(store) && !productIds.contains(cartItem.Product__c)) {
				productIds.add(cartItem.Product__c);				
			}
		}
		productIdList = productIds;
		//System.debug('-----productIds----- : ' + productIds);
		return productIds;
	}		

	private cc_bean_ShippingOptionsRequest handleShippingAttributes(List<E_Product__c> shippingSpecs, cc_bean_ShippingOptionsRequest shippingOptionsRequest) {
		List<cc_bean_ShippingAttributes> shippingAttributesList = new List<cc_bean_ShippingAttributes>(); 	
		for (E_Product__c shippingSpec : shippingSpecs) {
			cc_bean_ShippingAttributes shippingAttributes = new cc_bean_ShippingAttributes();
			//System.debug('-----productId in cc_api_ShippingAndHandling.handleShippingAttributes = ' + shippingSpec.ProductId__c);
			//System.debug('-----Id in cc_api_ShippingAndHandling.handleShippingAttributes = ' + shippingSpec.Id);
			shippingAttributes.productId = shippingSpec.ProductId__c;   
			// Ground Shipping
			if (shippingSpec.GroundFlag__c) {
				shippingAttributes.groundShippingRequired = true;
			}
			// Overnight Air
			if (shippingSpec.OvernightFlag__c) {
				shippingAttributes.overnightAirRequired = true;
			}
			// Dry Ice
			if (shippingSpec.DryIceFlag__c) {
				shippingAttributes.dryIceRequired = true;
			}	
			// Cooler Pak
			if (shippingSpec.CoolerPakFlag__c) {
				shippingAttributes.coolerPakRequired = true;
			}
			// Hazardous Material
			if (shippingSpec.HazardousFlag__c) {
				shippingAttributes.hazardousflag = true;
			}
			// Hazardous Material outside 48 U.S. states
			if (shippingSpec.HazardousOutside48Flag__c) {
				shippingAttributes.hazardousoutside48flag = true;
			}					
			// Dry ice weight
			if (shippingSpec.DryIceWeight__c != null && shippingSpec.DryIceWeight__c > 0) {
				shippingAttributes.dryIceWeight = shippingSpec.DryIceWeight__c;
				if (shippingOptionsRequest.dryIceWeight == null) {
					shippingOptionsRequest.dryIceWeight = 0;
				}
				shippingOptionsRequest.dryIceWeight = shippingOptionsRequest.dryIceWeight + shippingAttributes.dryIceWeight;
				//System.debug('-----shippingOptionsRequest.dryIceWeight-----: ' + shippingOptionsRequest.dryIceWeight);
			} 		
			// Ship weight
			if (shippingSpec.ShippingWeight__c != null && shippingSpec.ShippingWeight__c > 0) {
				//System.debug('-----shippingSpec.ShippingWeight__c-----: ' + shippingSpec.ShippingWeight__c);
				shippingAttributes.weight = calculateWeightWithQuantity(shippingSpec.ShippingWeight__c, shippingSpec.Id);
			}
			shippingAttributesList.add(shippingAttributes);
		}
		//System.debug('-----shippingAttributesList in cc_api_ShippingAndHandling.handleShippingAttributes = ' + shippingAttributesList);
		shippingOptionsRequest.shippingAttributesList = shippingAttributesList;	
		return shippingOptionsRequest;
	}

	// This method visibility is public, for unit testing purposes.	
	public boolean checkToDisplayOrCallShipOptions(cc_bean_ShippingOptionsRequest shipOptionsRequest) {
		boolean displayAndNotCallShipOptions = true;
		boolean airOvernightFlag = false;
		boolean alaskaOrHawaiiFlag = false;
		if ('AK'.equals(shipOptionsRequest.recepientStateCode) || 'HI'.equals(shipOptionsRequest.recepientStateCode)) {
			alaskaOrHawaiiFlag = true;				
		} 
		boolean outside48Flag = false;
		if ('AK'.equals(shipOptionsRequest.recepientStateCode) || 'HI'.equals(shipOptionsRequest.recepientStateCode) || 'CA'.equals(shipOptionsRequest.recepientCountryCode)) {
			outside48Flag = true;				
		} 		
		List<cc_bean_ShippingAttributes> shipAttributesList = shipOptionsRequest.shippingAttributesList;
		for (cc_bean_ShippingAttributes shipAttributes : shipAttributesList) {
			// Outside 48 & Hazardous
			if (outside48Flag && shipAttributes.hazardousflag != null && shipAttributes.hazardousflag){
				displayAndNotCallShipOptions = false;
				break;
			}
			// Outside 48 & Hazardous outside 48			
			if (outside48Flag && shipAttributes.hazardousoutside48flag != null && shipAttributes.hazardousoutside48flag) {
				displayAndNotCallShipOptions = false;
				break;				
			}			
			// Alaska/Hawaii & Ground Shipping
			if (alaskaOrHawaiiFlag && shipAttributes.groundShippingRequired != null && shipAttributes.groundShippingRequired) {
				displayAndNotCallShipOptions = false;
				break;				
			}
			// Dry Ice, Cooler Pak, Overnight Air - Overnight flag is true
			if (!airOvernightFlag && ((shipAttributes.dryIceRequired != null && shipAttributes.dryIceRequired) || (shipAttributes.coolerPakRequired != null && shipAttributes.coolerPakRequired) || (shipAttributes.overnightAirRequired != null && shipAttributes.overnightAirRequired))) {
				airOvernightFlag = true;				
			}
			//If cart has both Ground Shipping & Overnight Air
			if (airOvernightFlag && shipAttributes.groundShippingRequired != null && shipAttributes.groundShippingRequired) {
				displayAndNotCallShipOptions = false;
				break;								
			}
		}
		//System.debug('--- cc_api_ShippingAndHandling.checkToDisplayOrCallShipOptions: returning displayAndNotCallShipOptions=' + displayAndNotCallShipOptions);
		return displayAndNotCallShipOptions;
	}	

	// This method visibility is public, for unit testing purposes.
	public cc_bean_ShippingOptionsRequest buildPackageRequest(cc_bean_ShippingOptionsRequest shipOptionsRequest) {
		List<cc_bean_ShippingAttributes> shippingAttributesList = shipOptionsRequest.shippingAttributesList;
		List<cc_bean_ShippingAttributes> newShippingAttributesList = new List<cc_bean_ShippingAttributes>();
		cc_bean_ShippingAttributes dryIceShippingAttributesBean = new cc_bean_ShippingAttributes();
		cc_bean_ShippingAttributes coolerPakShippingAttributesBean = new cc_bean_ShippingAttributes();
		cc_bean_ShippingAttributes newShippingAttributesBean = new cc_bean_ShippingAttributes();
		boolean hasDryIceRequirement = false;
		boolean hasCoolerPakRequirement = false;
		boolean hasRegularProducts = false;
		//System.debug('cc_api_ShippingAndHandling.buildPackageRequest shipOptionsRequest=' + shipOptionsRequest);
        //System.debug('cc_api_ShippingAndHandling.buildPackageRequest shippingAttributesList.size=' + shippingAttributesList.size() + ', shippingAttributesList=' + shippingAttributesList);
		for (cc_bean_ShippingAttributes shipAttributes : shippingAttributesList) {
			if (shipAttributes.hazardousflag != null && shipAttributes.hazardousflag) {
				//System.debug('-----Has Hazardous Products-----');
				cc_bean_ShippingAttributes hazardousShippingAttributesBean = new cc_bean_ShippingAttributes();
				hazardousShippingAttributesBean.overnightAirRequired = shipAttributes.overnightAirRequired;
				if (shipAttributes.groundShippingRequired != null && shipAttributes.groundShippingRequired) {
					hazardousShippingAttributesBean.groundShippingRequired = shipAttributes.groundShippingRequired;
				}
				hazardousShippingAttributesBean.weight = calculateShipWeight(hazardousShippingAttributesBean.weight, shipAttributes.weight, shipAttributes.dryIceWeight);
				hazardousShippingAttributesBean.hazardousflag = true;
				Decimal shipWeight = hazardousShippingAttributesBean.weight;
				//System.debug('cc_api_ShippingAndHandling.buildPackageRequest shipWeight=' + shipWeight + ', MAX_PER_PACKAGE_WEIGHT=' + MAX_PER_PACKAGE_WEIGHT + ', shipAttributes=' + shipAttributes);
				if (shipWeight > MAX_PER_PACKAGE_WEIGHT) {
					Decimal noOfPackages = shipWeight.divide(MAX_PER_PACKAGE_WEIGHT, 0, System.RoundingMode.UP);
					Decimal weightPerPackage = shipWeight.divide(noOfPackages, 2);
					//System.debug('-----No of Split Hazardous Packages----- : ' + noOfPackages);
					for (Integer i =0; i<noOfPackages; i++) {
						cc_bean_ShippingAttributes packageSplitShippingAttributesBean = new cc_bean_ShippingAttributes();
						packageSplitShippingAttributesBean.overnightAirRequired = hazardousShippingAttributesBean.overnightAirRequired;
						packageSplitShippingAttributesBean.hazardousflag = true;
						packageSplitShippingAttributesBean.weight = weightPerPackage;
						newShippingAttributesList.add(packageSplitShippingAttributesBean);
					}
				} else {
					newShippingAttributesList.add(hazardousShippingAttributesBean);					
				}
			} else if (shipAttributes.dryIceRequired != null && shipAttributes.dryIceRequired) {
				hasDryIceRequirement = true;
				dryIceShippingAttributesBean.overnightAirRequired = shipAttributes.overnightAirRequired;
				dryIceShippingAttributesBean.hazardousoutside48flag = shipAttributes.hazardousoutside48flag;
				dryIceShippingAttributesBean.weight = calculateShipWeight(dryIceShippingAttributesBean.weight, shipAttributes.weight, shipAttributes.dryIceWeight);
				dryIceShippingAttributesBean.dryIceRequired = true;
			} else if (shipAttributes.coolerPakRequired != null && shipAttributes.coolerPakRequired) {
				hasCoolerPakRequirement = true;
				coolerPakShippingAttributesBean.overnightAirRequired = shipAttributes.overnightAirRequired;
				coolerPakShippingAttributesBean.hazardousoutside48flag = shipAttributes.hazardousoutside48flag;
				coolerPakShippingAttributesBean.weight = calculateShipWeight(coolerPakShippingAttributesBean.weight, shipAttributes.weight, shipAttributes.dryIceWeight);
				coolerPakShippingAttributesBean.coolerPakRequired = true;
			} else if (shipAttributes.weight != null){
				hasRegularProducts = true;
				newShippingAttributesBean.groundShippingRequired = shipAttributes.groundShippingRequired;
				newShippingAttributesBean.overnightAirRequired = shipAttributes.overnightAirRequired;
				newShippingAttributesBean.hazardousoutside48flag = shipAttributes.hazardousoutside48flag;
				newShippingAttributesBean.weight = calculateShipWeight(newShippingAttributesBean.weight, shipAttributes.weight, shipAttributes.dryIceWeight);
			}
		}
		if (hasDryIceRequirement) {
			//System.debug('-----Has Dry Ice Required Products-----');
			newShippingAttributesList = handleMultiplePackages(dryIceShippingAttributesBean.weight, newShippingAttributesList, dryIceShippingAttributesBean, true, false);
		} 
		if (hasCoolerPakRequirement) {
			//System.debug('-----Has Cooler Pak Required Products-----');
			newShippingAttributesList = handleMultiplePackages(coolerPakShippingAttributesBean.weight, newShippingAttributesList, coolerPakShippingAttributesBean, false, true);
		} 
		if (hasRegularProducts) {
			//System.debug('-----Has Regular Products-----');
			newShippingAttributesList = handleMultiplePackages(newShippingAttributesBean.weight, newShippingAttributesList, newShippingAttributesBean, false, false);			
		}
		//System.debug('-----Total No of Packages : ' + newShippingAttributesList.size());
		//System.debug('-----Package details : ' + newShippingAttributesList);
		shipOptionsRequest.shippingAttributesList = newShippingAttributesList;
		return shipOptionsRequest;
	}

	private List<cc_bean_ShippingAttributes> handleMultiplePackages(Decimal weight, List<cc_bean_ShippingAttributes> newShippingAttributesList, cc_bean_ShippingAttributes newShippingAttributesBean, boolean dryIceFlag, boolean coolerPakFlag) {
		if (weight > MAX_PER_PACKAGE_WEIGHT) {
			Decimal noOfPackages = weight.divide(MAX_PER_PACKAGE_WEIGHT, 0, System.RoundingMode.UP);
			Decimal weightPerPackage = weight.divide(noOfPackages, 2);
			//System.debug('-----Packages split due to weight limit----- : ' + noOfPackages);
			for (Integer i =0; i<noOfPackages; i++) {
				cc_bean_ShippingAttributes packageSplitShippingAttributesBean = new cc_bean_ShippingAttributes();
				if (dryIceFlag || coolerPakFlag) {
					packageSplitShippingAttributesBean.groundShippingRequired = false;					
				} else {
					packageSplitShippingAttributesBean.groundShippingRequired = newShippingAttributesBean.groundShippingRequired;
				}
				if (dryIceFlag) {
					packageSplitShippingAttributesBean.dryIceRequired = true;
				}
				if (coolerPakFlag) {
					packageSplitShippingAttributesBean.coolerPakRequired = true;
				}
				packageSplitShippingAttributesBean.overnightAirRequired = newShippingAttributesBean.overnightAirRequired;
				packageSplitShippingAttributesBean.hazardousoutside48flag = newShippingAttributesBean.hazardousoutside48flag;
				packageSplitShippingAttributesBean.weight = weightPerPackage;
				newShippingAttributesList.add(packageSplitShippingAttributesBean);
			}
		} else {
			newShippingAttributesList.add(newShippingAttributesBean);				
		}
		return newShippingAttributesList;
	}
	
	// This method visibility is public, for unit testing purposes.
	public Decimal calculateShipWeight(Decimal existingWeight, Decimal newWeight, Decimal newDryIceWeight) {
		decimal shipWeight = 0;
		if (existingWeight != null && existingWeight > 0) {
			shipWeight = existingWeight;
		}
		if (newWeight != null && newWeight > 0) {
			shipWeight = shipWeight + newWeight;
			if (newDryIceWeight != null && newDryIceWeight > 0) {
				Decimal dryIceWeight = newDryIceWeight;
				shipWeight = shipWeight + dryIceWeight;
			}
		} 
		//System.debug('-----calculateShipWeight.shipWeight-----: ' + shipWeight);
		return shipWeight;			
	}	

	// This method visibility is public, for unit testing purposes.
	public Decimal calculateWeightWithQuantity(Decimal weight, String productId) {
		Decimal qtyOrdered = 0;
		Map<String, Decimal> productQtyMap = new Map<String, Decimal>();
		for (E_CartItem__c cartItem : cartItems) {
			Decimal existingQty = 0;
			if (productQtyMap.containsKey(cartItem.Product__c)) {
				existingQty = productQtyMap.get(cartItem.Product__c);
				qtyOrdered = existingQty + cartItem.Quantity__c;
				productQtyMap.remove(cartItem.Product__c);
				productQtyMap.put(cartItem.Product__c, qtyOrdered);
			} else {
				productQtyMap.put(cartItem.Product__c, cartItem.Quantity__c);
			}
		}
		Decimal productWeight = productQtyMap.get(productId) * weight;
		//System.debug('-----calculateWeightWithQuantity-----' + productWeight);
		return productWeight;		
	}
}