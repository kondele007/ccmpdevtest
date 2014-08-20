//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
//**
// * @Description: Data Persistency for Product Media Custom Object
// * @Author: 1.0
// * @File: cc_dao_ProductMedia
// * ==========================================================
// * 2009/06/08 1.0 IL - Created.
// **/

public with sharing class cc_dao_ProductMedia {
	//==================================================
    // CONSTRUCTOR
    //==================================================
    //Default Constructor     
    public cc_dao_ProductMedia() {
    }
    
    //==================================================
    // SERVICE METHODS
    //==================================================
    public List<E_ProductMedia__c> readProduct(String productId) {     
        List<E_ProductMedia__c> productMediaList = [Select e.EndDate__c,
        													e.Id,
        													e.AltMessage__c,
        													e.Product__c,
        													e.Product__r.Id,
        													e.Sequence__c,
        													e.StartDate__c,
        													e.URI__c,
        													e.MediaType__c
    													from E_ProductMedia__c e
    													where e.Product__r.Id =:productId
    													order by e.Sequence__c];
        return productMediaList;
    }
    
    public List<E_ProductMedia__c> saveProductMedia(List<E_ProductMedia__c> productMediaList) {
        upsert productMediaList;
        return productMediaList;
    }

    public void deleteProductMedia(String productId) {
        List<E_ProductMedia__c> productMediaList = [Select e.Id
        											from E_ProductMedia__c e
        											where e.Product__r.Id =:productId];
        if(productMediaList .size() > 0) {
            delete productMediaList ;
        }
    }

    /**
     *  LICOR
     *  Gets attachments that belong to the products in the productIdList
     *  with names matching the pattern specified. The pattern is used in the
     *  LIKE clause.
     **/
    public static Map<Id,Id> getAttachmentsForProductList(List<Id> productIdList, String pattern) {
        return getAttachmentsForProductList(productIdList, pattern, false);
    }
    
    /**
     *  LICOR
     *  Gets attachments that belong to the products in the productIdList
     *  with names matching the pattern specified. The pattern is used in the
     *  LIKE clause. If exclude is true, the LIKE clause with be NOT LIKE.
     *
     *  Leave pattern as null to get all attachments for the products
     **/
    public static Map<Id,Id> getAttachmentsForProductList(List<Id> productIdList, String pattern, boolean exclude, String locale) {
        
        for(Id pid : productIdList) {
            //System.debug('--- pid: ' + pid + ' ---');
        }
        
        // Get List of E_ProductMedia__c IDs
        List<E_ProductMedia__c> media = [select e.Id,e.Product__c from E_ProductMedia__c e where e.isDeleted = false and e.Product__c in :productIdList and locale__c = :locale];
         
        Map<Id,Id> productMediaMap = new Map<Id,Id>();
        Map<Id,Id> attachmentMap = new Map<Id,Id>();
        //System.debug('--- media size: ' + media.size() + ' ---');
        List <Id> mediaIds = new List<Id>();
        
        if(media.size() > 0) {
            for(E_ProductMedia__c prodmed : media) {
                productMediaMap.put(prodmed.Id, prodmed.Product__c);
                mediaIds.add(prodmed.Id);
            }
            
            if(al.StringUtils.isBlank(pattern)) {
                pattern = '%';
            }
            
            // Get list of Attachment IDs
            List<Attachment> attachmentList = null;
            if(exclude) {
                attachmentList = [select a.Id,a.Name,a.ParentId from Attachment a where a.ParentId in :mediaIds and (not a.Name like :pattern)];
            } else {
                attachmentList = [select a.Id,a.Name,a.ParentId from Attachment a where a.ParentId in :mediaIds and a.Name like :pattern];
            }
            //System.debug('--- attachmentList size: ' + attachmentList.size() + ' ---');
            
            // The media ID is the parent ID, so use ParentID to look up the product 
            if(attachmentList != null && attachmentList.size() > 0){
                for(Attachment a: attachmentList) {
                    Id productId = productMediaMap.get(a.ParentId);
                    if(productId != null && !attachmentMap.containsKey(productId)) {
                        attachmentMap.put(productId, a.Id);
                    }
                }
            }
        }
        return attachmentMap;
    }

    public static Map<Id,Id> getAttachmentsForProductList(List<Id> productIdList, String pattern, boolean exclude) {
        return getAttachmentsForProductList(productIdList, pattern, exclude, cc_util_Locale.getUserLanguage()); 
    }
    
    public Map<String, List<cc_bean_MediaWrapper>> getProductMediaByType(String productId) {
        return getProductMediaByType(productId, cc_util_Locale.getUserLanguage());
	}
   	
   	public Map<String, List<cc_bean_MediaWrapper>> getProductMediaByType(String productId, String locale) {
        //key = ProductMediaType
        Map<String, List<cc_bean_MediaWrapper> > mediaMap = new Map<String, List<cc_bean_MediaWrapper> >();
        
        List<E_ProductMedia__c> pmList = [Select e.AltMessage__c,e.EndDate__c, e.Id, e.FilePath__c, e.Product__c, e.Product__r.Id, e.Sequence__c, e.StartDate__c, e.URI__c, e.MediaType__c, ProductMediaSource__c, (SELECT Id, Name, ParentId FROM Attachments) from E_ProductMedia__c e where e.Product__r.Id =:productId and locale__c = :locale order by e.Sequence__c];
        for(E_ProductMedia__c pm: pmList) {
    	
            String mediaType = pm.MediaType__c;
            if(!mediaMap.containsKey(mediaType)) {
                mediaMap.put(mediaType, new List<cc_bean_MediaWrapper>());
            }
            
            List<cc_bean_MediaWrapper> pmTypeList = mediaMap.get(mediaType);
	        if('Attachment' == pm.ProductMediaSource__c)
        	{
	            List<Attachment> attachmentList = pm.Attachments;
	            
	            for(Attachment a: attachmentList) {
	                cc_bean_MediaWrapper wrapper = new cc_bean_MediaWrapper();
	                wrapper.uri = a.Id;
	                wrapper.sourceType = pm.ProductMediaSource__c;
	                wrapper.altMessage = pm.AltMessage__c;
	                wrapper.mediaName = a.Name;
	                pmTypeList.add(wrapper);
	            }
        	}
        	else if('URI' == pm.ProductMediaSource__c )
        	{
        		cc_bean_MediaWrapper wrapper = new cc_bean_MediaWrapper();
            	wrapper.uri = pm.URI__c;
            	wrapper.sourceType = pm.ProductMediaSource__c;
            	wrapper.altMessage = pm.AltMessage__c;
            	wrapper.mediaName = pm.URI__c;
                pmTypeList.add(wrapper);
        	}
        	
        	else if('Static Resource' == pm.ProductMediaSource__c )
        	{
        		cc_bean_MediaWrapper wrapper = new cc_bean_MediaWrapper();
            	wrapper.uri = pm.FilePath__c;
            	wrapper.sourceType = pm.ProductMediaSource__c;
            	wrapper.altMessage = pm.AltMessage__c;
            	wrapper.mediaName = pm.URI__c;
                pmTypeList.add(wrapper);
        	}
        	
        }
        return mediaMap;
    }
    
    //map from product id to alt_message
     public Map<Id, String> getProductAltMessages(List<String> pids) {
     	Map<Id,String> AltMessageMap = new Map<Id,String>();
     	List<E_ProductMedia__c> pmList = [Select e.AltMessage__c,
     											e.Product__c
 											from E_ProductMedia__c e
 											where e.Product__r.Id in :pids
 												and e.AltMessage__c != null];
 												
     	for(E_ProductMedia__c pm: pmList) {
        	AltMessageMap.put(pm.Product__c, pm.AltMessage__c);
        	//System.debug('@@@@@@@@@ Alt Message in Product MediaDAO:' + pm.AltMessage__c);
        }
        return AltMessageMap;
     }
    
     public Map<Id, cc_bean_MediaWrapper> getProductMedia(List<String> pids, String mediaType, String locale) {
        List<String> localeList = new List<String> ();
        if(locale == null || locale.trim().length() == 0 || locale == 'en_US') {
            //if locale is empty or equals 'en_US', localeList contains one "default" locale which is 'en_US'
            locale='en_US'; 
            localeList.add(locale);
        } else {
	        //otherwise, localeList contains two locales, one is default locale 'en_US', the other one is user's locale
	        localeList.add('en_US');
	        localeList.add(locale);
        }
        
        Map<Id,cc_bean_MediaWrapper> attachmentMap = new Map<Id,cc_bean_MediaWrapper>();
        System.debug('roy---localeList--->' + localeList);
        System.debug('roy---mediaType--->' + mediaType);
        System.debug('roy---pids--->' + pids);
        List<E_ProductMedia__c> pmList = [Select e.AltMessage__c, e.filePath__c, e.EndDate__c, e.Id, e.Product__c, e.Product__r.Id, e.Product__r.Name, e.Sequence__c, e.StartDate__c, e.URI__c, e.MediaType__c, ProductMediaSource__c, (SELECT Id, Name, ParentId FROM Attachments) from E_ProductMedia__c e where e.Product__r.Id in :pids and e.MediaType__c = :mediaType and locale__c in :localeList];
        
        //Boolean flag = true;
        //String IDMessage;
        for(E_ProductMedia__c pm: pmList) {
        	System.debug('roy---ProductMediaSource__c--->' + pm);
        	if('Attachment' ==pm.ProductMediaSource__c)
        	{
	            List<Attachment> attachmentList = pm.Attachments;
	            for(Attachment a: attachmentList) {
	                if(!(attachmentMap.containsKey(pm.Product__c))) {
	                    cc_bean_MediaWrapper wrapper = new cc_bean_MediaWrapper();
	                	wrapper.uri = a.Id;
	                	wrapper.sourceType = pm.ProductMediaSource__c;
	                	wrapper.altMessage = pm.AltMessage__c;
	                	wrapper.mediaName = a.Name;
	                    attachmentMap.put(pm.Product__c, wrapper);
	                }
	            }
        	}
        	else if('URI' == pm.ProductMediaSource__c )
        	{
        		cc_bean_MediaWrapper wrapper = new cc_bean_MediaWrapper();
            	wrapper.uri = pm.URI__c;
            	wrapper.sourceType = pm.ProductMediaSource__c;
            	wrapper.altMessage = pm.AltMessage__c;
            	wrapper.mediaName = pm.URI__c;
            	System.debug('roy---media wrapper--->' + wrapper);
                attachmentMap.put(pm.Product__c, wrapper);
        	}
        	else if('Static Resource' == pm.ProductMediaSource__c )
        	{
        		cc_bean_MediaWrapper wrapper = new cc_bean_MediaWrapper();
            	wrapper.uri = pm.filePath__c;
            	wrapper.sourceType = pm.ProductMediaSource__c;
            	wrapper.altMessage = pm.AltMessage__c;
            	wrapper.mediaName = pm.URI__c;
            	System.debug('roy---media wrapper--->' + wrapper);
                attachmentMap.put(pm.Product__c, wrapper);
        	}
            /*
            if(flag==true) {
            	IDMessage = ':'+ pm.AltMessage__c;
            	attachmentMap.put(pm.Product__c, IDMessage);
            }
            */
        }
        return attachmentMap;
    }
/*    
    
    //map from product id to attachment id
    public Map<Id, String> getProductMedia(List<String> pids, String mediaType, String locale) {
        List<String> localeList = new List<String> ();
        if(locale == null || locale.trim().length() == 0 || locale == 'en_US') {
            //if locale is empty or equals 'en_US', localeList contains one "default" locale which is 'en_US'
            locale='en_US'; 
            localeList.add(locale);
        } else {
	        //otherwise, localeList contains two locales, one is default locale 'en_US', the other one is user's locale
	        localeList.add('en_US');
	        localeList.add(locale);
        }
        
        Map<Id,String> attachmentMap = new Map<Id,String>();
        List<E_ProductMedia__c> pmList = [Select e.AltMessage__c, e.EndDate__c, e.Id, e.Product__c, e.Product__r.Id, e.Sequence__c, e.StartDate__c, e.URI__c, e.MediaType__c, (SELECT Id, Name, ParentId FROM Attachments) from E_ProductMedia__c e where e.Product__r.Id in :pids and e.MediaType__c = :mediaType and locale__c in :localeList];
        
        //Boolean flag = true;
        //String IDMessage;
        for(E_ProductMedia__c pm: pmList) {
        	//flag = true;
            List<Attachment> attachmentList = pm.Attachments;
            for(Attachment a: attachmentList) {
            	//flag=false;
            	//IDMessage = a.Id + ':' + pm.AltMessage__c;
                if(!(locale == 'en_US' && attachmentMap.containsKey(pm.Product__c))) {
                    attachmentMap.put(pm.Product__c, a.Id);
                    //attachmentMap.put(pm.Product__c, IDMessage);
                }
            }
            
            //if(flag==true) {
            //	IDMessage = ':'+ pm.AltMessage__c;
            //	attachmentMap.put(pm.Product__c, IDMessage);
            //}
            
        }
        return attachmentMap;
    }
*/    
    public Map<Id, cc_bean_MediaWrapper> getProductMedia(List<String> pids, String mediaType) {
        return getProductMedia( pids, mediaType, cc_util_Locale.getUserLanguage());
    }
    
    //map from product id to attachment id
    public Map<Id, cc_bean_MediaWrapper> getProductSearchMedia(List<String> pids, String locale) {
        return getProductMedia(pids, cc_cnst_CloudCraze.PM_ProductSearchImage, locale);
    }
/*    
    //map from product id to attachment id
    public Map<Id, String> getProductSearchMedia(List<String> pids, String locale) {
        return getProductMedia(pids, cc_cnst_CloudCraze.PM_ProductSearchImage, locale);
    }
*/    
    //map from product id to attachment id
    public Map<Id, cc_bean_MediaWrapper> getProductSearchMedia(List<String> pids) {
        return getProductMedia(pids, cc_cnst_CloudCraze.PM_ProductSearchImage, cc_util_Locale.getUserLanguage());
    }
    
    //map from product id to attachment id
    public Map<Id, cc_bean_MediaWrapper> getProductImage(List<String> pids, String locale) {
        return getProductMedia(pids, cc_cnst_CloudCraze.PM_ProductImage, locale);
    }
    
    
    //map from product id to attachment id
    public Map<Id, cc_bean_MediaWrapper> getProductThumbnailMedia(List<String> pids, String locale) {
        return getProductMedia(pids, cc_cnst_CloudCraze.PM_ProductImageThumbnail, locale);
    }
    
    //map from product id to attachment id
    public Map<Id, cc_bean_MediaWrapper> getProductThumbnailMedia(List<String> pids) {
        return getProductMedia(pids, cc_cnst_CloudCraze.PM_ProductImageThumbnail, cc_util_Locale.getUserLanguage());
    }
}