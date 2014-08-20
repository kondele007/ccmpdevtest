/*     Class            : UpdateDeliverableOwnershipController
       Description      : Used in updating deliverable ownership
       Developed by     : Acumen Solutions, Rajesh Potluri
       Version History  : 1.0
       Creation         : 03/23/09
       */
public class UpdateDeliverableOwnershipController {

    private Implementation__c impl;
    public  String delvOwnerId;
    public String implOwner;

    /*
        Constructor that initializes implementation object
    */
    public UpdateDeliverableOwnershipController(ApexPages.StandardController stdController) {
        impl = (Implementation__c)stdController.getRecord();

    }

    /*
    This method updates ownership of deliverable objects with the owner of Implementation
    */
    public PageReference updateDeliverableOwnership() {
         try {

              Implementation__c implDetailObj = [Select OwnerId from Implementation__c where Implementation__c.id = :impl.id];
              Deliverables__c[] DeliverableObjs  = [Select Id, OwnerId From Deliverables__c where Implementation__c = :impl.id];

              if(DeliverableObjs != null && DeliverableObjs.size() > 0){


                for(Deliverables__c dl : DeliverableObjs) {

                System.debug('Implementation Owner Id...'+impl.id);

                 dl.OwnerId = implDetailObj.OwnerId;
                 delvOwnerId = dl.OwnerId;
                 implOwner = implDetailObj.OwnerId;


                }

                update DeliverableObjs;
              }

       } catch(exception e) {
                 ApexPages.addMessages(e);
        }
          return new PageReference('/'+impl.Id);
    }

    /*
    This method tests if implementation id is equal to deliverables Id
    */
    public static testMethod void TestUpdateDeliverableOwnershipController() {

        Implementation__c[] implObj = KapTestUtil.createImplementations( 1, true );

        PageReference pageRef = Page.UpdateDeliverableOwnership;
            Test.setCurrentPageReference(pageRef);

        UpdateDeliverableOwnershipController testController = new UpdateDeliverableOwnershipController(new ApexPages.StandardController(ImplObj[0]));
        testController.updateDeliverableOwnership();
        System.assertEquals(testController.implOwner, testController.delvOwnerId);


    }


}