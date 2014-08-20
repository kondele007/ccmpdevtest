global class SSOprovisioningFunctionCall{
//Variable Declaration
//Variables are aligned according to Registration form Inputs..
//A wrapper class to hold all variables...
    global class details{
    Webservice Decimal studentId;
    Webservice String email;
    Webservice String firstName;
    Webservice String lastName;
    Webservice String abaNumber;
    Webservice String amaNumber;
    Webservice String billingFirstName;
    Webservice String billingLastName;
    Webservice String billingAddressLine1;
    Webservice String billingAddressLine2;
    Webservice String billingCity;
    Webservice String billingState;
    Webservice String billingZip;
    Webservice String billingCountry;
    Webservice String billingAddressType;
    Webservice String billingPhone;
    Webservice String shippingFirstName;
    Webservice String shippingLastName;
    Webservice String shippingAddressLine1;
    Webservice String shippingAddressLine2;
    Webservice String shippingCity;
    Webservice String shippingState;
    Webservice String shippingZip;
    Webservice String shippingCountry;
    Webservice String shippingAddressType;
    Webservice String shippingPhone;
    Webservice String parentEmail;
    Webservice String parentFirstName=null;
    Webservice String parentLastName=null;
    Webservice String parentKaptestUserId=null;
    Webservice String parentStudentId;
    Webservice String schoolId;
    Webservice String schoolName;
    Webservice String schoolState;
    Webservice String graduationYear;
    Webservice String accountabilityId;
    Webservice String relationshipId;
    Webservice String kaptestUserId;
    Webservice String childEmail;
    Webservice String childFirstName;
    Webservice String childLastName;
    Webservice String childKaptestUserId;
    Webservice String childStudentId;
    Webservice Boolean preCollegeProgramSelected;
    Webservice Boolean medicalProgramSelected;
    Webservice String PersonEmail=null;
     /*
     * Fields that come from PingFederate GUI
     */
    Webservice String defaultProfileId;
    Webservice String defaultLocale;
    Webservice String defaultEncoding;
    Webservice String defaultSource;
    Webservice String defaultTimeZone;
    Webservice String defaultAccountGroup;
    Webservice String defaultAccountGroupAma;
    
   
    /***
    Webservice final String RELATIONSHIP_TYPE_PARENT = 'Parent';
    Webservice final String DUPLICATE_EXTERNAL_ID_STATUS_CODE = 'DUPLICATE_EXTERNAL_ID';
    
    Webservice final String KAPTEST_USER_ID_DUPLICATED_ERROR_MESSAGE = 'Kaptest_User_Id';
    ***/
      

    
    }  
    details studentDetails = new details();
   
    /****
    *Handles all types of Just in Time Account-Contact-User (etc.) Provisioning.
    ***/
     Webservice Static Void executeAccountUserProvisioning(details detrequest){
     
         SSOprovisioningFunctionCall stuDetails = new SSOprovisioningFunctionCall(detrequest); 
         
         stuDetails.executeProvisioning();       
        
      }
      
      public SSOprovisioningFunctionCall(details reqDetails){
          studentDetails = reqDetails;    
      }
      
      public void executeProvisioning(){
          
          system.debug('****Inside identification of type of user****');
          if(studentDetails.preCollegeProgramSelected ){
              system.debug('****Inside Pre College FLow****');
              if(String.isNotBlank(studentDetails.childEmail)){
                  system.debug('****Execute PreCollge Provisioning as Parent****');
                         
                  //Generate Child data first
                  system.debug('****Generating Child data****');
                  Account childAccount = generateParentChildAccount(false);
                  //Populate ParentData (if missing)
                  studentDetails.ParentEmail = studentDetails.email;
                  studentDetails.ParentFirstName = studentDetails.FirstName;
                  studentDetails.ParentKaptestUserId = studentDetails.KaptestUserId;
                  studentDetails.ParentLastName = studentDetails.LastName;
                  studentDetails.ParentStudentId = String.valueof(studentDetails.StudentId);       
                  executeCommonAccountUserProvisioningSteps(childAccount,true,true);       
        
                  system.debug('****Generating Parent data****');
                  Account parentAccount = accountFieldPopulation();//User authenticated
                  parentAccount.OnBehalfPurchaseAccount__c = childAccount.Id;
                  executeCommonAccountUserProvisioningSteps(parentAccount, false, false);
       
                                    
              }
              else if(String.isNotBlank(studentDetails.parentEmail )){
                  system.debug('****User is a Student****');
                  system.debug('****Generating Child data****');
                  Account accnt = accountFieldPopulation();
                  upsertAccountRec(accnt);
                  String personContactId = getPersonContactId(accnt);
                  User myUser = verifyUserExistsByPersonContactId(personContactId);
                            
                  Boolean isInsert = False;
                  if(myUser == null){
                      isInsert = True;    
                  }
                   
                  User uptUser = generateUser(accnt, myUser, isInsert,personcontactId);//Generates User object based on Account and other params
                  upsertUserRec(uptUser, isInsert);//Upsert User     
                                    
                  //Parent/Child relationship
                  if(String.isNotBlank(studentDetails.ParentEmail) && String.isNotBlank(studentDetails.RelationshipId)){              
                      Relationship__c relationship = generateRelationship(accnt, uptUser);
                      upsertRelationshipRec(relationship);
                  }    
                  //School Data
                  executeCommonStudentSchoolCreation(accnt);
                  executeCommonAddressBookCreation(accnt);                    
              }                  
          }
          else{
              system.debug('Inside Regular Flow****');
              Account accnt = accountFieldPopulation();
              upsertAccountRec(accnt);
              System.debug ('account id is -> ' + accnt.id);
              String personContactId = getPersonContactId(accnt);
              System.debug('Check one in Line 135 for personContactId::'+personcontactId);
              User myUser = verifyUserExistsByPersonContactId(personContactId);              
              Boolean isInsert = False;
              if(myUser == null){
                  isInsert = True;    
              }

              User uptUser = generateUser(accnt, myUser, isInsert,PersonContactId);//Generates User object based on Account and other params
              upsertUserRec(uptUser, isInsert);//Upsert User
                
             //Parent/Child relationship
             System.debug('Relationship VALUE before validation'+studentDetails.RelationshipId);
             if(String.isNotBlank(studentDetails.ParentEmail) && String.isNotBlank(studentDetails.RelationshipId) ){  
             System.debug('Relationship VALUE after null validation'+studentDetails.RelationshipId);            
                 Relationship__c relationship = generateRelationship(accnt, uptUser);
                 System.debug('Entered into Relationship Loop at Line 161 in  Regular Flow');
                 upsertRelationshipRec(relationship);
             }
             executeCommonStudentSchoolCreation(accnt);
             executeCommonAddressBookCreation(accnt);      
          }     
      } 
      
      public Account accountFieldPopulation(){
          
          system.debug('****Inside Account Creation based on type****');
          Account newAcc = new Account();
          if(studentDetails.studentId!=null){
              newAcc.Student_ID__c = studentDetails.studentId;
              newAcc.Student_ID_Display__c = String.valueOf(studentDetails.studentId);
          }
          if(String.isNotBlank(studentDetails.kaptestUserId)){
              newAcc.Kaptest_User_Id__c = studentDetails.kaptestUserId;
          }
          newAcc.LastName = (studentDetails.lastName).left(80);
          newAcc.FirstName = (studentDetails.firstName).left(40);
          newAcc.PersonEmail = studentDetails.email;
          
          newAcc.AccountSource = studentDetails.defaultSource;             
          newAcc.IsPortalUser__pc = True;
          newAcc.SelfRegistered__pc = True;   
          newAcc.Active__c = 'Yes';
          if(String.isNotBlank(studentDetails.amaNumber) && studentDetails.medicalProgramSelected){                
              newAcc.AMA_Number__c = (studentDetails.amaNumber).left(15);
              newAcc.E_AccountGroup__c = studentDetails.defaultAccountGroupAma;
          }else{
              newAcc.E_AccountGroup__c = studentDetails.defaultAccountGroup;
          }
          if(String.isNotBlank(studentDetails.abaNumber)){
          newAcc.ABA_Number__c = (studentDetails.abaNumber).left(8);
          }
          if(String.isNotBlank(newAcc.PersonEmail)){
          newAcc.Kaptest_Username__c = (newAcc.PersonEmail).left(100);
          } 
          
          return newAcc;   
      }
      private Account generateParentChildAccount(Boolean isParent) {
          Account account = new Account();    
          if(isParent){
              if(String.isNotBlank(studentDetails.ParentStudentId)){
                  account.Student_ID__c = Double.valueOf(studentDetails.ParentStudentId);
                  account.Student_ID_Display__c = String.valueof(account.Student_ID__c);
              }
              if(String.isNotBlank(studentDetails.ParentKaptestUserId)){
                  account.Kaptest_User_Id__c = studentDetails.ParentKaptestUserId;
              }
               account.LastName = (studentDetails.parentlastName).left(80);
               account.FirstName = (studentDetails.parentfirstName).left(40);
               account.PersonEmail = studentDetails.parentemail;       
          }else{
              if(String.isNotBlank(studentDetails.childStudentId)){
                  account.Student_ID__c = Double.valueOf(studentDetails.childStudentId);
                  account.Student_ID_Display__c = String.valueof(account.Student_ID__c);
              }
              if(String.isNotBlank(studentDetails.childKaptestUserId)){
                  account.Kaptest_User_Id__c = studentDetails.childKaptestUserId;
              }
               account.LastName = (studentDetails.childlastName).left(80);
               account.FirstName = (studentDetails.childfirstName).left(40);
               account.PersonEmail = studentDetails.childemail;
          }
        
          account.AccountSource = studentDetails.defaultSource;             
          account.IsPortalUser__pc = True;
          account.SelfRegistered__pc = True;   
          account.Active__c = 'Yes';
          if(String.isNotBlank(studentDetails.amaNumber) && studentDetails.medicalProgramSelected){                
              account.AMA_Number__c = (studentDetails.amaNumber).left(15);
              account.E_AccountGroup__c = studentDetails.defaultAccountGroupAma;
          }else{
              account.E_AccountGroup__c = studentDetails.defaultAccountGroup;
          }
          if(String.isNotBlank(studentDetails.abaNumber)){
          account.ABA_Number__c = (studentDetails.abaNumber).left(8);
          }
           if(String.isNotBlank(account.PersonEmail)){
          account.Kaptest_Username__c = (account.PersonEmail).left(100);   
           }
          return account;
      }
        
      public Student_School__c generateStudentSchool(Account account){
        Student_School__c studentSchool = new Student_School__c();
        studentSchool.Account__c = account.Id;
        studentSchool.School_ID__c = studentDetails.schoolId;
        studentSchool.School_Name__c = (studentDetails.schoolName).left(100);
        studentSchool.School_State__c = studentDetails.schoolState;
        studentSchool.Graduation_Year__c = studentDetails.graduationYear;
        studentSchool.Student_School_ID__c = Double.valueOf(studentDetails.accountabilityId);
        
        return studentSchool;
      } 
      
      private E_AddressBook__c generateCcAddressBook(Account account, String addressType){
        E_AddressBook__c addressBook = new E_AddressBook__c();
        addressBook.Account__c = account.Id;
        addressBook.AddressType__c = addressType;
        addressBook.Default__c = True;
        
        return addressBook;
      }
      private E_ContactAddr__c generateCcContactAddress(String addressType, String accountId){
          E_ContactAddr__c contactAddress = new E_ContactAddr__c();
          String ADDRESSTYPEBILLING='Billing';
          System.debug('The value of AddressTypeBilling in CcContactAddress is::'+ADDRESSTYPEBILLING);
         // System.debug('The value of studentDetails.ADDRESS_TYPE_BILLING in CcContactAddress is::'+studentDetails.ADDRESS_TYPE_BILLING+'::');
          System.debug('The value of String variable addressType in CcContactAddress is::'+addressType+'::');
          if(addressType.equalsIgnoreCase(ADDRESSTYPEBILLING)){
          System.debug('The value of AddressTypeBilling in CcContactAddress  after equalsIgnorecase is::'+ADDRESSTYPEBILLING);
              contactAddress.AddressFirstline__c = studentDetails.billingAddressLine1;
              contactAddress.AddressSecondline__c = studentDetails.billingAddressLine2;
              contactAddress.City__c = studentDetails.billingCity;
              contactAddress.Country__c = studentDetails.billingCountry;
              contactAddress.FirstName__c = studentDetails.billingFirstName;
              contactAddress.LastName__c = studentDetails.billingLastName;
              contactAddress.DaytimePhone__c = studentDetails.billingPhone;        
              contactAddress.State__c = studentDetails.billingState;
              contactAddress.PostalCode__c = studentDetails.billingZip;
              contactAddress.KBSAddressType__c = studentDetails.billingAddressType;
          }else{
              contactAddress.AddressFirstline__c = studentDetails.shippingAddressLine1;
              contactAddress.AddressSecondline__c = studentDetails.shippingAddressLine2;
              contactAddress.City__c = studentDetails.shippingCity;
              contactAddress.Country__c = studentDetails.shippingCountry;         
              contactAddress.FirstName__c = studentDetails.shippingFirstName;
              contactAddress.LastName__c = studentDetails.shippingLastName;
              contactAddress.DaytimePhone__c = studentDetails.shippingPhone;       
              contactAddress.State__c = studentDetails.shippingState;
              contactAddress.PostalCode__c = studentDetails.shippingZip;
              contactAddress.KBSAddressType__c = studentDetails.shippingAddressType;
          }
          contactAddress.CountryISOCode__c = contactAddress.Country__c;
          contactAddress.StateISOCode__c = contactAddress.State__c;
          contactAddress.Email__c = studentDetails.email;
          contactAddress.ContactAddrId__c = accountId +'-'+ addressType;
        
          return contactAddress;
      }
      public void updateCcContactAddress(E_ContactAddr__c originContactAddress, E_ContactAddr__c destinationContactAddress){       
          destinationContactAddress.AddressFirstline__c = originContactAddress.AddressFirstline__c;
          destinationContactAddress.AddressSecondline__c = originContactAddress.AddressSecondline__c;
          destinationContactAddress.City__c = originContactAddress.City__c;
          destinationContactAddress.Country__c = originContactAddress.Country__c;
          destinationContactAddress.FirstName__c = originContactAddress.FirstName__c;
          destinationContactAddress.LastName__c = originContactAddress.LastName__c;
          destinationContactAddress.DaytimePhone__c = originContactAddress.DaytimePhone__c;        
          destinationContactAddress.State__c = originContactAddress.State__c;
          destinationContactAddress.StateISOCode__c = originContactAddress.StateISOCode__c;
          destinationContactAddress.PostalCode__c = originContactAddress.PostalCode__c;
          destinationContactAddress.Email__c = originContactAddress.Email__c;
          destinationContactAddress.CountryISOCode__c = originContactAddress.CountryISOCode__c;
          destinationContactAddress.KBSAddressType__c = originContactAddress.KBSAddressType__c;
      }
      public E_AddressBook__c getAddressBook(E_AddressBook__c addressBook) {
           E_AddressBook__c resultAddBook;
          system.debug('****Retrieve AddressBook for Account from SFDC.****'); 
          List<E_AddressBook__c> resultAddressBook = [SELECT ID, Account__c, Name, AddressType__c, E_ContactAddress__c FROM E_AddressBook__c WHERE Account__c =:addressBook.Account__c AND AddressType__c =:addressBook.AddressType__c];
          
          if(resultAddressBook.size()>0){
              resultAddBook=resultAddressBook[0];
              //E_ContactAddr__c contactAddress = getContactAddressById(resultAddBook.E_ContactAddress__c);
              //resultAddBook.E_ContactAddress__r.id = contactAddress.Id;    
          }
        return resultAddBook;
      }
      public E_ContactAddr__c getContactAddressId(E_ContactAddr__c contactAddress) {
         E_ContactAddr__c resultcon;
          system.debug('****Retrieve E_ContactAddr__c from SFDC with ContactAddrId__c****'); 
        List<E_ContactAddr__c> result = [Select Name, ContactAddrId__c, ID FROM E_ContactAddr__c where ContactAddrId__c =:contactAddress.ContactAddrId__c Limit 1];
         if(result.size()>0){
         resultcon=result.get(0);
         }
        return resultcon;
    }
      public void upsertAccountRec(Account accRec){
          
          system.debug('****Inside Upsert Account****'+accRec);
          Account account = fetchAccount(accRec,true);          
          List<Account> accRecs = new List<Account>();
          if(account==null){
            account = fetchAccount(accRec, false);//If no account has been created by SSO (source = Web), maybe it was created by wM
          }

          if(account !=null && account.Student_ID__c !=null){
              if(accRec.Student_ID__c ==null){
                  accRec.Student_ID__c = account.Student_ID__c;    
              }
              accRecs.add(accRec);
              //Upsert accRec Student_ID__c;
              Database.UpsertResult[] saveresult = Database.upsert(accRecs, Schema.Account.Student_ID__c, false);
              system.debug('****Upsert Save Result - Student ID****'+saveresult);
              for(Database.UpsertResult result:saveresult){
                  if(!result.isSuccess()){
                      Database.Error[] errs = result.getErrors();
                      for(Database.Error err : errs){ 
                          if(err.getStatusCode().name() == 'DUPLICATE_VALUE' && err.getMessage().contains('Student_ID__c duplicates value on record')){ 
                              accRec.Student_ID__c=null;
                              accRec.Student_ID_Display__c=null;
                              upsertAccountRec(accRec);
                          }
                      }
                  }
              }
          }
          else{
              accRecs.add(accRec);
              //Upsert accRec Kaptest_User_Id__c;   
              Database.UpsertResult[] saveresultK = Database.upsert(accRecs, Schema.Account.Kaptest_User_Id__c, false);
              system.debug('****Upsert Save Result - Student ID****'+saveresultK);
              for(Database.UpsertResult result:saveresultK){
                  if(!result.isSuccess()){
                      Database.Error[] errs = result.getErrors();
                      for(Database.Error err : errs){ 
                          if(err.getStatusCode().name() == 'DUPLICATE_EXTERNAL_ID' && err.getMessage().contains('Kaptest_User_Id')){ 
                              accRec.Id = account.Id;
                              updateAccountRecord(accRec);
                          } else if(err.getStatusCode().name() == 'DUPLICATE_VALUE' && err.getMessage().contains('Student_ID__c duplicates value on record')){ 
                              accRec.Student_ID__c=null;
                              accRec.Student_ID_Display__c=null;
                              accRec.Id = account.Id;
                              updateAccountRecord(accRec);
                          }
                      }
                  }
              }

          }         
      }
      public void updateAccountRecord(Account updateAccount) {
        system.debug('Updating Account');
        String STUDENT_ID_DUPLICATED_ERROR_MESSAGE = 'Student_ID__c duplicates value on record';
        String DUPLICATE_VALUE_STATUS_CODE = 'DUPLICATE_VALUE';  
        Database.saveresult saveres = Database.Update(updateAccount,false);
        
       if(!saveres.isSuccess()){
           if(DUPLICATE_VALUE_STATUS_CODE.equals(saveres.getErrors()[0].getStatusCode().name())
                            && saveres.getErrors()[0].getMessage().contains(STUDENT_ID_DUPLICATED_ERROR_MESSAGE)){
                            updateAccount.Student_ID__c = null;
                            updateAccount.Student_ID_Display__c=null;
                            updateAccountRecord(updateAccount);
           }
       }      
    }
 
      public void upsertUserRec(User upsertUser, Boolean isInsert){
        
          system.debug('****Peform Insert or Update based on IsInsert flag****');       
          if(isInsert){
                Insert upsertUser;
          }else{
                Update upsertUser;
          }                                  
      }
      public void upsertRelationshipRec(Relationship__c relationshipRec) {
        
        system.debug('****Upsert Relationship****');
        
        Upsert relationshipRec Relationship_Id__c;
      }
      
      public void upsertstudentSchoolRec(Student_School__c studentSchool) {
          
          system.debug('****Upsert StudentSchool****');
          Upsert studentSchool Student_School_ID__c; 
        
      }
      public void upsertContactAddressRec(E_ContactAddr__c contactAddress, Boolean isUpdate){
          
          system.debug('****Upsert ContactAddress isUpdate****');
       try{
          if(isUpdate){//Name must be excluded from Updates
            //contactAddress.Name = null;
            Update contactAddress;
          }else{
          //Upsert contactAddress ContactAddrId__c;   
           Insert contactAddress; 
          }  
          }Catch(Exception e){
          System.debug('Error while executing UPSERT of AddressBook (ContactAddres)s'+e);
        }  
      }
      public void upsertAddressBookRec(E_AddressBook__c addressBook, Boolean isUpdate){
          system.debug('****Upsert AddressBook isUpdate****');
          try{
          if(isUpdate){
              //No Updates for address book
          }
          else{
              Insert addressBook;
          }
        }Catch(Exception e){
          System.debug('Error while executing UPSERT of AddressBook'+e);
        }
                 
      }
      public void executeCommonAccountUserProvisioningSteps(Account accnt, Boolean registerRelationShip, Boolean registerSchool){
          system.debug('****Inside ECAUPS Account****'+accnt);
          upsertAccountRec(accnt);
          System.debug('PersoncontactiD is set to null for testing chckpoint3'); 
                  String personContactId = getPersonContactId(accnt);
                  System.debug('PersoncontactiD is set to null for testing chckpoint2'); 
                  User myUser = verifyUserExistsByPersonContactId(personContactId);  
                  System.debug('PersoncontactiD is set to null for testing chckpoint1');            
                  Boolean isInsert = False;
                  if(myUser == null){
                      isInsert = True;    
                  }
                    System.debug('RegisterSchool value set for testing');
                  User uptUser = generateUser(accnt, myUser, isInsert,PersonContactid);//Generates User object based on Account and other params
                  upsertUserRec(uptUser, isInsert);//Upsert User     
                 if(registerRelationShip){                   
                  //Parent/Child relationship
                  if(String.isNotBlank(studentDetails.ParentEmail) && String.isNotBlank(studentDetails.RelationshipId)){              
                      Relationship__c relationship = generateRelationship(accnt, uptUser);
                      upsertRelationshipRec(relationship);
                    } 
                  }   
                  //School Data
                  System.debug('The flag for Register school is :::'+registerSchool);
                  if(registerSchool){
                  executeCommonStudentSchoolCreation(accnt);
                  }
                  executeCommonAddressBookCreation(accnt);
      }
      public void executeCommonStudentSchoolCreation(Account account){
        //Student School      
        if(String.isNotBlank(studentDetails.accountabilityId)){
            Student_School__c studentSchool = generateStudentSchool(account);
            system.debug('****Upserting StudentSchool Data****');
            upsertstudentSchoolRec(studentSchool);
        }
      }  
      private void executeCommonAddressBookCreation(Account account){
           
          //Generate Contact Address and Address Book (Shipping and Billing)
          String ADDRESSTYPEBILLING='Billing';
          String ADDRESSTYPESHIPPING ='Shipping';
          E_AddressBook__c billingAddressBook = generateCcAddressBook(account, ADDRESSTYPEBILLING);
          E_AddressBook__c shippingAddressBook = generateCcAddressBook(account, ADDRESSTYPESHIPPING);
          E_ContactAddr__c billingContactAddr = generateCcContactAddress(ADDRESSTYPEBILLING, account.Id);
          E_ContactAddr__c shippingContactAddr = generateCcContactAddress(ADDRESSTYPESHIPPING, account.Id); 
                 

          if(String.isNotBlank(billingContactAddr.AddressFirstline__c) && String.isNotBlank(billingContactAddr.DaytimePhone__c) && String.isNotBlank(billingContactAddr.Country__c)){
                
              system.debug('****Upserting Billing Data****');
              saveAddressBookAndContact(account, billingAddressBook, billingContactAddr); //Save/Update AddressBook and Contacts
          }

          if(String.isNotBlank(shippingContactAddr.DaytimePhone__c) && String.isNotBlank(shippingContactAddr.Country__c)){
               
              system.debug('****Upserting Shipping Data****');
              saveAddressBookAndContact(account, shippingAddressBook, shippingContactAddr); //Save/Update AddressBook and Contacts
          }
      }
      public void saveAddressBookAndContact(Account upsertAccount, E_AddressBook__c addressBook, E_ContactAddr__c contactAddr) {
          System.debug('Account value in Line 433::'+upsertAccount);
           System.debug('E_AddressBook__c  value in Line 433::'+addressBook);
            System.debug('E_ContactAddr__c value in Line 433::'+contactAddr);
            
          Boolean isAddressBookUpdate = false;
          Boolean isContactAddressUpdate = false;
        
          //Check if Address Book exists
          E_AddressBook__c resultAddressBook = getAddressBook(addressBook);
          if(resultAddressBook!=null){
              isAddressBookUpdate = true; //AddressBook exists
              if(resultAddressBook.E_ContactAddress__c!=null){//Contact associated to this adressBook
                  isContactAddressUpdate = true;
                  E_ContactAddr__c resultContactAddr = new E_ContactAddr__c();
                  resultContactAddr.Id = resultAddressBook.E_ContactAddress__c;
                  updateCcContactAddress(contactAddr, resultContactAddr); //Update ContactAddress on oject retrieved data    
                
                  //Invoke Upsert for Contact
                  upsertContactAddressRec(resultContactAddr, isContactAddressUpdate);//Update ContactAddress
                  //resultAddressBook.E_ContactAddress__r.Id = resultContactAddr.Id;//Associate ContactAddress with AddressBook
              }else{
                  //Invoke Upsert for Contact
                  //upsertContactAddressRec(contactAddr, isContactAddressUpdate);//Save ContactAddress
                  //resultAddressBook.E_ContactAddress__c = contactAddr.Id;//Associate ContactAddress with AddressBook
              }
              //Invoke Upsert for AddressBook
              upsertAddressBookRec(resultAddressBook, isAddressBookUpdate);//Update AddressBook
          }else{
              //Check if Contact exists
              E_ContactAddr__c contactAddress = getContactAddressId(contactAddr);
              if(contactAddress!=null){
                  isContactAddressUpdate = true;//Contact exists  
                  //contactAddr.ContactAddrId__c = contactAddress.ContactAddrId__c;
                  //contactAddr.Id = contactAddress.Id;                
              }
              //Invoke Upsert for Contact
              upsertContactAddressRec(contactAddr, isContactAddressUpdate);//Save ContactAddress
           
              addressBook.E_ContactAddress__c = contactAddr.Id ;//Associate ContactAddress with AddressBook
              //Invoke Upsert for AddressBook
              upsertAddressBookRec(addressBook, isAddressBookUpdate);//Save AddressBook
          }                      
      }
    
      public Account fetchAccount(Account account,Boolean isAccountSourceWeb){
          
          system.debug('****Inside fetch details from Account Object****'+account);
          Boolean conditionAdded = False;
          Boolean kapConAdd = False;
          Account result = null;
          String query = null;
          
          if(account.Student_ID__c != null || account.Kaptest_User_Id__c != null){
              query = 'Select Kaptest_User_Id__c, Student_ID__c, Id FROM Account WHERE (';
          }
          if(account.Student_ID__c != null){
              query = query + 'Student_ID__c = '+account.Student_ID__c+' ';
              conditionAdded = True;
          }
          if(account.Kaptest_User_Id__c !=null){
              if(conditionAdded){
                  query = query + 'OR ';
              }
              query = query +  'Kaptest_User_Id__c = \''+account.Kaptest_User_Id__c+'\''; 
              kapConAdd = True;          
          }
          if(conditionAdded || kapConAdd){
              query = query + ')';
              if(isAccountSourceWeb){
                  query = query + 'AND AccountSource= \'Web\'';
              }
          } 
          system.debug('****Account Query****'+query);
          if(query!=null){
              SObject[] records = Database.query(query);
              if(!records.isEmpty()){
                  for(SObject obj : records){
                      result = (Account)obj;
                      break;
                  }
              }
          }
          return result;
      }
      public String getPersonContactId(Account account){
          Account accnt;
          system.debug('****Inside fetch person contact Id****');
          system.debug(account.id);
          String personContactId = null;
          List<Account> acc = [SELECT PersonContactId FROM Account WHERE id =:account.Id Limit 1];
          if(acc.size()>0){
              accnt=acc.get(0);
              personContactId = accnt.personContactId;    
          }         
          return personContactId;
      }
      
      public User verifyUserExistsByPersonContactId(String personContactId){
        User usrres;
        system.debug('****Verifying if personContactId Exists on SFDC****'); 
        List<User> usrresult = [SELECT UserName, Id From User Where contactId =:personContactId Limit 1];
        system.debug(' personContactId Exists on SFDC at Line 509'+personContactId); 
          if(usrresult.size()>0){
          usrres=usrresult.get(0);
          }      
          System.debug('verify my user after at line 514::'+usrres);   
        return usrres;
      }
      public E_ContactAddr__c getContactAddressById(String cAddId) {
          
          system.debug('****Retrieve E_ContactAddr__c from SFDC based on Id****'); 
          E_ContactAddr__c result = [Select Name, Id,ContactAddrId__c from E_ContactAddr__c where Id =:cAddId];
            
          return result;
      }
      
      public User generateUser(Account account, User myUser, Boolean isInsert,String personContactId) {
      
        
        system.debug('****Populating User with details****'+account);
         system.debug('****Populating User with details field 2****'+myuser);
         system.debug('****Populating User with details field 3****'+isInsert);
           
        User user = new User();
        
        System.debug('personcontactId Value is'+account.PersonContactId);
        if(isInsert){
         user.LastName = account.LastName;
        user.FirstName = account.FirstName;
        user.Alias = (account.PersonEmail).left(8);
        user.Email = account.PersonEmail;
        user.Username = account.PersonEmail;
        user.EmailEncodingKey = studentDetails.defaultEncoding;
        user.LanguageLocaleKey = studentDetails.defaultLocale;
        user.LocaleSidKey = studentDetails.defaultLocale;
        user.TimeZoneSidKey = studentDetails.defaultTimeZone;
        user.ProfileId = studentDetails.defaultProfileId;
        user.FederationIdentifier = user.Username;
        user.Phone = studentDetails.billingPhone;    
        user.IsActive = True;   
        user.IsPortalSelfRegistered = True;           
        user.ContactId = PersonContactId;
        System.debug('User values assigned'+user);
        }else{  
        user.LastName = account.LastName;
        user.FirstName = account.FirstName;
       // user.Alias = (account.PersonEmail).left(8);
        user.Email = account.PersonEmail;
        user.TimeZoneSidKey = studentDetails.defaultTimeZone;
        user.Phone = studentDetails.billingPhone; 
        user.FederationIdentifier = account.PersonEmail;
        user.Id = myUser.Id;//User is Not null when isInsert is false            
        }
                                
        return user;
    }
    public Relationship__c generateRelationship(Account account, User user) {
        Relationship__c relationship = new Relationship__c();
        
        relationship.Account__c = account.Id;
        relationship.Parent_First_Name__c = (studentDetails.parentFirstName).left(25);
        relationship.Parent_Last_Name__c = (studentDetails.parentLastName).left(40);
        relationship.Email_1__c = (studentDetails.parentEmail).left(80);
        relationship.Email_2__c = (studentDetails.email).left(80);
        relationship.Phone_1__c = user.Phone;
        relationship.Relation_Type__c = 'Parent';
        relationship.Relationship_Id__c = (studentDetails.relationshipId).left(80);
        
        return relationship;
    }
      
       }