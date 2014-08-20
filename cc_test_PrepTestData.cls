//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public without sharing class cc_test_PrepTestData {
	//==================================================
    // CONSTANTS
    //==================================================
	public with sharing class TestPrepException extends Exception {}
	public static String PROFILE_STANDARD_USER = 'Standard User';
    public static String PROFILE_CUSTOMER_PORTAL_MANAGER = 'CloudCraze High Volume Customer Portal User';

    //==================================================
    // STATIC HELPER METHODS
    //==================================================
    public static E_TaxRate__c insertTaxRate(String countryCode, String stateCode, String taxrateID) {
        E_TaxRate__c taxRate = new E_TaxRate__c();
        taxRate.CountryCode__c = countryCode;
        taxRate.StateCode__c = stateCode;
        taxRate.TaxRateID__c = taxRateID;
        insert taxRate;
        return taxRate;
    }

    public Static List<E_Product__c> insertProduct(Integer count) {
        List<E_Product__c> productList = new List<E_Product__c>();
        Integer i = 0;
        
        while(i < count){
            E_Product__c prod = new E_Product__c();
            prod.SKU__c = 'UNV21200'+String.valueOf(i);
            prod.Name = 'ProductName'+String.valueOf(i);
            prod.LeadTime__c = 1;
            prod.QuantityPerUnit__c = 1;
            prod.StartDate__c = System.today();
            prod.EndDate__c = System.today();
            //prod.ProductStatus__c = thisCode.id;
            prod.ProductStatus__c=cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED;
            prod.RequiredItemDialogText__c = 'Required';
            prod.ShippingWeight__c = 1;
            productList.add(prod);
            i++;
        }
        insert productlist;
        insertProductMedia(productList);
        
        return productList;
    }
    
    public Static E_Rule__c insertRule() {
    	E_Rule__c rule=new E_Rule__c();
    	rule.RuleType__c=cc_cnst_PickListConstants.RULETYPE_GENERAL;
    	rule.StartDate__c = System.today();
    	rule.EndDate__c = System.today()+5;    	
    	rule.Relation__c=cc_cnst_PickListConstants.RULERELATION_SKU;
    	rule.Name__c='test rule';
    	insert rule;
    	return rule;
    }
    
    public static List<E_ProductMedia__c> insertProductMedia(List<E_Product__c> prodList) {
        List<E_ProductMedia__c> mediaList = new List<E_ProductMedia__c>();
        for(E_Product__c thisProd : prodList){
            E_ProductMedia__c media = new E_ProductMedia__c();
            media.Product__c = thisProd.id;
            media.URI__c = 'media URI Dummy';
            media.EndDate__c = System.today();
            media.StartDate__c = System.today();
            mediaList.add(media);
            
        }
        insert mediaList;
        return mediaList;
        
    }

    public static List<E_RelatedProduct__c> insertRelatedProduct(Id prod1, Id prod2) {
    	return insertRelatedProduct(prod1, prod2, cc_cnst_PickListConstants.RELATEDPRODUCT_RELATED);
    }

    public static List<E_RelatedProduct__c> insertRelatedProduct(Id prod1, Id prod2, String relationship) {
        List<E_RelatedProduct__c> relatedproductList = new List<E_RelatedProduct__c>();
        E_RelatedProduct__c thisRelatedProduct = new E_RelatedProduct__c();
        thisRelatedProduct.Product__c = prod1;
        thisRelatedProduct.RelatedProduct__c = prod2;
        thisRelatedProduct.StartDate__c = System.today();
        //E_Code__c thisCode = insertCode('RelatedProduct', 'Test Sell', '700');
        //thisRelatedProduct.RelatedProductType__c = thisCode.id;
        thisRelatedProduct.RelatedProductType__c = relationship;
        thisRelatedProduct.EndDate__c = System.today() + 1;
        thisRelatedProduct.Sequence__c = 500;
        relatedproductList.add(thisRelatedProduct);
        insert relatedproductList; 
        return relatedproductList;
    }

    public static List<E_ProductCategory__c> insertProductCategory(E_Category__c cat, E_Product__c prod){
        List<E_ProductCategory__c> prodCatlist = new List<E_ProductCategory__c>();
        E_ProductCategory__c prodCat = new E_ProductCategory__c();
        prodCat.Product__c = prod.id;
        prodCat.Category__c = cat.id;
        prodCat.StartDate__c = System.today();
        prodCat.EndDate__c = System.today();
        prodCatlist.add(prodCat);
        insert prodCatlist;
        return prodCatList;
    }

    public static List<E_Category__c> insertCategory(){
        
        // TO DO: implement unit test
        List<E_Category__c> listCategory=new List<E_Category__c>();
        E_Category__c rootCategory=new E_Category__c();
        rootCategory.Name='Root';
        rootCategory.Sequence__c=0;
        rootCategory.CategoryID__c='123';
        listCategory.add(rootCategory);
      
        E_Category__c xyzCategory=new E_Category__c();
        xyzCategory.Name='Palm';
        xyzCategory.Sequence__c=100;
        xyzCategory.ShortDesc__c='Palm Category';
        xyzCategory.ParentCategory__c=rootCategory.Id;
        xyzCategory.CategoryID__c='456';
        listCategory.add(xyzCategory);
        
        E_Category__c childCategory=new E_Category__c();
        childCategory.Name='AT&T';
        childCategory.Sequence__c=100;
        childCategory.ShortDesc__c='Palm Category';
        childCategory.ParentCategory__c=xyzCategory.Id;
        childCategory.CategoryID__c='789';
        listCategory.add(childCategory);
        
       insert listCategory;
        
       return listCategory;    
    }

    public static List<E_CartItem__c> insertCartItems(List<E_Product__c> productList, String cartId) {
        List<E_CartItem__c> cartItemList = new List<E_CartItem__c>();
        for(E_Product__c thisProd : productList){
            E_CartItem__c cartItem = new E_CartItem__c();
            cartItem.Quantity__c = 1;
            cartItem.Price__c = 25;
            cartItem.Product__c = thisProd.id;
            cartItem.Cart__c = cartId;
            cartItemList.add(cartItem);
        }
        insert cartItemList;
        return cartItemList;
    }

    public static E_Cart__c insertCart(Boolean activeCart, String cartStatus) {
        E_Cart__c cartHeader = new E_Cart__c();
        cartHeader.CartStatus__c=cartStatus;
        cartHeader.User__c = UserInfo.getUserId();
        cartHeader.Name__c = 'Dummy Cart Name';
        cartHeader.OwnerId = UserInfo.getUserId();
        cartHeader.AnonymousID__c = false;
        cartHeader.ActiveCart__c = activeCart;
        cartHeader.cartType__c = 'Cart';
        cartHeader.SessionID__c = 'Dummy Session';
        
        insert cartHeader;
        return cartHeader;
    }

    public static E_Cart__c insertWishList(){       
        E_Cart__c cartHeader = new E_Cart__c();        
        cartHeader.User__c = UserInfo.getUserId();
        cartHeader.Name__c = 'Dummy WishList';
        cartHeader.OwnerId = UserInfo.getUserId();
        cartHeader.AnonymousID__c = false;
        //cartHeader.CartType__c = wishListType.id;
        cartHeader.CartType__c = cc_cnst_PickListConstants.CARTTYPE_WISHLIST;
        cartHeader.SessionID__c = 'Dummy Session';
        cartHeader.User__c = UserInfo.getUserId();
        
        insert cartHeader;
        return cartHeader;
    }

    public static void truncate(String sObjectName) {
    	String q = 'select Id from ' + sObjectName;
    	List<SObject> objects = Database.query(q);
    	delete objects;
    }
    
    public static E_ApplicationSettings__c insertAppCustomSetting(Boolean clean, String storeName, String anonymousAccountName, String anonymousUsername) {
    	if(clean) {
    		Map<String, E_ApplicationSettings__c> appMap = E_ApplicationSettings__c.getAll();
    		List<E_ApplicationSettings__c> apps = appMap.values();
    		delete apps;
    	}
    	
    	E_ApplicationSettings__c app = new E_ApplicationSettings__c(
    	       name = cc_cnst_CloudCraze.DEFAULT_APPLICATION_NAME,
    	       Default_Storefront__c = storeName,
    	       Anonymous_Account_Name__c = anonymousAccountName,
    	       Anonymous_Username__c = anonymousUsername);

    	insert app;
    	return app;
    }
    
    public static E_StorefrontSettings__c insertStorefrontCustomSetting(Boolean clean, String storeName, String supportUrl, String portalAccountName) {
        if(clean) {
            Map<String, E_StorefrontSettings__c> appMap = E_StorefrontSettings__c.getAll();
            List<E_StorefrontSettings__c> apps = appMap.values();
            delete apps;
        }
        
        E_StorefrontSettings__c storefront = new E_StorefrontSettings__c(
                name = storeName,
                Support_URL__c = supportUrl,
                Customer_Portal_Account_Name__c = portalAccountName
        );
        
        //System.debug('--- insertStorefrontCustomSetting storefront: ' + storefront);

        insert storefront;
        return storefront;
    }
    
    /*
     * Creates a new user with the provided profile
     * @param profileName name of profile the user will belong to; defaults to Standard Profile
     */
    public static User createUser() {
    	return cc_test_PrepTestData.createUser(cc_test_PrepTestData.PROFILE_STANDARD_USER);
    }

    public static User createUser(String profileName) {
    	return cc_test_PrepTestData.createUser(profileName, null);
    }

    public static User createUser(String profileName, String username) {
	    List<Profile> ps = [select id from profile where name = :profileName limit 1];
	    if(ps == null || ps.size() < 1 || ps.get(0) == null) {
	    	throw new TestPrepException('Profile [' + profileName + '] not found. Unable to create user for this profile.');
	    }
	    
	    String alias = username;
	    if(alias == null) {
		    Integer newUserNumber = [select count() from User LIMIT 2000] + 1;
		    alias = 'tuser' + newUserNumber;
	    } else if(alias.length() > 5) {
	    	alias = alias.substring(0, 5);
	    }
	    
	    Profile p = ps.get(0);
	    User u = new User(alias = alias,
	                      email = username + '@testorg.com',
	                      emailencodingkey = 'UTF-8',
	                      lastname = 'Tester',
	                      languagelocalekey = 'en_US',
	                      localesidkey = 'en_US',
	                      profileid = p.Id,
	                      timezonesidkey = 'America/Denver',
	                      username = username + '@testorg.com');
        return u;
    }
    
    public static User insertUser() {
    	User u = cc_test_PrepTestData.createUser();
    	insert u;
    	return u;
    }

    // TODO: implement this method
    public static User insertPortalUser(String username) {
    	E_StorefrontSettings__c storefront = cc_util_CloudCraze.getDefaultStorefrontSettings();
    	Account portalAccount = insertAccount(true, username, 'Test portal user', '111-222-3333');//cc_util_CloudCraze.getAccountByName(storefront.Customer_Portal_Account_Name__c);
    	
    	//Contact c = new Contact();
    	Contact c = [select id from Contact where AccountId =: portalAccount.Id];
    	//portalAccount.LastName = username;
    	//portalAccount.FirstName = 'Test portal user';
    	//c.AccountId = portalAccount.Id;
    	//portalAccount.Phone = '111-222-3333';
    	//insert c;
    	//update portalAccount;
    	
    	//List<UserRole> portalRoles = [select Id from UserRole where Name = '']
    	
    	User u = cc_test_PrepTestData.createUser(cc_test_PrepTestData.PROFILE_CUSTOMER_PORTAL_MANAGER, username);
    	u.ContactId = c.Id;
    	u.firstName = portalAccount.firstName;
    	
    	System.debug('--- storefront: ' + storefront + ' ---');
        System.debug('--- account: ' + portalAccount + ' ---');
        System.debug('--- contact: ' + c + ' ---');
        System.debug('--- user: ' + u + ' ---');

    	insert u;
    	
    	return u;
    }
    
    public static Account insertAccount(String name) {
        return cc_test_PrepTestData.insertAccount(true, name);
    }
    public static Account insertAccount(boolean clean, String name) {
    	return cc_test_PrepTestData.insertAccount(true, name, null, null);
    }
    public static Account insertAccount(boolean clean, String name, String firstname, String phone) {
    	Account a = null;
    	
        Account[] matches = [select Id from Account where Name = :name];
        //System.debug('--- found ' + matches.size() + ' accounts matching name: ' + name + ' ---');

        if(matches != null && matches.size() > 0) {
	    	if(clean) {
	        	delete matches;
	    	} else {
	    		a = matches[0];
	    	}
    	}
        
        if(a == null) {
            E_AccountGroup__c ag = insertAccountGroup(clean, name);  	
		RecordType rt = [Select r.Name, r.Id From RecordType r where r.Name = 'Person Account' limit 1];
		a = new Account(LastName=name, FirstName = firstname, Phone = phone, RecordTypeID = rt.Id, E_AccountGroup__c= ag.Id, OwnerId=userInfo.getUserId());
		insert a;
		//a = new Account(name = name, E_AccountGroup__c = ag.Id);
    	    //insert a;
        }

    	return a;
    }
    
    public static E_AccountGroup__c insertAccountGroup(boolean clean, String name) {
    	E_AccountGroup__c a = null;

    	E_AccountGroup__c[] matches = [select Id from E_AccountGroup__c where Name = :name];
        //System.debug('--- found ' + matches.size() + ' AccountGroups matching name: ' + name + ' ---');

        if(matches != null && matches.size() > 0) {
            if(clean) {
                delete matches;
            } else {
                a = matches[0];
            }
        }
        
        if(a == null) {
            a = new E_AccountGroup__c(name = name);
            insert a;
        }

        return a;
    }
    
    public static void loadCustomSettings() {
        cc_hlpr_InitLoadCustomSettings.loadCloudCrazeApplicationSettings();
        cc_hlpr_InitLoadCustomSettings.loadCloudCrazeStorefrontSettings();
    }

    public static void loadAllCustomSettings() {
    	cc_test_PrepTestData.loadCustomSettings();

        cc_hlpr_InitLoadCustomSettings.loadCountryCodes(new Set<String> {'US','ES','CA'});
        cc_hlpr_InitLoadCustomSettings.loadCurrencyCodes();
        cc_hlpr_InitLoadCustomSettings.loadPageConfigurations();
        cc_hlpr_InitLoadCustomSettings.loadStateCodes();
    }

    public static void loadInitData() {
        cc_hlpr_InitDataSet.initialize();
        cc_hlpr_InitDataSet.loadAccountGroup();
        cc_hlpr_InitDataSet.loadAccount();
        cc_hlpr_InitDataSet.loadPriceList();
        cc_hlpr_InitDataSet.loadAccountGroupPriceList();
    }
     
    public static void loadTestCategoryData() {
        cc_hlpr_InitLoadCategories.loadTestCategories();
        cc_hlpr_InitLoadCategories.loadTestProducts();
        cc_hlpr_InitLoadCategories.loadTestProductCategories();
        cc_hlpr_InitLoadCategories.loadTestPriceListItems();
        cc_hlpr_InitLoadCategories.loadTestSpecs();
    }
    
    public static List<E_Product__c> getAllTestProducts() {
    	return [select Id, Name, ProductStatus__c, ProductType__c, Sku__c, Storefront__c, UnitOfMeasure__c, InventoryType__c, RequiredItemDialogText__c from E_Product__c where Name like 'CloudCrazeTestProduct%'];
    }

    public static void insertPricingTiers(E_PriceListItem__c item, String tierType, List<cc_ctrl_PriceListItemTiers.TierStruct> tierValues) {
        E_Rule__c rule = new E_Rule__c(
                Relation__c='Pricelist Item',
                Name__c='PLI-' + item.Name + '-tiered-pricing-rule',
                RuleType__c=tierType,
                RuleSource__c='Pricing',
                Enabled__c=true,
                CurrencyISOCode__c=cc_ctrl_PricingEngine.getCurrencyCode(),
                CustomerTypeCode__c=cc_ctrl_PricingEngine.getCustomerType());
        insert rule;
        
        // create a price modifier record for each tier
        List<E_PriceModifier__c> pms = new List<E_PriceModifier__c>();
        for(cc_ctrl_PriceListItemTiers.TierStruct tier : tierValues) {
            if(tier.low == null || tier.low.trim().length()==0) {
                break;
            }
            
            System.debug('--- adding PriceModifier: low=' + tier.low + ', valueType=' + tier.valueType + ', amount=' + tier.amount);

            E_PriceModifier__c modifier = new E_PriceModifier__c(DiscountType__c=tier.valueType, 
                Amount__c=tier.amount, Quantity__c=double.valueOf(tier.low));
            pms.add(modifier);
        }
        insert pms;

        // tie the pricing modifiers to the rule
        List<E_RulePricingModifier__c> rpms = new List<E_RulePricingModifier__c>();
        for(E_PriceModifier__c pm : pms) {
            rpms.add(new E_RulePricingModifier__c(Rule__c=rule.Id, PriceModifier__c=pm.Id));
        }
        insert(rpms);
        
        // tie the rule to the pricelist item
        insert new E_RuleTargetPLI__c(E_Rule__c=rule.Id, E_PriceListItem__c=item.Id);
    }

    public static List<cc_ctrl_PriceListItemTiers.TierStruct> getTestTiers() {
        List<cc_ctrl_PriceListItemTiers.TierStruct> tierValues = new List<cc_ctrl_PriceListItemTiers.TierStruct>();

        cc_ctrl_PriceListItemTiers.TierStruct tier = new cc_ctrl_PriceListItemTiers.TierStruct();
        tier.low = '5';
        tier.valueType = cc_cnst_CloudCraze.DISCOUNTTYPE_PERCENTAGE;
        tier.amount = 5;
        tierValues.add(tier);
        
        tier = new cc_ctrl_PriceListItemTiers.TierStruct();
        tier.low = '10';
        tier.valueType = cc_cnst_CloudCraze.DISCOUNTTYPE_PERCENTAGE;
        tier.amount = 10;
        tierValues.add(tier);

        tier = new cc_ctrl_PriceListItemTiers.TierStruct();
        tier.low = '20';
        tier.valueType = cc_cnst_CloudCraze.DISCOUNTTYPE_PERCENTAGE;
        tier.amount = 20;
        tierValues.add(tier);

        tier = new cc_ctrl_PriceListItemTiers.TierStruct();
        tier.low = '30';
        tier.valueType = cc_cnst_CloudCraze.DISCOUNTTYPE_PERCENTAGE;
        tier.amount = 30;
        tierValues.add(tier);

        tier = new cc_ctrl_PriceListItemTiers.TierStruct();
        tier.low = '40';
        tier.valueType = cc_cnst_CloudCraze.DISCOUNTTYPE_PERCENTAGE;
        tier.amount = 40;
        tierValues.add(tier);

        tier = new cc_ctrl_PriceListItemTiers.TierStruct();
        tier.low = '50';
        tier.valueType = cc_cnst_CloudCraze.DISCOUNTTYPE_PERCENTAGE;
        tier.amount = 50;
        tierValues.add(tier);
        
        return tierValues;
    }
    

    public static User getGuestUser() {
        User guest = null;
	   	List<User> guests = [SELECT FirstName, LastName FROM User WHERE UserType = 'Guest' and isActive=true];
	   	if(guests != null && guests.size() > 0) {
	   		guest = guests[0];
	   	}
	   	return guest;
    }

}