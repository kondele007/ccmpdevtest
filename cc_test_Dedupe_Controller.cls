@isTest(seeAllData=true)
private class cc_test_Dedupe_Controller {
String groupName = 'Anonymous';
	
	@isTest static void test_method_one() {
		Test.startTest();
		String personAccountName = 'Person Account';
		ID personeRecordTypeId = [SELECT Id FROM RecordType WHERE Name = :personAccountName LIMIT 1].Id;
		String groupName = 'Anonymous';
		ID accountGroupId = [Select ID from E_AccountGroup__c where Name = :groupName Limit 1].Id;

        Opportunity newOpportunity = new Opportunity();
        newOpportunity.Name = 'Test Opportunity ' + Math.random();
		newOpportunity.StageName = 'Prospecting';
		newOpportunity.CloseDate = Date.today();
		insert newOpportunity;

		E_Rostering_Master__c rm = new E_Rostering_Master__c();
        rm.Upload_Date__c = System.now();
        rm.Opportunity__c = newOpportunity.id;
        rm.Name = 'testfile.csv';               
        insert rm;
		PageReference pageRefTemp = System.Page.cc_Rostering;
        pageRefTemp.getParameters().put('id',rm.id);
        Test.setCurrentPage(pageRefTemp);

		
		Account personAccount = new Account();
		personAccount.FirstName = 'FirstName';
    	personAccount.LastName = 'LastName';
    	personAccount.Email__c = 'email@email.com';
    	personAccount.PersonEmail = 'email@email.com';
    	personAccount.Kaptest_Username__c = 'email@email.com';
    	personAccount.E_AccountGroup__c = accountGroupId;
    	personAccount.RecordTypeId = personeRecordTypeId;
		insert personAccount;

        List <CC_Rostering_Detail__c> rdList = new List<CC_Rostering_Detail__c>();
        CC_Rostering_Detail__c rd = new CC_Rostering_Detail__c();
        rd.CC_Rostering_Master__c = rm.Id;
        rd.First_Name__c = 'FirstName';
        rd.Last_Name__c = 'LastName';
        rd.Email__c = 'email@email.com';
        rd.Street_Address_Line_1__c = 'Address Line 1';
        rd.Street_Address_Line_2__c = 'Address Line 2';
        rd.City__c = 'Chicago';
        rd.State__c = 'IL';
        rd.Zipcode__c = '55555';
        rd.Country__c = 'USA';
        rd.Phone__c = '222-222-2222';
        rd.Class_Code__c = 'GMAT';
        rd.Program_Of_Interest__c = 'EYXX10000';
        rd.Transaction_Code__c = '403';
        rd.Balance_Due__c = 10.0;
        rd.Start_Date__c = convertStringToDate('10/03/2013');
        rd.End_Date__c = convertStringToDate('10/03/2014');
        rd.Graduation_Year__c = 2014;
        rd.School_Id__c = '123456';
        rd.Channel__c = 40;
        rd.Lead_Source_ID__c = 400;
        rd.Center_Code__c = '100';
        //rd.Student_Id__c = 55555555;
        rd.Do_Not_Email__c = false;
        rd.Do_Not_Call__c = false;
        rd.Status__c = 'Dedupe';
        //change
        rd.Notes__c = personAccount.id;
        rdList.add(rd);
        insert rdList;

        cc_Dedupe_Controller dedupeController = new cc_Dedupe_Controller();
        dedupeController.getRosterDetails();
        dedupeController.uploadRoster();

        Test.stopTest();
	}
	
