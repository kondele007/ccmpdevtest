//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_ctrl_RecentlyVisited {
	//==================================================
    // CONSTANTS
    //==================================================
    public String MAP_DELIMITER = ',';
    public String ATTRIBUTE_DELIMITER = ':';
 	//==================================================
    // INSTANCE PROPERTIES
    //==================================================   
	 public String currentProductID { get; set; } 
	 public String currentCartID { get; set; }
	// public cc_bean_ProductForm cc_bean_ProductForm {get;set;}
 	//==================================================
    // INSTANCE VARIABLES
    //==================================================
    public String cookieValue = null;
    public String cookieJSON = null;
 	//==================================================
    // CONSTRUCTOR
    //==================================================
	 public cc_ctrl_RecentlyVisited(){
	 }
	//==================================================
    // SERVICE METHODS
    //==================================================
 	public List<cc_bean_RecentItem> recentItems {
        get {
            // Instead of getting the recent items from a query, get them
            // from a cookie
            List<cc_bean_RecentItem> recentItems = new List<cc_bean_RecentItem>();
            Map<String,String> cookieValues = getCookieValues();
            Set<String> keys = cookieValues.keySet();
            for(String id: keys){
                cc_bean_RecentItem i = new cc_bean_RecentItem(id, cookieValues.get(id), currentCartId);
                recentItems.add(i);
            }
            
            /*
            ID userId = UserInfo.getUserId();
            List<E_RecentItem__c> items = [Select e.E_Product__r.SKU__c, e.E_Product__r.Id, e.E_Product__r.ShortDesc__c, e.E_Product__r.Name from E_RecentItem__c e where e.User__c= :userId and e.isDeleted = false];
            for(E_RecentItem__c item : items)
            {
                // Just to not break the page
                p.add(new E_Product__c(SKU__c=item.E_Product__r.SKU__c, Id=item.E_Product__r.Id, ShortDesc__c=item.E_Product__r.ShortDesc__c, Name=item.E_Product__r.Name));
            }
            */
            return recentItems;
        }
    }
	
	//==================================================
    // HELPER METHODS
    //==================================================
    // Get the current cookie values
    /**
     * Parses the string for the cookie value into a map of <productID,productName>
     */
     
    public Map<String,String> getCookieValues(){
        Map<String,String> cookieMap = new Map<String,String>();

        if(cookieValue != null){
        // Parse the cookie value into the map
        //System.debug('----------------- splitting the map items');
        String[] mapValues = cookieValue.split(MAP_DELIMITER);
        
        // for each mapValue
        for(String s: mapValues){
            // split into the attribute values
            //System.debug('----------------- splitting the attribute item');
            String[] attributes = s.split(ATTRIBUTE_DELIMITER);

            // Do any JSON decoding necessary
            
            // add the values to the cookieMap
            if(attributes != null && attributes.size() == 2){
                cookieMap.put(attributes[0], attributes[1]);
            }
        }
                }
        
        //System.debug('------- getCookieValues currentProductID: ' + currentProductID + ' ----------------');
                // Add the new product to the map
        if(currentProductID != null && !currentProductID.equals('') && !cookieMap.containsKey(currentProductID)){
            // query for the product
            //String query = 'SELECT E_Product__c.Name, E_Product__c.SKU__c  from E_Product__c where E_Product__c.Id = \'' + currentProductID + '\' limit 1'; //TASK ID 1 START Change ProductID to Sku
            ////System.debug('-------------- query: ' + query); 
            //E_Product__c products = (E_Product__c)Database.query(query)[0];
            
            cc_dao_Product pDao = new cc_dao_Product();
            List<E_Product__c> pdl = pDao.readProductWithID(new List<String> {currentProductID}, cc_util_Locale.getUserLanguage());
             E_Product__c products = pdl[0];            
            if(products != null){
                
            // put the product ID and name in the map
            cookieMap.put(products.SKU__c, products.Name); //TASK ID 1 START Change ProductID to Sku
            }else {
                //System.debug('---------------- Product query returned null');
            }
        }
        
        return cookieMap; 
    }
    /**
     * Gets the cookie values currently in the cookie, adds the current product
     * to the cookie (if it's not already there) and returns the new
     * cookie value
     */
     
     public String getCookieValue(){
        return cookieValue;
     }
     public void setCookieValue(String str){ 
            this.cookieValue = str;
     }
     
     public void doSomething(){
        //System.debug('------- in doSomething ');
        return;
     }
     public void setCookieJSON(String value){
        //System.debug('----------- setCookieJSON value: ' + value);
        // dirty hack - remove this
     }
    public String getCookieJSON(){
        //System.debug('--------- getCookieJSON currentProductID: ' + currentProductID + ' -----------');
        // Get the map of cookie attributes
        Map<String,String> cookieMap = getCookieValues();
        //System.debug('----------- cookieMap.size: ' + cookieMap.size() + ' ---------');
        // Join the map into a JSON string
        
        String cookieStringJSON = null;
        if(cookieMap.size() > 0){
        cookieStringJSON = al.MapUtils.joinMap(cookieMap, ATTRIBUTE_DELIMITER, MAP_DELIMITER);
        }
        
        if(cookieStringJSON == null || cookieStringJSON.length() < 1){
            return null;
        }
        //System.debug('------- getCookieJSON cookieStringJSON: ' + cookieStringJSON + ' ----------------');
        return cookieStringJSON;
    }
    
    
}