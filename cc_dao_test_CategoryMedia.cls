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
private class cc_dao_test_CategoryMedia { 

    static testMethod void myUnitTest() {
    	cc_test_TestDataSetup.loadData();
    	System.assert([Select c.Id From E_ApplicationSettings__c c where name='CloudCraze'].size() != 0);
       List<E_Category__c> listCategory=new List<E_Category__c>();
        
        E_Category__c rootCategory=new E_Category__c();
        rootCategory.Name='Root';
        rootCategory.Sequence__c=0;
        rootCategory.CategoryID__c='123';
        insert rootCategory;
   
        E_Category__c test1Category=new E_Category__c();
        test1Category.Name='test1Category';
        test1Category.Sequence__c=100;
        test1Category.ShortDesc__c='test1Category Category';
        test1Category.ParentCategory__c=rootCategory.Id;
        test1Category.CategoryID__c='789';
        insert test1Category;
        
         E_Category__c test2Category=new E_Category__c();
        test2Category.Name='test2Category';
        test2Category.Sequence__c=200;
        test2Category.ShortDesc__c='test1Category';
        test2Category.CategoryID__c='567';
        test2Category.ParentCategory__c=rootCategory.Id;
        insert test2Category;
        
        E_CategoryMedia__c newCatMedia = new E_CategoryMedia__c();
        newCatMedia.Sequence__c = 100;
        newCatMedia.URI__c = '/nolocation/Example1.jpg';
        newCatMedia.MediaType__c='Category Image';
        newCatMedia.Category__c = test1Category.Id;
        newCatMedia.locale__c='en_US';
        insert newCatMedia;
        
        List<String> categoryIds = new List<String>();
        categoryIds.add(test1Category.Id);
        
        List<E_CategoryMedia__c> cmList = new List<E_CategoryMedia__c>();
        cmList.add(newCatMedia);
        
        cc_dao_CategoryMedia cmDAO = new cc_dao_CategoryMedia();
        cmDAO.readCategory(test1Category.Id);
        cmDAO.getCategoryMedia(categoryIds, 'Category Image');
        cmDAO.saveCategoryMedia(cmList);
        cmDAO.getCategoryAltMessages(categoryIds);
        cmDAO.getCategoryMedia(categoryIds, 'Category Image', 'en_US');
        cmDAO.getCategoryMediaByType(test1Category.Id,  'en_US');
        cmDAO.getCategorySearchMedia(categoryIds);
        cmDAO.getCategoryThumbnailMedia(categoryIds);
        cmDAO.getCategoryMediaByType(test1Category.Id);
        
        cmDAO.getCategorySearchMedia(categoryIds,'en_US');
        cmDAO.getCategoryMedia(categoryIds, 'Category Image', 'de_DE');
        
        cmDAO.deleteCategoryMedia(test1Category.Id);
        
    }
}