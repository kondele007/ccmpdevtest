//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public class cc_hlpr_CompositeProductHelperFactory {
	//==================================================
    // SERVICE METHOD
    //==================================================
	public static cc_hlpr_CompositeProductHelperBase getCompositeProductHelper(String pType)
	{
		cc_hlpr_CompositeProductHelperBase utils = null;
		if(pType == 'Bundle')
		{
			utils = new cc_hlpr_BundleProduct();
		}
		else if(pType == 'Kit')
		{
			utils = new cc_hlpr_KitProduct();
		}
		else if(pType == 'Assembly')
    	{
    		utils = new cc_hlpr_AssemblyProduct();
    	} 
    	else
    	{
    		utils = new cc_hlpr_RegularProduct();
    	}
    	return utils;
	}
}