public with sharing class cc_ctrl_PriceList {
	//==================================================
	// INSTANCE PROPERTIES
	//==================================================
	public ApexPages.StandardController stndCtrl {get;set;}

	// variables
	public String addSubtract {get;set;}
	public String percentAbsolute{get;set;}
	public Decimal amount {get;set;}

	// picklists
	public List<Selectoption> addSubOptions {
		get {
			List<Selectoption> options = new List<Selectoption>();
			options.add(new Selectoption('-none-','-Select One-'));
			options.add(new Selectoption('add','Add'));
			options.add(new Selectoption('sub','Deduct'));
			return options;
		}
	}
	
	public List<Selectoption> percentAbsoluteOptions  {
		get {
			List<Selectoption> options = new List<Selectoption>();
			options.add(new Selectoption('-none-','-Select One-'));
			options.add(new Selectoption('absolute','Absolute'));
			options.add(new Selectoption('percent','Percent'));
			return options;
		}
	}
	
	//==================================================
    // CONSTRUCTOR
    //==================================================
	public cc_ctrl_PriceList(ApexPages.StandardController c) { this.stndCtrl = c; }
	
	//==================================================
    // HELPER METHODS
    //==================================================
	public boolean validateInput() {
		boolean valid = true;
		if (amount == null || amount <= 0 ) {
			Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,'Amount is required.'));
			valid = false;
		}
		if (this.addSubtract == '-none-') {
			Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,'Change Type is required.'));
			valid = false;
		}
		if (this.percentAbsolute == '-none-' ) {
			Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR,'Change Code is required.'));
			valid = false;
		}
		return valid;
	}
	
	//==================================================
    // SERVICE METHODS
    //==================================================
	public Pagereference applyChanges() {
		Pagereference pageRef= null;
		
		if (validateInput()) {
			Decimal changeAmount = 0;
			amount = amount.setScale(2);
			List<E_PriceListItem__c> itemsToUpdate = new List<E_PriceListItem__c>();	
			List<E_PriceListItem__c> items = [Select id,price__c from E_PriceListItem__c where Pricelist__c = :this.stndCtrl.getId() ];
			
			for (E_PriceListItem__c item:items) {
				if (item.price__c == null) { continue; }
				if (percentAbsolute == 'absolute') {
					changeAmount = amount;
				} else {
					changeAmount = item.price__c * amount / 100;
				}
				
				if (addSubtract == 'add') {
					item.Price__c = item.Price__c + changeAmount.setScale(2);
				} else {
					item.Price__c = item.Price__c - changeAmount.setScale(2);
				}
				
				itemsToUpdate.add(item);
			}
			
			if (!itemsToUpdate.isEmpty()) {
				try {
					update itemsToUpdate;
					amount = null;
					addSubtract = null;
					percentAbsolute = null;
					Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.Info,'Price List Item have been Updated, Please Refresh Your Page to View Updated Prices.'));
				} catch(DMLException e) {
					//System.debug('Exception saving pricelist items ->' +e);
					Apexpages.addMessage(new Apexpages.Message(Apexpages.Severity.Error,e.getMessage()));
				}
			}
		}
		return pageRef;
	}
	
	public Pagereference cancelChanges() {
		Pagereference pageRef = Apexpages.currentPage();
		pageRef.setRedirect(true);
		return pageRef;
	}
	
	static testMethod void myUnitTest() {
		E_PriceListItem__c priceListItem = new E_PriceListItem__c();
		ApexPages.StandardController stdCtrl = new ApexPages.StandardController(priceListItem);
		cc_ctrl_PriceList ctrl = new cc_ctrl_PriceList(stdCtrl);
		
		System.assert(ctrl.addSubOptions.size() > 0);
		System.assert(ctrl.percentAbsoluteOptions.size() > 0);
		
		ctrl.amount = null;
		ctrl.addSubtract = null;
		ctrl.percentAbsolute = null;
		System.assert(!ctrl.validateInput());
		
		ctrl.amount = 10;
		ctrl.addSubtract = null;
		ctrl.percentAbsolute = null;
		System.assert(ctrl.validateInput());
		
		ctrl.amount = 10;
		ctrl.addSubtract = '-none-';
		ctrl.percentAbsolute = null;
		System.assert(!ctrl.validateInput());
		
		ctrl.amount = 10;
		ctrl.addSubtract = null;
		ctrl.percentAbsolute = '-none-';
		System.assert(!ctrl.validateInput());
		
		
		ctrl.amount = 10;
		ctrl.addSubtract = null;
		ctrl.percentAbsolute = null;
		System.assert(ctrl.applyChanges() == null);
		
		System.assert(ctrl.cancelChanges() != null);
	}
}