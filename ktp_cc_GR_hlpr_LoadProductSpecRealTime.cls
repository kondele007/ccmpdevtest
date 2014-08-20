/**
// * @Description: Builds specs in real time as opposed to using the index.
// * @Version: 1.0
// * @File: cc_kap_api_rules_CartRules
// * =======================================================================================
// * 2012/08/20 1.1 IL -  Created
**/
public with sharing class ktp_cc_GR_hlpr_LoadProductSpecRealTime {
    
    public static Map<String,List<ccrz__E_ProductSpecIndex__c>> getRealTimeProductSpecIndices(List<ccrz__E_Product__c> productList){
        Map<String,List<ccrz__E_ProductSpecIndex__c>> returnMap = new Map<String,List<ccrz__E_ProductSpecIndex__c>>();

        List<String> idList = new List<String>();
        for(ccrz__E_Product__c product:productList){
            idList.add(product.Id); 
        } 

        List<ccrz__E_ProductSpecIndex__c> allSpecs = getRealTimeProductSpecIndicesList(idList);
        List<ccrz__E_ProductSpecIndex__c> tempSpecs;
        for(ccrz__E_ProductSpecIndex__c psi : allSpecs){
            if(returnMap.get(String.valueOf(psi.ccrz__Product__c)) == null){
                tempSpecs = new List<ccrz__E_ProductSpecIndex__c>();
                tempSpecs.add(psi);
                returnMap.put(String.valueOf(psi.ccrz__Product__c), tempSpecs);
            }
            else{
                tempSpecs = returnMap.get(String.valueOf(psi.ccrz__Product__c));
                tempSpecs.add(psi);
            }
        }
        return returnMap;
    }

   public static List<ccrz__E_ProductSpecIndex__c> getRealTimeProductSpecIndicesList(List<Id> idList){
       System.debug(LoggingLevel.INFO, '*********Start of Spec indexing');                  
      //variable declarations
      Integer noOfProductSpecIndices=0;
      Map<String,Set<String>> categoriesByProduct = new Map<String,Set<String>>();
      Set<String> categorySet                     = new Set<String>(); 
      Map<String,List<ccrz__E_ProductSpec__c>> specsByProduct = ktp_cc_dao_Spec.getProductSpec(idList);
      for( ccrz__E_ProductCategory__c pc:[Select e.ccrz__Sequence__c, e.ccrz__Product__c, 
                                                    e.ccrz__ProductCategoryID__c, e.Name, e.Id, 
                                                    e.ccrz__Category__c 
                                                From ccrz__E_ProductCategory__c e
                                                Where e.ccrz__Product__c in :idList]){
         categorySet.add(pc.ccrz__Category__c);
         if(categoriesByProduct.containsKey(pc.ccrz__Product__c)){
            Set<String> pcSet = categoriesByProduct.get(pc.ccrz__Product__c);
            pcSet.add(pc.ccrz__Category__c);
            categoriesByProduct.put(pc.ccrz__Product__c,pcSet);
         } else {
            categoriesByProduct.put(pc.ccrz__Product__c,new Set<String>{pc.ccrz__Category__c});
         }                                  
      }
      Map<String,List<String>> categoryParentMap = ktp_cc_dao_Spec.getAllParentCategories(categorySet);
      System.debug(LoggingLevel.INFO, '*********Number of Parent Categories = '  + categoryParentMap.size());
      System.debug(LoggingLevel.INFO, '*********categoryParentMap' + categoryParentMap);
      
      Map<String,ccrz__E_ProductSpecIndex__c> prdSpecIndexMap = new Map<String,ccrz__E_ProductSpecIndex__c>();
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
                 
            Map<String,List<ccrz__E_CategorySpec__c>> categorySpecMap = ktp_cc_dao_Spec.getCategorySpecValues(catSet);
                System.debug(LoggingLevel.INFO, '*********Number of Category Spec Maps = '  + categorySpecMap.size());
                System.debug(LoggingLevel.INFO, '*********categorySpecMap ' + categorySpecMap);
            for(String categoryId:categorySpecMap.keySet()){
                List<ccrz__E_CategorySpec__c> categorySpecList = categorySpecMap.get(categoryId);
                for(ccrz__E_CategorySpec__c categorySpec:categorySpecList){
                
                    String indexKey = key+categorySpec.ccrz__Spec__c;
                    ccrz__E_ProductSpecIndex__c psi = new ccrz__E_ProductSpecIndex__c();
                    psi.ccrz__ProductSpecIndexId__c = indexKey;
                    psi.ccrz__Product__c = key;
                    psi.ccrz__Spec__c = categorySpec.ccrz__Spec__c;
                    psi.ccrz__Spec__r = categorySpec.ccrz__Spec__r;
                    psi.ccrz__SpecValue__c = categorySpec.ccrz__SpecValue__c;
                    System.debug(LoggingLevel.INFO, '*********---categorySpec.Spec__r.Name = ' + categorySpec.ccrz__Spec__r.Name);
                    System.debug(LoggingLevel.INFO, '*********---psi.Spec__r.Name = ' + psi.ccrz__Spec__r.Name);
                    System.debug(LoggingLevel.INFO, '*********--key--' + key);
                    System.debug(LoggingLevel.INFO, '*********--psi--' + psi);
                    
                    if(prdSpecIndexMap.get(indexKey)==null){
                        prdSpecIndexMap.put(indexKey,psi);
                    }
                    else{
                       psi= prdSpecIndexMap.get(indexKey);
                       psi.ccrz__SpecValue__c+= '|' + categorySpec.ccrz__SpecValue__c;
                       prdSpecIndexMap.put(indexKey,psi);
                    }
                    
                }
                
            }
      }
      System.debug(LoggingLevel.INFO, '*********Specs by product List  size = '  + specsByProduct.values().size());
      for(List<ccrz__E_ProductSpec__c> valueList: specsByProduct.values()){
        for(ccrz__E_ProductSpec__c ps:valueList){
            String indexKey           =  String.valueOf(ps.ccrz__Product__c) + String.valueOf(ps.ccrz__Spec__c);
            ccrz__E_ProductSpecIndex__c psi = new ccrz__E_ProductSpecIndex__c();
            psi.ccrz__ProductSpecIndexId__c = indexKey;
            psi.ccrz__Product__c        = ps.ccrz__Product__c;
            psi.ccrz__Spec__c           = ps.ccrz__Spec__c;
            psi.ccrz__Spec__r           = ps.ccrz__Spec__r;
            psi.ccrz__SpecValue__c          = ps.ccrz__SpecValue__c;
            //overwrite any existing indices if no product indices have been added since product index overrides category index.
            if(noOfProductSpecIndices==0 || prdSpecIndexMap.get(indexKey)==null){
                prdSpecIndexMap.put(indexKey,psi);
            }
            
            else{
               psi= prdSpecIndexMap.get(indexKey);
               psi.ccrz__SpecValue__c+= '|' + ps.ccrz__SpecValue__c;
               prdSpecIndexMap.put(indexKey,psi);
            }
          noOfProductSpecIndices++;
        }
      }

      System.debug(LoggingLevel.INFO, '*********Product Spec Index Map size = '  + prdSpecIndexMap.values().size());
      System.debug(LoggingLevel.INFO, '*********Product Spec Index Map values = '  + prdSpecIndexMap.values());
        List<ccrz__E_ProductSpecIndex__c> psiList = new List<ccrz__E_ProductSpecIndex__c>();
        if(prdSpecIndexMap.values().size() > 0){
            for(ccrz__E_ProductSpecIndex__c tempPSI : prdSpecIndexMap.values()){
                System.debug(LoggingLevel.INFO, '*********Product Spec Index Map values = ' + tempPSI);
                psiList.add(tempPSI);
            }
        }
        System.debug(LoggingLevel.INFO, '*********End of Spec indexing');
        return psiList;  
   }    
}