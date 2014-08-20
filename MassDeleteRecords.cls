global class MassDeleteRecords implements  Database.Batchable<sObject> {

global final string query;

global MassDeleteRecords (String q)
{
   query = q;
}

global Database.QueryLocator start(Database.BatchableContext BC){

   return Database.getQueryLocator(query);
}

global void execute(Database.BatchableContext BC, List<sObject> scope){

  delete scope;
}


global void finish(Database.BatchableContext BC){
}

}