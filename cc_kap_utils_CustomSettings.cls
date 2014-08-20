public with sharing class cc_kap_utils_CustomSettings {

	public static List<E_KaplanDeliveryTypes__c> getDeliveryTypes(String locale) {
		List<E_KaplanDeliveryTypes__c> allDeliveryTypes = E_KaplanDeliveryTypes__c.getAll().values();
		List<E_KaplanDeliveryTypes__c> deliveryTypes = new List<E_KaplanDeliveryTypes__c>();
		for (E_KaplanDeliveryTypes__c deliveryType: allDeliveryTypes) {
			if (deliveryType.Locale__c == locale)
				deliveryTypes.add(deliveryType);
		}
		return deliveryTypes;
	}
		

}