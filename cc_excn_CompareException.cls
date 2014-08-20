public class cc_excn_CompareException extends Exception {
	 static testMethod void myUnitTest() {
	 	try {
	 		throw new cc_excn_CompareException('Test Compare Exception');
	 		system.assert(false);	 		
	 	} catch(Exception e) {}
	 }
}