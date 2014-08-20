public with sharing class ktp_cc_GR_utils_AppConstants {
	public static final String COOKIE_LAST_ADDED_ID = 'lastAddedId';
	public static final String COOKIE_LAST_ADDED_PRODUCT = '__productName';
	public static final String COOKIE_CURR_CART_ID = 'currentCartID';
	public static final String COOKIE_CART_ITEM_COUNT = 'cartItemCount';
	public static final String COOKIE_PROGRAM_OF_INTEREST = 'programCode';
	public static final String COOKIE_CART_SHIPPING_FLAG = 'cartShippingFlag';
	
	public static final String SPEC_SHIPPABLE = 'HSKEnabled';
	
	/***** CASE # 1660 - Begin *****/
	
	public static final String SPEC_KBS_PROGRAM_CODE = 'KbsProgramCode';
	
	/***** CASE # 1660 - End *****/
	
	public static final String SPEC_FREE_SHIP = 'FreeShip';
	public static final String SPEC_DELIVERY_TYPE = 'DeliveryType';
	public static final String SPEC_BILL_INSTALLMENTS = 'BillingInstallments';
	public static final String SPEC_FLEX_TYPE = 'FlexStartDateType';
	public static final String SPEC_FLEX_START_DURATION = 'FlexStartDateMaxDuration';
	public static final String SPEC_PROGRAM_CODE = 'ProgramCode';
	public static final String SPEC_REGION = 'Country';
	public static final String SPEC_SBU = 'SBU';
	
	public static final String PROG_CODE_BAR_REVIEW = '94000325'; //Bar Review
	
	public static final String TOTALS_UPFRONT = 'Upfront';
	public static final String TOTALS_SUBSCRIPTION = 'Subscription';
	public static final String TOTALS_INSTALLS = 'Installments';
	public static final String TOTALS_GRAND = 'GrandTotal';
	public static final String TOTALS_SHIPPING = 'TotalShipping';
	
	public static final String COUNTRY_USA = 'United States';
	public static final String COUNTRY_USA_ABBREV = 'US';
	public static final String COUNTRY_CANADA = 'Canada';
	public static final String COUNTRY_CANADA_ABBREV = 'CA';
	
	public static final String SHIP_STANDARD = 'STND';
	public static final String SHIP_EXPEDITED = 'EXP';
	public static final String SHIP_NONE = 'NONE';
	public static final Integer SHIP_DAYS_FOR_EXPEDITED = 7;
	
	public static final String REQUEST_PARAM_CCNUM = 'cardNumber';
	
	public static final Set<String> PAYMENT_AVS_ERROR_CODES = new Set<String> { 'C', 'I', 'K', 'N' };
	public static final Set<String> PAYMENT_CV_ERROR_CODES = new Set<String> { 'D', 'I', 'N' };
	
	public static final String TRANS_CODE_FULL_TUITION_ENROLL = '400';
	public static final String TRANS_CODE_DISCOUNT_ENROLL = '403';
	public static final String TRANS_CODE_MARKETING_EVENT = '408';
	public static final String TRANS_CODE_FREE_BUNDLE = '409';
	
	public static final Integer DELIV_TYPE_ADMISSION_CONSULTING = 1;
	public static final Integer DELIV_TYPE_CENTER_BASED = 2;
	public static final Integer DELIV_TYPE_ONLINE = 3;
	public static final Integer DELIV_TYPE_TUTORING = 4;
	public static final Integer DELIV_TYPE_SELF_STUDY = 5;
	public static final Integer DELIV_TYPE_CENTER_BASED_EVENTS = 6;
	public static final Integer DELIV_TYPE_ONLINE_EVENTS = 7;
	public static final Integer DELIV_TYPE_BOE = 8;
	public static final Integer DELIV_TYPE_KAP_ITEMS = 9;
	public static final Integer DELIV_TYPE_LIVE_ONLINE = 11;
	public static final Integer DELIV_TYPE_SIT = 12;
	public static final Integer DELIV_TYPE_LIVE_ONLINE_EVENTS = 13;
	public static final Integer DELIV_TYPE_SELF_STUDY_AT_CENTER = 14;
	public static final Integer DELIV_TYPE_ZIPLESS_CENTER_BASED = 15;
	
	public static final String DEFAULT_CENTER_CODE = '0068';
	public static final String DEFAULT_GRAD_CENTER_CODE = '0579';
	public static final String DEFAULT_PC_CENTER_CODE = '0912';
	public static final String DEFAULT_HEALTH_CENTER_CODE = '7010'; //Nursing 7034
	public static final String DEFAULT_BAR_CENTER_CODE = '0795';
	
	public static final String SBU_GRAD = '3';
	public static final String SBU_PC = '4';
	public static final String SBU_HEALTH = '5';
	public static final String SBU_BAR = '6';
	
	public static final String DEFAULT_BILLING_POSTAL_CODE = '10018';
	//IB Fee
	public static final String IB_FEE_CATEGORY_ID = '99999';
	public static final String IB_FEE_SPEC_CURRENCY = 'Currency';
	public static final String IB_FEE_SPEC = 'IBFee';
	public static final String PAGE_UI_KEY_CART = 'ca';
	public static final Decimal TOTAL_INSTALLMENTS = 3.0;
}