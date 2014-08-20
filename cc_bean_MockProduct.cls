//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_bean_MockProduct {
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
	public String id {get; set;}
	public String name {get; set;}
	public String sku {get; set;}
	public String UnitOfMeasure { get; set; }
	public String ProductStatus { get; set; }
	public String ProductType { get; set; }
	public String shortDesc { get; set; }
	//==================================================
    // CONSTRUCTOR
    //==================================================
	public cc_bean_MockProduct(E_Product__c p)
	{
		id=p.Id;
		name=p.Name;
		sku=p.SKU__c;
		UnitOfMeasure=p.UnitOfMeasure__c;
		ProductStatus=p.ProductStatus__c;
		productType = p.ProductType__c;
		shortDesc = p.ShortDesc__c;
	}

}