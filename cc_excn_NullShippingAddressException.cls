public with sharing class cc_excn_NullShippingAddressException extends Exception {
	 static testMethod void myUnitTest() {
	 	try {
	 		throw new cc_excn_NullShippingAddressException('Test Exception');
	 		system.assert(false);	 		
	 	} catch(Exception e) {}
	 }

}