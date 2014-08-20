/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class cc_api_test_NameValuePair {

    static testMethod void myUnitTest() {
        list<cc_api_NameValuePair> pcs = new list<cc_api_NameValuePair> {
        	new cc_api_NameValuePair('DefaultStore.HomePage.css02', 'css/spasticnav.css'),
        	new cc_api_NameValuePair('DefaultStore.HomePage.css01', 'styles2.css'),
        	new cc_api_NameValuePair('Global.All.css01', 'globalstyles1.css'),
        	new cc_api_NameValuePair('DefaultStore.HomePage.css01', 'styles1.css'),
        	new cc_api_NameValuePair('DefaultStore.HomePage.js01', 'js/spasticnav.js'),
        	new cc_api_NameValuePair('DefaultStore.All.css01', 'allstyles1.css'),
        	new cc_api_NameValuePair('DefaultStore.HomePage.js02', 'js/homepage.js'),
        	new cc_api_NameValuePair('DefaultStore.Theme', 'CCThemeRed'),
        	new cc_api_NameValuePair('DefaultStore.All.css02', 'allstyles2.css'),
        	new cc_api_NameValuePair('Global.HomePage.css01', 'globalstyles2.css')
        };
        
        // sort by name/value
        list<cc_api_NameValuePair> result = (list<cc_api_NameValuePair>) cc_hlpr_CloudCrazeSorter.IntrospectionSort(pcs, 0, pcs.size(), new cc_api_NameValuePair.NameValueComparator());
    	
    	system.assertEquals('allstyles1.css', result[0].value);
    	system.assertEquals('allstyles2.css', result[1].value);
    	system.assertEquals('styles1.css', result[2].value);
    	system.assertEquals('styles2.css', result[3].value);
    	
    	// sort by page config settings order
        result = (list<cc_api_NameValuePair>) cc_hlpr_CloudCrazeSorter.IntrospectionSort(pcs, 0, pcs.size(), new cc_api_NameValuePair.PageSettingComparator());
    	
    	system.assertEquals('globalstyles1.css', result[0].value);
    	system.assertEquals('globalstyles2.css', result[1].value);
    	system.assertEquals('allstyles1.css', result[2].value);
    	system.assertEquals('allstyles2.css', result[3].value);
    	system.assertEquals('styles1.css', result[4].value);
    	system.assertEquals('styles2.css', result[5].value);
    }
}