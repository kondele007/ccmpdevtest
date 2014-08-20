public with sharing class cc_excn_AccountGroupNotFoundException extends cc_excn_AccountGroupException {
    
    public cc_excn_AccountGroupNotFoundException(String accountGroupName, String msg) {
        super(accountGroupName, msg);
    }
    
   static testMethod void myUnitTest() {
     try {
       throw new cc_excn_AccountGroupNotFoundException('Test Account Group', 'Test Account Group Not Found Exception');   
       system.assert(false);    
     } catch(Exception e) {}
   }
}