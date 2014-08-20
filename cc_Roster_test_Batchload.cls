@isTest(seeAllData=true)
private class cc_Roster_test_Batchload {
	
	@isTest static void test_method_one() {
		Test.startTest();
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

        List <CC_Rostering_Detail__c> rdList = new List<CC_Rostering_Detail__c>();
        CC_Rostering_Detail__c rd = new CC_Rostering_Detail__c();
        rd.CC_Rostering_Master__c = rm.Id;
        rd.First_Name__c = 'FirstName';
        rd.Last_Name__c = 'LastName';
        rd.Email__c = 'email@email121013.com';
        rd.Street_Address_Line_1__c = 'Address Line 1';
        rd.Street_Address_Line_2__c = 'Address Line 2';
        rd.City__c = 'Chicago';
        rd.State__c = 'IL';
        rd.Zipcode__c = '55555';
        rd.Country__c = 'USA';
        rd.Phone__c = '222-222-2222';
        rd.Class_Code__c = 'EYXX10000';
        rd.Program_Of_Interest__c = 'GRE';
        rd.Transaction_Code__c = '403';
        rd.Balance_Due__c = 10.0;
        rd.Start_Date__c = convertStringToDate('10/03/2013');
        rd.End_Date__c = convertStringToDate('10/03/2014');
        rd.Graduation_Year__c = 2014;
        rd.School_Id__c = '123456';
        rd.Channel__c = 20;
        rd.Lead_Source_ID__c = 400;
        rd.Center_Code__c = '579';
        //rd.Student_Id__c = 55555555;
        rd.Do_Not_Email__c = false;
        rd.Do_Not_Call__c = false;
        rd.Status__c = 'Loaded';
        rdList.add(rd);
        insert rdList;
        String status = 'Loaded';
        String query = 'select Id,  First_Name__c, Last_Name__c, Email__c, Street_Address_Line_1__c, Street_Address_Line_2__c, State__c, City__c, Zipcode__c, CC_Rostering_Master__c, Country__c, Phone__c, Program_Of_Interest__c, School_Id__c, Graduation_Year__c, Student_Id__c, Center_Code__c, Do_Not_Email__c, Do_Not_Call__c, Channel__c, Start_Date__c, End_Date__c, Class_Code__c, Transaction_Code__c, Balance_Due__c, Lead_Source_ID__c, Status__c, Notes__c from CC_Rostering_Detail__c where CC_Rostering_Master__c = \'' + rm.Id + '\' and Status__c = \''+status+'\'';
  		STring jobName = 'cc_Roster_Batchload';
  		cc_Roster_Preprocessor rosterPreProcessor = new cc_Roster_Preprocessor(query, rm.Name, rm.Id);

        cc_RosterScheduler rosterSchedule = new cc_RosterScheduler(query, newOpportunity.id, rm.Name, rm.Id, jobName);
        cc_RosterScheduler rosterSchedule1 = new cc_RosterScheduler(query, rm.Name, rm.Id);
        Datetime dt = Datetime.now().addSeconds(10);
        String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
        Id schedId = System.Schedule('cc_Roster_Batchload'+timeForScheduler,timeForScheduler,rosterSchedule);
        
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

		Account personAccount = new Account();
		personAccount.FirstName = 'FirstName';
    	personAccount.LastName = 'LastName';
    	personAccount.Email__c = 'email@email121013.com';
    	personAccount.PersonEmail = 'email@email121013.com';
    	personAccount.Kaptest_Username__c = 'email@email121013.com';
    	personAccount.E_AccountGroup__c = accountGroupId;
    	personAccount.RecordTypeId = personeRecordTypeId;
    	personAccount.Student_id_display__c = '123456';
		insert personAccount;        

        List <CC_Rostering_Detail__c> rdList = new List<CC_Rostering_Detail__c>();
        CC_Rostering_Detail__c rd = new CC_Rostering_Detail__c();
        rd.CC_Rostering_Master__c = rm.Id;
        rd.First_Name__c = 'FirstName';
        rd.Last_Name__c = 'LastName';
        rd.Email__c = 'email@email121013.com';
        rd.Street_Address_Line_1__c = 'Address Line 1';
        rd.Street_Address_Line_2__c = 'Address Line 2';
        rd.City__c = 'Chicago';
        rd.State__c = 'IL';
        rd.Zipcode__c = '55555';
        rd.Country__c = 'USA';
        rd.Phone__c = '222-222-2222';
        rd.Class_Code__c = 'EYXX10000';
        rd.Program_Of_Interest__c = 'GRE';
        rd.Transaction_Code__c = '403';
        rd.Balance_Due__c = 10.0;
        rd.Start_Date__c = convertStringToDate('10/03/2013');
        rd.End_Date__c = convertStringToDate('10/03/2014');
        rd.Graduation_Year__c = 2014;
        rd.School_Id__c = '123456';
        rd.Channel__c = 20;
        rd.Lead_Source_ID__c = 400;
        rd.Center_Code__c = '579';
        rd.Student_Id__c = 123456;
        rd.Do_Not_Email__c = false;
        rd.Do_Not_Call__c = false;
        rd.Status__c = 'Loaded';
        rdList.add(rd);
        insert rdList;
        String status = 'Loaded';
        String query = 'select Id,  First_Name__c, Last_Name__c, Email__c, Street_Address_Line_1__c, Street_Address_Line_2__c, State__c, City__c, Zipcode__c, CC_Rostering_Master__c, Country__c, Phone__c, Program_Of_Interest__c, School_Id__c, Graduation_Year__c, Student_Id__c, Center_Code__c, Do_Not_Email__c, Do_Not_Call__c, Channel__c, Start_Date__c, End_Date__c, Class_Code__c, Transaction_Code__c, Balance_Due__c, Lead_Source_ID__c, Status__c, Notes__c from CC_Rostering_Detail__c where CC_Rostering_Master__c = \'' + rm.Id + '\' and Status__c = \''+status+'\'';
  		STring jobName = 'cc_Roster_Batchload';
  		cc_Roster_Preprocessor rosterPreProcessor = new cc_Roster_Preprocessor(query, rm.Name, rm.Id);

        cc_RosterScheduler rosterSchedule = new cc_RosterScheduler(query, newOpportunity.id, rm.Name, rm.Id, jobName);
        cc_RosterScheduler rosterSchedule1 = new cc_RosterScheduler(query, rm.Name, rm.Id);
        Datetime dt = Datetime.now().addSeconds(10);
        String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
        Id schedId = System.Schedule('cc_Roster_Batchload'+timeForScheduler,timeForScheduler,rosterSchedule);
        
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