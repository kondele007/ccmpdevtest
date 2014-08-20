//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
global with sharing class cc_hlpr_ShippingOptionComparator implements al.ObjectComparator {
	//==================================================
    // DERIVED METHODS
    //==================================================
  global Integer compare(Object object1, Object object2){  
      if(object1==null || !(object1 instanceof cc_ctrl_hlpr_ShippingOption) 
         && object2==null || !(object2 instanceof cc_ctrl_hlpr_ShippingOption)){      
            throw new al.IllegalArgumentException();    
     }
     Decimal r1 = ((cc_ctrl_hlpr_ShippingOption)object1).price;
     Decimal r2 = ((cc_ctrl_hlpr_ShippingOption)object2).price;
     if(r1 < r2){
        return -1;
     } else if(r1 == r2){
        return 0;
     }else{
        return 1;
     }  
  }
}