public with sharing class cc_cnst_PageConfiguration {
	
	public static final String ALL_STOREFRONTS = 'Global';
	public static final String ALL_UI_KEYS = 'All';
	public static final String RESOURCE_CSS = 'css';
	public static final String RESOURCE_JS = 'js';
	static testMethod void myUnitTest() {
	 	system.assert(cc_cnst_PageConfiguration.ALL_STOREFRONTS == 'Global');
	 }
}