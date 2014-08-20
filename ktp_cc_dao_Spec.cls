public with sharing class ktp_cc_dao_Spec {
	public static Map<String,List<ccrz__E_ProductSpec__c>> getProductSpec(List<String> productIds){
	    Map<String,List<ccrz__E_ProductSpec__c>> productSpecMap = new Map<String,List<ccrz__E_ProductSpec__c>>();
	    if(al.ArrayUtils.isEmpty(productIds)){
	      return productSpecMap;
	    }
	    for(ccrz__E_ProductSpec__c prdSpec: [Select e.ccrz__SpecValue__c, e.ccrz__ProductID__c, e.ccrz__Spec__r.ccrz__DisplayName__c,e.ccrz__Spec__r.Name,
	                             e.Name, e.Id, e.ccrz__Spec__c, e.ccrz__Product__c
	                          From ccrz__E_ProductSpec__c e
	                           Where e.ccrz__Product__c in :productIds
	                           Order by e.ccrz__Product__c, e.ccrz__Spec__c]){
	       if(!productSpecMap.containsKey(prdSpec.ccrz__Product__c)){
	         productSpecMap.put(prdSpec.ccrz__Product__c,new List<ccrz__E_ProductSpec__c>{prdSpec}); 
	       } else {
	         List<ccrz__E_ProductSpec__c> specList = productSpecMap.get(prdSpec.ccrz__Product__c);
	         specList.add(prdSpec);
	         productSpecMap.put(prdSpec.ccrz__Product__c,specList); 
	       }    
	    }
	    
	    return productSpecMap;
	  }
	  public static Map<String,List<String>> getAllParentCategories(Set<String> categoryIds){
	  	Map<String,List<String>> parentCategoryMap=new Map<String,List<String>>();
	  	for(ccrz__E_BreadCrumb__c breadCrumbIns:[Select e.ccrz__CategoryId__c,e.ccrz__BreadcrumbURL__c,e.ccrz__Breadcrumb__c From ccrz__E_BreadCrumb__c e where e.ccrz__CategoryId__c in :categoryIds]){
	  		//split breadcrumb url by  >
	  		if(breadCrumbIns.ccrz__BreadcrumbURL__c!=null && breadCrumbIns.ccrz__BreadcrumbURL__c.contains('>')){
	  			String[] catIds=breadCrumbIns.ccrz__BreadcrumbURL__c.split('>');
	  			for(String categoryId:catIds){
	  				if(categoryId!=breadCrumbIns.ccrz__CategoryId__c && categoryId!='Start'){
	  					if(parentCategoryMap.get(breadCrumbIns.ccrz__CategoryId__c)!=null){
	  						parentCategoryMap.get(breadCrumbIns.ccrz__CategoryId__c).add(categoryId);
	  					}
	  					else{
	  						List<String> catList=new List<String>();
	  						catList.add(categoryId);
	  						parentCategoryMap.put(breadCrumbIns.ccrz__CategoryId__c,catList);
	  						
	  					}
	  				}
	  			}
	  		}
	  	}
	  	return parentCategoryMap;
	  }
	  public static Map<String,List<ccrz__E_CategorySpec__c>> getCategorySpecValues(Set<String> categoryIds){
	    Map<String,List<ccrz__E_CategorySpec__c>> categorySpecMap = new Map<String,List<ccrz__E_CategorySpec__c>>();
	    if(categoryIds==null || categoryIds.size()==0){
	      return categorySpecMap;
	    }
	    
	    for(ccrz__E_CategorySpec__c csi : [Select e.ccrz__SpecValue__c, e.Name, e.Id, e.ccrz__Spec__c, e.ccrz__Spec__r.ccrz__DisplayName__c, e.ccrz__Spec__r.Name, e.ccrz__Category__c 
	                      From ccrz__E_CategorySpec__c e 
	                      Where e.ccrz__Category__c in :categoryIds]){
	      if(!categorySpecMap.containsKey(csi.ccrz__Category__c)){
	        categorySpecMap.put(csi.ccrz__Category__c,new List<ccrz__E_CategorySpec__c>{csi}); 
	      } else {
	         List<ccrz__E_CategorySpec__c> indexList = categorySpecMap.get(csi.ccrz__Category__c);
	         indexList.add(csi);
	        categorySpecMap.put(csi.ccrz__Category__c,indexList); 
	      }                    
	    }
	    return categorySpecMap;
	  }
}