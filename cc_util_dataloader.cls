public with sharing class cc_util_dataloader {
	public static final string CustomSettingsStaticResourceName = 'CC_CustomSettings';
	private static String lCustomSettingStaticResourceName = null;
	public static final string ProductDataStaticResourceName = 'CC_Data2';
	private static String lProductDataStaticResourceName = null;
	public static String getCustomSettingStaticResourceName() {
		if(lCustomSettingStaticResourceName == null) {
			lCustomSettingStaticResourceName = cc_util_dataloader.getAbsoluteDataResourceName(CustomSettingsStaticResourceName);
		}
		return lCustomSettingStaticResourceName;
	}
	public static String getProductDataStaticResourceName() {
		if(lProductDataStaticResourceName == null) {
			lProductDataStaticResourceName = cc_util_dataloader.getAbsoluteDataResourceName(ProductDataStaticResourceName);
		}
		return lProductDataStaticResourceName;
	}
	public static String getAbsoluteDataResourceName(String resourceName) {
		System.debug('-------------------' +resourceName);
    	String absoluteResourceName = null;
    	for(StaticResource sr:[Select s.SystemModstamp, s.NamespacePrefix, 
    		                              s.Name, s.LastModifiedDate, s.Id, s.CreatedDate
    		                         From StaticResource s WHERE name = :resourceName]) {
    		    String skey = sr.Name;                     	
    		    if(sr.NamespacePrefix!=null && sr.NamespacePrefix.length()>0) {
    		    	skey=sr.NamespacePrefix+'__'+sr.Name;
    		    }                     	
    		    absoluteResourceName='/resource/'+sr.SystemModstamp.getTime()+'/'+skey;			
    	}    
    		
    	return absoluteResourceName;
    }
    
    static testMethod void myUnitTest() {
    	System.assert(cc_util_dataloader.CustomSettingsStaticResourceName == 'CC_CustomSettings');
    	System.assert(cc_util_dataloader.lCustomSettingStaticResourceName == null);
    	System.assert(cc_util_dataloader.ProductDataStaticResourceName == 'CC_Data2');
    	System.assert(cc_util_dataloader.lProductDataStaticResourceName == null);
    	
    	cc_util_dataloader.getCustomSettingStaticResourceName();
    	cc_util_dataloader.getProductDataStaticResourceName();
    	cc_util_dataloader.getAbsoluteDataResourceName('name');
    }
}