/**
// * Created by CloudCraze, LLC.
// * Refactored from cc_ctrl_Order
// * 2012/10/09 1.1 IL -  Customized
**/
global without sharing class cc_util_OrderEmail {
	global String encryptedOrderId{get; set;}
    public cc_util_OrderEmail getOrderController() { return this; }
    private boolean initialized{get; set;}
	public cc_bean_MockOrder mockOrder {get{if(!initialized){initialized = true; getInit();} return this.mockOrder;}set;}
	public List<cc_bean_MockOrderItem> mockOrderItems {get;set;}
	public String fromPage {get;set;}
	public Boolean orderHasCouponLineItem {
		get {
			if (orderHasCouponLineItem == null)
				orderHasCouponLineItem = false;
			return orderHasCouponLineItem;
		}
		private set;
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
	public String store {get; set;}
	public E_StorefrontSettings__c storefront {get; private set;}
	
	public cc_util_OrderEmail() {
    	store = cc_util_CloudCraze.application.Default_Storefront__c;
    	storefront = cc_util_CloudCraze.getStorefrontSettings(store);
		this.printViewEnabled = true;
		this.initialized = false;
	}
	
	/**
	 * Initializes the order objects in the controller, retrieving the order wrapper
	 * and order item wrappers. Handles setup of all necessary attributes needed
	 * to process the functionality in the controller and page.
	 * @param encrypted id of the order to retrieve
	 */
	public String getInit() {
		this.fromPage = '';
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
	 	cc_util_Order orderUtils = new cc_util_Order();
	 	orderUtils.encrytpedId = this.encryptedOrderId;
	 	this.mockOrder = orderUtils.retrieveFullOrderData(true);
		this.mockOrder.encryptedId = encryptedOrderId;
		this.mockOrderItems = mockOrder.orderItems;
		this.orderHasShipment = mockOrder.displayRulesApi.cartHasSpec(cc_kap_utils_AppConstants.SPEC_SHIPPABLE, '1');
		this.isFreeEventOnlyOrder = cc_kap_utils_Cart.isFreeEventCart(mockOrder.displayRulesApi.cartLines);
		this.orderHasCouponLineItem = orderUtils.orderHasCouponLineItem;
        determinePrimaryEvent(); 
        processDeliveryTypes(mockOrder.displayRulesApi.getSpecValues(cc_kap_utils_AppConstants.SPEC_DELIVERY_TYPE), this.isFreeEventOnlyOrder, this.primaryEvent);
        this.shipMethods = getShippingMethods();
        return '';
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
		/*
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
		*/
	 }
	 
	 /** Kaplan Phase 1 End */
	public class OrderException extends Exception{
	 }
	 	 
}