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
private class cc_hlpr_test_CategoryStack {

       /* Verifies that push(), pop() and peak() work correctly
   * when there is only 1 object on the cc_hlpr_CategoryStack. */
  static testMethod void basicTest() {
        // Instantiate a cc_hlpr_CategoryStack.
        cc_hlpr_CategoryStack stackInstance = new cc_hlpr_CategoryStack();
        
        // Verify the initial state is as expected.
        System.assert(stackInstance.isEmpty());
        
        //Create a new instance of cc_hlpr_Stack node
        cc_hlpr_StackNode cc_hlpr_StackNode=new cc_hlpr_StackNode();
        
        cc_hlpr_StackNode.setCategoryID('123');
        cc_hlpr_StackNode.setSequence('1');
        cc_hlpr_StackNode.setCategoryName('ABC');
        cc_hlpr_StackNode.setParent('Root');
        
        // Call the push() method and verify the cc_hlpr_CategoryStack is no longer empty
        stackInstance.push(cc_hlpr_StackNode);
        System.assert(!stackInstance.isEmpty());
        
        // Verify that the value we pushed on the cc_hlpr_CategoryStack is the one we expected
        cc_hlpr_StackNode peakValue = stackInstance.peak();
        System.assertEquals('ABC', peakValue.getCategoryName());
        System.assert(!stackInstance.isEmpty());
        
        // Verify the cc_hlpr_CategoryStack state after pop() is called.
        cc_hlpr_StackNode popValue = stackInstance.pop();
        System.assertEquals('123', popValue.getCategoryID());
        System.assert(stackInstance.isEmpty());
  }
    
  /* Verifies that push(), pop() and peak() work correctly
   * when there are multiple objects on the cc_hlpr_CategoryStack. */
  static testMethod void verifyCorrectOrderTest() {
        
        // Instantiate a cc_hlpr_CategoryStack.        
        cc_hlpr_CategoryStack stackInstance = new cc_hlpr_CategoryStack();
        
        // Set up some test data.
        
        cc_hlpr_StackNode bottomStackNode=new cc_hlpr_StackNode();
        
        bottomStackNode.setCategoryID('123');
        bottomStackNode.setSequence('1');
        bottomStackNode.setCategoryName('ABC');
        bottomStackNode.setParent('Root');
        
        
        cc_hlpr_StackNode middleStackNode=new cc_hlpr_StackNode();
        
        middleStackNode.setCategoryID('456');
        middleStackNode.setSequence('2');
        middleStackNode.setCategoryName('def');
        middleStackNode.setParent('Root');
        
        cc_hlpr_StackNode topStackNode=new cc_hlpr_StackNode();
        
        topStackNode.setCategoryID('789');
        topStackNode.setSequence('3');
        topStackNode.setCategoryName('GHI');
        topStackNode.setParent('Root');
        

        
        // Call the push() method with multiple objects
        stackInstance.push(bottomStackNode);
        stackInstance.push(middleStackNode);
        stackInstance.push(topStackNode);
        
        // Verify that the 'top' object is the object we expected 
        cc_hlpr_StackNode peakValue = stackInstance.peak();
        System.assertEquals(topStackNode, peakValue);
        
        //Verify the size of the cc_hlpr_CategoryStack
        System.assertEquals(stackInstance.size(), 3);
        
        // Verify that the order of the objects is as we expected
        cc_hlpr_StackNode popValue = stackInstance.pop();
        System.assertEquals(topStackNode, popValue);
        popValue = stackInstance.pop();
        System.assertEquals(middleStackNode, popValue);
        popValue = stackInstance.pop();
        System.assertEquals(bottomStackNode, popValue);
        System.assert(stackInstance.isEmpty());
  }    
    
  static testMethod void nullValueNotAllowedExceptionTest() {
        cc_hlpr_CategoryStack stackInstance = new cc_hlpr_CategoryStack();
        
        try{        
        	stackInstance.push(null);
        }catch (cc_hlpr_CategoryStack.NullValueNotAllowedException e){
        	// Exit the test if the expected NullValueNotAllowedException is thrown.
        	return;
        }
        // Fail the test if the expected NullValueNotAllowedException is not thrown.
        System.assert(false,
                   'A NullValueNotAllowedException was expected, but was not thrown.');       
  }
    
  static testMethod void stackOverflowTest() {
        cc_hlpr_CategoryStack stackInstance = new cc_hlpr_CategoryStack();
        cc_hlpr_StackNode cc_hlpr_StackNode=new cc_hlpr_StackNode();
        
        try{        
        	for(Integer i = 0; i < cc_hlpr_CategoryStack.MAX_STACK_DEPTH + 1; i++){
        		cc_hlpr_StackNode=new cc_hlpr_StackNode();
        		cc_hlpr_StackNode.setCategoryID('123');
                cc_hlpr_StackNode.setSequence('1');
                cc_hlpr_StackNode.setCategoryName('ABC');
                cc_hlpr_StackNode.setParent('Root');
        		stackInstance.push(cc_hlpr_StackNode);
        	}
        }catch (cc_hlpr_CategoryStack.StackOverflowException e){
        	// Exit the test if the expected StackOverflowException is thrown.
        	return;
        }
        // Fail the test if the expected StackOverflowException is not thrown.
        System.assert(false, 
                     'A StackOverflowException was expected, but was not thrown.');       
  }
    
  static testMethod void stackPopUnderflowTest() {
        cc_hlpr_CategoryStack stackInstance = new cc_hlpr_CategoryStack();
        
        try{        
        	stackInstance.pop();
        }catch (cc_hlpr_CategoryStack.StackUnderflowException e){
        	// Exit the test if the expected StackUnderflowException is thrown.
        	return;
        }
        // Fail the test if the expected StackUnderflowException is not thrown.
        System.assert(false, 
                     'A StackUnderflowException was expected, but was not thrown.');       
  }
    
  static testMethod void stackPeakUnderflowTest() {
        cc_hlpr_CategoryStack stackInstance = new cc_hlpr_CategoryStack();
        
        try{        
        	stackInstance.peak();
        }catch (cc_hlpr_CategoryStack.StackUnderflowException e){
        	// Exit the test if the expected StackUnderflowException is thrown.
        	return;
        }
        // Fail the test if the expected StackUnderflowException is not thrown.
        System.assert(false, 
                     'A StackUnderflowException was expected, but was not thrown.');       
  }
}