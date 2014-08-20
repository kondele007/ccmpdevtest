public with sharing class cc_api_dl_Categories extends cc_api_dl_productDataLoaderBase {
	public override SObject getNewSObject(){
		return new  E_Category__c();
	}
	public override void deleteObject() {
		delete [Select c.Id From E_Category__c c where c.CATEGORYID__C in ('0', '99999', '99998', '88888', '88887') ];
	}
	public override String getDataFileName() {
		return 'category.xml';
	}
	public override Map<String, Schema.SObjectField> getFieldMap() {
		return Schema.SObjectType.E_Category__c.fields.getMap();
	}
	public override void postProcess(List<SObject> objs) {
		List<E_Category__c> cats = new List<E_Category__c>();
		for(SObject so : objs) {
			cats.add(new E_Category__c(CATEGORYID__C=String.valueOf(so.get('CATEGORYID__C')), SEQUENCE__C=Double.valueOf(so.get('SEQUENCE__C')),
				SHORTDESC__C=String.valueOf(so.get('SHORTDESC__C')), LONGDESC__C=String.valueOf(so.get('LONGDESC__C')), name=String.valueOf(so.get('NAME'))) );
		}
		try{
			insert cats;
		}catch(Exception e){
			//means we have a duplicate
		}
		List<E_Category__c> parentChildren = new List<E_Category__c>();
		for(SObject so : objs) {
			String externalId = String.valueOf(so.get('PARENTCATEGORY__C'));
			if(externalId==null || externalId.trim().length() == 0) {
				
				continue;
			}
			E_Category__c parent = new E_Category__c(CategoryID__c=String.valueOf(so.get('PARENTCATEGORY__C')));
			
			parentChildren.add(new E_Category__c(CATEGORYID__C=String.valueOf(so.get('CATEGORYID__C')), PARENTCATEGORY__R=parent) );
		}
		upsert parentChildren CategoryID__c;
	}
	public override String getTestString() {
		return '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>' +
				'<Root xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' +
				'<row><NAME>Products</NAME ><CATEGORYID__C>0</CATEGORYID__C ><LONGDESC__C></LONGDESC__C ><PARENTCATEGORY__C></PARENTCATEGORY__C ><SEQUENCE__C>0</SEQUENCE__C ><SHORTDESC__C></SHORTDESC__C ></row><row><NAME>Managed Servers</NAME ><CATEGORYID__C>99999</CATEGORYID__C ><LONGDESC__C></LONGDESC__C ><PARENTCATEGORY__C>0</PARENTCATEGORY__C ><SEQUENCE__C>450</SEQUENCE__C ><SHORTDESC__C></SHORTDESC__C ></row><row><NAME>Services</NAME ><CATEGORYID__C>99998</CATEGORYID__C ><LONGDESC__C></LONGDESC__C ><PARENTCATEGORY__C>99999</PARENTCATEGORY__C ><SEQUENCE__C>200</SEQUENCE__C ><SHORTDESC__C>Managed Servers Services</SHORTDESC__C ></row><row><NAME>Hardware</NAME ><CATEGORYID__C>99997</CATEGORYID__C ><LONGDESC__C></LONGDESC__C ><PARENTCATEGORY__C>99999</PARENTCATEGORY__C ><SEQUENCE__C>300</SEQUENCE__C ><SHORTDESC__C>Managed Servers Hardware</SHORTDESC__C ></row>' +
				'<row><NAME>CloudCrazeTestCategory</NAME ><CATEGORYID__C>88888</CATEGORYID__C ><LONGDESC__C></LONGDESC__C ><PARENTCATEGORY__C>0</PARENTCATEGORY__C ><SEQUENCE__C>0</SEQUENCE__C ><SHORTDESC__C></SHORTDESC__C ></row><row><NAME>CloudCrazeTestSubCategory</NAME ><CATEGORYID__C>88887</CATEGORYID__C ><LONGDESC__C></LONGDESC__C ><PARENTCATEGORY__C>88888</PARENTCATEGORY__C ><SEQUENCE__C>450</SEQUENCE__C ><SHORTDESC__C></SHORTDESC__C ></row>' +  
				'</Root>';
	}
}