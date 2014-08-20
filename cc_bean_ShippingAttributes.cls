//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_bean_ShippingAttributes {  
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
	public String productId {get; set;}	
	
	public Decimal weight {get; set;}
	public Decimal dryIceWeight {get; set;}
	public String UOM {get; set;}
    
    public boolean groundShippingRequired {get; set;}
    public boolean overnightAirRequired {get; set;}    
    
    public boolean dryIceRequired {get; set;}    
    public boolean coolerPakRequired {get; set;}
    
    public boolean hazardousflag {get; set;}    
    public boolean hazardousoutside48flag {get; set;}    
}