	@isTest static void test_method_two() {
		Test.startTest();
		String personAccountName = 'Person Account';
		ID personeRecordTypeId = [SELECT Id FROM RecordType WHERE Name = :personAccountName LIMIT 1].Id;
		String groupName = 'Anonymous';
		ID accountGroupId = [Select ID from E_AccountGroup__c where Name = :groupName Limit 1].Id;

        Opportunity newOpportunity = new Opportunity();
        newOpportunity.Name = 'Test Opportunity ' + Math.random();
		newOpportunity.StageName = 'Prospecting';
		newOpportunity.CloseDate = Date.today();
		insert newOpportunity;

		E_Rostering_Master__c rm = new E_Rostering_Master__c();
        rm.Upload_Date__c = System.now();
        rm.Opportunity__c = newOpportunity.id;
        rm.Name = 'testfile.csv';               
        insert rm;
		PageReference pageRefTemp = System.Page.cc_Rostering;
        pageRefTemp.getParameters().put('id',rm.id);
        Test.setCurrentPage(pageRefTemp);

		
		Account personAccount = new Account();
		personAccount.FirstName = 'FirstName';
    	personAccount.LastName = 'LastName';
    	personAccount.Email__c = 'email@email.com';
    	personAccount.PersonEmail = 'email@email.com';
    	personAccount.Kaptest_Username__c = 'email@email.com';
    	personAccount.E_AccountGroup__c = accountGroupId;
    	personAccount.RecordTypeId = personeRecordTypeId;
		insert personAccount;

        List <CC_Rostering_Detail__c> rdList = new List<CC_Rostering_Detail__c>();
        CC_Rostering_Detail__c rd = new CC_Rostering_Detail__c();
        rd.CC_Rostering_Master__c = rm.Id;
        rd.First_Name__c = 'FirstName';
        rd.Last_Name__c = 'LastName';
        rd.Email__c = 'email@email.com';
        rd.Street_Address_Line_1__c = 'Address Line 1';
        rd.Street_Address_Line_2__c = 'Address Line 2';
        rd.City__c = 'Chicago';
        rd.State__c = 'IL';
        rd.Zipcode__c = '55555';
        rd.Country__c = 'USA';
        rd.Phone__c = '222-222-2222';
        rd.Class_Code__c = 'GMAT';
        rd.Program_Of_Interest__c = 'EYXX10000';
        rd.Transaction_Code__c = '403';
        rd.Balance_Due__c = 10.0;
        rd.Start_Date__c = convertStringToDate('10/03/2013');
        rd.End_Date__c = convertStringToDate('10/03/2014');
        rd.Graduation_Year__c = 2014;
        rd.School_Id__c = '123456';
        rd.Channel__c = 40;
        rd.Lead_Source_ID__c = 400;
        rd.Center_Code__c = '100';
        //rd.Student_Id__c = 55555555;
        rd.Do_Not_Email__c = false;
        rd.Do_Not_Call__c = false;
        rd.Status__c = 'DedupeCreate';
        //change
        rd.Notes__c = null;
        rdList.add(rd);
        insert rdList;

        cc_Dedupe_Controller dedupeController = new cc_Dedupe_Controller();
        dedupeController.uploadRoster();

        Test.stopTest();
	}

	public static Date convertStringToDate(String dt){
	    Date tempDate;
	    if(dt == '' || dt == null){
	        return null;
	    }
	    String[] tempStr = dt.split('/');
	    System.debug(LoggingLevel.INFO, '$$Roster tempStr=' + tempStr);
	    Integer d = Integer.valueOf(tempStr[1]);
	    Integer m = Integer.valueOf(tempStr[0]);
	    Integer y = Integer.valueOf(tempStr[2]);
	    try{
	        tempDate = Date.newInstance(y,m,d);
	        System.debug(LoggingLevel.INFO, '$$Roster tempDate1=' + tempDate);
	        //tempDate = Date.valueOf(y+'-'+m+'-'+d);
	        //System.debug(LoggingLevel.INFO, '$$Roster tempDate2=' + tempDate);
	    }catch(Exception e){
	        System.debug(LoggingLevel.INFO, '$$Roster convertStringToDate Exception=');

	    }
	    return tempDate;
    
    }

	
}