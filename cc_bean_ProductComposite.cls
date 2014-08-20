//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public class cc_bean_ProductComposite extends cc_bean_ProductComponent {
	//==================================================
    // CONSTRUCTOR
    //==================================================
	public cc_bean_ProductComposite(E_Product__c p) {
		super(p);
		v_children = new List<cc_bean_ProductComponent>();
	}
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
	private List<cc_bean_ProductComponent> v_children { get; set; }
	//==================================================
    // DERIVED METHODS
    //==================================================
	public override List<cc_bean_ProductComponent> getChildren() { return v_children; }
	public override void addChild(cc_bean_ProductComponent c) {v_children.add(c);}
	
	
	
}