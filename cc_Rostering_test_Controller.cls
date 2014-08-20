@isTest
private class cc_Rostering_test_Controller {
	//normal file test
	@isTest static void test_method_one() {
		Test.startTest();
        Opportunity newOpportunity = new Opportunity();
        newOpportunity.Name = 'Test Opportunity ' + Math.random();
		newOpportunity.StageName = 'Prospecting';
		newOpportunity.CloseDate = Date.today();
		insert newOpportunity;
		// Instantiate a new controller with all parameters in the page
        PageReference pageRefTemp = System.Page.cc_Rostering;
        pageRefTemp.getParameters().put('id',newOpportunity.id);
        Test.setCurrentPage(pageRefTemp);
		cc_Rostering_Controller rostercontroller = new cc_Rostering_Controller();
		rostercontroller.nameFile = 'testfile';
		rostercontroller.contentFile = Blob.valueOf('First Name,Last Name,Email,Street Address Line 1,Street Address Line 2,City,State,Zipcode,Country,Phone,Programs of Interest,Class Code,Transaction Code,Balance,Start Date,End Date,Graduation Year,School Id,Channel,Lead Source Id,Center Code,Student Id,Do Not Email,Do Not Call\rRoster,Test1221,rostertest1221@edlconsulting.com,2043 W Belmont Ave.,Apt 2,Chicago,IL,60618,USA,773-555-5555,GMAT,EYXX10000,403,10,10/3/2013,10/3/2014,2014,23456,20,100,579,12345,Y,Y');
		PageReference pageRef = rostercontroller.ReadFile();
		Test.stopTest();
	}
	//test for the roster file record  with less than 23 values
	@isTest static void test_method_two() {
		Test.startTest();
		// Instantiate a new controller with all parameters in the page
        Opportunity newOpportunity = new Opportunity();
        newOpportunity.Name = 'Test Opportunity ' + Math.random();
		newOpportunity.StageName = 'Prospecting';
		newOpportunity.CloseDate = Date.today();
		insert newOpportunity;

        PageReference pageRefTemp = System.Page.cc_Rostering;
        pageRefTemp.getParameters().put('id',newOpportunity.id);
        Test.setCurrentPage(pageRefTemp);
		cc_Rostering_Controller rostercontroller = new cc_Rostering_Controller();
		rostercontroller.nameFile = 'testfile';
		rostercontroller.contentFile = Blob.valueOf('First Name,Last Name,Email,Street Address Line 1,Street Address Line 2,City,State,Zipcode,Country,Phone,Programs of Interest,Class Code,Transaction Code,Balance,Start Date,End Date,Graduation Year,School Id,Channel,Lead Source Id,Center Code,Student Id,Do Not Email,Do Not Call\rRoster,Test1221,rostertest1221@edlconsulting.com,2043 W Belmont Ave.,Apt 2,Chicago,IL,60618,USA,773-555-5555,GMAT,EYXX10000,403,10,10/3/2013,10/3/2014,2014,23456,20,100');
		PageReference pageRef = rostercontroller.ReadFile();
		Test.stopTest();
	}

	//test when the roster file is null
	@isTest static void test_method_three() {
		Test.startTest();
		// Instantiate a new controller with all parameters in the page
        Opportunity newOpportunity = new Opportunity();
        newOpportunity.Name = 'Test Opportunity ' + Math.random();
		newOpportunity.StageName = 'Prospecting';
		newOpportunity.CloseDate = Date.today();
		insert newOpportunity;

        PageReference pageRefTemp = System.Page.cc_Rostering;
        pageRefTemp.getParameters().put('id',newOpportunity.id);
        Test.setCurrentPage(pageRefTemp);
		cc_Rostering_Controller rostercontroller = new cc_Rostering_Controller();
		rostercontroller.nameFile = 'testfile';
		rostercontroller.contentFile = null;
		PageReference pageRef = rostercontroller.ReadFile();
		Test.stopTest();
	}

	//Test when the name of the file is null
	@isTest static void test_method_four() {
		Test.startTest();
		// Instantiate a new controller with all parameters in the page
        Opportunity newOpportunity = new Opportunity();
        newOpportunity.Name = 'Test Opportunity ' + Math.random();
		newOpportunity.StageName = 'Prospecting';
		newOpportunity.CloseDate = Date.today();
		insert newOpportunity;

        PageReference pageRefTemp = System.Page.cc_Rostering;
        pageRefTemp.getParameters().put('id',newOpportunity.id);
        Test.setCurrentPage(pageRefTemp);
		cc_Rostering_Controller rostercontroller = new cc_Rostering_Controller();
		rostercontroller.nameFile = null;
		rostercontroller.contentFile = Blob.valueOf('First Name,Last Name,Email,Street Address Line 1,Street Address Line 2,City,State,Zipcode,Country,Phone,Programs of Interest,Class Code,Transaction Code,Balance,Start Date,End Date,Graduation Year,School Id,Channel,Lead Source Id,Center Code,Student Id,Do Not Email,Do Not Call\rRoster,Test1221,rostertest1221@edlconsulting.com,2043 W Belmont Ave.,Apt 2,Chicago,IL,60618,USA,773-555-5555,GMAT,EYXX10000,403,10,10/3/2013,10/3/2014,2014,23456,20,100,579,12345,Y,Y');
		PageReference pageRef = rostercontroller.ReadFile();
		Test.stopTest();
	}

