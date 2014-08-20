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
private class cc_api_test_PageConfiguration {

    static testMethod void myUnitTest() {
        list<PageConfiguration__c> pcs = new list<PageConfiguration__c> {
        	new PageConfiguration__c(name='DefaultStore.HomePage.css01', value__c='styles.css', Enabled__c=true),
        	new PageConfiguration__c(name='DefaultStore.HomePage.css02', value__c='css/spasticnav.css', Enabled__c=true),
        	new PageConfiguration__c(name='DefaultStore.HomePage.js01', value__c='js/spasticnav.js', Enabled__c=true),
        	new PageConfiguration__c(name='DefaultStore.HomePage.js02', value__c='js/homepage.js', Enabled__c=true),
        	new PageConfiguration__c(name='DefaultStore.Theme', value__c='CCThemeRed', Enabled__c=true)
        };
        insert pcs;
        
        cc_api_PageConfiguration instance = cc_api_PageConfiguration.getInstance();
        system.assertEquals(instance.getPageConfigurationValue('DefaultStore.HomePage.css01'), 'styles.css');
        list<cc_api_NameValuePair> pairs = instance.getPageConfigurationValues('DefaultStore.HomePage');
        system.assertEquals(pairs.size(), 4);
        system.debug(pairs);
        system.assertEquals(instance.getPageConfigurationValue('DefaultStore.HomePage.css01', null), 'styles.css');
    }
    
    static testMethod void myUnitTest2() {
        list<PageConfiguration__c> pcs = new list<PageConfiguration__c> {
        	new PageConfiguration__c(name='DefaultStore.HomePage.css01', value__c='styles.css', Enabled__c=true),
        	new PageConfiguration__c(name='DefaultStore.HomePage.css02', value__c='css/spasticnav.css', Enabled__c=false),
        	new PageConfiguration__c(name='DefaultStore.HomePage.js01', value__c='js/spasticnav.js', Enabled__c=true),
        	new PageConfiguration__c(name='DefaultStore.HomePage.js02', value__c='js/homepage.js', Enabled__c=true),
        	new PageConfiguration__c(name='DefaultStore.Theme', value__c='CCThemeRed', Enabled__c=true)
        };
        insert pcs;
        
        cc_api_PageConfiguration instance = cc_api_PageConfiguration.getInstance();
        system.assertEquals(instance.getPageConfigurationValue('DefaultStore.HomePage.css01'), 'styles.css');
        list<cc_api_NameValuePair> pairs = instance.getPageConfigurationValues('DefaultStore.HomePage');
        system.assertEquals(pairs.size(), 3);
        system.assertEquals(instance.getPageConfigurationValue('DefaultStore.HomePage.css02'), null);
        system.debug(pairs);
        
    }
    
    static testMethod void myUnitTest3() {
        list<PageConfiguration__c> pcs = new list<PageConfiguration__c> {
        	new PageConfiguration__c(name='DefaultStore.Theme', value__c='CC_Theme_Midnight', enabled__c=true),
			new PageConfiguration__c(name='DefaultStore.HomePage.css.010', value__c='styles.css', enabled__c=true),
			new PageConfiguration__c(name='DefaultStore.All.css.010', value__c='css/cupertino/jquery-ui-1.8.20.custom.css', enabled__c=true),
			new PageConfiguration__c(name='DefaultStore.HomePage.js.050', value__c='js/spasticnav.js', enabled__c=true),
			new PageConfiguration__c(name='DefaultStore.HomePage.H.TagLine', value__c='images/home/tagline.gif', enabled__c=true),
			new PageConfiguration__c(name='Global.All.js.020', value__c='js/jquery-ui-1.8.20.custom.min.js', enabled__c=true),
			new PageConfiguration__c(name='Global.All.js.010', value__c='js/jquery-1.7.2.min.js', enabled__c=true),
			new PageConfiguration__c(name='DefaultStore.HomePage.js.035', value__c='js/jquery-treeview/jquery.treeview.js', enabled__c=true),
			new PageConfiguration__c(name='DefaultStore.All.css.020', value__c='js/jquery-treeview/jquery.treeview.css', enabled__c=true),
			new PageConfiguration__c(name='DefaultStore.All.css.030', value__c='css/fg.menu.css', enabled__c=true),
			new PageConfiguration__c(name='DefaultStore.HomePage.js.030', value__c='js/jquery-treeview/lib/jquery.cookie.js', enabled__c=true),
			new PageConfiguration__c(name='DefaultStore.HomePage.css.050', value__c='css/spasticnav.css', enabled__c=true),
			new PageConfiguration__c(name='Global.All.js.050', value__c='js/cloudcraze.js', enabled__c=true),
			new PageConfiguration__c(name='DefaultStore.HomePage.js.100', value__c='js/homepage.js', enabled__c=true),
			new PageConfiguration__c(name='DefaultStore.ProductList.css.050', value__c='css/spasticnav.css', enabled__c=true),
			new PageConfiguration__c(name='DefaultStore.ProductList.js.050', value__c='js/spasticnav.js', enabled__c=true),
			new PageConfiguration__c(name='DefaultStore.ProductList.js.100', value__c='js/homepage.js', enabled__c=true),
			new PageConfiguration__c(name='DefaultStore.ProductList.js.030', value__c='js/jquery-treeview/lib/jquery.cookie.js', enabled__c=true),
			new PageConfiguration__c(name='DefaultStore.ProductList.js.035', value__c='js/jquery-treeview/jquery.treeview.js', enabled__c=true),
			new PageConfiguration__c(name='DefaultStore.ProductList.css.010', value__c='styles.css', enabled__c=true),
			new PageConfiguration__c(name='Global.All.H.Logo', value__c='images/cloudburst_logo_global.png', enabled__c=true),
			new PageConfiguration__c(name='DefaultStore.HomePage.H.Logo', value__c='images/cloudburst_logo_black.png', enabled__c=true),
			new PageConfiguration__c(name='MyStore.Cart.H.Logo', value__c='images/wrongpage', enabled__c=true)
        };
        insert pcs;
        
        cc_api_PageConfiguration instance = cc_api_PageConfiguration.getInstance();
        
        system.assertEquals(instance.getValueWithOverride('Global', 'All', 'H.Logo'), 'images/cloudburst_logo_global.png');
        system.assertEquals(instance.getValueWithOverride('DefaultStore', 'HomePage', 'H.Logo'), 'images/cloudburst_logo_black.png');
        system.assertEquals(instance.getValueWithOverride('MyStore', 'Cart', 'H.Logo'), 'images/wrongpage');
        system.assertEquals('images/cloudburst_logo_global.png', instance.getValueWithOverride('MyStore', 'HomePage', 'H.Logo'));
        system.assertEquals(null, instance.getValueWithOverride('MyStore', 'HomePage', 'H.XXX'));
        //system.assertEquals(instance.getValueWithOverride('MyStore', '', 'H.Logo'), 'images/wrongpage');
        //system.assertEquals(instance.getValueWithOverride('', '', 'H.Logo'), 'images/wrongpage');
        
    }
    
}