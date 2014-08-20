//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
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
private class cc_hlpr_test_GenericPricingModifier {

	private static void prepTestData() {
        cc_test_PrepTestData.loadAllCustomSettings();
	}

    public static testMethod void myUnitTest() {
    	cc_hlpr_test_GenericPricingModifier.prepTestData();

		Test.startTest();

        cc_hlpr_GenericPricingModifier genericModifier=new cc_hlpr_GenericPricingModifier();
        E_Rule__c testRule=new E_Rule__c();
        testRule=cc_test_PrepTestData.insertRule();
        System.assertEquals(genericModifier.applyModifier(1, 25, testRule.Id),25);
        E_RulePricingModifier__c testModifier = new E_RulePricingModifier__c();
        testModifier = insertPriceModifier(testRule.Id);
        genericModifier.applyModifier(1, 25, testRule.Id);        
        System.assertEquals(genericModifier.applyModifier(1, 25, testRule.Id),25);
        
        Test.stopTest();
    }
    
    public static E_RulePricingModifier__c insertPriceModifier(Id ruleId){       
        E_RulePricingModifier__c rulePriceModifier = new E_RulePricingModifier__c();        
        
        E_PriceModifier__c priceModifier=new E_PriceModifier__c();
        priceModifier.Amount__c = 1234;
        priceModifier.CartTotalAmount__c=2345;
        priceModifier.DiscountType__c= 'Absolute';
        priceModifier.Quantity__c=2;
        priceModifier.OwnerId = UserInfo.getUserId();
        
        insert priceModifier;
        
        rulePriceModifier.PriceModifier__c=priceModifier.Id;
        rulePriceModifier.Rule__c=ruleId;
        rulePriceModifier.StartDate__c=System.today();
        rulePriceModifier.EndDate__c=System.today()+5;
        
        insert rulePriceModifier;
        return rulePriceModifier;
    }
}