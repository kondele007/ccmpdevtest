public class ClassCancellationFuture{
@Future(callout=true)
    public static void createCase(String Status,String code,String pid){
         Set<String> ClassList = new Set<String>();
        String Specvalue=Label.Specid;
         // Declare a List that can hold list of all classes that are modified
             //cc_hlpr_LoadProductSpecRealTime cc = new cc_hlpr_LoadProductSpecRealTime();
           List<E_Product__c> productList = [select id from e_product__c where id =: pid];
             Map<String,List<E_ProductSpecIndex__c>> result = cc_hlpr_LoadProductSpecRealTime.getRealTimeProductSpecIndices(productList);
            // loop over product id list
            if(result!=null){
            List<E_ProductSpecIndex__c> productspeclist = result.get(pid);  // product id
          for (E_ProductSpecIndex__c spec : productspeclist) {
              System.debug('Specvalue before the if loop::'+SpecValue);
              System.debug('Specvalue label before the if loop::'+spec.Spec__c);
              System.debug('Specvalue__c before the if loop::'+spec.SpecValue__C);
         if (spec.Spec__c == Specvalue && spec.SpecValue__c== '3') {// should be sbu id
          System.debug('sbu : ' + spec.SpecValue__c);
              //Check if the Product Status/Class Status is Cancelled and Also ensure the class code Exists..
             ClassList.add(Code);   
             //List is populated with ClassCodes..
              }
             }
            }
        
      
        
    List<Enrollment__c> EnrollmentListDb =[Select Id,Account__c,Account__r.PersonEmail,Account__r.Phone from Enrollment__c where Class_Code__c IN :ClassList];
  
    
   QueueSobject QS=[SELECT QueueId FROM QueueSobject WHERE SobjectType = 'CASE' AND Queue.Name = 'Class Cancellation Queue' Limit 1];

      List<Case> NewCaseList =new List<Case>();
     // Populate the List of Enrollments for all the Classes that exists...
        for(Enrollment__c Enrollcase:EnrollmentListDb){
        System.debug('The  Enrollments are:'+EnrollCase);
            Case caseCreation = new Case();
            caseCreation.AccountId=Enrollcase.Account__c;
            caseCreation.OwnerId=QS.QueueId;
            caseCreation.Enrollment__c=Enrollcase.Id;
            caseCreation.Caller_Type__c='Kaplan Employee';
            caseCreation.Product_Line__c='';
            caseCreation.Origin='Agent Initiated';
            caseCreation.Status='New';
            caseCreation.Subject='Class Cancelled';
            caseCreation.Type='Change of Plans';
            caseCreation.Description='';
            caseCreation.Type_Detail__c='Course cancellation (acct. mgr. only)';
            NewCaseList.add(caseCreation);
            
        }//End of For loop of Enrollment
        if(!NewCaseList.isEmpty()){
            //check if the cases are empty if not we should be able to create the Case.
            Database.SaveResult[] SaveResult=Database.Insert(NewCaseList,false);
            System.debug('The value in InsertcaseResult::'+SaveResult);
        }
       }
    }