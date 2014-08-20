public virtual with sharing class cc_ctrl_admin_Storefront {
	
	public String storefrontName {get;set;}
	
	public cc_ctrl_admin_Storefront() {}
	
	public List<SelectOption> getStorefrontOptionList() {
		List<SelectOption> selectOptions = new List<SelectOption>();

		Set<String> options = E_StorefrontSettings__c.getAll().keySet();
		for(String option : options) {
			selectOptions.add(new SelectOption(option, option));
		}

		return selectOptions;
	}
	static testMethod void myUnitTest() {
	 	cc_test_TestDataSetup.loadData();

		System.runAs(cc_test_TestDataSetup.testUser) {
			cc_ctrl_admin_Storefront admin = new cc_ctrl_admin_Storefront();
			system.assert(admin.getStorefrontOptionList() != null);
			
		}
	 }

}