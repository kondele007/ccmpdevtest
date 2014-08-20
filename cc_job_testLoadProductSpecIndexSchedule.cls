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
private class cc_job_testLoadProductSpecIndexSchedule {
	static void setupData() {
		List<E_product__c> productList = new List<E_product__c> {
			new E_product__c(Name='sku1', SKU__c='sku1', ProductStatus__c='Released'),
			new E_product__c(Name='sku2', SKU__c='sku2', ProductStatus__c='Released'),
			new E_product__c(Name='sku3', SKU__c='sku3', ProductStatus__c='Released'),
			new E_product__c(Name='sku4', SKU__c='sku4', ProductStatus__c='Released'),
			new E_product__c(Name='sku5', SKU__c='sku5', ProductStatus__c='Released'),
			new E_product__c(Name='sku6', SKU__c='sku6', ProductStatus__c='Released'),
			new E_product__c(Name='sku7', SKU__c='sku7', ProductStatus__c='Released'),
			new E_product__c(Name='sku8', SKU__c='sku8', ProductStatus__c='Released'),
			new E_product__c(Name='sku9', SKU__c='sku9', ProductStatus__c='Released'),
			new E_product__c(Name='sku10', SKU__c='sku10', ProductStatus__c='Released')
		};
		insert productList;
		List<E_Category__c> categoryList = new List<E_Category__c> {
			new E_Category__c(Name='category1', CategoryID__c='category1'),
			new E_Category__c(Name='category2', CategoryID__c='category2'),
			new E_Category__c(Name='category3', CategoryID__c='category3'),
			new E_Category__c(Name='category2_1', CategoryID__c='category2_1'),
			new E_Category__c(Name='category2_2', CategoryID__c='category2_2'),
			new E_Category__c(Name='category3_1', CategoryID__c='category3_1'),
			new E_Category__c(Name='category3_2', CategoryID__c='category3_2')
		};
		insert categoryList;
		List<E_Category__c> hierarchyList = new List<E_Category__c> {
			new E_Category__c(CategoryID__c='category2', ParentCategory__r=new E_Category__c(CategoryID__c='category1')),
			new E_Category__c(CategoryID__c='category3', ParentCategory__r=new E_Category__c(CategoryID__c='category1')),
			new E_Category__c(CategoryID__c='category2_1', ParentCategory__r=new E_Category__c(CategoryID__c='category2')),
			new E_Category__c(CategoryID__c='category2_2', ParentCategory__r=new E_Category__c(CategoryID__c='category2')),
			new E_Category__c(CategoryID__c='category3_1', ParentCategory__r=new E_Category__c(CategoryID__c='category3')),
			new E_Category__c(CategoryID__c='category3_2', ParentCategory__r=new E_Category__c(CategoryID__c='category3'))
		};
		upsert hierarchyList CategoryID__c;
		
		List<E_ProductCategory__c> pcList = new List<E_ProductCategory__c> {
			new E_ProductCategory__c(Category__r = new E_Category__c(CategoryID__c='category2_1'), Product__r=new E_Product__c(SKU__c='sku1')),
			new E_ProductCategory__c(Category__r = new E_Category__c(CategoryID__c='category2_2'), Product__r=new E_Product__c(SKU__c='sku1')),
			new E_ProductCategory__c(Category__r = new E_Category__c(CategoryID__c='category2_2'), Product__r=new E_Product__c(SKU__c='sku2')),
			new E_ProductCategory__c(Category__r = new E_Category__c(CategoryID__c='category3_1'), Product__r=new E_Product__c(SKU__c='sku3')),
			new E_ProductCategory__c(Category__r = new E_Category__c(CategoryID__c='category3_2'), Product__r=new E_Product__c(SKU__c='sku4')),
			new E_ProductCategory__c(Category__r = new E_Category__c(CategoryID__c='category2_1'), Product__r=new E_Product__c(SKU__c='sku5')),
			new E_ProductCategory__c(Category__r = new E_Category__c(CategoryID__c='category2_2'), Product__r=new E_Product__c(SKU__c='sku6')),
			new E_ProductCategory__c(Category__r = new E_Category__c(CategoryID__c='category3_1'), Product__r=new E_Product__c(SKU__c='sku7')),
			new E_ProductCategory__c(Category__r = new E_Category__c(CategoryID__c='category3_2'), Product__r=new E_Product__c(SKU__c='sku8')),
			new E_ProductCategory__c(Category__r = new E_Category__c(CategoryID__c='category3_1'), Product__r=new E_Product__c(SKU__c='sku9')),
			new E_ProductCategory__c(Category__r = new E_Category__c(CategoryID__c='category3_2'), Product__r=new E_Product__c(SKU__c='sku10'))
		};
		
		insert pcList;
		E_Spec__c spec = new E_Spec__c(name='spec1');
    	insert spec;
    	
		E_Spec__c catSpec = new E_Spec__c(name='catSpec1');
    	insert catSpec;
    	
    	List<E_ProductSpec__c> pss = new List<E_ProductSpec__c> {
    		new E_ProductSpec__c(Product__r = new E_Product__c(SKU__c='sku1'), Spec__c = spec.id, SpecValue__c='value1'),
    		new E_ProductSpec__c(Product__r = new E_Product__c(SKU__c='sku2'), Spec__c = spec.id, SpecValue__c='value2'),
    		new E_ProductSpec__c(Product__r = new E_Product__c(SKU__c='sku3'), Spec__c = spec.id, SpecValue__c='value3'),
    		new E_ProductSpec__c(Product__r = new E_Product__c(SKU__c='sku4'), Spec__c = spec.id, SpecValue__c='value4'),
    		new E_ProductSpec__c(Product__r = new E_Product__c(SKU__c='sku5'), Spec__c = spec.id, SpecValue__c='value5'),
    		new E_ProductSpec__c(Product__r = new E_Product__c(SKU__c='sku6'), Spec__c = spec.id, SpecValue__c='value6'),
    		new E_ProductSpec__c(Product__r = new E_Product__c(SKU__c='sku7'), Spec__c = spec.id, SpecValue__c='value7'),
    		new E_ProductSpec__c(Product__r = new E_Product__c(SKU__c='sku8'), Spec__c = spec.id, SpecValue__c='value8'),
    		new E_ProductSpec__c(Product__r = new E_Product__c(SKU__c='sku9'), Spec__c = spec.id, SpecValue__c='value9'),
    		new E_ProductSpec__c(Product__r = new E_Product__c(SKU__c='sku10'), Spec__c = spec.id, SpecValue__c='value10')
    	};
    	
    	insert pss;
    	
    	List<E_CategorySpec__c> css = new List<E_CategorySpec__c> {
    		new E_CategorySpec__c(Category__r = new E_Category__c(CategoryID__c='category2_1'), Spec__c = catSpec.id, SpecValue__c='value1'),
    		new E_CategorySpec__c(Category__r = new E_Category__c(CategoryID__c='category2_2'), Spec__c = catSpec.id, SpecValue__c='value2'),
    		new E_CategorySpec__c(Category__r = new E_Category__c(CategoryID__c='category3_1'), Spec__c = catSpec.id, SpecValue__c='value3'),
    		new E_CategorySpec__c(Category__r = new E_Category__c(CategoryID__c='category3_2'), Spec__c = catSpec.id, SpecValue__c='value4')
    	};
    	
    	insert css;
	}
    static testMethod void myUnitTest() {
    	setupData();
        Test.startTest();
		
		// Schedule the test job
		String jobId = System.schedule('testLoadProductSpecIndexSchedule', cc_job_LoadProductSpecIndexSchedule.CRON_EXP,
			new cc_job_LoadProductSpecIndexSchedule()); 
			
		// Get the information from the CronTrigger API object
		CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
		// Verify the expressions are the same 
		System.assertEquals(cc_job_LoadProductSpecIndexSchedule.CRON_EXP,
			ct.CronExpression);
		// Verify the job has not run 
		System.assertEquals(0, ct.TimesTriggered);
		// Verify the next time the job will run 
		Date targetDate = Date.today().addDays(1);
		DateTime fireTime = DateTime.newInstance( targetDate.year(), targetDate.month(), targetDate.day(), 0,0,0);
		System.assertEquals(fireTime, ct.NextFireTime); 
		
		Test.stopTest();
		
    }
}