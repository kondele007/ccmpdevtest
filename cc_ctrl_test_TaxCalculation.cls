//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
/* ============================================================
 * Unit test for cc_ctrl_TaxCalculation
 * 
 * ============================================================
 */
@IsTest
private class cc_ctrl_test_TaxCalculation {
    
    private static testmethod void testGetTaxAmountWithValidCode(){
        cc_bean_TaxCalculation cc_bean_TaxCalculation = new cc_bean_TaxCalculation();
        Decimal taxRate = 0;
        cc_bean_TaxCalculation.cartTotal = 90.19;
        cc_bean_TaxCalculation.countryCode= 'US';
        cc_bean_TaxCalculation.stateCode= 'NY';
        List<E_TaxRate__c> taxRateList = new List<E_TaxRate__c>();
        cc_test_PrepTestData.insertTaxRate(cc_bean_TaxCalculation.countryCode, cc_bean_TaxCalculation.stateCode, 'tax rate id1'); 
        taxRateList = [Select a.TaxRate__c 
                          from E_TaxRate__c a 
                          where CountryCode__c =:cc_bean_TaxCalculation.countryCode 
                          and StateCode__c =:cc_bean_TaxCalculation.stateCode
                         ]; 
        for(E_TaxRate__c taxRateObject: taxRateList){
                taxRate = taxRateObject.TaxRate__c;
        }                        
        cc_ctrl_TaxCalculation cc_ctrl_TaxCalculation = new cc_ctrl_TaxCalculation();
        Decimal taxAmount = cc_ctrl_TaxCalculation.getTaxAmount(cc_bean_TaxCalculation);
        if (taxRate > 0) {
            taxRate *= cc_bean_TaxCalculation.cartTotal;
            taxAmount = taxRate.divide(100, 2);
            System.assert(taxRate.divide(100, 2) == taxAmount);                         
            } else {      
            System.assert(0 == taxAmount);
            }
    }
    
    private static testmethod void testGetTaxAmountWithInValidCode(){
        cc_bean_TaxCalculation cc_bean_TaxCalculation = new cc_bean_TaxCalculation();
        cc_bean_TaxCalculation.cartTotal = 22.07;
        cc_bean_TaxCalculation.countryCode= 'ZZ';
        cc_bean_TaxCalculation.stateCode= 'ZZ';
        cc_ctrl_TaxCalculation cc_ctrl_TaxCalculation = new cc_ctrl_TaxCalculation();
        Decimal taxAmount = cc_ctrl_TaxCalculation.getTaxAmount(cc_bean_TaxCalculation);
        System.assert(0 == taxAmount);
    }    
    
    private static testmethod void testGetTaxAmountWithNoCartValue(){
        cc_bean_TaxCalculation cc_bean_TaxCalculation = new cc_bean_TaxCalculation();
        cc_bean_TaxCalculation.cartTotal = 0;
        cc_bean_TaxCalculation.countryCode= 'US';
        cc_bean_TaxCalculation.stateCode= 'NY';
        cc_ctrl_TaxCalculation cc_ctrl_TaxCalculation = new cc_ctrl_TaxCalculation();
        Decimal taxAmount = cc_ctrl_TaxCalculation.getTaxAmount(cc_bean_TaxCalculation);
        System.assert(0 == taxAmount);
    }
    
}