global class cc_Roster_Batchload implements Database.Batchable<sObject>, Database.AllowsCallouts{

private static final String groupName = 'Anonymous';
private static final String personAccountName = 'Person Account';
private static final String profileID = 'CloudCraze High Volume Customer Portal User';
private static final String rosterAlias = 'Roster';
private static final String emailEncodingKey = 'ISO-8859-1';
private static final String timeZoneKey = 'America/New_York';
private static final String languageLocaleKey = 'en_US';

Account personAccount;
Profile rosterProfile;
ID Opp_ID;
User rosterUser;
String query;
String rosterMasterID;
ID billingAddress;
ID shippingAddress;
String fileName;
ID personeRecordTypeId;


global cc_Roster_Batchload (String q, ID oppId, String name, String rosterId)
{
   query = q;
   Opp_ID = oppId;
   fileName = name;
   rosterMasterID = rosterId;
}

global cc_Roster_Batchload (String q, String name,String rosterId)
{
   query = q;
   rosterMasterID = rosterId;
   fileName = name;
}

global Database.QueryLocator start(Database.BatchableContext BC){
   System.debug(LoggingLevel.INFO,'query' + query); 
   System.debug(LoggingLevel.INFO,'Database.getQueryLocator(query)' + Database.getQueryLocator(query)); 
   return Database.getQueryLocator(query);
}

global void execute(Database.BatchableContext BC, List<CC_Rostering_Detail__c> scope){
    System.debug(LoggingLevel.INFO,'---------CW--------- scope' + scope); 
    for(CC_Rostering_Detail__c rd : scope){ 
        try{
            if(rd.Student_Id__c == null){
                markDeDupe(rd);
            }
            if(rd.Status__c == 'Loaded'){
                System.debug(LoggingLevel.INFO,'rd.Student_Id__c' + rd.Student_Id__c); 
                if(rd.Student_Id__c != null && String.valueOf(rd.Student_Id__c).trim() != ''){
                    if (personAccountExist(rd)){
                        updateAccountUserInfo(rd);
                    }else{
                        /*
                        if(userNameExist(rd)){
                            continue;
                        }
                        createAccoutUserAddressInfo(rd);
                        */
                        //if Student ID doesn't exist in ORG then error out.    
                        rd.Status__c = 'Fail';
                        rd.Notes__c = 'Student ID not found in the Org. - ' + rd.Student_Id__c;
                        continue;                       
                    }
                    createCartAndPlaceOrder(rd);
                }else{
                    if(userNameExist(rd)){
                        continue;
                    }
                    createAccoutUserAddressInfo(rd);
                    createCartAndPlaceOrder(rd);                    
                }

            }

            else if(rd.Status__c == 'AccountMerged'){
                System.debug(LoggingLevel.INFO, '$$Roster account='+rd.Notes__c);
                getAccountID(rd);
                if(personAccount != null){
                    updateAccountUserInfo(rd);
                    createCartAndPlaceOrder(rd);
                    rd.Status__c = 'Merged';
                }
            }
          
            else if(rd.Status__c == 'DedupeMerge'){
                System.debug(LoggingLevel.INFO, '$$Roster DedupeMerge='+rd.Notes__c);
                getAccountID(rd);
                if(personAccount != null){
                    System.debug(LoggingLevel.INFO, '$$Roster DedupeMerge='+personAccount);
                    updateAccountUserInfo(rd);
                    createCartAndPlaceOrder(rd);
                    rd.Status__c = 'Merged';
                }
            }
            else if(rd.Status__c == 'DedupeCreate'){
                System.debug(LoggingLevel.INFO, '$$Roster DedupeCreate='+rd.Notes__c);
                if(userNameExist(rd)){
                    continue;
                }
                createAccoutUserAddressInfo(rd);
                createCartAndPlaceOrder(rd); 
                rd.Status__c = 'Success';   
            }
            
            if(rd.Status__c == 'Loaded'){
                rd.Status__c = 'Success';
            }
        }
        catch(Exception e){
            rd.Status__c = 'Fail';
            if(rd.Notes__c == null || rd.Notes__c == ''){
                rd.Notes__c = e.getMessage();
            }else{
                rd.Notes__c = rd.Notes__c+' '+e.getMessage();
            }
        }

    }
    System.debug(LoggingLevel.INFO, '$$Roster scope=' + scope);
    update scope;

}

public String getAccountID(String rosteringDetailId, List<CC_Rostering_Detail__c> scope){
    String accID;
    for(CC_Rostering_Detail__c rd : scope){
        if(rd.Status__c == 'Success' && rosteringDetailId.equalsIgnoreCase(rd.Id)){
            accID = rd.Notes__c;
        }
    }
    if (accID != null){
        try{
            personAccount = [Select ID from Account where ID = :accID];
            System.debug(LoggingLevel.INFO, '$$Roster getAccountID->personAccount' +personAccount);
        }catch(QueryException e){
            personAccount= null;
            System.debug(LoggingLevel.INFO, '$$Roster getAccountID->Account Not Found');
        }
        return accID;
    }
    return null;
}

public String getAccountID(CC_Rostering_Detail__c rosterDetail){
    String accID = rosterDetail.Notes__c;
    System.debug(LoggingLevel.INFO, '$$Roster getAccountID->'+accID);
    if (accID != null){
        try{
            personAccount = [Select ID from Account where ID = :accID];
            System.debug(LoggingLevel.INFO, '$$Roster getAccountID->personAccount' +personAccount);
        }catch(QueryException e){
            System.debug(LoggingLevel.INFO, '$$Roster getAccountID->Account Not Found');
        }
        return accID;
    }
    return null;
}

public void createCartAndPlaceOrder(CC_Rostering_Detail__c rd){
    System.debug(LoggingLevel.INFO, '---------CW--------- rd.Transaction_Code__c : ' + rd.Transaction_Code__c);
    System.debug(LoggingLevel.INFO, '---------CW--------- rd.Class_Code__c : ' + rd.Class_Code__c);
    E_Cart__c cart = createCartForUser();
    String encryptedCartID = addProductToCart(cart.Id, rd);
    System.debug(LoggingLevel.INFO, '$$Roster encryptedCartID ' +encryptedCartID);
    UpdateRosterCartInfo(encryptedCartID, rd);
    ID orderID = placeOrder(encryptedCartID);
    E_Order__c order= [Select ID, OwnerId from E_Order__c where ID = :orderID];
    //System.debug(LoggingLevel.INFO,'Order_OwnerID' + order.OwnerId); 
    //System.debug(LoggingLevel.INFO,'Order_OwnerIDToBe' + rosterUser.Id);
    UpdateRosterOrderInfo(order, rd);
    rd.Order_Id__c = orderID;
    //cc_kap_impl_services.callKaplanStudentPlaceOrder(orderID);
    //cc_kap_impl_services.callKaplanStudentPlaceOrderRTCAPOnly(orderId);
    //cc_kap_impl_services.callKaplanStudentPlaceOrderGetRealOnly(orderId);

}

public boolean createAccoutUserAddressInfo(CC_Rostering_Detail__c rd){
    personAccount = createPersonAccount(rd);
    rosterUser = createUser(personAccount, rd);
    createAddressBookEntry(personAccount,rosterUser,rd);

    List<Id> userIdList = new List<Id>();
    userIdList.add(rosterUser.Id);
    cc_util_UpdateContact.updateContacts(userIdList);

    System.debug(LoggingLevel.INFO,'createAccoutUserAddressInfo: rd.School_Id__c' + rd.School_Id__c); 
    if(rd.School_Id__c != null){
        createStudentSchool(personAccount, rd);
    }
    rd.Notes__c = personAccount.id;
    return true;  
}

public void createStudentSchool(Account personAccount, CC_Rostering_Detail__c rd){
    Student_School__c school = new Student_School__c();
    school.Account__c = personAccount.id;
    school.School_ID__c = rd.School_Id__c;
    school.Student_School_ID__c = Math.round((Math.random() * (9999999 - 999)) + 999);
    if(rd.Graduation_Year__c != null){
        String year = (String.valueOf(rd.Graduation_Year__c)).substringBefore('.');
        System.debug(LoggingLevel.INFO,'createStudentSchool: Year' + year);
        school.Graduation_Year__c = year;
    }
    insert school;
}


public void updateAccountUserInfo(CC_Rostering_Detail__c rd){
    Account a =[select ID,Programs_Of_Interest__c,Lead_Source_Name__c, PersonContactId from Account where id = :personAccount.id limit 1];
    a.Programs_Of_Interest__c = rd.Program_of_Interest__c;
    a.Lead_Source_Name__c = String.valueOf(rd.Lead_Source_ID__c);
    update a;
    System.debug(LoggingLevel.INFO,'a.PersonContactId' + a.PersonContactId); 
    try{
        rosterUser = [Select ID from User where ContactId = :a.PersonContactId Limit 1];
    }catch(QueryException e){
        rosterUser = createUser(personAccount, rd);
    }
    //if(rosterUser == null){
    //  rosterUser = createUser(personAccount, rd);
    //}
    System.debug(LoggingLevel.INFO,'rosterUser' + rosterUser); 

    try{
        E_AddressBook__c addressBook = [Select ID,E_ContactAddress__r.Id from E_AddressBook__c where Account__c =:a.ID and AddressType__c = 'Billing' and Default__c = true Limit 1];
    }catch(QueryException e){
        createAddressBookEntry(personAccount,rosterUser,rd);
    }
/*
    if(addressBook != null){
        billingAddress = addressBook.E_ContactAddress__r.Id;
    }
*/
    try{
        E_AddressBook__c addressBook = [Select ID,E_ContactAddress__r.Id from E_AddressBook__c where Account__c =:a.ID and AddressType__c = 'Shipping' and Default__c = true Limit 1];
    }catch(QueryException e){
        createAddressBookEntry(personAccount,rosterUser,rd);
    }
 /*   
    if(addressBook != null){
        shippingAddress = addressBook.E_ContactAddress__r.Id;
    }
*/
    System.debug(LoggingLevel.INFO,'updateAccountUserInfo: rd.School_Id__c' + rd.School_Id__c); 
    if(rd.School_Id__c != null){
        try{
            Student_School__c school = [select ID from Student_School__c where Account__c = :personAccount.id and School_ID__c =:rd.School_Id__c limit 1];
            String year = (String.valueOf(rd.Graduation_Year__c)).substringBefore('.');
            school.Graduation_Year__c = year;
            update school;
        }catch(QueryException e){
            createStudentSchool(personAccount,rd);
        }

    }
    //createAddressBookEntry(personAccount,rosterUser,rd);
}

public boolean userNameExist(CC_Rostering_Detail__c rd){
    String query;
    String userList;
    query = 'Select ID from User where  Username = \'' +rd.Email__c+ '\'' ;
    System.debug(LoggingLevel.INFO, '$$Roster User query='+query);
    try{
        List<User> user = Database.query(query);
        System.debug(LoggingLevel.INFO, '$$Roster User='+user); 
        for(User usr : user){
            if(userList == null){
                userList = usr.id;
            }else{
                userList = userList+', '+usr.id;
            }
        }
        if(!user.isEmpty()){
            rd.Status__c = 'Fail';
            rd.Notes__c = userList + ' - The following User ID share the same user name.';
            return true;
        }
    }catch(QueryException e){
        System.debug(LoggingLevel.INFO, '$$Roster no records found=' +rd.Status__c);
    }
    return false;
}

public void attachErrorMessage(String msg, String name){
        Blob msgBlob = Blob.valueOf(msg);
        
        Attachment attach = new Attachment();
        attach.Name = getFileName(name);
        attach.Body = msgBlob;
        attach.ContentType= 'text/csv';
        attach.ParentID = rosterMasterID;
        System.debug(LoggingLevel.INFO,'msg' + msg);
        System.debug(LoggingLevel.INFO,'attach' + attach);
        insert attach;
}

    public String getFileName(String name){
         String tempName;
         Integer num = name.indexOf('.');
         if(num > 0){
              tempName = name.substring(0,num);
         }else{
              return null;
         }
         String dt = String.valueOf(Date.today());
         String yyyy = dt.substring(0,4);
         String mm = dt.substring(5,7);
         String dd = dt.substring(8,10);
         tempName = tempName+' - '+mm+'/'+dd+'/'+yyyy+' - Errors.csv';
         return tempName;


    }


public String buildErrorMessage(List<CC_Rostering_Detail__c> scope){
    String msg ='First Name,Last Name,Email,Street Address Line 1,Street Address Line 2,State,City,Zipcode,Country,Phone,Programs of Interest,Class Code,Transaction Code,Balance,Start Date,End Date,Grad Year,School Id,Channel,Lead Source Id,Center Code,Student Id,Do Not Email,Do Not Call,Result'+'\n';
   
    for(CC_Rostering_Detail__c rd : scope){
        msg = msg


             +KapUtil.handleNullString(rd.First_Name__c)+','
             +KapUtil.handleNullString(rd.Last_Name__c)+','
             +KapUtil.handleNullString(rd.Email__c)+','
             +KapUtil.handleNullString(rd.Street_Address_Line_1__c)+','
             +KapUtil.handleNullString(rd.Street_Address_Line_2__c)+','
             +KapUtil.handleNullString(rd.State__c)+','
             +KapUtil.handleNullString(rd.City__c)+','
             +KapUtil.handleNullString(rd.Zipcode__c)+','
             +KapUtil.handleNullString(rd.Country__c)+','
             +KapUtil.handleNullString(rd.Phone__c)+','
             +KapUtil.handleNullString(rd.Program_Of_Interest__c)+','
             +KapUtil.handleNullString(rd.Class_Code__c)+','
             +KapUtil.handleNullString(rd.Transaction_Code__c)+','
             +handleNullDecimal(rd.Balance_Due__c)+','
             +handleNullDate(rd.Start_Date__c)+','
             +handleNullDate(rd.End_Date__c)+','
             +handleNullDecimal(rd.Graduation_Year__c)+','
             +KapUtil.handleNullString(rd.School_Id__c)+','
             +handleNullDecimal(rd.Channel__c)+','
             +handleNullDecimal(rd.Lead_Source_ID__c)+','
             +KapUtil.handleNullString(rd.Center_Code__c)+','
             +handleNullDecimal(rd.Student_ID__c)+','
             +rd.Do_Not_Email__c+','
             +rd.Do_Not_Call__c+','
             +rd.Status__c+' --- '
             +KapUtil.handleNullString(rd.Notes__c)+'\n';     
    }
    return msg;
}

private String handleNullDate(Date value){
    if(value == null){
        return ' ';
    }else{
        return String.valueOf(value);
    }
}

private String handleNullDecimal(Decimal value){
    if(value == null){
        return ' ';
    }else{
        return String.valueOf(value);
    }
}

public void updateRosterCartInfo(String encryptedCartID, CC_Rostering_Detail__c rd){
    List<E_CartItem__c> cartItemList = [Select ID,Price__c from E_CartItem__c where E_CartItem__c.Cart__r.EncryptedId__c  = :encryptedCartID];
    System.debug(LoggingLevel.INFO,'cartItemList' + cartItemList);
    for(E_CartItem__c cartItem : cartItemList){
        cartItem.AbsoluteDiscount__c = cartItem.Price__c - rd.Balance_Due__c;
        cartItem.Flex_Date__c = rd.Start_Date__c;        
        cartItem.Flex_End_Date__c = rd.End_Date__c;
        System.debug(LoggingLevel.INFO,'cartItem.AbsoluteDiscount__c' + cartItem.AbsoluteDiscount__c);
    }
    update cartItemList;
}

public void updateRosterOrderInfo(E_Order__c order, CC_Rostering_Detail__c rd){

    order.OwnerId = rosterUser.Id;
    order.BuyerFirstName__c = rd.First_Name__c;
    order.BuyerLastName__c = rd.Last_Name__c;
    order.BuyerEmail__c = rd.Email__c;
    order.BuyerPhone__c = rd.Phone__c;
    if(Opp_ID != null){
        order.Opportunity__c = Opp_ID;  
    }               
    update order;
    List <E_OrderItem__c> orderItemList= [Select ID,Price__c from E_OrderItem__c where Order__c = :order.Id];
    for(E_OrderItem__c orderItem : orderItemList){
        orderItem.Balance_Due__c = rd.Balance_Due__c;
        orderItem.Channel__c = rd.Channel__c;
        orderItem.Center_Code__c = rd.Center_Code__c;
        orderItem.Transaction_Code__c = rd.Transaction_Code__c;
        orderItem.AbsoluteDiscount__c = orderItem.Price__c - rd.Balance_Due__c;
    }
    update orderItemList;
}

public ID placeOrder(String encryptedCartID){
    cc_api_Cart api = new cc_api_Cart();
    return api.placeOrder(encryptedCartID);
}
public String addProductToCart(ID cartID, CC_Rostering_Detail__c rd){
    String productIDs = rd.Class_Code__c;
    cc_api_Cart api = new cc_api_Cart();
    String encryptedCartID;
    String[] products = new String[]{};
    products = productIDs.split(',');
    System.debug(LoggingLevel.INFO, '$$Roster productID=' + productIDs);
    System.debug(LoggingLevel.INFO, '$$Roster products=' + products.size());
    for (Integer i=0;i<products.size();i++){
        E_Product__c product =productValidate(products[i], rd);
        System.debug(LoggingLevel.INFO, '$$Roster product=' + product);
        encryptedCartID = api.addToCart(product.SKU__c,cartID,1,false,'USD','US',true,'DefaultStore');
        System.debug(LoggingLevel.INFO, '$$Roster encryptedCartID=' + encryptedCartID);
    }
    return encryptedCartID;
    
}

public E_Product__c productValidate(String classCode, CC_Rostering_Detail__c rd){
    E_Product__c product;
    try{
        product = [Select ID, SKU__c from E_Product__c where Code__c = :classCode and ProductStatus__c = 'Released' Limit 1];
        System.debug(LoggingLevel.INFO, '$$Roster product=' + product);     
    }catch(QueryException e){
        rd.Notes__c = 'The Class code is invalid - '+ classCode;
        System.debug(LoggingLevel.INFO, '$$Roster no Product record found=' +classCode);
    }
    return product;
}
public void markDuplicate(CC_Rostering_Detail__c rdSample, List<CC_Rostering_Detail__c> scope){
    
    for(CC_Rostering_Detail__c rd : scope){
        if(rd.Status__c == 'Loaded'
            && rdSample.Student_ID__c != null
            && rdSample.Student_ID__c == rd.Student_ID__c
            && rdSample.Class_Code__c.equalsIgnoreCase(rd.Class_Code__c)
            && rdSample.Id != rd.Id){
            rd.Status__c = 'Duplicate';         
            rd.Notes__c = rdSample.Id;
            
        }
        if(rd.Status__c == 'Loaded'
            && rdSample.First_Name__c.equalsIgnoreCase(rd.First_Name__c) 
            && rdSample.Last_Name__c.equalsIgnoreCase(rd.Last_Name__c)
            && rdSample.Email__c.equalsIgnoreCase(rd.Email__c)
            && rdSample.Class_Code__c.equalsIgnoreCase(rd.Class_Code__c)
            && rdSample.Id != rd.Id){
            rd.Status__c = 'Duplicate';
            rd.Notes__c = rdSample.Id + ' - There was a duplicate classcode for this student on the roster.' ;
            
        }   
        
    }

}
public void markDeDupe(CC_Rostering_Detail__c rdSample){
    String fName;
    String lName;
    String deDupequery;
    System.debug(LoggingLevel.INFO, '$$Roster markDeDupe=');
    if(personeRecordTypeId == null){
        personeRecordTypeId = [SELECT Id FROM RecordType WHERE Name = :personAccountName LIMIT 1].Id;
    }   
    if(rdSample.Status__c == 'Loaded'){

        try{
            fName = rdSample.First_Name__c.SubString(0,3) + '%';
            lName = rdSample.Last_Name__c.SubString(0,3)  + '%';
        }catch(Exception e){
            fName = rdSample.First_Name__c.SubString(0,1) + '%';
            lName = rdSample.Last_Name__c.SubString(0,1)  + '%';
        }
        
        deDupequery = 'Select ID, IsCustomerPortal from Account where RecordTypeId = \'' +personeRecordTypeId+  '\' and  FirstName LIKE \'' +fName+ '\' and LastName LIKE \'' +lName+ '\'and PersonEmail = \'' +rdSample.Email__c+ '\'' ;
        System.debug(LoggingLevel.INFO, '$$Roster deDupequery='+deDupequery);
        try{
            List<Account> account = Database.query(deDupequery);
            System.debug(LoggingLevel.INFO, '$$Roster account='+account);
            System.debug(LoggingLevel.INFO, '$$Roster personeRecordTypeId='+personeRecordTypeId); 
            rdSample.Notes__c = '';  
            Integer i = 0;
            for(Account acc : account){
                i ++;
                if(acc.IsCustomerPortal){
                    rdSample.Status__c = 'AccountMerged';
                    rdSample.Notes__c = acc.id;
                    break;
                }else{
                    if(i == 1){
                        rdSample.Notes__c = acc.id;
                        rdSample.Status__c = 'Dedupe';   
                    }else{
                        rdSample.Notes__c = rdSample.Notes__c+','+acc.id;
                        rdSample.Status__c = 'Dedupe'; 
                    }                    
                }

/*

                if(rdSample.Notes__c == null){
                    //rdSample.Notes__c = acc.id;
                    System.debug(LoggingLevel.INFO, '$$Roster account.size() \n'+account.size()); 
                    if(account.size() == 1 && userNameExist(rdSample)){
                        rdSample.Status__c = 'AccountMerged';
                    }else{
                        System.debug(LoggingLevel.INFO, '$$Roster Dedupe scenario \n'+ acc.id); 
                        rdSample.Status__c = 'Dedupe';
                    }
                    rdSample.Notes__c = acc.id;
                }else{
                    rdSample.Notes__c = rdSample.Notes__c+','+acc.id;
                    rdSample.Status__c = 'Dedupe';
                }
*/
//                rdSample.Status__c = 'Dedupe';
            }
        }catch(QueryException e){
            System.debug(LoggingLevel.INFO, '$$Roster no records found=' +rdSample.Status__c);
        }
    }   

}

public boolean personAccountExist(CC_Rostering_Detail__c rdSample){
    System.debug(LoggingLevel.INFO, '$$Roster Student_Id=' + String.valueOf(rdSample.Student_Id__c));
        try{
            personAccount = [Select ID from Account where Student_id_display__c = :String.valueOf(rdSample.Student_Id__c) or Student_id__c = :rdSample.Student_Id__c];
        }catch(QueryException e){
            System.debug(LoggingLevel.INFO, '$$Roster personAccount=' + personAccount);
            return false;
        }
    
    return true;
}

public Account createPersonAccount(CC_Rostering_Detail__c rdSample){
    
        if(personeRecordTypeId == null){
            personeRecordTypeId = [SELECT Id FROM RecordType WHERE Name = :personAccountName LIMIT 1].Id;
        }
        System.debug(LoggingLevel.INFO, '$$Roster personeRecordTypeId=' + personeRecordTypeId);
        Account personAccount = new Account();
        personAccount.FirstName = rdSample.First_Name__c;
        personAccount.LastName = rdSample.Last_Name__c;
        personAccount.Email__c = rdSample.Email__c;
        personAccount.PersonEmail = rdSample.Email__c;
        personAccount.Kaptest_Username__c = rdSample.Email__c;
        personAccount.E_AccountGroup__c = getAccountGroup();
        personAccount.RecordTypeId = personeRecordTypeId;
        personAccount.Programs_of_Interest__c = rdSample.Program_Of_Interest__c;
        personAccount.BillingStreet = rdSample.Street_Address_Line_1__c;
        personAccount.Permanent_Address2__c = rdSample.Street_Address_Line_2__c;
        personAccount.BillingCity = rdSample.City__c;
        personAccount.BillingState = rdSample.State__c;
        personAccount.BillingPostalCode = rdSample.Zipcode__c;
        personAccount.BillingCountry = rdSample.Country__c;
        personAccount.ShippingStreet = rdSample.Street_Address_Line_1__c;
        personAccount.Work_Address_Line2__c= rdSample.Street_Address_Line_2__c;
        personAccount.ShippingCity = rdSample.City__c;
        personAccount.ShippingState = rdSample.State__c;
        personAccount.ShippingPostalCode = rdSample.Zipcode__c;
        personAccount.ShippingCountry = rdSample.Country__c;
        personAccount.Phone = rdSample.Phone__c;
        personAccount.Do_Not_Call2__c= rdSample.Do_Not_Call__c;
        personAccount.Email_Opt_Out2__c = rdSample.Do_Not_Email__c;
        personAccount.Channel__c = String.valueOf(rdSample.Channel__c);
        personAccount.Student_ID__c = rdSample.Student_Id__c;
        personAccount.Student_ID_Display__c = String.valueOf(rdSample.Student_Id__c);
        personAccount.Center_Code__c = rdSample.Center_Code__c;
        personAccount.Lead_Source_Name__c = String.valueOf(rdSample.Lead_Source_ID__c);


        insert personAccount;
        System.debug(LoggingLevel.INFO, '$$Roster personAccount=' + personAccount); 
        return personAccount;
}

public ID getAccountGroup(){
    E_AccountGroup__c accountGroup;
    System.debug(LoggingLevel.INFO, '$$Roster groupName=' + groupName);
    try{
        accountGroup = [Select ID from E_AccountGroup__c where Name = :groupName Limit 1];
    }catch(QueryException e){
        System.debug(LoggingLevel.INFO, '$$Roster accountGroup=' + accountGroup);
        throw e;
    }
    return accountGroup.Id;
}

public User createUser(Account acc, CC_Rostering_Detail__c rdSample){

    User usr = new User();
    usr.Username = rdSample.Email__c;
    usr.LastName = rdSample.Last_Name__c;
    usr.FirstName = rdSample.First_Name__c;
    usr.Email = rdSample.Email__c;
    usr.Phone = rdSample.Phone__c;
    
    Account a =[select ID, PersonContactId, OwnerId from Account where id = :acc.id limit 1];
    System.debug(LoggingLevel.INFO, '$$Roster PersonContactId=' + a.PersonContactId);
    usr.ContactId= a.PersonContactId;   
    usr.ProfileId = getProfileId();
    usr.Alias = rosterAlias;
    usr.EmailEncodingKey = emailEncodingKey;
    usr.LocaleSidKey = languageLocaleKey;
    usr.TimeZoneSidKey = timeZoneKey;
    usr.LanguageLocaleKey = languageLocaleKey;
    usr.IsActive = true;
    insert usr;
    System.debug(LoggingLevel.INFO, '$$Roster rosterUser=' + usr);
    System.debug(LoggingLevel.INFO, '$$Roster rostera=' + a);
    System.debug(LoggingLevel.INFO, '$$Roster rostera=' + a.OwnerId);

    return usr;
}

public ID getProfileId(){
    if (rosterProfile != null){
        return rosterProfile.Id;
    }else{
        try{
            rosterProfile = [Select ID from Profile where Name = :profileID Limit 1];
        }catch(QueryException e){
            System.debug(LoggingLevel.INFO, '$$Roster rosterProfile=' + rosterProfile);
            throw e;
        }
        return rosterProfile.Id;
    }
} 

public E_Cart__c createCartForUser(){
        E_Cart__c cartHeader = new E_Cart__c();
        cartHeader.Account__c = personAccount.Id;
        cartHeader.CartType__c = cc_cnst_PickListConstants.CARTTYPE_CART;
        cartHeader.CartStatus__c=cc_cnst_PickListConstants.CARTSTATUS_OPEN;
        cartHeader.CurrencyISOCode__c = 'USD';
        cartHeader.CustomerTypeCode__c = 'US';
        System.debug(LoggingLevel.INFO, '$$Roster createCartForUser -> rosterUser=' + rosterUser); 
        System.debug(LoggingLevel.INFO, '$$Roster createCartForUser -> rosterUser.id=' + rosterUser.Id); 
        cartHeader.User__c = rosterUser.Id;
        cartHeader.Contact__c = cc_api_User.getUserContactId(rosterUser.Id);
        cartHeader.Name__c = 'Cart';
        cartHeader.OwnerId = rosterUser.Id;
        cartHeader.AnonymousID__c = false;
        cartHeader.ActiveCart__c = true;
        cartHeader.SessionID__c ='no session id present';
        System.debug(LoggingLevel.INFO, '$$Roster billingAddress.id=' + billingAddress);
        System.debug(LoggingLevel.INFO, '$$Roster shippingAddress.id=' + shippingAddress);
        cartHeader.BillTo__c = billingAddress;
        cartHeader.ShipTo__c = shippingAddress;
        insert cartHeader;
        return cartHeader;
    }

public void createAddressBookEntry(Account acc, User usr, CC_Rostering_Detail__c rdSample){
    //billing
    billingAddress = createContactAddress(rdSample);
    E_AddressBook__c addressBookEntry = cc_api_Addressbook.createAddressBookEntry(acc.Id,billingAddress,true,'Billing',usr.Id);
    insert addressBookEntry;
    //shipping
    shippingAddress = createContactAddress(rdSample);
    addressBookEntry = cc_api_Addressbook.createAddressBookEntry(acc.Id,shippingAddress,true,'Shipping',usr.Id);
    insert addressBookEntry;

}

public ID createContactAddress(CC_Rostering_Detail__c rdSample){
    E_ContactAddr__c contactAddress= new E_ContactAddr__c();
    contactAddress.AddressFirstline__c = rdSample.Street_Address_Line_1__c;
    contactAddress.AddressSecondline__c = rdSample.Street_Address_Line_2__c;
    contactAddress.City__c = rdSample.City__c;
    contactAddress.State__c = rdSample.State__c;
    contactAddress.Country__c = rdSample.Country__c;
    contactAddress.DaytimePhone__c = rdSample.Phone__c;
    contactAddress.Email__c = rdSample.Email__c;
    contactAddress.FirstName__c = rdSample.First_Name__c;
    contactAddress.LastName__c= rdSample.Last_Name__c;
    contactAddress.PostalCode__c = rdSample.Zipcode__c;
    insert contactAddress;
    return contactAddress.Id;
}
    global void finish(Database.BatchableContext BC){
        System.debug(LoggingLevel.INFO, '$$Enter Finish');
        String failQuery = 'select Id,  First_Name__c, Last_Name__c, Email__c, Street_Address_Line_1__c, Street_Address_Line_2__c, State__c, City__c, Zipcode__c, CC_Rostering_Master__c, Country__c, Phone__c, Program_Of_Interest__c, School_Id__c, Graduation_Year__c, Student_Id__c, Center_Code__c, Do_Not_Email__c, Do_Not_Call__c, Channel__c, Start_Date__c, End_Date__c, Class_Code__c, Transaction_Code__c, Balance_Due__c, Lead_Source_ID__c, Status__c, Notes__c from CC_Rostering_Detail__c where CC_Rostering_Master__c = \'' + rosterMasterID + '\'and Status__c = \'' +'Fail'+'\'' ;
        System.debug(LoggingLevel.INFO, '$$failQuery' + failQuery);
        List<CC_Rostering_Detail__c> rdFailList = Database.query(failQuery);
        
        if(!rdFailList.isEmpty()){
            String errorMessage = buildErrorMessage(rdFailList);
            if(errorMessage != null){
                attachErrorMessage(errorMessage,fileName);
            }
        }

        //Integer start = System.Now().millisecond();
        //while(System.Now().millisecond()< start+10000){ }
        
        String orderSubmitQuery = 'select order_Id__c from CC_Rostering_Detail__c where CC_Rostering_Master__c = \'' + rosterMasterID + '\'and order_Id__c  != \'' +''+'\'' ;
        //String orderSubmitQuery = 'select order_Id__c from CC_Rostering_Detail__c where CC_Rostering_Master__c = \'' + rosterMasterID + '\'and order_Id__c  != \'' +''+'\' FOR UPDATE' ;

        List<CC_Rostering_Detail__c> rdOrderList = Database.query(orderSubmitQuery);
        if(!rdOrderList.isEmpty()){
            cc_RosterScheduler rosterSched = new cc_RosterScheduler(orderSubmitQuery,null,fileName,null,'cc_OrderPlaceCallOutInBatch');
            Datetime dt = Datetime.now().addSeconds(10);
            String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
            System.debug(LoggingLevel.INFO, '$$Roster timeForScheduler=' + timeForScheduler);
            Id schedId = System.Schedule('RosterSendOrderToGetReal'+timeForScheduler,timeForScheduler,rosterSched);
            System.debug(LoggingLevel.INFO, '$$Roster schedId=' + schedId);

        }else{  
            AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            from AsyncApexJob where Id =:BC.getJobId()];

            // Send an email to the Apex job's submitter notifying of job completion.  
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {a.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
            mail.setSubject('Roster Job Status ' + a.Status);
            mail.setPlainTextBody('The batch Apex job processed loading file '+fileName+' with '+ a.TotalJobItems +
            ' batches and '+ a.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
     
        }
    }

}