//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
global with sharing class cc_hlpr_RatingComparator implements al.ObjectComparator {
        global Integer compare(Object object1, Object object2){
            cc_bean_ProductListViewData p1 = (cc_bean_ProductListViewData)object1;
            cc_bean_ProductListViewData p2 = (cc_bean_ProductListViewData)object2;
            Integer rc = 0;
            if(p1.averageReview < p2.averageReview) rc = -1;
            else if(p1.averageReview > p2.averageReview) rc = 1;
            
            return rc;
            
        }

}