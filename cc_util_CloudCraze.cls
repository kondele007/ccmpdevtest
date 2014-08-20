//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public without sharing class cc_util_CloudCraze {
    //==================================================
    // CONSTANTS
    //==================================================    
    public static final String DefaultAnonymousUserName = 'Anonymous'; // move to cc_util_CloudCraze
    public static E_StorefrontSettings__c storeFrontSettings = null;
    //==================================================
    // STATIC VARIABLES
    //==================================================    
    private static Id currentUserId = null;
    private static Id currentAccountId = null;
   
    
    //==================================================
    // STATIC PROPERTIES
    //==================================================     
    public static Integer rootBreadCrumbLength { get; set; }
    public static Integer rootBreadCrumbURLLength { get; set; }
    public static String lastSelectedCategory;
    public static String productCategory;
    
    
    public static String localNamespace {
        get {
        	if(localNamespace == null) {
	            Schema.DescribeSObjectResult d = Schema.SObjectType.E_AccountGroup__c;
	            String localName = d.localName;
	            String fullName = d.name;
	            System.debug('--- localName=' + localName + ', fullName=' + fullName);
	            if(localName != fullName) {
	                localNamespace = fullName.substring(0, fullName.indexOf(localName));
	            } else {
	                localNamespace = '';
	            }
	            System.debug('--- localNamespace=' + localNamespace);
        	}
            return localNamespace;
        }
        set;
    }
    
    public static E_ApplicationSettings__c application {
        get {
            application = E_ApplicationSettings__c.getValues(cc_cnst_CloudCraze.DEFAULT_APPLICATION_NAME);
            System.debug('JLL DEBUG UNIT TESTS ====== ' + application);
            return application;
        }
        set;
    }
    
    //==================================================
    // STATIC INITIALIZER
    //==================================================    
    static {
        rootBreadCrumbLength=0;
        rootBreadCrumbURLLength=0;
        localNamespace = null;
    }
    
    //==================================================
    // STATIC HELPER METHODS
    //==================================================    
    public static boolean isInDevMode(String store) {
        return cc_util_CloudCraze.getStorefrontSettings(store).DevMode__c;
    }
    
    public static boolean isInDevMode(E_StorefrontSettings__c storeFront) {
        return storeFront.DevMode__c;
    }
    
    public static boolean isInDevMode() {
        return cc_util_CloudCraze.isInDevMode(cc_util_CloudCraze.application.Default_Storefront__c);
    }
    public static E_StorefrontSettings__c getDefaultStorefrontSettings() {
        System.debug('JLL UNIT TESTS============' + cc_util_CloudCraze.application);
        return cc_util_CloudCraze.getStorefrontSettings(cc_util_CloudCraze.application.Default_Storefront__c);
    }

    public static E_StorefrontSettings__c getStorefrontSettings(String store) {
        E_StorefrontSettings__c sf = null;
        
        if(store != null) {
            store = store.replaceAll('/', '');
            System.debug('--- cc_util_CloudCraze.getStorefrontSettings: getting settings for store=' + store);
    
            sf = E_StorefrontSettings__c.getValues(store);
        }

        if(sf == null) {
            System.debug('--- cc_util_CloudCraze.getStorefrontSettings: getting default storefront=' + cc_util_CloudCraze.application.Default_Storefront__c);
            sf = E_StorefrontSettings__c.getValues(cc_util_CloudCraze.application.Default_Storefront__c);
        }
        storeFrontSettings = sf;
        //System.debug('--- cc_util_CloudCraze.getStorefrontSettings: returning sf=' + sf);
        return sf;
    }
    
    private static Map<String,Integer> populateRanks(E_StorefrontSettings__c sf){
        Map<String,Integer> searchRankMap=new Map<String,Integer>();
   
        searchRankMap.put(cc_cnst_CloudCraze.SR_ExactProdNum, sf.SearchRank_ExactProductNum__c == null ? 0 : sf.SearchRank_ExactProductNum__c.intValue());
        searchRankMap.put(cc_cnst_CloudCraze.SR_inProdNum, sf.SearchRank_inProdNum__c == null ? 0 : sf.SearchRank_inProdNum__c.intValue());
        searchRankMap.put(cc_cnst_CloudCraze.SR_inDispName, sf.SearchRank_inDisplayName__c == null ? 0 : sf.SearchRank_inDisplayName__c.intValue());
        searchRankMap.put(cc_cnst_CloudCraze.SR_inShortDesc, sf.SearchRank_ShortDesc__c == null ? 0 : sf.SearchRank_ShortDesc__c.intValue());
        searchRankMap.put(cc_cnst_CloudCraze.SR_ManuName, sf.SearchRank_ManuName__c == null ? 0 : sf.SearchRank_ManuName__c.intValue());
        return searchRankMap;   
    }
    public static Map<String,Integer> getRank(){
        return populateRanks(getDefaultStorefrontSettings());
    }
    
    public static Map<String,Integer> getRank(String store){
        return populateRanks(getStorefrontSettings(store)); 
    }
    
    public static Integer getRootBreadCrumbLength() {
        return getRootBreadCrumbLength(cc_util_CloudCraze.application.Default_Storefront__c);
    }

    public static Integer getRootBreadCrumbLength(String store) {
        Integer rootLength = 0;
        
        E_StorefrontSettings__c sf = getStorefrontSettings(store);
        
        String rootCatId = null;
        List<E_Category__c> rootCats = [select Id from E_Category__c where CategoryID__c = :sf.Root_Category_ID__c limit 1];
        if(rootCats != null && rootCats.size() > 0) {
            rootCatId = rootCats[0].Id;
        }

        if(rootCatId != null) {
            List<E_BreadCrumb__c> breadCrumbRoot = [select BreadCrumb__c, BreadCrumbURL__c from E_BreadCrumb__c where CategoryID__c = :rootCatId];
            if(breadCrumbRoot != null && breadCrumbRoot.size() > 0 && breadCrumbRoot[0] != null && breadCrumbRoot[0].BreadCrumb__c != null) {
                System.debug('--- cc_util_CloudCraze.getRootBreadCrumbLength: breadCrumbRoot=' + breadCrumbRoot[0].BreadCrumb__c);
                rootBreadCrumbURLLength = breadCrumbRoot[0].BreadCrumbURL__c.length();
                rootLength = breadCrumbRoot[0].BreadCrumb__c.length();
            }
        }
        return rootLength;
    }
   
   public static ID getAccountID()
   {        
        if(isGuest())   
        {
            //System.debug('--------------------------GUEST-------------------------');
            return getAnonymousAccountID();
        }
        else
        {
            //System.debug('--------------------------getAccountID current User Id-------------------------' + currentUserId);
            //System.debug('--------------------------getAccountID UserInfo.getUserId-------------------------' + UserInfo.getUserId());
            if(UserInfo.getUserId() != currentUserId)
            {
                //reset currentUserId if cached id differs from userinfo.getUserId(), then re-query currentAccountId
                //System.debug('--------------------------retrieving user record 1-------------------------');
                currentUserId = UserInfo.getUserId();
                User u = [Select u.UserType, u.Contact.AccountId From User u where u.id = :currentUserId];
                currentAccountId = u.Contact.AccountId;
            }
            else if(currentAccountId == null && currentUserId != null)
            {
                System.debug('--------------------------retrieving user record 2-------------------------');
                User u = [Select u.UserType, u.Contact.AccountId From User u where u.id = :currentUserId];
                currentAccountId = u.Contact.AccountId;
            }
            /* CC SaaS Mod - Schema Change - removed E_ProfileToAccount__c
            if(currentAccountId == null)
            {
                Profile p = [select name from Profile where id = :userinfo.getProfileId() limit 1];
                for(E_ProfileToAccount__c pa : [select account__c from E_ProfileToAccount__c where name = :p.Name])
                {
                    System.debug('AccountName = ' + pa.account__c);
                    currentAccountId = pa.account__c;
                }
            }
            */
            if(currentAccountId == null)
            {
                currentAccountId = getAnonymousAccountID();
            }
            
            //System.debug('--------------------------User contact from cc_util_CloudCraze-------------------------' + u.Contact.id);
            System.debug('--------------------------Account ID from cc_util_CloudCraze-------------------------' + currentAccountId);
            return currentAccountId;
        }
    }

   public static ID getAccountID(User u)
   {        
        System.debug('--------------------------#2getAccountID current User Id-------------------------' + currentUserId);
        System.debug('--------------------------getAccountID UserInfo.getUserId-------------------------' + UserInfo.getUserId());
        System.debug('--------------------------retrieving user record 1-------------------------');
        currentUserId = u.Id;
        u = [Select u.UserType, u.Contact.AccountId From User u where u.id = :currentUserId];
        currentAccountId = u.Contact.AccountId;
        if(currentAccountId == null && currentUserId != null)
        {
            System.debug('--------------------------retrieving user record 2-------------------------');
            u = [Select u.UserType, u.Contact.AccountId From User u where u.id = :currentUserId];
            currentAccountId = u.Contact.AccountId;
        }
        /* CC SaaS Mod - Schema Change - removed E_ProfileToAccount__c
        if(currentAccountId == null)
        {
            Profile p = [select name from Profile where id = :userinfo.getProfileId() limit 1];
            for(E_ProfileToAccount__c pa : [select account__c from E_ProfileToAccount__c where name = :p.Name])
            {
                System.debug('AccountName = ' + pa.account__c);
                currentAccountId = pa.account__c;
            }
        }
        */
        //System.debug('--------------------------User contact from cc_util_CloudCraze-------------------------' + u.Contact.id);
        System.debug('--------------------------Account ID from cc_util_CloudCraze-------------------------' + currentAccountId);
        return currentAccountId;
    }

    
    public static Boolean isGuest()
    {
        return cc_cnst_CloudCraze.USER_TYPE_GUEST.equals(UserInfo.getUserType());
    }
    
