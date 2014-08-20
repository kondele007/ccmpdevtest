//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
@isTest
private class cc_hlpr_test_Stack {

    /* Verifies that push(), pop() and peak() work correctly
   * when there is only 1 object on the cc_hlpr_Stack. */
  static testMethod void basicTest() {
        // Instantiate a cc_hlpr_Stack.
        cc_hlpr_Stack stackInstance = new cc_hlpr_Stack();
        
        // Verify the initial state is as expected.
        System.assert(stackInstance.isEmpty());
        
        // Set up some test data.
        String onlyString = 'Only String';
        
        // Call the push() method and verify the cc_hlpr_Stack is no longer empty
        stackInstance.push(onlyString);
        System.assert(!stackInstance.isEmpty());
        
        // Verify that the value we pushed on the cc_hlpr_Stack is the one we expected
        String peakValue = stackInstance.peak();
        System.assertEquals(onlyString, peakValue);
        System.assert(!stackInstance.isEmpty());
        
        // Verify the cc_hlpr_Stack state after pop() is called.
        String popValue = stackInstance.pop();
        System.assertEquals(onlyString, popValue);
        System.assert(stackInstance.isEmpty());
  }
    
  /* Verifies that push(), pop() and peak() work correctly
   * when there are multiple objects on the cc_hlpr_Stack. */
  static testMethod void verifyCorrectOrderTest() {
        
        // Instantiate a cc_hlpr_Stack.        
        cc_hlpr_Stack stackInstance = new cc_hlpr_Stack();
        
        // Set up some test data.
        String bottomString = 'Bottom String';
        String middleString = 'Middle String';
        String topString = 'Top String';
        
        // Call the push() method with multiple objects
        stackInstance.push(bottomString);
        stackInstance.push(middleString);
        stackInstance.push(topString);
        
        // Verify that the 'top' object is the object we expected 
        String peakValue = stackInstance.peak();
        System.assertEquals(topString, peakValue);
        
        //Verify the size of the cc_hlpr_Stack
        System.assertEquals(stackInstance.size(), 3);
        
        // Verify that the order of the objects is as we expected
        String popValue = stackInstance.pop();
        System.assertEquals(topString, popValue);
        popValue = stackInstance.pop();
        System.assertEquals(middleString, popValue);
        popValue = stackInstance.pop();
        System.assertEquals(bottomString, popValue);
        System.assert(stackInstance.isEmpty());
  }    
    
  static testMethod void nullValueNotAllowedExceptionTest() {
        cc_hlpr_Stack stackInstance = new cc_hlpr_Stack();
        
        try{        
        	stackInstance.push(null);
        }catch (cc_hlpr_Stack.NullValueNotAllowedException e){
        	// Exit the test if the expected NullValueNotAllowedException is thrown.
        	return;
        }
        // Fail the test if the expected NullValueNotAllowedException is not thrown.
        System.assert(false,
                   'A NullValueNotAllowedException was expected, but was not thrown.');       
  }
    
  static testMethod void stackOverflowTest() {
        cc_hlpr_Stack stackInstance = new cc_hlpr_Stack();
        
        try{        
        	for(Integer i = 0; i < cc_hlpr_Stack.MAX_STACK_DEPTH + 1; i++){
        		stackInstance.push('String ' + i);
        	}
        }catch (cc_hlpr_Stack.StackOverflowException e){
        	// Exit the test if the expected StackOverflowException is thrown.
        	return;
        }
        // Fail the test if the expected StackOverflowException is not thrown.
        System.assert(false, 
                     'A StackOverflowException was expected, but was not thrown.');       
  }
    
  static testMethod void stackPopUnderflowTest() {
        cc_hlpr_Stack stackInstance = new cc_hlpr_Stack();
        
        try{        
        	stackInstance.pop();
        }catch (cc_hlpr_Stack.StackUnderflowException e){
        	// Exit the test if the expected StackUnderflowException is thrown.
        	return;
        }
        // Fail the test if the expected StackUnderflowException is not thrown.
        System.assert(false, 
                     'A StackUnderflowException was expected, but was not thrown.');       
  }
    
  static testMethod void stackPeakUnderflowTest() {
        cc_hlpr_Stack stackInstance = new cc_hlpr_Stack();
        
        try{        
        	stackInstance.peak();
        }catch (cc_hlpr_Stack.StackUnderflowException e){
        	// Exit the test if the expected StackUnderflowException is thrown.
        	return;
        }
        // Fail the test if the expected StackUnderflowException is not thrown.
        System.assert(false, 
                     'A StackUnderflowException was expected, but was not thrown.');       
  }
}