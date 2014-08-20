//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without
//  modification is PROHIBITED.
//
//
public with sharing class cc_util_BreadCrumb {
	//==================================================
    // STATIC SERVICE METHODS
    //==================================================
	public static void clearBreadCrumbs() {
        // Delete all the breadcrumb data
        List<E_BreadCrumb__c> existingBreadCrumbs = [select Id from E_BreadCrumb__c LIMIT 2000];
        Database.delete(existingBreadCrumbs);
	}

    public static void loadBreadCrumbs() {

        // Set the Menu Cache to dirty
/*mmm
        List<E_MenuCache__c> menuCacheList = new List<E_MenuCache__c>();
        for(E_MenuCache__c menuCache: [select Id, dirtyFlag__c from  E_MenuCache__c LIMIT 2000]) {
            menuCache.dirtyFlag__c = 'True';
            menuCacheList.add(menuCache);
        }
        update menuCacheList;
*/
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Menu Cache is invalid. Please Refresh');
        ApexPages.addMessage(myMsg);

        cc_bean_CategoryInfoI18N parentCategoryInfo = new cc_bean_CategoryInfoI18N();
        cc_bean_CategoryInfoI18N categoryI18N = new cc_bean_CategoryInfoI18N();
        cc_hlpr_BreadCrumbInfoI18N parentBreadCrumbInfo = new cc_hlpr_BreadCrumbInfoI18N();

        Map<String,cc_bean_CategoryInfoI18N> parentCategoryMap = new Map<String,cc_bean_CategoryInfoI18N>();
        Map<String,cc_bean_CategoryInfoI18N> categoryI18NMap = new Map<String,cc_bean_CategoryInfoI18N>();
        Map<String,cc_hlpr_BreadCrumbInfoI18N> breadCrumbInfoMap = new Map<String,cc_hlpr_BreadCrumbInfoI18N>();

        Set<String> categoryIDList = new Set<String>();
        Set<String> localeList = new Set<String>();

        List<E_CategoryI18N__c> categoryI18NList = [Select Locale__c, Category__c, Name from  E_CategoryI18N__c LIMIT 2000];

        // Iterate through locale category names and store them in a map.
        for(E_CategoryI18N__c categoryI18Ninstance : categoryI18NList) {
            // only get localization from custom setting.
            cc_bean_CategoryInfoI18N cc_bean_CategoryInfoI18N = new cc_bean_CategoryInfoI18N();
            cc_bean_CategoryInfoI18N.locale = categoryI18Ninstance.Locale__c;
            cc_bean_CategoryInfoI18N.categoryName = categoryI18Ninstance.Name;
            categoryI18NMap.put(categoryI18Ninstance.Category__c + categoryI18Ninstance.Locale__c, cc_bean_CategoryInfoI18N);
			System.debug('--- cc_ctrl_Admin.loadBreadCrumbs: getting category i18n data: key=' + categoryI18Ninstance.Category__c + categoryI18Ninstance.Locale__c + ', value=' + cc_bean_CategoryInfoI18N);
        }

        // Get the list of all allowable language codes
        List<E_Language__c> languageList = E_Language__c.getAll().values();

        for(E_Language__c languageInstance : languageList) {
            localeList.add(languageInstance.Locale__c);
        }

        List<E_Category__c> categories = [select ParentCategory__c, Name, Sequence__c from E_Category__c LIMIT 2000];
        String rootID = '';

        // IMPORTANT: The following algorithm is under the assumption that '@','#',',' does not occur in the category Name
        for(E_Category__c category : categories) {
            for(String locale : localeList) {

                categoryIDList.add(category.Id);

                if(category.ParentCategory__c == null) {
                    rootID = category.Id;
                    cc_hlpr_BreadCrumbInfoI18N breadCrumbInfoI18Ninstance = new cc_hlpr_BreadCrumbInfoI18N();
                    breadCrumbInfoI18Ninstance.breadCrumb = 'Start';
                    breadCrumbInfoI18Ninstance.breadCrumbURL = 'Start';
                    breadCrumbInfoI18Ninstance.sequenceName = '000.0Start';
                    breadCrumbInfoI18Ninstance.breadCrumbWithLocale = locale + 'Start';
                    breadCrumbInfoI18Ninstance.locale = locale;
                    breadCrumbInfoI18Ninstance.topLevelCategory = 'false';
                    breadCrumbInfoI18Ninstance.categoryName = 'Start';
                    breadCrumbInfoMap.put(category.Id + locale, breadCrumbInfoI18Ninstance);
                }

                cc_bean_CategoryInfoI18N cc_bean_CategoryInfoI18N = new cc_bean_CategoryInfoI18N();
                cc_bean_CategoryInfoI18N.locale = locale;
				System.debug('--- cc_ctrl_Admin.loadBreadCrumbs: getting category data: locale=' + locale);
                parentCategoryInfo = parentCategoryMap.get(category.ParentCategory__c + locale);
				System.debug('--- cc_ctrl_Admin.loadBreadCrumbs: getting category data: parentCategoryInfo=' + parentCategoryInfo);
                categoryI18N = categoryI18NMap.get(category.Id + locale);
				System.debug('--- cc_ctrl_Admin.loadBreadCrumbs: getting category data: category.ID + locale=' + category.Id + locale + ', categoryI18N=' + categoryI18N);
				
				/**
				 *  categoryMapStr = parentCategoryInfo.categoryMapStr + 'z@yx'
				 *  plus 5 tokens for the category
				 *  token1 = category Id
				 *  token2 = category I18N name, or if null, then category name
				 *  token3 = cateogry sequence
				 *  token4 = locale
				 *  token5 = category name
				 */

                if(parentCategoryInfo != null) {
                    if(categoryI18N != null) {
                        cc_bean_CategoryInfoI18N.categoryName = parentCategoryInfo.categoryName + ',' + categoryI18N.categoryName;
                        cc_bean_CategoryInfoI18N.categoryMapStr = parentCategoryInfo.categoryMapStr + 'z@yx' + category.Id + 'a#hz' + categoryI18N.categoryName + 'a#hz' + category.Sequence__c + 'a#hz' + locale + 'a#hz' + category.Name;
                    } else {
                        cc_bean_CategoryInfoI18N.categoryName = parentCategoryInfo.categoryName + ',' + category.Name;
                        cc_bean_CategoryInfoI18N.categoryMapStr = parentCategoryInfo.categoryMapStr + 'z@yx' + category.Id + 'a#hz' + category.Name + 'a#hz' + category.Sequence__c + 'a#hz' + locale + 'a#hz' + category.Name;
                    }
                } else {
                    if(categoryI18N != null ) {
                        cc_bean_CategoryInfoI18N.categoryName = categoryI18N.categoryName;
                        cc_bean_CategoryInfoI18N.categoryMapStr = category.Id + 'a#hz' + categoryI18N.categoryName + 'a#hz' + category.Sequence__c + 'a#hz' + locale + 'a#hz' + category.Name;
                    } else {
                        cc_bean_CategoryInfoI18N.categoryName = category.Name;
                        cc_bean_CategoryInfoI18N.categoryMapStr = category.Id + 'a#hz' + category.Name + 'a#hz' + category.Sequence__c + 'a#hz' + locale + 'a#hz' + category.Name;
                    }
                }

                System.debug('--- cc_ctrl_Admin.loadBreadCrumbs: adding to parentCategoryMap: key=' + category.ParentCategory__c + locale + ', value=' + cc_bean_CategoryInfoI18N);
                parentCategoryMap.put(category.ParentCategory__c + locale, cc_bean_CategoryInfoI18N);
            }
        }

        cc_hlpr_CategoryStack cc_hlpr_CategoryStack = new cc_hlpr_CategoryStack();
        Integer index = 0;
        
        System.debug('--- cc_ctrl_Admin.loadBreadCrumbs: localeList=' + localeList);

        for(String locale : localeList) {
            cc_bean_CategoryInfoI18N rootCategoryInfo = parentCategoryMap.get(rootID + locale);
            System.debug('--- cc_ctrl_Admin.loadBreadCrumbs: rootCategoryInfo=' + rootCategoryInfo);

            if(rootCategoryInfo != null) {
                String childCategory = rootCategoryInfo.categoryMapStr;
            	System.debug('--- cc_ctrl_Admin.loadBreadCrumbs: childCategory=' + childCategory);

                if(childCategory != null) {
                    List<String> childCategories = childCategory.split('z@yx');

                    if(childCategories != null && childCategories.size() > 0) {
                        for(String childCategoryStr : childCategories) {
            				System.debug('--- cc_ctrl_Admin.loadBreadCrumbs: childCategoryStr=' + childCategoryStr);

                            List<String> childInfo = childCategoryStr.split('a#hz');
                            if(childInfo != null && childInfo.size() == 5) {
                                // Update breadcrumb object field maps
                                if(breadCrumbInfoMap.get(childInfo[0] + locale) == null) {
                                    cc_hlpr_BreadCrumbInfoI18N breadCrumbInfoI18NInstance = new cc_hlpr_BreadCrumbInfoI18N();
                                    breadCrumbInfoI18NInstance.breadCrumb = 'Start>' + childInfo[1];
                                    breadCrumbInfoI18NInstance.breadCrumbURL = 'Start>' + childInfo[0];
                                    breadCrumbInfoI18NInstance.sequenceName = '000.0Start>' + childInfo[2] + childInfo[4];
                                    breadCrumbInfoI18NInstance.locale = rootCategoryInfo.locale;
                                    breadCrumbInfoI18NInstance.topLevelCategory = 'True';
                                    breadCrumbInfoI18NInstance.topLevelIndex = index++;
                                    breadCrumbInfoI18NInstance.categoryName = childInfo[1];
                                    breadCrumbInfoI18NInstance.breadCrumbWithLocale = rootCategoryInfo.locale + 'Start>' + childInfo[3] + childInfo[4];
                                    breadCrumbInfoMap.put(childInfo[0] + locale, breadCrumbInfoI18NInstance);
                                }

                                // Create a cc_hlpr_Stack of categories and push
                                cc_hlpr_StackNode node = new cc_hlpr_StackNode();
                                node.setCategoryID(childInfo[0]);
                                node.setLocale(childInfo[3]);
                                node.setCategoryName(childInfo[1]);
                                node.setSequence(childInfo[2]);
                                node.setDefaultLocaleCategoryName(childInfo[4]);
                                node.setVisted(false);
                                node.setParent(rootID);
                                cc_hlpr_CategoryStack.push(node);
                            }
                        }
                    }
                }
            }
        }


        while(!cc_hlpr_CategoryStack.isEmpty()) {
            cc_hlpr_StackNode node = cc_hlpr_CategoryStack.pop();
            if(!node.isVisited()) {
		        //jll - need to format sequence since it will be used in string form to determine display order
		        //ie need to prevent 10abc from being before 1abc by changing 1abc to 01abc
		        Integer maxDigits = 4;
                String categoryName = node.getCategoryName();
                String categoryID = node.getCategoryID();
                String sequence = node.getSequence();
                //jll need to determine leading 0's if any, see above comment
                String leadingPadding = '';
                for(Double currentDigits = Decimal.valueOf(sequence) > 0 ? Math.log10(Decimal.valueOf(sequence)) : maxDigits; currentDigits < maxDigits; currentDigits++)
                {
                	System.debug('--- PADDING ' + node.getCategoryName() + ' because it has' + currentDigits + ' digits in its sequence and the max digits is ' + maxDigits);
                	leadingPadding += '0';
                }
                sequence = leadingPadding + sequence;
                String parentCategory = node.getParent();
                String defaultLocaleCategoryName = node.getDefaultLocaleCategoryName();
                String locale=node.getLocale();

                if(breadCrumbInfoMap.get(categoryID + locale) == null && (parentBreadCrumbInfo=breadCrumbInfoMap.get(parentCategory + locale)) != null) {
                    cc_hlpr_BreadCrumbInfoI18N breadCrumbInfoI18NInstance = new cc_hlpr_BreadCrumbInfoI18N();
                    breadCrumbInfoI18NInstance.breadCrumb = parentBreadCrumbInfo.breadCrumb + '>' + categoryName;
                    breadCrumbInfoI18NInstance.breadCrumbURL = parentBreadCrumbInfo.breadCrumbURL + '>' + categoryID;
                    breadCrumbInfoI18NInstance.sequenceName = parentBreadCrumbInfo.sequenceName + '>' + sequence + categoryName;
                    breadCrumbInfoI18NInstance.breadCrumbWithLocale = parentBreadCrumbInfo.breadCrumbWithLocale + '>' + locale + categoryName;
                    //breadCrumbInfoI18NInstance.sequenceName = parentBreadCrumbInfo.sequenceName + '>' + sequence + defaultLocaleCategoryName;
                    //breadCrumbInfoI18NInstance.breadCrumbWithLocale = parentBreadCrumbInfo.breadCrumbWithLocale + '>' + locale + defaultLocaleCategoryName;
                    breadCrumbInfoI18NInstance.topLevelIndex = parentBreadCrumbInfo.topLevelIndex;
                    breadCrumbInfoI18NInstance.locale = locale;
                    breadCrumbInfoI18NInstance.topLevelCategory = 'False';
                    breadCrumbInfoI18NInstance.categoryName = categoryName;
                    breadCrumbInfoMap.put(categoryID + locale, breadCrumbInfoI18NInstance);
                }

                parentCategoryInfo = parentCategoryMap.get(categoryID + locale);
                if(parentCategoryInfo == null) {
                    parentCategoryInfo = parentCategoryMap.get(categoryID);
                }

                if(parentCategoryInfo != null) {
                    String childCategory = parentCategoryInfo.categoryMapStr;
                    if(childCategory != null) {
                        List<String> childCategories = childCategory.split('z@yx');
                        if(childCategories != null && childCategories.size() > 0) {
                            for(String childCategoryStr : childCategories){
                                List<String> childInfo = childCategoryStr.split('a#hz');
                                if(childInfo != null && childInfo.size() == 5) {

                                    // Create a cc_hlpr_Stack of categories and push
                                    cc_hlpr_StackNode childnode = new cc_hlpr_StackNode();
                                    childNode.setLocale(childInfo[3]);
                                    childnode.setCategoryID(childInfo[0]);
                                    childNode.setDefaultLocaleCategoryName(childInfo[4]);
                                    childnode.setCategoryName(childInfo[1]);
                                    childnode.setSequence(childInfo[2]);
                                    childnode.setVisted(false);
                                    childnode.setParent(categoryID);
                                    cc_hlpr_CategoryStack.push(childnode);
                                }
                            }
                        }
                    }
                }
            }

            node.setVisted(true);
        }

        // Insert the map elements into BreadCrumb table

        List<E_BreadCrumb__c> breadCrumbs=new List<E_BreadCrumb__c>();

        for(String category : categoryIDList) {
            for(String locale : localeList) {
                E_BreadCrumb__c breadCrumbInstance = new E_BreadCrumb__c();
                cc_hlpr_BreadCrumbInfoI18N breadCrumbInfoI18NInstance = breadCrumbInfoMap.get(category + locale);
                if(breadCrumbInfoI18NInstance != null) {
                    breadCrumbInstance.CategoryId__c = category;
                    breadCrumbInstance.Breadcrumb__c = breadCrumbInfoI18NInstance.breadCrumb;
                    breadCrumbInstance.Locale__c = breadCrumbInfoI18NInstance.locale;
                    breadCrumbInstance.BreadcrumbURL__c = breadCrumbInfoI18NInstance.breadCrumbURL;
                    breadCrumbInstance.SequenceName__c = breadCrumbInfoI18NInstance.sequenceName;
                    breadCrumbInstance.BreadCrumbWithLocale__c = breadCrumbInfoI18NInstance.breadCrumbWithLocale;
                    breadCrumbInstance.TopLevelFlag__c = breadCrumbInfoI18NInstance.topLevelCategory;
                    breadCrumbInstance.TopLevelIndex__c = breadCrumbInfoI18NInstance.topLevelIndex;
                    breadCrumbInstance.CategoryName__c = breadCrumbInfoI18NInstance.categoryName;
                    breadCrumbs.add(breadCrumbInstance);
                }
            }
        }

        insert breadCrumbs;
    }
}