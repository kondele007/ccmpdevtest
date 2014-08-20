public abstract class cc_ExtensionBase_va {
	public static final String Query_CartId = 'CartId';
	public static final String Query_ProductIdId = 'ProductId';
	public static final String Query_BillingAddress = 'Billing';
	public static final String Query_ShippingAddress = 'Shipping';
	public cc_ctrl_CloudCraze_va parentController { get; set; }
	public cc_ExtensionBase_va() {}
	public abstract string getName();
	public virtual void notify(Object subject) {
		
	}
	public virtual void notify(Object subject, String notificationType, Object notificationValue) {
		
	}

	public cc_ExtensionBase_va(cc_ctrl_CloudCraze_va parentCtrl) {
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