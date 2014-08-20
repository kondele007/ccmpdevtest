@isTest
private class cc_ctrl_test_UrlRewriter {

    static testMethod void testUrlRewriter() {
    	cc_test_PrepTestData.loadCustomSettings();
        cc_hlpr_InitLoadCategories.loadTestCategories();
        cc_hlpr_InitLoadCategories.loadTestProducts();
	 	
	 	List<E_Product__c> testProducts = [select SKU__c from E_Product__c limit 1];
	 	System.assertEquals(1, testProducts.size()); 
	 	E_Product__c testProduct = testProducts[0];
	 	
	 	List<E_Category__c> testCategories = [select CategoryID__c from E_Category__c limit 1];
	 	System.assertEquals(1, testCategories.size());
	 	E_Category__c testCategory = testCategories[0];
	 	
	 	Test.startTest();
    	
        PageReference productDetailsPage = new PageReference('/ProductDetails/' + testProduct.SKU__c);
        cc_ctrl_UrlRewriter rewriter = new cc_ctrl_UrlRewriter();
        PageReference resultUrl = rewriter.mapRequestUrl(productDetailsPage);
        System.debug('--- cc_ctrl_test_UrlRewriter.testUrlRewriter: productDetailsPage resultUrl=' + resultUrl);
        System.assertNotEquals(null, resultUrl);
        
        PageReference categoryPage = new PageReference('/Category/' + testCategory.CategoryID__c);
        resultUrl = rewriter.mapRequestUrl(categoryPage);
        System.debug('--- cc_ctrl_test_UrlRewriter.testUrlRewriter: categoryPage resultUrl=' + resultUrl);
        System.assertNotEquals(null, resultUrl);
        
        PageReference dummyPage = new PageReference('/doesntexist/');
        resultUrl = rewriter.mapRequestUrl(dummyPage);
        System.debug('--- cc_ctrl_test_UrlRewriter.testUrlRewriter: dummy page resultUrl=' + resultUrl);
        System.assertEquals(null, resultUrl);
        
        List<PageReference> pages = new List<PageReference>{productDetailsPage,categoryPage};
        List<PageReference> resultPages = rewriter.generateUrlFor(pages);
        System.assertEquals(pages, resultPages);
        
		PageReference image_url = new PageReference('/images/CC_OOTBImages/images/products/110515U/Product_Image/110515U_ProdImage.jpg');
        resultUrl = rewriter.mapRequestUrl(image_url);
        System.debug('--- cc_ctrl_test_UrlRewriter.testUrlRewriter: image_path resultUrl=' + resultUrl);
        System.assertEquals(null, resultUrl);

        Test.stopTest();
    }
}