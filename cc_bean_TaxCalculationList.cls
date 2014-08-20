//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
// TODO jlowenthal update unit tests to test tax on lists
public with sharing class cc_bean_TaxCalculationList {
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
    public List<cc_bean_TaxCalculation> taxCalcBeans{get; set;}
    //==================================================
    // CONSTRUCTOR
    //==================================================
    public cc_bean_TaxCalculationList()
    {
    	taxCalcBeans = new List<cc_bean_TaxCalculation>();
    }
    //==================================================
    // SERVICE METHODS
    //==================================================
    public void addTaxCalculationBean(cc_bean_TaxCalculation taxCalcBean)
    {
    	taxCalcBeans.add(taxCalcBean);
    }
    
    public List<String> getListOfZipCodes()
    {
    	List<String> ret = new List<String>();
    	for(cc_bean_TaxCalculation tcBean : taxCalcBeans)
    	{
    		ret.add(tcBean.zipCode);
    	}
    	return ret;
    }
    
    public List<Decimal> getListOfSubTotals()
    {
    	List<Decimal> ret = new List<Decimal>();
    	for(cc_bean_TaxCalculation tcBean : taxCalcBeans)
    	{
    		ret.add(tcBean.subTotal);
    	}
    	return ret;
    }
    
    public List<Decimal> getListOfTotalsWithTax()
    {
    	List<Decimal> ret = new List<Decimal>();
    	for(cc_bean_TaxCalculation tcBean : taxCalcBeans)
    	{
    		ret.add(tcBean.totalWithTax);
    	}
    	return ret;
    }
}