@isTest
public class ContractViewControllerTest{
 public static testMethod void testMyController() {
 ContractViewController cv= new ContractViewController();
 
 Account testAcct=new Account(Name='test1');
 insert testAcct;
 PageReference pageRef = Page.ContractView;
 pageRef.getParameters().put('AccountId', String.valueOf(testAcct.Id));
 Test.setCurrentPage(pageRef);
// cv.AccntId=testAcct.id;
 
 Test.startTest();
 List<Contract__c> ctList=cv.getAllcontracts();
 
 Account accnt=cv.getAccount();
 Test.stopTest();
 }

}