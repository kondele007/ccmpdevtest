public class cc_ctrl_promotionExtension {
	public cc_ctrl_promotion parentController { get; set; }
	public cc_ctrl_CloudCraze outerController { get; set; }
	public string locationType { get; set;}
	public list<cc_bean_promotion> getPromotions() {
		System.debug('----------getting promos----------');
		list<cc_bean_promotion> promotions;
		try {
			promotions = parentController.promoTypeMapList.get(locationType);
			System.debug('----------no exception----------' + locationType);
		} catch (Exception e) {
			System.debug('----------exception---------');
			promotions = new list<cc_bean_promotion>();
		}
		// return parentController.promoTypeMapList.get(locationType);
		return promotions;
    }
	public string getImageUri() {
		try {
			return parentController.promoTypeMap.get(locationType).imageUri;
		} catch (Exception e) {
			return null;
		}
	}
	public string getImageSource() {
		try {
			return parentController.promoTypeMap.get(locationType).imageSource;
		} catch (Exception e) {
			return null;
		}
	}
	public string getAltMsg() {
		try {
			return parentController.promoTypeMap.get(locationType).name;
		} catch(Exception e) {
			return null;
		}
	}
	public string getPageType() {
		try {
			return parentController.promoTypeMap.get(locationType).pageLocation;
		} catch (Exception e ) {
			return null;
		}
	}
	public cc_ctrl_promotionExtension() {
		parentController = null;
	}
}