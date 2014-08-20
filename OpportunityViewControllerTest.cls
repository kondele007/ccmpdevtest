@isTest
public class OpportunityViewControllerTest{
 public static testMethod void testMyController() {
 OpportunityViewController ov= new OpportunityViewController();
 
 Account testAcct=new Account(Name='test1');
 insert testAcct;
 PageReference pageRef = Page.OpportunityView;
 pageRef.getParameters().put('AccountId', String.valueOf(testAcct.Id));
 Test.setCurrentPage(pageRef);
// cv.AccntId=testAcct.id;
 
 Test.startTest();
 List<Opportunity> opList=ov.getAllopportunities();
 
 Account accnt=ov.getAccount();
 Test.stopTest();
 }

}