//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
// 
public with sharing class cc_cnst_CloudCraze {
    //public static final String ENV_STORE = 'env';
   // public static final String BIO_STORE = cc_util_CloudCraze.application.Default_Storefront__c;

    public static final String DEFAULT_APPLICATION_NAME = 'CloudCraze';
    public static final String DEFAULT_STOREFRONT_NAME = 'DefaultStore';
    public static final String DEFAULT_ANONYMOUS_USER_NAME = 'Anonymous';
    public static final String DEFAULT_ANONYMOUS_ACCOUNT_NAME = 'AnonymousAccount';
    public static final String DEFAULT_CUSTOMER_PORTAL_ACCOUNT_NAME = 'CloudCrazePortal';
    public static final String DEFAULT_STORE_SUPPORT_URL = 'http://www.edlconsulting.com';
    public static final String DEFAULT_ROOT_CATEGORY_NAME = cc_util_CloudCraze.getDefaultStorefrontSettings().Root_Category_Name__c;
    public static final String DEFAULT_ROOT_CATEGORY_ID = cc_util_CloudCraze.getDefaultStorefrontSettings().Root_Category_ID__c; 
    public static final Decimal MAX_PROMOTION_PER_WIDGET = cc_util_CloudCraze.getDefaultStorefrontSettings().MaxPromotionsPerWidget__c;
	public static final String BASE_PRICE_LIST_NAME = cc_util_CloudCraze.getDefaultStorefrontSettings().BasePriceList__c;
	
    public static final String SHIPFROM_ZIPCODE = '68504';
    public static final String SHIPFROM_COUNTRYCODE = 'US';
    
    public static final string SR_ExactProdNum = 'Exact Product Num'; 
    public static final string SR_inProdNum = 'In Product Num'; 
    public static final string SR_inDispName = 'In Display Name'; 
    public static final string SR_inShortDesc = 'In Short Desc'; 
    public static final string SR_ManuName = 'In Manu Name'; 
    
    public static final String GROUNDFLAG = 'groundflag';
    public static final String OVERNIGHTFLAG = 'overnightflag';

    public static final String DRYICEFLAG = 'dryiceflag';
    public static final String COOLERPAKFLAG = 'coolerpakflag';

    public static final String HAZARDOUSFLAG = 'hazardousflag';
    public static final String HAZARDOUSOUTSIDE48FLAG = 'hazardousoutside48flag';

    public static final String SHIP_WEIGHT = 'weight';          
    public static final String DRYICEWEIGHT = 'dryiceweight';   
    
    public static final String PASSWORD_SENT = 'A new password was sent';
    public static final String INVALID_USERNAME_PWD = 'Invalid login or password.';
    
    public static final String ATTACHMENTS_THUMBNAIL_IMAGE_SOQL_PATTERN = '%_thumb%';
    public static final String ATTACHMENTS_STANDARD_IMAGE_SOQL_PATTERN = '%\\_%';
    public static final String ATTACHMENTS_LARGE_IMAGE_SOQL_PATTERN = '%_large%';
    public static final String ATTACHMENTS_XL_IMAGE_SOQL_PATTERN = '%_xl%';
    
     public static final String HANDLING_COST_PERCENT='20';
    
   /* public static final String PRODUCT_INCREATION_STATUS_CODE = '100';    
    public static final String PRODUCT_NOTORDERABLE_STATUS_CODE = '200';    
    public static final String PRODUCT_RELEASED_STATUS_CODE = '300';
    public static final String PRODUCT_BLOCKED_STATUS_CODE = '400'; */       

    //public static final String PRODUCT_INCREATION_STATUS_DECODE = 'In Creation';    
    //public static final String PRODUCT_NOTORDERABLE_STATUS_DECODE = 'Not Orderable';    
    //public static final String PRODUCT_RELEASED_STATUS_DECODE = 'Released';
    //public static final String PRODUCT_BLOCKED_STATUS_DECODE = 'Blocked';        

    public static final String REQUIRED_ITEMS_DIALOG_DEFAULT_TEXT = 'Check items to add to the cart';
    
   // public static final String CODETYPE_PRODUCT_STATUS = 'ProductStatus';
    
   // public static final String RELATED_PRODUCT_CROSS_SELL_DECODE = 'CrossSell';
    
    public static final String IP_ADDRESS_LOCATION_KEY = 'g';    
    public static Double MaxQty = 2147483647;
    public static final String USER_TYPE_GUEST = 'Guest';
    public static final String breadCrumbSepearator = '>';
    
    /*public static final String RuleTypeTiered = '10';
    public static final String RuleTypeStepped = '20';
    public static final String RuleTypeTieredHistorical = '30';
    public static final String RuleTypeSteppedHistorical = '40';
    public static final String RuleTypeCombination = '50';
    public static final String RuleTypeCartTotal = '60';
    public static final String RuleTypeGeneral = '70';*/

    public static final String newLine='<br/>'; 
    
    // related product types
   /* public static final String RELATED_PRODUCT_RELATED = '100';
    public static final String RELATED_PRODUCT_COMPETITIVE = '200';
    public static final String RELATED_PRODUCT_CROSS_SELL = '300';
    public static final String RELATED_PRODUCT_UP_SELL = '400';
    public static final String RELATED_PRODUCT_REQUIRED_ITEM = '500';
    
    public static final String Complimentary_Product = '100';
    public static final String Competitive_Product = '200';
    public static final String Required_Product = '500';
    
     public static final String NOT_ORDERABLE_PRODUCT='Not Orderable';
    public static final String NOT_ORDERABLE_PRODUCT_CODE='ProductStatus_200';*/
    
   // public static final String CART_TYPE_CART = '10';
   // public static final String CART_TYPE_WISHLIST = '20';
    
    // Product types
  //  public static final String PRODUCT_TYPE_PRODUCT = '10';
   // public static final String PRODUCT_TYPE_COUPON = '20';
   
   public static final String PM_ProductImage = 'Product Image';
	public static final String PM_ProductImageThumbnail = 'Product Image Thumbnail';
	public static final String PM_ProductSearchImage = 'Product Search Image';
	public static final String PM_AlternateImage = 'Alternate Images';
	public static final String PM_AlternateThumbnail = 'Alternate Thumbnails';
	public static final String PM_Datasheets = 'Datasheets';
	public static final String PM_SafeDocuments = 'Safety Documents';
	public static final String PM_SalesBrochures = 'Sales Brochures';
	public static final String PM_FlashFiles = 'Flash Files';
	public static final String PM_OwnerManuals = 'Owner Manuals';
	public static final String PM_AssemblyGuides = 'Assembly Guides';
	public static final String PMS_Attachment = 'Attachment';
	public static final String PMS_StaticResource = 'Static Resource';
	
	public static final string DISCOUNTTYPE_ABSOLUTE = 'Absolute';
	public static final string DISCOUNTTYPE_PERCENTAGE = 'Percentage';
	public static final string DISCOUNTTYPE_PRICE = 'Price';
 
    public static final String PRICELIST_SELECTION_METHOD_BEST_PRICE = 'Best Price';
    public static final String PRICELIST_SELECTION_METHOD_SEQUENCE = 'Sequence Order';
    
    public static final string VS_MyAccount_Dashboard = 'viewDashboard';
    public static final string VS_MyAccount_AccountInfo = 'viewAccountInfo';
    public static final string VS_MyAccount_ViewOrder = 'viewOrders';
    public static final string VS_MyAccount_ViewCart = 'viewCarts';
    public static final string VS_MyAccount_ViewOrderSummary = 'OrderSummary';
    public static final string VS_MyAccount_ViewCartSummary = 'CartSummary';
    
    public static final string VS_CartView = 'CartView';
    public static final string VS_OrderPaymentReview = 'OrderPaymentReview';
    public static final string VS_DetailView = 'DetailView';
    public static final string VS_OrderReview = 'OrderReview';
    public static final string VS_OrderComplete = 'OrderComplete';
    public static final string VS_InfoView = 'InfoView';
    public static final string VS_PaymentView = 'PaymentView';
    public static final string VS_ListView = 'ListView';
    public static final string VS_SearchResultsView = 'SearchResultsView';
    public static final string VS_PromotionView = 'PromotionView';
    public static final string VS_LandingPage = 'LandingPage';
    public static final string VS_QuickOrder = 'QuickOrder';
    public static final string VS_ConfigListView = 'ConfigListView';
    public static final string VS_ShipRequestView = 'ShipRequestView';
    public static final string VS_ShipOptionsView = 'ShipOptionsView';
    
    public static final string PL_LandingPage = 'Landing Page';
    public static final string PL_ProductDetail = 'Product Detail';
    public static final string PL_ShoppingCart = 'Shopping Cart';
    public static final string PL_OrderReview = 'Order Review';
    public static final string PL_OrderConfirmation = 'Order Confirmation';
    public static final string PL_ProductListPage = 'Product List Page';
    public static final string PL_CategoryLandingPage = 'Category Landing Page';
    public static final string PL_AllPages = 'All Pages';
   
    public static final string NT_BillingAddress='MockBillingAddress';
    public static final string NT_ShippingAddress='MockShippingingAddress';
    public static final string NT_PONumber='PONUmber';
    public static final string NT_SelectedPaymentType='SelectedPaymentType';
    public static final string NT_SelectedShippingOption='SelectedShippingOption';
    public static final string NT_SelectedShippingOptionObj='SelectedShippingOptionObj';
    
    //Constants for UI
    public static final String UI_GLOBAL_OVERRIDESTATICRESOURCE='OverrideStaticResource';
    /* address book mod BEGIN by roy */
    public static final string ECommType_B2B='B2B';
    public static final string ECommType_B2C='B2C';
    public static final string ECommType_Mixed='Mixed';
    public static final string AddressType_Shipping='Shipping';
    public static final string AddressType_Billing='Billing';
    /* address book mod END by roy */
}