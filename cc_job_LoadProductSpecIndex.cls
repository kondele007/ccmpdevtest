//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
global with sharing class cc_job_LoadProductSpecIndex  implements Database.Batchable<sObject>{
  //==================================================
  // INSTANCE VARIABLE
  //================================================== 
  //usage
  //id batchinstanceid = database.executeBatch(new cc_job_LoadProductSpecIndex(q,e,f,v), 5);
  
   global final String query;
//   global final String Entity;
//   global final String Field; 
//  global final String Value;
   //==================================================
   // CONSTRUCTOR
   //================================================== 
   global cc_job_LoadProductSpecIndex(String q){
   		query=q; 
//  		Entity=e; 
//   		Field=f;
//   		Value=v; 
   }

   //==================================================
   // DERIVED METHODS
   //================================================== 
   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, 
                       List<sObject> scope){
                       	
      //variable declarations
      Integer noOfProductSpecIndices=0;
      Map<String,Set<String>> categoriesByProduct = new Map<String,Set<String>>();
      Set<String> categorySet				      = new Set<String>(); 
      List<String> idList = new List<String>();
      
      
      System.debug('Number of object ids passed into execute method = '  + scope.size());
      for(SObject sobj:scope){
      	idList.add(sobj.Id); 
      } 
      Map<String,List<E_ProductSpec__c>> specsByProduct = cc_dao_Spec.getProductSpec(idList);
      //System.debug('Number of specsByProduct = '  + specsByProduct.size());
      //System.debug('specsByProduct' + specsByProduct);
                      	
      
      
      for( E_ProductCategory__c pc:[Select e.Sequence__c, e.Product__c, 
													e.ProductCategoryID__c, e.Name, e.Id, 
													e.Category__c 
		 										From E_ProductCategory__c e
		 										Where e.Product__c in :idList]){
		 categorySet.add(pc.Category__c);
		// System.debug('Added categorty id to set = '  + pc.Category__c);
		 if(categoriesByProduct.containsKey(pc.Product__c)){
		 	Set<String> pcSet = categoriesByProduct.get(pc.Product__c);
		 	pcSet.add(pc.Category__c);
		 	categoriesByProduct.put(pc.Product__c,pcSet);
		 } else {
		 	categoriesByProduct.put(pc.Product__c,new Set<String>{pc.Category__c});
		 }									
	  }
     	 //System.debug('Number of categoriesByProduct = '  + categoriesByProduct.size());
     	 //System.debug('categoriesByProduct' + categoriesByProduct);
	  Map<String,List<String>> categoryParentMap = cc_dao_Spec.getAllParentCategories(categorySet);
     	 System.debug('Number of Parent Categories = '  + categoryParentMap.size());
     	 System.debug('categoryParentMap' + categoryParentMap);
     	// System.debug('categoryParentMap' + categoryParentMap);
	  
	  Map<String,E_ProductSpecIndex__c> prdSpecIndexMap = new Map<String,E_ProductSpecIndex__c>();
	  for(String key:categoriesByProduct.keySet()){
      		System.debug('categoriesByProduct.key = '  + key);
	  	    Set<String> catSet = categoriesByProduct.get(key);
      		System.debug('categoriesByProduct.value = '  + catSet);
	  	    if(catSet!=null){
	  	    	for(String str : categoryParentMap.keySet()){
      		//	System.debug('categoryParentMap Key = '  + str);
	  	    		if(catSet.contains(str)){
	  	    			for(String cat : categoryParentMap.get(str)){
     	 		//		System.debug('Category Name = '  + cat);
	  	    				catSet.add(cat);
	  	    			}
	  	    		}
	  	    	}
	  	    } 
	  	    	
	  	 
	   		//Set<String> categoryIdSet = categoriesByProduct.get(key);
	   		//List<String> categoryIds = ArrayUtils.pluck(pcList, 'CategoryID__c');
	   		//  T-MOBILE, HTC, BRAND, CARRIER
    	 	System.debug('Category Set = '  + catSet);
    	 		 
	   		Map<String,List<E_CategorySpec__c>> categorySpecMap = cc_dao_Spec.getCategorySpecValues(catSet);
    	 		System.debug('Number of Category Spec Maps = '  + categorySpecMap.size());
    	 		System.debug('categorySpecMap ' + categorySpecMap);
	   		for(String categoryId:categorySpecMap.keySet()){
	   			List<E_CategorySpec__c> categorySpecList = categorySpecMap.get(categoryId);
	   			for(E_CategorySpec__c categorySpec:categorySpecList){
	   			
	   				/*for(String catId:categoryParentMap.get(categoryId)){
	   					String indexKey2 		  = key+categorySpec.Spec__c;
	   					E_ProductSpecIndex__c psi2 = new E_ProductSpecIndex__c();
	   					psi2.ProductSpecIndexId__c = indexKey2;
	   					psi2.E_Product__c		  = key;
	   					psi2.E_Spec__c			  = categorySpec.Spec__c;
	   					psi2.SpecValue__c		  = categorySpec.SpecValue__c;
	   					prdSpecIndexMap.put(indexKey2,psi2);
	   				}*/
	   				
	   				String indexKey 		  = key+categorySpec.Spec__c;
	   				E_ProductSpecIndex__c psi = new E_ProductSpecIndex__c();
	   				psi.ProductSpecIndexId__c = indexKey;
	   				psi.Product__c		  = key;
	   				psi.Spec__c			  = categorySpec.Spec__c;
	   				psi.SpecValue__c		  = categorySpec.SpecValue__c;
	   				System.debug('---categorySpec.Spec__c---' + categorySpec.Spec__c);
	   				System.debug('--key--' + key);
	   				System.debug('--psi--' + psi);
	   				
	   				if(prdSpecIndexMap.get(indexKey)==null){
	   					prdSpecIndexMap.put(indexKey,psi);
	   				}
	   				else{
	   				   psi=	prdSpecIndexMap.get(indexKey);
	   				   psi.SpecValue__c+= ' , ' + categorySpec.SpecValue__c;
	   				   prdSpecIndexMap.put(indexKey,psi);
	   				}
	   				
	   				
	   				//if(prdSpecIndexMap.containsKey(indexKey)){
	   				//}
	   			}
	   			
	   		}
	  }
	  System.debug('Specs by product List  size = '  + specsByProduct.values().size());
	  for(List<E_ProductSpec__c> valueList: specsByProduct.values()){
	  	for(E_ProductSpec__c ps:valueList){
	  		String indexKey 		  =  String.valueOf(ps.Product__c) + String.valueOf(ps.Spec__c);
	   		E_ProductSpecIndex__c psi = new E_ProductSpecIndex__c();
	   		psi.ProductSpecIndexId__c = indexKey;
	   		psi.Product__c		  = ps.Product__c;
	   		psi.Spec__c			  = ps.Spec__c;
	   		psi.SpecValue__c		  = ps.SpecValue__c;
	   		//overwrite any existing indices if no product indices have been added since product index overrides category index.
	   		if(noOfProductSpecIndices==0 || prdSpecIndexMap.get(indexKey)==null){
	   			prdSpecIndexMap.put(indexKey,psi);
	   	    }
	   	    
	   	    else{
	   		   psi=	prdSpecIndexMap.get(indexKey);
	   		   psi.SpecValue__c+= ' , ' + ps.SpecValue__c;
	   		   prdSpecIndexMap.put(indexKey,psi);
	   		}
	   	  noOfProductSpecIndices++;
	   			  			
	  	}

	  }
	  
	  string localNamespace = cc_util_CloudCraze.localNamespace; 
	  Integer startIndex = 0;
	  System.debug('Product Spec Index Map size = '  + prdSpecIndexMap.values().size());
	  System.debug('Product Spec Index Map values = '  + prdSpecIndexMap.values());
	  while(startIndex<prdSpecIndexMap.values().size()){
	  	List<SObject> psiList = al.ArrayUtils.subset(prdSpecIndexMap.values(),startIndex,200);
	  	Set<String> extIdSet = new Set<String>();
	  	string fieldName = 'ProductSpecIndexId__c';
	  	if(!al.StringUtils.isBlank(localNamespace)) {
	  		fieldName = localNamespace + fieldName;
	  	}
	  	for(Object obj: al.ArrayUtils.pluck(psiList, fieldName)){
	  		extIdSet.add((String)obj);
	  	}
	  	List<E_ProductSpecIndex__c> psiListDel = [Select Id 
	  											  from E_ProductSpecIndex__c 
	  											  Where ProductSpecIndexId__c in :extIdSet];
	  	delete psiListDel;
	  	upsert psiList;
	  	startIndex+=200;
	  }
	  
   }

   global void finish(Database.BatchableContext BC){

   }

}