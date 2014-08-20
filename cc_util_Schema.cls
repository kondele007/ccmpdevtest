public with sharing class cc_util_Schema {
	
	public static Set<String> getAvailableSObjects() {
		return Schema.getGlobalDescribe().keySet();
	}
	
	public static Boolean isSObjectAvailable(String soName) {
		return isSObjectAvailable(new List<String> {soName});
	}
	
	public static Boolean isSObjectAvailable(List<String> soNames) {
		System.debug('--- cc_util_Schema.isSObjectAvailable: soNames=' + soNames);
		List<String> lcNames = al.ArrayUtils.lowerCase(soNames);
		System.debug('--- cc_util_Schema.isSObjectAvailable: lcNames=' + lcNames);
		Set<String> sobjects = cc_util_Schema.getAvailableSObjects();
		System.debug('--- cc_util_Schema.isSObjectAvailable: sobjects=' + sobjects);
		return sobjects.containsAll(lcNames);
	}
	
	public static SObject newSObject(String soName) {
		SObject newSObject = null;
		if(soName != null) {
			Schema.SObjectType soType = Schema.getGlobalDescribe().get(soName);
			if(soType != null) {
				newSObject = soType.newSObject();
			}
		}
		return newSObject;
	}
	
	public static Boolean sObjectHasField(SObject so, String fieldName) {
		Boolean hasField = false;
		if(so != null && fieldName != null) {
			Schema.DescribeSObjectResult dr = so.getSObjectType().getDescribe();
			Map<String, Schema.SObjectField> fieldMap = dr.fields.getMap();
			hasField = fieldMap.containsKey(fieldName);
			System.debug('--- cc_util_Schema.sObjectHasField: fieldMap=' + fieldMap);
		}
		return hasField;
	}
	
	@isTest static void testSObjectsExist() {
		System.assertEquals(true, cc_util_Schema.isSObjectAvailable('Account'));
		System.assertEquals(true, cc_util_Schema.isSObjectAvailable(new List<String> {'Account','Contact'}));
	}

	@isTest static void testSObjectsDoNotExist() {
		System.assertEquals(false, cc_util_Schema.isSObjectAvailable('IDontExist'));
		System.assertEquals(false, cc_util_Schema.isSObjectAvailable(new List<String> {'Account','IDontExist'}));
	}
	
	@isTest static void testNewSObjectExists() {
		SObject contact = cc_util_Schema.newSObject('Contact');
		System.assertNotEquals(null, contact);
		System.assertNotEquals(true, cc_util_Schema.sObjectHasField(contact, 'Account'));
		System.assertEquals(false, cc_util_Schema.sObjectHasField(contact, 'IDontExist'));
	}

	@isTest static void testNewSObjectDoesNotExist() {
		System.assertEquals(null, cc_util_Schema.newSObject('IDontExist'));
	}
}