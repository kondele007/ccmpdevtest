global class CybersourceScheduler implements Schedulable, Database.Batchable<SObject>, Database.Stateful
{
	global final String query;
	global String errors;

	private final String BATCH_JOB_TITLE = 'CyberSource Reparent Payments Batch ';

	global CybersourceScheduler()
	{
		this.errors = '';
		this.query = 'SELECT Id, Transaction_Reference_Number__c FROM CyberSource__c WHERE RecordType.DeveloperName = \'CS_Payment\' AND Transaction__c = NULL';
	}

	global database.querylocator start(Database.BatchableContext bc)
	{
		return Database.getQueryLocator( query );
	}

	global void execute(Database.BatchableContext bc, List<CyberSource__c> scope)
	{
		Map<String, Id> transactionReferenceToCybersourceId = new Map<String, Id>();
		for( CyberSource__c aPayment : scope )
		{
			transactionReferenceToCybersourceId.put( aPayment.Transaction_Reference_Number__c, null );
		}

		for( CyberSource__c aTransaction : [ SELECT Id, Transaction_Reference_Number__c FROM CyberSource__c
                                                WHERE RecordType.DeveloperName = 'CS_Transaction'
                                                AND Transaction_Reference_Number__c IN :transactionReferenceToCybersourceId.keySet() ] )
		{
			transactionReferenceToCybersourceId.put( aTransaction.Transaction_Reference_Number__c, aTransaction.Id );
		}

		for( CyberSource__c aPayment : scope )
		{
			aPayment.Transaction__c = transactionReferenceToCybersourceId.get( aPayment.Transaction_Reference_Number__c );
		}

		List<Database.SaveResult> updateResults = Database.update( scope, false );
		for( Database.SaveResult aResult : updateResults )
		{
			if( !aResult.isSuccess() )
			{
				for( Database.Error anError : aResult.getErrors() )
				{
					this.errors += '\n' + aResult.getId() + ':' + anError.getMessage();
				}
			}
		}
	}

	global void finish(Database.BatchableContext bc)
	{
		if( !String.isBlank( this.errors ) )
		{
			AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
								FROM AsyncApexJob
								WHERE Id = :bc.getJobId()];

			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

			mail.setToAddresses(new String[] {job.CreatedBy.Email});
			mail.setSaveAsActivity( false );
			mail.setSubject(BATCH_JOB_TITLE + job.Status);

			String emailBody = BATCH_JOB_TITLE + ' processed ' + job.TotalJobItems + ' batches with '+ job.NumberOfErrors + ' failures.';
			emailBody += '\n\n\nThe following errors occured:\n'+ errors;

			mail.setPlainTextBody(emailBody);
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		}
	}

	// calls two future methods
	global void execute(SchedulableContext sc)
	{
		CybersourceServices.calloutTransactionDetailReport();
		CybersourceServices.calloutPaymentBatchDetailReport();
        System.scheduleBatch( new CybersourceScheduler(), 'Payment Reparenting', 2 );
	}
}