	//Test when the graduation year is character instead of numeric
	@isTest static void test_method_five() {
		Test.startTest();
		// Instantiate a new controller with all parameters in the page
        Opportunity newOpportunity = new Opportunity();
        newOpportunity.Name = 'Test Opportunity ' + Math.random();
		newOpportunity.StageName = 'Prospecting';
		newOpportunity.CloseDate = Date.today();
		insert newOpportunity;

        PageReference pageRefTemp = System.Page.cc_Rostering;
        pageRefTemp.getParameters().put('id',newOpportunity.id);
        Test.setCurrentPage(pageRefTemp);
		cc_Rostering_Controller rostercontroller = new cc_Rostering_Controller();
		rostercontroller.nameFile = 'testfile';
		rostercontroller.contentFile = Blob.valueOf('First Name,Last Name,Email,Street Address Line 1,Street Address Line 2,City,State,Zipcode,Country,Phone,Programs of Interest,Class Code,Transaction Code,Balance,Start Date,End Date,Graduation Year,School Id,Channel,Lead Source Id,Center Code,Student Id,Do Not Email,Do Not Call\rRoster,Test1221,rostertest1221@edlconsulting.com,2043 W Belmont Ave.,Apt 2,Chicago,IL,60618,USA,773-555-5555,GMAT,EYXX10000,403,10,10/3/2013,10/3/2014,201345,23456,20,100,579,12345,Y,Y');
		PageReference pageRef = rostercontroller.ReadFile();
		Test.stopTest();
	}

	//Test when the graduation year is provided and school id is missing
	@isTest static void test_method_six() {
		Test.startTest();
		// Instantiate a new controller with all parameters in the page
        Opportunity newOpportunity = new Opportunity();
        newOpportunity.Name = 'Test Opportunity ' + Math.random();
		newOpportunity.StageName = 'Prospecting';
		newOpportunity.CloseDate = Date.today();
		insert newOpportunity;

        PageReference pageRefTemp = System.Page.cc_Rostering;
        pageRefTemp.getParameters().put('id',newOpportunity.id);
        Test.setCurrentPage(pageRefTemp);
		cc_Rostering_Controller rostercontroller = new cc_Rostering_Controller();
		rostercontroller.nameFile = 'testfile';
		rostercontroller.contentFile = Blob.valueOf('First Name,Last Name,Email,Street Address Line 1,Street Address Line 2,City,State,Zipcode,Country,Phone,Programs of Interest,Class Code,Transaction Code,Balance,Start Date,End Date,Graduation Year,School Id,Channel,Lead Source Id,Center Code,Student Id,Do Not Email,Do Not Call\rRoster,Test1221,rostertest1221@edlconsulting.com,2043 W Belmont Ave.,Apt 2,Chicago,IL,60618,USA,773-555-5555,GMAT,EYXX10000,403,10,10/3/2013,10/3/2014,2014,,20,100,579,12345,Y,Y');
		PageReference pageRef = rostercontroller.ReadFile();
		Test.stopTest();
	}

	//test when the Do not eamil and Do not call flag are false
	@isTest static void test_method_seven() {
		Test.startTest();
		// Instantiate a new controller with all parameters in the page
        Opportunity newOpportunity = new Opportunity();
        newOpportunity.Name = 'Test Opportunity ' + Math.random();
		newOpportunity.StageName = 'Prospecting';
		newOpportunity.CloseDate = Date.today();
		insert newOpportunity;

        PageReference pageRefTemp = System.Page.cc_Rostering;
        pageRefTemp.getParameters().put('id',newOpportunity.id);
        Test.setCurrentPage(pageRefTemp);
		cc_Rostering_Controller rostercontroller = new cc_Rostering_Controller();
		rostercontroller.nameFile = 'testfile';
		rostercontroller.contentFile = Blob.valueOf('First Name,Last Name,Email,Street Address Line 1,Street Address Line 2,City,State,Zipcode,Country,Phone,Programs of Interest,Class Code,Transaction Code,Balance,Start Date,End Date,Graduation Year,School Id,Channel,Lead Source Id,Center Code,Student Id,Do Not Email,Do Not Call\rRoster,Test1221,rostertest1221@edlconsulting.com,2043 W Belmont Ave.,Apt 2,Chicago,IL,60618,USA,773-555-5555,GMAT,EYXX10000,403,10,10/3/2013,10/3/2014,2014,23456,20,100,579,12345,N,N');
		PageReference pageRef = rostercontroller.ReadFile();
		Test.stopTest();
	}				
}