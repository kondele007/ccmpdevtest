public with sharing class cc_api_RequestForQuote {
	 
	public static cc_bean_RequestForQuote initRequestForQuoteForUser() {
		return cc_api_RequestForQuote.initRequestForQuoteForUser(null);
	}

	public static cc_bean_RequestForQuote initRequestForQuoteForUser(Id userId) {
		cc_bean_RequestForQuote rfq = new cc_bean_RequestForQuote();
		
		if(userId == null) return rfq;
		
		User userProfile = cc_api_User.getUserProfile(userId);
		
		if(userProfile == null) return rfq;
		
		rfq.populateContactInfo(userProfile.Contact);

		System.debug(LoggingLevel.INFO, '--- cc_api_RequestForQuote.initRequestForQuoteForUser: returning rfq=' + rfq);
		return rfq;
	}
	
	public static void handleRequestForQuoteInserts(List<E_RequestForQuote__c> rfqs) {
		List<SObject> leads = new List<SObject>();
		List<SObject> opptys = new List<SObject>();
		
		
		for(E_RequestForQuote__c rfqSObject : rfqs) {
			System.debug(LoggingLevel.INFO, '--- cc_api_RequestForQuote.handleRequestForQuoteInserts: rfqSObject=' + rfqSObject);
			cc_bean_RequestForQuote rfq = new cc_bean_RequestForQuote(rfqSObject);
			System.debug(LoggingLevel.INFO, '--- cc_api_RequestForQuote.handleRequestForQuoteInserts: rfq=' + rfq);

			if(rfq.accountId == null) {
				leads.add(rfq.getLead());
			} else {
				opptys.add(rfq.getOpportunity());
			}
			
		}
		
		if(leads.size() > 0) {
			try {
				System.debug(LoggingLevel.INFO, '--- cc_api_RequestForQuote.handleRequestForQuoteInserts: inserting leads=' + leads);
				insert leads;
				
			} catch(DmlException e) {
				System.debug(LoggingLevel.ERROR, '--- cc_api_RequestForQuote.handleRequestForQuoteInserts: unable to insert leads [' + leads + '] error=' + e.getMessage());
			}
		}

		if(opptys.size() > 0) {
			try {
				System.debug(LoggingLevel.INFO, '--- cc_api_RequestForQuote.handleRequestForQuoteInserts: inserting opptys=' + opptys);
				insert opptys;
				
			} catch(DmlException e) {
				System.debug(LoggingLevel.ERROR, '--- cc_api_RequestForQuote.handleRequestForQuoteInserts: unable to insert opptys [' + opptys + '] error=' + e.getMessage());
			}
		}
		
		
	}
}