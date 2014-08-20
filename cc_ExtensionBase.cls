public abstract class cc_ExtensionBase {
	public static final String Query_CartId = 'CartId';
	public static final String Query_ProductIdId = 'ProductId';
	public static final String Query_BillingAddress = 'Billing';
	public static final String Query_ShippingAddress = 'Shipping';
	public cc_ctrl_CloudCraze parentController { get; set; }
	public cc_ExtensionBase() {}
	public abstract string getName();
	public virtual void notify(Object subject) {
		
	}
	public virtual void notify(Object subject, String notificationType, Object notificationValue) {
		
	}
	public cc_ExtensionBase(cc_ctrl_CloudCraze parentCtrl) {
		this();
		parentController = parentCtrl;
		if(getName() != null) {
			parentController.addExtension(getName(), this);
		}
	}
	
	public virtual Object query(Object subject, String q) {
		return null;
	}
	
	public virtual PageReference gotoStep() {
		return null;
	}
}