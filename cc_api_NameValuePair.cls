public with sharing class cc_api_NameValuePair {
	public string name { get; set; }
	public string value { get; set; }
	public cc_api_NameValuePair(string n, string v) {
		name = n;
		value=v;
	}
	
	public class NameValueComparator implements cc_util_ObjectComparator {
		public Integer compare(Object object1, Object object2) {
			if(object1 == null || object2 == null) {
				throw new NameValuePairException();
			}
			cc_api_NameValuePair pair1 = (cc_api_NameValuePair) object1;
			cc_api_NameValuePair pair2 = (cc_api_NameValuePair) object2;
			integer diff = pair1.name.compareTo(pair2.name);
			if(diff == 0) {
				diff = pair1.value.compareTo(pair2.value);
			}
			return diff;
		}
	}
	
	public class PageSettingComparator implements cc_util_ObjectComparator {
		public Integer compare(Object object1, Object object2) {
			if(object1 == null || object2 == null) {
				throw new NameValuePairException();
			}
			cc_api_NameValuePair pair1 = (cc_api_NameValuePair) object1;
			cc_api_NameValuePair pair2 = (cc_api_NameValuePair) object2;
			
			Integer diff = 0;

			// Global comes first
			Boolean pair1IsGlobal = pair1.name.toLowerCase().startsWith('global.');
			Boolean pair2IsGlobal = pair2.name.toLowerCase().startsWith('global.');
			if(pair1IsGlobal && !pair2IsGlobal) diff = -1;
			if(!pair1IsGlobal && pair2IsGlobal) diff = 1;
			
			// Then All storefronts
			if(diff == 0) {
				Boolean pair1IsAllStores = pair1.name.toLowerCase().contains('.all.');
				Boolean pair2IsAllStores = pair2.name.toLowerCase().contains('.all.');
				if(pair1IsAllStores && !pair2IsAllStores) diff = -1;
				if(!pair1IsAllStores && pair2IsAllStores) diff = 1;
			}
			
			// Then by name
			if(diff == 0) {
				diff = pair1.name.compareTo(pair2.name);
			}

			// Then by value
			if(diff == 0 && pair1.value != null) {
				
				diff = pair1.value.compareTo(pair2.value);
			
			}
			return diff;
		}
	}
	
	
	public class NameValuePairException extends Exception {}
}