public with sharing class cc_api_dl_spec extends cc_api_dl_productDataLoaderBase {
	public override SObject getNewSObject(){
		return new  E_Spec__c();
	}
	public override void deleteObject() {
		//delete [Select c.Id From E_Spec__c c LIMIT 2000];
	}
	public override String getDataFileName() {
		return 'spec.xml';
	}
	public override Map<String, Schema.SObjectField> getFieldMap() {
		return Schema.SObjectType.E_Spec__c.fields.getMap();
	}
	   
	public override String getTestString() {
		return '<document><row><SPECID__C>1</SPECID__C ><NAME>Clock Speed</NAME ><DESC__C></DESC__C ><DISPLAYNAME__C>Clock Speed</DISPLAYNAME__C ><LOCALE__C>en_US</LOCALE__C ><SEQUENCE__C></SEQUENCE__C ><SPECGROUP__C>Processor</SPECGROUP__C ><ISVISIBLEINCATALOG__C>TRUE</ISVISIBLEINCATALOG__C ></row></document>';
	}
}