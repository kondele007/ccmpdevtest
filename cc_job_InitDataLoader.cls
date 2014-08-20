global with sharing class cc_job_InitDataLoader implements Database.Batchable<Sobject>{
	//==================================================
    // INSTANCE VARIABLES
    //==================================================
	global final List<Sobject> objs;
	
	//==================================================
    // CONSTRUCTOR
    //==================================================
	global cc_job_InitDataLoader(List<Sobject> os){
		objs = os;
	}
	//==================================================
    // DERIVED METHODS
    //==================================================
	global Iterable<Sobject> start(Database.BatchableContext BC){
		return objs;
	}
	global void execute(Database.BatchableContext BC, List<Sobject> scope){
		insert scope;
	}
	global void finish(Database.BatchableContext BC){
	}
}