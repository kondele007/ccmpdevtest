/**
 *  @author serge kandukuri
 */
@isTest
private class KapCloseCaseControllerTest {
	
	public static testMethod void testPostitive_OnlineExtensions() {
    	// Add 'Test Account' to Account table
    	Account testAccount = KapTestUtil.createTestAccount();
    	// Add 'Test Enrollment' to Enrollment table
    	Enrollment__c testEnrollment = KapTestUtil.createTestEnrollment(testAccount);
    	// Add 'Test Case' to Case table for parent 'testAccount'
    	Case testAccountCase = KapTestUtil.createTestAccountCase(testAccount,'New');
    	
    	testAccount.Kaptest_Username__c = 'test.user@kaptest.com';
    	update testAccount;
    	
    	testEnrollment.Expiration_Date__c = Date.valueof('2011-06-01');
    	update testEnrollment;
    	
    	testAccountCase.Enrollment__c = testEnrollment.Id;
    	testAccountCase.Type_Detail__c = KapConstants.KAP_TYPE_DETAIL_ONLINE_EXTENSION;
    	testAccountCase.Resolution_Type__c = KapConstants.KAP_RESOLUTION_TYPE_ONLINE_EXTENSION;
    	testAccountCase.Status ='Closed';
    //	testAccountCase.Online_Extension_Date__c = Date.valueOf('2011-06-14');
    //	update testAccountCase;
    	
    	test.startTest();
    	
    	ApexPages.Standardcontroller caseStandCont = new ApexPages.Standardcontroller(testAccountCase);
		KapCloseCaseController kapContObj = new KapCloseCaseController(caseStandCont);
		ApexPages.currentPage().getParameters().put('retURL', '');
		ApexPages.currentPage().getParameters().put('id', testAccountCase.Id);
		kapContObj.caseId = testAccountCase.Id;
		kapContObj.save();
		
		PageReference nextpage2= kapContObj.setOnlineExtension();
    	//jll
    	
		kapContObj = new KapCloseCaseController(caseStandCont);
		ApexPages.currentPage().getParameters().put('retURL', '');
		ApexPages.currentPage().getParameters().put('id', testAccountCase.Id);
		testAccountCase.Resolution_Type__c = 'Processed automatic extension 29 days or more';
		testAccountCase.Type_Detail__c = KapConstants.KAP_TYPE_DETAIL_RESET_PASSWORD;
		kapContObj.caseId = testAccountCase.Id;
		kapContObj.setOnlineExtension();
		kapContObj.save();
		
    	test.stopTest();
		
	}
	
	public static testMethod void testPostitive_PasswordReset() {
    	// Add 'Test Account' to Account table
    	Account testAccount = KapTestUtil.createTestAccount();
    	// Add 'Test Enrollment' to Enrollment table
    	Enrollment__c testEnrollment = KapTestUtil.createTestEnrollment(testAccount);
    	// Add 'Test Case' to Case table for parent 'testAccount'
    	Case testAccountCase = KapTestUtil.createTestAccountCase(testAccount,'New');
    	
    	testAccount.Kaptest_Username__c = 'test.user@kaptest.com';
    	update testAccount;
    	
    	testEnrollment.Expiration_Date__c = Date.valueof('2011-06-01');
    	update testEnrollment;
    	
    	testAccountCase.Enrollment__c = testEnrollment.Id;
    	testAccountCase.Type_Detail__c = KapConstants.KAP_TYPE_DETAIL_RESET_PASSWORD;
    	testAccountCase.Resolution_Type__c = KapConstants.KAP_RESOLUTION_TYPE_RESET_PASSWORD;
    	testAccountCase.Status ='Closed';
    	update testAccountCase;
    	
    	test.startTest();
    	
    	ApexPages.Standardcontroller caseStandCont = new ApexPages.Standardcontroller(testAccountCase);
		KapCloseCaseController kapContObj = new KapCloseCaseController(caseStandCont);
		ApexPages.currentPage().getParameters().put('retURL', '');
		ApexPages.currentPage().getParameters().put('id', testAccountCase.Id);
		kapContObj.caseId = testAccountCase.Id;
		kapContObj.save();
		
		PageReference nextpage = kapContObj.setKaplanPass();

		String enrollmentid =kapContObj.getPurchaseId();
		String password1=kapContObj.getStudentIdDisplay();
		String kaptestuserid=kapContObj.getKaptestUserId();
		String userid=kapContObj.getUserId();
   	
    	test.stopTest();
	}
                               
