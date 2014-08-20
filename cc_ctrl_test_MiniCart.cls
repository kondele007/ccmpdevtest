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
private without sharing class cc_ctrl_test_MiniCart {
   
    private static void prepTestData() {
        cc_test_PrepTestData.loadAllCustomSettings();
        cc_test_PrepTestData.loadInitData();
    }
    
    private Id createSpec(String name)
    {
        E_Spec__c spec = new E_Spec__c();
        spec.Name = name;
        spec.Locale__c = 'en_US';
        spec.IsVisibleInCatalog__c = false;
        insert spec;
        return spec.Id;
    }
    
    private static void setupIBFeeData(){
        //Insert IB Fee Category
        //List<E_Category__c> catList = new List<E_Category__c>();
        E_Category__c cat = new E_Category__c();
        cat.CATEGORYID__C = cc_kap_utils_AppConstants.IB_FEE_CATEGORY_ID;
        cat.SHORTDESC__C = 'TEST';
        cat.Name = 'TEST';
        //catList.add(cat);
        //insert catList;
        insert cat;
        
        E_Spec__c spec = new E_Spec__c();
        spec.Name = cc_kap_utils_AppConstants.IB_FEE_SPEC;
        spec.Locale__c = 'en_US';
        spec.IsVisibleInCatalog__c = false;
        insert spec;
        
        //Associate and Create IB Fee spec to Category
        E_CategorySpec__c catSpec = new E_CategorySpec__c();
        catSpec.Spec__c = spec.Id;
        catSpec.Category__c = cat.Id;
        catSpec.SpecValue__c = 'Yes';
        insert catSpec;
        
        
        //Insert IB Fee Product
        E_Product__c prod = new E_Product__c();
        prod.SKU__c = 'IBFee';
        prod.Name = 'IBFee';
        prod.LeadTime__c = 1;
        prod.QuantityPerUnit__c = 1;
        prod.StartDate__c = System.today();
        prod.EndDate__c = System.today();
        prod.ShippingWeight__c = 0;
        prod.ProductStatus__c = cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED;
        //productList.add(prod);
        insert prod;
        //Associate Product to IB Fee Category
        E_ProductCategory__c prodCat = new E_ProductCategory__c();
        prodCat.Category__c = catSpec.Id;
        prodCat.Product__c = prod.Id;
        prodCat.StartDate__c = System.today();
        prodCat.EndDate__c = System.today();
        insert prodCat;
        //Associate and Create Specs for SBU and Currency for Product
        E_Spec__c specSBU = new E_Spec__c();
        specSBU.Name = cc_kap_utils_AppConstants.SPEC_SBU;
        specSBU.Locale__c = 'en_US';
        specSBU.IsVisibleInCatalog__c = false;
        insert specSBU;
        
        E_Spec__c specCurrency = new E_Spec__c();
        specCurrency.Name = cc_kap_utils_AppConstants.IB_FEE_SPEC_CURRENCY;
        specCurrency.Locale__c = 'en_US';
        specCurrency.IsVisibleInCatalog__c = false;
        insert specCurrency;
        
        E_ProductSpec__c prodSpecSBU = new E_ProductSpec__c();
        prodSpecSBU.Product__c = prod.Id;
        prodSpecSBU.Spec__c = specSBU.Id;
        prodSpecSBU.SpecValue__c = '3';
        insert prodSpecSBU;
        
        E_ProductSpec__c prodSpecCurrency = new E_ProductSpec__c();
        prodSpecCurrency.Product__c = prod.Id;
        prodSpecCurrency.Spec__c = specCurrency.Id;
        prodSpecCurrency.SpecValue__c = 'USD';
        insert prodSpecCurrency;
        
    }

    static testMethod void myUnitTest() {
        cc_ctrl_test_MiniCart.prepTestData();
        //setupIBFeeData();
        User u = cc_api_User.getCurrentUser;
        Test.startTest();
           
        cc_api_Cart api = new cc_api_Cart();        
        E_Cart__c cart = api.createEmptyCart('USD', 'Commercial');
        List<E_Product__c> productList = insertProduct();
        for(E_Product__c prod:productList){
            api.addToCart(prod.Id, cart.Id, 1,false, 'USD', 
                          'Commercial', cc_util_CloudCraze.application.Default_Storefront__c);
        }
        cc_ctrl_MiniCart miniCart = new cc_ctrl_MiniCart();
        miniCart.addCoupon();
        miniCart.updateCouponInfo();
        //miniCart.addIBFee();
        //miniCart.removeIBFee();
        
        Test.stopTest();
    }
    
    private Static List<E_Product__c> insertProduct(){
        Integer count =1;
        List<E_Product__c> productList = new List<E_Product__c>();
        Integer i = 0;
        while(i < count){
            E_Product__c prod = new E_Product__c();
            prod.SKU__c = cc_util_RandomString.randomUUID();
            prod.Name = 'ProductName'+String.valueOf(i);
            prod.LeadTime__c = 1;
            prod.QuantityPerUnit__c = 1;
            prod.StartDate__c = System.today();
            prod.EndDate__c = System.today();
            prod.ShippingWeight__c = 0;
            prod.ProductStatus__c = cc_cnst_PickListConstants.PRODUCTSTATUS_RELEASED;
            productList.add(prod);
            i++;
        }
        insert productList;
        return productList;
    }
}