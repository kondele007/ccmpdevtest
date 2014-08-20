global class cc_hlpr_CartItemPriceComparator implements al.ISObjectComparator {
	//==================================================
    // SERVICE METHOD
    //==================================================
    global Integer compare(SObject record1, SObject record2) {
    	E_CartItem__c item1 = (E_CartItem__c)record1;
        E_CartItem__c item2 = (E_CartItem__c)record2;
        
        Integer rc = 0;
        
        if(item1.Price__c < item2.Price__c) rc = -1;
        else if(item1.Price__c > item2.Price__c) rc = 1;
        
        return rc;
    }
}