public with sharing class cc_excn_AccountGroupDuplicatedException extends cc_excn_AccountGroupException {
    
    public cc_excn_AccountGroupDuplicatedException(String accountGroupName, String msg) {
        super(accountGroupName, msg);
    }
    
   static testMethod void myUnitTest() {
     try {
       throw new cc_excn_AccountGroupDuplicatedException('Test Account Group', 'Test Account Group Duplicated Exception');   
       system.assert(false);    
     } catch(Exception e) {}
   }
}