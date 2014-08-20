//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public class cc_dao_Spec {
  //==================================================
  // STATIC SERVICE METHODS
  //==================================================
  public static Map<String,List<E_ProductSpec__c>> getProductSpec(List<String> productIds){
    Map<String,List<E_ProductSpec__c>> productSpecMap = new Map<String,List<E_ProductSpec__c>>();
    if(al.ArrayUtils.isEmpty(productIds)){
      return productSpecMap;
    }
    for(E_ProductSpec__c prdSpec: [Select e.SpecValue__c, e.ProductID__c, e.Spec__r.DisplayName__c,e.Spec__r.Name,
                             e.Name, e.Id, e.Spec__c, e.Product__c
                          From E_ProductSpec__c e
                           Where e.Product__c in :productIds
                           Order by e.Product__c, e.Spec__c]){
       if(!productSpecMap.containsKey(prdSpec.Product__c)){
         productSpecMap.put(prdSpec.Product__c,new List<E_ProductSpec__c>{prdSpec}); 
       } else {
         List<E_ProductSpec__c> specList = productSpecMap.get(prdSpec.Product__c);
         specList.add(prdSpec);
         productSpecMap.put(prdSpec.Product__c,specList); 
       }    
    }
    
    return productSpecMap;
  }
  
  public static Map<String,E_ProductSpecIndex__c> getProductSpecIndex(String productId){
    Map<String,E_ProductSpecIndex__c> productSpecMap = new Map<String,E_ProductSpecIndex__c>();
    if(al.StringUtils.isEmpty(productId)){
      return productSpecMap;
    }
    
    
    for(E_ProductSpecIndex__c prdSpecIndx: [Select e.SpecValue__c, e.Name, 
                               e.Id, e.Spec__c, e.Product__c 
                           From E_ProductSpecIndex__c e
                           Where e.Product__c=:productId]){
       productSpecMap.put(prdSpecIndx.Id,prdSpecIndx);    
    }
    
    return productSpecMap;
  }
  
  
  public static Map<String,List<E_ProductSpecIndex__c>> getProductSpecIndex(List<String> productIds){
    Map<String,List<E_ProductSpecIndex__c>> productSpecMap = new Map<String,List<E_ProductSpecIndex__c>>();
    if(al.ArrayUtils.isEmpty(productIds)){
      return productSpecMap;
    }
    for(E_ProductSpecIndex__c prdSpecIndx: [Select e.SpecValue__c, e.Name, 
                               e.Id, e.Spec__c, e.Product__c 
                           From E_ProductSpecIndex__c e
                           Where e.Product__c in :productIds
                           Order by e.Product__c, e.Spec__c]){
       if(!productSpecMap.containsKey(prdSpecIndx.Product__c)){
         productSpecMap.put(prdSpecIndx.Product__c,new List<E_ProductSpecIndex__c>{prdSpecIndx}); 
       } else {
         List<E_ProductSpecIndex__c> indexList = productSpecMap.get(prdSpecIndx.Product__c);
         indexList.add(prdSpecIndx);
         productSpecMap.put(prdSpecIndx.Product__c,indexList); 
       }    
    }
    
    return productSpecMap;
  }
  
  public static Map<String,List<E_CategorySpec__c>> getCategorySpec(String categoryId){
    if(al.StringUtils.isEmpty(categoryId)){
      return new Map<String,List<E_CategorySpec__c>>();
    }
    return getCategorySpec(new Set<String>{categoryId});
  }
  
  public static Map<String,List<E_CategorySpec__c>> getCategorySpecValues(Set<String> categoryIds){
    Map<String,List<E_CategorySpec__c>> categorySpecMap = new Map<String,List<E_CategorySpec__c>>();
    if(categoryIds==null || categoryIds.size()==0){
      return categorySpecMap;
    }
    
    for(E_CategorySpec__c csi : [Select e.SpecValue__c, e.Name, e.Id, e.Spec__c, e.Spec__r.DisplayName__c, e.Spec__r.Name, e.Category__c 
                      From E_CategorySpec__c e 
                      Where e.Category__c in :categoryIds]){
      if(!categorySpecMap.containsKey(csi.Category__c)){
        categorySpecMap.put(csi.Category__c,new List<E_CategorySpec__c>{csi}); 
      } else {
         List<E_CategorySpec__c> indexList = categorySpecMap.get(csi.Category__c);
         indexList.add(csi);
        categorySpecMap.put(csi.Category__c,indexList); 
      }                    
    }
    return categorySpecMap;
  }
  
  public static Map<String,List<E_CategorySpec__c>> getCategorySpec(Set<String> categoryIds){
    Map<String,List<E_CategorySpec__c>> categorySpecMap = new Map<String,List<E_CategorySpec__c>>();
    if(categoryIds==null || categoryIds.size()==0){
      return categorySpecMap;
    }
    Map<String,E_Category__c> categoryMap = new Map<String,E_Category__c>();
    categoryMap = cc_dao_Spec.getAllChildrenCategories(categoryIds, categoryMap);
    //List<String> categoryIdList = new List<String>();
    //for(E_Category__c category : categoryMap){
    //  categoryIdList.add(cateGor)
    //}
    System.debug('DOA Category Map = '  + categoryMap.keySet());
    for(String categoryId: categoryMap.keySet()){
    	System.debug(LoggingLevel.ERROR,'-----Child categoryId---' + categoryId);
    }
    for(E_CategorySpec__c csi : [Select e.SpecValue__c, e.Name, e.Id, e.Spec__c, e.Category__c 
                      From E_CategorySpec__c e 
                      Where e.Category__c in :categoryMap.keySet()]){
      if(!categorySpecMap.containsKey(csi.Category__c)){
        categorySpecMap.put(csi.Category__c,new List<E_CategorySpec__c>{csi}); 
      } else {
         List<E_CategorySpec__c> indexList = categorySpecMap.get(csi.Category__c);
         indexList.add(csi);
        categorySpecMap.put(csi.Category__c,indexList); 
      }                    
    }
    return categorySpecMap;
  }
  
  public static void createCategorySpecIndex(){
    
  } 
  
  public static Map<String,List<String>> getAllParentCategories(Set<String> categoryIds){
  	Map<String,List<String>> parentCategoryMap=new Map<String,List<String>>();
  	for(E_BreadCrumb__c breadCrumbIns:[Select e.CategoryId__c,e.BreadcrumbURL__c,e.Breadcrumb__c From E_BreadCrumb__c e where e.CategoryId__c in :categoryIds]){
  		//split breadcrumb url by  >
  		if(breadCrumbIns.BreadcrumbURL__c!=null && breadCrumbIns.BreadcrumbURL__c.contains('>')){
  			String[] catIds=breadCrumbIns.BreadcrumbURL__c.split('>');
  			for(String categoryId:catIds){
  				if(categoryId!=breadCrumbIns.CategoryId__c && categoryId!='Start'){
  					if(parentCategoryMap.get(breadCrumbIns.CategoryId__c)!=null){
  						parentCategoryMap.get(breadCrumbIns.CategoryId__c).add(categoryId);
  					}
  					else{
  						List<String> catList=new List<String>();
  						catList.add(categoryId);
  						parentCategoryMap.put(breadCrumbIns.CategoryId__c,catList);
  						
  					}
  				}
  			}
  		}
  	}
  	return parentCategoryMap;
  }
  
  /*public static Map<String,List<String>> getAllParentCategories(Set<String> categoryIds){
    Map<String,List<String>> categoryParentMap= new Map<String,List<String>>();
    String rootCatId='';
    
    for(E_Category__c rootCat: [Select e.Name, e.Id, e.ParentCategory__c From E_Category__c e where e.Name='Catalog']){
    	rootCatId=rootCat.Id;
    }
    
    List<E_Category__c> categoryList = [Select e.ShortDesc__c, e.Sequence__c, e.ProductCount__c, 
                       e.ParentCategory__c, e.Name, e.Id 
                  From E_Category__c e];
    Map<String,E_Category__c> categoryMap= new Map<String,E_Category__c>();
    for(E_Category__c category:categoryList){
      categoryMap.put(category.Id,category);
    }
    Boolean madeUpdate = false;
    while(true){
    madeUpdate = false;
    
    
    for(String catId:categoryIds){
      categoryParentMap.put(catId,new List<String>{});
    }
    
    System.debug(Logginglevel.ERROR,'categoryParentMap' + categoryParentMap);
    
    for(E_Category__c acat:categoryList){
      for(String catId:categoryIds){
      	
      	
        List<String> parentList = categoryParentMap.get(catId);        
        System.debug(Logginglevel.ERROR,'parentList' + parentList);
        String lastParentId = '';
        if(ArrayUtils.isNotEmpty(parentList)){
          lastParentId =  parentList[parentList.size()-1];
        }
        System.debug(Logginglevel.ERROR,'acat.Name' + acat.Name);
        //System.debug(Logginglevel.ERROR,'lastParentId' + lastParentId);
        if((categoryMap.get(catId) != null && acat.Id==categoryMap.get(catId).ParentCategory__c) && acat.Id!=rootCatId || 
           (StringUtils.isNotEmpty(lastParentId) &&
          categoryMap.get(lastParentId)!=null && 
          categoryMap.get(lastParentId).ParentCategory__c == acat.Id && acat.Id!=rootCatId)){
          	
          	System.debug(Logginglevel.ERROR,'categoryMap.get(catId).ParentCategory__c)' + categoryMap.get(catId).ParentCategory__c);
            //System.debug(Logginglevel.ERROR,'acat.Id' + acat.Id);
            
        
          	//System.debug(Logginglevel.ERROR,'adding acat.Id' + acat.Id);
          parentList.add(acat.Id);
          categoryParentMap.put(catId,parentList); 
        } 
        
      }
      //DEFINITELY COMMENT BELOW EVEN UNCOMMENTING THE METHOD
      // START
      if(StringUtils.isNotEmpty(category.ParentCategoryID__c)){
         if(categoryParentMap.containsKey(catId)){
           List<String> parentList =  categoryParentMap.get(catId);
           Boolean contains=false;
           for(String str:parentList){
             if(str.equals(category.ParentCategoryID__c)){
               contains = true;
             }
           }
           if(!contains && categoryy.){
             parentList.add(category.ParentCategoryID__c);
             //if(categoryParentMap.containsKey(category.ParentCategoryID__c)){
             //  for(String par: categoryParentMap.get(category.ParentCategoryID__c)){
             //    parentList.add(par);
             //  }
             //}
             categoryParentMap.put(catId,parentList);
             madeUpdate=true;
           }
         } else {
           categoryParentMap.put(catId,new List<String>{category.ParentCategoryID__c});
           madeUpdate=true;
         }
       } else if(StringUtils.isEmpty(category.ParentCategoryID__c) && 
              !categoryParentMap.containsKey(catId)) {
         categoryParentMap.put(catId,new List<String>());
         madeUpdate=true;
       }       
       
       //end
       
      
    }
      
      if(!madeUpdate){
        break;
      }
    }
    
    return categoryParentMap;
  }*/

  public static Map<String,E_Category__c> getAllChildrenCategories(Set<String> categoryIds, Map<String,E_Category__c> categoryMap){
    if(categoryMap==null || categoryIds==null || categoryIds.size()==0){
      return new Map<String,E_Category__c>();
    }
    Set<String> childrenCategoryIds = new Set<String>();
    for(E_Category__c category:[Select e.Id, e.Name, e.Sequence__c, e.ProductCount__c, e.ChildCategoryCount__c, e.CategoryID__c, 
                    (Select Id, Name, Sequence__c, ProductCount__c, ChildCategoryCount__c, CategoryID__c From Categories__r) 
                   From E_Category__c e
                   Where e.Id in :categoryIds]){
       categoryMap.put(category.Id,category);
       for(E_Category__c innerCategory : category.Categories__r){
         if(innerCategory.ChildCategoryCount__c>0){
           childrenCategoryIds.add(innerCategory.Id);
         } else {
           categoryMap.put(innerCategory.Id,innerCategory);
         }
       }              
    }
    if(childrenCategoryIds.size()>0){
      return getAllChildrenCategories(childrenCategoryIds,categoryMap);
    } else {
      return categoryMap;
    }
  }
  
  @future
  public static void clearIndexTable(String concatanatedIds){
    List<String> idList = al.StringUtils.split(concatanatedIds, '|');
    List<E_ProductSpecIndex__c> specIndices = [Select e.SpecValue__c, e.Name, e.Id, 
                          e.Spec__c, e.Product__c 
                       From E_ProductSpecIndex__c e Where Id in :idList];
    Integer startIndex = 0;
    while(startIndex<specIndices.size()){
      delete(al.ArrayUtils.subset(specIndices, startIndex, 200));
      startIndex+=200;
    }
  }
  
  public static Boolean populateProductSpecIndex(){
    
    for(List<E_ProductSpecIndex__c> productSpecIndexList: [Select e.SpecValue__c, e.Name, e.Id, 
                                    e.Spec__c, e.Product__c 
                                 From E_ProductSpecIndex__c e]){
      clearIndexTable(al.StringUtils.joinArray(al.ArrayUtils.pluck(productSpecIndexList, 'Id'), '|'));                             
    }
    
    for(List<E_Product__c> prodList :[Select Id from E_Product__c]){
      String str = al.StringUtils.joinArray(al.ArrayUtils.pluck(prodList, 'Id'), '|');
      
    }
    /*
    for(List<E_ProductSpec__c> productSpecList : [Select e.SpecValue__c, e.ProductSpecID__c, e.ProductID__c, 
                              e.Name, e.Id, e.E_Spec__c, e.E_Product__c 
                             From E_ProductSpec__c e]){
                               
                           }
    */
    return true;
  } 
}