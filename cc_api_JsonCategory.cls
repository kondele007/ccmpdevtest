//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//

global with sharing class cc_api_JsonCategory {   

	//==================================================
    // CONSTRUCTOR
    //================================================== 
    public cc_api_JsonCategory () {}
    
    //==================================================
    // WEBSERVICES METHODS
    //==================================================     
    WebService static String childCategories(String cid) {  
    	for(E_Category__c c : [Select e.Id, e.Name, e.CategoryID__c from E_Category__c e])
    	{
    		System.debug('ryl--> name =' + c.name + '  category id-->' + c.CategoryID__c);
    	}  
    	System.debug('cc_api_JsonCategory:childCategories cc_cnst_CloudCraze.DEFAULT_ROOT_CATEGORY_ID ->' + cc_cnst_CloudCraze.DEFAULT_ROOT_CATEGORY_ID);
        String root = null;  
        String jsonRecordsString = '[';
        if((cid == null) || 'source'.equalsIgnoreCase(cid))
        {
            root = [Select e.Id, e.Name, e.ParentCategory__c from E_Category__c e where e.CategoryID__c = :cc_cnst_CloudCraze.DEFAULT_ROOT_CATEGORY_ID order by e.name limit 1].ID;
        }
        else
        {
            root = cid;
        }
        //System.debug('root = ' + root);
        List<E_Category__c> cs = [Select e.Id, e.Name, e.ParentCategory__c, (Select Id, Name From Categories__r), (Select id From Product_Categories__r where product__r.producttype__c in ('Bundle','Kit','Aggregated', 'Assembly')) from E_Category__c e  where e.ParentCategory__c = :root order by e.Sequence__c desc];
        
        for(E_Category__c c : cs )
        {
            List<E_Category__c> cc = c.Categories__r;
            List<E_ProductCategory__c> pc = c.Product_Categories__r;
            String val = c.Name.replace('"', '\\"');
            jsonRecordsString += '{';  
            jsonRecordsString += '"text":' + '"'+val+'",';  
             
            jsonRecordsString += '"id":' + '"'+c.ID+'"';
              
            if(cc.size() > 0 || pc.size() > 0)
            {
                jsonRecordsString += ',"hasChildren": true';  
            }  
            jsonRecordsString += '},'; 
                     
        }
        
        List<E_ProductCategory__c> pcs = [Select e.Product__r.Name,e.Product__r.ProductType__c, e.Product__c, e.category__c from E_ProductCategory__c e  where e.Category__c = :root and e.Product__r.producttype__c in ('Bundle','Kit','Aggregated', 'Assembly')];
        for(E_ProductCategory__c pc : pcs )
        {
            E_Product__c p = pc.Product__r;
            String val = p.Name.replace('"', '\\"');
            jsonRecordsString += '{';  
            jsonRecordsString += '"text":' + '"'+val+'",'; 
            jsonRecordsString += '"cid":' + '"'+pc.category__c+'",';  
            jsonRecordsString += '"id":' + '"'+p.ID+'"';    
            jsonRecordsString += ',"pType":' + '"'+p.ProductType__c+'"'; 
            jsonRecordsString += '},'; 
                     
        }
        
        jsonRecordsString += ']';
         
         jsonRecordsString = jsonRecordsString.replaceAll(',]',']'); 
         //System.debug(jsonRecordsString); 
         return jsonRecordsString; 

     }  
     
     
     
     
     WebService static void changeParent(String parent, String child) 
    {
    	E_Category__c c = [select c.id from E_Category__c c where c.id = :child];
    	c.ParentCategory__c = parent;
    	
    	update c;
    	
    }
    
    WebService static String products(String category) {    
        String root = null;  
        //System.debug('=============================' + category);
        List<E_ProductCategory__c> cs = [Select e.Product__c from E_ProductCategory__c e  where e.Category__c = :category ];
        List<Id> pIds = new List<Id>();
        //System.debug('&&&&&&&&&&&&&&&&&' + cs.size());
        for(E_ProductCategory__c c : cs)
        {
        	//System.debug('^^^^^^^^^^^^^^^^^^^' + c.Product__c);
        	pIds.add(c.Product__c);
        }
        List<E_Product__c> ps = [Select e.Id, e.Name, e.SKU__c, e.productType__c from E_Product__c e where e.Id in :pIds ];
       //System.debug('******************************' + ps.size());
        
         return createJSONProducts(ps, category); 
     }  
     
     
	WebService static void changeCategory(String pid, String oldCID, String newCID) 
	{
		List<E_ProductCategory__c> cs = [Select e.Id from E_ProductCategory__c e  where e.Category__c = :oldCID and e.Product__c = : pid and e.IsDeleted = false ];
		//System.debug('-------------11111111111111111----------------' + cs.size());
		delete cs;
		//System.debug('-------------222222222222222222----------------');
		E_ProductCategory__c pc = new E_ProductCategory__c(Product__c=pid, Category__c=newCID);
		insert pc;
		//System.debug('-------------333333333333333333333----------------');
	}
	
	WebService static String addCategory(String parentId, String name, String description) 
	{
		E_Category__c newCategory = new E_Category__c(Name=name, ShortDesc__c = description, ParentCategory__c=parentId, categoryID__c=name+String.valueOf(Crypto.getRandomInteger()));
		cc_dao_Product dao = new cc_dao_Product();
		dao.addCategory(newCategory);
		List<E_Category__c> cl = new List<E_Category__c>();
		cl.add(newCategory);
		return createJSONCategories(cl);
	}
	
	WebService static String addCategoryToRoot(String name, String description) 
	{
		cc_dao_Product dao = new cc_dao_Product(); 
		E_Category__c root = dao.getRootCategory(); 
		E_Category__c newCategory = new E_Category__c(Name=name, ShortDesc__c = description, ParentCategory__c=root.id,  categoryID__c=name+String.valueOf(Crypto.getRandomInteger()));
		dao.addCategory(newCategory);
		List<E_Category__c> cl = new List<E_Category__c>();
		cl.add(newCategory);
		return createJSONCategories(cl);
	}
	
	
	WebService static String addProduct(String categoryId, String name, String sku, String shortDesc, String longDesc, Decimal price, String productType, String productStatus) 
	{
		cc_dao_Product dao = new cc_dao_Product();
		List<E_Product__c> pl = dao.readProduct(sku);
		if(pl.size() == 0)
		{
			E_Product__c product = new E_Product__c(Name=name, SKU__c=sku, ShortDesc__c=shortDesc, LongDesc__c=longDesc, QuantityPerUnit__c = 1.0, ProductStatus__c=productStatus, ProductType__c=productType);
			E_ProductCategory__c pc = dao.addProductCategory(categoryId, product);
			pl.add(product);
			cc_api_JsonCategory.updatePrice(sku, price);
			//if((productType == 'Bundle') || (productType == 'Kit') || (productType == 'Aggregated') || (productType == 'Assembly'))
			//{
			//	E_Config__c config = new E_Config__c(product__c=pc.Product__c);
			//	insert config;
			//}
		}
		else
		{
			for(E_Product__c product : pl)
			{
				dao.addProductCategory(categoryId, product);
				cc_api_JsonCategory.updatePrice(sku, price);
			}
		}
		
		return createJSONProducts(pl, categoryId);
	}
	
	WebService static String addExistingProduct(String categoryId, String sku) 
	{
		cc_dao_Product dao = new cc_dao_Product();
		List<E_Product__c> pl = dao.readProduct(sku);
		if(pl.size() != 0)
		{
			for(E_Product__c product : pl)
			{
				dao.addProductCategory(categoryId, product);
			}
		}
		
		return createJSONProducts(pl, categoryId);
	}
	
	WebService static String addBundleProduct(String categoryId, String name, String sku, String shortDesc, String longDesc, decimal price) 
	{
		cc_dao_Product dao = new cc_dao_Product(); 
		List<E_Product__c> pl = dao.readProduct(sku);
		if(pl.size() == 0)
		{
			E_Product__c product = new E_Product__c(Name=name, SKU__c=sku, ShortDesc__c=shortDesc, LongDesc__c=longDesc, QuantityPerUnit__c = 1.0, ProductType__c='Bundle', ProductStatus__c='Released');
			dao.addProductCategory(categoryId, product);
			pl.add(product);
			cc_api_JsonCategory.updatePrice(sku, price);
		}
		else
		{
			for(E_Product__c product : pl)
			{
				dao.addProductCategory(categoryId, product);
				cc_api_JsonCategory.updatePrice(sku, price);
			}
		}
		return createJSONProducts(pl, categoryId);
	}
	
	WebService static String deleteBundleProduct(String categoryId, String productId) 
	{
		List<E_CompositeProduct__c> bps = [select id from E_CompositeProduct__c where Composite__c= :productId];
		List<E_Product__c> ps = [select id from E_Product__c where id = :productId];
		List<E_ProductCategory__c> pcs = [select id, category__r.Name, category__r.id from E_ProductCategory__c where product__c=:productId and category__c = :categoryId];
		
		delete pcs;
		delete bps;
		delete ps;
		List<E_Category__c> cs = [Select e.Id, e.Name, e.ParentCategory__c, (Select Id, Name From Categories__r), (Select id From Product_Categories__r where product__r.producttype__c='Bundle') from E_Category__c e  where e.id = :categoryId order by e.Sequence__c desc];
		
		return createJSONCategories(cs);
	}
	
	WebService static String deleteBundleProductItem(String bundleId) 
	{
		try
		{
		List<E_CompositeProduct__c> bps = [select id from E_CompositeProduct__c where id = :bundleId];
		
		delete bps;
		
		return 'Ok'; 
		}
		catch(Exception e)
		{
			return e.getMessage();
		}
	}
	
	
	WebService static String bundleProducts(String productId) {    
        return createJSONBundleProducts(productId); 
     }  
     
	WebService static String addBundleProductItem(String parentId, String childId, Integer qty, boolean optional, String categoryId) 
	{
		E_CompositeProduct__c bundle = new E_CompositeProduct__c(Composite__c=parentId, Component__c=childId, Quantity__c=qty, Optional__c=optional, category__c = categoryId);
		insert bundle;
		return createJSONBundleProducts(parentId);
	}
	
	
	WebService static String updateBundleProductItem(String bundleProductId, Integer qty, boolean optional) 
	{
		String parentId = null;
		List<E_CompositeProduct__c> bps = [select id, Composite__c from E_CompositeProduct__c where id = :bundleProductId];
		for(E_CompositeProduct__c bp : bps)
		{
			parentId = bp.Composite__c;
			bp.Quantity__c = qty;
			bp.Optional__c = optional;
		}
		update bps;
		return createJSONBundleProducts(parentId);
		
		
	}
	
	//==================================================
    // HELPER METHODS
    //==================================================  
	public static String createJSONBundleProducts(String pid)
     {
     	List<E_CompositeProduct__c> bps = [Select e.id, e.Quantity__c, e.Optional__c, e.Composite__r.Name, e.Composite__c,  e.Component__c, e.Component__r.Name From E_CompositeProduct__c e where e.Composite__c =:pid];
     	String jsonRecordsString = '[';
     	for(E_CompositeProduct__c c : bps )
        { 
            jsonRecordsString += '{';  
            jsonRecordsString += '"name":' + '"'+ cc_api_JsonCategory.quote(c.Component__r.Name) +'",';
            jsonRecordsString += '"qty":' + '"'+c.Quantity__c+'",'; 
            jsonRecordsString += '"optional":' + c.Optional__c+',';  
            jsonRecordsString += '"id":' + '"'+c.id+'"';    
            jsonRecordsString += '},';       
        }
        jsonRecordsString += ']';
         
         jsonRecordsString = jsonRecordsString.replaceAll(',]',']'); 
         return jsonRecordsString;
     }
     public static String createJSONCategories(List<E_Category__c> cs)
     {
     	String jsonRecordsString = '[';
     	for(E_Category__c c : cs )
        {
            List<E_Category__c> cc = c.Categories__r;
            
            jsonRecordsString += '{';  
            jsonRecordsString += '"text":' + '"'+c.Name+'",';  
            jsonRecordsString += '"id":' + '"'+c.ID+'"';  
            if(cc.size() > 0)
            {
                jsonRecordsString += ',"hasChildren": true';  
            }  
            jsonRecordsString += '},'; 
                     
        }
        jsonRecordsString += ']';
         
         jsonRecordsString = jsonRecordsString.replaceAll(',]',']'); 

         return jsonRecordsString;
     }
     public static void updatePrice(String sku, Decimal price)
	{
		for(E_PriceList__c pl : [select id from e_PriceList__c where name='Enterprise'])
		{
			List<E_PriceListItem__c> items = [select id from E_PriceListItem__c where product__r.sku__c = :sku and pricelist__c = :pl.id];
			if(items.size() == 0)
			{
				E_Product__c p = new E_Product__c(sku__c = sku);
				E_PriceListItem__c plItem = new E_PriceListItem__c(product__r = p, pricelist__c=pl.id, price__c = price);
				insert plItem;
			}
			else
			{
				for(E_PriceListItem__c item : items )
				{
					item.price__c = price;
				}
				update items;
			}
		}
	}
	public static String createJSONProducts(List<E_Product__c> ps, String category)
     {
     	String jsonRecordsString = '[';
     	for(E_Product__c c : ps )
        { 
        	
            jsonRecordsString += '{';  
            jsonRecordsString += '"name":' + '"'+ cc_api_JsonCategory.quote(c.Name) +'",';
            jsonRecordsString += '"sku":' + '"'+c.SKU__c+'",'; 
            jsonRecordsString += '"cid":' + '"'+category+'",';
            jsonRecordsString += '"prodType":' + '"'+c.productType__c+'",'; 
            jsonRecordsString += '"id":' + '"'+c.ID+'"';    
            jsonRecordsString += '},';       
        }
        jsonRecordsString += ']';
         
         jsonRecordsString = jsonRecordsString.replaceAll(',]',']'); 
         return jsonRecordsString;
     }
	
	public static String quote(String inStr)
	{
		return inStr.replace('"','\\"');
	}
	
 }