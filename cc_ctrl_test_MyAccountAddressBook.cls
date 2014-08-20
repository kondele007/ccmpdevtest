/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class cc_ctrl_test_MyAccountAddressBook {
	static void setupAddressBook(Id accountId) {
		
		E_ContactAddr__c addr1 = new E_ContactAddr__c(
				ContactAddrId__c = 'myTestShipTo',
				DaytimePhone__c='(847) 555-1212',
				FirstName__c='Craig', LastName__c='Traxler',
				HomePhone__c='(847) 555-1212',
				AddressFirstline__c='100 Pine Street',
				City__c='SmallTown',
				PostalCode__c='60601',
				State__c='Idaho',
				StateISOCode__c='ID',
				CountryISOCode__c='US'
			);
		E_ContactAddr__c addr2 =  new E_ContactAddr__c(
				ContactAddrId__c = 'myTestBillTo',
				DaytimePhone__c='(847) 555-1212',
				FirstName__c='Craig', LastName__c='Traxler',
				HomePhone__c='(847) 555-1212',
				AddressFirstline__c='100 Pine Street',
				City__c='SmallTown',
				PostalCode__c='60601',
				State__c='Idaho',
				StateISOCode__c='ID',
				CountryISOCode__c='US'
			);
		insert addr1;
		insert addr2;
		System.debug('ah setupAddressBook userinfo.getuserid ' + userInfo.getuserid());
		cc_api_addressBook.createAddressBookEntries(accountId, addr1.id, addr2.id, userInfo.getUserId());  
	}
	static testMethod void myUnitTest() {
		cc_test_TestDataSetup.LoadData();
		
		System.runas(KapTestUtil.ADMIN_USER) {
			System.debug('ah sys.runas ' + userInfo.getUserId());
			Id accountId = cc_util_CloudCraze.getAccountID(cc_test_TestDataSetup.testUser);
			System.debug('--- cc_ctrl_test_MyAccountAddressBook.myUnitTest: accountId=' + accountId);
			cc_ctrl_test_MyAccountAddressBook.setupAddressBook(accountId);
			
			cc_ctrl_MyAccountAddressBook adb = new cc_ctrl_MyAccountAddressBook();
			
			List<E_AddressBook__c> adbs= cc_dao_addressBook.getAddressBooksForAccount(accountId);
			
			system.assertEquals(false, adbs.isEmpty());
	   
			adb.abid = adbs[0].id;
			List<SelectOption> addrTypeOptions = adb.addressTypeOptions;
			List<SelectOption> defaultAddrTypeOptions = adb.defaultAddressTypeOptions;
			system.assert(adb.getStateOptions().size() != 0);
			system.assert(adb.getStateOptionsCanada().size() != 0);
			system.assert(adb.getCountries().size() != 0);
			system.assert(adb.getAddressBookController() != null);
			
			System.runas(cc_test_TestDataSetup.testUser) {
			system.assert(adb.getAddressBooksForCurrentUser() != null);

			system.assert(adb.saveAddress() == null);
			system.assert(adb.editAddress() == null);
			system.assert(adb.deleteAddress() == null);
			system.assert(adb.getSelectedAddressTypes() != null);
			//setSelectedAddressTypes();
			system.assert(adb.getSelectedDefaultAddressTypes() != null);
			//setSelectedDefaultAddressTypes();
		  	system.assert(adb.resetAddressBookBean() == null);
		  }
		}
		
	}
}