public with sharing class cc_extn_PaymentShippingInfo_va extends cc_ExtensionBase_va {

	//==================================================
	// CONSTANTS
	//==================================================
	public static final String name = 'PaymentShippingInfo';
	
	//==================================================
	// INSTANCE PROPERTIES
	//==================================================
	public cc_ctrl_CheckOut_va checkOutController {get;set;}
	public cc_bean_Cart cartBean {get;set;}

	public cc_hlpr_CreditCard creditCardInfo{get;set;}
	public String defaultPaymentMethod {get;set;}

	public List<SelectOption> stateListUS {
		get {
			if(stateListUS == null) {
				stateListUS = cc_util_Picklist.getStateOptionsList('US');
			}
			return stateListUS;
		}
		set;
	}

	public String paymentTypeCCDisplayClass {
		get {
			if('cc'.equalsIgnoreCase(cartBean.paymentMethod) || (cartBean.paymentMethod == null && 'cc'.equalsIgnoreCase(defaultPaymentMethod))) {
				paymentTypeCCDisplayClass = 'show';
			} else {
				paymentTypeCCDisplayClass = 'hide';
			}
			return paymentTypeCCDisplayClass;
		}
		set;
	}

	public String paymentTypePODisplayClass {
		get {
			if('po'.equalsIgnoreCase(cartBean.paymentMethod) || (cartBean.paymentMethod == null && 'po'.equalsIgnoreCase(defaultPaymentMethod))) {
				paymentTypePODisplayClass = 'show';
			} else {
				paymentTypePODisplayClass = 'hide';
			}
			return paymentTypePODisplayClass;
		}
		set;
	}

	public String paymentTypeInstallmentsDisplayClass {
		get {
			if('installments'.equalsIgnoreCase(cartBean.paymentMethod) || (cartBean.paymentMethod == null && 'installments'.equalsIgnoreCase(defaultPaymentMethod))) {
				paymentTypeInstallmentsDisplayClass = 'show';
			} else {
				paymentTypeInstallmentsDisplayClass = 'hide';
			}
			return paymentTypeInstallmentsDisplayClass;
		}
		set;
	}

	//==================================================
	// SHIPPING PROPERTIES
	//==================================================
	public String selectedShipOption {get;set;}
	
	public Map<String, cc_ctrl_hlpr_ShippingOption> shipOptionsMap {
		get {
			if(shipOptionsMap == null) {
				shipOptionsMap = new Map<String, cc_ctrl_hlpr_ShippingOption>();

				for(cc_ctrl_hlpr_ShippingOption so : shipOptionsList) {
					shipOptionsMap.put(so.uid, so);
				}
			}
			return shipOptionsMap;
		}
		set;
	}

	public List<cc_ctrl_hlpr_ShippingOption> shipOptionsList {
		get {
			if(shipOptionsList == null) {
				shipOptionsList = new List<cc_ctrl_hlpr_ShippingOption>();

				if(cartBean.shipToAddress != null) {
					cc_api_ShippingAndHandling shipApi = new cc_api_ShippingAndHandling();
					shipOptionsList.addAll(shipApi.getShippingOptions(cartBean.shipToAddress.PostalCode, cartBean.shipToAddress.StateCode, 
						cartBean.shipToAddress.CountryCode, cartBean.sfid, parentController.store));
				}
			}
				
			System.debug(LoggingLevel.INFO, 'cc_extn_PaymentShippingInfo_va.getShipOptionsList: returning shipOptionsList=' + shipOptionsList);
	        return shipOptionsList;
		}
		set;
    }

    public List<SelectOption> shippingOptionItems {
    	get {
	    	if(shippingOptionItems == null) {
	            shippingOptionItems = new List<SelectOption>();
	            List<cc_ctrl_hlpr_ShippingOption> shipping = shipOptionsList;
	            System.debug('ryl--getShippingOptionItems-->' + shipping);
	            if(shipOptionsList != null) {
	                for(cc_ctrl_hlpr_ShippingOption opt:shipping) {
	                    shippingOptionItems.add(new SelectOption(opt.uid, opt.uid));
	                }
	            }
	        }

			System.debug(LoggingLevel.INFO, 'cc_extn_PaymentShippingInfo_va.getShippingOptionItems: returning shippingOptionItems=' + shippingOptionItems);
        	return shippingOptionItems;
    	}
    	set;
    }

	//==================================================
	// CONSTRUCTORS
	//==================================================
	public cc_extn_PaymentShippingInfo_va(cc_ctrl_CloudCraze_va c) {
		super(c);
		
		// add references to parent
		checkOutController = (cc_ctrl_CheckOut_va) parentController;
		cartBean = checkOutController.cartBean;
		defaultPaymentMethod = 'po';
	}

	//==================================================
	// OVERRIDE METHODS
	//==================================================
	public override string getName() {
		return name;
	}

	public override PageReference gotoStep() {
		return checkOutController.gotoStep(cc_extn_PaymentShippingInfo_va.name);
	}

	//==================================================
	// HELPER METHODS
	//==================================================
	public cc_extn_PaymentShippingInfo_va getPaymentShippingInfo() { return this; }

	//==================================================
	// SHIPPING HELPER METHODS
	//==================================================
	/* NOT USED FOR OOTB
    public cc_ctrl_hlpr_ShippingOption getSelectedShipmentOption() {
    	// example shippingMethod = 'UPS - Ground (4 to 6 days) $7.99';
    	System.debug('--- cc_extn_PaymentShippingInfo_va.getSelectedShipmentOption: shippingMethod=' + cartBean.shippingMethod);
        for(cc_ctrl_hlpr_ShippingOption opt:shipping){    
        	System.debug('ah inside for loop');
        	System.debug('ah opt.provider ' + opt.provider + '=' + selOptionPair[0]);
        	System.debug('ah opt.serviceName ' + opt.serviceName + '=' + selOptionPair[1]);    
        	
            if(opt.provider.equals(selOptionPair[0]) && opt.serviceName.equals(selOptionPair[1])){
                return opt;
            }
            
        }
        return null; 
    }

	public Decimal getSelectedShipmentPrice() {
		Decimal shipPrice = 0.0;
        List<cc_ctrl_hlpr_ShippingOption> shipping= this.getShipOptionsList();
        List<String> selOptionPair=al.StringUtils.split(this.selectedShippingOption,'-');
        System.debug('rryyll->' + selectedShippingOption);
        if(selOptionPair!=null && selOptionPair.size()==2 && shipping!=null){
            for(cc_ctrl_hlpr_ShippingOption opt:shipping){       
                if(opt.provider.equals(selOptionPair[0]) && opt.serviceName.equals(selOptionPair[1])){
                	selectedShippingOptionObj = opt;
                    shipPrice = opt.price;
                }
            }
        }
        return shipPrice;
    }
    
	public String getSelectedShipmentValue() {
        return String.valueOf( this.getSelectedShipmentPrice().setScale(2));
   	}
    
    public Boolean getDisplayShippingRegion(){
       this.getShippingOptionItems();
       if(this.l_shippingOptionItems!=null && 
          this.l_shippingOptionItems.size()>0){
             return true;
          } else {
             return false;
          }
    } 
    
   public PageReference shippingPrice(){
        parentController.messages.clear();
        return null;
    }
    */
   
	//==================================================
	// PAYMENT HELPER METHODS
	//==================================================
	public List<SelectOption> getPaymentTypes() { 
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('po', Label.CheckOut_PurchaseOrderNumber));
        options.add(new SelectOption('cc', Label.CheckOut_CreditCard));
        options.add(new SelectOption('installments', 'Installment Payments'));
        
        return options; 
    }

	//==================================================
	// SERVICE METHODS
	//==================================================
	public PageReference savePayment() {
		parentController.messages.clear();

		System.debug(LoggingLevel.INFO, '--- cc_extn_PaymentShippingInfo_va.savePayment: cartBean.paymentMethod=' + cartBean.paymentMethod);
		System.debug(LoggingLevel.INFO, '--- cc_extn_PaymentShippingInfo_va.savePayment: cartBean.poNumber=' + cartBean.poNumber);
		
		if(selectedShipOption != null) {
			cc_ctrl_hlpr_ShippingOption soBean = shipOptionsMap.get(selectedShipOption);
			if(soBean != null) {
				cartBean.shippingMethod = soBean.uid;
				cartBean.shipAmount = soBean.price;
				
				update cartBean.shipToAddress.dataObject;
			}
		} else {
			cartBean.shippingMethod = Label.NA;
		}

		E_Cart__c cart = cartBean.dataObject;
		System.debug(LoggingLevel.INFO, '--- cc_extn_PaymentShippingInfo_va.savePayment: cart=' + cart);
		update cart;

		return checkOutController.nextStep(cc_extn_PaymentShippingInfo_va.name);
	}
}