/*
    public static String getAnonymousUserName() {
        String anonymousUserName = cc_util_CloudCraze.application.Anonymous_Username__c;
         
        if(anonymousUserName == null) {
            anonymousUserName = cc_cnst_CloudCraze.DEFAULT_ANONYMOUS_USER_NAME;
        }
        return anonymousUserName;
    }
*/
    
    public Static String getPageURL(){
        String url='';
        if(Site.getPrefix()==null){
            url+='https://';
            url+=Apexpages.currentPage().getHeaders().get('Host');
            url=url+'/apex';
        }
        else{
            url=Site.getPrefix();           
        }
        return url;
    }
    
    public static String toString(Object[] objectArray){
        if(objectArray == null){
            return '{}';    
        }
        String returnValue = '{';
        for(Integer i = 0; i < objectArray.size(); i++){
            if(i!=0){ returnValue += ','; }
            returnValue += '\'' + objectArray[i] + '\'';
        }
        returnValue += '}';
        return returnValue; 
    }
     
    public static void assertArraysAreEqual(Object[] expected, Object[] actual){
        //check to see if one param is null but the other is not
        System.assert((expected == null && actual == null)|| (expected != null && actual != null),
            'Assertion failed, the following two arrays are not equal.  Expected: ' 
                    + cc_util_CloudCraze.toString(expected) + ', Actual: ' + cc_util_CloudCraze.toString(actual));
        if(expected != null && actual != null){
            System.assert(expected.size() == actual.size(), 'Assertion failed, the following two arrays are not equal.  Expected: ' 
                    + cc_util_CloudCraze.toString(expected) + ', Actual: ' + cc_util_CloudCraze.toString(actual));
            for(Integer i = 0; i < expected.size(); i++){
                System.assert(expected[i] == actual[i], 'Assertion failed, the following two arrays are not equal.  Expected: ' 
                    + cc_util_CloudCraze.toString(expected) + ', Actual: ' + cc_util_CloudCraze.toString(actual));
            }
        }
    }
    
    public static List<E_Product__c> getRelatedProducts(ID prodID, String relatedType)
    {
        List<E_Product__c> pList = new List<E_Product__c>();
        for (E_RelatedProduct__c rp:  [Select e.Enabled__c, e.EndDate__c, e.Name, e.Product__c, e.RelatedProduct__c, e.RelatedProduct__r.Id, e.RelatedProduct__r.Name, e.RelatedProduct__r.ShortDesc__c, e.RelatedProduct__r.SKU__c, e.RelatedProduct__r.StartDate__c, e.Sequence__c, e.StartDate__c, e.RelatedProduct__r.ProductStatus__c from E_RelatedProduct__c e where e.Product__c = :prodID and e.RelatedProductType__c = :relatedType])
        {
            pList.add(rp.RelatedProduct__r);
        }
        return pList;
    }
  
    public static Integer getHistoricalOrderedQty(ID accountID, ID productID)
    {
        return 10;
    }
    
    public static Double getModifiedPrice(Double listPrice, String valueType, Double modifier)
    {
        System.debug('--- enter getModifiedPrice: listPrice=' + listPrice + ', valueType=' + valueType + ', modifier=' + modifier);
        Double temp=0.0;
        if(cc_cnst_CloudCraze.DISCOUNTTYPE_PERCENTAGE.equalsIgnoreCase(valueType))
        {
            temp = listPrice*(1.0-modifier/100.0);
            System.debug('---temp in percentage if clause---' + temp);
        }
        else if(cc_cnst_CloudCraze.DISCOUNTTYPE_ABSOLUTE.equalsIgnoreCase(valueType) && listPrice > modifier)
        {
            temp = listPrice - modifier;
        }
        else if(cc_cnst_CloudCraze.DISCOUNTTYPE_PRICE.equalsIgnoreCase(valueType))
        {
            temp = modifier;
        }
        else{
            temp=listPrice;
        }
        System.debug('--- exit getModifiedPrice: return value=' + temp);
        return temp;
    }
    
    public static Account getAccountByName(String accountName) {
        List<Account> acc = [Select a.Id, a.Name, a.OwnerId from Account a where a.Name= :accountName and a.isDeleted=false limit 1];
        System.debug('--- found ' + acc.size() + ' accounts with name:' + accountName + ' ---');
        
        if(acc.size() == 0) {
            throw new CCAccountNotFoundException(accountName, 'Account not found');
        }// else if(acc.size() > 1) {
        //    throw new CCDuplicatedAccountException(accountName, 'Duplicated account');
        //}
        
        return acc.get(0);
    }

    public static Id getAccountIdByName(String accountName) {
        return cc_util_CloudCraze.getAccountByName(accountName).Id;
    }

    /**
     * Retrieves the account group referenced by the passed in name.
     * @return E_AccountGroup__c
     */
     public static E_AccountGroup__c getAccountGroupByName(String accountGroupName) {
        List<E_AccountGroup__c> accountGroups = [Select a.Id, a.Name from E_AccountGroup__c a where a.Name= :accountGroupName];
        System.debug('--- found ' + accountGroups.size() + ' account Groups with name:' + accountGroupName + ' ---');
        if (accountGroups.size() == 0)
            throw new cc_excn_AccountGroupNotFoundException(accountGroupName, 'Account Group not found');
        else if (accountGroups.size() > 1)
            throw new cc_excn_AccountGroupDuplicatedException(accountGroupName, 'Duplicated account group');
        return accountGroups.get(0);
     }
     
     /**
     * Retrieves the Id of the account group referenced by the passed in name.
     * @return Id
     */
     public static Id getAccountGroupIdByName(String accountGroupName) {
        return getAccountGroupByName(accountGroupName).Id;
     }

    //make anonymousAccountId a singleton - roy lou
    private static Id anonymousAccountId = null;
    public static Account getAnonymousAccount() {
        if(anonymousAccountId == null)
        {
            String anonymousName = cc_util_CloudCraze.application.Anonymous_Account_Name__c;
            System.debug('sns account name: ' + anonymousName);
            Account a = cc_util_CloudCraze.getAccountByName(anonymousName);
            if(a != null)
            {
                anonymousAccountId = a.Id;
            }
        }
        return new Account(id =anonymousAccountId);
    }

    public static Id getAnonymousAccountID() {
        return cc_util_CloudCraze.getAnonymousAccount().Id;
    }
    
    
    public static Boolean isIPAddressSafe(String store, String location){
       /* Boolean IPAddressSafe = false;
        // Decode the location
        if (al.StringUtils.isNotBlank(location)) {
            location = Encodingutil.base64Decode(location).toString();
        }
        if(location == null)
            location = '';
        if(location == 'US'){
            IPAddressSafe = true;
        }else{
            if(CloudCrazeConfiguration.RESTRICTED_COUNTRIES.indexOf(location, 0) == -1){ 
                IPAddressSafe = false;
            }else{
                IPAddressSafe = null;
            }
        }*/
        //return IPAddressSafe;
        return true;
    }
    
    public static string getCurrentPageName() {
    	string ret = null;
    	string reqPath = Apexpages.currentPage().getUrl();
    	if(reqPath != null) {
	        string subStr = reqPath;
			System.debug('ryl-->path' + reqPath);
			integer idx1 = reqPath.lastIndexOf('/');
	    	integer idx2 = reqPath.lastIndexOf('?');
	    	if(idx1 != -1 && idx2 != -1) {
	    		subStr = reqPath.substring(idx1+1, idx2);
	    	} else if(idx1 != -1 && idx2 == -1) {
	    		subStr = reqPath.substring(idx1+1);
	    	} 
	    	string[] pageParts = subStr.split('__');
	  		if(pageParts.size() > 1) {
	  			ret = pageParts[1];
	  		} else {
	  			ret = pageParts[0];
	  		}
    	}
    	return ret;
    }
   //==================================================
    // INNER CLASSES
    //==================================================
    public virtual class CCAccountException extends Exception {
        public String accountName { get; set; }
        public CCAccountException(String accountName, String msg) 
        {
            this(msg);
            this.accountName = accountName;
        }
    }
    
    public virtual class CCAccountNotFoundException extends CCAccountException {
        
        public CCAccountNotFoundException(String accountName, String msg)
        {
            super(accountName, msg);
        }
    }
    
    public virtual class CCDuplicatedAccountException extends CCAccountException {
        
        public CCDuplicatedAccountException(String accountName, String msg)
        {
            super(accountName, msg);
        }
    }
}