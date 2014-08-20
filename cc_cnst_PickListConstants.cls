//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_cnst_PickListConstants {
	public static final string CARTITEM_PRODUCT = 'Product;';
	public static final string CARTITEM_COUPON = 'Coupon'; 
	public static final string CARTSTATUS_ABANDONED = 'Abandoned';
	public static final string CARTSTATUS_CLOSED = 'Closed';
	public static final string CARTSTATUS_OPEN = 'Open';
	public static final string CARTTYPE_WISHLIST = 'WishList';
	public static final string CARTTYPE_CART = 'Cart';
	public static final string MEDIATYPE_ALTERNATEIMAGES = 'Alternate Images';
	public static final string MEDIATYPE_ALTERNATETHUMBNAILS = 'Alternate Thumbnails';
	public static final string MEDIATYPE_DATASHEETS = 'Datasheets';
	public static final string MEDIATYPE_SAFETYDOCUMENTS = 'Safety Documents';
	public static final string MEDIATYPE_SALESBROCHURES = 'Sales Brochures';
	public static final string MEDIATYPE_PRODUCTSEARCHIMAGE= 'Product Search Image';
	public static final string MEDIATYPE_OWNERSMANUALS = 'Owner\'s Manuals';
	public static final string MEDIATYPE_ASSEMBLYGUIDES = 'Assembly Guides'; 
	public static final string MEDIATYPE_JPGIMAGE = 'JPG Image';
	public static final string MEDIATYPE_PRODUCTIMAGE = 'Product Image';
	public static final string MEDIATYPE_PRODUCTIMAGETHUMBNAIL = 'Product Image Thumbnail';
	public static final string MEDIATYPE_FLASHFILES = 'Flash Files';
    public static final string MEDIASOURCE_ATTACHMENT = 'Attachment';
    public static final string MEDIASOURCE_STATICRESOURCE = 'Static Resource';
    public static final string MEDIASOURCE_URI = 'URI';
	public static final string ORDERSTATUS_OPEN = 'Open';
	public static final string ORDERSTATUS_ORDERSUBMITTED = 'Order Submitted';
	public static final string ORDERSTATUS_CANCELSUBMITTED = 'Cancel Submitted';
	public static final string ORDERSTATUS_CANCELLED = 'Cancelled';
	public static final string ORDERSTATUS_COMPLETED = 'Completed';
	public static final string ORDERSTATUS_SHIPPED = 'Shipped';
	public static final string ORDERSTATUS_RETURNSUBMITTED = 'Return Submitted';
	public static final string ORDERSTATUS_RETURNED = 'Returned';
	public static final string ORDERSTATUS_INPROCESS = 'In Process';
	public static final string ORDERSTATUS_PARTIALSHIPPED = 'Partial Shipped';
	public static final string ORDERSTATUS_BILLOFMATERIAL = 'Bill Of Material';
	public static final string ORDERSTATUS_ONHOLD = 'On Hold';
	public static final string PRODUCTSTATUS_BLOCKED = 'Blocked';
	public static final string PRODUCTSTATUS_NOTORDERABLE = 'Not Orderable';
	public static final string PRODUCTSTATUS_RELEASED = 'Released';
	public static final string PRODUCTSTATUS_INCREATION = 'In Creation';
	public static final string PRODUCTTYPE_PRODUCT = 'Product';
	public static final string PRODUCTTYPE_COUPON = 'Coupon';
	public static final string RATINGCODE_ONE = 'One';
	public static final string RATINGCODE_TWO = 'Two';
	public static final string RATINGCODE_THREE = 'Three';
	public static final string RATINGCODE_FOUR = 'Four';
	public static final string RATINGCODE_FIVE = 'Five';
	public static final string RELATEDPRODUCT_COMPETITIVE = 'Competitive';
	public static final string RELATEDPRODUCT_RELATED = 'Related';
	public static final string RELATEDPRODUCE_REQUIREDITEM = 'RequiredItem';
	public static final string RELATEDPRODUCT_CROSSSELL = 'CrossSell';
	public static final string RELATEDPRODUCT_UPSELL = 'UpSell';
	public static final string RULETYPE_STEPPEDHISTORY = 'SteppedHistory';
	public static final string RULETYPE_COMBINATION = 'Combination';
	public static final string RULETYPE_CARTTOTAL = 'CartTotal';
	public static final string RULETYPE_GENERAL = 'General';
	public static final string RULETYPE_SHIPPING = 'Shipping';
	public static final string RULETYPE_TIEREDHISTORY = 'TieredHistory';
	public static final string RULETYPE_STEPPED = 'Stepped';
	public static final string RULETYPE_TIERED = 'Tiered';
	public static final string UNITOFMEASURE_EACH = 'Each';
	public static final string VALUETYPE_DISCOUNT = 'Discount';
	public static final string VALUETYPE_ABSOLUTE = 'Absolute';
	public static final string RULERELATION_SKU   = 'Product';
	public static final string RULERELATION_SPEC  = 'SPEC';
	
	public static final String HTML_CACHE_TYPE_CATEGORY = 'Category Tree';
	public static final String HTML_CACHE_TYPE_MENU = 'Top Menu';
	
	public static final String MENU_LINK_TYPE_NONE = 'None';
	public static final String MENU_LINK_TYPE_CATEGORY = 'Category';
	public static final String MENU_LINK_TYPE_PRODUCT = 'Product';
	public static final String MENU_LINK_TYPE_URL = 'URL';
	static testMethod void myUnitTest() {
	 	system.assert(cc_cnst_PickListConstants.MENU_LINK_TYPE_URL == 'URL');
	 }
}