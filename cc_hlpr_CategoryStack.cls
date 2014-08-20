//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_hlpr_CategoryStack {
	//==================================================
    // CONSTANTS
    //==================================================
	public static final Integer MAX_STACK_DEPTH = 1000;
	
	//==================================================
    // PRIVATE MEMBER VARIABLE
    //==================================================
	private List<cc_hlpr_StackNode> cc_hlpr_Stack;
	
	//==================================================
    // CONSTRUCTOR
    //==================================================
	public cc_hlpr_CategoryStack(){
		cc_hlpr_Stack = new List<cc_hlpr_StackNode>();
	}
	
	//==================================================
    // HELPER METHODS
    //==================================================
    public Boolean isEmpty() { return cc_hlpr_Stack.isEmpty(); }
	public Boolean isFull() { return MAX_STACK_DEPTH == cc_hlpr_Stack.size(); }
	private Integer lastItemIndex {
		get { return cc_hlpr_Stack.size() - 1; }
	}
	
	//==================================================
    // SERVICE METHODS
    //==================================================
	public void push(cc_hlpr_StackNode node){ 
		if (node == null) { throw new NullValueNotAllowedException(); }
		if (this.isFull()) { throw new StackOverflowException(); }
		cc_hlpr_Stack.add(node); 
	}
	
	
	public Integer size(){
		if(cc_hlpr_Stack!=null){
		   return cc_hlpr_Stack.size();	
		}
		else
		   return 0;
	}
	
	public cc_hlpr_StackNode pop() { 
		if (this.isEmpty()) { throw new StackUnderflowException(); }
		return cc_hlpr_Stack.remove( lastItemIndex );
	}
	
	public cc_hlpr_StackNode peak() { 
		if (this.isEmpty()) { throw new StackUnderflowException(); }
		return cc_hlpr_Stack.get( lastItemIndex );
	}
	
	
	//==================================================
    // INNER EXCEPTION CLASSES
    //==================================================
	public with sharing class NullValueNotAllowedException extends Exception {}
	public with sharing class StackOverflowException extends Exception {}
	public with sharing class StackUnderflowException extends Exception {}
}