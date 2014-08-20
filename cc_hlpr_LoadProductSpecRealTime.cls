/**
// * @Description: Builds specs in real time as opposed to using the index.
// * @Version: 1.0
// * @File: cc_kap_api_rules_CartRules
// * =======================================================================================
// * 2012/08/20 1.1 IL -  Created
**/
public with sharing class cc_hlpr_LoadProductSpecRealTime {

	public static Map<String,List<E_ProductSpecIndex__c>> getRealTimeProductSpecIndices(List<Id> idList){
		Map<String,List<E_ProductSpecIndex__c>> returnMap = new Map<String,List<E_ProductSpecIndex__c>>();
		List<E_ProductSpecIndex__c> allSpecs = getRealTimeProductSpecIndicesList(idList);
		List<E_ProductSpecIndex__c> tempSpecs;
		for(E_ProductSpecIndex__c psi : allSpecs){
			if(returnMap.get(String.valueOf(psi.Product__c)) == null){
				tempSpecs = new List<E_ProductSpecIndex__c>();
				tempSpecs.add(psi);
				returnMap.put(String.valueOf(psi.Product__c), tempSpecs);
			}
			else{
				tempSpecs = returnMap.get(String.valueOf(psi.Product__c));
				tempSpecs.add(psi);
			}
		}
		return returnMap;
	}
	
	public static Map<String,List<E_ProductSpecIndex__c>> getRealTimeProductSpecIndices(List<E_Product__c> productList){
		Map<String,List<E_ProductSpecIndex__c>> returnMap = new Map<String,List<E_ProductSpecIndex__c>>();

		List<String> idList = new List<String>();
		for(E_Product__c product:productList){
			idList.add(product.Id); 
		} 

		List<E_ProductSpecIndex__c> allSpecs = getRealTimeProductSpecIndicesList(idList);
		List<E_ProductSpecIndex__c> tempSpecs;
		for(E_ProductSpecIndex__c psi : allSpecs){
			if(returnMap.get(String.valueOf(psi.Product__c)) == null){
				tempSpecs = new List<E_ProductSpecIndex__c>();
				tempSpecs.add(psi);
				returnMap.put(String.valueOf(psi.Product__c), tempSpecs);
			}
			else{
				tempSpecs = returnMap.get(String.valueOf(psi.Product__c));
				tempSpecs.add(psi);
			}
		}
		return returnMap;
	}

   public static List<E_ProductSpecIndex__c> getRealTimeProductSpecIndicesList(List<Id> idList){
       System.debug(LoggingLevel.INFO, '*********Start of Spec indexing');                	
      //variable declarations
      Integer noOfProductSpecIndices=0;
      Map<String,Set<String>> categoriesByProduct = new Map<String,Set<String>>();
      Set<String> categorySet				      = new Set<String>(); 
      Map<String,List<E_ProductSpec__c>> specsByProduct = cc_dao_Spec.getProductSpec(idList);
      for( E_ProductCategory__c pc:[Select e.Sequence__c, e.Product__c, 
													e.ProductCategoryID__c, e.Name, e.Id, 
													e.Category__c 
		 										From E_ProductCategory__c e
		 										Where e.Product__c in :idList]){
		 categorySet.add(pc.Category__c);
		 if(categoriesByProduct.containsKey(pc.Product__c)){
		 	Set<String> pcSet = categoriesByProduct.get(pc.Product__c);
		 	pcSet.add(pc.Category__c);
		 	categoriesByProduct.put(pc.Product__c,pcSet);
		 } else {
		 	categoriesByProduct.put(pc.Product__c,new Set<String>{pc.Category__c});
		 }									
	  }
	  Map<String,List<String>> categoryParentMap = cc_dao_Spec.getAllParentCategories(categorySet);
      System.debug(LoggingLevel.INFO, '*********Number of Parent Categories = '  + categoryParentMap.size());
      System.debug(LoggingLevel.INFO, '*********categoryParentMap' + categoryParentMap);
	  
	  Map<String,E_ProductSpecIndex__c> prdSpecIndexMap = new Map<String,E_ProductSpecIndex__c>();
	  for(String key:categoriesByProduct.keySet()){
      		System.debug(LoggingLevel.INFO, '*********categoriesByProduct.key = '  + key);
	  	    Set<String> catSet = categoriesByProduct.get(key);
      		System.debug(LoggingLevel.INFO, '*********categoriesByProduct.value = '  + catSet);
	  	    if(catSet!=null){
	  	    	for(String str : categoryParentMap.keySet()){
	  	    		if(catSet.contains(str)){
	  	    			for(String cat : categoryParentMap.get(str)){
	  	    				catSet.add(cat);
	  	    			}
	  	    		}
	  	    	}
	  	    } 
	  	    	
	  	 
    	 	System.debug(LoggingLevel.INFO, '*********Category Set = '  + catSet);
    	 		 
	   		Map<String,List<E_CategorySpec__c>> categorySpecMap = cc_dao_Spec.getCategorySpecValues(catSet);
    	 		System.debug(LoggingLevel.INFO, '*********Number of Category Spec Maps = '  + categorySpecMap.size());
    	 		System.debug(LoggingLevel.INFO, '*********categorySpecMap ' + categorySpecMap);
	   		for(String categoryId:categorySpecMap.keySet()){
	   			List<E_CategorySpec__c> categorySpecList = categorySpecMap.get(categoryId);
	   			for(E_CategorySpec__c categorySpec:categorySpecList){
	   			
	   				String indexKey = key+categorySpec.Spec__c;
	   				E_ProductSpecIndex__c psi = new E_ProductSpecIndex__c();
	   				psi.ProductSpecIndexId__c = indexKey;
	   				psi.Product__c = key;
	   				psi.Spec__c	= categorySpec.Spec__c;
	   				psi.Spec__r	= categorySpec.Spec__r;
	   				psi.SpecValue__c = categorySpec.SpecValue__c;
	   				System.debug(LoggingLevel.INFO, '*********---categorySpec.Spec__r.Name = ' + categorySpec.Spec__r.Name);
	   				System.debug(LoggingLevel.INFO, '*********---psi.Spec__r.Name = ' + psi.Spec__r.Name);
	   				System.debug(LoggingLevel.INFO, '*********--key--' + key);
	   				System.debug(LoggingLevel.INFO, '*********--psi--' + psi);
	   				
	   				if(prdSpecIndexMap.get(indexKey)==null){
	   					prdSpecIndexMap.put(indexKey,psi);
	   				}
	   				else{
	   				   psi=	prdSpecIndexMap.get(indexKey);
	   				   psi.SpecValue__c+= '|' + categorySpec.SpecValue__c;
	   				   prdSpecIndexMap.put(indexKey,psi);
	   				}
	   				
	   			}
	   			
	   		}
	  }
	  System.debug(LoggingLevel.INFO, '*********Specs by product List  size = '  + specsByProduct.values().size());
	  for(List<E_ProductSpec__c> valueList: specsByProduct.values()){
	  	for(E_ProductSpec__c ps:valueList){
	  		String indexKey 		  =  String.valueOf(ps.Product__c) + String.valueOf(ps.Spec__c);
	   		E_ProductSpecIndex__c psi = new E_ProductSpecIndex__c();
	   		psi.ProductSpecIndexId__c = indexKey;
	   		psi.Product__c		  = ps.Product__c;
	   		psi.Spec__c			  = ps.Spec__c;
	   		psi.Spec__r			  = ps.Spec__r;
	   		psi.SpecValue__c		  = ps.SpecValue__c;
	   		//overwrite any existing indices if no product indices have been added since product index overrides category index.
	   		if(noOfProductSpecIndices==0 || prdSpecIndexMap.get(indexKey)==null){
	   			prdSpecIndexMap.put(indexKey,psi);
	   	    }
	   	    
	   	    else{
	   		   psi=	prdSpecIndexMap.get(indexKey);
	   		   psi.SpecValue__c+= '|' + ps.SpecValue__c;
	   		   prdSpecIndexMap.put(indexKey,psi);
	   		}
	   	  noOfProductSpecIndices++;
	  	}
	  }

	  System.debug(LoggingLevel.INFO, '*********Product Spec Index Map size = '  + prdSpecIndexMap.values().size());
	  System.debug(LoggingLevel.INFO, '*********Product Spec Index Map values = '  + prdSpecIndexMap.values());
		List<E_ProductSpecIndex__c> psiList = new List<E_ProductSpecIndex__c>();
		if(prdSpecIndexMap.values().size() > 0){
	  		for(E_ProductSpecIndex__c tempPSI : prdSpecIndexMap.values()){
	  			System.debug(LoggingLevel.INFO, '*********Product Spec Index Map values = ' + tempPSI);
	  			psiList.add(tempPSI);
	  		}
		}
		System.debug(LoggingLevel.INFO, '*********End of Spec indexing');
	  	return psiList;  
   }	
}