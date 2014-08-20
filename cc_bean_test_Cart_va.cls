@isTest
private class cc_bean_test_Cart_va {
    
    static testMethod void testCartBean() {
        cc_test_TestDataSetup.LoadData();
        User testUser = cc_test_TestDataSetup.testUser;
        Contact testContact = testUser.Contact;
        
        E_ContactAddr__c billTo = new E_ContactAddr__c(
            AddressFirstline__c='100 Pine Street', City__c='SmallTown', DaytimePhone__c='(847) 555-1212',
            FirstName__c='Test', HomePhone__c='(847) 555-1212', LastName__c='User',
            PostalCode__c='60601', State__c='Idaho', StateISOCode__c='ID',
            CountryISOCode__c='USA');

        E_ContactAddr__c shipTo = new E_ContactAddr__c(
            AddressFirstline__c='100 Pine Street', City__c='SmallTown', DaytimePhone__c='(847) 555-1212',
            FirstName__c='Craig', HomePhone__c='(847) 555-1212', LastName__c='Traxler',
            PostalCode__c='60601', State__c='Idaho', StateISOCode__c='ID',
            CountryISOCode__c='USA');

        insert new List<E_ContactAddr__c> {billTo, shipTo};
        
        String testName = 'testcart';
        String testEmail = 'myemail@test.com';
        String testFirstName = 'Test';
        String testLastName = 'User';
        String testCompanyName = 'MyCo';
        String testPhone = '(800) 555-1111';
        String testMobilePhone = '(800) 555-2222';
        String testPaymentMethod = 'PO';
        String testPONumber = '12345';
        
        E_Cart__c cart = new E_Cart__c(
            Name__c = testName,
            Contact__c = testUser.ContactId,
            BillTo__c = billTo.Id,
            ShipTo__c = shipTo.Id,
            BuyerEmail__c = testEmail,
            BuyerFirstName__c = testFirstName,
            BuyerLastName__c = testLastName,
            BuyerCompanyName__c = testCompanyName,
            BuyerPhone__c = testPhone,
            BuyerMobilePhone__c = testMobilePhone,
            PaymentMethod__c = testPaymentMethod,
            PONumber__c = testPONumber,
            SessionID__c = 'test session'
        );
        
        insert cart;

        Test.startTest();

        System.runas(cc_test_TestDataSetup.testUser) {
            cc_bean_Cart_va cartBean = new cc_bean_Cart_va(cart);
            
            System.assertEquals(cart.Id, cartBean.sfid);
            System.assertEquals(testName, cartBean.name);
            System.assertEquals(testEmail, cartBean.buyerEmail);
            System.assertEquals(testFirstName, cartBean.buyerFirstName);
            System.assertEquals(testLastName, cartBean.buyerLastName);
            System.assertEquals(testCompanyName, cartBean.buyerCompanyName);
            System.assertEquals(testPhone, cartBean.buyerPhone);
            System.assertEquals(testMobilePhone, cartBean.buyerMobilePhone);
            System.assertEquals(testPaymentMethod, cartBean.paymentMethod);
            System.assertEquals(testPONumber, cartBean.poNumber);
        }
        
        Test.stopTest();
    }

}