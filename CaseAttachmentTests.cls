@isTest
public class CaseAttachmentTests
{
	static testMethod void testAttachments()
	{
		final String FILENAME = 'some file';

		Kaplan_Custom_Config__c newSetting = new Kaplan_Custom_Config__c();
		newSetting.Name = 'Kaplan Custom Config';
		newSetting.ETL_Load_Username__c = 'someusername';
		System.runAs( KapTestUtil.ADMIN_USER )
		{
			insert newSetting;
		}

		Case cse = KapTestUtil.createTestCase( UserInfo.getUserId() );

		//Instantiate Controller
		CaseAttachment sc = new CaseAttachment(new ApexPages.StandardController(cse));

		Test.startTest();

			sc.contentFile = Blob.valueOf('testAttachmentBody');
			sc.nameFile = FILENAME;

			sc.attachments[1].Body = Blob.valueOf('testanotherattachment');
			sc.attachments[1].Name = FILENAME + '1';

			sc.attachments[2].Body = Blob.valueOf('testyetanotherattachment');
			sc.attachments[2].Name = FILENAME + '2';
			//upload the attachment
			PageReference uploadTest = sc.ReadFile();

		Test.stopTest();

		List<Attachment> attachments = [SELECT Id, Name FROM Attachment WHERE ParentId = :cse.Id];
		System.assertEquals(3, attachments.size(), 'There should be attachments created for the Case');
		for( Attachment anAttachment : attachments )
		{
			System.assert( attachments[0].Name.startsWith( FILENAME ), 'The name of the file should be as specified' );
		}
	}
}