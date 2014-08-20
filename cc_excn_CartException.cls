public with sharing class cc_excn_CartException extends Exception {

	 static testMethod void myUnitTest() {
	 	try {
	 		throw new cc_excn_CartException('Test Cart Exception');	 
	 		system.assert(false);		
	 	} catch(Exception e) {}
	 }
}