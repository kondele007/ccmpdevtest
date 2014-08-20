public with sharing class ktp_cc_api_User {
    //==================================================
    // STATIC VARIABLE
    //==================================================
    //currUser is a singleton, it is shared in current request.
    private static User currUser = null; 
    //==================================================
    // STATIC PROPERTY
    //==================================================
    public static User getCurrentUser {
        get {
            if(currUser != null)
            {
                return currUser;
            }
            String userId = UserInfo.getUserId();
            if(userId != null && !userId.equals('')) {
                currUser = [
                  SELECT 
                    u.Title, u.user_salutation__c,u.ID, u.CC_CurrencyCode__c, u.ContactId, 
                    u.FirstName, u.LastName, u.Phone, u.MobilePhone, u.Email, u.CompanyName,
                    u.Tax_Exempt__c, u.Street, u.City, u.State, u.PostalCode, u.Country, 
                    u.UserType, u.Contact.Account.Name, u.Contact.Phone, 
                u.Contact.Account.PreventNewAddrCheckout__c, u.Contact.Account.PreventAddrBookSave__c
                  FROM User u where u.id = :userId];
            }
            return currUser;
        }
    }
  }