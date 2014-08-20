public with sharing class cc_bean_RequestForQuote {

    //==================================================
    // PROPERTIES
    //==================================================
    public Id sfid {get;set;}
	public String firstName {get;set;}
	public String lastName {get;set;}
	public String company {get;set;}
	public String email {get;set;}
	public String phone {get;set;}
	public String description {get;set;}
	public Id cartId {get;set;}
	public E_Cart__c cart {get;set;}
	public Id accountId {get;set;}
	public Id contactId {get;set;}
	public String storefront {get;set;}
	public String opportunityName {get;set;}
	public Decimal amount {get;set;}
	public Date closeDate {get;set;}
	public String stage {get;set;}
	public String leadSource {get;set;}
	public String leadStatus {get;set;}
	public String opportunityType {get;set;}
	public String nextStep {get;set;}
	public Boolean emailOptOut {get;set;}
	//public Id campaignId {get;set;}
	//public Campaign campaign {get;set;}
	public String website {get;set;}
	public E_RequestForQuote__c dataObject {
		get {
	        if(dataObject == null) { 
	            dataObject = new E_RequestForQuote__c();
	        }
	        dataObject.FirstName__c = firstName;
	        dataObject.LastName__c = lastName;
	        dataObject.Company__c = company;
	        dataObject.Email__c = email;
	        dataObject.Phone__c = phone;
	        dataObject.Description__c = description;
	        dataObject.Cart__c = cartId;
	        dataObject.Account__c = accountId;
	        dataObject.Contact__c = contactId;
	        dataObject.Storefront__c = storefront;
	        dataObject.OpportunityName__c = opportunityName;
	        dataObject.Amount__c = amount;
	        dataObject.CloseDate__c = closeDate;
	        dataObject.StageName__c = stage;
	        dataObject.LeadSource__c = leadSource;
	        dataObject.LeadStatus__c = leadStatus;
	        dataObject.OpportunityType__c = opportunityType;
	        dataObject.NextStep__c = nextStep;
	        //dataObject.HasOptedOutOfEmail__c = emailOptOut;
	        //dataObject.Campaign__c = campaignId;
	        dataObject.Website__c = website;
	        return dataObject;
		}
		set;
	}
	
    //==================================================
    // CONSTRUCTORS
    //==================================================
    public cc_bean_RequestForQuote() {}
    
    public cc_bean_RequestForQuote(E_RequestForQuote__c rfq) {
    	if(rfq != null) {
    		dataObject = rfq;
    		sfid = rfq.Id;
            try{firstName = rfq.FirstName__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{lastName = rfq.LastName__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{company = rfq.Company__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{email = rfq.Email__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{phone = rfq.Phone__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{description = rfq.Description__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{cartId = rfq.Cart__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{cart = rfq.Cart__r;}catch(SObjectException e){/*System.debug(e);*/}
            try{accountId = rfq.Account__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{contactId = rfq.Contact__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{storefront = rfq.Storefront__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{opportunityName = rfq.OpportunityName__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{amount = rfq.Amount__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{closeDate = rfq.CloseDate__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{stage = rfq.StageName__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{leadSource = rfq.LeadSource__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{leadStatus = rfq.LeadStatus__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{opportunityType = rfq.OpportunityType__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{nextStep = rfq.NextStep__c;}catch(SObjectException e){/*System.debug(e);*/}
            try{emailOptOut = rfq.HasOptedOutOfEmail__c;}catch(SObjectException e){/*System.debug(e);*/}
            //try{campaignId = rfq.Campaign__c;}catch(SObjectException e){/*System.debug(e);*/}
            //try{campaign = rfq.Campaign__r;}catch(SObjectException e){/*System.debug(e);*/}
            try{website = rfq.Website__c;}catch(SObjectException e){/*System.debug(e);*/}
    	}
    }
    
    public void populateContactInfo(Contact c) {
    	if(c != null) {
    		accountId = c.AccountId;
    		contactId = c.Id;
			firstName = c.FirstName;
			lastName = c.LastName;
			company = c.CompanyName__c;
			email = c.Email;
			phone = c.Phone;
    	}
    }
    
    public SObject getLead() {
    	SObject lead = cc_util_Schema.newSObject('Lead');
    	lead.put('FirstName', firstName);
    	lead.put('LastName', lastName);
    	lead.put('Email', email);
    	lead.put('Phone', phone);
    	lead.put('Company', company);
    	lead.put('LeadSource', leadSource);
    	lead.put('Status', leadStatus);
    	lead.put('Website', website);
    	lead.put('Description', description);
    	putCartField(lead);
    	return lead;
    }

    public SObject getOpportunity() {
    	SObject oppty = cc_util_Schema.newSObject('Opportunity');
    	oppty.put('AccountId', accountId);
    	oppty.put('Name', opportunityName);
    	oppty.put('Type', opportunityType);
    	oppty.put('LeadSource', leadSource);
    	oppty.put('StageName', stage);
    	oppty.put('NextStep', nextStep);
    	oppty.put('CloseDate', closeDate);
    	oppty.put('Description', description);
    	oppty.put('Amount', amount);
    	putCartField(oppty);
    	return oppty;
    }
    
    public void putCartField(SObject so) {
		if(cc_util_Schema.sObjectHasField(so, 'Cart__c')) {
			so.put('Cart__c', cartId);
		}
    }
}