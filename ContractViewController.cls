public class ContractViewController{
   
   public Id AccntId{get; set;}
   
     public ContractViewController(){
     AccntId=ApexPages.currentPage().getParameters().get('AccountId');
     }
     
    public List<Contract__c> getAllcontracts() {
        return [SELECT Id, Name, Owner.name,Account_Contracts__c,Author__c,Auto_Renews__c,Business_Group__c,Contract_Manager__c,Contract_Manager_Email__c,Contract_Type__c,Contract_Value__c,Contract_Value_is_Variable__c,Contract_with_Government_Entity__c,Counter_party_Legal_Entity__c,Describe_the_content__c,Early_Termination__c,Effective_Early_Termination_Date__c FROM Contract__c where Account_Contracts__c=:AccntId];
    }
  
    public Account getAccount() {
   return [select id, name from Account where id = :ApexPages.currentPage().getParameters().get('AccountId')];
   }
    
}