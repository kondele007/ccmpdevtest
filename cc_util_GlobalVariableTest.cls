public class cc_util_GlobalVariableTest {

    public static Global_Variable__c ensureGlobalVariableExists(Global_Variable__c record){
        if(record != null && !isBlank(record.name)){
	        Global_Variable__c queried = null;
	        try{
	            queried = [   
	                select id 
	                from Global_Variable__c 
	                where name = :record.name
	            ];
	        }catch(QueryException e){}
	        if(queried != null && queried.id != record.id){
	            delete queried;
	        }
	        if(record.id != null){
	            update record;
	        } else {
	            insert record;
	        }
        }
        return record;
    } 

    private static boolean isBlank(String str) {
        return str == null || str.trim() == null || str.trim().length() == 0;
    }


}