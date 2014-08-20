public with sharing class cc_kap_IBFee_Util_va {
/***************************Nullified
    private Map<String, List<E_ProductSpecIndex__c>> transientSpecMap;
    
    public cc_kap_IBFee_Util(){}
    
    /*
    * Get IB Fee SKU based on SBU and Currency
    */
  /***************************Nullified  
    public String getMatchingIBFeeSKU(String cartSBUCode,String cartCurrency){
        String IBFeeSKU = '';
        E_Category__c IBFeeCategory;
        IBFeeCategory = [select Id,Name from E_Category__c where CategoryID__c = :cc_kap_utils_AppConstants.IB_FEE_CATEGORY_ID LIMIT 1];//Get the IB Fee Category
        if(IBFeeCategory != null){
                List<E_ProductCategory__c> productCategories = new List<E_ProductCategory__c>();
                productCategories = [Select p.Product__r.ID,p.Product__r.SKU__c from E_ProductCategory__c p where p.Category__c = :IBFeeCategory.Id];//Get the Products from the IB Fee Category
                //System.debug(LoggingLevel.INFO,'@@IBFee productCategories ='+ productCategories);
                if(!al.ArrayUtils.isEmpty(productCategories)){
                    List<String> skus = new List<String>();
                    for(E_ProductCategory__c prodCat:productCategories){
                        skus.add(prodCat.Product__r.SKU__c);
                    }
                    System.debug(LoggingLevel.INFO,'@@IBFee foundskus='+ skus);
                    if(!al.ArrayUtils.isEmpty(skus)){
                        cc_dao_Product dao = new cc_dao_Product();
                        List<E_Product__c> products = dao.readProduct(skus);
                        transientSpecMap = cc_hlpr_LoadProductSpecRealTime.getRealTimeProductSpecIndices(products);
                        IBFeeSKU = '';
                        Boolean foundMatchingSBU = false;
                        Boolean foundMatchingCurrency = false;
                        for(E_Product__c product: products)
                        {
                            foundMatchingSBU = false;
                            foundMatchingCurrency = false;
                            System.debug(LoggingLevel.INFO,'@@IBFee SKU='+ product.SKU__C);
                            System.debug(LoggingLevel.INFO,'@@IBFee cartSBUCode='+ cartSBUCode);
                            for (E_ProductSpecIndex__c spec: transientSpecMap.get(String.valueOf(product.Id))){
                                System.debug(LoggingLevel.INFO,'@@IBFee spec='+ spec); 
                                System.debug(LoggingLevel.INFO,'@@IBFee spec.Spec__r.Name='+ spec.Spec__r.Name);
                                System.debug(LoggingLevel.INFO,'@@IBFee spec.SpecValue__c before='+ spec.SpecValue__c);
                                if(cartSBUCode.contains('|')){
                                    if ((spec.Spec__r.Name == cc_kap_utils_AppConstants.SPEC_SBU)){
                                        foundMatchingSBU = true;
                                        System.debug(LoggingLevel.INFO,'@@IBFee foundMatchingSBU with pipe='+ foundMatchingSBU);    
                                    }else{
                                        if(spec.SpecValue__c.contains('|')){
                                            System.debug(LoggingLevel.INFO,'@@IBFee has pipe');
                                            spec.SpecValue__c = spec.SpecValue__c.replace('|','');
                                        }   
                                    }
                                }
                                System.debug(LoggingLevel.INFO,'@@IBFee spec.SpecValue__c after='+ spec.SpecValue__c);
                                System.debug(LoggingLevel.INFO,'@@IBFee spec.SpecValue__c unescapeHtml4='+ spec.SpecValue__c.unescapeHtml4());
                                System.debug(LoggingLevel.INFO,'@@IBFee spec.SpecValue__c unescapeHtml3='+ spec.SpecValue__c.unescapeHtml3());

                                if ((spec.Spec__r.Name == cc_kap_utils_AppConstants.SPEC_SBU) && spec.SpecValue__c.contains(cartSBUCode)){
                                    foundMatchingSBU = true;
                                    System.debug(LoggingLevel.INFO,'@@IBFee foundMatchingSBU='+ foundMatchingSBU);                                      
                                }
                                if((spec.Spec__r.Name == cc_kap_utils_AppConstants.IB_FEE_SPEC_CURRENCY) && spec.SpecValue__c.equals(cartCurrency)){
                                    foundMatchingCurrency = true;
                                    System.debug(LoggingLevel.INFO,'@@IBFee foundMatchingCurrency='+ foundMatchingCurrency);
                                }
                                if(foundMatchingSBU && foundMatchingCurrency){
                                    IBFeeSKU = product.SKU__c;
                                    System.debug(LoggingLevel.INFO,'@@IBFee foundMatching IB Fee SKU='+ IBFeeSKU);
                                    break;
                                }                               
                            }
                        }
                    }
                }               
            }
            return IBFeeSKU;
    }
    
    *************************************/

}