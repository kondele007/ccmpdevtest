/**
// * Created by CloudCraze, LLC.
// * Copyright 2010-12 CloudCraze, LLC. All rights reserved
// * @Description: Extension to handle customized related item retrieval.
// * @Author: 1.0
// * @File: cc_ctrl_Order
// * =======================================================================================
// * 2012/10/09 1.1 IL -  Refactored
// * 2012/10/09 1.1 IL -  Customized
**/
public with sharing class cc_ctrl_Order extends cc_ctrl_CloudCraze {
    public cc_ctrl_Order getOrderController() { return this; }
	public cc_bean_MockOrder mockOrder {get;set;}
	public List<cc_bean_MockOrderItem> mockOrderItems {get;set;}
	public String fromPage {get;set;}
	public Boolean orderHasCouponLineItem {
		get {
			if (orderHasCouponLineItem == null)
				orderHasCouponLineItem = false;
			return orderHasCouponLineItem;
		}
		set;
	}
	
	/** Kaplan Phase 1 Begin */
	public Boolean printViewEnabled{get; private set;}	 
	public Boolean elementViewYourOrderAmountDue{get; private set;}	
	public Boolean elementViewThanksSignUp{get; private set;}
	public Boolean elementViewSocialEnabled{get; private set;}
	public Boolean elementViewAddCalendarEnabled{get; private set;}
	public Boolean elementViewEventInfo{get; private set;}
	public Boolean elementViewGoogleMaps{get; private set;}
	public Boolean elementViewLiveOnlineEventText{get; private set;}	
	public Boolean elementViewReminderEmailForClass{get; private set;}
	public Boolean elementViewReminderEmailForEvent{get; private set;}
	public Boolean elementViewGeneralStudentInfo{get; private set;}
	public Boolean orderHasShipment{get; private set;}
	public boolean isFreeEventOnlyOrder { get; private set; }
	public static cc_kap_utils_AppConstants appConstants { get; set; }
	public cc_bean_MockOrderItem primaryEvent { get; private set; }
	public cc_bean_MockContactAddress facilityBean {get; private set; } 
	public String shipMethods {get; private set; }
	public String programCode{get; set;} // Case # 00001814 ----- cw ----- 
    public String kbsProgramCodes{get; set;} // Case # 00001814 ----- cw ----- 
	
	/**
	 * Processes the incoming order id, and initializes the controller with the 
	 * necessary variables to handle the display of the order information.
	 */
	public cc_ctrl_Order() {
		String encryptedOrderId = Apexpages.currentPage().getParameters().get(cc_cnst_UrlParams.ORDER_ENC_ID);
		if (encryptedOrderId == null || encryptedOrderId.trim().length() == 0) {
            this.messages.add(Label.Cart_Error_OrderNotFound);
            throw new OrderException(Label.Cart_Error_OrderNotFound + ' Id:' + EncodingUtil.base64Decode(encryptedOrderId).toString());
			return;
		}
		this.removeCurrentCart();
		this.fromPage = Apexpages.currentPage().getParameters().get(cc_cnst_UrlParams.FROM_PAGE);
		this.elementViewSocialEnabled = false;
		this.elementViewAddCalendarEnabled = false;
		this.elementViewEventInfo = false;
		this.elementViewThanksSignUp = false;
		this.elementViewGoogleMaps = false;
		this.elementViewLiveOnlineEventText = false;
		this.elementViewYourOrderAmountDue =false;
		this.elementViewGeneralStudentInfo =false;
		this.elementViewReminderEmailForClass = false;
		this.elementViewReminderEmailForEvent = false;
		init(encryptedOrderId);
		String sPrintView = Apexpages.currentPage().getParameters().get('printView');
    	this.printViewEnabled = (sPrintView != null && sPrintView == 'true');
	}
	
	/**
	 * Initializes the order objects in the controller, retrieving the order wrapper
	 * and order item wrappers. Handles setup of all necessary attributes needed
	 * to process the functionality in the controller and page.
	 * @param encrypted id of the order to retrieve
	 */
	public void init(String encryptedOrderId) {
	 	cc_util_Order orderUtils = new cc_util_Order();
	 	orderUtils.encrytpedId = encryptedOrderId;
	 	this.mockOrder = orderUtils.retrieveFullOrderData(true);
	 	if (mockOrder == null) {
            this.messages.add(Label.Cart_Error_OrderNotFound);
            throw new OrderException(Label.Cart_Error_OrderNotFound + ' Id:' + EncodingUtil.base64Decode(encryptedOrderId).toString());
			return;
		}
		this.mockOrder.encryptedId = encryptedOrderId;
		this.mockOrderItems = mockOrder.orderItems;
		this.orderHasShipment = mockOrder.displayRulesApi.cartHasSpec(cc_kap_utils_AppConstants.SPEC_SHIPPABLE, '1');
		this.isFreeEventOnlyOrder = cc_kap_utils_Cart.isFreeEventCart(mockOrder.displayRulesApi.cartLines);
		this.orderHasCouponLineItem = orderUtils.orderHasCouponLineItem;
        determinePrimaryEvent(); 
        processDeliveryTypes(mockOrder.displayRulesApi.getSpecValues(cc_kap_utils_AppConstants.SPEC_DELIVERY_TYPE), this.isFreeEventOnlyOrder, this.primaryEvent);
        this.shipMethods = getShippingMethods();

        /************* CASE # 1732 - Begin ************/
        
        Set<String> programCodes = mockOrder.displayRulesApi.getSpecValues(cc_kap_utils_AppConstants.SPEC_PROGRAM_CODE);
        List<String> codes = new List<String>();
        if (programCodes != null) {
            codes.addAll(programCodes);
            programCode = codes.get(0);                 
        }

        List<E_CartItem__c> cartItems = cc_dao_cart.getDisplayCartItems(this.mockOrder.dataObject.OriginatedCart__r.EncryptedId__c);

        if(this.mockOrderItems != null && cartItems != null){
        	for(cc_bean_MockOrderItem moi : this.mockOrderItems){
        		for(E_CartItem__c ci : cartItems){
        			if(moi.sku == ci.Product__r.SKU__c){

        				List<E_CartItem__c> cartItem = new List<E_CartItem__c>();
                		cartItem.add(ci);

        				cc_kap_api_rules_CartRules cartRulesAPI = new cc_kap_api_rules_CartRules(cartItems);

        				//Set<String> kbsProgramCodeSet = mockOrder.displayRulesApi.getSpecValues(cc_kap_utils_AppConstants.SPEC_KBS_PROGRAM_CODE);
        				Set<String> kbsProgramCodesSet = mockOrder.displayRulesApi.getSpecValues(cc_kap_utils_AppConstants.SPEC_KBS_PROGRAM_CODE);
                        Set<String> kbsProgramCodeSet = cartRulesAPI.getSpecValues(cc_kap_utils_AppConstants.SPEC_KBS_PROGRAM_CODE);
                        
                		List<String> kbsProgramCodeList = new List<String>();
                		List<String> kbsProgramCodesList = new List<String>(); 
                		if(kbsProgramCodeSet != null){
                    		kbsProgramCodeList.addAll(kbsProgramCodeSet);
                            kbsProgramCodesList.addAll(kbsProgramCodesSet);
                            moi.kbsProgramCode = kbsProgramCodeList.get(0);

                            // Case # 00001814 ----- Begin ----- cw -----  
                            kbsProgramCodes = '';                           
                            kbsProgramCodes = kbsProgramCodeList.get(0);

                            if(kbsProgramCodesList.size() > 1){
                                for(integer i = 1; i <= kbsProgramCodesList.size() - 1; i++){
                                    kbsProgramCodes = kbsProgramCodes + ',' + kbsProgramCodesList.get(i);
                                }
                            }         
                            kbsProgramCodes.trim();
                            // Case # 00001814 ----- End ----- cw -----
                		}   

        			}
        		}
        	}
        } 

        /************* CASE # 1732 - End ************/
        //printState();
	}
	
	/**
	 * Processes the delivery types to control the elements hidden and displayed
	 * in the page.
	 * @param deliveryTypes  Set of delivery types in string form
	 */
	private void processDeliveryTypes(Set<String> deliveryTypeList, boolean isFreeEventOnlyOrder, cc_bean_MockOrderItem primaryEvent) {
		if (deliveryTypeList != null && deliveryTypeList.size() > 0) {
			if (isFreeEventOnlyOrder) { // If this is a free event only cart then show event specific info, else show order data 
				elementViewYourOrderAmountDue = false;
				elementViewGeneralStudentInfo = false;
				elementViewThanksSignUp = true;				
			} 
			else {
				elementViewYourOrderAmountDue = true;
				elementViewGeneralStudentInfo = true;
				elementViewThanksSignUp = false;
			}
			if (deliveryTypeList.contains(String.valueOf(cc_kap_utils_AppConstants.DELIV_TYPE_CENTER_BASED)) || 
				deliveryTypeList.contains(String.valueOf(cc_kap_utils_AppConstants.DELIV_TYPE_LIVE_ONLINE))) {
	        	elementViewReminderEmailForClass = true;
	        }
			if (primaryEvent != null) {  // If order has an event then use the primaryEvent's delivery type to drive behavior
				deliveryTypeList.clear(); 
				deliveryTypeList.add(primaryEvent.deliveryTypeCode.format());
				if (deliveryTypeList.contains(String.valueOf(cc_kap_utils_AppConstants.DELIV_TYPE_ONLINE_EVENTS))) {
		        	elementViewSocialEnabled = true;
		        }
		        if ((deliveryTypeList.contains(String.valueOf(cc_kap_utils_AppConstants.DELIV_TYPE_LIVE_ONLINE_EVENTS)))
		        	|| (deliveryTypeList.contains(String.valueOf(cc_kap_utils_AppConstants.DELIV_TYPE_CENTER_BASED_EVENTS)))) {
		        	
		        	boolean isLiveOnlineEvent = mockOrder.displayRulesApi.getDisplayRuleBean(primaryEvent.sku).line.Product__r.IsLiveOnlineEvent__c;
					elementViewSocialEnabled = true;
					elementViewAddCalendarEnabled = true;
					elementViewEventInfo = true;
					elementViewReminderEmailForEvent = true;
					if(isLiveOnlineEvent) {
						elementViewLiveOnlineEventText = true;
					} else {
						elementViewGoogleMaps = true;
					}
		        }
			}	      
        }
	}	
	
	/**
	 * Determines the primary event for this order.  If the order contains any
	 * event based products, this method will determine the primary one and
	 * assign that to a variable used in the page to display the primary event.
	 * Currently, the primary event is the first event found in the order.
	 */
	private void determinePrimaryEvent() {
		for (cc_bean_MockOrderItem orderItemWrapper: mockOrderItems) {
			if (!al.StringUtils.isBlank(orderItemWrapper.eventType)) {
				this.primaryEvent = orderItemWrapper;
				break;
			}
		}
		if (this.primaryEvent != null) {
			if(primaryEvent.startDate != null) {
				primaryEvent.startDateStrET = primaryEvent.startDate.format('MMMMMM dd, yyyy hh:mm a', 'America/New_York');
			}
			if(primaryEvent.endDate != null) {
				primaryEvent.endDateStrET = primaryEvent.endDate.format('hh:mm a', 'America/New_York');
			}
			
			Decimal facilityId = mockOrder.displayRulesApi.getDisplayRuleBean(primaryEvent.sku).line.Product__r.FacilityId__c;
			List<Facility__c> facilities = [Select Name, Address1__c, Address2__c, City__c, State__c, ZIP__c From Facility__c Where ID__c = :facilityId Limit 1];
			if (facilities.size() > 0) {
				Facility__c facility = facilities.get(0);
				facilityBean = new cc_bean_MockContactAddress();
				facilityBean.companyName = facility.Name;
				facilityBean.address1 = facility.Address1__c;
				facilityBean.address2 = facility.Address2__c;
				facilityBean.city = facility.City__c;
				facilityBean.state = facility.State__c;
				facilityBean.postalCode = facility.ZIP__c;
			}
		}
	}
	
	private String getShippingMethods() {
		Set<String> existingMethods = new Set<String>();
		String methods = '';
		for (cc_bean_MockOrderItem orderItemWrapper: mockOrderItems) {
			if ((orderItemWrapper.shipMethod != cc_kap_utils_AppConstants.SHIP_NONE) && !existingMethods.contains(orderItemWrapper.shipMethod)) {
				if (methods != '')
					methods += ', ';
				methods += orderItemWrapper.shipMethod;
				existingMethods.add(orderItemWrapper.shipMethod);
			}
		}
		return methods;
	}
	 
	private void printState() {
		System.debug('$$$$$$$$$$THANK YOU PAGE STATE$$$$$$$$$$');
	 	System.debug('$$$$$$$$$$DeliveryTypes: '+mockOrder.displayRulesApi.getSpecValues(cc_kap_utils_AppConstants.SPEC_DELIVERY_TYPE));
	 	System.debug('$$$$$$$$$$elementViewSocialEnabled: '+this.elementViewSocialEnabled);
		System.debug('$$$$$$$$$$elementViewAddCalendarEnabled: '+this.elementViewAddCalendarEnabled);
		System.debug('$$$$$$$$$$elementViewEventInfo: '+this.elementViewEventInfo);
		System.debug('$$$$$$$$$$elementViewThanksSignUp: '+this.elementViewThanksSignUp);
		System.debug('$$$$$$$$$$elementViewGoogleMaps: '+this.elementViewGoogleMaps);
		System.debug('$$$$$$$$$$elementViewLiveOnlineEventText: '+this.elementViewLiveOnlineEventText);
		System.debug('$$$$$$$$$$elementViewYourOrderAmountDue: '+this.elementViewYourOrderAmountDue);
		System.debug('$$$$$$$$$$elementViewGeneralStudentInfo: '+this.elementViewGeneralStudentInfo);
		System.debug('$$$$$$$$$$orderHasShipment: '+this.orderHasShipment);
		System.debug('$$$$$$$$$$isFreeEventOnlyOrder: '+this.isFreeEventOnlyOrder);
		System.debug('$$$$$$$$$$Primary Event: '+this.primaryEvent);
	 }
	 
	 /** Kaplan Phase 1 End */
	public class OrderException extends Exception{
	 }
	 	 
	 
 /*   //==================================================
    // CONSTRUCTORS
    //==================================================
	public cc_ctrl_Order(boolean old) {
		String encryptedOrderId = Apexpages.currentPage().getParameters().get(cc_cnst_UrlParams.ORDER_ENC_ID);
		String maskedCard = Apexpages.currentPage().getParameters().get('cardNumber');
		// handle missing order id
		if(encryptedOrderId == null || encryptedOrderId.trim().length() == 0) {
            this.messages.add(Label.Cart_Error_OrderNotFound);
            throw new OrderException(Label.Cart_Error_OrderNotFound + ' Id:' + EncodingUtil.base64Decode(encryptedOrderId).toString());
			return;
		}
		
		E_Order__c eOrder = cc_dao_Order.getOrderByEncId(encryptedOrderId);

		// handle missing order
		if(eOrder == null) {
            this.messages.add(Label.Cart_Error_OrderNotFound);
            throw new OrderException(Label.Cart_Error_OrderNotFound + ' Id:' + EncodingUtil.base64Decode(encryptedOrderId).toString());
			return;
		}
		
		// create bean for use in the visualforce page
		mockOrder = new cc_bean_MockOrder(eOrder);
		
		populateMockOrderItems();
		mockOrder.encryptedId = encryptedOrderId;
    	fromPage = Apexpages.currentPage().getParameters().get(cc_cnst_UrlParams.FROM_PAGE);
    	
	    elementViewSocialEnabled = false;
		elementViewAddCalendarEnabled = false;
		elementViewEventInfoEnabled = false;
		elementViewThanksSignUp = false;
		elementViewWhatHappensNext = false;	
		elementViewGoogleMaps = false;
		elementViewEventText = false;
		elementViewYourOrderAmountDue =false;
		elementViewGeneralStudentInfo =false;
		
		Integer deliveryType;
		deliveryTypeList.clear();
		for(cc_bean_mockOrderItem item : mockOrderItems)
		{
			deliveryType = item.deliveryTypeCode;
			//deliveryTypeList.add(item.deliveryTypeCode);
			System.debug('DeliveryType: ' + deliveryType);
			
			orderHasShipment = false;
			
			if(deliveryType == cc_kap_utils_AppConstants.DELIV_TYPE_ONLINE_EVENTS) //online
			{
			  elementViewThanksSignUp = true;
			  elementViewSocialEnabled = true;
			  elementViewWhatHappensNext = true;
			}
			else if(deliveryType == cc_kap_utils_AppConstants.DELIV_TYPE_LIVE_ONLINE_EVENTS) //live online
			{
			  elementViewThanksSignUp = true;
			  elementViewSocialEnabled = true;
			  elementViewAddCalendarEnabled = true;
			  elementViewWhatHappensNext = true;
			  elementViewEventInfoEnabled = true; 	
			  elementViewEventText = true;
			}
			else if(deliveryType == cc_kap_utils_AppConstants.DELIV_TYPE_CENTER_BASED_EVENTS) //center based
			{
			  elementViewThanksSignUp = true;
			  elementViewSocialEnabled = true;
			  elementViewAddCalendarEnabled = true;
			  elementViewWhatHappensNext = true;
			  elementViewEventInfoEnabled = true; 	
			  elementViewGoogleMaps = true;
			}
			else   // regular
			{
			 elementViewYourOrderAmountDue =true;
			 elementViewWhatHappensNext = true;
			 elementViewGeneralStudentInfo= true;			 
			}
		}
		
    	String sPrintView = Apexpages.currentPage().getParameters().get('printView');
    	if(sPrintView != null && sPrintView == 'true')
    		printViewEnabled = true;
    	else
    		printViewEnabled = false;
	}*/

	/**
	 *  Gets the order items as mockOrderItems
	 *  TODO: refactor - move soql to a dao
	 **/
	 
    /*private void populateMockOrderItems() {
        mockOrderItems = null;

        if(mockOrder != null) {
        	mockOrderItems = new List<cc_bean_MockOrderItem>();

            List<E_OrderItem__c> orderItems = [
                select SubAmount__c, StoreId__c, Quantity__c, Product__r.SKU__c,
                    Category__r.Name, Product__r.ProductId__c, Product__r.Name,
                    Product__c, Price__c, Name, OrderLineType__c, Coupon__c,
                    Coupon__r.Rule__r.Name__c, AbsoluteDiscount__c, AmountPaid__c,
                    (select Quantity__c, Price__c, SubAmount__c
                        from CC_Order_Item_Pricing_Tiers__r
                        order by Price__c desc
                    )
                from E_OrderItem__c
                where Order__c = :mockOrder.sfid
            ];
             
            for(E_OrderItem__c item : orderItems) {
                mockOrderItems.add(new cc_bean_MockOrderItem(item));
                if (item.OrderLineType__c == 'Coupon') {
                 	orderHasCouponLineItem = true;
                }
            }
        }
    }*/
}