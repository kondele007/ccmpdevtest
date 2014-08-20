public class OpportunityViewController{
   
   public Id AccntId{get; set;}
   
     public OpportunityViewController(){
     AccntId=ApexPages.currentPage().getParameters().get('AccountId');
     }
     
    public List<Opportunity> getAllopportunities() {
        return [SELECT Id, Name,AccountId FROM Opportunity where AccountId=:AccntId];
    }
  
    public Account getAccount() {
   return [select id, name from Account where id = :ApexPages.currentPage().getParameters().get('AccountId')];
   }
    
}