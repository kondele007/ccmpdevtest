/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class cc_util_test_Chatter {

    static testMethod void myUnitTest() {
        
        //cc_test_TestDataSetup.LoadData();
        //User testUser = cc_test_TestDataSetup.testUser;
//        Account a = new Account(name = 'my account');
//        insert a;

	cc_api_dl_accountGroups ag = new cc_api_dl_accountGroups();
	ag.loadData();
	RecordType rt = [Select r.Name, r.Id From RecordType r where r.Name = 'Person Account' limit 1];
	Account a = new Account(LastName='my account', RecordTypeID = rt.Id, E_AccountGroup__r= new E_AccountGroup__c(ACCOUNTGROUPID__C='1'), OwnerId=userInfo.getUserId());
	insert a;
        
        test.startTest();
            doTest(a.id);
        test.stopTest();
        
    }
    @future
    static void doTest(id objId) {
        User currentUser = [select id from user where id = :userinfo.getUserId()];
        Account a = [select id from account where id = :objId ];
        //insert new Group(name='MyTestGroup');
        //insert new GroupMember (UserOrGroupId = currentUser.id,  Group=new Group(name='MyTestGroup'));
        
        //List<EntitySubscription> followers= cc_util_Chatter.addGroupToObjects(new list<SObject>{a}, 'MyTestGroup');
        //system.assert(followers != null);
        
        List<EntitySubscription> followers= cc_util_Chatter.addFollowersToObjects(new list<SObject>{a}, new list<id>{currentUser.id});
        system.assert(followers != null);
        
        followers= cc_util_Chatter.addFollowersToObjects(new list<Id>{(Id)a.get('Id')}, new list<User>{currentUser});
        system.assert(followers != null);
         
        FeedItem fi = cc_util_Chatter.addObjectFeedItem(a, 'View This', 'New Object just created');
        system.assert(fi != null);
    }
}