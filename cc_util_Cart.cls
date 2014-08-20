public class cc_util_Cart {
	//==================================================
    // STATIC SERVICE METHODS
    //==================================================
    public static Map<Id,Integer> getCartProductQuantities(List<E_CartItem__c> cartItems) {
    	Map<Id,Integer> cartProducts = new Map<Id,Integer>();

    	for(E_CartItem__c item : cartItems) {
    		cartProducts.put(item.Product__c, item.Quantity__c.intValue());
    	}
    	
    	return cartProducts;
    }
    
    public static Integer getCartTotalQuantity(List<E_CartItem__c> cartItems) {
    	Integer qty = 0;
    	
        for(E_CartItem__c item : cartItems) {
            qty += item.Quantity__c.intValue();
        }

    	return qty;
    }
    
    public static Map<Id,E_CartItem__c> getCartProductMap(List<E_CartItem__c> cartItems) {
    	Map<Id,E_CartItem__c> cartProductMap = new Map<Id,E_CartItem__c>();
    	
        for(E_CartItem__c item : cartItems) {
            cartProductMap.put(item.Product__c, item);
        }
        
        return cartProductMap;
    }
}