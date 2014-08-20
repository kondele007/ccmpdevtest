global class ECFile implements Database.Batchable<sObject>,Database.AllowsCallouts{
   global final String Query;
   global ECFile(String q){
             Query=q;
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
     System.debug('The final query is'+query);
      return Database.getQueryLocator(query);
   }

   global void execute(Database.BatchableContext BC, 
                       List<sObject> scope){
      for(Sobject s : scope){
      cc_kap_impl_services.callKaplanStudentPlaceOrderGetRealOnly(s.id);
      }
   }

   global void finish(Database.BatchableContext BC){
     
     // Get the ID of the AsyncApexJob representing this batch job
   // from Database.BatchableContext.
   // Query the AsyncApexJob object to retrieve the current job's information.
   AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
      TotalJobItems, CreatedBy.Email
      FROM AsyncApexJob WHERE Id =
      :BC.getJobId()];
   // Send an email to the Apex job's submitter notifying of job completion.
   Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
   String[] toAddresses = new String[] {a.CreatedBy.Email};
   mail.setToAddresses(toAddresses);
   mail.setSubject('EC Error Records Process Job ' + a.Status);
   mail.setPlainTextBody
   ('The batch Apex job processed ' + a.TotalJobItems +
   ' batches with '+ a.NumberOfErrors + ' failures.');
   Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
   }

}