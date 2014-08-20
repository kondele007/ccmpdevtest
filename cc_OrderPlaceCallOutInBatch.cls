global with sharing class cc_OrderPlaceCallOutInBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
	
	public String query;
	public String fileName;

	public cc_OrderPlaceCallOutInBatch(String q, String name) {
		query = q;
		fileName = name;

	}

	global Database.QueryLocator start(Database.BatchableContext BC){		    
   		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<CC_Rostering_Detail__c> scope){
		List<CC_Rostering_Detail__c> rdList = new List<CC_Rostering_Detail__c>();
		for(CC_Rostering_Detail__c rd : scope){
			cc_kap_impl_services.callKaplanStudentPlaceOrder(rd.Order_Id__c);
			System.debug(LoggingLevel.INFO,'execute -> order - ' + rd.Order_Id__c);
			rd.Order_Id__c = '';
			rdList.add(rd);
		}
		update rdList;

	}

	global void finish(Database.BatchableContext BC){

		AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
	  	TotalJobItems, CreatedBy.Email
	   	from AsyncApexJob where Id =:BC.getJobId()];

	  	// Send an email to the Apex job's submitter notifying of job completion.  
	  	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	  	String[] toAddresses = new String[] {a.CreatedBy.Email};
	  	mail.setToAddresses(toAddresses);
	  	mail.setSubject('Roster Job Status ' + a.Status);
	  	mail.setPlainTextBody('The batch Apex job processed loading file '+fileName+' with '+ a.TotalJobItems +
	    ' batches and '+ a.NumberOfErrors + ' failures.');

	  	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });	
	}

}