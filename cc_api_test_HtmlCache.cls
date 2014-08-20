@isTest
private class cc_api_test_HtmlCache {

    static testMethod void testMenuCache() {
        cc_hlpr_InitLoadCustomSettings.loadCloudCrazeApplicationSettings();
        cc_hlpr_InitLoadCustomSettings.loadCloudCrazeStorefrontSettings();

        Date startDate = System.today();
        Date endDate = System.today() + 1000;
        
        E_Category__c testCategory = new E_Category__c(Name='menutestcategory1321312', CategoryID__c='92323432');
        insert testCategory;
        
        E_Product__c testProduct = new E_Product__c(Name='menutestproduct23124', SKU__c='1232321');
        insert testProduct;
        
        E_Menu__c menu1 = new E_Menu__c(DisplayName__c='Menu1', Enabled__c=true, StartDate__c=startDate, EndDate__c=endDate, Sequence__c=100);
        E_Menu__c menu2 = new E_Menu__c(DisplayName__c='Menu2', Enabled__c=true, StartDate__c=startDate, EndDate__c=endDate, Sequence__c=200, LinkType__c='Category', Category__c=testCategory.Id);
        E_Menu__c menu3 = new E_Menu__c(DisplayName__c='Menu3', Enabled__c=true, StartDate__c=startDate, EndDate__c=endDate, Sequence__c=300, LinkType__c='Product', Product__c=testProduct.Id);
        E_Menu__c menu4 = new E_Menu__c(DisplayName__c='Menu4', Enabled__c=true, StartDate__c=startDate, EndDate__c=endDate, Sequence__c=400, LinkType__c='URL', URL__c='www.cloudcrazedev.com', NewWindow__c=true);
        
        List<E_Menu__c> menuListL1 = new List<E_Menu__c>{menu1, menu2, menu3, menu4};
        insert menuListL1;
        
        E_MenuItem__c menuItem1_1 = new E_MenuItem__c(Menu__c=menu1.Id, DisplayName__c='MenuItem1_1', Enabled__c=true, StartDate__c=startDate, EndDate__c=endDate, Sequence__c=100);
        E_MenuItem__c menuItem1_2 = new E_MenuItem__c(Menu__c=menu1.Id, DisplayName__c='MenuItem1_2', Enabled__c=true, StartDate__c=startDate, EndDate__c=endDate, Sequence__c=200, LinkType__c='Category', Category__c=testCategory.Id);
        E_MenuItem__c menuItem1_3 = new E_MenuItem__c(Menu__c=menu1.Id, DisplayName__c='MenuItem1_3', Enabled__c=true, StartDate__c=startDate, EndDate__c=endDate, Sequence__c=300, LinkType__c='Product', Product__c=testProduct.Id);
        
        E_MenuItem__c menuItem2_1 = new E_MenuItem__c(Menu__c=menu2.Id, DisplayName__c='MenuItem2_1', Enabled__c=true, StartDate__c=startDate, EndDate__c=endDate, Sequence__c=100, LinkType__c='URL', URL__c='www.cloudcrazedev.com', NewWindow__c=true);
        E_MenuItem__c menuItem2_2 = new E_MenuItem__c(Menu__c=menu2.Id, DisplayName__c='MenuItem2_2', Enabled__c=true, StartDate__c=startDate, EndDate__c=endDate, Sequence__c=200);
        E_MenuItem__c menuItem2_3 = new E_MenuItem__c(Menu__c=menu2.Id, DisplayName__c='MenuItem2_3', Enabled__c=true, StartDate__c=startDate, EndDate__c=endDate, Sequence__c=300);
        
        List<E_MenuItem__c> menuItemsL2 = new List<E_MenuItem__c> {menuItem1_1, menuItem1_2, menuItem1_3, menuItem2_1, menuItem2_2, menuItem2_3};
        insert menuItemsL2;
        
        E_MenuItem__c menuItem1_1_1 = new E_MenuItem__c(ParentMenuItem__c=menuItem1_1.Id, DisplayName__c='MenuItem1_1_1', Enabled__c=true, StartDate__c=startDate, EndDate__c=endDate);
        E_MenuItem__c menuItem1_1_2 = new E_MenuItem__c(ParentMenuItem__c=menuItem1_1.Id, DisplayName__c='MenuItem1_1_2', Enabled__c=true, StartDate__c=startDate, EndDate__c=endDate);
        E_MenuItem__c menuItem1_1_3 = new E_MenuItem__c(ParentMenuItem__c=menuItem1_1.Id, DisplayName__c='MenuItem1_1_3', Enabled__c=true, StartDate__c=startDate, EndDate__c=endDate, LinkType__c='URL', URL__c='www.cloudcrazedev.com', NewWindow__c=true);
        
        E_MenuItem__c menuItem1_2_1 = new E_MenuItem__c(ParentMenuItem__c=menuItem1_2.Id, DisplayName__c='MenuItem1_2_1', Enabled__c=true, StartDate__c=startDate, EndDate__c=endDate);
        E_MenuItem__c menuItem1_2_2 = new E_MenuItem__c(ParentMenuItem__c=menuItem1_2.Id, DisplayName__c='MenuItem1_2_2', Enabled__c=true, StartDate__c=startDate, EndDate__c=endDate);

        E_MenuItem__c menuItem2_1_1 = new E_MenuItem__c(ParentMenuItem__c=menuItem2_1.Id, DisplayName__c='MenuItem2_1_1', Enabled__c=true, StartDate__c=startDate, EndDate__c=endDate);
        
        List<E_MenuItem__c> menuItemsL3 = new List<E_MenuItem__c> {menuItem1_1_1, menuItem1_1_2, menuItem1_1_3, menuItem1_2_1, menuItem1_2_2, menuItem2_1_1};
        insert menuItemsL3;

    	Test.startTest();

        cc_api_HtmlCache.cacheMenus();
        
        String menuHtml = cc_api_HtmlCache.getMenuHtml('DefaultStore', 'en_US');
        //System.assertNotEquals(null, menuHtml);
        
        cc_api_HtmlCache.deleteAllMenuHtmlCaches();
        List<E_HtmlCache__c> menuCaches = [select Id from E_HtmlCache__c where HtmlType__c = :cc_cnst_PickListConstants.HTML_CACHE_TYPE_MENU];
        //System.assertEquals(0, menuCaches.size());
        
        Test.stopTest();
    
    }
    static testMethod void testCategoryCache() {
        cc_hlpr_InitLoadCustomSettings.loadCloudCrazeApplicationSettings();
        cc_hlpr_InitLoadCustomSettings.loadCloudCrazeStorefrontSettings();
        cc_hlpr_InitLoadCustomSettings.loadLanguageCodes();
        cc_hlpr_InitLoadCategories.loadTestCategories();
        
        List<E_Category__c> loadedCategories = [select Name, CategoryID__c from E_Category__c];
        System.debug('--- loaded categories=' + loadedCategories);
        
    	Test.startTest();
    	
    	cc_util_BreadCrumb.loadBreadCrumbs();
    	cc_api_HtmlCache.cacheCategoryTreeHtml();
    	
    	String categoryHtml = cc_api_HtmlCache.getCategoryTreeHtml('DefaultStore', 'en_US');
        List<E_HtmlCache__c> tempCategoryCaches = [select Id from E_HtmlCache__c where HtmlType__c = :cc_cnst_PickListConstants.HTML_CACHE_TYPE_CATEGORY];
        System.debug('--- tempCategoryCaches=' + tempCategoryCaches);
    	
    	//System.assertNotEquals(null, categoryHtml);
    	
    	cc_api_HtmlCache.deleteAllCategoryTreeHtmlCaches();
        List<E_HtmlCache__c> categoryCaches = [select Id from E_HtmlCache__c where HtmlType__c = :cc_cnst_PickListConstants.HTML_CACHE_TYPE_CATEGORY];
        //System.assertEquals(0, categoryCaches.size());
        
        Test.stopTest();
    	
    }
}