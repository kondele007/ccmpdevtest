//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public class cc_hlpr_ProductSearchMatchComparator implements cc_util_ObjectComparator {
	//==================================================
    // CONSTANTS
    //==================================================
    public final Integer BEFORE = -1;
    public final Integer EQUAL = 0;
    public final Integer AFTER = 1;
    public final Integer NO_MATCH = 0;
    //==================================================
    // INSTANCE PROPERTIES
    //==================================================
    private Map<String,Integer> searchIntSettings { get; set; }
    public String searchString { get;
        set {
            if(value != null) {
                searchString = value.trim().toUpperCase();
            } else {
                searchString = null;
            }
            refreshSearchPattern();
        }
    } 
    
    public Pattern searchPattern {get; private set;}
    //==================================================
    // CONSTRUCTORS
    //==================================================
    private cc_hlpr_ProductSearchMatchComparator() {}
    public cc_hlpr_ProductSearchMatchComparator(String searchString) {
        this.searchString = searchString;
      //  searchIntSettings = CustomSettingsDAO.getProductSearchIntSettings();
      searchIntSettings = cc_util_CloudCraze.getRank();      
    }
    //==================================================
    // DERIVED METHODS
    //================================================== 
    public Integer compare(Object object1, Object object2){
        // ensure both objects are not null
        if(object1 == null || object2 == null){
            throw new cc_excn_CompareException('ProductSearchMatchCompare failed - objects must not be null');
        }
        
        // ensure both objects are products
        if(!(object1 instanceof cc_bean_ProductListViewData) || !(object2 instanceof cc_bean_ProductListViewData)) {
            throw new cc_excn_CompareException('ProductSearchMatchCompare failed - objects must be instances of cc_bean_ProductListViewData');
        }
        
        Integer comp = compare((cc_bean_ProductListViewData)object1, (cc_bean_ProductListViewData)object2);
        //System.debug('--- result = ' + comp + ' ---');
        
        return comp;
    }
	//==================================================
    // HELPER METHODS
    //==================================================
    private Integer compare(cc_bean_ProductListViewData view1, cc_bean_ProductListViewData view2) {
    	if(view1.productSearchRank > view2.productSearchRank) return BEFORE;
    	else if(view1.productSearchRank < view2.productSearchRank) return AFTER;
    	
    	if(view1.priceListItem.Price__c > view2.priceListItem.Price__c) return BEFORE;
    	else if(view1.priceListItem.Price__c < view2.priceListItem.Price__c) return AFTER;
    	
    	return EQUAL;
    }
    
    private void refreshSearchPattern() {
        if(searchString != null) {
            searchPattern = Pattern.compile('.*' + searchString + '.*');
        } else {
            searchPattern = Pattern.compile('.*');
        }
    }
    
    public void rankProduct(cc_bean_ProductListViewData viewData) {
    	
        if(searchString == null || searchString == '') {
        	viewData.productSearchRank = NO_MATCH;
        	return;
        }
        
        // strip special chars except _ (underscore) and - (dash)
        String rankSearchString = searchString.replaceAll('[^\\w-]', '');
        
        Integer rank = 0;
        
         if(rankSearchString == viewData.product.SKU__c.toUpperCase()) {
        	//System.debug('--- prouduct ' + viewData.product.SKU__c + ' ' + CustomSettingsDAO.EQUALS_SKU + ' += ' + searchIntSettings.get(CustomSettingsDAO.EQUALS_SKU) + '---');
        	rank += searchIntSettings.get(cc_cnst_CloudCraze.SR_ExactProdNum);
        } else if(viewData.product.SKU__c.toUpperCase().contains(rankSearchString)) {
            //System.debug('--- prouduct ' + viewData.product.SKU__c + ' ' + CustomSettingsDAO.MATCHES_SKU + ' += ' + searchIntSettings.get(CustomSettingsDAO.MATCHES_SKU) + '---');
            rank += searchIntSettings.get(cc_cnst_CloudCraze.SR_inProdNum);
        }
       //put together display string 
       String displayString = viewData.product.Name;
       
        if(displayString.toUpperCase().contains(rankSearchString))
        {
        	rank += searchIntSettings.get(cc_cnst_CloudCraze.SR_inDispName);
        	System.debug('Found match on display name for ' + displayString + ' Rank + ' + searchIntSettings.get(cc_cnst_CloudCraze.SR_inDispName)); 
        }
		
        if(viewData.product.ShortDesc__c!=null && viewData.product.ShortDesc__c.toUpperCase().contains(rankSearchString)) 
        {
             rank += searchIntSettings.get(cc_cnst_CloudCraze.SR_inShortDesc);
             System.debug('Found match on short desc for  ' + displayString + 'Rank + ' + searchIntSettings.get(cc_cnst_CloudCraze.SR_inShortDesc)); 
        }
        
       Date startDate = viewData.product.StartDate__c;
       Integer daysSince = System.today().daysBetween(startDate);
      	viewData.productSearchRank = rank;
      	viewData.sortRank = -(2*(rank*10)+daysSince);
      //	viewData.sortRank=-(2*(rank*100000) + viewData.priceListItem.Price__c);
        
        //System.debug('--- sku=' + viewData.product.SKU__c + ', productSearchRank=' + viewData.productSearchRank + ' ---');
    }
}