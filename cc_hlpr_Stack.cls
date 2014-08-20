//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public with sharing class cc_hlpr_Stack {
	//==================================================
    // CONSTANTS
    //==================================================
	public static final Integer MAX_STACK_DEPTH = 1000;
	//==================================================
    // INSTANCE VARIABLES
    //==================================================
	private List<String> cc_hlpr_Stack;
	//==================================================
    // INSTANCE PROPERTIES
    //==================================================
	// Helper property
	private Integer lastItemIndex {
		get { return cc_hlpr_Stack.size() - 1; }
	}
	//==================================================
    // CONSTRUCTOR
    //==================================================
	public cc_hlpr_Stack(){
		cc_hlpr_Stack = new List<String>();
	}
	//==================================================
    // SERVICE METHODS
    //==================================================
	public void push(String s){ 
		if (s == null) { throw new NullValueNotAllowedException(); }
		if (this.isFull()) { throw new StackOverflowException(); }
		cc_hlpr_Stack.add(s); 
	}
	
	public Integer size(){
		if(cc_hlpr_Stack!=null){
		   return cc_hlpr_Stack.size();	
		}
		else
		   return 0;
	}
	
	public String pop() { 
		if (this.isEmpty()) { throw new StackUnderflowException(); }
		return cc_hlpr_Stack.remove( lastItemIndex );
	}
	
	public String peak() { 
		if (this.isEmpty()) { throw new StackUnderflowException(); }
		return cc_hlpr_Stack.get( lastItemIndex );
	}
	
	public Boolean isEmpty() { return cc_hlpr_Stack.isEmpty(); }
	public Boolean isFull() { return MAX_STACK_DEPTH == cc_hlpr_Stack.size(); }
	
	
	
	public with sharing class NullValueNotAllowedException extends Exception {}
	public with sharing class StackOverflowException extends Exception {}
	public with sharing class StackUnderflowException extends Exception {}
}