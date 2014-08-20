@isTest
private class cc_ctrl_test_RequestForQuote {

    static testMethod void testRFQController() {
        cc_test_TestDataSetup.LoadData();
        User testUser = cc_test_TestDataSetup.testUser;
        Account testAccount = cc_test_TestDataSetup.testAccount;
        Id cartId = null;

        System.runas(testUser) {
            cc_api_cart cartApi = new cc_api_cart();
            E_Cart__c testCart = cartApi.createEmptyCart();
            cartId = testCart.Id;
            PageReference cartPage = system.page.cart;
            cartPage.getParameters().put('cartId', testCart.EncryptedID__c);
            Test.setCurrentPage(cartPage);
            cc_ctrl_cart cartController = new cc_ctrl_cart();
            cc_ctrl_RequestForQuote ctrlRFQ = new cc_ctrl_RequestForQuote();
            ctrlRFQ.cloudCrazeController = cartController;
            system.assertEquals(null, ctrlRFQ.saveRequestForQuote());
        }

        if(cc_util_Schema.isSObjectAvailable('Opportunity')) {
            List<SObject> opptys = Database.query('select AccountId, Cart__c  from Opportunity');
            //System.assertEquals(1, opptys.size());
            for(SObject oppty : opptys) {
               // System.assertEquals(testAccount.Id, oppty.get('AccountId'));
                if(cc_util_Schema.sObjectHasField(oppty, 'Cart__c')) {
                 //   System.assertEquals(cartId, oppty.get('Cart__c'));
                }
            }
        }
    }
    
    static testMethod void testRFQControllerAnonymous() {
        cc_test_TestDataSetup.LoadData();
        User guest = cc_test_PrepTestData.getGuestUser();
        //Account a = new Account(name='Anonymous');
        //insert a;
        RecordType rt = [Select r.Name, r.Id From RecordType r where r.Name = 'Person Account' limit 1];
        
        Account a = new Account(LastName='Anonymous', RecordTypeID = rt.Id, E_AccountGroup__r= new E_AccountGroup__c(ACCOUNTGROUPID__C='1'), OwnerId=userInfo.getUserId());
        insert a;

        Id cartId = null;
        
        if(guest != null) {
            System.runAs (guest) {
                cc_api_cart cartApi = new cc_api_cart();
                E_Cart__c testCart = cartApi.createEmptyCart();
                cartId = testCart.Id;
                PageReference cartPage = system.page.cart;
                cartPage.getParameters().put('cartId', testCart.EncryptedID__c);
                Test.setCurrentPage(cartPage);
                cc_ctrl_cart cartController = new cc_ctrl_cart();
                cc_ctrl_RequestForQuote ctrlRFQ = new cc_ctrl_RequestForQuote();
                ctrlRFQ.cloudCrazeController = cartController;
                cc_bean_RequestForQuote rfq = ctrlRFQ.rfq;
                rfq.lastName = guest.LastName;
                rfq.company = 'MyCo';
                system.assertEquals(null, ctrlRFQ.saveRequestForQuote());
            }
        }

        if(cc_util_Schema.isSObjectAvailable('Lead')) {
            List<SObject> leads = Database.query('select LastName, Cart__c from Lead');
            //System.assertEquals(1, leads.size());
            for(SObject lead : leads) {
               // System.assertEquals(guest.LastName, lead.get('LastName'));
                if(cc_util_Schema.sObjectHasField(lead, 'Cart__c')) {
                 //   System.assertEquals(cartId, lead.get('Cart__c'));
                }
            }
        }
    }
}