@IsTest
private class cc_util_test_GlobalVariableTest {
    

    private static testmethod void testEnsureGlobalVariableExists_Null(){
        System.assertEquals(null,cc_util_GlobalVariableTest.ensureGlobalVariableExists(null));
        System.assertNotEquals(null,cc_util_GlobalVariableTest.ensureGlobalVariableExists(new Global_Variable__c()));
    }

    private static testmethod void testEnsureGlobalVariableExists_Insert(){
        Global_Variable__c record = new Global_Variable__c(
            name     = 'test 123'
            ,Value__c = 'xyz'
        );
        record = cc_util_GlobalVariableTest.ensureGlobalVariableExists(record);
        System.assertNotEquals(null,record);
        System.assertNotEquals(null,record.id);
        try{
            record = [    
               select id 
               from Global_Variable__c 
               where name = :'test 123' 
               limit 1 
            ];
        }catch(QueryException e){}
        System.assertNotEquals(null,record);
    }

    private static testmethod void testEnsureGlobalVariableExists_UpdateOther(){
        Global_Variable__c record = new Global_Variable__c(
            name     = 'test 123'
            ,Value__c = 'xyz'
        );
        insert record;
        record = cc_util_GlobalVariableTest.ensureGlobalVariableExists(record.clone(false));
        System.assertNotEquals(null,record);
        System.assertNotEquals(null,record.id);
        try{
            record = [    
               select id 
               from Global_Variable__c 
               where name = :'test 123' 
               limit 1 
            ];
        }catch(QueryException e){}
        System.assertNotEquals(null,record);
    }

    private static testmethod void testEnsureGlobalVariableExists_UpdateItself(){
        Global_Variable__c record = new Global_Variable__c(
            name     = 'test 123'
            ,Value__c = 'xyz'
        );
        insert record;
        record = cc_util_GlobalVariableTest.ensureGlobalVariableExists(record);
        System.assertNotEquals(null,record);
        System.assertNotEquals(null,record.id);
        try{
            record = [    
               select id 
               from Global_Variable__c 
               where name = :'test 123' 
               limit 1 
            ];
        }catch(QueryException e){}
        System.assertNotEquals(null,record);
    }

}