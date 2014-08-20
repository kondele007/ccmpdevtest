//The purpose of this Apex Class is to support the CTIMultiMatch VF page.
//It recieves the ANI from Genesys via the CTI solution, calls a search and passes
//values back to VF page for presentation.  This class is only called when the CTI adapter
//has more than one matching result for an ANI.  


Public class KapSearchPageController {
    public List<Account> accounts {get; private set;}
 
    public KapSearchPageController() {
        String callerId = ApexPages.currentPage().getParameters().get('ANI');
        List<List<SObject>> searchList = [FIND :callerId IN PHONE FIELDS RETURNING Account(Id,Name,BillingCity,Phone,Phone_2__c,Phone_3__c,Student_ID_Display__c,PersonEmail,Enrollment_ID__c,Programs_of_Interest__c,Product_Purchase_History__c,Classcode_Purchase_History__c)];
 
        if (searchList!=null) {
            accounts = ((List<Account>)searchList[0]);
        }
    }
    
      
    Public static testmethod void kapsearchpagecontroller(){
        //instantiate a new controller with all parameters in the page
        ApexPages.currentPage().getParameters().put('ANI', 'Test');
        kapsearchpagecontroller controller = new kapsearchpagecontroller();      
    }
   
}