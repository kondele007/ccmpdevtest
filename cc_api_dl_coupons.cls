public with sharing class cc_api_dl_coupons extends cc_api_dl_productDataLoaderBase {
	 
	public override SObject getNewSObject(){
		return new  E_Coupon__c();
	}
	
	public override void deleteObject() {
		//delete [Select c.Id From E_Coupon__c c where c.COUPONCODE__C in ('COUPONCODE__C') ];
	}
	public override String getDataFileName() {
		return 'coupon.xml';
	}
	public override Map<String, Schema.SObjectField> getFieldMap() {
		return Schema.SObjectType.E_Coupon__c.fields.getMap();
	}
	
	public override void postProcess(List<SObject> objs) {
		Set<String> couponCodesForDeletion = new Set<String>();
		List<E_Coupon__c> cats = new List<E_Coupon__c>();
		for(SObject so : objs) {
			E_Coupon__c newCoupon = new E_Coupon__c(StartDate__c=Date.today(), EndDate__c=Date.today().addDays(60));
			
			if(!al.StringUtils.isEmpty(String.valueOf(so.get('RULE__C')))) {
				E_Rule__c rule = new E_Rule__c(RULEID__C=String.valueOf(so.get('RULE__C')));
				newCoupon.rule__r = rule;
			}
			if(!al.StringUtils.isEmpty(String.valueOf(so.get('SOURCEPRODUCT__C')))) {
				E_Product__c sourceProd = new E_Product__c(PRODUCTID__C=String.valueOf(so.get('SOURCEPRODUCT__C')));
				newCoupon.SOURCEPRODUCT__R = sourceProd;
			}
			if(!al.StringUtils.isEmpty(String.valueOf(so.get('TARGETPRODUCT__C')))) {
				E_Product__c targetProd = new E_Product__c(PRODUCTID__C=String.valueOf(so.get('TARGETPRODUCT__C')));
				newCoupon.TARGETPRODUCT__R = targetProd;
			}
			if(!al.StringUtils.isEmpty(String.valueOf(so.get('TARGETSPEC__C')))) {
				E_Spec__c targetSpec = new E_Spec__c(SPECID__C=String.valueOf(so.get('TARGETSPEC__C')));
				newCoupon.TARGETSPEC__R = targetSpec;
			}
			if(!al.StringUtils.isEmpty(String.valueOf(so.get('SOURCESPEC__C')))) {
				E_Spec__c sourceSpec = new E_Spec__c(SPECID__C=String.valueOf(so.get('SOURCESPEC__C')));
				newCoupon.SOURCESPEC__R = sourceSpec;
			}
			SObject sn = (SObject) newCoupon;
			Map<String, Schema.SObjectField> fMap = getFieldMap();
			for(string name : fMap.keyset()) {
				if(!fMap.get(name).getDescribe().isCalculated() && fMap.get(name).getDescribe().getType() != Schema.DisplayType.Reference && fMap.get(name).getDescribe().isCustom() && so.get(name) != null) {
					sn.put(name, so.get(name));
				}
			}
			cats.add(newCoupon);
			
		}
		
		insert cats;
	}
	public override String getTestString() {
		return '<document><row><COUPONCODE__C>THINK4MONITOR</COUPONCODE__C ><COUPONNAME__C>THINK4MONITOR</COUPONNAME__C ><COUPONTYPE__C>Absolute</COUPONTYPE__C ><ENABLED__C>TRUE</ENABLED__C ><MAXUSE__C>9999</MAXUSE__C ><RULENAME__C>&lt;a href=&quot;/a10U0000000Gvtz&quot; target=&quot;_blank&quot;&gt;By one and get another 10% off&lt;/a&gt;</RULENAME__C ><RULETYPE__C>General</RULETYPE__C ><SOURCEPRODUCT__C>99991</SOURCEPRODUCT__C ><TARGETPRODUCT__C>99992</TARGETPRODUCT__C ><TOTALUSED__C>0</TOTALUSED__C ><COUPON_NOTES__C>Buy a HP ProLiant ML110 G7 and get a monitor at 10% discount</COUPON_NOTES__C ></row></document>';
	}
	
}