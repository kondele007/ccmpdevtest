//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//

 
public with sharing class cc_dao_CategoryMedia {
	//==================================================
    // CONSTANTS
    //==================================================
	public static final String CategoryImage='Category Image';
	public static final String CategoryImageThumbnail='Category Image Thumbnail';
	public cc_dao_CategoryMedia() {
		
	}
	//==================================================
    // SERVICE METHODS
    //==================================================
	
	/*
	 * CRUD-type functions
	 */
	
	// Reads a category specified by Id
	public List<E_CategoryMedia__c> readCategory(String categoryId) {
		List<E_CategoryMedia__c> categoryMediaList = [Select cm.Id,
													cm.AltMessage__c,
													cm.EndDate__c,
													cm.StartDate__c,
													cm.Category__c,
													cm.Category__r.Id,
													cm.Sequence__c,
													cm.URI__c,
													cm.MediaType__c
												from E_CategoryMedia__c cm
												where cm.Category__r.Id =: categoryId
												order by cm.Sequence__c];
	
		return categoryMediaList;
	}
	
	// Add category media records
	public List<E_CategoryMedia__c> saveCategoryMedia(List<E_CategoryMedia__c> categoryMediaList) {
		upsert categoryMediaList;
		return categoryMediaList;
	}
	
	// Delete category media record
	public void deleteCategoryMedia(String categoryId) {
		List<E_CategoryMedia__c> categoryMediaList = [select cm.Id
														from E_CategoryMedia__c cm
														where cm.Category__r.Id = :categoryId];
		if (categoryMediaList.size() > 0) {
			delete categoryMediaList;
		}
	}
	
	//==================================================
    // HELPER METHODS
    //==================================================
	/*
	 * getCategoryMedia(...)
	 */
	 
	// Returns a map of Categories and their attachment Ids
	public Map<Id,String> getCategoryMedia(List<String> categoryIds,
														String mediaType,
														String locale) {
		List<String> localeList = new List<String>();
		
		// If locale is empty or equals 'en_US', localeList contains one "default"
		// locale which is 'en_US'.  Otherwise, localeList contains two locales:
		// one is default locale 'en_US' and the other is user's locale.
		if (locale == null || locale.trim().length() == 0 || locale == 'en_US') {
			locale = 'en_US';
			localeList.add(locale);
		} else {
			localeList.add('en_US');
			localelist.add(locale);
		}
		
		
		Map<Id,String> attachmentMap = new Map<Id,String>();
		List<E_CategoryMedia__c> categoryMediaList = [Select cm.AltMessage__c,
														cm.Category__c,
														cm.Category__r.Id,
														cm.Sequence__c,
														cm.StartDate__c,
														cm.URI__c,
														cm.MediaType__c,
														(select Id, Name, ParentId from Attachments)
														from E_CategoryMedia__c cm
														where cm.Category__r.Id in :categoryIds and
															cm.MediaType__c = :mediaType and
															locale__c in :localeList];
	
		for (E_CategoryMedia__c categoryMedia : categoryMediaList) {
			List<Attachment> attachmentList = categoryMedia.Attachments;
			for (Attachment attachment : attachmentList) {
				if (!(locale =='en_US' && attachmentMap.containsKey(categoryMedia.Category__c))) {
					attachmentMap.put(categoryMedia.Category__c, attachment.Id);
				}
			}
		}
		return attachmentMap;
	}
	 
	public Map<Id,String> getCategoryMedia(List<String> categoryIds, String mediaType) {
		return getCategoryMedia(categoryIds, mediaType, cc_util_Locale.getUserLanguage());
	}
	
	/*
	 * getCategoryMediaByType(...)
	 */
	
	public Map<String, List<String> > getCategoryMediaByType(String categoryId, String locale) {
		Map<String, List<String> > mediaMap = new Map<String, List<String> >();
		
		List<E_CategoryMedia__c> categoryMediaList = [select cm.AltMessage__c,
															cm.EndDate__c,
															cm.Id,
															cm.Category__c,
															cm.Category__r.Id,
															cm.Sequence__c,
															cm.StartDate__c,
															cm.URI__c,
															cm.MediaType__c,
															(select Id, Name, ParentId from Attachments)
														from E_CategoryMedia__c cm
														where cm.Category__r.Id = :categoryId and
															locale__c = :locale
														order by cm.Sequence__c];
		for (E_CategoryMedia__c categoryMedia : categoryMediaList) {
			String mediaType = categoryMedia.MediaType__c;
			if (!mediaMap.containsKey(mediaType)) {
				mediaMap.put(mediaType, new List<String>());
			}
			List<String> categoryMediaTypeList = mediaMap.get(mediaType);
			List<Attachment> attachmentList = categoryMedia.Attachments;
			for (Attachment attachment : attachmentList) {
				categoryMediaTypeList.add(attachment.Id);
			}
		}
		return mediaMap;
	}
	
	public Map<String, List<String> > getCategoryMediaByType(String categoryId) {
		return getCategoryMediaByType(categoryId, cc_util_Locale.getUserLanguage());
	}
	
	/*
	 * Miscellaneous accessors
	 */
	 
	// Map from Product Id to Alt_Message
	public Map<Id,String> getCategoryAltMessages(List<String> categoryIds) {
		Map<Id,String> AltMessageMap = new Map<Id,String>();
		List<E_CategoryMedia__c> categoryMediaList = [select cm.AltMessage__c,
															cm.Category__c
														from E_CategoryMedia__c cm
														where cm.Category__r.Id in :categoryIds and
														cm.AltMessage__c != null];
		for (E_CategoryMedia__c categoryMedia : categoryMediaList) {
			AltMessageMap.put(categoryMedia.Category__c, categoryMedia.AltMessage__c);
		}
		return AltMessageMap;
	}
	
	// Map from Category Id to Attachment Id
	public Map<Id,String> getCategorySearchMedia(List<String> categoryIds, String locale) {
		return getCategoryMedia(categoryIds, cc_dao_CategoryMedia.CategoryImageThumbnail, locale);
	}
	
	// Map from Category Id to Attachment Id
	public Map<Id,String> getCategorySearchMedia(List<String> categoryIds) {
		return getCategoryMedia(categoryIds, cc_dao_CategoryMedia.CategoryImageThumbnail, cc_util_Locale.getUserLanguage());
	}
	
	// Map from Product Id to Attachment Id
	public Map<Id,String> getCategoryThumbnailMedia(List<String> categoryIds) {
		return getCategoryMedia(categoryIds, cc_dao_CategoryMedia.CategoryImageThumbnail);
	}
	
	
}