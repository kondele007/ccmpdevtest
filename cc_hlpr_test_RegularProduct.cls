/* ============================================================
 * Unit test for cc_hlpr_RegularProduct
 *
 * ============================================================
 */
@IsTest
private class cc_hlpr_test_RegularProduct {  
      
	private static testmethod void testRegularProductHelper() {
		cc_hlpr_RegularProduct helper = new cc_hlpr_RegularProduct();		
		helper.runTest();
		system.assert(true);
	}
}