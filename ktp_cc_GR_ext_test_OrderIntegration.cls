@isTest(seeAllData=true)
private class ktp_cc_GR_ext_test_OrderIntegration {
	@isTest static void test_method_one() {
			Test.startTest();
			ktp_cc_GR_ext_OrderVOPopulator kapVOHelper = new ktp_cc_GR_ext_OrderVOPopulator('a2zM00000003UiDIAU');
			String xmlRequest;
			xmlRequest = KapGetRealUtil.createCloudCrazeOrderPlaceMessage(kapVOHelper.personVO);
			xmlRequest = xmlRequest.replaceAll('><','>\n<');
			System.debug(xmlRequest);
			System.assert(xmlRequest.contains('CCORDER-a2zM00000003UiDIAU'));
			Test.stopTest();
	}
}