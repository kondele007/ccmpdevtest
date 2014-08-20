public without sharing class cc_api_dl_accounts extends cc_api_dl_productDataLoaderBase {
	public override SObject getNewSObject(){
		return new  Account();
	}
	public override void deleteObject() {
		//delete [Select c.Id From Account c where c.name in ('PortalAccount', 'Anonymous')];
	}
	public override String getDataFileName() {
		return 'account.xml';
	}
	public override Map<String, Schema.SObjectField> getFieldMap() {
		return Schema.SObjectType.Account.fields.getMap();
	}
	public override void postProcess(List<SObject> objs) {
		list<String> names = new list<String> ();
		List<Account> cats = new List<Account>();
		set<string> aNameSet = new set<string>();
		for(SObject so : objs) {
			names.add(String.valueOf(so.get('NAME')));
		}
		for(account a: [select id, name from account where name in :names]) {
			aNameSet.add(a.name);
		}
		RecordType rt = [Select r.Name, r.Id From RecordType r where r.Name = 'Person Account' limit 1];
		for(SObject so : objs) {
			if(!aNameSet.contains(String.valueOf(so.get('NAME')))) {
				E_AccountGroup__c p = new E_AccountGroup__c(AccountGroupID__c=String.valueOf(so.get('E_ACCOUNTGROUP__C')));
				Account a = new Account(E_AccountGroup__c = p.Id, RecordTypeID = rt.Id);
				a.lastname = String.valueOf(so.get('LASTNAME'));
				cats.add(a);
			}	
		}
		
		insert cats;
		
	}
	
	public override String getTestString() {
		return '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
				'<Root xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
				'<Row>' +
				'<LASTNAME>PortalAccount</LASTNAME>' +
				'<E_AccountGroup__c>1</E_AccountGroup__c>' +
				'</Row>' +
				'<Row>' +
				'<LASTNAME>Anonymous</LASTNAME>' +
				'<E_AccountGroup__c>2</E_AccountGroup__c>' +
				'</Row>' +
				'</Root>';
	}
	
}