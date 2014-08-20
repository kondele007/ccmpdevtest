//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public abstract class cc_bean_ProductComponent {
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
	
	public integer level { get; set; }
	public integer quantity { get; set; }
	public String category { get; set;}
	public E_Product__c component {get; set; }
	//==================================================
    // CONSTRUCTOR
    //==================================================
	public cc_bean_ProductComponent(E_Product__c p)
	{
		component = p;
		quantity = 1;
	}
	//==================================================
    // INTERFACE METHODS
    //==================================================
	public virtual List<cc_bean_ProductComponent> getChildren() { return null; }
	public virtual void addChild(cc_bean_ProductComponent c) {}
}