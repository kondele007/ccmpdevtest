public with sharing class cc_excn_ShippingAddressIsNullException extends Exception {
	 static testMethod void myUnitTest() {
	 	try {
	 		throw new cc_excn_ShippingAddressIsNullException('Test Exception');	 	
	 		system.assert(false);	
	 	} catch(Exception e) {}
	 }

}