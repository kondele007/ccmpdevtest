//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public without sharing class cc_test_TestDataSetup {
	public static User testUser;
	public static Account testAccount;
 	static Map<String, string> selectedAggregatedProduct = new Map<String, string>();
	public static final String PROFILE_CUSTOMER_PORTAL='CloudCraze High Volume Customer Portal User';
	public static final String PROFILE_SYSTEM_ADMIN='System Administrator';
	public static Map<String, string> getSelectedAggregatedProduct() { return selectedAggregatedProduct; }
	public static void loadData()
	{
		if(Test.isRunningTest())
    	{
	        cc_hlpr_InitLoadCustomSettings.loadCloudCrazeApplicationSettings();
	        cc_hlpr_InitLoadCustomSettings.loadCloudCrazeStorefrontSettings();
	        cc_hlpr_InitLoadCustomSettings.loadCountryCodes();
	        cc_hlpr_InitLoadCustomSettings.loadCurrencyCodes();
	        cc_hlpr_InitLoadCustomSettings.loadLanguageCodes();
	        cc_hlpr_InitLoadCustomSettings.loadPageConfigurations();
	        cc_hlpr_InitLoadCustomSettings.loadStateCodes();
    		delete [select id from E_PriceList__c where Name in ('PortalAccount', 'Enterprise')];
    		delete [select id from Account where name='CloudCrazeTestAccount'];
    		delete [select id from E_AccountGroup__c where name = 'testAccountGroup'];
    		createAccountUser(PROFILE_CUSTOMER_PORTAL);
    	}
        
	}
	
	public static void loadCompositeProducts() {
		E_Product__c bundleProduct = new E_Product__c(Name='bundle 1', Sku__c='sku001', ProductStatus__c='Released', ProductType__c='Bundle');
    	E_Product__c aggregated1 = new E_Product__c(Name='Aggregated 1', Sku__c='sku002', ProductStatus__c='Released', ProductType__c='Aggregated');
    	E_Product__c childProduct1 = new E_Product__c(Name='Aggregate 1', Sku__c='sku003', ProductStatus__c='Released', ProductType__c='Product');
    	E_Product__c childProduct2 = new E_Product__c(Name='Aggregate 2', Sku__c='sku004', ProductStatus__c='Released', ProductType__c='Product');
    	E_Product__c childProduct3 = new E_Product__c(Name='Aggregate 3', Sku__c='sku005', ProductStatus__c='Released', ProductType__c='Product');
    	E_Product__c regularProduct = new E_Product__c(Name='product 1', Sku__c='sku006', ProductStatus__c='Released', ProductType__c='Product');
    	E_Product__c aggregated2 = new E_Product__c(Name='Aggregated 2', Sku__c='sku007', ProductStatus__c='Released', ProductType__c='Aggregated');
    	E_Product__c childProduct4 = new E_Product__c(Name='Aggregate 4', Sku__c='sku008', ProductStatus__c='Released', ProductType__c='Product');
    	E_Product__c childProduct5 = new E_Product__c(Name='Aggregate 5', Sku__c='sku009', ProductStatus__c='Released', ProductType__c='Product');
    	E_Product__c childProduct6 = new E_Product__c(Name='Aggregate 6', Sku__c='sku0010', ProductStatus__c='Released', ProductType__c='Product');
    	E_Product__c bundleProduct2 = new E_Product__c(Name='bundle 2', Sku__c='sku0011', ProductStatus__c='Released', ProductType__c='Bundle');
    	E_Product__c childProduct7 = new E_Product__c(Name='Product 7', Sku__c='sku0012', ProductStatus__c='Released', ProductType__c='Product');
    	E_Product__c childProduct8 = new E_Product__c(Name='Product 8', Sku__c='sku0013', ProductStatus__c='Released', ProductType__c='Product');
    	E_Product__c childProduct9 = new E_Product__c(Name='Product 9', Sku__c='sku0014', ProductStatus__c='Released', ProductType__c='Product');
    	E_Product__c kitProduct = new E_Product__c(Name='Kit 1', Sku__c='sku0015', ProductStatus__c='Released', ProductType__c='Kit');
    	E_Product__c childProduct11 = new E_Product__c(Name='Kit child 1', Sku__c='sku0016', ProductStatus__c='Released', ProductType__c='Product');
    	E_Product__c childProduct12 = new E_Product__c(Name='Kit child 2', Sku__c='sku0017', ProductStatus__c='Released', ProductType__c='Product');
    	E_Product__c childProduct13 = new E_Product__c(Name='Kit child 3', Sku__c='sku0018', ProductStatus__c='Released', ProductType__c='Product');
    	List<E_Product__c> pList = new List<E_Product__c> {bundleProduct, aggregated1, childProduct1, childProduct2, childProduct3, 
    			aggregated2, childProduct4, childProduct5, childProduct6, regularProduct, bundleProduct2, childProduct7, childProduct8, childProduct9,
    			kitProduct, childProduct11, childProduct12, childProduct13};
    	insert pList;
    	String rootId = cc_cnst_CloudCraze.DEFAULT_ROOT_CATEGORY_ID;
    	E_Category__c root = new E_Category__c(Name='Root', CategoryID__c=rootId);
        insert root;
        
        E_Category__c directChild = new E_Category__c(Name='directChild', CategoryID__c='directChild', parentCategory__c = root.id);
        insert directChild;
        
    	E_Category__c category = new E_Category__c(Name='Handsets', CategoryID__c='Handsets', parentCategory__c = root.id);
        insert category;
        
        List<E_ProductCategory__c> pcs = new List<E_ProductCategory__c>{
        		new E_ProductCategory__c(Category__c=category.id, Product__c=bundleProduct.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=aggregated1.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=childProduct1.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=childProduct2.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=childProduct3.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=aggregated2.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=childProduct4.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=childProduct5.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=childProduct6.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=regularProduct.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=bundleProduct2.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=childProduct7.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=childProduct8.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=kitProduct.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=childProduct11.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=childProduct12.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=childProduct13.id),
        		new E_ProductCategory__c(Category__c=category.id, Product__c=childProduct9.id)
        };
        
        insert pcs;
        
    	selectedAggregatedProduct.put(aggregated1.id, childProduct2.id);
    	selectedAggregatedProduct.put(aggregated2.id, childProduct5.id);
    	List<E_PriceListItem__c> priceLineList = new List<E_PriceListItem__c> ();
    	priceLineList.add( new E_PriceListItem__c(Pricelist__r=new E_PriceList__c(PricelistId__c='1'), Product__c=bundleProduct.id, Price__c=200));
    	priceLineList.add( new E_PriceListItem__c(Pricelist__r=new E_PriceList__c(PricelistId__c='1'), Product__c=aggregated1.id, Price__c=100));
    	priceLineList.add( new E_PriceListItem__c(Pricelist__r=new E_PriceList__c(PricelistId__c='1'), Product__c=childProduct1.id, Price__c=100));
    	priceLineList.add( new E_PriceListItem__c(Pricelist__r=new E_PriceList__c(PricelistId__c='1'), Product__c=childProduct2.id, Price__c=100));
    	priceLineList.add( new E_PriceListItem__c(Pricelist__r=new E_PriceList__c(PricelistId__c='1'), Product__c=childProduct3.id, Price__c=100));
    	priceLineList.add( new E_PriceListItem__c(Pricelist__r=new E_PriceList__c(PricelistId__c='1'), Product__c=regularProduct.id, Price__c=200));
    	priceLineList.add( new E_PriceListItem__c(Pricelist__r=new E_PriceList__c(PricelistId__c='1'), Product__c=aggregated2.id, Price__c=90));
    	priceLineList.add( new E_PriceListItem__c(Pricelist__r=new E_PriceList__c(PricelistId__c='1'), Product__c=childProduct4.id, Price__c=90));
    	priceLineList.add( new E_PriceListItem__c(Pricelist__r=new E_PriceList__c(PricelistId__c='1'), Product__c=childProduct5.id, Price__c=90));
    	priceLineList.add( new E_PriceListItem__c(Pricelist__r=new E_PriceList__c(PricelistId__c='1'), Product__c=childProduct6.id, Price__c=90));
    	
    	priceLineList.add( new E_PriceListItem__c(Pricelist__r=new E_PriceList__c(PricelistId__c='1'), Product__c=bundleProduct2.id, Price__c=200));
    	priceLineList.add( new E_PriceListItem__c(Pricelist__r=new E_PriceList__c(PricelistId__c='1'), Product__c=childProduct7.id, Price__c=100));
    	priceLineList.add( new E_PriceListItem__c(Pricelist__r=new E_PriceList__c(PricelistId__c='1'), Product__c=childProduct8.id, Price__c=100));
    	priceLineList.add( new E_PriceListItem__c(Pricelist__r=new E_PriceList__c(PricelistId__c='1'), Product__c=childProduct9.id, Price__c=100));
    	priceLineList.add( new E_PriceListItem__c(Pricelist__r=new E_PriceList__c(PricelistId__c='1'), Product__c=childProduct11.id, Price__c=100));
    	priceLineList.add( new E_PriceListItem__c(Pricelist__r=new E_PriceList__c(PricelistId__c='1'), Product__c=childProduct12.id, Price__c=200));
    	priceLineList.add( new E_PriceListItem__c(Pricelist__r=new E_PriceList__c(PricelistId__c='1'), Product__c=childProduct13.id, Price__c=90));
    	priceLineList.add( new E_PriceListItem__c(Pricelist__r=new E_PriceList__c(PricelistId__c='1'), Product__c=kitProduct.id, Price__c=90));
    	
    	
        insert priceLineList;
        
        List<E_ProductMedia__c> pMedias = new List<E_ProductMedia__c>();
        pMedias.add(new E_ProductMedia__c(Product__c=childProduct1.id, MediaType__c='Product Search Image', ProductMediaSource__c='URI', URI__c='MyImageURI'));
        pMedias.add(new E_ProductMedia__c(Product__c=childProduct2.id, MediaType__c='Product Search Image', ProductMediaSource__c='URI', URI__c='MyImageURI'));
        pMedias.add(new E_ProductMedia__c(Product__c=childProduct3.id, MediaType__c='Product Search Image', ProductMediaSource__c='URI', URI__c='MyImageURI'));
        pMedias.add(new E_ProductMedia__c(Product__c=childProduct4.id, MediaType__c='Product Search Image', ProductMediaSource__c='URI', URI__c='MyImageURI'));
        pMedias.add(new E_ProductMedia__c(Product__c=childProduct5.id, MediaType__c='Product Search Image', ProductMediaSource__c='URI', URI__c='MyImageURI'));
        pMedias.add(new E_ProductMedia__c(Product__c=childProduct6.id, MediaType__c='Product Search Image', ProductMediaSource__c='URI', URI__c='MyImageURI'));
    	insert pMedias;
    	
    	//E_CompositeProduct__c cp0=new E_CompositeProduct__c( Component__c=bundleProduct.Id, Quantity__c=1, Optional__c=false);
    	//insert cp0;
    	
    	E_CompositeProduct__c cp1=new E_CompositeProduct__c(Composite__c=bundleProduct.id, Component__c=aggregated1.Id, Quantity__c=1, Optional__c=false, category__c=category.id);
    	insert cp1;
    	List<E_CompositeProduct__c> cp2l = new List<E_CompositeProduct__c>{
    		new E_CompositeProduct__c(Composite__c=aggregated1.id, Component__c=childProduct1.Id, Quantity__c=1, Optional__c=false, Parent__c=cp1.id, category__c=category.id),
    		new E_CompositeProduct__c(Composite__c=aggregated1.id, Component__c=childProduct2.Id, Quantity__c=1, Optional__c=false, Parent__c=cp1.id, category__c=category.id),
    		new E_CompositeProduct__c(Composite__c=aggregated1.id, Component__c=childProduct3.Id, Quantity__c=1, Optional__c=false, Parent__c=cp1.id, category__c=category.id)
    	};
    	insert cp2l;
    	E_CompositeProduct__c cp9=new E_CompositeProduct__c(Composite__c=bundleProduct.id, Component__c=aggregated2.Id, Quantity__c=1, Optional__c=false, category__c=category.id);
    	insert cp9;
    	
    	E_CompositeProduct__c cp6=new E_CompositeProduct__c(Composite__c=aggregated2.id, Component__c=childProduct4.Id, Quantity__c=1, Optional__c=false, Parent__c=cp9.id, category__c=category.id);
    	E_CompositeProduct__c cp7=new E_CompositeProduct__c(Composite__c=aggregated2.id, Component__c=childProduct5.Id, Quantity__c=1, Optional__c=false, Parent__c=cp9.id, category__c=category.id);
    	E_CompositeProduct__c cp8=new E_CompositeProduct__c(Composite__c=aggregated2.id, Component__c=childProduct6.Id, Quantity__c=1, Optional__c=false, Parent__c=cp9.id, category__c=category.id);
    	insert new list<E_CompositeProduct__c> {cp6, cp7, cp8};
    	E_CompositeProduct__c cp10=new E_CompositeProduct__c(Composite__c=bundleProduct.id, Component__c=regularProduct.Id, Quantity__c=1, Optional__c=false, category__c=category.id);
    	insert cp10;
    	
    	E_CompositeProduct__c cp14=new E_CompositeProduct__c(Composite__c=bundleProduct.id, Component__c=bundleProduct2.Id, Quantity__c=1, Optional__c=true, category__c=category.id);
    	insert cp14;
    	
    	E_CompositeProduct__c cp11=new E_CompositeProduct__c(Composite__c=bundleProduct2.id, Component__c=childProduct7.Id, Quantity__c=1, Optional__c=false, Parent__c=cp14.id, category__c=category.id);
    	insert cp11;
    	E_CompositeProduct__c cp12=new E_CompositeProduct__c(Composite__c=bundleProduct2.id, Component__c=childProduct8.Id, Quantity__c=1, Optional__c=false, Parent__c=cp14.id, category__c=category.id);
    	insert cp12;
    	E_CompositeProduct__c cp13=new E_CompositeProduct__c(Composite__c=bundleProduct2.id, Component__c=childProduct9.Id, Quantity__c=1, Optional__c=false, Parent__c=cp14.id, category__c=category.id);
    	insert cp13;
    	
    	E_CompositeProduct__c cp15=new E_CompositeProduct__c(Composite__c=bundleProduct2.id, Component__c=kitProduct.Id, Quantity__c=1, Optional__c=false, Parent__c=cp14.id, category__c=category.id);
    	insert cp15;
    	
    	E_CompositeProduct__c cp16=new E_CompositeProduct__c(Composite__c=kitProduct.id, Component__c=childProduct11.Id, Quantity__c=2, Optional__c=false, Parent__c=cp15.id, category__c=category.id);
    	insert cp16;
    	E_CompositeProduct__c cp17=new E_CompositeProduct__c(Composite__c=kitProduct.id, Component__c=childProduct12.Id, Quantity__c=3, Optional__c=false, Parent__c=cp15.id, category__c=category.id);
    	insert cp17;
    	E_CompositeProduct__c cp18=new E_CompositeProduct__c(Composite__c=kitProduct.id, Component__c=childProduct13.Id, Quantity__c=4, Optional__c=false, Parent__c=cp15.id, category__c=category.id);
    	insert cp18;
    	E_CompositeProduct__c cp19=new E_CompositeProduct__c(Composite__c=kitProduct.id, Component__c=aggregated1.Id, Quantity__c=1, Optional__c=false, Parent__c=cp15.id, category__c=category.id);
    	insert cp19;
	}
	public static void createAccountUser(String profileName) {
		System.debug('-----------' + profileName);
		cc_api_dl_accountGroups ag = new cc_api_dl_accountGroups();
		ag.loadData();
		
		/*
		Account acc = new Account(name='CloudCrazeTestAccount', E_AccountGroup__r= new E_AccountGroup__c(ACCOUNTGROUPID__C='1'), OwnerId=userInfo.getUserId());
		insert acc;
		*/
		RecordType rt = [Select r.Name, r.Id From RecordType r where r.Name = 'Person Account' limit 1];
		
		Account acc = new Account(LastName='CloudCrazeTestAccount', RecordTypeID = rt.Id, E_AccountGroup__r= new E_AccountGroup__c(ACCOUNTGROUPID__C='1'), OwnerId=userInfo.getUserId());
		insert acc;
		
		/*
		Contact c = new Contact(FirstName='joe', LastName='Smith', accountId=acc.id);
		insert c;
		*/
		Contact c = [select id from Contact where AccountId =: acc.Id];
		
		String randomUserName = String.valueOf(System.now().getTime()) + '@fido.com';
		User userObj=null;
		
		System.debug('--- cc_tst_TestDataSetup.createAccountUser: profileName=' + profileName);
		for(Profile p:[Select p.name, p.id From Profile p where p.Name= :profileName]) {
			userObj = new User(alias = 'flotv', email='fido@fido.com',
	        emailencodingkey='UTF-8', lastname='TestUser1', languagelocalekey='en_US',
	        localesidkey='en_US', profileid = p.Id,
	        timezonesidkey='America/Los_Angeles', username=randomUserName, isActive=true, ContactId=c.id);
	        insert userObj;
	        break;
		}
		testAccount = acc;
		testUser = userObj;
		loadPriceList();
		
		cc_api_dl_accountGroupPriceLists agpl = new cc_api_dl_accountGroupPriceLists();
		agpl.loadData();
		//E_AccountGroupPriceList__c agpl = new E_AccountGroupPriceList__c(AccountGroup__c = accountGroup.Id, Pricelist__r = new E_PriceList__c(PricelistId__c='1'), sequence__c=100); 
        //insert agpl;
	}
	public static void loadPriceList()
    {
    	/*
    	List<E_PriceList__c> priceLists = new List<E_PriceList__c>();
        priceLists.add(new E_PriceList__c(Name='Enterprise', Desc__c='Enterprise Price List', CustomerTypeCode__c='General',
                            CurrencyISOCode__c='USD', PricelistId__c='Enterprise'));
        priceLists.add(new E_PriceList__c(Name='test price list 1', Desc__c='Test Price List', CustomerTypeCode__c='General',
                            CurrencyISOCode__c='USD', PricelistId__c='test price list 1'));

        insert priceLists;
        */
        cc_api_dl_priceLists pl = new cc_api_dl_priceLists();
        pl.loadData();
    }
    
    static testMethod void unitTest() {
    	cc_test_TestDataSetup.loadData();
    	System.assert([Select c.Id From E_ApplicationSettings__c c where name='CloudCraze'].size() != 0);
    }
}