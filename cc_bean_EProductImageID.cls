//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_bean_EProductImageID {
	//==================================================
    // CONSTRUCTOR
    //==================================================
	public cc_bean_EProductImageID(String id1, String source1, String id2, String source2) 
	{largeImage = id1; thumbNailImage=id2; largeImageSource = source1; thumbNailSource = source2;}
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
	public String largeImage { get; set; }
	public String thumbNailImage { get; set; }
	public String largeImageSource { get; set; }
	public String thumbNailSource { get; set; }
	
	static testMethod void myUnitTest() {
		cc_bean_EProductImageID testObj = new cc_bean_EProductImageID('id1', 'source1', 'id2', 'source2');
		System.assertEquals(testObj.largeImage, 'id1');
		System.assertEquals(testObj.thumbNailImage, 'id2');
		System.assertEquals(testObj.largeImageSource, 'source1');
		System.assertEquals(testObj.thumbNailSource, 'source2');
		
	}
}