  public static testMethod void saveTest() {
		
    	Id RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Person Account' LIMIT 1].Id;

		Account acc = new Account(LastName='George-003', FirstName='Smith-008', Student_Id_Display__c='123', Kaptest_Username__c='test@test.com', RecordTypeId=RecordTypeId);
    	Test.startTest();
    	insert acc;
    	
    	//Case caseObj = [Select Id, AccountId from Case Limit 1];
     
    	Case caseObj = new Case(Subject='GK Test Case', Product_Line__c='Bar Review', 
    							Type_Detail__c = KapConstants.KAP_TYPE_DETAIL_RESET_PASSWORD, 
    							Resolution_Type__c = KapConstants.KAP_RESOLUTION_TYPE_RESET_PASSWORD,    							 
    							Status ='Closed', AccountId=acc.Id);
    	
    	insert caseObj;
    	system.debug('---------------------------------caseObj:'+caseObj.Id);
    	ApexPages.Standardcontroller caseStandCont = new ApexPages.Standardcontroller(caseObj);
		KapCloseCaseController kapContObj = new KapCloseCaseController(caseStandCont);
		ApexPages.currentPage().getParameters().put('retURL', '');
		ApexPages.currentPage().getParameters().put('id', caseObj.Id);
		kapContObj.caseId = caseObj.Id;
		kapContObj.save();
		
		Enrollment__c enrObj = new Enrollment__c(Enrollment_Type__c='product', Enrollment_Id__c='41258537',
		Account__c = acc.Id, Student_Id__c=41269861);
		enrObj.Expiration_Date__c = Date.valueof('2011-06-01');
		insert enrObj;
		
		caseObj.Type_Detail__c = KapConstants.KAP_TYPE_DETAIL_ONLINE_EXTENSION;
		caseObj.Resolution_Type__c = KapConstants.KAP_RESOLUTION_TYPE_ONLINE_EXTENSION;
		caseObj.Enrollment__c = enrObj.Id;
		//caseobj.Online_Extension_Date__c = System.today();
		
		update caseObj;
		ApexPages.currentPage().getParameters().put('id', caseObj.Id);
		kapContObj.save();
		String enrollmentid =kapContObj.getPurchaseId();
		String password1=kapContObj.getStudentIdDisplay();
		String kaptestuserid=kapContObj.getKaptestUserId();
		String userid=kapContObj.getUserId();
		
		Boolean display123=kapContObj.display12;
		Integer test1=kapContObj.calloutStatus;
		
		System.debug('enrollment id'+enrollmentid);
		System.debug('password1'+password1);
		System.debug('kaptestuser id '+kaptestuserid);
		System.debug('userid'+userid);
		
		
		PageReference nextpage = kapContObj.setKaplanPass();
		PageReference nextpage2= kapContObj.setOnlineExtension();
		PageReference nextpage1= kapContObj.Cancel();
		
		KapXmlResponseWS xmlres = new KapXmlResponseWS();
		KaptestWS ktw = new KaptestWS();
		xmlres=ktw.setHardPasswordReset('test@test.com', 'test123');
		
		    KapCatalogWS kapcatalogws = new KapCatalogWS();
            KapXmlResponseWS kapxmlresponse = new KapXmlResponseWS();
          //  kapxmlresponse=kapcatalogws.setOnlineExtensions(enrollmentid, '05/29/1984');
            
            CaseComment casecomments = new CaseComment();
            
            casecomments.CommentBody='test';
            
            boolean display12=KapContObj.display12;
            
            boolean display21=KapContObj.display21;
            
            Account CaseAccount=KapContObj.caseAccount;
                               
	}
	/*
	
	  public String getPurchaseIdTest() {
                
        Case thisCase1;  
        String enrollid;  
        Id caseId = '500M0000000VMWk';
       // system.debug('caseId:'+caseId);
        thisCase1 = [Select c.Enrollment__r.Enrollment_Id__c From Case c WHERE Id = :caseId LIMIT 1];
        
        enrollId = thisCase1.Enrollment__r.Enrollment_Id__c;
        
        String enrollId2 = thisCase1.Enrollment__c;
        
        System.debug(enrollId);
        System.debug(enrollId2);
        return enrollId;
                
    
        }
	
    */
   
 
 
}