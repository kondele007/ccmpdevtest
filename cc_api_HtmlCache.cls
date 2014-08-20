public with sharing class cc_api_HtmlCache {
	
	public static String getMenuHtml(String storefrontName, String locale) {
		return cc_api_HtmlCache.getCacheHtml(cc_cnst_PickListConstants.HTML_CACHE_TYPE_MENU, storefrontName, locale);
	}
	
	public static String getCategoryTreeHtml(String storefrontName, String locale) {
		return cc_api_HtmlCache.getCacheHtml(cc_cnst_PickListConstants.HTML_CACHE_TYPE_CATEGORY, storefrontName, locale);
	}

	public static String getCacheHtml(String cacheType, String storefrontName, String locale) {
		String cacheHtml = null;
		/*
		List<E_HtmlCache__c> caches = cc_dao_HtmlCache.getHtmlCaches(cacheType, storefrontName, locale);
		Id htmlAttachmentId = null;
		if(caches != null && caches.size() > 0) {
			E_HtmlCache__c cache = caches[0];
			if(cache.Attachments != null && cache.Attachments.size() > 0) {
				htmlAttachmentId = cache.Attachments[0].Id;
			}
		}
		
		if(htmlAttachmentId != null) {
	        Attachment aBody = [Select Body From Attachment Where id = :htmlAttachmentId];
	        cacheHtml = aBody.Body.toString();
		}
		*/
		return cacheHtml;
	}

	public static void deleteAllCategoryTreeHtmlCaches() {
		//cc_dao_HtmlCache.deleteCaches(cc_cnst_PickListConstants.HTML_CACHE_TYPE_CATEGORY);
	}
	
	public static void deleteAllMenuHtmlCaches() {
		//cc_dao_HtmlCache.deleteCaches(cc_cnst_PickListConstants.HTML_CACHE_TYPE_MENU);
	}

	/**
	 * reads E_Menu__c and children an generates html for each storefront and language and stores in E_MenuCache
	 */
    public static void cacheMenus() {
		return;
		/*
        Map<String,E_StorefrontSettings__c> storefrontMap = E_StorefrontSettings__c.getAll();
        E_StorefrontSettings__c storefront = null;
        for(E_StorefrontSettings__c sf : storefrontMap.values()) {
			storefront = sf; // TODO: change to work with all storefronts, not just the first one
			break;
        }

		// list to hold all of the menus in order
		List<E_Menu__c> menuList = new List<E_Menu__c>(); // top-level menus
		Map<Id,E_MenuItem__c> menuItemMap = new Map<Id,E_MenuItem__c>(); // maps E_MenuItem.Id to E_MenuItem
		Map<Id,List<Id>> menuHeirarchyMap = new Map<Id,List<Id>>(); // maps Id of menu or menu item to list of sub menu items

		// get top level menus
		menuList = cc_dao_Menu.getAllMenus();
		
		List<Id> childMenuItemIds = new List<Id>(); // all children under top-level menus
		List<Id> childIds = null; // temp holder for children for each menu
		
		for(E_Menu__c m : menuList) {
			childIds = new List<Id>(); // reset list of childIds for each menu
			if(m.Menu_Items__r != null) {
				for(E_MenuItem__c mi : m.Menu_Items__r) {
					childIds.add(mi.Id);
					childMenuItemIds.add(mi.Id);
				}
			}
			
			if(childIds.size() > 0) {
				//childMenuItemIds.addAll(childIds); // add menu item ids to list of children
				menuHeirarchyMap.put(m.Id, childIds); // add menu id => list of child menu item ids to map
			}
		}
		
		while(childMenuItemIds.size() > 0) {
			List<E_MenuItem__c> menuItems = cc_dao_Menu.getMenuItems(childMenuItemIds); // get current level menu items
			childMenuItemIds = new List<Id>(); // reset the list of children

			for(E_MenuItem__c mi : menuItems) {
				menuItemMap.put(mi.Id, mi); // add menu item to map
				childIds = new List<Id>(); // reset list of childIds for each menu

				if(mi.Child_Menu_Items__r != null) {
					for(E_MenuItem__c child : mi.Child_Menu_Items__r) {
						childIds.add(child.Id);
						childMenuItemIds.add(child.Id);
					}
				}
				
				if(childIds.size() > 0) {
					//childMenuItemIds.addAll(childIds); // add menu item ids to list of children
					menuHeirarchyMap.put(mi.Id, childIds); // add menu item id => list of child menu item ids to map
				}
			}
		}
		
		String menuHtml = '';

		for(E_Menu__c menu : menuList) {
			System.debug(LoggingLevel.INFO, '--- cc_api_HtmlCache.cacheMenu: L1 menu=' + menu.DisplayName__c);
			String menuLink = cc_api_HtmlCache.getMenuLink(menu.LinkType__c, menu.Category__c, menu.Product__c, menu.URL__c);
			String newWindow = '';
			if(menu.NewWindow__c) {
				newWindow = 'target="_blank"';
			}
			menuHtml += '<li><a href="' + menuLink + '" ' + newWindow + '>' + menu.DisplayName__c + '</a>';

			List<Id> itemIds = new List<Id>();

			if(menuHeirarchyMap.containsKey(menu.Id)) {
				menuHtml += '<ul>';

				for(Id childId : menuHeirarchyMap.get(menu.Id)) {
					E_MenuItem__c menuItem = menuItemMap.get(childId);
					System.debug(LoggingLevel.INFO, '--- cc_api_HtmlCache.cacheMenu: - L2 menu item=' + menuItem.DisplayName__c);
					menuLink = cc_api_HtmlCache.getMenuLink(menuItem.LinkType__c, menuItem.Category__c, menuItem.Product__c, menuItem.URL__c);
					if(menuItem.NewWindow__c) {
						newWindow = 'target="_blank"';
					} else {
						newWindow = '';
					}
					menuHtml += '<li><a href="' + menuLink + '">' + menuItem.DisplayName__c + '</a>';

					if(menuHeirarchyMap.containsKey(menuItem.Id)) {
						menuHtml += '<ul>';

						for(Id childId2 : menuHeirarchyMap.get(menuItem.Id)) {
							E_MenuItem__c menuItem2 = menuItemMap.get(childId2);
							System.debug(LoggingLevel.INFO, '--- cc_api_HtmlCache.cacheMenu: - L3 menu item=' + menuItem2.DisplayName__c);
							menuLink = cc_api_HtmlCache.getMenuLink(menuItem2.LinkType__c, menuItem2.Category__c, menuItem2.Product__c, menuItem2.URL__c);
							if(menuItem2.NewWindow__c) {
								newWindow = 'target="_blank"';
							} else {
								newWindow = '';
							}
							menuHtml += '<li><a href="' + menuLink + '">' + menuItem2.DisplayName__c + '</a></li>';
						}
						menuHtml += '</ul>';
					}
					menuHtml += '</li>';
				}
				menuHtml += '</ul>';
			}
			menuHtml += '</li>';
		}
		
		System.debug(LoggingLevel.INFO, '--- cc_api_HtmlCache.cacheMenu: menuHtml=' + menuHtml);
		
		E_HtmlCache__c cache = new E_HtmlCache__c(StoreID__c=storefront.Name, Locale__c='en_US', dirtyFlag__c='False', HtmlType__c=cc_cnst_PickListConstants.HTML_CACHE_TYPE_MENU);
		insert cache;
		
		Attachment cacheAttachment = new Attachment(ParentId=cache.Id, Name='menuCache.html', Body=Blob.valueOf(menuHtml));
		insert cacheAttachment;
		*/
	}
	
	public static void cacheCategoryTreeHtml() {
		return;
		/*
        Map<String,E_StorefrontSettings__c> storefrontMap = E_StorefrontSettings__c.getAll();
        E_StorefrontSettings__c storefront = null;
        for(E_StorefrontSettings__c sf : storefrontMap.values()) {
			storefront = sf; // TODO: change to work with all storefronts, not just the first one
			break;
        }

		// read E_Category__c and children and generate html for each language and store in E_MenuCache
    	
    	System.debug('--- cc_api_HtmlCache.cacheCategoryTreesForStorefront: loading html cache for storefront=' + storefront);
    	
        Set<String> localeList = new Set<String>();
        List<String> orderedTreeList = new List<String>();
        List<String> treeList = new List<String>();

        Map<String,List<String>> treeListMap = new Map<String,List<String>>();

        Map<String,List<String>> topCategoryMap = new Map<String,List<String>>();

        String categoryName;
        Boolean whileFlag = false;
        Boolean hasChildren = false;
        Integer noOpenULs = 0;
        Integer rootBreadCrumbLength = 0;
        String lastBreadCrumb = '';
        String tempTreeHtml = '';
        String rootID = '';
        
        List<E_Category__c> levelOneCategories = [Select Name, ParentCategory__c, CategoryID__c
			                                     from E_Category__c
			                                     where ParentCategory__r.CategoryID__c = :storefront.Root_Category_ID__c order by Sequence__c];

		List<Id> levelOneCategoryIds = new List<Id>();
        if (levelOneCategories.size() > 0) {
            rootID = levelOneCategories[0].ParentCategory__c;
            for(E_Category__c loc : levelOneCategories) {
            	levelOneCategoryIds.add(loc.Id);
       			System.debug('--- cc_util_Menu.loadMenuCache: root category=' + loc.Name);
            }
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Root Category not found for storefront ' + storefront.Name + ' with Category ID=' + storefront.Root_Category_ID__c));
            return;
        }

        //Get the breadcrumb info for the top category to construct the HTML properly.
        List<E_BreadCrumb__c> breadCrumbRoot = [select BreadCrumb__c from E_BreadCrumb__c where CategoryID__c = :rootID];

        if (breadCrumbRoot.size() > 0 && breadCrumbRoot[0] != null && breadCrumbRoot[0].BreadCrumb__c != null) {
            rootBreadCrumbLength = breadCrumbRoot[0].BreadCrumb__c.split(cc_cnst_CloudCraze.breadCrumbSepearator).size() + 1;
            System.debug('--- cc_util_Menu.loadMenuCache: rootBreadCrumbLength=' + rootBreadCrumbLength);
        }

        String ret = '';
        Integer index = 0;

        for (E_BreadCrumb__c breadCrumbInstance: [Select BreadCrumb__c,
				                                     BreadCrumbURL__c,
				                                     BreadCrumbWithLocale__c,
				                                     CategoryName__c,
				                                     CategoryID__c,
				                                     TopLevelIndex__c,
				                                     Locale__c
				                                  From E_BreadCrumb__c
				                                  where CategoryID__c in :levelOneCategoryIds
				                                  order by SequenceName__c, BreadCrumbWithLocale__c]) {

            localeList.add(breadCrumbInstance.Locale__c);
            tempTreeHtml = '';
            index++;
            
            System.debug(LoggingLevel.INFO, '--- cc_api_HtmlCache.cacheCategoryTreeHtml: breadCrumbInstance: catid=' + breadCrumbInstance.CategoryID__c + ', locale=' + breadCrumbInstance.Locale__c + ', CategoryName=' + breadCrumbInstance.CategoryName__c + ', BreadCrumbWithLocale=' + breadCrumbInstance.BreadCrumbWithLocale__c);

            tempTreeHtml += '<li><a href="javascript:productList(\'' + breadCrumbInstance.CategoryID__c + '\');">' + breadCrumbInstance.CategoryName__c + '</a>';

            //intialize previous variable string
            String previousBreadCrumb = '';
            String previousBreadCrumbURL = '';
            cc_hlpr_Stack previousCatStack = new cc_hlpr_Stack();
            cc_hlpr_Stack previousCatURLStack = new cc_hlpr_Stack();
            
            List<E_BreadCrumb__c> breadCrumbChildren = [select CategoryName__c, BreadCrumbWithLocale__c, CategoryID__c, BreadCrumb__c, BreadCrumbURL__c, Locale__c
            										From E_BreadCrumb__c
            										where BreadCrumbWithLocale__c like :breadCrumbInstance.BreadCrumbWithLocale__c + '>%'
            										order by SequenceName__c];
            if(breadCrumbChildren.size() == 0) {
            	//tempTreeHtml += '</li>';
            } else {
	
	            for (E_BreadCrumb__c breadCrumbChild : breadCrumbChildren) {
	
		            if (previousBreadCrumb == '') {
		                lastBreadCrumb = breadCrumbInstance.BreadCrumb__c;
		                previousBreadCrumb = breadCrumbInstance.BreadCrumbWithLocale__c;
		                previousBreadCrumbURL = breadCrumbInstance.BreadCrumbURL__c;
		                previousCatStack.push(breadCrumbInstance.BreadCrumbWithLocale__c);
		                previousCatURLStack.push(breadCrumbInstance.BreadCrumbURL__c);
		            }
		            previousBreadCrumb = previousCatStack.peak() + cc_cnst_CloudCraze.breadCrumbSepearator;
		            System.debug('--- cc_util_Menu.loadMenuCaches: previousBreadCrumb=' + previousBreadCrumb);
		            previousBreadCrumbURL = previousCatURLStack.peak() + cc_cnst_CloudCraze.breadCrumbSepearator;
		            System.debug('--- cc_util_Menu.loadMenuCaches: previousBreadCrumbURL=' + previousBreadCrumbURL);
		            Integer noTobeClosed = (lastBreadCrumb.split(cc_cnst_CloudCraze.breadCrumbSepearator).size()) - (breadCrumbChild.BreadCrumb__c.split(cc_cnst_CloudCraze.breadCrumbSepearator).size());
	
		            while (noTobeClosed> 0) {
		                tempTreeHtml += '</ul></li>';
		                noTobeClosed--;
		            }
	
		            System.debug('--- cc_util_Menu.loadMenuCaches: breadCrumbChild: catid=' + breadCrumbChild.CategoryID__c + ', locale=' + breadCrumbChild.Locale__c + ', CategoryName=' + breadCrumbChild.CategoryName__c + ', BreadCrumbWithLocale' + breadCrumbChild.BreadCrumbWithLocale__c);
		
		            if(al.StringUtils.contains(breadCrumbChild.BreadCrumbWithLocale__c, previousBreadCrumb)) {
		            	System.debug('--- cc_util_Menu.loadMenuCaches: previousBreadCrumb is found in breadCrumbChild.BreadCrumbWithLocale__c');
		                hasChildren = true;
		
		                tempTreeHtml = al.StringUtils.removeEnd(tempTreeHtml, '</li>');
		                String tempTreeStr = '<ul><li><a href="javascript:productList(\'' + breadCrumbChild.CategoryID__c + '\');">' + breadCrumbChild.CategoryName__c + '</a></li>';
		                tempTreeHtml += tempTreeStr;
		                noOpenULs++;
		
		                previousBreadCrumb = breadCrumbChild.BreadCrumbWithLocale__c;
		                previousBreadCrumbURL = breadCrumbChild.BreadCrumbURL__c;
		
		                previousCatStack.push(breadCrumbChild.BreadCrumbWithLocale__c);
		                previousCatURLStack.push(breadCrumbChild.BreadCrumbURL__c);
		            } else {
		            	System.debug('--- cc_util_Menu.loadMenuCaches: previousBreadCrumb is NOT found in breadCrumbChild.BreadCrumbWithLocale__c');
		                previousBreadCrumb = previousCatStack.pop() + cc_cnst_CloudCraze.breadCrumbSepearator;
		                previousBreadCrumbURL = previousCatURLStack.pop() + cc_cnst_CloudCraze.breadCrumbSepearator;
		                if (!previousCatStack.isEmpty()) previousBreadCrumb = previousCatStack.peak() + cc_cnst_CloudCraze.breadCrumbSepearator;
		
		                while (!previousCatStack.isEmpty() && !al.StringUtils.contains(breadCrumbChild.BreadCrumbWithLocale__c, previousBreadCrumb)) {
		
			                previousBreadCrumb = previousCatStack.pop() + cc_cnst_CloudCraze.breadCrumbSepearator;
			                whileFlag = true;
			                if (!previousCatStack.isEmpty()) {
			                    previousBreadCrumb = previousCatStack.peak() + cc_cnst_CloudCraze.breadCrumbSepearator;
			                }
		                }
	
		                if (!previousCatURLStack.isEmpty()) previousBreadCrumbURL = previousCatURLStack.peak() + cc_cnst_CloudCraze.breadCrumbSepearator;
		
		                while (!previousCatURLStack.isEmpty() && !al.StringUtils.contains(breadCrumbChild.BreadCrumbURL__c, previousBreadCrumbURL)) {
		
			                previousBreadCrumbURL = previousCatURLStack.pop() + cc_cnst_CloudCraze.breadCrumbSepearator;
			
			                if (!previousCatURLStack.isEmpty()) {
			                    previousBreadCrumbURL = previousCatURLStack.peak() + cc_cnst_CloudCraze.breadCrumbSepearator;
			                }
			            }
		
		                String tempChildTreeStr = '<li><a href="javascript:productList(\'' + breadCrumbChild.CategoryID__c + '\');">' + breadCrumbChild.CategoryName__c + '</a></li>';
		                tempTreeHtml += tempChildTreeStr;
		
		                previousBreadCrumb = breadCrumbChild.BreadCrumbWithLocale__c;
		                previousBreadCrumbURL = breadCrumbChild.BreadCrumbURL__c;
		
		                previousCatStack.push(breadCrumbChild.BreadCrumbWithLocale__c);
		                previousCatURLStack.push(breadCrumbChild.BreadCrumbURL__c);
		            }
		
		            lastBreadCrumb = breadCrumbChild.BreadCrumb__c;
	            }
            }

            Integer loopCount = lastBreadCrumb.split(cc_cnst_CloudCraze.breadCrumbSepearator).size() - rootBreadCrumbLength;
            System.debug(LoggingLevel.INFO, '--- cc_api_HtmlCache.cacheCategoryTreeHtml: figuring loop count: lastBreadCrumb=' + lastBreadCrumb + ', rootBreadCrumbLength=' + rootBreadCrumbLength + ', loopCount=' + loopCount);
            while(loopCount > 0) {
	            if(noOpenULs > 0) {
            		System.debug(LoggingLevel.INFO, '--- cc_api_HtmlCache.cacheCategoryTreeHtml: adding closing UL LI');
	                tempTreeHtml += '</ul></li>';
	                noOpenULs--;
	            } else {
            		System.debug(LoggingLevel.INFO, '--- cc_api_HtmlCache.cacheCategoryTreeHtml: adding closing LI');
	                tempTreeHtml += '</li>';
	            }
	            loopCount--;
            }
            
            if(lastBreadCrumb == '') {
            	System.debug(LoggingLevel.INFO, '--- cc_api_HtmlCache.cacheCategoryTreeHtml: adding closing LI');
	            tempTreeHtml += '</li>';
            }

			treeList = treeListMap.get(breadCrumbInstance.Locale__c);
            if (treeList == null) {
            	treeList = new List<String>();
            }

            treeList.add(tempTreeHtml);

            // Add entities to Map
            treeListMap.put(breadCrumbInstance.Locale__c, treeList);
            System.debug('--- cc_util_Menu.loadMenuCaches: treeListMap added key=' + breadCrumbInstance.Locale__c + ', treeList size=' + treeList.size() + ', added tempTreeHtml=' + tempTreeHtml);
        }
        System.debug('--- cc_util_Menu.loadMenuCaches: treeListMap keySet=' + treeListMap.keySet());

        List <E_HtmlCache__c> htmlCacheList = new List <E_HtmlCache__c> ();
        List<String> treeCaches = new List<String>();
        Integer treeindex = 1;

		System.debug('--- cc_util_Menu.loadMenuCaches: localeList=' + localeList);
     	for (string locale: localeList) {

            String treehtml = '';

            List<String> tempTreeList = treeListMap.get(locale);
			System.debug('--- cc_util_Menu.loadMenuCaches: tempTreeList size=' + tempTreeList.size());
            Integer tempLoopIndex = 0;
            if(tempTreeList != null) {
	            for(tempLoopIndex = tempTreeList.size() - 1; tempLoopIndex >= 0; tempLoopIndex--) {
	                if(treeList != null && orderedTreeList != null) {
						System.debug('--- cc_util_Menu.loadMenuCaches: adding to orderedTreeList tempTreeList.get(' + tempLoopIndex + ')=' + tempTreeList.get(tempLoopIndex));
	                    orderedTreeList.add(tempTreeList.get(tempLoopIndex));
	                }
	            }
            }

            for (String htmlInstance : orderedTreeList) {
				System.debug('--- cc_util_Menu.loadMenuCaches: adding htmlInstance=' + htmlInstance);
            	treeHtml += htmlInstance;
            }
            treeCaches.add(treeHtml);

            E_HtmlCache__c htmlCache = new E_HtmlCache__c();
            htmlCache.dirtyFlag__c = 'False';
            htmlCache.Locale__c = locale;
            htmlCache.StoreID__c = storefront.Name;
            htmlCache.HtmlType__c = cc_cnst_PickListConstants.HTML_CACHE_TYPE_CATEGORY;
            htmlCacheList.add(htmlCache);
            treeindex++;

            orderedTreeList = new List<String>();
        }

        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Menu cache is current');
        ApexPages.addMessage(myMsg);

        System.debug('--- cc_util_Menu.loadMenuCache: inserting htmlCacheList=' + htmlCacheList);
        insert htmlCacheList;

        // Insert tree cache as attachment
        List<Attachment> attachments = new List<Attachment>();
        Integer i = 0;
        for(E_HtmlCache__c mc : htmlCacheList) {
            Attachment treeAttachment = new Attachment();
            treeAttachment.ParentId = mc.Id;
            treeAttachment.Name = 'treeCache.html';
            treeAttachment.Body = Blob.valueOf(treeCaches[i]);
            attachments.add(treeAttachment);
            i++;
        }
        */
        //insert attachments;
    }
    
    public static String getMenuLink(String linkType, String categoryId, String productId, String URL) {
    	String menuLink = '';
    	/*
    	if(cc_cnst_PickListConstants.MENU_LINK_TYPE_CATEGORY.equalsIgnoreCase(linkType)) {
    		menuLink = 'javascript:productList(\'' + categoryId + '\')';
    	} else if(cc_cnst_PickListConstants.MENU_LINK_TYPE_PRODUCT.equalsIgnoreCase(linkType)) {
    		menuLink = 'javascript:productDetails(\'' + productId + '\')';
    	} else if(cc_cnst_PickListConstants.MENU_LINK_TYPE_URL.equalsIgnoreCase(linkType)) {
    		menuLink = URL;
    	}
    	*/
    	return menuLink;
    }
}