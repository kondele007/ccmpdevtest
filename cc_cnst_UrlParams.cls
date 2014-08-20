public with sharing class cc_cnst_UrlParams {

    public static final String ORDER_ENC_ID = 'o';
    public static final String FROM_PAGE = 'fromPage';
    public static final String CONTENT_ID = 'ctid';
    public static final String STORE = 'store';
    static testMethod void myUnitTest() {
	 	system.assert(cc_cnst_UrlParams.STORE == 'store');
	 }
}