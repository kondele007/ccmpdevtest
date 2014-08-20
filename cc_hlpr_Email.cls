//
//
//  Created by CloudCraze, LLC.
//  Copyright 2010 CloudCraze, LLC. All rights reserved.
//
//  Redistribution and use in source or binary forms, with or without 
//  modification is PROHIBITED.
//
//
public class cc_hlpr_Email {
	//==================================================
	// SERVICE METHODS
	//================================================== 
	public void sendEmail(String subject, String body) {
		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
		String[] sendTo = new String[] { 'vishal.belawade@gmail.com' }; 
		
		email.setToAddresses(sendTo);
		email.setSubject(subject);
		email.setPlainTextBody(body);

		Messaging.SendEmailResult [] r = Messaging.sendEmail(
			new Messaging.SingleEmailMessage[] { email }
		);
    }

	public void sendEmailUsingTemplate(ID templateId, ID objectId, String[] sendTo) {
		sendEmailusingTemplate(templateId,objectId,sendTo,null);   
	}

	public void sendEmailUsingTemplate(ID templateId, ID objectId, String[] sendTo, String subject) {
		try {
			User user = cc_api_User.getCurrentUser;
			Id targetId = (user.ContactId != null) ? user.ContactId : user.Id;
			Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
			email.setSaveAsActivity(false);
			email.setWhatId(objectId);
			email.setCcAddresses(sendTo);
			email.setTemplateId(templateId);
			email.setTargetObjectId(targetId);
			if (!al.StringUtils.isEmpty(subject)){ email.setSubject(subject); }
			Messaging.SendEmailResult [] r = Messaging.sendEmail(
				new Messaging.SingleEmailMessage[] { email }
			);
		} catch (Exception e) {
			System.debug('Exception thrown from cc_hlpr_Email.SendEmailUsingTemplate: ' + e.getMessage());
		}
	}
	
	static testMethod void myUnitTest() {
		cc_test_TestDataSetup.loadData();
		cc_hlpr_Email email = new cc_hlpr_Email();
		email.sendEmail('test', 'test');
		EmailTemplate et = new EmailTemplate();
		String[] sendTo = new String[] { 'test@test.test' };
		List<E_Product__c> products = cc_test_PrepTestData.insertProduct(1);
		email.sendEmailUsingTemplate(et.id, products[0].id, sendTo);
		email.sendEmailUsingTemplate(et.id, products[0].id, sendTo, 'test');
		System.assert([Select c.Id From E_ApplicationSettings__c c where name='CloudCraze'].size() != 0);
	}
}